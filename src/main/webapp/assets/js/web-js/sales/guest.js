var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
function newGuest() {
	/**
	 * 证件类型注册时间,当选择类型是身份证的时候，验证身份证的长度
	 */
	$("#guestId").val("");
	$("#guestName").val("");
	$("#guestSl").val("");
	$("#guestCertificateNum").val("");
	$("#guestAge").val("");
	$("#guestMobile").val("");
	$("#guestNativePlace").val("");
	$("#guestCareer").val("");
	$("#guestTypeSl").val("");
	$("#guestMark").val("");
	layer.open({
		type : 1,
		title : '添加客人信息',
		shadeClose : true,
		shade : 0.5,
        area : ['600px','430px'],
		content : $('#addGuest')
	});
}
function toEditGuest(id) {
	$.getJSON("../guest/editGuest.do?id=" + id, function(data) {
		$("#guestId").val(data.id);
		$("#guestName1").val(data.name);
		$("#guestSl1").val(data.certificateTypeId);
		$("input[id='guestGender1'][value=" + data.gender + "]").attr(
				"checked", true);
		$("#guestCertificateNum1").val(data.certificateNum);
		$("#guestAge1").val(data.age);
		$("#guestMobile1").val(data.mobile);
		$("#guestNativePlace1").val(data.nativePlace);
		$("input[id='guestIsSingleRoom1'][value=" + data.isSingleRoom + "]")
				.attr("checked", true);
		$("#guestCareer1").val(data.career);
		$("input[id='guestIsLeader1'][value=" + data.isLeader + "]").attr(
				"checked", true);
		$("#guestTypeSl1").val(data.type);
		$("#guestMark1").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改客人信息',
		shadeClose : true,
		shade : 0.5,
		area : ['600px','430px'],
		content : $('#editGuest')
	});
}
function deleteGuestById(obj,id, orderId) {
	$.confirm("确认删除吗？", function() {
		$.getJSON("../guest/deleteGuestById.do?id=" + id + "&orderId="
				+ orderId, function(data) {
			if (data.success) {
				$(obj).closest("tr").remove();
				$.info('删除成功！');
			}
		});
	}, function() {
		$.info('取消删除');
	});
}
$(function() {
	$("#addGuestForm").validate(
			{
				rules : {
					'name' : {
						required : true
					},
					'certificateNum' : {
						required : true
					}
				},
				errorPlacement : function(error, element) {
					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) {
						error.appendTo(element.parent());
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					var options = {
						url : "../guest/saveGuest.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功');
								window.location = window.location;
							} else {
								$.error(data.msg);
								
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					/**
					 * 验证客人是否已录入
					 */
					$.getJSON("../guest/matchNum.htm?orderId=" + $("#orderId").val()
							+ "&count=" + 1, function(data) {
						if (data.success) {
							var cerNums = "" ;
							var vv = $(".certificateNum") ;
							vv.each(function (){
								cerNums = cerNums + $(this).text() ;
							}) ;
							var v1 = cerNums.indexOf($("#guestCertificateNum").val()) ;
							if(v1!=-1){
								$.warn("该客人数据已录入！");
								return false ;
							}else{
								$(form).ajaxSubmit(options);
							}
						}
					});
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});

	/**
	 * 修改接送信息弹出层form
	 */
	$("#editGuestForm").validate(
			{
				rules : {
					'name' : {
						required : true
					},
					'certificateNum' : {
						required : true
					}
				},
				errorPlacement : function(error, element) {
					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) {
						error.appendTo(element.parent());
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					var options = {
						url : "../guest/updateGuest.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功');
								window.location = window.location;
							} else {
								$.error(data.msg);
								
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	
	/**
	 * 通过身份证号自动给性别，籍贯，年龄赋值
	 */
	$("input[id='guestCertificateNum']").mouseout(
		function(e) {
			var options=$("#guestSl option:selected");  //获取选中的项
			if(options.text()=='身份证'){
				var guestCertificateNum = $("#guestCertificateNum").val();
				if(guestCertificateNum!=''){
					guestCertificateNum=guestCertificateNum.toUpperCase();
					if (reg.test(guestCertificateNum) === true) {
						var card = new Card(guestCertificateNum);
						card.init(function(data){
							$("#guestAge").val(data.age);
							if(data.age<12){
								$("#guestTypeSl").val("2");
							}
							$("#guestNativePlace").val(data.addr);
							if(data.sex=='男'){
								$("input[id='guestGender'][value=1]").attr("checked", "checked");
							}else{
								$("input[id='guestGender'][value=0]").attr("checked", "checked");
							}
						});
					}else{
						$.warn("请输入正确长度的身份证号码！");
					}
				}
			}
		}
	);
	
	/**
	 * 通过身份证号自动给性别，籍贯，年龄赋值
	 */
	$("input[id='guestCertificateNum1']").mouseout(
		function(e) {
			var options=$("#guestSl1 option:selected");  //获取选中的项
			if(options.text()=='身份证'){
				var guestCertificateNum = $("#guestCertificateNum1").val();
				if(guestCertificateNum!=''){
					guestCertificateNum=guestCertificateNum.toUpperCase();
					if (reg.test(guestCertificateNum) === true) {
						var card = new Card(guestCertificateNum);
						card.init(function(data){
							$("#guestAge1").val(data.age);
							$("#guestNativePlace1").val(data.addr);
							if(data.age <=12){
								$("#guestTypeSl").val("2");
							}
							if(data.sex=='男'){
								$("input[id='guestGender1'][value=1]").attr("checked", "checked");
							}else{
								$("input[id='guestGender1'][value=0]").attr("checked", "checked");
							}
						});
					}else{
						$.warn("请输入正确长度的身份证号码！");
					}
				}
			}
		}
	);
	
	$("input[id='guideIsGuide1']").change(
			function(){		
				var obj = $(this) ;
				if($(this).val()==1){
					$.getJSON("../guest/matchGuide.htm?orderId=" + $("#orderId").val(), function(data) {
						if(!data.success){
							$.warn(data.msg) ;
							obj.attr("checked",false) ;
							obj.next().attr("checked","checked") ;
						}
					}) ;
				}
			}
		);
});

$(document).ready(function() {
	/**
	 * 批量录入的隐藏和显示
	 */
	$(".p").toggle(function() {
		$("#bi").show();
	}, function() {
		$("#bi").hide();
	});
});

function toSubmit(strName) {
	var html = $("#guest_template").html();
	// 订单id
	var orderId = $("#orderId").val();
	// 客人类型
	var type = "1";
	var count = 0 ;
	var str = $("#batchInputText").val();
	if (str == "" || str == null) {
		$.warn("输入信息为空");
		return false;
	}
	var strs = new Array();
	strs = str.split("\n");
	for(var i=0;i<strs.length;i++){
		if(strs[i]!=""){
			count+=1 ;
		}
	}
	/**
	 * 先检查页面批量录入数据身份证是否有重复的
	 */
	var cerNums = "" ; //数据库已经录入的数据
	jQuery.ajax({
		url : "../guest/getCertificateNums.htm",
		type : "post",
		async : false,
		data : {
			"orderId" : orderId
		},
		dataType : "json",
		success : function(data) {
			if (data.sucess) {
				cerNums = data.certificateNums ;
			} else {
				$.warn(data.msg);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.error(textStatus);
			window.location = window.location;
		}
	});
	var cerNum = "" ; //统计录入数据是否重复
	for (var i = 0; i < strs.length; i++) {
		var infos = new Array();
		var va = strs[i].toString().replace("\n", "").replace(/，/g,
				",").replace(/。/g, ",");
		infos = va.split(",");
		var v = cerNum.indexOf(infos[1]);
		if(v===-1){
			cerNum+=infos[1] ;
		}else{
			$.warn("第" + eval(i + 1) + "行客人数据重复！");
			return false ;
		}
		var v1 = cerNums.indexOf(infos[1]) ;
		if(v1!=-1){
			$.warn("第" + eval(i + 1) + "行客人数据重复！");
			return false ;
		}
	}
	// 比对当前输入人数是否定制团人数范围之内
	$.getJSON("../guest/matchNum.htm?orderId=" + orderId + "&count="
			+ count, function(data) {
		if(!data.success){
			$.warn(data.msg);
		}else{
			for (var i = 0; i < strs.length; i++) {
				if (strs[i] != "") {
					var infos = new Array();
					var va = strs[i].toString().replace("\n", "").replace(/，/g,
							",").replace(/。/g, ",");
					infos = va.split(",");
					
					if (infos.length != 3 && infos.length != 2) {
						$.warn("第" + eval(i + 1) + "行输入格式有误！");
						return false ;
					}
					
				   /* if(infos[2].length==0){
			            $.warn('请输入手机号码！');
			            return false;
			        }  */
			        if(infos.length == 3 && infos[2].length!=11){
			        	$.warn('请输入有效的手机号码！');
			            return false;
			        }
			        
					if(reg.test(infos[1]) === true) {
						infos[1]=infos[1].toUpperCase();
						var card = new Card(infos[1]);
						card.init(function(data){
							if (data.age <=12) {
								type = "2";
							}else{
								type="1" ;					
							}
							if(infos.length==2){
//								arr.push(infos[0] + "," + data.sex + ","
//										+ data.age + "," + data.addr + ","
//										+ infos[1] + "," +""+ "," + orderId
//										+ "," + type);
								
								
								var count = $("#"+strName+"Data").children('tr').length;
								html = template('guest_template', {index : count});
								$("#"+strName+"Data").append(html);
								$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
								if($("input[name='groupOrder.receiveMode']").length>0  && $("input[name='groupOrder.receiveMode']").val==''){
									$("input[name='groupOrder.receiveMode']").val(infos[0]);
								}
								if(data.sex=='男'){
									$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
								}else{
									$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
								}
								$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
								$("select[name='groupOrderGuestList["+count+"].type").val(type);
								$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.addr);
								$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
								
								
							}
							if(infos.length==3){
//								arr.push(infos[0] + "," + data.sex + ","
//										+ data.age + "," + data.addr + ","
//										+ infos[1] + "," + infos[2] + "," + orderId
//										+ "," + type);
								
								var count = $("#"+strName+"Data").children('tr').length;
								html = template('guest_template', {index : count});
								$("#"+strName+"Data").append(html);
								$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
								if(data.sex=='男'){
									$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
								}else{
									$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
								}
								$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
								$("select[name='groupOrderGuestList["+count+"].type").val(type);
								$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.addr);
								$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
								$("input[name='groupOrderGuestList["+count+"].mobile").val(infos[2]);
								
							}
							
						}) ;
					}else{
						if(infos.length==2){
//							arr.push(infos[0] + "," + infos[1] + "," + ""
//							+ "," + orderId + "," + type);
							
							var count = $("#"+strName+"Data").children('tr').length;
							html = template('guest_template', {index : count});
							$("#"+strName+"Data").append(html);
							$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
							
						}
						if(infos.length==3){
//							arr.push(infos[0] + "," + infos[1] + "," + infos[2]
//							+ "," + orderId + "," + type);
							var count = $("#"+strName+"Data").children('tr').length;
							html = template('guest_template', {index : count});
							$("#"+strName+"Data").append(html);
							$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
							$("input[name='groupOrderGuestList["+count+"].mobile").val(infos[2]);
						}
					}
				}
			}


		}
	});
	$("#bi").hide();
}

/**
 * 显示客人的历史参团记录
 * @param guestCertificateNum
 */
function showHistory(guestCertificateNum,orderId){
	layer.open({
		type : 2,
		title : '参团历史信息',
		shadeClose : true,
		shade : 0.5,
        area : ['800px','500px'],
        content : "../guest/getGuestOrderInfo.htm?guestCertificateNum="+guestCertificateNum+"&orderId="+orderId
	});
}

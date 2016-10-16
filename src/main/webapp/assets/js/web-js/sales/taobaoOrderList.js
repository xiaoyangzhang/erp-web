
$(function(){
	loadRoute();
	queryList();
	$("#provinceCode").change(
			function() {
				if ($("#provinceCode").val() != -1) {
					
					$.getJSON("../basic/getRegion.do?id="
							+ $("#provinceCode").val(), function(data) {
						data = eval(data);
						var s = "<option value='-1'>请选择市</option>";
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
									+ "</option>";
						});
						$("#cityCode").html(s);
						$("#provinceName").val($("#provinceCode option:selected").text());
						
					});
				}else {
					$("#cityCode").html("<option value='-1'>请选择市</option>");
					$("#provinceName").val('');
				}

	});
	//接送
	$(".pp").toggle(function() {
		$("#bbb").show();
	}, function() {
		$("#bbb").hide();
	});
	//客人
	$(".p").toggle(function() {
		$("#bi").show();
	}, function() {
		$("#bi").hide();
	});
	
	

	
	$("#cityCode").change(function(){
		if($("#cityCode").val()!=-1){
			$("#cityName").val($("#cityCode option:selected").text());
		}else{
			$("#cityName").val('');
		}
	});
	

	
	
	
	$("#SpecialGroupOrderForm").validate({
		rules : {
			'groupOrder.saleOperatorName' : {
				required : true
			},
			'groupOrder.operatorName' : {
				required : true
			},
			'groupOrder.receiveMode' : {
				required : true
			},
			'groupOrder.supplierName' : {
				required : true
			},
			'groupOrder.numAdult' : {
				required : true,
				digits : true
			},
			'groupOrder.numChild' : {
				required : true,
				digits : true
			},
			'groupOrder.numGuide' : {
				required : true,
				digits : true
			},
			'groupOrder.departureDate' : {
				required : true
			},
			'groupOrder.productBrandName' : {
				required : true
			},
			'groupOrder.productName' : {
				required : true
			},
			'hotelInfo.countSingleRoom' : {
				required : true,
				digits : true
			},
			'hotelInfo.countDoubleRoom' : {
				required : true,
				digits : true
			},
			'hotelInfo.countTripleRoom' : {
				required : true,
				digits : true
			},
			'hotelInfo.peiFang' : {
				required : true,
				digits : true
			},
			'hotelInfo.extraBed' : {
				required : true,
				digits : true
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
			
			if($("#supplierId").val()==''){
				$.warn("不存在的组团社");
				return;
			}
			//checkProvince();
			
			
			  var GroupMode = $("#GroupMode").val();
		
		      if($("#GroupMode").val()==-1){
		    	  $.warn('请选择业务类别');
		    	  return ;
		      }
			var options = {
				url : "saveSpecialGroup.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							refreshWindow('编辑订单','toEditTaobaoOrder.htm?id='+data.groupId)
						});
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
			$("#SpecialGroupOrderForm").focus();
			return false;
		}
	});
	
	
	
	
});

function insertGroupOnly(tid){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择散客团',
		closeBtn : false,
		area : [ '900px', '500px' ],
		shadeClose : true,
		content : '../taobao/taobaoOrderList_table.htm?tid='+tid,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			
			var code = win.getCode();
			$.post("../specialGroup/insertGroup.do", { id: tid, code: code }, function(data){
				  if(data.success){
					  $.success('操作成功',function(){
							searchBtn();
						});
				  }else{
					  $.error(data.msg);
				  }
			},"json");
			
			layer.close(index);
	       
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 更改团状态
 * state==0时代表未确认状态，需要查询该订单下是否维护了成本价格
 * @param state 
 */
var stateIndex;
function changeGroupState(groupId,state){
	if(state==0){
		$.getJSON("../budgetItem/getTotalBudgetByOrderId.do?id=" + groupId ,function(data) {
			if (data.success) {
				$("#modalgroupId").val(groupId);
				$("#modalGroupState").val(state);
				optionState(state);
				layer.open({
					type : 1,
					title : '修改状态',
					shadeClose : true,
					shade : 0.5,
			        area : ['350px','210px'],
					content : $('#stateModal')
				});
			}else{
				$.warn(data.msg);
			}
		});
	}else{
		$("#modalgroupId").val(groupId);
		$("#modalGroupState").val(state);
		optionState(state);
		stateIndex=layer.open({
			type : 1,
			title : '修改状态',
			shadeClose : true,
			shade : 0.5,
	        area : ['350px','210px'],
			content : $('#stateModal')
		});
	}
};

function optionState(state){
	var sltState = document.getElementById("modalGroupState");
	
	while (sltState.firstChild) {
		sltState.removeChild(sltState.firstChild); 
	}
	if(state==0){
		var option1 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);	
	}else if(state==1){
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);
	}else if(state==2){
		var option1 = new Option("未确认", "0");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option2);
	}
}

/**
 * 跳到信息编辑页面
 */
function editOrderGroupInfo(){
	var groupId = $("#modalgroupId").val();
	var groupState = $("#modalGroupState").val();
	$.getJSON("../groupOrder/editOrderGroupInfo.do?id=" + groupId +"&groupState="+groupState, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				layer.close(stateIndex);
				searchBtn();
				
			});
			
		}
	});
}

function insertGroupByList(){
	
	var chk_value = [];
	$("input[name='chkGroupOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行加入团操作');
		return;
	}
	
	$.get("../specialGroup/beforeInsertGroup.htm?ids="+chk_value, function(data){
		  if(data.success){

					var win=0;
					layer.open({ 
						type : 2,
						title : '选择散客团',
						closeBtn : false,
						area : [ '900px', '500px' ],
						shadeClose : true,
						content : '../specialGroup/getSpecialGroup.do?tid='+chk_value[0],
						btn: ['确定', '取消'],
						success:function(layero, index){
							win = window[layero.find('iframe')[0]['name']];
						},
						yes: function(index){
							var code = win.getCode();
							$.post("../specialGroup/insertGroupMany.do", { ids: chk_value.toString(), code: code }, function(data){
								  if(data.success){
									  $.success('操作成功',function(){
										  searchBtn();
										  layer.close(index); 
										  	
										});
								  }else{
									  $.error(data.msg);
								  }
							},"json");
							
							
					       
					    },cancel: function(index){
					    	layer.close(index);
					    }
					});

		  }else{
			  $.error(data.msg);
		  }
	},"json");
	
}


function toMergeGroup() {

	var chk_value = [];
	$("input[name='chkGroupOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行并团操作');
		return;
	}

	$.getJSON("../specialGroup/judgeMergeGroup.htm?ids=" + chk_value, function(data) {
		if (data.success) {
			newWindow('一地散并团','specialGroup/toMergeGroup.htm?ids=' + chk_value);
		} else {
			$.error(data.msg);
		}
	});

}

function loadRoute(){
	var orderId=$("input[name='groupOrder.id']");
	
	if(orderId.length>0 && orderId.val() !=''){
		$.ajax({
            type: "post",
            cache: false,
            url : "../groupRoute/getDataByOrderId.do",
            data : {
                orderId :orderId.val()
            },
            dataType: 'json',
            async: false,
            success: function (data) {
            	$(".day_content").html('');
                new SalesRoute(function(){
                    var days = data.groupRouteDayVOList;
                    for(var i = 1; i <= days.length; i++){
                        var dayVo = days[i - 1];
                        this.dayAdd(dayVo.groupRoute);
                        var trafficList = dayVo.groupRouteTrafficList;
                        for(var j = 0; j < trafficList.length; j++){
                            this.trafficAdd(i, j, trafficList[j]);
                        }
                        var optionsSupplierList = dayVo.groupRouteOptionsSupplierList;
                        for(var k = 0; k < optionsSupplierList.length; k++){
                            this.supplierAdd(i, k, optionsSupplierList[k])
                        }
                        var imgList = dayVo.groupRouteAttachmentList;
                        for(var l = 0; l < imgList.length; l++){
                            imgList[l].thumb = img200Url + imgList[l].path;
                            this.imgAdd(i, l, imgList[l])
                        }
                    }
                });
            }
        });
	}
}


function recCertifNum(count){
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	var typeName = $("select[name='groupOrderGuestList["+count+"].certificateTypeId'] option:selected").text();
	if(typeName=='身份证'){
		var guestCertificateNum = $("input[name='groupOrderGuestList["+count+"].certificateNum']").val();
		if(guestCertificateNum!=''){
			if (reg.test(guestCertificateNum) === true) {
				var data = $.parseIDCard(guestCertificateNum);
					if(data.tip==''){
					
						$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
						if(data.age<=12){
							$("select[name='groupOrderGuestList["+count+"].type").val("2");
						}else{
							$("select[name='groupOrderGuestList["+count+"].type").val("1");
						}
						$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.birthPlace);
						if(data.gender=='男'){
							$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
						}else{
							$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
						}
						$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
					}else{
						$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
						$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
					}
			}else{
				$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
				$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
			}
		}
	}else{
		$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
	}

}
function countTotalPrice(count) {
	var unitPrice = $("input[name='groupOrderPriceList["+count+"].unitPrice']").val();
	var numTimes = $("input[name='groupOrderPriceList["+count+"].numTimes']").val();
	var numPerson = $("input[name='groupOrderPriceList["+count+"].numPerson']").val();
	var total = (unitPrice == '' ? '1' : unitPrice)
			* (numTimes == '' ? '1' : numTimes)
			* (numPerson == '' ? '1' : numPerson);
	$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);
	var count = $("#newPriceData").children('tr').length;
	var totalPrice= 0;
	/*for(var i=0;i<count;i++){
		totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
	}*/
	$("#newPriceData").find("input[name*='.totalPrice']").each(function(){
		totalPrice +=Number($(this).val());
	});
	$("#totalPrice").html(totalPrice);
	
}


function countTotalCost(count){
	var unitPrice = $("input[name='groupOrderCostList["+count+"].unitPrice']").val();
	var numTimes = $("input[name='groupOrderCostList["+count+"].numTimes']").val();
	var numPerson = $("input[name='groupOrderCostList["+count+"].numPerson']").val();
	var total = (unitPrice == '' ? '1' : unitPrice)
			* (numTimes == '' ? '1' : numTimes)
			* (numPerson == '' ? '1' : numPerson);
	$("input[name='groupOrderCostList["+count+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);
	var count = $("#newCostData").children('tr').length;
	var totalCost= 0;
	for(var i=0;i<count;i++){
		totalCost=Number(totalCost)+Number($("input[name='groupOrderCostList["+i+"].totalPrice']").val());
	}
	$("#totalCost").html(totalCost);
}


function addItemName(obj){
	$(obj).prev().val($(obj).find("option:selected").text());
}
/**
 * 新增订单
 */
function  addNewSpecialGroup(){
	newWindow('新增一地散订单','specialGroup/toAddSpecialGroup.htm');
}
/**
 * 查看团信息
 * @param id
 */
function lookGroup(id){
	newWindow('查看团信息','fitGroup/toFitGroupInfo.htm?groupId='+id+'&operType=0')
}

/**
 * 编辑订单
 * @param id
 */
function editGroup(id){
	newWindow('编辑订单','taobao/toEditTaobaoOrder.htm?id='+id);
}
/**
 *  删除订单
 * @param id
 */
function delGroup(id){
	$.confirm("确认删除吗？", function() {
		$.getJSON("../groupOrder/delGroupOrder.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					searchBtn();
				});
			}else {
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});
	
}
/**
 * 分页查询
 * @param page 
 * @param pageSize
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#orderPage").val(page);
	$("#orderPageSize").val(pageSize);
	var options = {
		/*url:"getSpecialGroupData.do",*/
		url:"taobaoOrderList_table.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.warn("服务忙，请稍后再试",{icon:1,time:1000});
    	}
    };
    $("#specialGroupListForm").ajaxSubmit(options);	
}

function searchBtn() {
	var pageSize=$("#orderPageSize").val();
	queryList(1,pageSize);
}
function toSaveSeatInCoach(strr) {
	var html = $("#trans_template").html();
	
	// 订单id
	var orderId = $("#orderId").val();
	var str = $("#bit").val();
	if (str == "" || str == null) {
		$.warn("输入信息为空");
		return false;
	}
	
	var strs = new Array();
	strs = str.split("\n");
	// 比对当前输入人数是否定制团人数范围之内
	for (var i = 0; i < strs.length; i++) {
		if (strs[i] != "") {
			var infos = new Array();
			//console.log(infos);
			var va = strs[i].toString().replace("\n", "").replace(/，/g, ",").replace(/。/g, ",").replace(/，/g, ",").replace(/；/g, ",").replace(/;/g, ",");
			infos = va.split(",");
			if (infos.length != 5&&infos.length!=3) {
				$.warn("第" + eval(i + 1) + "行输入格式有误！");
				return false ;
			}
			if(infos.length==5){
				var count = $("#"+strr+"Data").children('tr').length;
				html = template('trans_template', {index : count});
				$("#"+strr+"Data").append(html);
				$("input[name='groupOrderTransportList["+count+"].departureDate']").val(infos[0]);
				$("input[name='groupOrderTransportList["+count+"].departureTime']").val(infos[1]);
				//$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
				$("input[name='groupOrderTransportList["+count+"].departureCity']").val(infos[3]);
				$("input[name='groupOrderTransportList["+count+"].arrivalCity']").val(infos[4]);
			}
			if(infos.length==3){
				var count = $("#"+strr+"Data").children('tr').length;
				html = template('trans_template', {index : count});
				$("#"+strr+"Data").append(html);
				$("input[name='groupOrderTransportList["+count+"].departureDate']").val(infos[0]);
				$("input[name='groupOrderTransportList["+count+"].departureTime']").val(infos[1]);
				//$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
			}
			
		}
	}
	$("#bbb").hide();
}
function toSubmit(strName) {
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	var html = $("#guest_template").html();
	var count = $("#"+strName+"Data").children('tr').length; // 订单id
	var type = "1"; // 客人类型
	var sum = 0 ;
	var str = $("#batchInputText").val();

	if (str == "" || str == null) {
		$.warn("输入信息为空");
		return false;
	}
	var strs = new Array();
	strs = str.split("\n");
	for(var i=0;i<strs.length;i++){
		if(strs[i]!=""){
			sum+=1 ;
		}
	}

	 //统计录入数据是否重复
	var cerNum = "" ;
	for (var i = 0; i < strs.length; i++) {
		var va = strs[i].toString().replace("\n", "").replace(/，/g, ",").replace(/。/g, ",").replace(/，/g, ",").replace(/；/g, ",").replace(/;/g, ",");
		var infos = va.split(","); //0姓名，１证件号，２手机
		if (infos[1] != ""){
				var v = cerNum.indexOf(infos[1]);
				if(v==-1){
					cerNum+=infos[1] ;
				}else{
					$.warn("第" + eval(i + 1) + "行客人数据重复！");
					return false ;
				}
		}
	}
	// 比对当前输入人数是否定制团人数范围之内
	var numAdult =$("input[name='groupOrder.numAdult']").val();
	var numChild =$("input[name='groupOrder.numChild']").val();
	var numGuide =$("input[name='groupOrder.numGuide']").val();
	if(numAdult=='' ||numChild=='' || numGuide==''){
		$.warn("请先填写订单接纳人数！");
		return ;
	}
	if(isNaN(numAdult) || isNaN(numChild) || isNaN(numGuide)){
		$.warn("请正确填写订单容纳人数！");
		return ;
	}
	if((Number(count)+Number(sum))>(Number(numAdult)+Number(numChild)+Number(numGuide))){
		$.warn("超过该订单最大容纳人数！");
		return ;
	}
	
			for (var i = 0; i < strs.length; i++) {
				if (strs[i] != "") {
					var infos = new Array();
					var va = strs[i].toString().replace("\n", "").replace(/，/g, ",").replace(/。/g, ",").replace(/，/g, ",").replace(/；/g, ",").replace(/;/g, ",");
					infos = va.split(",");
					
					if (infos.length != 3 && infos.length != 2) {
						$.warn("第" + eval(i + 1) + "行输入格式有误！");
						return false ;
					}

			        if(infos.length == 3 && infos[2].trim()!=""){
			        	if (infos[2].trim().length!=11){
			        		$.warn('请输入有效的手机号码！');
			        		return false;
			        	}
			        }
			        
			        if($("input[name='groupOrder.receiveMode']").val()==''){
						$("input[name='groupOrder.receiveMode']").val(infos[0]);
					}
			     
			        
			        infos[1]= infos[1].trim();
					if(reg.test(infos[1]) === true) {
						infos[1]=infos[1].toUpperCase();
						var data =  $.parseIDCard(infos[1]);
						
							if (data.age <=12) {
								type = "2";
							}else{
								type="1" ;					
							}
							if(infos.length==2){
								
								
								var count = $("#"+strName+"Data").children('tr').length;
								html = template('guest_template', {index : count});
								$("#"+strName+"Data").append(html);
								$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
								if(data.gender=='男'){
									$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
								}else{
									$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
								}
								$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
								$("select[name='groupOrderGuestList["+count+"].type").val(type);
								$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.birthPlace);
								$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
								$("input[name='groupOrderGuestList["+count+"].age']").change(
										function(e) {
									if($(this).val().trim()<=12){
										$("select[name='groupOrderGuestList["+count+"].type").val("2");
									}else{
										$("select[name='groupOrderGuestList["+count+"].type").val("1");
									}
								});
								
							}
							if(infos.length==3){
								var count = $("#"+strName+"Data").children('tr').length;
								html = template('guest_template', {index : count});
								$("#"+strName+"Data").append(html);
								$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
								if(data.gender=='男'){
									$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
								}else{
									$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
								}
								$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
								$("select[name='groupOrderGuestList["+count+"].type").val(type);
								$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.birthPlace);
								$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
								$("input[name='groupOrderGuestList["+count+"].mobile").val(infos[2]);
								$("input[name='groupOrderGuestList["+count+"].age']").change(
										function(e) {
									if($(this).val().trim()<=12){
										$("select[name='groupOrderGuestList["+count+"].type").val("2");
									}else{
										$("select[name='groupOrderGuestList["+count+"].type").val("1");
									}
								});
							}
					}else{
						if(infos.length==2){
							var count = $("#"+strName+"Data").children('tr').length;
							html = template('guest_template', {index : count});
							$("#"+strName+"Data").append(html);
							$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号码不是身份证号</span>");
							$("input[name='groupOrderGuestList["+count+"].age']").change(
									function(e) {
								if($(this).val().trim()<=12){
									$("select[name='groupOrderGuestList["+count+"].type").val("2");
								}else{
									$("select[name='groupOrderGuestList["+count+"].type").val("1");
								}
							});
						}
						if(infos.length==3){
							var count = $("#"+strName+"Data").children('tr').length;
							html = template('guest_template', {index : count});
							$("#"+strName+"Data").append(html);
							$("input[name='groupOrderGuestList["+count+"].name").val(infos[0]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").val(infos[1]);
							$("input[name='groupOrderGuestList["+count+"].mobile").val(infos[2]);
							$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号码不是身份证号</span>");
							$("input[name='groupOrderGuestList["+count+"].age']").change(
									function(e) {
								if($(this).val().trim()<=12){
									$("select[name='groupOrderGuestList["+count+"].type").val("2");
								}else{
									$("select[name='groupOrderGuestList["+count+"].type").val("1");
								}
							});
						}
					}
				}
			}

	$("#bi").hide();
	receiverMode_setValue(); //设置 接站牌的内容
	checkProvince();
}

function checkProvince(){
	if($("#provinceCode").val() !=-1 ) return;
	
	var firstGuestPlace = $("input[name='groupOrderGuestList[0].nativePlace']").val();
	if (firstGuestPlace==undefined || firstGuestPlace== 'undefined' || firstGuestPlace==null)
		firstGuestPlace = "";
	if (firstGuestPlace == "") return;

	var nativeinfo = new nativeInfo(firstGuestPlace);
	var proinfo = eval("("+ nativeinfo.province()+")" ); 
	
	$("#provinceCode").val(proinfo.proid);
	$.getJSON("../basic/getRegion.do?id=" + proinfo.proid, function(data) {
		data = eval(data);
		var s = "<option value='-1'>请选择市</option>";
		$.each(data, function(i, item) {
			s += "<option value='" + item.id + "'>" + item.name + "</option>";
		});
		$("#cityCode").html(s);
		$("#provinceName").val(proinfo.proname);
		
	});
	
	/*
	if($("#provinceCode").val()!=-1 ){
		$.warn('请选择客源地所属省市');
		return ;
	}
	if($("#cityCode").val()==-1 ){
		$.warn('请选择客源地所属市');
		return ;
	}
	*/
}

function taobao_PorcessSellerMemo(aObj){
	/*
	 * 卖家备注提取：格式
	 * {赵倩}操作20160911牟叶<牟叶|640103199401261522|15009612735,马喜迪|642221198811140702|,史超|640221199207282715|,罗超|640103198712100318|>[七彩盛宴6天5晚游]，4大。用房2标。银川出发。满额立减券： 100元
	 */
	var currOrder = $(aObj).closest("tr").find("td").text();
	var startInd = currOrder.indexOf("<"),  endInd = currOrder.indexOf(">");
	if (startInd != -1 && endInd != -1 && startInd < endInd){
		var guestMemo = currOrder.substring(startInd+1, parseInt(endInd));  //取出了尖括号内的结果
		var guestArray = guestMemo.split(",");
		$.each(guestArray, function(i, value){
			guestArray[i] = guestArray[i].replace("|", ",").replace("|", ",").replace("|", ",");
		});
		
		//把结果放到：客人名称导入框里
		$("#batchInputText").val(guestArray.join("\r"));
		//执行导入操作
		toSubmit('newGuest');
	}

}



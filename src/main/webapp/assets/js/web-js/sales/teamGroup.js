$(function(){
	salesRoute = new SalesRoute();
	loadRoute();
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
	
	$("#sourceTypeCode").change(function(){
		if($("#sourceTypeCode").val()!=-1){
			$("#sourceTypeName").val($("#sourceTypeCode option:selected").text());
		}else{
			$("#sourceTypeName").val('');
		}
	});
	
	$("#cityCode").change(function(){
		if($("#cityCode").val()!=-1){
			$("#cityName").val($("#cityCode option:selected").text());
		}else{
			$("#cityName").val('');
		}
	});
	
	$("select[name='groupOrder.prudctBrandId']").change(function() {
		$("input[name='groupOrder.productBrandName']").val($("select[name='groupOrder.proudctBrandId'] option:selected").text());
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
	
	/*客源类别非空校验*/
	$.validator.addMethod("hasSelected", function(value, element) {
		console.log(value);
		if(value == "-1"){
			return false;
		}
		return true;
	}, "必须选择");
	
	$("#teamGroupForm").validate(
			{
				rules : {
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
					'groupOrder.sourceTypeId' : {
						hasSelected : true
					}
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
				
					if($("#supplierId").val()==''){
						$.warn("不存在的组团社");
						return;
					}
					
					if($("#provinceCode").val()==-1 ){
						var nativeinfo = new nativeInfo($("input[name='groupOrderGuestList[0].nativePlace']").val());
						var proinfo = eval("("+ nativeinfo.province()+")" ); 
						$("#provinceCode").val(proinfo.proid);
							$.getJSON("../basic/getRegion.do?id="
									+ proinfo.proid, function(data) {
								data = eval(data);
								var s = "<option value='-1'>请选择市</option>";
								$.each(data, function(i, item) {
									s += "<option value='" + item.id + "'>" + item.name
											+ "</option>";
								});
								$("#cityCode").html(s);
								$("#provinceName").val(proinfo.proname);
								
							});
						$.warn('请选择客源地所属省市');
						return ;
					}
					if($("#cityCode").val()==-1 ){
						$.warn('请选择客源地所属市');
						return ;
						
					}
					
					
					var options = {
						url : '../teamGroup/saveTeamGroupInfo.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									refreshWindow('编辑团订单','../teamGroup/toEditTeamGroupInfo.htm?groupId='+data.groupId+'&operType=1');
									
								});
							} else {
								$.success(data.msg);

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试');
						}
					} 
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					$("#teamGroupForm").focus();
					return false;
				}

			});

});



function loadRoute(){
	
	 $.ajax({
	        type: "post",
	        cache: false,
	        url : path+"/groupRoute/getData.do",
	        data : {
	            groupId : $("input[name='tourGroup.id']").val()
	        },
	        dataType: 'json',
	        async: false,
	        success: function (data) {
	                var days = data.groupRouteDayVOList;
	                for(var i = 1; i <= days.length; i++){
	                    var dayVo = days[i - 1];
	                    salesRoute.dayAdd(dayVo.groupRoute);
	                    var trafficList = dayVo.groupRouteTrafficList;
	                    for(var j = 0; j < trafficList.length; j++){
	                    	salesRoute.trafficAdd(i, j, trafficList[j]);
	                    }
	                    var optionsSupplierList = dayVo.groupRouteOptionsSupplierList;
	                    for(var k = 0; k < optionsSupplierList.length; k++){
	                    	salesRoute.supplierAdd(i, k, optionsSupplierList[k])
	                    }
	                    var imgList = dayVo.groupRouteAttachmentList;
	                    for(var l = 0; l < imgList.length; l++){
	                        imgList[l].thumb = img200Url + imgList[l].path;
	                        salesRoute.imgAdd(i, l, imgList[l])
	                    }
	                }
	           
	        }
	    });
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
	for(var i=0;i<count;i++){
		totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
	}
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
			var va = strs[i].toString().replace("\n", "").replace(/，/g,
					",").replace(/。/g, ",");
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
				$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
				$("input[name='groupOrderTransportList["+count+"].departureCity']").val(infos[3]);
				$("input[name='groupOrderTransportList["+count+"].arrivalCity']").val(infos[4]);
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
				var count = $("#"+strr+"Data").children('tr').length;
				html = template('trans_template', {index : count});
				$("#"+strr+"Data").append(html);
				$("input[name='groupOrderTransportList["+count+"].departureTime']").val(infos[0]);
				$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
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
	$("#bbb").hide();
}
function toSubmit(strName) {
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	var html = $("#guest_template").html();
	// 订单id
	var count = $("#"+strName+"Data").children('tr').length;
	// 客人类型
	var type = "1";
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

	var cerNum = "" ; //统计录入数据是否重复
	for (var i = 0; i < strs.length; i++) {
		var infos = new Array();
		var va = strs[i].toString().replace("\n", "").replace(/，/g,
				",").replace(/。/g, ",");
		infos = va.split(",");
		var v = cerNum.indexOf(infos[1]);
		if(v==-1){
			cerNum+=infos[1] ;
		}else{
			$.warn("第" + eval(i + 1) + "行客人数据重复！");
			return false ;
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
			        if(infos.length == 3 && infos[2].trim().length!=11){
			        	$.warn('请输入有效的手机号码！');
			            return false;
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
								if (data.tip!=""){
									$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'>"+data.tip+"</span>");
								}
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
								if (data.tip!=""){
									$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'>"+data.tip+"</span>");
								}
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
}

/**
 * 订单打印
 * @param orderId 订单id
 */
function printOrder(orderId,state,groupId){
	if(state==0 || state == 2){
		$("#saleOrder").hide() ;
		$("#saleCharge").hide() ;
		$("#saleChargeNoRoute").hide() ;
		$("#saleOrderNoRoute").hide() ;
		$("#tddyd").hide() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
	}else{
		$("#saleOrder").show() ;
		$("#saleCharge").show() ;
		$("#saleChargeNoRoute").show() ;
		$("#saleOrderNoRoute").show() ;
		$("#tddyd").show() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
		$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
		$("#tddyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //导游行程单
	}
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
        area : ['350px','280px'],
		content : $('#exportWord')
	});
};
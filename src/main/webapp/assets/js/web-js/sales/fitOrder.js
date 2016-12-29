/**
 * 散客订单
 */
$(function(){
	
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
					$("#cityName").val('');
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
	
	
	$("#sourceTypeCode").change(function(){
		if($("#sourceTypeCode").val()!=-1){
			$("#sourceTypeName").val($("#sourceTypeCode option:selected").text());
		}else{
			$("#sourceTypeName").val('');
		}
	});
	
	$("#guestSourceId").change(function(){
		if($("#guestSourceId").val()!=-1){
			$("#guestSourceName").val($("#guestSourceId option:selected").text());
		}else{
			$("#guestSourceName").val('');
		}
	});
	
	$("#cityCode").change(function(){
		if($("#cityCode").val()!=-1){
			$("#cityName").val($("#cityCode option:selected").text());
		}else{
			$("#cityName").val('');
		}
	});
	
	
	loadRoute();
	
	
	$("#priceGroup").change(function() {
		
		changePriceTable();
			
	});
	
	$("#fitOrderForm").validate({
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
			if($("input[name='groupOrder.id']").val()==''){
				if($("#priceGroup").val()==''){
					$.warn("请选择价格方案");
					return;
				}
			}
			
			if($("#supplierId").val()==''){
				$.warn("不存在的组团社");
				return;
			}
			
			//var groupCode =$("input[name='groupOrder.groupCode']").val(); //若是变更团，不作人数为0判断
			var numAdult =$("input[name='groupOrder.numAdult']").val();
			var numChild =$("input[name='groupOrder.numChild']").val();
			var numGuide =$("input[name='groupOrder.numGuide']").val();
			
			/*
			if(groupCode.indexOf('变更')==-1){
					if(Number(numAdult)+Number(numChild)+Number(numGuide) <= 0){
						$.warn("订单接纳人数必须大于0！");
						return ;
					}
			}
			*/
			
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
				$.warn('请选择客源地所属省市');
				return ;
				
			}
			var options = {
				url : "saveFitOrderInfo.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							refreshWindow('编辑散客订单','toEditFirOrder.htm?orderId='+data.orderId+"&operType=1&isSales=true")
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
			$("#fitOrderForm").focus();
			return false;
		}
	});
	
	
	
	
	
	

})

function addItemName(obj){
	$(obj).prev().val($(obj).find("option:selected").text());
}
function changePriceTable(){
	var numAdult = $("input[name='groupOrder.numAdult']").val() ;
	var numChild = $("input[name='groupOrder.numChild']").val() ;
		if(numAdult!='' && numChild !='' &&  !isNaN(numAdult) &&  !isNaN(numChild)){
			var info= $("#priceGroup").val().split(",");
			
			
			var p1 = $("#price_numAdult_select").parent('tr');
			var siblings_1 = p1.siblings();
		    p1.remove();
		    siblings_1.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderPriceList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
		        });
		        
		    });
		    
		    
		    
		    
		    var p2 = $("#price_numChild_select").parent('tr');
			var siblings_2 = p2.siblings();
		    p2.remove();
		    siblings_2.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderPriceList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
		        });
		        
		    });
		    
		    
		    
		    if(numAdult>0){
		  	//价格-成人
			var html = $("#price_template_numAdult").html();
			var count = $("#newPriceData").children('tr').length;
			html = template('price_template_numAdult', {index : count});
			$("#newPriceData").append(html);
			 $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '成人'){  
			                 $(this).attr("selected","selected");  
			             }  
			  });  
			$("input[name='groupOrderPriceList["+count+"].itemName']").val("成人");
			$("input[name='groupOrderPriceList["+count+"].unitPrice']").val(info[0]);
			$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numAdult);
			$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(info[0]*numAdult);
			var totalPrice= 0;
			for(var i=0;i<count+1;i++){
				totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
			}
			$("#totalPrice").html(totalPrice);
		    }
		    
		    if(numChild>0){
			//价格-小孩
			var html = $("#price_template_numChild").html();
			var count = $("#newPriceData").children('tr').length;
			html = template('price_template_numChild', {index : count});
			$("#newPriceData").append(html);
			
		 //	$("select[name='groupOrderPriceList["+count+"].itemId']").find("option[text='儿童']").attr("selected",true);
		    $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
		        var temp_value = $(this).text();  
		             if(temp_value == '儿童'){  
		                 $(this).attr("selected","selected");  
		             }  
		        });  
			$("input[name='groupOrderPriceList["+count+"].itemName']").val("儿童");
			$("input[name='groupOrderPriceList["+count+"].unitPrice']").val(info[1]);
			$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numChild);
			$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(info[1]*numChild);
			var totalPrice= 0;
			for(var i=0;i<count+1;i++){
				totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
			}
			$("#totalPrice").html(totalPrice);
			
		    }
		    
		   
		    var p3 = $("#cost_numAdult_select").parent('tr');
		    var siblings_3 = p3.siblings();
		    p3.remove();
		    siblings_3.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderCostList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
		        });
		    });
		    
		   
		    
		    var p4 = $("#cost_numChild_select").parent('tr');
		    var siblings_4 = p4.siblings();
		    p4.remove();
		    siblings_4.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderCostList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
		        });
		    });
		    
		    
		    if(numAdult>0){ 
		    //成本-成人
			var html = $("#cost_template_numAdult").html();
			var count = $("#newCostData").children('tr').length;
			html = template('cost_template_numAdult', {index : count});
			$("#newCostData").append(html);
			
		//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='成人']").attr("selected", true);
			 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '成人'){  
			                 $(this).attr("selected","selected");  
			             }  
			        });  
			$("input[name='groupOrderCostList["+count+"].itemName']").val("成人");
			$("input[name='groupOrderCostList["+count+"].unitPrice']").val(info[2]);
			$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderCostList["+count+"].numPerson']").val(numAdult);
			$("input[name='groupOrderCostList["+count+"].totalPrice']").val(info[2]*numAdult);
			var totalCost= 0;
			for(var i=0;i<count+1;i++){
				totalCost=Number(totalCost)+Number($("input[name='groupOrderCostList["+i+"].totalPrice']").val());
			}
			$("#totalCost").html(totalCost);
		    }
		    if(numChild>0){
			//成本-儿童
			var html = $("#cost_template_numChild").html();
			var count = $("#newCostData").children('tr').length;
			html = template('cost_template_numChild', {index : count});
			$("#newCostData").append(html);
			
		//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='儿童']").attr("selected", true);
			 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '儿童'){  
			                 $(this).attr("selected","selected");  
			             }  
			        }); 
			$("input[name='groupOrderCostList["+count+"].itemName']").val("儿童");
			$("input[name='groupOrderCostList["+count+"].unitPrice']").val(info[3]);
			$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderCostList["+count+"].numPerson']").val(numChild);
			$("input[name='groupOrderCostList["+count+"].totalPrice']").val(info[3]*numChild);
			var totalCost= 0;
			for(var i=0;i<count+1;i++){
				totalCost=Number(totalCost)+Number($("input[name='groupOrderCostList["+i+"].totalPrice']").val());
			}
			$("#totalCost").html(totalCost);
		    }
		}else{
			$.warn("请先正确填写订单人数！");
			$("#priceGroup").val("");
		}
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
	}else{
		$.ajax({
            type: "post",
            cache: false,
            url : path + "/groupRoute/getImpData.do",
            data : {
                productId :$("input[name='groupOrder.productId']").val()
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
		var orderId = $("input[name='groupOrder.id']").val();
		
		if(guestCertificateNum!=''){
			
			
			if (reg.test(guestCertificateNum) === true) {
				
				var data = $.parseIDCard(guestCertificateNum);
				
				if(data.tip==''){
					
					$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
					if(data.age<12){
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
				$.ajax({
					type: "post",
					cache: false,
					url : "../guest/guestCertificateNumValidate.htm",
					data : {guestCertificateNum :guestCertificateNum,orderId:orderId},
					dataType: 'json',
					async: false,
					success: function (data) {
						/*if(data && data.success == true){
							alert(22);
						}*/
						if(data && data.success == false){
							layer.open({
								type : 2,
								title : '参团信息',
								shadeClose : true,
								shade : 0.5,
								area: ['720px', '460px'],
								content: '../guest/getGuestOrderInfo.htm?guestCertificateNum='+guestCertificateNum+'&orderId='+orderId
							});
						}
						
					}
				});
				
			}else{
				$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
				$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
			}
		}
	}else{
		$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
	}

}
function isAllowAddGuest(){
	var numAdultBeforEdit = $("#numAdultBeforEdit").val();  //修改前的团人数(成人）
	var numChildBeforEdit = $("#numChildBeforEdit").val();  //修改前的团人数(小孩）
	var personNum=$("#allowNum").val();
	var numAdult =$("input[name='groupOrder.numAdult']").val();
	var numChild =$("input[name='groupOrder.numChild']").val();
	
	var iAllNumBeforEdit = 0;  //修改前总人数
	var iNumAdultBeforEdit = 0;  //修改前的团人数(成人）
	var iNumChildBeforEdit = 0;  //修改前的团人数(小孩）
	if(numAdultBeforEdit && numAdultBeforEdit!= "" && !isNaN(numAdultBeforEdit)){
		iNumAdultBeforEdit = Number(numAdultBeforEdit);
	}
	if(numChildBeforEdit && numChildBeforEdit!= "" && !isNaN(numChildBeforEdit)){
		iNumChildBeforEdit = Number(numChildBeforEdit);
	}
	iAllNumBeforEdit = iNumAdultBeforEdit + iNumChildBeforEdit;  //修改前总人数
	var personNumAfterEdit = Number(numAdult)+Number(numChild);  //修改后总人数
	//实际库存应该是修改前人数 + 库存
	personNum = Number(iAllNumBeforEdit) + Number(personNum);
	
	var groupCode =$("input[name='groupOrder.groupCode']").val(); //若是变更团，不作人数为0判断
	//alert(groupCode+","+groupCode.indexOf('变更'));
	if(groupCode.indexOf('变更')==-1){
		if(personNumAfterEdit>personNum){
			$.warn("订单人数不允许大于库存人数！");
			$("input[name='groupOrder.numAdult']").val(0);
			$("input[name='groupOrder.numChild']").val(0);
			return ;
		}
	}
	if($("#priceGroup").val()!=''){
	changePriceTable();
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
								$("input[name='groupOrderGuestList["+count+"].age']").change(
										function(e) {
									if($(this).val().trim()<12){
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
									if($(this).val().trim()<12){
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
								if($(this).val().trim()<12){
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
								if($(this).val().trim()<12){
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
function changeNum(){
	var numAdultBeforEdit = $("#numAdultBeforEdit").val();  //修改前的团人数(成人）
	var numChildBeforEdit = $("#numChildBeforEdit").val();  //修改前的团人数(小孩）
	var personNum=$("#allowNum").val();
	var numAdult =$("input[name='groupOrder.numAdult']").val();
	var numChild =$("input[name='groupOrder.numChild']").val();
	
	var iAllNumBeforEdit = 0;  //修改前总人数
	var iNumAdultBeforEdit = 0;  //修改前的团人数(成人）
	var iNumChildBeforEdit = 0;  //修改前的团人数(小孩）
	if(numAdultBeforEdit && numAdultBeforEdit!= "" && !isNaN(numAdultBeforEdit)){
		iNumAdultBeforEdit = Number(numAdultBeforEdit);
	}
	if(numChildBeforEdit && numChildBeforEdit!= "" && !isNaN(numChildBeforEdit)){
		iNumChildBeforEdit = Number(numChildBeforEdit);
	}
	iAllNumBeforEdit = iNumAdultBeforEdit + iNumChildBeforEdit;  //修改前总人数
	var personNumAfterEdit = Number(numAdult)+Number(numChild);  //修改后总人数
	//实际库存应该是修改前人数 + 库存
	personNum = Number(iAllNumBeforEdit) + Number(personNum);
	
	if(personNumAfterEdit>personNum){
		$.warn("订单人数不允许大于库存人数！");
		$("input[name='groupOrder.numAdult']").val(0);
		$("input[name='groupOrder.numChild']").val(0);
		return ;
	}
	if($("#groupId").val()!=''){
	changeTable();
	}
	
}

function changeTable(){

	var numAdult = $("input[name='groupOrder.numAdult']").val() ;
	var numChild = $("input[name='groupOrder.numChild']").val() ;
		if(numAdult!='' && numChild !='' &&  !isNaN(numAdult) &&  !isNaN(numChild)){
			
			var p1 = $("#price_numAdult_select").parent('tr');
			var siblings_1 = p1.siblings();
		    p1.remove();
		    siblings_1.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderPriceList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
		        });
		        
		    });
		    
		    
		    
		    
		    var p2 = $("#price_numChild_select").parent('tr');
			var siblings_2 = p2.siblings();
		    p2.remove();
		    siblings_2.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderPriceList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
		        });
		        
		    });
		    
		    
		    
		    if(numAdult>0){
		  	//价格-成人
			var html = $("#price_template_numAdult").html();
			var count = $("#newPriceData").children('tr').length;
			html = template('price_template_numAdult', {index : count});
			$("#newPriceData").append(html);
			 $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '成人'){  
			                 $(this).attr("selected","selected");  
			             }  
			  });  
			$("input[name='groupOrderPriceList["+count+"].itemName']").val("成人");
			$("input[name='groupOrderPriceList["+count+"].unitPrice']").val($("#adultPrice").val());
			$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numAdult);
			$("input[name='groupOrderPriceList["+count+"].totalPrice']").val($("#adultPrice").val()*numAdult);
			var totalPrice= 0;
			for(var i=0;i<count+1;i++){
				totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
			}
			$("#totalPrice").html(totalPrice);
		    }
		    
		    if(numChild>0){
			//价格-小孩
			var html = $("#price_template_numChild").html();
			var count = $("#newPriceData").children('tr').length;
			html = template('price_template_numChild', {index : count});
			$("#newPriceData").append(html);
			
		 //	$("select[name='groupOrderPriceList["+count+"].itemId']").find("option[text='儿童']").attr("selected",true);
		    $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
		        var temp_value = $(this).text();  
		             if(temp_value == '儿童'){  
		                 $(this).attr("selected","selected");  
		             }  
		        });  
			$("input[name='groupOrderPriceList["+count+"].itemName']").val("儿童");
			$("input[name='groupOrderPriceList["+count+"].unitPrice']").val($("#childPrice").val());
			$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numChild);
			$("input[name='groupOrderPriceList["+count+"].totalPrice']").val($("#childPrice").val()*numChild);
			var totalPrice= 0;
			for(var i=0;i<count+1;i++){
				totalPrice=Number(totalPrice)+Number($("input[name='groupOrderPriceList["+i+"].totalPrice']").val());
			}
			$("#totalPrice").html(totalPrice);
			
		    }
		    
		   
		    var p3 = $("#cost_numAdult_select").parent('tr');
		    var siblings_3 = p3.siblings();
		    p3.remove();
		    siblings_3.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderCostList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
		        });
		    });
		    
		   
		    
		    var p4 = $("#cost_numChild_select").parent('tr');
		    var siblings_4 = p4.siblings();
		    p4.remove();
		    siblings_4.each(function(index, element){
		        var founds = $(element).find("[name^='groupOrderCostList']");
		        founds.each(function(){
		            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
		        });
		    });
		    
		    
		    if(numAdult>0){ 
		    //成本-成人
			var html = $("#cost_template_numAdult").html();
			var count = $("#newCostData").children('tr').length;
			html = template('cost_template_numAdult', {index : count});
			$("#newCostData").append(html);
			
		//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='成人']").attr("selected", true);
			 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '成人'){  
			                 $(this).attr("selected","selected");  
			             }  
			        });  
			$("input[name='groupOrderCostList["+count+"].itemName']").val("成人");
			$("input[name='groupOrderCostList["+count+"].unitPrice']").val($("#adultCost").val());
			$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderCostList["+count+"].numPerson']").val(numAdult);
			$("input[name='groupOrderCostList["+count+"].totalPrice']").val($("#adultCost").val()*numAdult);
			var totalCost= 0;
			for(var i=0;i<count+1;i++){
				totalCost=Number(totalCost)+Number($("input[name='groupOrderCostList["+i+"].totalPrice']").val());
			}
			$("#totalCost").html(totalCost);
		    }
		    if(numChild>0){
			//成本-儿童
			var html = $("#cost_template_numChild").html();
			var count = $("#newCostData").children('tr').length;
			html = template('cost_template_numChild', {index : count});
			$("#newCostData").append(html);
			
		//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='儿童']").attr("selected", true);
			 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '儿童'){  
			                 $(this).attr("selected","selected");  
			             }  
			        }); 
			$("input[name='groupOrderCostList["+count+"].itemName']").val("儿童");
			$("input[name='groupOrderCostList["+count+"].unitPrice']").val($("#childCost").val());
			$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
			$("input[name='groupOrderCostList["+count+"].numPerson']").val(numChild);
			$("input[name='groupOrderCostList["+count+"].totalPrice']").val($("#childCost").val()*numChild);
			var totalCost= 0;
			for(var i=0;i<count+1;i++){
				totalCost=Number(totalCost)+Number($("input[name='groupOrderCostList["+i+"].totalPrice']").val());
			}
			$("#totalCost").html(totalCost);
		    }
		}else{
			$.warn("请先正确填写订单人数！");
			$("#priceGroup").val("");
		}

}
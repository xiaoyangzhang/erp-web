var addGuest=function(str){
	$("#"+str+"BtnState").css("display","");
	var html = $("#guest_template").html();
	var count = $("#"+str+"Data").children('tr').length;
	if($("#orderId").length>0){ //团队
		$.getJSON("../guest/matchNum.htm?orderId=" + $("#orderId").val()
				+ "&count=" +(count+1), function(data) {
			if (!data.success) {
				$.warn("超过该团最大容纳人数！");
				return ;
			}
		});
	}else{ //一地散
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
		if((count+1)>(Number(numAdult)+Number(numChild)+Number(numGuide))){
			$.warn("超过该订单最大容纳人数！");
			return ;
		}
		
	}
	
	
			html = template('guest_template', {index : count});
			$("#"+str+"Data").append(html);
			var name =  $("input[name='groupOrderGuestList["+count+"].name']");
		    
			if(name.length > 0){
				name.rules("add",{required : true});
			}
			
			$("input[name='groupOrderGuestList["+count+"].name']").blur(function(){
				if($("input[name='groupOrder.receiveMode']").length>0 && $("input[name='groupOrder.receiveMode']").val()=='' ){
					$("input[name='groupOrder.receiveMode']").val(name.val());
				}
				
			});
			var certificateNum =  $("input[name='groupOrderGuestList["+count+"].certificateNum']");
		    
			if(certificateNum.length > 0){
				certificateNum.rules("add",{required : true});
			}
			$("input[name='groupOrderGuestList["+count+"].age']").change(
					function(e) {
				if($(this).val().trim()<12){
					$("select[name='groupOrderGuestList["+count+"].type").val("2");
				}else{
					$("select[name='groupOrderGuestList["+count+"].type").val("1");
				}
			});
			var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
			var cerNums = "" ;
			$("input[name='groupOrderGuestList["+count+"].certificateNum']").mouseout(
					function(e) {
						/**
						 * 验证客人是否已录入
						 */
						var vv = $(".certificateNum") ;
						vv.each(function (){
							cerNums = cerNums + $(this).text() ;
						}) ;
						if($("input[name='groupOrderGuestList["+count+"].certificateNum']").val()!=''){
							var v1 = cerNums.indexOf($("input[name='groupOrderGuestList["+count+"].certificateNum']").val()) ;
							if(v1!=-1){
								$.warn("该客人数据已录入！");
								return false ;
							}
						}
						
						var typeName = $("#certificateTypeId option:selected").text();
						if(typeName=='身份证'){
							var guestCertificateNum = $("input[name='groupOrderGuestList["+count+"].certificateNum']").val();
							if(guestCertificateNum!=''){
								if (reg.test(guestCertificateNum) === true) {
									var data = $.parseIDCard(guestCertificateNum);
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
									
								}else{
									$.warn("请输入正确长度的身份证号码！");
								}
							}
						}
					}
				);

}

var delGuestTable = function(el,str){
  	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    if(siblings.length==0){
    	$("#"+str+"BtnState").css("display","none");
    }
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='groupOrderGuestList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/groupOrderGuestList\[\d+]/g, 'groupOrderGuestList[' + index + ']'));
        });
    });
}



var addTran = function (str){
	$("#"+str+"BtnState").css("display","");
	var html = $("#trans_template").html();
	var count = $("#"+str+"Data").children('tr').length;
	html = template('trans_template', {index : count});
	$("#"+str+"Data").append(html);
	
	  var departureCity =  $("input[name='groupOrderTransportList["+count+"].departureCity']");
      
		if(departureCity.length > 0){
			//departureCity.rules("add",{required : true});
		}
	  var arrivalCity =  $("input[name='groupOrderTransportList["+count+"].arrivalCity']");
	      
			if(arrivalCity.length > 0){
				//arrivalCity.rules("add",{required : true});
			}
	
}


var delTranTable = function(el,str){
  	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    if(siblings.length==0){
    	$("#"+str+"BtnState").css("display","none");
    }
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='groupOrderTransportList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/groupOrderTransportList\[\d+]/g, 'groupOrderTransportList[' + index + ']'));
        });
    });
}


var addPrice =function(type,str, rowObj){
	//type 项目下拉框值，　str=newPrice, rowObj：json对象（格式与新增的行对应）
		$("#"+str+"BtnState").css("display","");
		var html = $("#price_template").html();
		var count = $("#"+str+"Data").children('tr').length;
		html = template('price_template', {index : count,delType:type==0?'newPrice':'newCost'});
		$("#"+str+"Data").append(html);
		
		$("input[name='groupOrderPriceList["+count+"].mode']").val(type);
        var unitPrice =  $("input[name='groupOrderPriceList["+count+"].unitPrice']");
	/*		if(unitPrice.length > 0){
				unitPrice.rules("add",{required : true,number : true});
			}*/
		
		var numTimes =  $("input[name='groupOrderPriceList["+count+"].numTimes']");
			if(numTimes.length > 0){
				numTimes.rules("add",{required : true,number : true});
			}
			
		var numPerson =  $("input[name='groupOrderPriceList["+count+"].numPerson']");
				if(numPerson.length > 0){
					numPerson.rules("add",{required : true,number : true});
			}
				$("input[name='groupOrderPriceList["+count+"].itemName']").val($("select[name='groupOrderPriceList["+count+"].itemId'] option:selected").text());
				$("select[name='groupOrderPriceList["+count+"].itemId']").change(function(){
					$("input[name='groupOrderPriceList["+count+"].itemName']").val($("select[name='groupOrderPriceList["+count+"].itemId'] option:selected").text());
				});	
				$("input[name='groupOrderPriceList["+count+"].unitPrice']").on(
						'input',
						function(e) { priceRowCals(count);
						});
				
				$("input[name='groupOrderPriceList["+count+"].numTimes']").on(
						'input',
						function(e) {
							priceRowCals(count);
						});
				
				$("input[name='groupOrderPriceList["+count+"].numPerson']").on(
						'input',
						function(e) {
							priceRowCals(count);
						});
				$orderId = $("input[name='groupOrderPriceList["+count+"].orderId']");
				if ($orderId.val() == ""){
					$orderId.val("0");
				}
				
				//淘宝订单　加入：priceLockState＝淘宝订单id，若此字段不为０，表示前台页面不能更改 
				//console.log(rowObj);
				if (rowObj){
					if (rowObj.priceLockState) $("input[name='groupOrderPriceList["+count+"].priceLockState']").val(rowObj.priceLockState);
					if (rowObj.unitPrice){ 
						$("input[name='groupOrderPriceList["+count+"].unitPrice']").val(rowObj.unitPrice);
						$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(rowObj.unitPrice);
						$("textarea[name='groupOrderPriceList["+count+"].remark']").val(rowObj.remark);
						priceRowCals(count);
						priceRow_setReadonly(count); //设置为只读
						countTotalPrice(count); //此方法在：taobaoOrderList.js
					}
				}
				
}
var priceRowCals = function(row){
	var unitPrice = $("input[name='groupOrderPriceList["+row+"].unitPrice']").val();
	var numTimes = $("input[name='groupOrderPriceList["+row+"].numTimes']").val();
	var numPerson = $("input[name='groupOrderPriceList["+row+"].numPerson']").val();
	var total = (unitPrice == '' ? '1' : unitPrice) * (numTimes == '' ? '1' : numTimes) * (numPerson == '' ? '1' : numPerson);
	$("input[name='groupOrderPriceList["+row+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);	
}

var priceRow_setReadonly = function(row){
	$("input[name='groupOrderPriceList["+row+"].unitPrice']").css({'color': "red", 'border-color': "red"}).attr("readonly", "readonly");
	$("input[name='groupOrderPriceList["+row+"].numTimes']").css({'color': "red", 'border-color': "red"}).attr("readonly", "readonly");
	$("input[name='groupOrderPriceList["+row+"].numPerson']").css({'color': "red", 'border-color': "red"}).attr("readonly", "readonly");
	$("textarea[name='groupOrderPriceList["+row+"].remark']").css({'color': "red", 'border-color': "red"}).attr("readonly", "readonly");
}

var delPriceTable = function(el,str){ 
	  	var p = $(el).parent('td').parent('tr');
	    var siblings = p.siblings();
	    p.remove();
	    if(siblings.length==0){
	    	$("#"+str+"BtnState").css("display","none");
	    }
	    siblings.each(function(index, element){
	        var founds = $(element).find("[name^='groupOrderPriceList']");
	       
	        founds.each(function(){
	            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
	        });
	    });
}


var addCost =function(type,str){
	$("#"+str+"BtnState").css("display","");
	var html = $("#cost_template").html();
	var count = $("#"+str+"Data").children('tr').length;
	html = template('cost_template', {index : count,delType:type==0?'newPrice':'newCost'});
	$("#"+str+"Data").append(html);
	$("input[name='groupOrderCostList["+count+"].mode']").val(type);
    var unitPrice =  $("input[name='groupOrderCostList["+count+"].unitPrice']");
    
		if(unitPrice.length > 0){
			unitPrice.rules("add",{required : true,number : true});
		}
	
	var numTimes =  $("input[name='groupOrderCostList["+count+"].numTimes']");
		if(numTimes.length > 0){
			numTimes.rules("add",{required : true,number : true});
		}
		
	var numPerson =  $("input[name='groupOrderCostList["+count+"].numPerson']");
			if(numPerson.length > 0){
				numPerson.rules("add",{required : true,number : true});
		}
			$orderId = $("input[name='groupOrderCostList["+count+"].orderId']");
			if ($orderId.val() == ""){
				$orderId.val("0");
			}
			$("input[name='groupOrderCostList["+count+"].itemName']").val($("select[name='groupOrderCostList["+count+"].itemId'] option:selected").text());
			$("select[name='groupOrderCostList["+count+"].itemId']").change(function(){
				$("input[name='groupOrderCostList["+count+"].itemName']").val($("select[name='groupOrderCostList["+count+"].itemId'] option:selected").text());
				
			});			
			$("input[name='groupOrderCostList["+count+"].unitPrice']").on(
					'input',
					function(e) {
						var unitPrice = $("input[name='groupOrderCostList["+count+"].unitPrice']").val();
						var numTimes = $("input[name='groupOrderCostList["+count+"].numTimes']").val();
						var numPerson = $("input[name='groupOrderCostList["+count+"].numPerson']").val();
						var total = (unitPrice == '' ? '1' : unitPrice)
								* (numTimes == '' ? '1' : numTimes)
								* (numPerson == '' ? '1' : numPerson);
						$("input[name='groupOrderCostList["+count+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);
					});
			
			$("input[name='groupOrderCostList["+count+"].numTimes']").on(
					'input',
					function(e) {
						var unitPrice = $("input[name='groupOrderCostList["+count+"].unitPrice']").val();
						var numTimes = $("input[name='groupOrderCostList["+count+"].numTimes']").val();
						var numPerson = $("input[name='groupOrderCostList["+count+"].numPerson']").val();
						var total = (unitPrice == '' ? '1' : unitPrice)
								* (numTimes == '' ? '1' : numTimes)
								* (numPerson == '' ? '1' : numPerson);
						$("input[name='groupOrderCostList["+count+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);
					});
			
			$("input[name='groupOrderCostList["+count+"].numPerson']").on(
					'input',
					function(e) {
						var unitPrice = $("input[name='groupOrderCostList["+count+"].unitPrice']").val();
						var numTimes = $("input[name='groupOrderCostList["+count+"].numTimes']").val();
						var numPerson = $("input[name='groupOrderCostList["+count+"].numPerson']").val();
						var total = (unitPrice == '' ? '1' : unitPrice)
								* (numTimes == '' ? '1' : numTimes)
								* (numPerson == '' ? '1' : numPerson);
						$("input[name='groupOrderCostList["+count+"].totalPrice']").val(isNaN(total)?"0":Math.round(total*100)/100);
					});
			
}

var delCostTable = function(el,str){
  	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    if(siblings.length==0){
    	$("#"+str+"BtnState").css("display","none");
    }
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='groupOrderCostList']");
       
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
        });
    });
}

$(function(){
	
	$("#newTransportDataForm").validate(
			{
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
					var options = {
						url : '../groupOrder/addManyGroupOrderTransport.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
								
							} else {
								$.warn(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
	
	
	$("#newPriceDataForm").validate(
			{
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
					var options = {
						url : '../groupOrder/addGroupOrderPriceMany.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
								
							} else {
								$.warn(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
	
	$("#newCostDataForm").validate(
			{
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
					var options = {
						url : '../groupOrder/addGroupOrderPriceMany.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
								
							} else {
								$.warn(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
	
})
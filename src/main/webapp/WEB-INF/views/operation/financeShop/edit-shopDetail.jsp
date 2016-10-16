<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	 <div class="p_container" >
	  

	    <div class="p_container_sub" id="tab1">
	    	<form id="saveShopDetailForm">
	    	<p class="p_paragraph_title"><b>添加明细</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">商品：</div> 
	    			<div class="dd_right">
	    					<input type="hidden" name="bookingId" value="${shopDetail.bookingId }">
	    					<input type="hidden" name="id" value="${shopDetail.id }">
	    					<input type="hidden" name="goodsName" id = "goodsName" value="${shopDetail.goodsName }">
	    					<select name="goodsId" id="goodsId">
	    						<option value="">请选择</option>
							<c:forEach items="${dic}" var="d">
								
								<option value="${d.id}" <c:if test="${shopDetail.goodsId eq d.id }">selected</c:if> >${d.value}</option>
							</c:forEach>
						</select>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    	
	    		<dd>
	    			<div class="dd_left">数量：</div> 
	    			<div class="dd_right">
	    				<input  type="text" id="buyNum" name="buyNum"  value="${shopDetail.buyNum }" class="IptText300">
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">价格：</div> 
	    			<div class="dd_right">
	    				<input  type="text" id="buyPrice" name="buyPrice"  value="<fmt:formatNumber value="${shopDetail.buyPrice }" pattern="#.##" type="number"/>" class="IptText300">
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">金额：</div> 
	    			<div class="dd_right">
	    				<input  type="text" id="buyTotal" name="buyTotal"  value="<fmt:formatNumber value="${shopDetail.buyTotal }" pattern="#.##" type="number"/>" class="IptText300">
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">返款模式：</div> 
	    			<div class="dd_right">
	    			<input id="repayVal" name="repayVal" type="hidden" value="${shopDetail.repayVal }" />
	    				<input name="repayType" type="radio" value="1" id="rad_repay1" <c:if test="${shopDetail.repayType eq 1 }">checked="checked"</c:if> />
	    				<label for="rad_repay1">按销售金额返款&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    				<input id="repayType1" type="text" <c:if test="${shopDetail.repayType eq 1 }">value="${shopDetail.repayVal }"</c:if>  />% </label>
	    				<div class="clear"></div>
	    				<input name="repayType" type="radio" value="2" id="rad_repay2" <c:if test="${shopDetail.repayType eq 2 }">checked="checked"</c:if> />
	    				<label for="rad_repay2">按销售数量返款&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    				<input id="repayType2" type="text" <c:if test="${shopDetail.repayType eq 2 }">value="${shopDetail.repayVal }"</c:if>  />件 </label>
	    			</div>
					<div class="clear"></div>
	    		</dd>  
	    		<dd>
	    			<div class="dd_left">返款：</div> 
	    			<div class="dd_right">
	    				<input name="repayTotal" id="repayTotal" type="text" value="<fmt:formatNumber value="${shopDetail.repayTotal }" pattern="#.##" type="number"/>" />
	    			</div>
					<div class="clear"></div>
	    		</dd>  
	    		
	    		
	    	</dl>

	    	
            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            <button  type="submit" class="button button-primary button-small">保存</button>
            <a href="toFactShop.htm?id=${shopDetail.bookingId }&groupId=${groupId}" class="button button-primary button-small">返回</a>
            </div>
            </div>    
            </form>	
          
			
	    </div>
     
        
    </div>
</body>



<script type="text/javascript">
var priceData = new Array();

$(function(){	
	var buyNum= $("#buyNum").val();
	if(buyNum==""){
		$("#buyNum").val(1);
	}
	var repayType1= $("#repayType1").val();
	if(repayType1==""){
		$("#repayType1").val(0);
	}
	
	$.ajax({
		type: 'GET',
        url: '<%=ctx%>/booking/contractPriceExt.htm?supplierId=${supplierId}&date=${shopDate}',
        dataType: 'json',
        success: function(data) {
        	priceData = data;		        	
        },
        error: function(data,msg) {	            
        }
	});
	
	$("input[name='repayType']").change(calculateRepay);
	$("#repayType1").change(calculateRepay);
	$("#repayType2").change(calculateRepay);
	
	
	$("#goodsId").change(function(){
		$("#goodsName").val(($("#goodsId  option:selected").text()));
	});
	
	
	/*提交**/
	$("#saveShopDetailForm").validate(
			{
				rules:{
					
					'goodsType' : {
						required : true
					},
					'buyNum' : {
						required : true,
						isDouble:true 
					},
					'buyPrice' : {
						required : true,
						number:true
					},
					'goodsType' : {
						required : true
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
					var options = {
						url : "saveShopDetail.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							
							if (data.success) {
								$.success('操作成功',function(){
									window.location.href="toFactShop.htm?id=${shopDetail.bookingId }&groupId=${groupId}";
								});
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
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
});

function calculateRepay(){
	if ($("input[name='repayType']:checked").val()=="1"){
		var repayVal = $("#repayType1").val();
		$("input[name='repayVal']").val(repayVal);
		$("input[name='repayTotal']").val($("input[name='buyTotal']").val()*100 * repayVal / 10000);
	}else {
		var repayVal = $("#repayType2").val();
		$("input[name='repayVal']").val(repayVal);
		$("input[name='repayTotal']").val($("input[name='buyNum']").val() * 100 * repayVal / 100);
	}
}


function date_compare(dateStart, dateEnd, dateCompare) {
    var arr = dateStart.split("-"), arr2 = dateEnd.split("-"), arr3 = dateCompare.split("-");
    var timeStart = (new Date(arr[0], arr[1], arr[2])).getTime();
    var timeEnd = (new Date(arr2[0], arr2[1], arr2[2])).getTime();
    var timeCompare = (new Date(arr3[0], arr3[1], arr3[2])).getTime();
    return (timeCompare >= timeStart && timeCompare <= timeEnd); 
}

var type;
var price;
var selectChange = function () {
	$("#saveShopDetailForm select").unbind("change").bind("change", function(){
		changeData();
	});
}

selectChange();

var inputChange = function () {
	$("#buyNum,#buyPrice,#repayType1,#repayType2").unbind("change").bind("change", function(){
		inputData();
	});
}

inputChange();

function inputData(){
	var buyNum= $("#buyNum").val();
	
	var buyPrice =$("#buyPrice").val();
	var repayValId = null;
	$("#buyTotal").val(buyNum*buyPrice);
	if(type==1){
	 	$("#repayVal").val($("#"+repayValId).val()); 
		$("#repayTotal").val($("#buyTotal").val()*($("#repayType1").val()/100));
	}else if (type==2){
		 $("#repayVal").val($("#"+repayValId).val());
		$("#repayTotal").val($("#buyNum").val()*$("#repayType2").val());
	}
}

function changeData(){
	var d = priceData;
	var vType1 = $("#goodsId").val();//商品
	//var vType2 = $("#goodsType").val();//正特价

	var exist=false;
	if(d.length>0){
		for (var i = 0; i < d.length&&!exist; i++) {
			if(d[i].itemType == vType1){
				if (date_compare(d[i].startDateStr, d[i].endDateStr, "${shopDate}")){
					type = d[i].rebateMethod;
					price = d[i].rebateAmount;
					$("input[id^=repayType]").val(""); 
					 $("#repayType"+d[i].rebateMethod).val(d[i].rebateAmount);
					repayValId = "repayType"+d[i].rebateMethod;
					$("input[type=radio][value="+d[i].rebateMethod+"]").attr("checked",'true');
					exist=true;
				}
				
			}
		}
	}

	var buyNum= $("#buyNum").val();
	var buyPrice =$("#buyPrice").val();
	var repayValId = null;
	$("#buyTotal").val(buyNum*buyPrice);
	if(type==1){
	 	$("#repayVal").val($("#"+repayValId).val()); 
		$("#repayTotal").val($("#buyTotal").val()*($("#repayType1").val()/100));
	}else if (type==2){
		 $("#repayVal").val($("#"+repayValId).val());
		$("#repayTotal").val($("#buyNum").val()*$("#repayType2").val());
	}
	
};

</script>

</html>

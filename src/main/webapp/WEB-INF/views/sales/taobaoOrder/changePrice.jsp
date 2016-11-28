<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/changeAddShow.js"></script>
</head>
<body>
<form id="SavePriceForm">
<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 5%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">项目<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th style="width: 10%">单价<i class="w_table_split"></i></th>
			<th style="width: 10%">人数<i class="w_table_split"></i></th>
			<th style="width: 10%">次数<i class="w_table_split"></i></th>
			<th style="width: 10%">金额<i class="w_table_split"></i></th>
			<th width="5%"><a href="javascript:;" onclick="addPrice(0,'newPrice');" class="def">增加</a></th>
		</tr>
    </thead>
       <tbody id="newPriceData">
 			<c:forEach items="${gop}" var="price" varStatus="index">
		 <tr>
											<td>${index.count} <input type="hidden" name="groupOrderPriceList[${index.index}].id"	value="${price.id}" />
											<input type="hidden" name="groupOrderPriceList[${index.index}].priceLockState"	value="${price.priceLockState}" />
											</td>
											<td><input type="hidden"
												name="groupOrderPriceList[${index.index}].itemName"
												value="${price.itemName}" /> <select <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }"> disabled="disabled" </c:if>
												name="groupOrderPriceList[${index.index}].itemId"
												onchange="addItemName(this)">
													<c:forEach items="${lysfxmList}" var="lysfxm">
														<option value="${lysfxm.id}"
															<c:if test="${price.itemId==lysfxm.id }">selected="selected"</c:if>>${lysfxm.value }</option>
													</c:forEach>
											</select></td>
											<td><textarea class="l_textarea_mark" <c:if test="${price.stateFinance==1 || price.priceLockState > 0 }"> style="width:80%;border-color: red" readonly="readonly" </c:if>
													name="groupOrderPriceList[${index.index}].remark"
													placeholder="备注" >${price.remark }</textarea></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" <c:if test="${price.stateFinance==1 || price.priceLockState > 0  }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].unitPrice"
												placeholder="单价" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.unitPrice }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1 || price.priceLockState > 0  }">border-color: red </c:if>" <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].numPerson"
												placeholder="人数" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.numPerson }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].numTimes"
												placeholder="次数" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.numTimes }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" type="text"
												name="groupOrderPriceList[${index.index}].totalPrice"
												placeholder="金额" readonly="readonly"
												value="<fmt:formatNumber value='${price.totalPrice }' type='currency' pattern='#.##' />" /></td>
											<td>
											<c:if test="${price.stateFinance ne 1  && price.priceLockState ==0 }">
													<a href="javascript:void(0);"	onclick="delPriceTable(this,'newPrice')">删除</a>
													</c:if>
												</td>
				</tr> 
				<c:set var="totalPrice"
											value="${totalPrice+price.totalPrice  }" />
		</c:forEach>
      </tbody>
      <tr>
									<td colspan="6" style="text-align: right">合计：</td>
									<td colspan="2" style="text-align: left"><span id="totalPrice">${totalPrice }</span></td>
								</tr>
</table>
<div class="Footer" style="position:fixed;bottom:0px; right:0px; background-color: rgba(58,128,128,0.7);width: 100%;padding-bottom: 4px;margin-bottom:0px; text-align: center;">
						<button type="submit" class="button button-primary button-small">保存</button>
				</div>
<input type="hidden" name="orderId"	value="${orderId}" />
</form>
</body>

<script type="text/html" id="price_template">
					<tr>
						<td> 
								<input type="hidden" name="groupOrderPriceList[{{index}}].orderId" value="${groupOrder.id}" /> 
								<input type="hidden" name="groupOrderPriceList[{{index}}].mode" value="0"/>
								<input type="hidden" name="groupOrderPriceList[{{index}}].priceLockState" value="0"/>
								<input type="hidden" name="groupOrderPriceList[{{index}}].stateFinance"	value="0" />
						</td>
						<td>
						<input type="hidden" name="groupOrderPriceList[{{index}}].itemName"/>
						<select name="groupOrderPriceList[{{index}}].itemId">
								<c:forEach items="${lysfxmList}" var="lysfxm">
									<option value="${lysfxm.id}" text="${lysfxm.value }">${lysfxm.value }</option>
								</c:forEach>
						</select></td>
						<td><textarea class="l_textarea_mark" style="width:95%;" name="groupOrderPriceList[{{index}}].remark" placeholder="备注"></textarea>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].unitPrice" placeholder="单价" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].numPerson" placeholder="人数"  value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].numTimes" placeholder="次数" value="1" onblur="countTotalPrice({{index}})"/>
						</td>
						<td><input style="width:80%" type="text" name="groupOrderPriceList[{{index}}].totalPrice" placeholder="金额" /></td>
						<td>
								<a href="javascript:void(0);" lang="aDeletePriceRow" onclick="delPriceTable(this,'{{delType}}')">删除</a>
						</td>
					</tr>
</script>
<script type="text/javascript">

$(function(){
	$("#SavePriceForm").validate({
		submitHandler : function(form) {
			var options = {
				url : "savePrice.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
							parent.reloadPage();
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
			$("#SavePriceForm").focus();
			return false;
		}
	});
});

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
</script>
</html>
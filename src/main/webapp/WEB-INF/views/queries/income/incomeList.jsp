<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>其它收入业务统计-商家统计</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body> 
	<div class="p_container">

		<form id="form" method="post">
			<input type="hidden" name="page" id="page" /> 
			<input type="hidden" name="pageSize" id="pageSize" /> 
			<input type="hidden" name="sl" value="booking.selectBookingSupplierListPage" />
			<input type="hidden" name="ssl" value="booking.selectBookingSupplierSum" /> 
			<input type="hidden" name="rp" value="queries/restaurant/restaurantTable" /> 
			<input type="hidden" id="supplierId" name="supplierId" value="" /> 
			<input type="hidden" id="supplierType" name="supplierType" value="${supplierType}" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text"><select id="selectDate" name="selectDate">
								<option value="0">出团日期</option>
								<option value="1">订单日期</option>
								<option value="2">离团日期</option>
							</select></li>
						<li> <input id="startTime" name="startTime" type="text"
								style="width: 120px" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> ~<input
								id="endTime" name="endTime" type="text" style="width: 120px"
								class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
								value="" />
						</li>
						<li class="text">商家：</li>
						<li><input id="supplierName" name="supplierName" style="width: 200px" type="text" /></li>
						<li class="text">产品</li>
						<li><input id="productBrandName" name="productBrandName" type="text" style="width: 200px" placeholder="输入产品名称或品牌" /></li>
						<li class="text">部门:</li>
						<li><input type="text" name="orgNames" id="orgNames"
							stag="orgNames" value="" readonly="readonly" onclick="showOrg()" />
							<input name="orgIds" id="orgIds" stag="orgIds" value=""
							type="hidden" value="" /></li>
						<li class="text">计调:</li>
						<li><select name="operType">
								<option value="0">团计调</option>
								<option value="1">订单计调</option>
						</select> <input type="text" name="saleOperatorName" id="saleOperatorName"
							stag="userNames" value="" readonly="readonly"
							onclick="showUser()" /> <input name="saleOperatorIds"
							id="saleOperatorIds" stag="userIds" type="hidden" value="" /></li>

						<li class="text">团类型</li>
						<li><select id="groupMode" name="groupMode">
								<option value="" selected="selected">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
						</select></li>
						
						
						<li class="text">项目</li>
						<li><select id="type1Id" name="type1Id">
								<option value="">请选择</option>
								<c:forEach items="${Type1}" var="t1" varStatus="vs">
									<option value="${t1.id }">${t1.value }</option>
								</c:forEach>
						</select></li>
						
						<li class="text">结算方式：</li>
						<li><select name="cashType" id="cashType">
								<option value=""></option>
								<c:forEach items="${cashType }" var="type">
									<option value="${type.value }">${type.value }</option>
								</c:forEach>
						</select></li>
						<li class="text">收款状态</li>
						<li><select id="paymentState" name="paymentState">
								<option value="" selected="selected">全部</option>
								<option value="1">已结清</option>
								<option value="0">未结清</option>
						</select></li>						
						<li>
							<button id="btnQuery" type="button" class="button button-primary button-small">查询</button>
						</li>
						<li class="clear" />
					</ul>
				</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<!-- <div id="hotelDetailDiv" style="display: none;width: 1200px;height: 800px"></div> -->

<script type="text/javascript">

$(function() {
	var vars={dateFrom : $.currentMonthFirstDay(),dateTo : $.currentMonthLastDay()};
	$("#startTime").val(vars.dateFrom);
	$("#endTime").val(vars.dateTo );

	$("#btnQuery").click(function(){
 		hotelQueryList(1,$("#searchPageSize").val());
	});
	
	hotelQueryList(1, 15);
});

function hotelQueryList(page, pageSize) {	
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);

	if (!typeof(pageSize)=="number")
		pageSize = 15;
	$("#pageSize").val(pageSize);
	
	var options = {
			url:"../query/getHotelStatistics",
			type:"post",
			dataType:"html",
			success:function(data){
				$("#tableDiv").html(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.error("服务忙，请稍后再试");
			}
	};
	$("#form").ajaxSubmit(options);	
} 

function toDetail(supplierId, supplierName){
	//$("#supplierId").val(supplierId);
	var url = "<%=ctx%>/query/incomeDetailList?"+
		"selectDate=" + $("#selectDate").val() +
		"&startTime=" + $("#startTime").val() + 
		"&endTime=" + $("#endTime").val() + 
		"&level=" + ($("#level").val()==undefined?"":$("#level").val()) + 
		"&supplierId=" + supplierId + 
		"&supplierName=" + supplierName + 
		"&productBrandName=" + $("#productBrandName").val() + 
		"&paymentState=" + ($("#paymentState").val()==undefined?"":$("#paymentState").val()) + 
		"&orgIds=" + $("#orgIds").val() + 
		"&orgNames=" + $("#orgNames").val() + 
		"&saleOperatorIds=" + $("#saleOperatorIds").val() + 
		"&saleOperatorName=" + $("#saleOperatorName").val() + 
		"&operType=" + ($("#operType").val()==undefined?"":$("#operType").val())  + 
		"&groupMode=" + $("#groupMode").val() + 
		"&type1Id=" + ($("#type1Id").val()==undefined?"":$("#type1Id").val()) + 
		"&provinceId=" + ($("#provinceCode").val()==undefined?"":$("#provinceCode").val()) + 
		"&cityId=" + ($("#cityCode").val()==undefined?"":$("#cityCode").val())  + 
		"&cashType=" + $("#cashType").val() + 
		"&supplierType=" + $("#supplierType").val();
	//console.log(url);
	newWindow("其它订单详情", encodeURI(url));
			
}
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</body>

</html>
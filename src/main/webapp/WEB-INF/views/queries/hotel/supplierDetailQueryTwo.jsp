<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>订单明细统计</title>
<!-- 此统计页面，（资源供应系统：审核时使用）  ou
 -->
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>
	<div class="p_container">
		<form id="detailTwoForm" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.bookingSupplierDetailTwoListPage" />
			<input type="hidden" name="ssl" value="booking.bookingSupplierDetailTwoTotal" />
			<input type="hidden" name="rp" value="queries/hotel/supplierDetailQueryTableTwo" />
			<input type="hidden" name="supplierId" id="supplierId" value=""/>
			<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
			<input type="hidden" name="supplierType" id="supplierType" value="${supplierType}"/>
			
			<input type="hidden" name="supplerIds" id="supplerIds" value=""/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">
						<select id="selectDate" name="selectDate">
							<option value="0">出团日期</option>
							<option value="1">订单日期</option>
							<option value="2">离团日期</option>
						</select></li>
					<li><input id="startTime" name="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						~<input id="endTime" name="endTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
					</li>
					<li class="text">团号：</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">商家类别：</li>
					<li><select name="supplierType" id="supplierType">
						<c:if test="${supplierType == 3}">
							<option value="3">酒店</option>
						</c:if>
						<c:if test="${supplierType == 2}">
							<option value="2">餐厅</option>
						</c:if>
						<c:if test="${supplierType == 5}">
							<option value="5">景区</option>
						</c:if>
					</select></li>
					<li class="text">商家名称：</li>
					<li><input id="supplierName"  name="supplierName" style="width: 180px"type="text" value="" placeholder="商家名称"/></li>
					 <li class="text">产品：</li>
					<li><input id="productBrandName"  name="productBrandName" style="width: 200px" type="text" value="" placeholder="产品名称或品牌"/></li>
					<li class="clear"/>
				 </ul>
				<ul> 
					<li class="text">部门：</li>
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" style="width: 181px;" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">	<select name="operType">
								<option value="0">团计调</option>
								<option value="1">订单计调</option>
							</select>
						</li>
						<li>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						</li>
					
					<li class="text">团类型：</li>
					<li><select id="groupMode" name="groupMode">
								<option value="" >全部</option>
								<option value="1" >团队</option>
								<option value="0" >散客</option>
					</select></li>
					<li class="text">结算方式：</li>
					<li>
						<select name="cashType" id="cashType">
								<option value="">请选择</option>
								<c:forEach items="${cashType }" var="type">
									<option value="${type.value }">${type.value }</option>
								</c:forEach>
							</select>

		  				<select id="paymentState" name="paymentState">
								<option value="">付款状态</option>
								<option value="1" >已付清</option>
								<option value="0" >未付清</option>
						</select>
					</li>
					<li class="text">项目：</li>
					<li><input id="type1Name"  name="type1Name" type="text"/></li>	
					<li class="clear" />	
					<li  style="margin-left: 20px;">
						<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
						<input name="limitSupplerIds" id="limitSupplerIds" type="hidden" lang="此值为商家限定-旅游集团财务要求:ou" 
						value="955,2469,1078,867,1563,1560,1561,1562,1559,1882,1827,2040,1083,1077,0,2180,1239,1188,1199,1507,1208,1197,1811,1232,1237,1204,1555,1220,1234,0,1293,1556,0,926,943,1799,860,945,2392,2040,1081,1989"/>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableTwoDiv"></div>

</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
<script type="text/javascript">
$(function(){
	var vars={ dateFrom : $.currentMonthFirstDay(), dateTo : $.currentMonthLastDay() };
	if ($("#startTime").val()=='') $("#startTime").val(vars.dateFrom);
	if ($("#endTime").val()=='') $("#endTime").val(vars.dateTo );
	
	//queryList(1, 15);
	queryList();
});
function searchBtn(){
	 queryList(1,$("#pageSize").val());
}

function queryList(page,pagesize) {	
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);
	
	var options = {
			url:"../query/queryBookingDetailProfit_TableTwo",
			type:"post",
			dataType:"html",
			success:function(data){
				$("#tableTwoDiv").html(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.error(textStatus+":"+errorThrown);
			}
	};
	$("#detailTwoForm").ajaxSubmit(options);	
}

</script>
</html>
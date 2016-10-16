<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>其它支出订单明细</title> 
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
</head>
<body>
	<div class="p_container"> 
		
		<form id="detailForm" action="<%=ctx%>/query/hotelDetailList.htm" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.bookingSupplierDetailListPage" />
			<input type="hidden" name="ssl" value="booking.bookingSupplierDetailTotal" />
			<input type="hidden" name="rp" value="queries/outcome/outcomeDetailTable" />
			<input type="hidden" name="supplierId" id="supplierId" value=""/>
			<input type="hidden" name="supplierType" id="supplierType" value="${condition.supplierType}"/>
			<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text" style="margin-left:30px;" >
						<select id="selectDate" name="selectDate">
							<option value="0" ${condition.selectDate eq 0?'selected="selected"':'' }>出团日期</option>
							<option value="1" ${condition.selectDate eq 1?'selected="selected"':'' }>项目日期</option>
							<option value="2" ${condition.selectDate eq 2?'selected="selected"':'' }>离团日期</option>
						</select></li>
					<li><input id="startTime" name="startTime" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.startTime}" />
						~<input id="endTime" name="endTime" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.endTime}" />
					</li>
					<li class="text">团号</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">商家信息:</li>
					<li><input id="supplierName"  name="supplierName" style="width: 180px"type="text" value="${condition.supplierName}" placeholder="商家名称"/></li>
					 <li class="text">产品</li>
					<li><input id="productBrandName"  name="productBrandName" style="width: 200px" type="text" value="${condition.productBrandName}" placeholder="产品名称或品牌"/></li>

					<li class="clear"/>
				 </ul>
				<ul> 
					
					<li class="text">部门:</li>
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${condition.orgNames}" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value="${condition.orgIds}"/>	
						</li>
						<li class="text">计调:</li>
					<li>	<select name="operType">
								<option value="0">团计调</option>
								<option value="1">订单计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="${condition.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${condition.saleOperatorIds}"/>
					</li>
					
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
								<option value="" >全部</option>
								<option value="1" <c:if test="${condition.groupMode==1}">selected="selected"</c:if>>团队</option>
								<option value="0" <c:if test="${condition.groupMode==0}">selected="selected"</c:if>>散客</option>
					</select></li>
					<li class="text">结算方式：</li>
					<li>
						<select name="cashType" id="cashType">
								<option value="">请选择</option>
								<c:forEach items="${cashType }" var="type">
									<option value="${type.value }" <c:if test="${condition.cashType==type.value }"> selected="selected" </c:if>>${type.value }</option>
								</c:forEach>
							</select>
					</li>
					<li class="text">付款状态</li>
					<li>
		  				<select id="paymentState" name="paymentState">
								<option value="">全部</option>
								<option value="1" <c:if test="${condition.paymentState=='1'}">selected="selected"</c:if>>已结清</option>
								<option value="0" <c:if test="${condition.paymentState=='0'}">selected="selected"</c:if>>未结清</option>
						</select>
					</li>
					<li class="text">项目</li>
					<li><input id="type1Name"  name="type1Name" type="text" style="width:80px"/></li>				
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
						<a href="javascript:void(0)" id="preview" onclick="toPreview()"  class="button button-primary button-small" >
						打印预览</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>

</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
<script type="text/javascript">
$(function(){
	var vars={ dateFrom : $.currentMonthFirstDay(), dateTo : $.currentMonthLastDay() };
	if ($("#startTime").val()=='') $("#startTime").val(vars.dateFrom);
	if ($("#endTime").val()=='') $("#endTime").val(vars.dateTo );
	
	
	$("#btnQuery").click(function(){
		 queryList(1,$("#searchPageSize").val());
	});
	queryList(1, 15);
});

function queryList(page,pagesize) {	
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);
	
	var options = {
			url:"../query/getSupplierStatisticsDetail",
			type:"post", 
			dataType:"html",
			success:function(data){
				$("#tableDiv").html(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.error(textStatus+":"+errorThrown);
			}
	};
	$("#detailForm").ajaxSubmit(options);	
}

</script>
</html>
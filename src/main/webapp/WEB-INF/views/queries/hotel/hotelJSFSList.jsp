<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>结算方式查询</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
</head>
<body>
	<div class="p_container">

		<form id="form" action="<%=ctx%>/query/hotelDetailList" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.selectJSFSListPage" />
			<input type="hidden" name="ssl" value="booking.selectJSFSTotal" />
			<input type="hidden" name="rp" value="queries/hotel/hotelJSFSTable" />
			<input type="hidden" name="supplierId" id="supplierId" value=""/>
			<input type="hidden" name="supplierType" id="supplierType" value="${condition.supplierType}"/>
			<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text" style="margin-left:30px;" >
						<select id="selectDate" name="selectDate">
							<option value="0" >出团日期</option>
							<option value="2">离团日期</option>
						</select></li>
					<li><input id="startTime" name="startTime" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						~<input id="endTime" name="endTime" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
					</li>
					<li class="text">团号</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">商家类别:</li>
					<li><select name="detailLevel" style="width: 100px; text-align: right;">
						<option value="">请选择</option>
						<c:forEach items="${levelList}" var="level">
							<option value="${level.id }"
								<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>
									${level.value }
								</option>
						</c:forEach>
					</select></li>
					<li class="text">商家名称</li>
					<li><select name="provinceId" id="provinceCode"
							class="input-small">
								<option value="">省</option>
								<c:forEach items="${allProvince}" var="province">
									<option value="${province.id }" >${province.name }</option>
								</c:forEach>
						</select>
						<select name="cityId" id="cityCode" class="input-small">
						</select><input id="supplierName"  name="supplierName" style="width: 200px"type="text" value="" placeholder="商家名称"/></li>
					 <li class="text">产品</li>
					<li><input id="productBrandName"  name="productBrandName" style="width: 200px" type="text" value="" placeholder="产品名称或品牌"/></li>

				 </ul>
				<ul> 
					
					<li class="text">部门:</li>
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
					<li>	<select name="operType">
								<option value="0">团计调</option>
								<option value="1">订单计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
					</li>
					
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
								<option value="" >全部</option>
								<option value="1" >团队</option>
								<option value="0" >散客</option>
					</select></li>
					<li class="text">付款状态</li>
					<li>
		  				<select id="paymentState" name="paymentState">
								<option value="">全部</option>
								<option value="1" >已付清</option>
								<option value="0" >未付清</option>
						</select>
					</li>					
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
<script type="text/javascript">
$(function(){
	var vars={ dateFrom : $.currentMonthFirstDay(), dateTo : $.currentMonthLastDay() };
	if ($("#startTime").val()=='') $("#startTime").val(vars.dateFrom);
	if ($("#endTime").val()=='') $("#endTime").val(vars.dateTo );
	
	$("#btnQuery").click(function(){
		 queryList(1);
	})
	
	queryList(1,15);
});

function queryList(page,pagesize) {	
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);

	var options = {
		url:"../query/getSupplierStatistics",
		type:"post",
		dataType:"html",
		success:function(data){
			$("#tableDiv").html(data);
		},
		error:function(XMLHttpRequest, textStatus, errorThrown){
			$.error(textStatus+":"+errorThrown);
		}
	};
	$("#form").ajaxSubmit(options);	
}

</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</html>
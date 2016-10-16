<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>车辆信息</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=path%>/assets/js/web-js/views/car.js"></script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		<!-- <ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="###" class="selected">车辆订单统计</a></li>
			<li class="clear"></li>
		</ul> -->
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="car.selectCarListPage" />
			<input type="hidden" name="rp" value="queries/car/carTable" />
			<input type="hidden" name="ssl" value="car.selectCarTotal" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">出团日期:</li>
					<li><input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='${first }'/> 
					—
					<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last }"/> </li>
					<li class="text">团号：</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">产品名称：</li>
					<li><input id="productName"  name="productName" type="text"/></li>
					<li class="clear"/>
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
					<li>	
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li>
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode" style="width:100px;text-align: right;">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
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
	<script type="text/javascript">
	$("#btnQuery").click(function(){
		 queryList(null,$("#searchPageSize").val());
	})
	</script>
</body>
</html>
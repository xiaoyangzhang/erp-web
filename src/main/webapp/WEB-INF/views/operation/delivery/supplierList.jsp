<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>地接项目费用统计</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript" src="<%=staticPath %>/assets/js/table/jquery.table.mergecells.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/operate/supplierPrice.js"></script>
		<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="form">
					<input type="hidden" name="page" id="page"/>
					<input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize }"/>
					<ul>
						<li class="text">出团日期:</li>
						<li><input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/> 
						—
						<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/> </li>
						<li class="text">团号:</li>
						<li><input type="text" name="groupCode" id="groupCode" value=""/> </li>
						<li class="text">项目:</li>
						<li><input type="text" name="itemName" id="itemName" value=""/> </li>
						<li class="text">车队/车牌号:</li>
						<li><input type="text" name="carInfo" id="carInfo" value=""/> </li>
						<li class="text">地接社:</li>
						<li><input type="text" name="supplierName" id="supplierName" value=""/></li>
						<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames"  stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	
						</li>
						<li class="text">计调:</li>
					<li>	
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li><li class="text">团类型</li>
						<li><select id="groupMode" name="groupMode">
								<option value="" selected="selected">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
						</select> </li>
						<li class="text">产品</li>
						<li><input type="text"  name="productName"  id="productName"  value="" /></li>
						<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
					</ul>
				</form>
				<div id="content"></div>
			</div>
		</div>
	</div>
	
</body>
</html>


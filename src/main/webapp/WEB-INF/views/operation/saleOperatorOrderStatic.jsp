<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>销售业绩统计</title>
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/operate/saleOperatorOrderStatic.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="form" method="post" >
					<input type="hidden" name="page" id="page"/>
					<input type="hidden" name="pageSize" id="pageSize" />
					<dd class="inl-bl">
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input type="text"  name="startTime" id="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/> 
							—
							<input type="text"  name="endTime" id="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品:</div>
						<div class="dd_right grey">
							<input type="text" name="productName" value="${groupOrder.tourGroup.productName}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">部门:</div>
						<div class="dd_left">
	    					<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</div>   
					</dd> 	
					<dd class="inl-bl">	
					<div class="dd_left">计调:</div>
						<div class="dd_right">
							<input type="text" name="userNames" stag="userNames" id="operatorName" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${groupOrder.saleOperatorIds}"/> 
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">	
						<div class="dd_left">团类型:</div>
						<div class="dd_right">
							<select id="orderType" name="orderType">
								<option value="" selected="selected">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
							</select>
						</div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
						</div>
						<div class="clear"></div>
					</dd>
				</form>
		</dl>
		<dl class="p_paragraph_content">
			<div id="content"></div>
		</dl>
		</div>
	</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>其他信息</title>
    <%@ include file="../../../include/top.jsp"%>
    <link href="<%=ctx%>/assets/js/web-js/sales/region_dlg.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/grogShop.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/motorcade.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/airTicket.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/railwayTicket.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/guide.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/restaurant.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/otherInfo.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/cities.js" ></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/jquery.autocomplete.js"></script>
</head>
	<body>
		<div class="p_container">
			<ul class="w_tab">
				<li><a href="javascript:void(0);" onclick="toGroupOrder()">订单详情</a></li>
				<li><a href="javascript:void(0);" onclick="toGetRouteList()">行程列表</a></li>
				<li><a href="javascript:void(0);" onclick="toOtherInfo()">其他信息</a></li>
				<li><a href="javascript:void(0);" onclick="togroupRequirement()" class="selected">计调需求</a></li>
				<li class="clear"></li>
			</ul>
			<div class="p_container_sub">
				<dl class="p_paragraph_content">
					<input type="hidden" id="groupId" value="${groupId}"/>
					<input type="hidden" id="stateFinance" name="" value="${stateFinance}" />
					<input type="hidden" id="state" name="" value="${state}" />
					<c:import url="groupRequirement/grogShop.jsp"/>	
					<c:import url="groupRequirement/motorcade.jsp"/>
<%-- 					<c:import url="groupRequirement/airTicket.jsp"/> --%>
<%-- 					<c:import url="groupRequirement/railwayTicket.jsp"/> --%>
					<c:import url="groupRequirement/guide.jsp"/>
					<c:import url="groupRequirement/restaurant.jsp"/>
				</dl>
			</div>
		</div>
	</body>
</html>
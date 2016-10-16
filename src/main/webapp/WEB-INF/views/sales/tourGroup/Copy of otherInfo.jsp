<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="x-ua-compatible" content="IE=7" />
    <title>其他信息</title>
    <%@ include file="../../../include/top.jsp"%>
    <link href="<%=ctx%>/assets/js/web-js/sales/region_dlg.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/budgetItem.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/costItem.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/seatInCoach.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/guest.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/otherInfo.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/card/region-card-data.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/cities.js" ></script>
	<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/jquery.autocomplete.js"></script>
</head>
	<body>
		<div class="p_container">
			<ul class="w_tab">
				<li><a href="javascript:void(0);" onclick="toGroupOrder()">订单详情</a></li>
				<li><a href="javascript:void(0);" onclick="toGetRouteList()">行程列表</a></li>
				<li><a href="javascript:void(0);" onclick="toOtherInfo()" class="selected">其他信息</a></li>
				<li><a href="javascript:void(0);" onclick="togroupRequirement()">计调需求</a></li>
				<li class="clear"></li>
			</ul>
			<div class="p_container_sub">
				<dl class="p_paragraph_content">
					<input type="hidden" id="groupId" value="${groupId}"/>
					<input type="hidden" id="orderId" value="${orderId}"/>
					<input type="hidden" id="stateFinance" name="" value="${stateFinance}" />
					<input type="hidden" id="state" name="" value="${state}" />
					<!-- 收入 -->
					<%-- <c:import url="budgetItem/addBudgetItem.jsp"/>
					<c:import url="budgetItem/editBudgetItem.jsp"/>--%>
					<c:import url="budgetItem/budgetItem.jsp"/> 
					<!-- 成本 -->
					<c:import url="costItem/costItem.jsp"/>
					<%-- <c:import url="costItem/addCostItem.jsp"/>
					<c:import url="costItem/editCostItem.jsp"/> --%>
					<!-- 接送信息 -->
					<c:import url="seatInCoach/seatInCoach.jsp"/>
					<%-- <c:import url="seatInCoach/addSeatInCoach.jsp"/>
					<c:import url="seatInCoach/editSeatInCoach.jsp"/> --%>
					<!-- 添加客人 -->
					<c:import url="guest/guest.jsp"/>
					<c:import url="guest/addGuest.jsp"/>
					<c:import url="guest/editGuest.jsp"/>
				</dl>
			</div>
		</div>
	</body>
</html>

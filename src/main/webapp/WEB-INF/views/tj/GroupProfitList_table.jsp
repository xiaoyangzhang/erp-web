<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table LgTable" style="width:3350px;">
<thead>
	<tr>
		<th width="50" rowspan="2">序号</th>
		<th colspan="7">团信息</th>
		<th colspan="3">收入</th>
		<th colspan="9">支出</th>
		<th colspan="4">合计</th>
	</tr>
	<tr>
		<th style="width:50px;">团号</th>
		<th style="width:100px;">团期</th>
		<th style="width:150px;">人数</th>
		<th style="width:400px;">产品线路</th>
		<th style="width:430px;">组团社</th>
		<th style="width:200px;">地接社</th>
		<th style="width:100px;">计调</th>
		<th style="width:120px;">团费</th>
		<th style="width:120px;">其他收入</th>
		<th style="width:120px;">购物收入</th>
		<th style="width:120px;">地接</th>
		<th style="width:120px;">房费</th>
		<th style="width:120px;">餐费</th>
		<th style="width:120px;">车费</th>
		<th style="width:120px;">门票</th>
		<th style="width:120px;">机票</th>
		<th style="width:120px;">火车票</th>
		<th style="width:120px;">保险</th>
		<th style="width:120px;">其他支出</th>
		<th style="width:120px;">总收入</th>
		<th style="width:120px;">总成本</th>
		<th style="width:120px;">毛利</th>
		<th style="width:120px;">人均毛利</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${page.result }" var="tj" varStatus="status">
<tr>
	<td>${status.index+1}</td>
	<td><a href="javascript:goToGroupStatistics(${tj.groupId},'${tj.groupCode}');">${tj.groupCode }</a></td>
	<td><fmt:formatDate value="${tj.dateStart }" pattern="MM-dd"/>/<fmt:formatDate value="${tj.dateEnd }" pattern="MM-dd"/></td>
	<td>${tj.totalAdult}大${tj.totalChild}小${tj.totalGuide}陪</td>
	<td>【${tj.productBrandName}】${tj.productName}</td>
	<td style="text-align:left;">${tj.orderDetails }</td>
	<td></td>
	<td>${tj.operatorName }</td>
	<td><fmt:formatNumber value="${tj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalProfit}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.profitPerGuest}" pattern="#.##" type="currency"/></td>
</tr>
</c:forEach>
<tr>
	<td colspan="3">本页合计：</td>
	<td colspan="5" style="text-align:left">${pageTotalTj.totalAdult}大${pageTotalTj.totalChild}小${pageTotalTj.totalGuide}陪</td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalProfit}" pattern="#.##" type="currency"/></td>
	<%-- <td><fmt:formatNumber value="${pageTotalTj.profitPerGuest}" pattern="#.##" type="currency"/></td> --%>
	<td>
	<c:set var="totalPerson"   value="${pageTotalTj.totalAdult+pageTotalTj.totalChild+pageTotalTj.totalGuide}"/>
	<c:if test="${totalPerson > 0}">
	<fmt:formatNumber value="${pageTotalTj.totalProfit /totalPerson}" pattern="#.##" type="currency"/>
	</c:if>

	</td>
</tr>

<tr>
	<td colspan="3">合计：</td>
	<td colspan="5" style="text-align:left">${totalTj.totalAdult}大${totalTj.totalChild}小${totalTj.totalGuide}陪</td>
	<td><fmt:formatNumber value="${totalTj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalProfit}" pattern="#.##" type="currency"/></td>
	<%-- <td><fmt:formatNumber value="${totalTj.profitPerGuest}" pattern="#.##" type="currency"/></td> --%>
	<td>
	<c:set var="tPerson"   value="${totalTj.totalAdult+totalTj.totalChild+totalTj.totalGuide}"/>
	<c:if test="${tPerson > 0 }">
	<fmt:formatNumber value="${totalTj.totalProfit / tPerson}" pattern="#.##" type="currency"/>
	</c:if>
	
	</td>
</tr>
</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
		<jsp:param value="${page.page }" name="p" />
		<jsp:param value="${page.totalPage }" name="tp" />
		<jsp:param value="${page.pageSize }" name="ps" />
		<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
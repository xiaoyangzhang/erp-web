<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String staticPath = request.getContextPath();
%>

	<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 4%">序号<i class="w_table_split"></i></th>
			<th style="width: 13%">自编号<i class="w_table_split"></i></th>
			<th style="width:20%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 7%">单价<i class="w_table_split"></i></th>
			<th style="width: 6%">总件数<i class="w_table_split"></i></th>
			<th style="width: 6%">买家账号数<i class="w_table_split"></i></th>
			<th style="width: 7%">总实付金额<i class="w_table_split"></i></th>
			<th style="width: 7%">总应付金额<i class="w_table_split"></i></th>
			<th style="width: 6%">移动端总件数<i class="w_table_split"></i></th>
			<th style="width: 6%">移动端买家账号数<i class="w_table_split"></i></th>
			<th style="width: 7%">移动端总实付金额<i class="w_table_split"></i></th>
			<th style="width: 7%">移动端总应付金额<i class="w_table_split"></i></th>
			<th style="width: 4%">明细<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr><td>${v.count}</td>
				<td>${orders.outerIid}</td>
				<td>${orders.title}</td>
				<td>${orders.price}</td>
				<td>${orders.orders}</td>
				<td>${orders.buyers}</td>
				<td><fmt:formatNumber value="${orders.totalFee}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.payment}" pattern="#.##"/></td>
				<td>${orders.wapOrders eq null?0:orders.wapOrders}</td>
				<td>${orders.wapBuyers eq null?0:orders.wapBuyers}</td>
				<td><fmt:formatNumber value="${orders.wapTotalFee eq null?0:orders.wapTotalFee}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.wapPayment eq null?0:orders.wapPayment}" pattern="#.##"/></td>
				<td><a class="def" href="javascript:void(0)" onclick="detail('${orders.outerIid}')">明细</a></td>
				</tr>
				<c:set var="sumOrders" value="${sumOrders + orders.orders }"/>
				<c:set var="sumBuyers" value="${sumBuyers+ orders.buyers }"/>
				<c:set var="sumTotal" value="${sumTotal + orders.payment }"/>
				<c:set var="sumTotalFee" value="${sumTotalFee + orders.totalFee }"/>
				
					<c:set var="sumOrdersWap" value="${sumOrdersWap + orders.wapOrders }"/>
				<c:set var="sumBuyersWap" value="${sumBuyersWap+ orders.wapBuyers }"/>
				<c:set var="sumTotalWap" value="${sumTotalWap + orders.wapPayment }"/>
				<c:set var="sumTotalFeeWap" value="${sumTotalFeeWap + orders.wapTotalFee }"/>
		</c:forEach></tbody>
		<tfooter>
			<tr class="footer1">
				<td colspan="4" style="text-align: right">本页合计:</td>
				<td><fmt:formatNumber value="${sumOrders}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumBuyers}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalFee}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumOrdersWap}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumBuyersWap}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalFeeWap}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalWap}" pattern="#.##"/></td>
				<td></td>
			</tr>
		</tfooter>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>


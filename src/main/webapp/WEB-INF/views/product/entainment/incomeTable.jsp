<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>订单数<i class="w_table_split"></i></th>
			<th>金额/元<i class="w_table_split"></i></th>
			<th>已收/元<i class="w_table_split"></i></th>
			<th>未收/元<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.supplierName}</td>
				<td>${v.orderCount}</td>
				
				<td><fmt:formatNumber value="${v.total}" pattern="0.00" type="number"/></td>
				<td><fmt:formatNumber value="${v.totalCash}" pattern="0.00" type="number"/></td>
				<td><fmt:formatNumber value="${v.total-v.totalCash}" pattern="0.00" type="number"/></td>
				<td>
					<button type="button" class="button button-rounded button-tinier" onclick="toIncomeDetail(${v.supplier_id})">查看明细</button>
				</td>
			</tr>
			<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total }" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash }" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash }" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
		    <td>${sum_orderCount}</td>
			<td>${sum_totalCount}</td>
			<td>${sum_totalCashCount}</td>
			<td>${sum_totalBalanceCount}</td>
			<td></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

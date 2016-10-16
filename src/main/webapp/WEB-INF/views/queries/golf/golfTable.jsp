<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >商家名称<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			
			<th  >应付<i class="w_table_split"></i></th>
			<th >已付<i class="w_table_split"></i></th>
			<th >未付<i class="w_table_split"></i></th>
			<th >操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td >${v.orderCount}</td>
				<td ><fmt:formatNumber value="${v.totalNum}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${v.totalMon}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.totalCashMon}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.totalMon-v.totalCashMon}" pattern="#.##" type="currency"/></td>
				<td>
					<button type="button" class="button button-rounded button-tinier" onclick="toGolfDetail(${v.supplierId})">查看明细</button>
				</td>
			</tr>
			<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
			
			<c:set var="sum_count" value="${sum_count+v.totalNum}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.totalMon }" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCashMon }" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.totalMon-v.totalCashMon }" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td style="text-align: left" colspan="1" >合计：</td>
		    <td >${sum_orderCount}</td>
		    
		    <td ><fmt:formatNumber value="${sum_count}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>
<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>报账金额<i class="w_table_split"></i></th>
			<th>计划购物<i class="w_table_split"></i></th>
			<th>实际购物<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.groupCode}</td>
				<td>${v.dateStart}</td>
				<td>${v.productName}</td>
				<td>${v.supplierName}</td>
				<td>${v.personCount}</td>
				<td>${v.operatorName}</td>
				<td>${v.guideName}</td>
				<td><c:if test="${v.stateBooking eq 0}">未报账</c:if><c:if test="${v.stateBooking eq 1}">处理中</c:if> <c:if test="${v.stateBooking eq 2}">已报账</c:if></td>
				<td><fmt:formatNumber type="number"  value="${v.total}" pattern="0.00#" /></td>
				<td><fmt:formatNumber type="number"  value="${v.jh}" pattern="0.00#" /></td>
				<td><fmt:formatNumber type="number"  value="${v.sj}" pattern="0.00#" /></td>
				<td>	<a class="def" href="javascript:void(0)" onclick="newWindow('查看报账单','<%=staticPath %>/bookingGuide/finance.htm?bookingId=${v.id }&groupId=${v.groupId}')">查看报账单</a></td>
				
			</tr>
		</c:forEach>
	</tbody>
	
</table>
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

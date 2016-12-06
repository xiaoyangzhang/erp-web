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
			<th style="width: 7%">业务类别<i class="w_table_split"></i></th>
			<th style="width: 13%">平台来源<i class="w_table_split"></i></th>
			<th style="width: 20%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 6%">成人数<i class="w_table_split"></i></th>
			<th style="width: 6%">儿童数<i class="w_table_split"></i></th>
			<th style="width: 7%">团款收入<i class="w_table_split"></i></th>
			<th style="width: 7%">其他收入<i class="w_table_split"></i></th>
			<th style="width: 6%">供应商应付<i class="w_table_split"></i></th>
			<th style="width: 6%">毛利<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr><td>${v.count}</td>
				<td><c:forEach items="${typeList}" var="v" varStatus="vs">
					<c:if test='${orders.orderMode==v.id}'>${v.value}</c:if> 
							</c:forEach></td>
				<td>${orders.supplierName}</td>
				<td>${orders.productName}</td>
				<td>${orders.numAdult}</td>
				<td>${orders.numChild}</td>
				<td><fmt:formatNumber value="${orders.totalIncome}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.otherTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.totalCost}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.totalIncome +orders.otherTotal- orders.totalCost}" pattern="#.##"/></td>
				</tr>
				 <c:set var="sumAdult" value="${sumAdult + orders.numAdult }"/>
				<c:set var="sumChild" value="${sumChild+ orders.numChild }"/>
				<c:set var="sumTotalIncome" value="${sumTotalIncome + orders.totalIncome }"/> 
				<c:set var="sumTotherTotal" value="${sumTotherTotal + orders.otherTotal }"/> 
				<c:set var="sumTotalCost" value="${sumTotalCost + orders.totalCost }"/> 
		</c:forEach></tbody>
		 <tfooter>
			<tr class="footer1">
				<td colspan="4" style="text-align: right">本页合计:</td>
				<td><fmt:formatNumber value="${sumAdult}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumChild}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalIncome}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotherTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalCost}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalIncome+sumTotherTotal-sumTotalCost}" pattern="#.##"/></td>
			</tr>
		</tfooter>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>


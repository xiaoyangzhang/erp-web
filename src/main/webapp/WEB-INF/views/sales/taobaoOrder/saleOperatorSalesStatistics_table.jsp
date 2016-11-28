<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String staticPath = request.getContextPath();
%>

	<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 15%">序号<i class="w_table_split"></i></th>
			<th style="width: 25%">客服名称<i class="w_table_split"></i></th>
			<th style="width: 20%">总件数<i class="w_table_split"></i></th>
			<th style="width: 20%">总实付金额<i class="w_table_split"></i></th>
			<th style="width: 20%">总应付金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr>
				<td>${v.count}</td>
				<td><c:if test="${orders.customerService==null || orders.customerService==''}">000</c:if> 
						<c:if test="${orders.customerService!=null}">${orders.customerService}</c:if></td>
				<td><fmt:formatNumber value="${orders.orders}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.totalFee}" pattern="#.##"/></td>
					<td><fmt:formatNumber value="${orders.payment}" pattern="#.##"/></td>
				</tr>
				<c:set var="sumOrders" value="${sumOrders + orders.orders }"/>
				<c:set var="sumPayment" value="${sumPayment + orders.payment }"/>
				<c:set var="sumTotalFee" value="${sumTotalFee + orders.totalFee }"/>
		</c:forEach>
				</tbody>
				<tfoot>
			<tr class="footer1">
				<td colspan="2" style="text-align: right">本页合计:</td>
				<td><fmt:formatNumber value="${sumOrders}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalFee}" pattern="#.##"/></td>
					<td><fmt:formatNumber value="${sumPayment}" pattern="#.##"/></td>
			</tr>
			</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>
<SCRIPT type="text/javascript">
function toExportWord(){
	window.location = "getOrders.do?startTime=${parameter.startTime}&endTime=${parameter.endTime}"+
	"&orderMode=${parameter.orderMode}"+
	"&supplierName=${parameter.supplierName}"+
	"&productName=${parameter.productName}"+
	"&operType=${parameter.operType}"+
	"&operatorIds=${parameter.operatorIds}"+
	"&groupCode=${parameter.groupCode}"+
	"&receiveMode=${parameter.receiveMode}"+
	"&saleOperatorIds=${parameter.saleOperatorIds}";
}
</SCRIPT>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String staticPath = request.getContextPath();
%>

	<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 2%">序号<i class="w_table_split"></i></th>
			<th style="width: 7%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">日期<i class="w_table_split"></i></th>
			<th style="width: 11%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 8%">商家名称<i class="w_table_split"></i></th>
			<th style="width: 11%">供应商名称<i class="w_table_split"></i></th>
			<th style="width: 4%">业务类型<i class="w_table_split"></i></th>
			<th style="width: 6%">客人信息<i class="w_table_split"></i></th>
			<th style="width: 3%">成人数<i class="w_table_split"></i></th>
			<th style="width: 3%">儿童数<i class="w_table_split"></i></th>
			<th style="width: 4%">客服<i class="w_table_split"></i></th>
			<th style="width: 4%">计调<i class="w_table_split"></i></th>
			<th style="width: 3%">应收<i class="w_table_split"></i></th>
			<th style="width: 3%">已收<i class="w_table_split"></i></th>
			<th style="width: 3%">未收<i class="w_table_split"></i></th>
			<th style="width: 3%">其他应收<i class="w_table_split"></i></th>
			<th style="width: 3%">其他已收<i class="w_table_split"></i></th>
			<th style="width: 3%">其他未收<i class="w_table_split"></i></th>
			<th style="width: 3%">应付<i class="w_table_split"></i></th>
			<th style="width: 3%">已付<i class="w_table_split"></i></th>
			<th style="width: 3%">未付<i class="w_table_split"></i></th>
			<th style="width: 3%">毛利<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr>
				<td>${v.count}</td>
				<td>${orders.groupCode}</td>
				<td>${orders.dateStart}</td>
				<td>${orders.productName}</td>
				<td>${orders.businessName}</td>
				<td>${orders.supplierName}</td>
				<td><c:forEach items="${typeList}" var="v" varStatus="vs">
					<c:if test='${orders.orderMode==v.id}'>${v.value}</c:if> 
						</c:forEach></td>
				<td>${orders.receiveMode}</td>
				<td>${orders.numAdult}</td>
				<td>${orders.numChild}</td>
				<td>${orders.saleOperatorName}</td>
				<td>${orders.operatorName}</td>
				<td><fmt:formatNumber value="${orders.total}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.totalCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.totalBalance}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.otherTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.otherTotalCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.otherTotalBalance}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.cost}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.costCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.costBalance}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.groupCost}" pattern="#.##"/></td>
				</tr>
				<c:set var="sumAdult" value="${sumAdult + orders.numAdult }"/>
				<c:set var="sumChild" value="${sumChild + orders.numChild }"/>
				 <c:set var="sumTotal" value="${sumTotal + orders.total }"/>
				<c:set var="sumTotalCash" value="${sumTotalCash+ orders.totalCash }"/>
				<c:set var="sumTotalBalance" value="${sumTotalBalance + orders.totalBalance }"/>
				<c:set var="sumCost" value="${sumCost + orders.cost }"/>
				<c:set var="sumCostCash" value="${sumCostCash + orders.costCash }"/>
				<c:set var="sumCostBalance" value="${sumCostBalance + orders.costBalance }"/>
				<c:set var="sumGroupCost" value="${sumGroupCost + orders.groupCost }"/>
				<c:set var="sumOtherTotal" value="${sumOtherTotal + orders.otherTotal }"/>
				<c:set var="sumOtherTotalCash" value="${sumOtherTotalCash + orders.otherTotalCash }"/>
				<c:set var="sumOtherBalanceTotal" value="${sumOtherBalanceTotal + orders.otherTotalBalance }"/>
		</c:forEach>
				</tbody>
				<tfoot>
			<tr class="footer1">
				<td colspan="8" style="text-align: right">本页合计:</td>
				<td><fmt:formatNumber value="${sumAdult}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumChild}" pattern="#.##"/></td>
				<td></td>
				<td></td>
				<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotalBalance}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumOtherTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumOtherTotalCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumOtherBalanceTotal}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumCost}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumCostCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumCostBalance}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumGroupCost}" pattern="#.##"/></td>
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
	"&orderNo=${parameter.orderNo}"+
	"&supplierName=${parameter.supplierName}"+
	"&productName=${parameter.productName}"+
	"&operType=${parameter.operType}"+
	"&operatorIds=${parameter.operatorIds}"+
	"&groupCode=${parameter.groupCode}"+
	"&receiveMode=${parameter.receiveMode}"+
	"&saleOperatorIds=${parameter.saleOperatorIds}";
}
</SCRIPT>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String staticPath = request.getContextPath();
%>
<!-- 	<SCRIPT type="text/javascript">
	$(function(){	
		alert($("#orderId").val())
	})
	</SCRIPT> -->

	<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">订单号<i class="w_table_split"></i></th>
			<th style="width: 5%">旺旺号<i class="w_table_split"></i></th>
			<th style="width: 15%">产品<i class="w_table_split"></i></th>
			<th style="width: 20%">套餐<i class="w_table_split"></i></th>
			<th style="width: 8%">付款时间<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="">卖家备注<i class="w_table_split"></i></th>
			<th style="width: 5%">状态<i class="w_table_split"></i></th>
			<th style="width: 4%">选择</th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:set var="sumTotal" value="0"/>
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
		 <tr >
				<td>${v.count}</td>
				<td>${orders.tid}</td>
				<td>${orders.buyerNick}</td>
				<td style="text-align:left;">${orders.title}</td>
				<td style="text-align:left;">${orders.skuPropertiesName}</td>
				<td><fmt:formatDate value="${orders.created}" pattern="yyyy-MM-dd" /><br/><fmt:formatDate value="${orders.created}" pattern="HH:mm:ss" /></td>
				<td>${orders.payment}</td>
				<td style="text-align:left;">${fn:escapeXml(orders.sellerMemo)}</td>
				<td><c:if test="${orders.myState=='NEW'}"><font color="green">未组单</c:if> 
						<c:if test="${orders.myState=='CONFIRM'}">已组单</c:if> 
						<c:if test="${orders.myState=='CANCEL'}"><font color="red">废弃</c:if> </td>
				<td><input type="checkbox"  id="orderId"  name="orderId" <c:if test="${orders.myState=='CONFIRM'}"> disabled="disabled"</c:if> value="${orders.id}" /></td>
				</tr>
				<c:set var="sumTotal" value="${sumTotal + orders.payment }"/>
				
		</c:forEach>
			<tr>
				<td colspan="2" style="text-align: right">合计:</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>


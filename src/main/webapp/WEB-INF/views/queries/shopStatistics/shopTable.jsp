<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<colgroup>
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>购物店<i class="w_table_split"></i></th>
			<th>团数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>进店数<i class="w_table_split"></i></th>
			<th>计划销售<i class="w_table_split"></i></th>
			<th>实际销售<i class="w_table_split"></i></th>
			<th>差额<i class="w_table_split"></i></th>
			<th>完成比<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.supplier_name }</td>
				<td><fmt:formatNumber value="${v.group_num }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.total_adult+v.total_child+v.total_guide }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.person_num }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.planSales }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.factSales }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.factSales-v.planSales }" type="currency" pattern="#.##"/></td>
				<td>
					<c:if test="${v.planSales!='0.0000' and v.factSales!='0.0000'}">
							<fmt:formatNumber value="${v.factSales/v.planSales }" type="percent" />
					</c:if>
					<c:if test="${v.planSales=='0.0000' or v.factSales=='0.0000'}">
							0%
					</c:if>
				</td>
				<td><fmt:formatNumber value="${v.payReturn }" type="currency" pattern="#.##"/></td>
			</tr>
				<c:set var="countGroup" value="${countGroup+v.group_num}" />
				<c:set var="numPersonGroup" value="${numPersonGroup+v.total_adult+v.total_child+v.total_guide }" />
				<c:set var="countShop" value="${countShop+v.person_num }" />
				<c:set var="planSales" value="${planSales+v.planSales }" />
				<c:set var="factSales" value="${factSales+v.factSales }" />
				<c:set var="fp" value="${fp+v.factSales-v.planSales }" />
				<c:set var="payReturn" value="${payReturn+v.payReturn }" />
		</c:forEach>
	</tbody>
		<tr>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
			<td><fmt:formatNumber value="${countGroup }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${numPersonGroup }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${countShop }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${planSales }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${factSales }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${fp }" type="currency" pattern="#.##"/></td>
			<td></td>
			<td><fmt:formatNumber value="${payReturn }" type="currency" pattern="#.##"/></td>
		</tr>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

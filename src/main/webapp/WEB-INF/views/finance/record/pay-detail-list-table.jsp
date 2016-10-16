<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="20%" />
	<col width="15%" />
	<col width="15%" />
	<c:if test="${reqpm.supplierType eq 16 }">
		<col width="10%" />
	</c:if>
	<col width="10%" />
	<col width="20%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<c:if test="${reqpm.supplierType eq 16 }">
				<th>人数<i class="w_table_split"></i></th>
			</c:if>
			<th>单价<i class="w_table_split"></i></th>
			<th>数量<i class="w_table_split"></i></th>
			<th>免去数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>
					${item.item_name}
					<c:if test="${not empty item.ticket_flight }"> <br/> ${item.ticket_flight } </c:if>
				</td>
				<c:if test="${reqpm.supplierType eq 16 }">
					<td><fmt:formatNumber value="${item.num_person}" pattern="#.##"/></td>
				</c:if>
				<td><fmt:formatNumber value="${item.unit_price }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.num_times }" pattern="#.##"/></td>
				<td><c:if test="${item.item_num_minus!=null }"><fmt:formatNumber value="${item.item_num_minus }" pattern="#.##"/></c:if><c:if test="${item.item_num_minus==null }">0</c:if></td>
				<td><fmt:formatNumber value="${item.total_price }" pattern="#.##"/></td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash+item.total_price }" />
		</c:forEach>
		<tr>
			<td></td>
			<c:if test="${reqpm.supplierType eq 16 }">
				<td></td>
			</c:if>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="20%" />
	<%-- <col width="30%" /> --%>
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<!-- <th>摘要<i class="w_table_split"></i></th> -->
			<th>单价<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${item.item_name}</td>
				<%-- <td>${item.remark}</td> --%>
				<td>
					<c:if test="${not empty item.unit_price}">
						<fmt:formatNumber value="${item.unit_price }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.unit_price}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.num_times}">
						<fmt:formatNumber value="${item.num_times }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.num_times}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.num_person}">
						<fmt:formatNumber value="${item.num_person }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.num_person}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.total_price}">
						<fmt:formatNumber value="${item.total_price }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.total_price}">0</c:if>
				</td>
				<td>${item.remark }</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash+item.total_price }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
<!-- 			<td></td> -->
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
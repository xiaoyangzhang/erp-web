<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="4%" />
	<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
		<col width="10%" />
		<col width="15%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</c:if>
	<c:if test="${'1' == reqpm.supplierType || '16' == reqpm.supplierType}">
		<col width="10%" />
		<col width="15%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
				<th>类型<i class="w_table_split"></i></th>
				<th>项目<i class="w_table_split"></i></th>
				<th>日期<i class="w_table_split"></i></th>
				<th>数量<i class="w_table_split"></i></th>
				<th>价格<i class="w_table_split"></i></th>
				<th>免去数<i class="w_table_split"></i></th>
				<th>金额<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${'1' == reqpm.supplierType || '16' == reqpm.supplierType}">
				<th>项目<i class="w_table_split"></i></th>
				<th>备注<i class="w_table_split"></i></th>
				<th>单价<i class="w_table_split"></i></th>
				<th>人数<i class="w_table_split"></i></th>
				<th>次数<i class="w_table_split"></i></th>
				<th>金额<i class="w_table_split"></i></th>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
					<td style="text-align: left">${item.type2_name}</td>
					<td style="text-align: left">${item.type1_name}</td>
					<td>${item.item_date}</td>
					<td ><fmt:formatNumber value="${item.item_num }" pattern="#.##" type="number"/></td>
					<td ><fmt:formatNumber value="${item.item_price }" pattern="#.##" type="currency"/></td>
					<td ><fmt:formatNumber value="${item.item_num_minus }" pattern="#.##" type="number"/></td>
					<td ><fmt:formatNumber value="${item.item_total }" pattern="#.##" type="currency"/></td>
				</c:if>
				<c:if test="${'1' == reqpm.supplierType || '16' == reqpm.supplierType}">
					<td style="text-align: left">${item.item_name}</td>
					<td>${item.remark}</td>
					<td ><fmt:formatNumber value="${item.unit_price }" pattern="#.##" type="number"/></td>
					<td><fmt:formatNumber value="${item.num_person}" pattern="#.##" type="number"/></td>
					<td><fmt:formatNumber value="${item.num_times}" pattern="#.##" type="number"/></td>
					<td ><fmt:formatNumber value="${item.total_price }" pattern="#.##" type="number"/></td>
				</c:if>
			</tr>
		</c:forEach>
	</tbody>
</table>
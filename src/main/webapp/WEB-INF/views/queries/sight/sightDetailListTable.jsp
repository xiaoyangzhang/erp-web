<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="4%" />
	<col width="20%" />
	<col width="15%" />
	<col width="15%" />
	<col width="15%" />
	<col width="15%" />
	<col width="15%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>数量<i class="w_table_split"></i></th>
			<th>满减数量<i class="w_table_split"></i></th>
			<th>价格<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left">${item.type1_name}</td>
				<td>${item.item_date}</td>
				<td style="text-align: left"><fmt:formatNumber value="${item.item_num }" pattern="#.##" type="number"/></td>
				<td style="text-align: left"><fmt:formatNumber value="${item.item_num_minus }" pattern="#.##" type="number"/></td>
				<td style="text-align: left"><fmt:formatNumber value="${item.item_price }" pattern="#.##" type="currency"/></td>
				<td style="text-align: left"><fmt:formatNumber value="${item.item_total }" pattern="#.##" type="currency"/></td>
			</tr>
		</c:forEach>
	</tbody>
</table>
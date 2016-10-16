<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="10%" />
	<col width="5%" />
	<col width="10%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>单据号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>我方银行<i class="w_table_split"></i></th>
			<th>我方户名<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>对方银行<i class="w_table_split"></i></th>
			<th>对方户名<i class="w_table_split"></i></th>
			<th>摘要<i class="w_table_split"></i></th>
			<th>
				<c:if test="${reqpm.payDirect eq 0 }">本次付款</c:if>
				<c:if test="${reqpm.payDirect eq 1 }">本次收款</c:if>
				<i class="w_table_split"></i>
			</th>
			<th>操作员<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${item.pay_code}</td>
				<td><fmt:formatDate value="${item.pay_date}" pattern="yyyy-MM-dd" /></td>
				<td>${item.left_bank}</td>
				<td>${item.left_bank_holder}</td>
				<td>${item.pay_type}</td>
				<td>${item.right_bank}</td>
				<td>${item.right_bank_holder}</td>
				<td>${item.remark}</td>
				<td><fmt:formatNumber value="${item.cash }" pattern="#.##"/></td>
				<td>${item.user_name}</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash+item.cash }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
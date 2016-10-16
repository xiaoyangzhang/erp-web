<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" border="1" class="w_table">
	<col width="3%"/>
	<col width="30%"/>
	<col width="30%"/>
	<col width="5%"/>
	<col width="8%"/>
	<col width="8%"/>
	<thead>
		<tr>
			<th>序号</th>
			<th>商家名称</th>
			<th>明细</th>
			<th>报账金额</th>
			<th>报账人</th>
			<th>报账时间</th>
		</tr>	
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${item.supplier_name}</td>
				<td>${item.details}</td>
				<td>
					<c:if test="${item.supplier_type eq 120 }">
						<c:set var="itemCash" value="${0-item.cash }" />
						<fmt:formatNumber value="${0-item.cash }" type="number" pattern="#.##"/>
					</c:if>
					<c:if test="${item.supplier_type ne 120 }">
						<c:set var="itemCash" value="${item.cash }" />
						<fmt:formatNumber value="${item.cash }" type="number" pattern="#.##"/>
					</c:if>
				</td>
				<td>${item.user_name}</td>
				<td>${item.pay_date}</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash + itemCash }" />
		</c:forEach>
			<tr>
				<td></td>
				<td></td>
				<td>合计</td>
				<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
				<td></td>
				<td></td>
			</tr>
	</tbody>
</table>
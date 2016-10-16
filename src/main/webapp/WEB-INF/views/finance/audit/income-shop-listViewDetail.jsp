<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="20%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>返回比<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${item.goods_name}</td>
				<td>
					<c:if test="${not empty item.buy_total}">
						<fmt:formatNumber value="${item.buy_total }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.buy_total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.buy_total}">
						<fmt:formatNumber value="${item.repay_total/item.buy_total }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.buy_total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.repay_total}">
						<fmt:formatNumber value="${item.repay_total }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.repay_total}">0</c:if>
				</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash+item.buy_total }" />
			<c:set var="sum_repay_total" value="${sum_repay_total+item.repay_total }" />
		</c:forEach>
		<tr>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_repay_total }" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
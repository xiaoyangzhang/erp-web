<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="80px" />
	<col />
	<col width="170px" />
	<col width="150px" />	
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>			
			<th>产品名称<i class="w_table_split"></i></th>
			<th>客人数<i class="w_table_split"></i></th>
			<th>比例<i class="w_table_split"></i></th>			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>【${item.productBrandName}】${item.productName }</td>
				<td><fmt:formatNumber value="${item.guestCnt}" pattern="#.##"/></td>
				<td>
					<fmt:formatNumber value="${(item.guestCnt/total)*100}" pattern="#.##"/>%
				</td>
			</tr>
			
			<%-- <c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+item.balance }" /> --%>
		</c:forEach>		
		<tr>			
			<td></td>
			<td style="text-align: right;font-weight:bold;">总计:</td>
			<td><fmt:formatNumber value="${total }" pattern="#.##" type="currency"/></td>			
			<td></td>
		</tr>
	</tbody>
</table>
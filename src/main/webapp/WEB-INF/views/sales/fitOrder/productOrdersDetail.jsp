<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
.w_table>tbody>tr:nth-child(odd){background-color:#fff;}
</style>
<table class="w_table">
	<thead>
		<tr>
			<th style="width: 5%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">出发日期<i class="w_table_split"></i></th>
			<th style="width: 20%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 15%">组团社<i class="w_table_split"></i></th>
			<th style="width: 5%">接站牌<i class="w_table_split"></i></th>
			<th style="width: 5%">客源地<i class="w_table_split"></i></th>
			<th style="width: 5%">联系人<i class="w_table_split"></i></th>
			<th style="width: 5%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="width: 5%">销售<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 5%">输单员<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
			<tr>
				<td>${v.count}</td>
				<td style="text-align: left;">${groupOrder.tourGroup.groupCode}</td>
				<td>${groupOrder.departureDate}</td>
				<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
				<td style="text-align: left;">${groupOrder.supplierName}</td>
				<td>${groupOrder.receiveMode}</td>
				<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
				<td>${groupOrder.contactName}</td>
				<td>${groupOrder.numAdult }大${groupOrder.numChild}小</td>
				<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
				<td>${groupOrder.saleOperatorName}</td>
				<td>${groupOrder.operatorName}</td>
				<td>${groupOrder.creatorName}</td>
				</tr>
		</c:forEach>
	</tbody>
</table>


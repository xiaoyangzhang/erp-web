<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
 
<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >商家名称<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			<th >免去数<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			<th >期初未付<i class="w_table_split"></i></th>
			<th  >应付<i class="w_table_split"></i></th>
			<th >已付<i class="w_table_split"></i></th>
			<th >未付<i class="w_table_split"></i></th>
			<th >总未付<i class="w_table_split"></i></th>
			<th >操作<i class="w_table_split"></i></th>
		</tr>
		
		
	</thead>
	<tbody>
	<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td >${v.orderCount}</td>
				<td ><fmt:formatNumber value="${v.totalNumMinus}" pattern="#.##" type="number"/></td>
				<td >
				<fmt:formatNumber value="${v.totalNum eq null?0:v.totalNum}" pattern="#.#" type="number"/>
				</td>
				<td>
					<fmt:formatNumber value="${v.originalTotalBalance eq null?0:v.originalTotalBalance}" pattern="#.##" type="number"/>
				</td>
				<td >
				
				<fmt:formatNumber value="${v.totalMon eq null?0:v.totalMon}" pattern="#.##" type="number"/>
				
				</td>
				<td >
				
				<fmt:formatNumber value="${v.totalCashMon eq null?0:v.totalCashMon}" pattern="#.##" type="number"/>
				
				</td>
				<td >
				
				<fmt:formatNumber value="${v.totalMon-v.totalCashMon eq null?0:(v.totalMon-v.totalCashMon)}" pattern="#.##" type="currency"/>
				
				</td>
				<c:set var="sumBalance" value="${v.originalTotalBalance+v.totalMon-v.totalCashMon }"/>
				<td><fmt:formatNumber value="${sumBalance }" pattern="#.##" type="currency"/>
				</td>
				<td>
					<button type="button" class="button button-rounded button-tinier" onclick="toDetail(${v.supplierId},'${v.supplierName}')">明细</button>
				</td>
			</tr>
			<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
			<c:set var="sum_minus" value="${sum_minus+v.totalNumMinus}" />
			<c:set var="sum_originalDebt" value="${sum_originalDebt+v.originalTotalBalance}" />
			<c:set var="sum_roomCount" value="${sum_roomCount+v.totalNum}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.totalMon }" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCashMon }" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.totalMon-v.totalCashMon }" />
			<c:set var="sum_originalBalance" value="${sum_originalBalance+sumBalance}" />
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td></td>
			<td colspan="1" style="text-align: center">页合计：</td>
		    <td >${sum_orderCount}</td>
		    <td ><fmt:formatNumber value="${sum_minus }" pattern="#.#" type="number"/></td>
		    <td ><fmt:formatNumber value="${sum_roomCount eq null?0:sum_roomCount}" pattern="#.#" type="number"/></td>
			<td><fmt:formatNumber value="${sum_originalDebt eq null?0:sum_originalDebt}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum_totalCount eq null?0:sum_totalCount}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum_totalCashCount eq null?0:sum_totalCashCount}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum_totalBalanceCount eq null?0:sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_originalBalance eq null?0:sum_originalBalance}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
		<tr class="footer2">
			<td></td>
			<td colspan="1" style="text-align: center">总合计：</td>
		    <td >${sum.orderCount}</td>
		    <td ><fmt:formatNumber value="${sum.totalNumMinus }" pattern="#.#" type="number"/></td>
		    <td ><fmt:formatNumber value="${sum.totalNum}" pattern="#.#" type="number"/></td>
			<td><fmt:formatNumber value="${sum.originalTotalBalance}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum.total}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="currency"/></td>
		    <td ><fmt:formatNumber value="${sum.total-sum.totalCash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum.total-sum.totalCash + sum.originalTotalBalance}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr></tfoot>		
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
	<jsp:param value="hotelQueryList" name="fnQuery" />
</jsp:include>

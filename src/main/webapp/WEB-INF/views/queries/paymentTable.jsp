<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="w_table" id="payTable">
<colgroup>
		<col width="5%" />
		<col width="15%" />
		<col width="10%" />
		<col width=10%" />
		<col width=10%" />
		<col width=10%" />
		<col width=10%" />
		<col width="10%" />
		<col width=10%" />
		<col width="10%" />
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>期初欠收<i class="w_table_split"></i></th>
			<th>订单数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>团款<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>总未收<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td><fmt:formatNumber value="${v.preTotal}" type="currency" pattern="#.##"/></td>
				<td>${v.orderCount}</td>
				<td>${v.num_adult==null?0:v.num_adult}大${v.num_child==null?0:v.num_child}小${v.num_guide==null?0:v.num_guide}陪</td>
				<td><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.totalCash}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.totalBalance+v.preTotal-v.preTotal}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.totalBalance+v.preTotal}" type="currency" pattern="#.##"/></td>
				<td>
					<a href="javascript:void(0);" class="def" onclick="paymentDetail(${v.supplier_id})">明细</a>
					<a href="javascript:void(0);" class="def" id="toPaymentPreview" target="_blank" onclick="toPaymentPreview('${v.supplier_id}',this)">对账明细</a>
				</td>
			</tr>
			<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
			<c:set var="sum_adult" value="${sum_adult+v.num_adult}" />
			<c:set var="sum_child" value="${sum_child+v.num_child}" />
			<c:set var="sum_guide" value="${sum_guide+v.num_guide}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total }" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash }" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.totalBalance+v.preTotal }" />
			<c:set var="sum_preTotal" value="${sum_preTotal+v.preTotal }" />
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
			<td><fmt:formatNumber value="${sum_preTotal}" type="currency" pattern="#.##"/></td>
		    <td><fmt:formatNumber value="${sum_orderCount}" type="currency" pattern="#.##"/></td>
         	<td>
         		<fmt:formatNumber value="${sum_adult}" type="currency" pattern="#.##"/>+
         		<fmt:formatNumber value="${sum_child}" type="currency" pattern="#.##"/>+
         		<fmt:formatNumber value="${sum_guide}" type="currency" pattern="#.##"/>
         	</td>
			<td><fmt:formatNumber value="${sum_totalCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalCashCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalBalanceCount-sum_preTotal}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalBalanceCount}" type="currency" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="20%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>地接社<i class="w_table_split"></i></th>
			<th>订单数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>期初未付<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>总未付<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left">${item.supplier_name}</td>
				<td ><fmt:formatNumber value="${item.order_num}" pattern="#.##"/></td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td>
					<fmt:formatNumber value="${item.originalTotalBalance eq null?0:item.originalTotalBalance}" pattern="#.##" type="number"/>
				</td>
				<td><fmt:formatNumber value="${item.total }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total-item.total_cash}" pattern="#.##" type="currency"/></td>
				<c:set var="sumBalance" value="${item.originalTotalBalance+item.total-item.total_cash }"/>
				<td><fmt:formatNumber value="${sumBalance }" pattern="#.##" type="currency"/>
				</td>
				<td><a href="javascript:void(0)" onclick="deliveryDetail('${item.supplier_id }')" class="def">明细</a>
				</td>
			</tr>
			
			 <c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.total_cash }" />
			<%-- <c:set var="sum_balance" value="${sum_balance+item.total-item.total_cash }" /> --%>
			<c:set var="sum_originalTotal" value="${sum_originalTotal+item.originalTotalBalance }" />
			<c:set var="sum_adult" value="${sum_adult+item.total_adult }" />
			<c:set var="sum_child" value="${sum_child+item.total_child }" />
			<c:set var="sum_guide" value="${sum_guide+item.total_guide }" />
		</c:forEach>
		</tbody>
		<tfoot>
		 <tr class="footer1">
			<td></td>
			<td></td>
			<td>合计:</td>
			<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
			<td ><fmt:formatNumber value="${sum_originalTotal }" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total-sum_cash }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum_total-sum_cash+sum_originalTotal}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr> 
		<tr class="footer2">
			<td></td>
			<td></td>
			<td >总计:</td>
			<td>${sum.total_adult }大${sum.total_child }小${sum.total_guide }陪</td>
			
			<td ><fmt:formatNumber value="${originalDelivery.originalTotalBalance }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum.total }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum.total_cash }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum.total-sum.total_cash}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${originalDelivery.originalTotalBalance+sum.total-sum.total_cash}" pattern="#.##" type="currency"/></td>
			
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
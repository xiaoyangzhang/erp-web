<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
$(function(){
	
	$('#guestTable').mergeCell({
	    // 目前只有cols这么一个配置项, 用数组表示列的索引,从0开始 
	    // 然后根据指定列来处理(合并)相同内容单元格 
	    cols: [0]
	});
});
</script>
<table cellspacing="0" cellpadding="0" class="w_table" id="guestTable">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >组团社<i class="w_table_split"></i></th>
			<th >销售计调<i class="w_table_split"></i></th>
			<th >线路<i class="w_table_split"></i></th>
			<th >成人数<i class="w_table_split"></i></th>
			<th >儿童数<i class="w_table_split"></i></th>
		</tr>
		
		
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td rowspan="${v.rowSpan+1}">${vs.count}</td>
				<td style="text-align: left" rowspan="${v.rowSpan+1}">${v.supplierName }<input type="hidden" value="${v.supplierId}" /></td>
				
				<c:forEach items="${v.orderList }" var="order">
				<tr>
				<td >${order.saleOperatorName }<input type="hidden" value="${order.saleOperatorId}" /></td>
				<td >${order.productBrandName}</td>
				<td >${order.numAdult==null?0:order.numAdult}</td>
				<td >${order.numChild==null?0:order.numChild}</td>
				<c:set var="sum_adult" value="${sum_adult+order.numAdult }" />
				<c:set var="sum_child" value="${sum_child+order.numChild }" />
				</tr>
				</c:forEach>
				
			</tr>
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="4">合计：</td>
			<td>${sum_adult }</td>
			<td>${sum_child }</td>

		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

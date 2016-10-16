<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table id="detailOrderTable" cellspacing="0" cellpadding="0" class="w_table">
	<c:if test="${reqpm.supplierType eq 1}">
		<col width="5%" />
		<col width="5%" />
		<col width="12%" />
		<col width="20%" />
		<col width="15%" />
		<col width="10%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="8%" />
	</c:if>
	<c:if test="${reqpm.supplierType eq 16}">
		<col width="5%" />
		<col width="5%" />
		<col width="15%" />
		<col width="20%" />
		<col width="5%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</c:if>
	
	<c:if test="${reqpm.supplierType ne 1 and reqpm.supplierType ne 16}">
		<col width="3%" />
		<col width="3%" />
		<col width="5%" />
		<col width="19%" />
		<col width="5%" />
		<col width="5%" />
		<col width="19%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
	</c:if>
			
	<thead>
		<tr>
			<th><input id="select_all" type="checkbox" onclick="selectAll()" value=""/><i class="w_table_split"></i></th>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			
			<c:if test="${reqpm.supplierType eq 1}">
				<th>日期<i class="w_table_split"></i></th>
				<th>接站牌<i class="w_table_split"></i></th>
			</c:if>
			
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			
			<c:if test="${reqpm.supplierType ne 1 and reqpm.supplierType ne 16}">
				<th>明细<i class="w_table_split"></i></th>
			</c:if>
			
			<th>金额<i class="w_table_split"></i></th>
			<th>已结算<i class="w_table_split"></i></th>
			<th>未结算<i class="w_table_split"></i></th>
			<th>是否对账<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>
					<input type="checkbox" 
						<c:if test="${not empty item.verify_code || 1 ne item.state_finance}">disabled</c:if> 
					value="${item.id }"/>
				</td>
				<td class="serialnum">${status.index+1}</td>
				<td>${item.group_code}</td>
				<td>【${item.product_brand_name}】${item.product_name}</td>
				<c:if test="${reqpm.supplierType eq 1}">
					<td>
						<fmt:formatDate value="${item.date_start}" pattern="yyyy-MM-dd" />/
						<fmt:formatDate value="${item.date_end}" pattern="yyyy-MM-dd" />
					</td>
					<td>${item.receive_mode}</td>
				</c:if>
				<td>${item.person_count}</td>
				<td>${item.operator_name}</td>
				<c:if test="${reqpm.supplierType ne 1 and reqpm.supplierType ne 16}">
					<td>${item.details}</td>
				</c:if>
				<td><fmt:formatNumber value="${item.total}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_not}" pattern="#.##"/></td>
				
				<td>
					<c:if test="${empty item.verify_code && 1 ne item.state_finance}">未审核</c:if>
					<c:if test="${empty item.verify_code && 1 eq item.state_finance}">未对账</c:if>
					<c:if test="${not empty item.verify_code && 1 eq item.state_finance}">已对账</c:if>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
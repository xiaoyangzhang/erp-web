<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>

<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>团计调<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>明细<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>
					<%-- <c:forEach items="${orderMap }" var="order">
					<c:if test="${v.groupId eq order.key }"> --%>
				<%-- 	<c:forEach items="${order.value }" var="o">
 --%>					<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="loadOrderId(${v.groupId})">${v.groupCode}</a></c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/groupOrder/toFitEdit.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
                  	<%-- </c:forEach> --%>
                  	<%-- </c:if>
				</c:forEach> --%>
				</td>
				<td>${v.operatorName}</td>
				<td style="text-align: left">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td style="text-align: left" >
					<c:choose>
						<c:when test="${v.detailList.size() eq 0 }">无数据</c:when>
						<c:otherwise>
						
						<c:forEach items="${v.detailList }" var="dl">
						
				<fmt:formatDate value="${dl.itemDate }"
														pattern="yyyy-MM-dd" />【${dl.type1Name }】
						<fmt:formatNumber value="${dl.itemPrice}" pattern="#.##" type="currency"/>*
					(<fmt:formatNumber value="${dl.itemNum }" pattern="#.#" type="number"/>-
					<fmt:formatNumber value="${dl.itemNumMinus }" pattern="#.#" type="number"/>)
						</c:forEach>
						</c:otherwise>
					</c:choose>
					
					
				</td>
				<td>${v.cashType}</td>
				<td ><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
				<td > <fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td>
				<td >${v.remark }</td>
			</tr>
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			<td></td>
			<td colspan="6" style="text-align: left">合计：</td>
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			
			<td></td>
			<td colspan="6" style="text-align: left">总计：</td>
			<td ><fmt:formatNumber value="${sum.totalCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum.totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum.totalBalanceCount}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

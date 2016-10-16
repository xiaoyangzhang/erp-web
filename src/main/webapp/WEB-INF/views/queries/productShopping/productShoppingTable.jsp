<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
<col width="5%"><col width="15%"><col width="10%"><col width="5%"><col width="8%"><col width="8%">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >组团社<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			<th >收客人数（成人）<i class="w_table_split"></i></th>
			
			<th >购物<i class="w_table_split"></i></th>
			<th >人均购物<i class="w_table_split"></i></th>
		</tr>
		
		
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td style="text-align: left">${v.productBrandName}</td>
				
				<td >${v.totalAdult}</td>
				
				<td><fmt:formatNumber value="${v.buyTotal }" pattern="#.##" type="number"/></td>
				<td>
					<c:choose>
					<c:when test="${v.totalAdult eq 0 or v.totalAdult eq null}">0</c:when>
					<c:otherwise>
					
					<fmt:formatNumber value="${v.buyTotal /v.totalAdult}" pattern="#.##" type="number"/></c:otherwise>
					</c:choose>
				</td>
			</tr>
			<c:set var="sum_buyTotal" value="${sum_buyTotal+v.buyTotal }" />
			
			<c:set var="sum_adult" value="${sum_adult+v.totalAdult}" />
			
			
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="3" >本页合计：</td>
			
			<td>${ sum_adult}</td>
		     
		    <td><fmt:formatNumber value="${sum_buyTotal }" pattern="#.##" type="number"/></td>
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

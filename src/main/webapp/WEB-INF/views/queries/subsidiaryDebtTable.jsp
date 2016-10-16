<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="w_table" id="payTable">
<colgroup>
		<col width="5%" />
		<col width="20%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="15%" />
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>乐景<i class="w_table_split"></i></th>
			<th>乐美<i class="w_table_split"></i></th>
			<th>悦享<i class="w_table_split"></i></th>
			<th>优派<i class="w_table_split"></i></th>
			<th>乐途<i class="w_table_split"></i></th>
			<th>总计<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.supplier_name}</td>
				<td><fmt:formatNumber value="${v.ljj}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.lmm}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.yxx}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.ypp}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.ltt}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
			</tr>
			<c:set var="sum_lj" value="${sum_lj+v.ljj}" />
			<c:set var="sum_lm" value="${sum_lm+v.lmm}" />
			<c:set var="sum_yx" value="${sum_yx+v.yxx}" />
			<c:set var="sum_yp" value="${sum_yp+v.ypp}" />
			<c:set var="sum_lt" value="${sum_lt+v.ltt}" />
			<c:set var="sum_total" value="${sum_total+v.total}" />
			
		</c:forEach>
	</tbody>
	<tbody>
		 <tr>
			<td colspan="2" >合计：</td>
			<td><fmt:formatNumber value="${sum_lj }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_lm }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_yx}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_yp }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${ sum_lt }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${ sum_total}" type="currency" pattern="#.##"/></td>
		</tr> 
	</tbody>
	<tbody>
		  <tr>
			<td colspan="2" >总计：</td>
			<td><fmt:formatNumber value="${sum.ljj }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.lmm}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.yxx }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.ypp}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${ sum.ltt}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${ sum.total}" type="currency" pattern="#.##"/></td>
		</tr>  
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

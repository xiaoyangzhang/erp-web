<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>姓名<i class="w_table_split"></i></th>
			<th>导游证号<i class="w_table_split"></i></th>
			<th>已报账<i class="w_table_split"></i></th>
			<th>未报账<i class="w_table_split"></i></th>
			<th>小计<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计划购物金额<i class="w_table_split"></i></th>
			<th>实际购物金额<i class="w_table_split"></i></th>
			<th>实际购物人均<i class="w_table_split"></i></th>
			<th>完成率<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.guideName}（${v.guideMobile}）</td>
				<td>${v.guideNo}</td>
				<td>${v.state2}</td>
				<td>${v.state0}</td>
				<td>${v.state2+v.state0}</td>
				<td>${v.adult}</td>
				<td><fmt:formatNumber type="number"  value="${v.jh}" pattern="0.00#" /></td>
				<td><fmt:formatNumber type="number"  value="${v.sj}" pattern="0.00#" /></td>
				<td><fmt:formatNumber type="number"  value="${v.sj/v.adult}" pattern="0.00#" /></td>
				<td>
				<c:if test="${v.jh == '0.0000'}">0</c:if>
				<c:if test="${v.jh != '0.0000' }">
				 <fmt:formatNumber type="number"  value="${v.sj/v.jh*100}" pattern="0.00#" />
					
				</c:if>
				%
				</td>
				
			</tr>
		</c:forEach>
	</tbody>
	
</table>
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="12%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<thead>
		<tr>
			<td>序号<i class="w_table_split"></i></td>
			<td>商家名称<i class="w_table_split"></i></td>
			
			<td >应付<i class="w_table_split"></i></td>
			<td >已付<i class="w_table_split"></i></td>
			<td >期末余额<i class="w_table_split"></i></td>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.supplier_name}</td>
				<td><fmt:formatNumber value="${item.total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total-item.total_cash}" pattern="#.##" type="currency"/></td>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_total_cash" value="${sum_total_cash+item.total_cash }" />
		</c:forEach>
		<tr>
			<td colspan="2">合计：</td>
			<td><fmt:formatNumber value="${sum_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total-sum_total_cash}" pattern="#.##" type="currency"/></td>
		</tr>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
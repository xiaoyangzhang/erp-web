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
	<col width="7%" />
	<col width="7%" />
	<%-- <col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" /> --%>
	
	<thead>
		<!-- <tr>
			<td rowspan="2">序号<i class="w_table_split"></i></td>
			<td rowspan="2">商家名称<i class="w_table_split"></i></td>
			
			<td colspan="4">应付<i class="w_table_split"></i></td>
			<td colspan="4">已付<i class="w_table_split"></i></td>
			<td colspan="4">欠付<i class="w_table_split"></i></td>
		</tr> -->
		<tr>
			<td >序号<i class="w_table_split"></i></td>
			<td >商家名称<i class="w_table_split"></i></td>
			<td >导游现付<i class="w_table_split"></i></td>
			<td >公司现付<i class="w_table_split"></i></td>
			<td >签单月结<i class="w_table_split"></i></td>
			<td >其它<i class="w_table_split"></i></td>
			<td >合计<i class="w_table_split"></i></td>
			
			<!-- <td >导游现付<i class="w_table_split"></i></td>
			<td >公司现付<i class="w_table_split"></i></td>
			<td >签单月结<i class="w_table_split"></i></td>
			<td >其它<i class="w_table_split"></i></td>
			
			<td >导游现付<i class="w_table_split"></i></td>
			<td >公司现付<i class="w_table_split"></i></td>
			<td >签单月结<i class="w_table_split"></i></td>
			<td >其它<i class="w_table_split"></i></td> -->
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.supplier_name}</td>
				<td><fmt:formatNumber value="${item.dy_total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.gs_total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qd_total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qt_total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.dy_total+item.gs_total+item.qd_total+item.qt_total}" pattern="#.##" type="currency"/></td>
				
				<%-- <td><fmt:formatNumber value="${item.dy_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.gs_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qd_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qt_total_cash}" pattern="#.##" type="currency"/></td>
				
				<td><fmt:formatNumber value="${item.dy_total-item.dy_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.gs_total-item.gs_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qd_total-item.qd_total_cash}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.qt_total-item.qt_total_cash}" pattern="#.##" type="currency"/></td> --%>
				
			</tr>
			<c:set var="sum_dy_total" value="${sum_dy_total+item.dy_total }" />
			<c:set var="sum_gs_total" value="${sum_gs_total+item.gs_total }" />
			<c:set var="sum_qd_total" value="${sum_qd_total+item.qd_total }" />
			<c:set var="sum_qt_total" value="${sum_qt_total+item.qt_total }" />
			<%-- <c:set var="sum_dy_total_cash" value="${sum_dy_total_cash+item.dy_total_cash }" />
			<c:set var="sum_gs_total_cash" value="${sum_gs_total_cash+item.gs_total_cash }" />
			<c:set var="sum_qd_total_cash" value="${sum_qd_total_cash+item.qd_total_cash }" />
			<c:set var="sum_qt_total_cash" value="${sum_qt_total_cash+item.qt_total_cash }" /> --%>
		</c:forEach>
		<tr>
			<td colspan="2">合计：</td>
			<td><fmt:formatNumber value="${sum_dy_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_gs_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qd_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qt_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_dy_total+sum_gs_total+sum_qd_total+sum_qt_total}" pattern="#.##" type="currency"/></td>
			<%-- <td><fmt:formatNumber value="${sum_dy_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_gs_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qd_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qt_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_dy_total-sum_dy_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_gs_total-sum_gs_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qd_total-sum_qd_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_qt_total-sum_qt_total_cash}" pattern="#.##" type="currency"/></td> --%>
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
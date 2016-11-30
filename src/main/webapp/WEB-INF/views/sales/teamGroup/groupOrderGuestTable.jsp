<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String path = request.getContextPath();
%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width:3%">序号<i class="w_table_split"></i></th>
			<th style="width:8%">团号<i class="w_table_split"></i></th>
			<th style="width:6%">发团日期<i class="w_table_split"></i></th>
			<th style="width:6%">平台来源<i class="w_table_split"></i></th>
			<th style="width:12%">客人信息<i class="w_table_split"></i></th>
			<th style="width:4%">姓名<i class="w_table_split"></i></th>
			<th style="width:3%">性别<i class="w_table_split"></i></th>
			<th style="width:3%">年龄<i class="w_table_split"></i></th>
			<th style="width:10%">证件号<i class="w_table_split"></i></th>
			<th style="width:7%">电话<i class="w_table_split"></i></th>
			<th style="width:6%">籍贯<i class="w_table_split"></i></th>
			<th>产品套餐<i class="w_table_split"></i></th>
			<th style="width:3%">业务</th>
			<th style="width:5%">销售</th>
			<th style="width:4%">计调</th>
			<th style="width:3%">金额</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="goBean" varStatus="vo">
			<tr>
				<td>${vo.index+1 }</td>
				<td style="text-align: left;">${goBean['group_code']}</td>
				<td>${goBean['departure_date']}</td>
				<td>${goBean['supplier_name']}</td>
				<td style="text-align: left;">${goBean['receive_mode']}</td>
				<td>${goBean['name']}</td>
				<td>${goBean['gender']==0?"女":"男"}</td>
				<td>${goBean['age']}</td>
				<td>${goBean['certificate_num']}</td>
				<td>${goBean['mobile']}</td>
				<td style="text-align: left;">${goBean['native_place']}</td>
				<td style="text-align: left;">${goBean['remark']}</td>
				<td><c:forEach items="${typeList}" var="v" varStatus="vs">
					<c:if test="${goBean['order_mode']==v.id}">${v.value}</c:if> 
							</c:forEach> </td>
				<td>${goBean['sale_operator_name']}</td>
				<td>${goBean['operator_name']}</td>
				<c:set var="sum_person" value="${goBean['num_adult']+goBean['num_child']}" />
				<td><fmt:formatNumber value="${goBean['total']/sum_person}" type="currency" pattern="#.##"/>	</td>
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
<script type="text/javascript">


</script>
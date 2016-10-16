<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="10%" />
	<col width="15%" />
	<col width="15%" />
	<col width="5%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>对账单号<i class="w_table_split"></i></th>
			<th>对账时间<i class="w_table_split"></i></th>
			<th>对账员<i class="w_table_split"></i></th>
			<th>账期<i class="w_table_split"></i></th>
			<c:if test="${'1' == reqpm.supplierType}">
				<th>组团社<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${'16' == reqpm.supplierType}">
				<th>地接社<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
				<th>商家名称<i class="w_table_split"></i></th>
			</c:if>
			<th>对账金额<i class="w_table_split"></i></th>
			<th>已结算<i class="w_table_split"></i></th>
			<th>未结算<i class="w_table_split"></i></th>
			<th>调账<i class="w_table_split"></i></th>
			<th>记录条数<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;" >${item.verify_code}</td>
				<td><fmt:formatDate value="${item.create_time}" pattern="yyyy-MM-dd" /></td>
				<td>${item.user_name}</td>
				<td>${item.date_start} 至 ${item.date_end}</td>
				<td style="text-align: left;" >${item.supplier_name}</td>
				<td><fmt:formatNumber value="${item.total_price }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_not}" pattern="#.##"/></td>
				<c:if test="${!empty item.total_adjust}">
					<td><fmt:formatNumber value="${item.total_adjust}" pattern="#.##"/></td>
				</c:if>
				<c:if test="${empty item.total_adjust}">
					<td>0</td>
				</c:if>
				<c:if test="${!empty item.total_record}">
					<td>${item.total_record}条</td>
				</c:if>
				<c:if test="${empty item.total_record}">
					<td>0条</td>
				</c:if>
				<td>
					<c:if test="${item.verify_state eq 0}">未确认</c:if>
					<c:if test="${item.verify_state eq 1}">已确认</c:if>
				</td>
				<td>
					<c:if test="${item.verify_state eq 0}"><a class="def" href="javascript:void(0)" onclick="verifySub(${item.id});">确认</a></c:if>
					<a class="def" href="javascript:void(0)" onclick="toVerifyDetail('${item.id}')">查看明细</a>
					<a class="def" href="javascript:void(0)" onclick="deleteVerify(${item.id})">删除</a>
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="8%" />
	<col width="10%" />
	<col width="15%" />
	<col width="3%" />
	<col width="12%" />
	<col width="15%" />
	<col width="5%" />
	<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
		<col width="5%" />
	</c:if>
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>对账单号<i class="w_table_split"></i></th>
			<th>团号/类别<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>订单号/日期<i class="w_table_split"></i></th>
			<c:if test="${'1' == reqpm.supplierType}">
				<th>组团社<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${'16' == reqpm.supplierType}">
				<th>地接社<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
				<th>商家名称<i class="w_table_split"></i></th>
			</c:if>
			<th>计调员<i class="w_table_split"></i></th>
			<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
				<th>预订员<i class="w_table_split"></i></th>
			</c:if>
			<th>金额<i class="w_table_split"></i></th>
			<th>已结算<i class="w_table_split"></i></th>
			<th>未结算<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<c:if test="${empty item.verify_code}">
					<td>未对账</td>
				</c:if>
				<c:if test="${!empty item.verify_code}">
					<td>${item.verify_code}</td>
				</c:if>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}/<c:if test='${item.groupModel < 1}'>散客</c:if><c:if test='${item.groupModel > 0}'>团队</c:if></a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}/<c:if test='${item.groupModel < 1}'>散客</c:if><c:if test='${item.groupModel > 0}'>团队</c:if></a>
	              </c:if>
             	</td>
				
				<c:if test="${'1' == reqpm.supplierType}">
					<td  style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				</c:if>
				<c:if test="${'1' != reqpm.supplierType}">
					<td>${item.product_name}</td>
				</c:if>
				<td>${item.person_count}</td>
				<td>${item.booking_no}/<fmt:formatDate value="${item.booking_date}" pattern="yyyy-MM-dd" /></td>
				<td>${item.supplier_name}</td>
				<td>${item.operator_name}</td>
				<c:if test="${'1' != reqpm.supplierType && '16' != reqpm.supplierType}">
					<td>${item.user_name}</td>
				</c:if>
				<td><a href="javascript:void(0)" onclick="totalDetail('${item.id }')"><fmt:formatNumber value="${item.total}" pattern="#.##"/></a></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_not}" pattern="#.##"/></td>
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
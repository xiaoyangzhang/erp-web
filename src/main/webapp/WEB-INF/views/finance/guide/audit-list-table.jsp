<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>报账总额<i class="w_table_split"></i></th>
			<th>佣金<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
			<th>审核状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">
					<div class="serialnum_btn" groupId="${item.id}"></div> ${status.index+1}
				</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a>
	              </c:if>
              </td>
				<td style="text-align: left;" >【${item.product_brand_name}】${item.product_name}</td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td>${item.operator_name}</td>
				<td>${item.guide_name}</td>
				<td><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.comm_total }" pattern="#.##"/></td>
				<td>
					<c:if test="${item.group_state eq 0}">未确认</c:if>
					<c:if test="${item.group_state eq 1}">已确认</c:if>
					<c:if test="${item.group_state eq 2}">作废</c:if>
					<c:if test="${item.group_state eq 3}">已审核</c:if>
					<c:if test="${item.group_state eq 4}">封存</c:if>
				</td>
				<td>
					<c:if test="${item.state_finance eq 0}">未审核</c:if>
					<c:if test="${item.state_finance eq 1}">已审核</c:if>
				</td>
				<td>
					<c:if test="${item.state_finance ne 1}"><a class="def" href="javascript:void(0)" onclick="audit('${item.id }')">审核通过</a></c:if>
					<c:if test="${item.state_finance eq 1}"><a class="def" href="javascript:void(0)" onclick="delAudit('${item.id }')">取消审核</a></c:if>
					<a class="def" onclick="newWindow('导游报账审核详情', '<%=staticPath%>/bookingGuide/finance.htm?fromfin=1&groupId=${item.group_id }&bookingId=${item.id}')" href="javascript:void(0);">查看</a>
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
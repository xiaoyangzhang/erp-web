<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>报账金额<i class="w_table_split"></i></th>
			<th>已报账<i class="w_table_split"></i></th>
			<th>未报账<i class="w_table_split"></i></th>
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
				<td>
					<c:set var="itemTotal" value="${item.total + item.comm_total}" />
					<fmt:formatNumber value="${itemTotal}" pattern="#.##"/>
				</td>
				<td>
					<c:set var="itemTotalCash" value="${item.total_cash + item.comm_total_cash}" />
					<fmt:formatNumber value="${itemTotalCash }" pattern="#.##"/>
				</td>
				<td>
					<fmt:formatNumber value="${itemTotal - itemTotalCash}" pattern="#.##"/>
				</td>
				<td>
<%-- 					<c:if test="${item.state_booking eq 2}"> --%>
						<a class="def" onclick="newWindow('付款', '<%=staticPath%>/bookingGuide/paymentDetail.htm?groupId=${item.group_id }&bookingId=${item.id}')" href="javascript:void(0);">付款</a>
<%-- 					</c:if> --%>
					<a class="def" onclick="newWindow('导游结算详情', '<%=staticPath%>/bookingGuide/finance.htm?isHidden=true&groupId=${item.group_id }&bookingId=${item.id}')" href="javascript:void(0);">报账单</a>
				</td>
			</tr>
			<c:set var="sum_total" value="${sum_total + itemTotal }" />
			<c:set var="sum_total_cash" value="${sum_total_cash + itemTotalCash }" />
		</c:forEach>
		<tr>
			<td colspan="6">本页合计:</td>
			<td>
				<fmt:formatNumber value="${sum_total }" pattern="#.##"/>
			</td>
			<td>
				<fmt:formatNumber value="${sum_total_cash }" pattern="#.##"/>
			</td>
			<td>
				<fmt:formatNumber value="${sum_total-sum_total_cash }" pattern="#.##"/>
			</td>
			<td></td>
		</tr>
		<tr>
			<td colspan="6">全部合计:</td>
			<td>
				<c:set var="sumAllTotal" value="${sumTotalAmount + sumCommTotal }" />
				<fmt:formatNumber value="${sumTotalAmount + sumCommTotal }" pattern="#.##"/>
			</td>
			<td>
				<c:set var="sumAllTotalCash" value="${sumTotalCash + sumCommTotalCash }" />
				<fmt:formatNumber value="${sumAllTotalCash }" pattern="#.##"/>
			</td>
			<td>
				<fmt:formatNumber value="${sumAllTotal - sumAllTotalCash }" pattern="#.##"/>
			</td>
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
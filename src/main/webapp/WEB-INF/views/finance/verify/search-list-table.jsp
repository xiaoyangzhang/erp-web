<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="7%" />
	<col width="10%" />
	<col width="4%" />
	<col width="7%" />
	<col  />
	
	<col width="12%" />
	<col width="8%" />
	<col width="6%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>对账单号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>类别<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			
			<th>名称<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调员<i class="w_table_split"></i></th>
			<th>预订员<i class="w_table_split"></i></th>
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
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a>
	              </c:if>
             	</td>
             	<td >
             		<c:if test="${item.group_mode>0 }"><span class="log_action insert">团队</span></c:if>
             		<c:if test="${item.group_mode<=0 }"><span class="log_action update">散客</span></c:if>
             	</td>
				<td><fmt:formatDate value="${item.booking_date}" pattern="yyyy-MM-dd" /></td>
				<td style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td style="text-align: left;">${item.supplier_name}</td>
				<td style="text-align: left;">${item.receive_mode}</td>
				<td>${item.adult}+${item.child}+${item.guide}</td>
				<td>${item.operator_name}</td>
				<td> ${item.user_name} </td>
				<td><a href="javascript:void(0)" onclick="totalDetail('${item.id }')"><fmt:formatNumber value="${item.total}" pattern="#.##"/></a></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_not}" pattern="#.##"/></td>
			</tr>
			<c:set var="adult" value="${adult+item.adult}" />
			<c:set var="child" value="${child+item.child}" />
			<c:set var="guide" value="${guide+item.guide}" />
			<c:set var="total" value="${total+item.total}" />
			<c:set var="total_cash" value="${total_cash+item.total_cash}" />
			<c:set var="total_not" value="${total_not+item.total-item.total_cash}" />
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td ></td>
			<td >合计</td>
				<td ></td>
             	<td ></td>
				<td ></td>
				<td ></td>
				<td ></td>
				<td ></td>
				<td >${adult}+${child}+${guide}</td>
				<td ></td>
				<td ></td>
				<td><fmt:formatNumber value="${total}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${total_not}" pattern="#.##"/></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
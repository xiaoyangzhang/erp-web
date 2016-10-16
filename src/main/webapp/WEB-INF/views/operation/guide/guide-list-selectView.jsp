<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>
<div class="pl-10 pr-10" style="overflow-x:scroll;">  
<table cellspacing="0" cellpadding="0" class="w_table" style="width:100%;">
	<col width="3%" />
	<col width="7%" />
	<col width="5%" />
	<col width="10%" />
	<col width="10%" />
	<col width="5%" />
	<col width="3%" />
	<col width="5%" />
	<col width="3%" />
	<col width="4%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>调派人<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>报账金额<i class="w_table_split"></i></th>
			<th>计划购物<i class="w_table_split"></i></th>
			<th>实际购物<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">
	              <c:choose>
                  		<c:when test="${v.groupMode < 1}">
                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a></td>
                  		</c:when>
                  		<c:otherwise>
				 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId }&operType=0')">${v.groupCode}</a></td> 
                  		</c:otherwise>
                  	</c:choose>
	              </td> 
				<td>${v.dateStart}</td>
				<td style="text-align: left">【${v.productBrandName}】${v.productName}</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td>${v.adultCount}</td>
				<td>${v.operatorName}</td>
				<td>${v.guideName}</td>
				<td>${v.userName}</td>
				<td><c:if test="${v.stateBooking eq 0}">未提交</c:if><c:if test="${v.stateBooking eq 1}">处理中</c:if> <c:if test="${v.stateBooking eq 2}">处理中</c:if><c:if test="${v.stateBooking eq 3}">已报账</c:if></td>
				<td><fmt:formatNumber pattern="#.##" type="currency" value="${v.total}" /></td>
				<td><fmt:formatNumber pattern="#.##" type="currency" value="${v.jh}"/></td>
				<td><fmt:formatNumber pattern="#.##" type="currency" value="${v.sj}"/></td>
				<td>	<a class="def" href="javascript:void(0)" onclick="newWindow('查看报账单','<%=staticPath %>/bookingGuide/finance.htm?bookingId=${v.id }&groupId=${v.groupId}')">查看报账单</a></td>
				
			</tr>
			<c:set var="sum_personCnt" value="${sum_personCnt+v.adultCount }" />
			<c:set var="sum_total" value="${sum_total+v.total }" />
			<c:set var="sum_jh" value="${sum_jh+v.jh }" />
			<c:set var="sum_sj" value="${sum_sj+v.sj }" />
		</c:forEach>
		<tr>
			<td colspan="5" style="text-align:right;">合计：</td>
			<td>${sum_personCnt}</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber pattern="#.##" type="currency" value="${sum_total}" /></td>
			<td><fmt:formatNumber pattern="#.##" type="currency" value="${sum_jh}" /></td>
			<td><fmt:formatNumber pattern="#.##" type="currency" value="${sum_sj}" /></td>
			<td></td>
		</tr>
	</tbody>
	
</table>
</div>
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

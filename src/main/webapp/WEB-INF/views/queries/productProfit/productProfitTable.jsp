<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			<th >团数<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			<th >计划总人数<i class="w_table_split"></i></th>
			<th >实际总人数<i class="w_table_split"></i></th>
			<th >计划总购<i class="w_table_split"></i></th>
			<th >计划人均<i class="w_table_split"></i></th>
			<th >实际总购<i class="w_table_split"></i></th>
			<th >实际人均<i class="w_table_split"></i></th>
			
			<th  >完成率<i class="w_table_split"></i></th>
			<th >总收入<i class="w_table_split"></i></th>
			<th >总成本<i class="w_table_split"></i></th>
			<th >总毛利<i class="w_table_split"></i></th>
		</tr>
		
		
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.productBrandName}-${v.productName }</td>
				<td >${v.groupCount }</td>
				<td >${v.orderCount}</td>
				<td >${v.planedPersonCount eq null ?0:v.planedPersonCount}</td>
				<td >${v.totalAdult}</td>
				<td ><fmt:formatNumber value="${v.personBuyAvg*v.personNum}" pattern="#.##" type="number"/></td>
				<td ><c:choose>
					<c:when test="${v.planedPersonCount eq 0 or v.planedPersonCount eq null}">0</c:when>
					<c:otherwise><fmt:formatNumber value="${(v.personBuyAvg)*(v.personNum)/(v.planedPersonCount)}" pattern="#.##" type="number"/></c:otherwise>
					</c:choose>
				</td>
				<td ><fmt:formatNumber value="${v.totalFace==null?0:v.totalFace}" pattern="#.##" type="number"/></td>
				<td ><c:choose>
					<c:when test="${v.totalAdult eq 0 or v.totalAdult eq null}">0</c:when>
					<c:otherwise>
					
					<fmt:formatNumber value="${v.totalFace/v.totalAdult}" pattern="#.##" type="number"/></c:otherwise>
					</c:choose></td>
				<td >
					<fmt:formatNumber value="${(v.completeRate==null?0:v.completeRate)*100}" pattern="0.00#" type="number"/>%

				</td>
				<td ><fmt:formatNumber value="${v.total+v.totalRepay+ v.otherIncome-v.otherTotal }" pattern="#.##" type="number"/></td>
				<td ><fmt:formatNumber value="${v.totalPrice}" pattern="#.##" type="number"/></td>
				<td ><fmt:formatNumber value="${v.total+v.totalRepay+ v.otherIncome-v.otherTotal-v.totalPrice}" pattern="#.##" type="number"/></td>
				
			</tr>
			<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
			<c:set var="sum_groupCount" value="${sum_groupCount+v.groupCount }" />
			
			<c:set var="sum_planedPersonCount" value="${sum_planedPersonCount+v.planedPersonCount}" />
			<c:set var="sum_totalAdult" value="${sum_totalAdult+v.totalAdult}" />
			<c:set var="sum_expectedTotalFace" value="${sum_expectedTotalFace+v.personBuyAvg*v.personNum }" />
			<c:set var="sum_totalFace" value="${sum_totalFace+v.totalFace }" />
			<c:set var="sum_total" value="${sum_total+v.total+v.totalRepay+ v.otherIncome-v.otherTotal }" />
			<c:set var="sum_totalCost" value="${sum_totalCost+v.totalPrice}" />
			<c:set var="sum_totalProfit" value="${sum_totalProfit+v.total+v.totalRepay+ v.otherIncome-v.otherTotal-v.totalPrice}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="2">合计：</td>
			<td>${sum_groupCount }</td>
			<td>${sum_orderCount }</td>
			<td>${sum_planedPersonCount }</td>
			<td>${ sum_totalAdult}</td>
			<td><fmt:formatNumber value="${sum_expectedTotalFace }" pattern="#.##" type="number"/></td>
			<td></td>
			<td><fmt:formatNumber value="${ sum_totalFace}" pattern="#.##" type="number"/></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${ sum_total}" pattern="#.##" type="number"/></td>
			<td><fmt:formatNumber value="${sum_totalCost }" pattern="#.##" type="number"/></td>
			<td><fmt:formatNumber value="${sum_totalProfit }" pattern="#.##" type="number"/></td>

		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
<col width="3%">
<col width="10%">
<col width="6%">
<col width="5%">
<col >

<col width="10%">
<col width="6%">
<col width="5%">
<col width="5%">
<col width="6%">
<col width="6%">
<col width="6%">

<col width="5%">
<col width="5%">
<col width="5%">
<col width="5%">
<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >团号<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			
			<th >航空公司<i class="w_table_split"></i></th>
			<th >日期<i class="w_table_split"></i></th>
			<th >始发地<i class="w_table_split"></i></th>
			<th >目的地<i class="w_table_split"></i></th>
			<th >班次<i class="w_table_split"></i></th>
			<th >方式<i class="w_table_split"></i></th>
			<th >项目<i class="w_table_split"></i></th>
			
			<th >单价<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			<th >免去数<i class="w_table_split"></i></th>
			<th >金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">
					<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> 
                  		</c:when>
                  		<c:otherwise>
				 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td>${v.totalAdult }大${v.totalChild }小${v.totalGuide }陪</td>
				<td>${v.operatorName}</td>
				<td style="text-align: left;">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td ><fmt:formatDate value="${v.itemDate }"
						pattern="yyyy-MM-dd" /></td>
				<td>${v.ticketDeparture}</td>
				<td>${v.ticketArrival}</td>
				<td>${v.ticketFlight}</td>
				<td>${v.cashType}</td>
				<td>${v.type1Name }</td>
				
				<td><fmt:formatNumber value="${v.itemPrice }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.itemNum }" pattern="#.#" type="number"/></td>
				<td><fmt:formatNumber value="${v.itemNumMinus }" pattern="#.#" type="number"/></td>
				<td><fmt:formatNumber value="${v.itemTotal}" pattern="#.##" type="currency"/></td>
				<%-- <td > <fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td> --%>
			</tr>
			<c:set var="sum_totalCount" value="${sum_totalCount+v.itemTotal}" />
			 <c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum}" />
			<c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" /> 
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td colspan="13"  >合计：</td>
			<td ><fmt:formatNumber value="${sum_totalNum}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalNumMinus}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<%-- <td ><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td> --%>
		</tr>
		<tr class="footer2">
			<td colspan="13" >总计：</td>
			<td ><fmt:formatNumber value="${sum.totalNum}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalNumMinus}" pattern="#.##" type="number"/></td> 
			<td ><fmt:formatNumber value="${sum.totalCount}" pattern="#.##" type="number"/></td>
			<%-- <td ><fmt:formatNumber value="${sum.totalCashCount}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalBalanceCount}" pattern="#.##" type="number"/></td> --%>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

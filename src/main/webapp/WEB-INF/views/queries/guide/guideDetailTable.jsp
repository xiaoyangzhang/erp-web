<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>数量<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>
				<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td>${v.}</td>
				<td style="text-align: left">${v.productName}</td>
				<td>${v.operatorName}</td>
				<td style="text-align: left">${v.numAdult+v.numChild+v.numGuide}</td>
				<td style="text-align: left"><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
				<td style="text-align: left"><fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td style="text-align: left"><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td>
			</tr>
			<c:set var="sum_personCount" value="${sum_personCount+v.numAdult+v.numChild+v.numGuide}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td style="text-align: left">合计：</td>
			<td style="text-align: left">${sum_personCount}</td>
			<td style="text-align: left"><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<td style="text-align: left"><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td style="text-align: left"><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td style="text-align: left">总计：</td>
			<td style="text-align: left">${sum.personCount}</td>
			<td style="text-align: left"><fmt:formatNumber value="${sum.totalCount}" pattern="#.##" type="number"/></td>
			<td style="text-align: left"><fmt:formatNumber value="${sum.totalCashCount}" pattern="#.##" type="number"/></td>
			<td style="text-align: left"><fmt:formatNumber value="${sum.totalBalanceCount}" pattern="#.##" type="number"/></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

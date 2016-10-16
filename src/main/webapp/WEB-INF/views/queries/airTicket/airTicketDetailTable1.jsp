<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<table cellspacing="0" cellpadding="0" class="w_table">
<col width="2%"><col width="7%"><col width="5%"><col width="3%"><col width="10%"><col width="5%"><col width="5%"><col width="10%">
<col width="20%"><col width="3%"><col width="3%"><col width="3%"><col width="3%">	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th style="min-width:75px;">团出日期<i class="w_table_split"></i></th>
			<th>类型<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>团计调<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>明细<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count }</td>
				<td style="text-align: left;">
				<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td><fmt:formatDate value="${v.startDate}" pattern="yyyy-MM-dd" /></td>
				<td><c:if test="${v.groupMode<1 or v.groupMode==null}">散客</c:if><c:if test="${v.groupMode>0}">团队</c:if></td>
				<td style="text-align: left;">【${v.productBrandName}】${v.productName}</td>
				<td>${v.receiveMode}</td>
				<td>${v.groupOperatorName}</td>
				<td style="text-align: left;">${v.supplierName}</td>
				<td><c:if test="${v.details!=null }">
				                  ${fn:replace(v.details,',','</br>') }
				     </c:if></td>
				<td>${v.cashType }</td>
				<td><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td><c:if test="${v.stateFinance==0}">未审核</c:if><c:if test="${v.stateFinance==1}">已审核</c:if></td>
			</tr>
		</c:forEach>
	</tbody>

	<tfoot>
		<tr class="footer1">
			<td></td>
			<td colspan="9" style="text-align: right">本页合计：</td>
			<td><fmt:formatNumber value="${sumPageTotal}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sumPageTotalCash}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>

		<tr class="footer1">
			<td></td>
			<td colspan="9" style="text-align: right">合计：</td>
			<td><fmt:formatNumber value="${sum.total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
	<jsp:param value="queryAirTicketList" name="fnQuery"/>
</jsp:include>

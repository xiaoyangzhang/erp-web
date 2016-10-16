<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<table cellspacing="0" cellpadding="0" class="w_table">
<col width="5%" />
<col width="7%" />
<col width="5%" />
<col width="8%" />
<col width="17%" /
><col width="13%" />
<col width="5%" />
<col width="8%" /
><col width="17%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
             
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >团号<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			<th >导游<i class="w_table_split"></i></th>
			<th >产品名称<i class="w_table_split"></i></th>
			
			<th >商家名称<i class="w_table_split"></i></th>
			<th >方式<i class="w_table_split"></i></th>
			<th >预定日期<i class="w_table_split"></i></th>
			<th >明细<i class="w_table_split"></i></th>
			
			
			<th >应付<i class="w_table_split"></i></th>
			<th >已付<i class="w_table_split"></i></th>
			<th >未付<i class="w_table_split"></i></th>
		</tr>
		
	</thead>
	<tbody>
	<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
		
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">
					<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td>${v.operatorName}</td>
				<td>
					 <c:if test="${v.bookingGuideInfo!=null }">
				                  ${v.bookingGuideInfo }
				                  	 
				                  	</c:if>
				</td>
				
				<td style="text-align: left">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td>${v.cashType}</td>
				<td>
				${v.bookingDate }
				
				</td>
				<td >
					
					
						<c:if test="${v.details!=null }">
				                  ${fn:replace(v.details,',','</br>') }
				                  	 
				                  	</c:if>
					
					
				</td>
				<td ><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
				<td > <fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td>
			</tr>
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
					
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			
			<td></td>
			<td colspan="8" style="text-align: right">合计：</td>
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
		</tr>
		<tr class="footer2">
			<td></td>
			<td colspan="8" style="text-align: right">总计：</td>
			<td ><fmt:formatNumber value="${sum.total}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.total - sum.totalCash}" pattern="#.##" type="number"/></td>
		</tr>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<%@ page language="java" import="java.util.Date,java.text.SimpleDateFormat" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 
<table cellspacing="0" cellpadding="0" class="w_table">
<col width="5%" />
<col width="7%" />
<col width="8%" />
<col width="17%" />
<col width="13%" />
<col width="5%" />
<col width="8%" />
<col width="5%" />
<col width="5%" />
<col width="5%" />
			             
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >团号<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			<th >产品名称<i class="w_table_split"></i></th>
			
			<th >商家名称<i class="w_table_split"></i></th>
			<th >预定日期<i class="w_table_split"></i></th>
			
			
			<th >导游现付<i class="w_table_split"></i></th>
			<th >签单月结<i class="w_table_split"></i></th>
			<th >公司现付<i class="w_table_split"></i></th>
			<th >其他<i class="w_table_split"></i></th>
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
				
				<td style="text-align: left">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td>
				${v.bookingDate }
				
				</td>
				<td ><fmt:formatNumber value="${v.dyxf}" pattern="#.##" type="currency"/></td>
				<td > <fmt:formatNumber value="${v.dyxf_qdyj+v.qdyj}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.gsxf}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.qt}" pattern="#.##" type="currency"/></td>
			</tr>
			<c:set var="sum_dyxf" value="${sum_dyxf+v.dyxf}" />
			<c:set var="sum_dyxf_qdyj" value="${sum_dyxf_qdyj+v.dyxf_qdyj+v.qdyj}" />
			<c:set var="sum_gsxf" value="${sum_gsxf+v.gsxf}" />
			<c:set var="sum_qt" value="${sum_qt+v.qt}" />
					
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td></td>
			<td colspan="5" style="text-align: right">合计：</td>
			<td ><fmt:formatNumber value="${sum_dyxf}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_dyxf_qdyj}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_gsxf}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_qt}" pattern="#.##" type="currency"/></td>
		</tr>
		<tr class="footer2">
			<td></td>
			<td colspan="5" style="text-align: right">总计：</td>
			<td ><fmt:formatNumber value="${sum.dyxf}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.dyxf_qdyj+sum.qdyj}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.gsxf}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.qt}" pattern="#.##" type="number"/></td>
		</tr>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

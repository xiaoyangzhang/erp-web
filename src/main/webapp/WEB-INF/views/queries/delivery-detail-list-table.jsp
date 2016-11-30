<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="8%" />
	<col width="8%" />
	<col width="18%" />
	<col width="9%" />
	
	<col width="5%" />
	<col width="8%" />
	<col/>
	<col width="4%" />
	<col width="4%" />
	
	<col width="4%" />
	<col width="4%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>地接社<i class="w_table_split"></i></th>
			<th>客人<i class="w_table_split"></i></th>
			
			<th>团类型<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			
			<th>未付<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left">
				<c:choose>
                  		<c:when test="${item.group_mode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td>${item.date_arrival}</td>
				<td style="text-align: left">${item.supplier_name}</td>
				<td style="text-align: left">${item.receive_mode }</td>
				<td>
					<c:if test="${item.group_mode <1 }">散客</c:if>
					<c:if test="${item.group_mode > 0}">团队</c:if>
				</td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td style="text-align: left">【${item.product_brand_name}】${item.product_name }</td>
				<td ><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td ><fmt:formatNumber value="${item.totalCash}" pattern="#.##"/></td>
				<td ><fmt:formatNumber value="${item.total-item.totalCash}" pattern="#.##"/></td>
				<td>${item.operator_name}</td>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.totalCash }" />
			<c:set var="sum_balance" value="${sum_balance+item.total-item.totalCash }" />
			<c:set var="sum_adult" value="${sum_adult+item.total_adult }" />
			<c:set var="sum_child" value="${sum_child+item.total_child }" />
			<c:set var="sum_guide" value="${sum_guide+item.total_guide}" />
		</c:forEach>
		</tbody>
		<tfoot>
		<tr>
			
			<td colspan="6" >合计:</td>
			<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
			<td></td>
			<td ><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum_balance }" pattern="#.##"/></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="6">总计:</td>
			<td>${sum.total_adult }大${sum.total_child }小${sum.total_guide }陪</td>
			<td></td>
			<td ><fmt:formatNumber value="${sum.total }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum.totalCash }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum.total-sum.totalCash }" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
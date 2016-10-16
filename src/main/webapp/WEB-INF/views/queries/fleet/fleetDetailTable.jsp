<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="6%" />
	<col width="15%" /> 
	
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="6%" />
	<col width="6%" />
	
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			
			<th>车队<i class="w_table_split"></i></th>
			<th>车型<i class="w_table_split"></i></th>
			<th>座位<i class="w_table_split"></i></th>
			<th>司机<i class="w_table_split"></i></th>
			<th>车牌<i class="w_table_split"></i></th>
			
			<th>用车日期<i class="w_table_split"></i></th>
			<th>结算方式<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;"><c:choose>
                  		<c:when test="${item.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose></td>
				<td>${item.operatorName}</td>
				<td>${item.totalAdult}+${item.totalChild}</td>
				<td  style="text-align: left;">【${item.productBrandName}】${item.productName}</td>
				
				<td style="text-align: left">${item.supplierName}</td>
				<td>${item.type1Name}</td>
				<td>${item.type2Name}</td>
				<td>${item.driverName}<br>${item.driverTel }</td>
				<td>${item.carLisence}</td>
				<td>
				<fmt:formatDate value="${item.itemDate}" pattern="MM-dd"/><br/><fmt:formatDate value="${item.itemDateTo}" pattern="MM-dd"/></td>
				 <td>${item.cashType }</td>
				 
				<td ><fmt:formatNumber value="${item.total }" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.total-item.totalCash}" pattern="#.##" type="currency"/></td>
				<td>${item.remark}</td>
			</tr>
			<c:set var="sum_adult" value="${sum_adult+item.totalAdult}" />
			<c:set var="sum_child" value="${sum_child+item.totalChild }" />
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.totalCash }" />
			<c:set var="sum_balance" value="${sum_balance+item.total-item.totalCash}" />
			
		</c:forEach>
		</tbody>
		<tfoot>
		<tr class="footer1">
			<td ></td>
			<td style="text-align:right;font-weight:bold;">合计：</td>
			<td ></td>
			<td >${sum_adult }+${sum_child }</td>
			<td ></td>
			
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			
			<td ><fmt:formatNumber value="${sum_total }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_cash }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_balance }" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
		<tr class="footer1">
			<td></td>
			<td style="text-align: right;font-weight:bold;">总计：</td>
			<td ></td>
			<td ></td>
			<td ></td>
			
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			<td ></td>
			
			<td ><fmt:formatNumber value="${sum.total}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.total - sum.totalCash}" pattern="#.##" type="number"/></td>
			<td ></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
<col width="3%" /><col width="10%" /><col width="11%" /><col width="5%" /><col width="4%" /><col width="8%" />
<col width="10%" /><col width="6%" /><col width="5%" /><col width="5%" /><col width="6%" />
<col width="4%" /><col width="4%" /><col width="4%" /><col width="5%" /><col width="5%" /><col width="5%" />
<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th> 
			<th >团号<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			<th >导游<i class="w_table_split"></i></th>
			<th >商家<i class="w_table_split"></i></th>
			<th >日期<i class="w_table_split"></i></th>
			<th >方式<i class="w_table_split"></i></th>
			<th >项目<i class="w_table_split"></i></th>
			<th >备注<i class="w_table_split"></i></th>
			<th >单价<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			<th >免去数<i class="w_table_split"></i></th>
			<th >金额<i class="w_table_split"></i></th>
			<th >已收<i class="w_table_split"></i></th>
			<th >未收<i class="w_table_split"></i></th>
		</tr>
		
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
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
				<td>${v.productBrandName }-${v.productName }</td>
				<td>${v.totalAdult }大${v.totalChild }小${v.totalGuide }陪</td>
				<td>${v.operatorName}</td>
				<td>
					 <c:if test="${v.bookingGuideInfo!=null }">
				                  ${v.bookingGuideInfo }
				                  	 
				                  	</c:if>
				</td>
				
				
				
				<td style="text-align: left">${v.supplierName}</td>
				
				
				<td ><fmt:formatDate value="${v.itemDate }"
						pattern="yyyy-MM-dd" /></td>
				<td>${v.cashType}</td>
				<td>${v.type1Name }</td>
				<td>${v.remark }</td>
				<td>	<fmt:formatNumber value="${v.itemPrice }" pattern="#.##" type="currency"/></td>
				<td>	<fmt:formatNumber value="${v.itemNum }" pattern="#.#" type="number"/></td>
					
				<td>	<fmt:formatNumber value="${v.itemNumMinus }" pattern="#.#" type="number"/></td>
						
				<td ><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
				<td > <fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td>
			</tr>
			<c:set var="sum_total" value="${sum_total+v.total}" />
			<c:set var="sum_totalCash" value="${sum_totalCash+v.totalCash}" />
			 <c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum }" />
			<c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" /> 
					
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			
			
			<td colspan="12" >合计：</td>
			 <td ><fmt:formatNumber value="${sum_totalNum}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalNumMinus}" pattern="#.##" type="currency"/></td> 
			<td ><fmt:formatNumber value="${sum_total}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCash}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_total-sum_totalCash}" pattern="#.##" type="currency"/></td>
		</tr>

		<tr class="footer2">
			
			
			<td colspan="12" >总计：</td>
			 <td ><fmt:formatNumber value="${sum.totalNum}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalNumMinus}" pattern="#.##" type="number"/></td> 
			<td ><fmt:formatNumber value="${sum.total}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalCash}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.total-sum.totalCash}" pattern="#.##" type="number"/></td>
		</tr>
	</tfoot>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
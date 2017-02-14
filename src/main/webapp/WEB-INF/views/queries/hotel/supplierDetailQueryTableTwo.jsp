<%@ page language="java" import="java.util.Date,java.text.SimpleDateFormat" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../../../include/path.jsp" %>
<table cellspacing="0" cellpadding="0" class="w_table">
<col width="3%" /><col width="9%" /><col /><col width="5%" /><col width="4%" />
<col width="10%" /><col width="6%" /><col width="5%" /><col width="5%" /><col width="8%" />

<col width="4%" /><col width="4%" /><col width="4%" /><col width="5%" /><col width="4%" /><col width="5%" /><col width="5%" />
			             
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >团号<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			
			
			<th >商家<i class="w_table_split"></i></th>
			<th >日期<i class="w_table_split"></i></th>
			<th >方式<i class="w_table_split"></i></th>
			<th >项目<i class="w_table_split"></i></th>
			<th >备注<i class="w_table_split"></i></th>
			
			
			<th >数量<i class="w_table_split"></i></th>
			<th >免数<i class="w_table_split"></i></th>
			<th >成本价<i class="w_table_split"></i></th>
			<th >成本金额<i class="w_table_split"></i></th>
			<th >结算价<i class="w_table_split"></i></th>
			<th >结算金额<i class="w_table_split"></i></th>
			<th >利润<i class="w_table_split"></i></th>
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
                  	<c:if test="${v.supplierType == 3}">
	                  	<a class="def" href="javascript:void(0)" onclick="newWindow('修改酒店订单','<%=staticPath %>/booking/toAddHotel?groupId=${v.groupId }&bookingId=${v.id}&isShow=1')">修改</a>
                  	</c:if>
                  	<c:if test="${v.supplierType == 2}">
	                  	<a class="def" href="javascript:void(0)" onclick="newWindow('修改餐饮订单','<%=staticPath %>/booking/toAddEat?groupId=${v.groupId }&bookingId=${v.id}&isShow=1')">修改</a>
                  	</c:if>
                  	<c:if test="${v.supplierType == 5}">
	                  	<a class="def" href="javascript:void(0)" onclick="newWindow('修改门票订单','<%=ctx %>/booking/toAddSight?groupId=${v.groupId }&bookingId=${v.id}&supplierId=${v.supplierId }&isShow=1')">修改</a>
                  	</c:if>
				</td>
				<td>${v.productBrandName }-${v.productName }</td>
				<td>${v.totalAdult }+${v.totalChild }+${v.totalGuide }</td>
				<td>${v.operatorName}</td>

				<td style="text-align: left">${v.supplierName}</td>
				
				
				<td ><fmt:formatDate value="${v.itemDate }"
						pattern="yyyy-MM-dd" /></td>
				<td>${v.cashType}</td>
				<td>${v.type1Name }</td>
				<td>${v.itemBrief }</td>
				<td><fmt:formatNumber value="${v.itemNum }" pattern="#.#" type="number"/></td>
				<td><fmt:formatNumber value="${v.itemNumMinus }" pattern="#.#" type="number"/></td>
				<td><fmt:formatNumber value="${v.itemPrice }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.itemTotal}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.saleItemPrice  }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.totalSale}" pattern="#.##" type="currency"/></td>
				<%-- <td><fmt:formatNumber value="${v.totalSale-v.itemTotal}" pattern="#.##" type="currency"/></td> --%>
				
				<c:if test="${v.supplierType == 3}">
                	<td><fmt:formatNumber value="${v.totalSale-v.itemTotal}" pattern="#.##" type="currency"/></td>
               	</c:if>
               	<c:if test="${v.supplierType == 2}">
                	<td><fmt:formatNumber value="${v.itemTotal - v.totalSale}" pattern="#.##" type="currency"/></td>
               	</c:if>
               	<c:if test="${v.supplierType == 5}">
                	<td><fmt:formatNumber value="${v.totalSale-v.itemTotal}" pattern="#.##" type="currency"/></td>
               	</c:if>
			</tr>
			<%-- <c:set var="sum_totalCount" value="${sum_totalCount+v.itemTotal}" />
			<c:set var="sum_totalSale" value="${sum_totalSale+v.totalSale}" />
			<c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum }" />
			<c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" />  --%>
			
			<c:set var="sum_itemNum" value="${sum_itemNum+v.itemNum}" />
			<c:set var="sum_itemNumMinus" value="${sum_itemNumMinus+v.itemNumMinus}" />
			<c:set var="sum_itemPrice" value="${sum_itemPrice+v.itemPrice}" />
			<c:set var="sum_itemTotal" value="${sum_itemTotal+v.itemTotal}" />
			
			<c:set var="sum_saleItemPrice" value="${sum_saleItemPrice+v.saleItemPrice}" />
			<c:set var="sum_totalSale" value="${sum_totalSale+v.totalSale}" />
			
			<c:set var="supplierTypeSet" value="${v.supplierType}" />
					
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			
			
			<td colspan="10" >合计：</td>
			 <td ><fmt:formatNumber value="${sum_itemNum}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_itemNumMinus}" pattern="#.##" type="currency"/></td> 
			<td ><fmt:formatNumber value="${sum_itemPrice}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_itemTotal}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_saleItemPrice}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalSale}" pattern="#.##" type="currency"/></td>
			<%-- <td ><fmt:formatNumber value="${sum_totalSale-sum_itemTotal}" pattern="#.##" type="currency"/></td> --%>
			<td >
				<c:if test="${supplierTypeSet == 3}">
	            	<fmt:formatNumber value="${sum_totalSale - sum_itemTotal}" pattern="#.##" type="currency"/>
	           	</c:if>
	           	<c:if test="${supplierTypeSet == 2}">
	            	<fmt:formatNumber value="${sum_itemTotal - sum_totalSale}" pattern="#.##" type="currency"/>
	           	</c:if>
	           	<c:if test="${supplierTypeSet == 5}">
	            	<fmt:formatNumber value="${sum_totalSale - sum_itemTotal}" pattern="#.##" type="currency"/>
	           	</c:if>
           	</td>
		</tr>

		<tr class="footer2">
			
			
			<td colspan="10" >总计：</td>
			 <td ><fmt:formatNumber value="${sum.totalNum}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalNumMinus}" pattern="#.##" type="number"/></td> 
			<td ><fmt:formatNumber value="${sum.totalPrice}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalCount}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.saleItemPrice}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum.totalSale}" pattern="#.##" type="number"/></td>
			<%-- <td ><fmt:formatNumber value="${sum.totalProfit}" pattern="#.##" type="number"/></td> --%>
			<td >
				<c:if test="${supplierTypeSet == 3}">
	            	<fmt:formatNumber value="${sum.totalSale - sum.totalCount}" pattern="#.##" type="number"/>
	           	</c:if>
	           	<c:if test="${supplierTypeSet == 2}">
	            	<fmt:formatNumber value="${sum.totalCount - sum.totalSale}" pattern="#.##" type="number"/>
	           	</c:if>
	           	<c:if test="${supplierTypeSet == 5}">
	            	<fmt:formatNumber value="${sum.totalSale - sum.totalCount}" pattern="#.##" type="number"/>
	           	</c:if>
           </td>
		</tr>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

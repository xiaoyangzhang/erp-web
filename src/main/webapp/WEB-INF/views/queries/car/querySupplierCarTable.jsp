<%@ page language="java" import="java.util.Date,java.text.SimpleDateFormat" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../../../include/path.jsp" %>
<table cellspacing="0" cellpadding="0" class="w_table">

<col width="3%" />
<col width="9%" />
<col />
<col width="5%" />
<col width="4%" />

<col width="10%" />
<col width="6%" />
<col width="5%" />
<col width="5%" />
<col width="8%" />

<col width="4%" />
<col width="4%" />
<col width="4%" />
<col width="4%" />
<col width="5%" />

<col width="4%" />
<col width="5%" />
<col width="5%" />
			             
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
			<th >结算价<i class="w_table_split"></i></th>
			<th >成本价<i class="w_table_split"></i></th>
			<th >计调费<i class="w_table_split"></i></th>
			<th >计调费备注<i class="w_table_split"></i></th>
			
			<th >其他利润<i class="w_table_split"></i></th>
			<th >其他利润备注<i class="w_table_split"></i></th>
			<th>利润<i class="w_table_split"></th>
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
                  	<a class="def" href="javascript:void(0)" onclick="newWindow('修改车辆订单','<%=staticPath %>/booking/toAddCar?groupId=${v.groupId}&bookingId=${v.bookingId}&isShow=1')">修改</a>
				</td>
				<td style="text-align: left;">【${v.productBrandName }】${v.productName }</td>
				<td>${v.totalAdult }+${v.totalChild }+${v.totalGuide }</td>
				<td>${v.operatorName}</td>

				<td style="text-align: left">${v.supplierName}</td>
				<td ><fmt:formatDate value="${v.itemDate }"
						pattern="yyyy-MM-dd" /></td>
				<td>${v.cashType}</td>
				<td>${v.type1Name }</td>
				<td>${v.remark }</td>
				
				<td><fmt:formatNumber value="${v.itemNum }" pattern="#.#" type="number"/></td>
				<td><fmt:formatNumber value="${v.itemPrice-v.financeTotal}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.itemPrice-v.financeTotal-v.carProfitTotal-v.carProfitTotal2}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.carProfitTotal}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${v.carPayType eq '0'}">
						代订
					</c:if>	
					<c:if test="${v.carPayType eq '1'}">
						手续费
					</c:if>	
				</td>
				
				
				<td><fmt:formatNumber value="${v.carProfitTotal2}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${v.carPayType2 eq '1'}">
						套团
					</c:if>	
					<c:if test="${v.carPayType2 eq '2'}">
						临时团
					</c:if>	
					<c:if test="${v.carPayType2 eq '3'}">
						短线
					</c:if>	
					<c:if test="${v.carPayType2 eq '4'} ">
						其他
					</c:if>	
				</td>
				<td><fmt:formatNumber value="${v.carProfitTotal2+v.carProfitTotal}" pattern="#.##" type="currency"/></td>
			</tr>
			<!-- 数量 -->
			<c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum }" />
			<!-- 结算价 -->
			<c:set var="sum_totalItemPrice" value="${sum_totalItemPrice+ v.itemPrice-v.financeTotal}" />
			<!--成本价 -->
			<c:set var="sum_totalSalePrice" value="${sum_totalSalePrice+(v.itemPrice-v.financeTotal-v.carProfitTotal-v.carProfitTotal2)}" />
			<!-- 计调费 -->
			<c:set var="sum_carProfitTotal" value="${sum_carProfitTotal+v.carProfitTotal }" />
			<!--其他利润-->
			<c:set var="sum_carProfitTotal2" value="${sum_carProfitTotal2+v.carProfitTotal2}" />
			
		</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td colspan="10" style="text-align: right;">合计：</td>
			<td ><fmt:formatNumber value="${sum_totalNum}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalItemPrice}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalSalePrice}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_carProfitTotal}" pattern="#.##" type="currency"/></td>
			<td>&nbsp;</td>
			<td><fmt:formatNumber value="${sum_carProfitTotal2}" pattern="#.##" type="currency"/></td>
			<td>&nbsp;</td>
			<td><fmt:formatNumber value="${sum_carProfitTotal2+sum_carProfitTotal}" pattern="#.##" type="currency"/></td>
		</tr>

		<tr class="footer2">
			<td colspan="10" style="text-align: right;">总计：</td>
			<!-- 数量 -->
			<td ><fmt:formatNumber value="${sum.totalNum}" pattern="#.##" type="currency"/></td>
			<!-- 结算价 -->
			<td ><fmt:formatNumber value="${sum.costPrice}" pattern="#.##" type="currency"/></td> 
			<!-- 成本价 -->
			<td ><fmt:formatNumber value="${sum.salePrice}" pattern="#.##" type="currency"/></td>
			<!-- 计调费 -->
			<td ><fmt:formatNumber value="${sum.carProfitTotal}" pattern="#.##" type="currency"/></td> 
			<td>&nbsp;</td>
			<!--其他利润 -->
			<td ><fmt:formatNumber value="${sum.carProfitTotal2}" pattern="#.##" type="currency"/></td> 
			<td>&nbsp;</td>
			<td ><fmt:formatNumber value="${sum.carProfitTotal2+sum.carProfitTotal}" pattern="#.##" type="currency"/></td> 
		</tr>
	</tbody>
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<table class="w_table" style="margin-left: 0px">
	<colgroup> 
		<col width="5%"/>
		<col width="8%"/>
		<col width="6%"/>
		<col width="20%"/>
		<col width="6%"/>
		<col width="10%"/>
		
		<col width="4%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="6%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>客人信息<i class="w_table_split"></i></th>
			
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>收入<i class="w_table_split"></i></th>
			<th>预算成本<i class="w_table_split"></i></th>
			<th>预算毛利<i class="w_table_split"></i></th>
			
			<th>实际成本<i class="w_table_split"></i></th>
			<th>实际毛利<i class="w_table_split"></i></th>
			<th>差额<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${groupList}" var="tg" varStatus="v">
       		<tr>
              <td>${v.count}</td>
              <td style="text-align: left;">
	              <c:if test="${tg.groupMode==0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${tg.id}&operType=0')">${tg.groupCode}</a> 
	              </c:if>
	              <c:if test="${tg.groupMode!=0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${tg.id}&operType=0')">${tg.groupCode}</a>
	              </c:if>
              </td>
              <td style="text-align: center;"><fmt:formatDate value="${tg.dateStart}" pattern="yyyy-MM-dd"/></td>
              <td style="text-align: left">【${tg.productBrandName}】${tg.productName}</td>
              <td style="text-align: left">
              	<c:if test="${tg.groupMode==0}">
              		散客团
              	</c:if>
              	<c:if test="${tg.groupMode!=0}">
              		${tg.supplierName}
              	</c:if>
              </td>
              <!-- 客人信息 -->
              <td>
              	<c:if test="${tg.groupMode==0}">
              		
              	</c:if>
              	<c:if test="${tg.groupMode!=0}">
              		${tg.receiveMode}
              	</c:if>
              </td>
              
              <td>
              	<c:if test="${tg.totalBaby==null  }">${tg.totalAdult}+${tg.totalChild}+${tg.totalGuide}</c:if>
              	<c:if test="${tg.totalBaby!=null  }">${tg.totalAdult}+${tg.totalChild}<span style="color: red;font-size: 8px;">(${tg.totalBaby})</span>+${tg.totalGuide}</c:if>
              </td>
              <td>${tg.operatorName}</td>
              <td>
              	<fmt:formatNumber value="${tg.total}" type="currency" pattern="#.##"/>
              </td>
              <td>
              	<fmt:formatNumber value="${tg.budget}" type="currency" pattern="#.##"/>	
              </td>
              <td>
              	<fmt:formatNumber value="${tg.total-tg.budget}" type="currency" pattern="#.##"/>	
              </td>
              
               <c:set var="sumTotalBudget" value="${tg.total-tg.budget}" />
			   <c:set var="sumIncomeCost" value="${tg.totalIncome-tg.totalCost}" />
              <td>
              	<fmt:formatNumber value="${tg.totalCost}" type="currency" pattern="#.##"/>	
              </td>
               <td>
              	<fmt:formatNumber value="${sumIncomeCost}" type="currency" pattern="#.##"/>	
              </td>
              
               <td>
              	<fmt:formatNumber value="${sumTotalBudget-sumIncomeCost}" type="currency" pattern="#.##"/>	
              </td>
              <td>
              		<c:if test="${tg.groupState==0 }">未确认</c:if>
	                <c:if test="${tg.groupState==1 }">已确认</c:if>
					<%-- <c:if test="${tg.groupState==1 and nowDate-tg.dateStart.time < 0}">(待出团)</c:if>
					<c:if test="${tg.groupState==1 and  !empty tg.dateEnd and nowDate-tg.dateEnd.time > 0}">(已离开)</c:if>
					<c:if test="${tg.groupState==1 and  !empty tg.dateEnd and nowDate-tg.dateStart.time > 0 and nowDate-tg.dateEnd.time < 0 }">(行程中)</c:if> --%>
					<c:if test="${tg.groupState==2}">废弃</c:if>
					<c:if test="${tg.groupState==3}">封存</c:if>
			  </td>
         	</tr>
         	<c:set var="sum_adult" value="${sum_adult+tg.totalAdult}" />
			<c:set var="sum_child" value="${sum_child+tg.totalChild}" />
			<c:set var="sum_guide" value="${sum_guide+tg.totalGuide}" />
			<c:set var="sum_baby" value="${sum_baby+tg.totalBaby}" />
			<c:set var="sum_total" value="${sum_total+tg.total}" />
			<c:set var="sum_budget" value="${sum_budget+tg.budget}" />
			
			<c:set var="sum_totalCost" value="${sum_totalCost+tg.totalCost}" />
			<c:set var="sum_incomeCost" value="${sum_incomeCost+(tg.totalIncome-tg.totalCost)}" />
			<c:set var="sum_budgetCost" value="${sum_budgetCost+(sumTotalBudget-sumIncomeCost)}" />
       	</c:forEach>
       	<c:forEach items="${pb}" var="pb">
         	<c:set var="sum_adult1" value="${sum_adult1+pb.totalAdult}" />
			<c:set var="sum_child1" value="${sum_child1+pb.totalChild}" />
			<c:set var="sum_guide1" value="${sum_guide1+pb.totalGuide}" />
			<c:set var="sum_baby1" value="${sum_baby1+pb.totalBaby}" />
    	</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
			<td>
				<c:if test="${sum_baby==0  }">${sum_adult}+${sum_child}+${sum_guide}</c:if>
              	<c:if test="${sum_baby!=0  }">${sum_adult}+${sum_child}<span style="color: red;font-size: 8px;">(${sum_baby})</span>+${sum_guide}</c:if>
			</td>
		    <td></td>
			<td><fmt:formatNumber value="${sum_total}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_budget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total-sum_budget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalCost}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_incomeCost}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_budgetCost}" type="currency" pattern="#.##"/></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">总合计：</td>
			<td>
				<c:if test="${sum_baby1==0  }">${sum_adult1}+${sum_child1}+${sum_guide1}</c:if>
              	<c:if test="${sum_baby1!=0  }">${sum_adult1}+${sum_child1}<span style="color: red;font-size: 8px;">(${sum_baby1})</span>+${sum_guide1}</c:if>
			</td>
		    <td></td>
			<td><fmt:formatNumber value="${totalIncome}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${totalBudget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${totalIncome-totalBudget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumTotalCost}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumTotalIncome-sumTotalCost}" type="currency" pattern="#.##"/></td>
			
			<c:set var="sub_incomeBudget" value="${totalIncome-totalBudget}" />
			<c:set var="sub_incomeCost" value="${sumTotalIncome-sumTotalCost}" />
			<td><fmt:formatNumber value="${sub_incomeBudget-sub_incomeCost}" type="currency" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

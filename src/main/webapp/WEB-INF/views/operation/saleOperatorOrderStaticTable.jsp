<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../include/top.jsp"%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>订单数<i class="w_table_split"></i></th>
			<th>成人<i class="w_table_split"></i></th>
			<th>儿童<i class="w_table_split"></i></th>
			<th>全陪<i class="w_table_split"></i></th>
			<th>订单收入<i class="w_table_split"></i></th>
			<th>其他收入<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>总收入<i class="w_table_split"></i></th>
			<th>总成本<i class="w_table_split"></i></th>
			<th>毛利<i class="w_table_split"></i></th>
			<th>毛利率<i class="w_table_split"></i></th>
			<th>人均毛利<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${page.result}" var="sl" varStatus="v">
       		<tr>
              <td>${v.count}</td>
              <td>${sl.saleOperatorName}</td>
              <td>${sl.orderNum}</td>
              <td>${sl.numAdult}</td>
              <td>${sl.numChild}</td>
              <td>${sl.numGuide}</td>
              <td><fmt:formatNumber type="percent" value="${sl.orderIncome}" pattern="#.##"></fmt:formatNumber></td>
              <td>
              		<c:if test="${sl.totalPersons!=0}"><fmt:formatNumber type="percent" value="${sl.otherIncome/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber></c:if>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
              </td>
              <td>
					<c:if test="${sl.totalPersons!=0}"><fmt:formatNumber type="percent" value="${(sl.rayPayIncome-sl.fsIncome)/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber></c:if>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
			  </td>
              <td>
              		<c:if test="${sl.totalPersons!=0}"><fmt:formatNumber type="percent" value="${sl.totalIncome/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber></c:if>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
              </td>
              <td>
              		<c:if test="${sl.totalPersons!=0}"><fmt:formatNumber type="percent" value="${sl.totalCost/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber></c:if>
              		<c:if test="${sl.totalPersons==0}">-</c:if></td>
              <td>
					<c:if test="${sl.totalPersons!=0}"><fmt:formatNumber type="percent" value="${(sl.totalIncome-sl.totalCost)/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber></c:if>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
			  </td>
              <td>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
              		<c:if test="${sl.totalPersons!=0}">
						<c:if test="${(sl.totalIncome-sl.totalCost) > 0}">
			              	<c:if test="${sl.totalIncome!='0.0000'}">
			              		<fmt:formatNumber type="percent" value="${((sl.totalIncome-sl.totalCost)*100/(sl.totalIncome))/sl.totalPersons*(sl.numAdult+sl.numChild+sl.numGuide)}" pattern="#.##"></fmt:formatNumber>% 
			              	</c:if>
	              		</c:if>
              		</c:if>
			  </td>
              <td>
              		<c:if test="${sl.totalPersons==0}">-</c:if>
              		<c:if test="${sl.totalPersons!=0}">
						<c:if test="${(sl.numAdult+sl.numChild+sl.numGuide)!=0}">
	              		<fmt:formatNumber type="percent" value="${(sl.totalIncome-sl.totalCost)/sl.totalPersons}" pattern="#.##"></fmt:formatNumber>
	              		</c:if>
              		</c:if>
			</td>
         	</tr>
         	<c:set var="sum_orderNum" value="${sum_orderNum+sl.orderNum}" />
         	<c:set var="sum_adult" value="${sum_adult+sl.numAdult}" />
			<c:set var="sum_child" value="${sum_child+sl.numChild}" />
			<c:set var="sum_guide" value="${sum_guide+sl.numGuide}" />
			<c:set var="sum_orderIncome" value="${sum_orderIncome+sl.orderIncome}" />
			<c:set var="sum_otherIncome" value="${sum_otherIncome+sl.otherIncome}" />
			<c:set var="sum_shopIncome" value="${sum_shopIncome+sl.rayPayIncome-sl.fsIncome}" />
			<c:set var="sum_totalIncome" value="${sum_totalIncome+sl.totalIncome}" />
			<c:set var="sum_totalCost" value="${sum_totalCost+sl.totalCost}" />
       	</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td style="text-align: right">本页合计：</td>
			<td>${sum_orderNum}</td>
			<td>${sum_adult}</td>
			<td>${sum_child}</td>
			<td>${sum_guide}</td>
			<td><fmt:formatNumber type="percent" value="${sum_orderIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_otherIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_shopIncome}" pattern="#.##"></fmt:formatNumber></td>
		    <td><fmt:formatNumber type="percent" value="${sum_totalIncome}" pattern="#.##"></fmt:formatNumber></td>
         	<td><fmt:formatNumber type="percent" value="${sum_totalCost}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_totalIncome-sum_totalCost}" pattern="#.##"></fmt:formatNumber></td>
			<td>
				<c:if test="${sl.sum_totalIncome!=0}">
				<fmt:formatNumber type="percent" value="${(sum_totalIncome-sum_totalCost)*100/sum_totalIncome}" pattern="#.##"></fmt:formatNumber>%
				</c:if>
			</td>
			<td>
				<c:if test="${(sum_adult+sum_child+sum_guide)!=0}">
              		<fmt:formatNumber type="percent" value="${(sum_totalIncome-sum_totalCost)/(sum_adult+sum_child+sum_guide)}" pattern="#.##"></fmt:formatNumber>
              	</c:if>
			</td>
		</tr>
		<tr>
			<td></td>
			<td style="text-align: right">总合计：</td>
			<td>${sum.sumOrderNum}</td>
			<td>${sum.sumAdult}</td>
			<td>${sum.sumChild}</td>
			<td>${sum.sumGuide}</td>
			<td><fmt:formatNumber type="percent" value="${sum.sumOrderIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumOtherIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumRayPayIncome-sum.sumFsIncome}" pattern="#.##"></fmt:formatNumber></td>		
		    <td><fmt:formatNumber type="percent" value="${sum.sumTotalIncome}" pattern="#.##"></fmt:formatNumber></td>
         	<td><fmt:formatNumber type="percent" value="${sum.sumTotalCost}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumTotalIncome-sum.sumTotalCost}" pattern="#.##"></fmt:formatNumber></td>
			<td>
				<c:if test="${sl.sumTotalIncome!=0}">
				<fmt:formatNumber type="percent" value="${(sum.sumTotalIncome-sum.sumTotalCost)*100/sum.sumTotalIncome}" pattern="#.##"></fmt:formatNumber>%
				</c:if>
			</td>
			<td>
				<c:if test="${(sum.sumAdult+sum.sumChild+sum.sumGuide)!=0}">
              		<fmt:formatNumber type="percent" value="${(sum.sumTotalIncome-sum.sumTotalCost)/(sum.sumAdult+sum.sumChild+sum.sumGuide)}" pattern="#.##"></fmt:formatNumber>
              	</c:if>
			</td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page}" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize}" name="ps" />
	<jsp:param value="${page.totalCount}" name="tn" />
</jsp:include>

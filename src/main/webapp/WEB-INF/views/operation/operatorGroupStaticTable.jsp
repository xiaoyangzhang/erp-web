<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../include/top.jsp"%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>团数<i class="w_table_split"></i></th>
			<th>成人<i class="w_table_split"></i></th>
			<th>儿童<i class="w_table_split"></i></th>
			<th>全陪<i class="w_table_split"></i></th>
			<th>团款收入<i class="w_table_split"></i></th>
			<th>其他收入<i class="w_table_split"></i></th>
			<th>进店收入<i class="w_table_split"></i></th>
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
              <td>${sl.operatorName}</td>
              <td>${sl.groupNum}</td>
              <td>${sl.totalAdult}</td>
              <td>${sl.totalChild}</td>
              <td>${sl.totalGuide}</td>
              <td><fmt:formatNumber type="percent" value="${sl.groupIncome}" pattern="#.##"></fmt:formatNumber></td>
              <td><fmt:formatNumber type="percent" value="${sl.otherIncome}" pattern="#.##"></fmt:formatNumber></td>
              <td><fmt:formatNumber type="percent" value="${sl.shopTotalIncome}" pattern="#.##"></fmt:formatNumber></td>
              <td><fmt:formatNumber type="percent" value="${sl.totalIncome}" pattern="#.##"></fmt:formatNumber></td>
              <td><fmt:formatNumber type="percent" value="${sl.groupCost}" pattern="#.##"></fmt:formatNumber></td>
              <td><fmt:formatNumber type="percent" value="${sl.totalIncome-sl.groupCost}" pattern="#.##"></fmt:formatNumber></td>
              <td>
              	<c:if test="${(sl.totalIncome-sl.groupCost) > 0}">
	              	<c:if test="${sl.totalIncome!='0.0000'}">
	              		<fmt:formatNumber type="percent" value="${(sl.totalIncome-sl.groupCost)*100/(sl.totalIncome)}" pattern="#.##"></fmt:formatNumber>% 
	              	</c:if>
              	</c:if>
              </td>
              <td>
              	<c:if test="${(sl.totalAdult+sl.totalChild+sl.totalGuide)!=0}">
              		<fmt:formatNumber type="percent" value="${(sl.totalIncome-sl.groupCost)/(sl.totalAdult+sl.totalChild+sl.totalGuide)}" pattern="#.##"></fmt:formatNumber>
              	</c:if>
              </td>
         	</tr>
         	<c:set var="sum_groupNum" value="${sum_groupNum+sl.groupNum}" />
         	<c:set var="sum_adult" value="${sum_adult+sl.totalAdult}" />
			<c:set var="sum_child" value="${sum_child+sl.totalChild}" />
			<c:set var="sum_guide" value="${sum_guide+sl.totalGuide}" />
			<c:set var="sum_groupIncome" value="${sum_groupIncome+sl.groupIncome}" />
			<c:set var="sum_otherIncome" value="${sum_otherIncome+sl.otherIncome}" />
			<c:set var="sum_shopTotalIncome" value="${sum_shopTotalIncome+sl.shopTotalIncome}" />
			<c:set var="sum_totalIncome" value="${sum_totalIncome+sl.totalIncome}" />
			<c:set var="sum_groupCost" value="${sum_groupCost+sl.groupCost}" />
       	</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td></td>
			<td style="text-align: right">本页合计：</td>
			<td>${sum_groupNum}</td>
			<td>${sum_adult}</td>
			<td>${sum_child}</td>
			<td>${sum_guide}</td>
			<td><fmt:formatNumber type="percent" value="${sum_groupIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_otherIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_shopTotalIncome}" pattern="#.##"></fmt:formatNumber></td>
		    <td><fmt:formatNumber type="percent" value="${sum_totalIncome}" pattern="#.##"></fmt:formatNumber></td>
         	<td><fmt:formatNumber type="percent" value="${sum_groupCost}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum_totalIncome-sum_groupCost}" pattern="#.##"></fmt:formatNumber></td>
			<td>
				<c:if test="${(sum_totalIncome-sum_groupCost) > 0}">
					<c:if test="${sum_totalIncome!='0.0000'}">
	              		<fmt:formatNumber type="percent" value="${(sum_totalIncome-sum_groupCost)*100/sum_totalIncome}" pattern="#.##"></fmt:formatNumber>% 
	              	</c:if>
              	</c:if>
			</td>
			<td>
				<c:if test="${(sum_adult+sum_child+sum_guide)!=0}">
              		<fmt:formatNumber type="percent" value="${(sum_totalIncome-sum_groupCost)/(sum_adult+sum_child+sum_guide)}" pattern="#.##"></fmt:formatNumber>
              	</c:if>
			</td>
		</tr>
		<tr>
			<td></td>
			<td style="text-align: right">总合计：</td>
			<td>${sum.sumGroupNum}</td>
			<td>${sum.sumAdult}</td>
			<td>${sum.sumChild}</td>
			<td>${sum.sumGuide}</td>
			<td><fmt:formatNumber type="percent" value="${sum.sumGroupIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumOtherIncome}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumShopTotalIncome}" pattern="#.##"></fmt:formatNumber></td>
		    <td><fmt:formatNumber type="percent" value="${sum.sumTotalIncome}" pattern="#.##"></fmt:formatNumber></td>
         	<td><fmt:formatNumber type="percent" value="${sum.sumGroupCost}" pattern="#.##"></fmt:formatNumber></td>
			<td><fmt:formatNumber type="percent" value="${sum.sumTotalIncome-sum.sumGroupCost}" pattern="#.##"></fmt:formatNumber></td>
			<td>
				<c:if test="${(sum.sumTotalIncome-sum.sumGroupCost) > 0}">
					<c:if test="${sum.sumTotalIncome!='0.0000'}">
	              		<fmt:formatNumber type="percent" value="${(sum.sumTotalIncome-sum.sumGroupCost)*100/sum.sumTotalIncome}" pattern="#.##"></fmt:formatNumber>% 
	              	</c:if>
	            </c:if>
			</td>
			<td>
				<c:if test="${(sum.sumAdult+sum.sumChild+sum.sumGuide)!=0}">
              		<fmt:formatNumber type="percent" value="${(sum.sumTotalIncome-sum.sumGroupCost)/(sum.sumAdult+sum.sumChild+sum.sumGuide)}" pattern="#.##"></fmt:formatNumber>
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

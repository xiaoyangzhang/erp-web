<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >产品<i class="w_table_split"></i></th>
			<th >组团社<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >12岁以下<i class="w_table_split"></i></th>
			<th >13岁~23岁<i class="w_table_split"></i></th>
			<th >24岁~28岁<i class="w_table_split"></i></th>
			<th >29岁~49岁<i class="w_table_split"></i></th>
			<th >50岁~55岁<i class="w_table_split"></i></th>
			<th >56岁~65岁<i class="w_table_split"></i></th>
			<th >66岁以上<i class="w_table_split"></i></th>
			
			<th  >预算人均成本<i class="w_table_split"></i></th>
			<th >人均收客价<i class="w_table_split"></i></th>
			<th >人均购物<i class="w_table_split"></i></th>
			<th >总收入<i class="w_table_split"></i></th>
			<th >总购物<i class="w_table_split"></i></th>
		</tr>
		
		
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.productBrandName}-${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td >${v.orderCount}</td>
				<td >${v.adultCount}大${v.childCount }小</td>
				<td>${ v['12以下']==null?0:v['12以下']}</td>
				<td>${ v['13~23']==null?0:v['13~23']}</td>
				<td>${ v['24~28']==null?0:v['24~28']}</td>
				<td>${ v['29~49']==null?0:v['29~49']}</td>
				<td>${ v['50~55']==null?0:v['50~55']}</td>
				<td>${ v['56~65']==null?0:v['56~65']}</td>
				<td>${ v['66以上']==null?0:v['66以上']}</td>
				<td><c:choose>
				<c:when test="${v.adultCount +v.childCount eq 0}">0</c:when>
				<c:otherwise>
				 <fmt:formatNumber value="${ v.totalPrice/(v.adultCount+ v.childCount )}" pattern="#.##" type="number"/> 
				
				</c:otherwise>
				</c:choose>
				</td>
				<td>
				<c:choose>
				<c:when test="${v.adultCount +v.childCount eq 0}">0</c:when>
				<c:otherwise>
				<fmt:formatNumber value="${  v.total/(v.adultCount+ v.childCount )}" pattern="#.##" type="number"/> 
				
				</c:otherwise>
				</c:choose>
				</td>
				<td>
				<c:choose>
				<c:when test="${v.adultCount  eq 0}">0</c:when>
				<c:otherwise>
				
				<fmt:formatNumber value="${  v.buyTotal/v.adultCount}" pattern="#.##" type="number"/> 
				</c:otherwise>
				</c:choose></td>
				<td><fmt:formatNumber value="${v.total==null?0:v.total }" pattern="#.##" type="number"/></td>
				<td><fmt:formatNumber value="${v.buyTotal==null?0:v.buyTotal }" pattern="#.##" type="number"/></td>
			</tr>
			<c:set var="sum_total" value="${sum_total+v.total }" />
			<c:set var="sum_buyTotal" value="${sum_buyTotal+v.buyTotal }" />
			<c:set var="sum_age1" value="${sum_age1+v['12以下']}" />
			<c:set var="sum_age2" value="${sum_age2+v['13~23']}" />
			<c:set var="sum_age3" value="${sum_age3+v['24~28']}" />
			<c:set var="sum_age4" value="${sum_age4+v['29~49']}" />
			<c:set var="sum_age5" value="${sum_age5+v['50~55']}" />
			<c:set var="sum_age6" value="${sum_age6+v['56~65']}" />
			<c:set var="sum_age7" value="${sum_age7+v['66以上']}" />
			<c:set var="sum_order" value="${sum_order+v.orderCount}" />
			<c:set var="sum_adult" value="${sum_adult+v.adultCount}" />
			<c:set var="sum_child" value="${sum_child+v.childCount}" />
			
			
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="3" >本页合计：</td>
			<td>${ sum_order}</td>
			<td>${ sum_adult}大${ sum_child}小</td>
		     <td>${sum_age1 }</td>
		    <td>${sum_age2 }</td>
		    <td>${sum_age3 }</td>
		    <td>${sum_age4 }</td>
		    <td>${sum_age5 }</td>
		    <td>${sum_age6 }</td>
		    <td>${sum_age7 }</td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td><fmt:formatNumber value="${sum_total }" pattern="#.##" type="number"/></td>
		    <td><fmt:formatNumber value="${sum_buyTotal }" pattern="#.##" type="number"/></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

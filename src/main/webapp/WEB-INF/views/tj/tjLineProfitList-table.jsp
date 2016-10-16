<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table" >
	<col width="3%" />
	<col width="10%" />
	<col width="8%" />
	<col width="5%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<thead>
		<tr>
			<td rowspan="2">序号<i class="w_table_split"></i></td>
			<td rowspan="2">品牌名称<i class="w_table_split"></i></td>
			<td rowspan="2">收客人数<i class="w_table_split"></i></td>
			<td rowspan="2">收客占比<i class="w_table_split"></i></td>
			
			<td colspan="4">收入<i class="w_table_split"></i></td>
			<td colspan="3">成本<i class="w_table_split"></i></td>
			
			<td rowspan="2">毛利<i class="w_table_split"></i></td>
			<td rowspan="2">人均毛利<i class="w_table_split"></i></td>
			<td rowspan="2">总购物<i class="w_table_split"></i></td>
			<td rowspan="2">人均购物<i class="w_table_split"></i></td>
		</tr>
		<tr>
			<td >团款收入<i class="w_table_split"></i></td>
			<td >人均团款<i class="w_table_split"></i></td>
			<td >其他收入<i class="w_table_split"></i></td>
			<td >购物收入<i class="w_table_split"></i></td>
			
			<td >单团成本<i class="w_table_split"></i></td>
			<td >人均成本<i class="w_table_split"></i></td>
			<td >购物成本<i class="w_table_split"></i></td>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.product_brand_name}</td>
				<td>${item.total_adult}大${item.total_child}小${item.total_guide}陪</td>
				<td>
				<c:if test="${empty all_sum_person or all_sum_person eq 0}">0</c:if>
				
				<c:if test="${not empty all_sum_person and (all_sum_person >0 or all_sum_person <0)}">
					<fmt:formatNumber value="${item.sum_person*100/all_sum_person}" pattern="#.####" type="currency"/>% 
				</c:if>
				</td>
				<!--团款收入 -->
				<td><fmt:formatNumber value="${item.income_order}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
					<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
						<fmt:formatNumber value="${item.income_order/item.total_adult}" pattern="#.##" type="currency"/>
					</c:if>
				</td>
				<td><fmt:formatNumber value="${item.income_other}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.shop_repay}" pattern="#.##" type="currency"/></td>
				<!--单团成本 -->
				<td><fmt:formatNumber value="${item.total_expense}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
					<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
						<fmt:formatNumber value="${item.total_expense/item.total_adult}" pattern="#.##" type="currency"/>
					</c:if>
				</td>
				<td><fmt:formatNumber value="${item.shop_commission}" pattern="#.##" type="currency"/></td>
				<!--毛利 -->
				<td><fmt:formatNumber value="${item.total_profit}" pattern="#.##" type="currency"/></td>
				<td >
					<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
					<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
						<fmt:formatNumber value="${item.total_profit/item.total_adult}" pattern="#.##" type="currency"/>
					</c:if>
				</td>
				<td><fmt:formatNumber value="${item.shop_sales}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
					<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
						<fmt:formatNumber value="${item.shop_sales/item.total_adult}" pattern="#.##" type="currency"/>
					</c:if>
				</td>
				
				<c:set var="sum_total_adult" value="${sum_total_adult+item.total_adult }" />
				<c:set var="sum_total_child" value="${sum_total_child+item.total_child }" />
				<c:set var="sum_total_guide" value="${sum_total_guide+item.total_guide }" />
				<c:set var="sum_income_order" value="${sum_income_order+item.income_order }" />
				<c:set var="sum_income_other" value="${sum_income_other+item.income_other }" />
				<c:set var="sum_shop_repay" value="${sum_shop_repay+item.shop_repay }" />
				<c:set var="sum_total_profit" value="${sum_total_profit+item.total_profit }" />
				<c:set var="sum_total_expense" value="${sum_total_expense+item.total_expense }" />
				<c:set var="sum_shop_commission" value="${sum_shop_commission+item.shop_commission }" />
				<c:set var="sum_shop_sales" value="${sum_shop_sales+item.shop_sales }" />
				
			</tr>
		</c:forEach>
		<tr>
			<td colspan="2">本页合计：</td>
			<td>${sum_total_adult}大${sum_total_child}小${sum_total_guide}陪</td>
			<td></td>
			<td><fmt:formatNumber value="${sum_income_order}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_income_other}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_shop_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_expense}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_shop_commission}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_profit}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_shop_sales}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="2">总合计：</td>
			<td>${all_total_adult}大${all_total_child}小${all_total_guide}陪</td>
			<td></td>
			<td><fmt:formatNumber value="${all_income_order}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${all_income_other}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${all_shop_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${all_total_expense}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${all_shop_commission}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${all_total_profit}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${all_shop_sales}" pattern="#.##" type="currency"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
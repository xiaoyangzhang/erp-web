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
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="15%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>购物店<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>人均购物<i class="w_table_split"></i></th>
			<th>购物返款<i class="w_table_split"></i></th>
			<th>应收合计<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>欠收<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.shop_supplier_name}</td>
				<td>${item.person_num }</td>
				<td><fmt:formatNumber value="${item.total_fact }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.person_buy_avg}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_repay }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_repay }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_repay - item.total_cash }" pattern="#.##" type="currency"/></td>
				
				<c:set var="sum_person_num" value="${sum_person_num + item.person_num}" />
				<c:set var="sum_total_fact" value="${sum_total_fact + item.total_fact}" />
				<c:set var="sum_person_buy_avg" value="${sum_person_buy_avg + item.person_buy_avg}" />
				<c:set var="sum_total_repay" value="${sum_total_repay + item.total_repay}" />
				<c:set var="sum_total_cash" value="${sum_total_cash + item.total_cash}" />
			</tr>
		</c:forEach>
		<tr>
			<td colspan="2">本页合计：</td>
			<td>${sum_person_num}</td>
			<td><fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/></td>
			<td>
				<c:if test="${sum_person_num eq 0}">
					<fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/>
				</c:if>
				<c:if test="${sum_person_num ne 0}">
					<fmt:formatNumber value="${sum_total_fact/sum_person_num}" pattern="#.##" type="currency"/>
				</c:if>
			</td>
			<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_repay - sum_total_cash}" pattern="#.##" type="currency"/></td>
		</tr>
		<tr>
			<td colspan="2">总合计：</td>
			<td><fmt:formatNumber value="${totalMap.all_person_num}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_fact}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_person_buy_avg}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_cash}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_repay - totalCommMap.all_total_cash}" pattern="#.##" type="currency"/></td>
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
<script type="text/javascript">
	$(function(){
		var docHeight = $(window).height()-240;		
		var minHeight=498;
		var tHeight=docHeight+"px";
		if(docHeight>minHeight){
			tHeight=minHeight+"px";
		}
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})
</script>
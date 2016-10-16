<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="w_table" id="payTable">
	<colgroup>
		<col width="4%" />
		<col width="18%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
		<col width="6%" />
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>总欠收<i class="w_table_split"></i></th>
			<th>12月欠收<i class="w_table_split"></i></th>
			<th>11月欠收<i class="w_table_split"></i></th>
			<th>10月欠收<i class="w_table_split"></i></th>
			<th>9月欠收<i class="w_table_split"></i></th>
			<th>8月欠收<i class="w_table_split"></i></th>
			<th>7月欠收<i class="w_table_split"></i></th>
			<th>6月欠收<i class="w_table_split"></i></th>
			<th>5月欠收<i class="w_table_split"></i></th>
			<th>4月欠收<i class="w_table_split"></i></th>
			<th>3月欠收<i class="w_table_split"></i></th>
			<th>2月欠收<i class="w_table_split"></i></th>
			<th>1月欠收<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.supplier_name}</td>
				<td><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m12}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m11}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m10}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m9}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m8}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m7}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m6}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m5}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m4}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m3}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m2}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.m1}" type="currency" pattern="#.##"/></td>
			</tr>
			<c:set var="sum_total" value="${sum_total+v.total}" />
			<c:set var="sum_m12" value="${sum_m12+v.m12}" />
			<c:set var="sum_m11" value="${sum_m11+v.m11 }" />
			<c:set var="sum_m10" value="${sum_m10+v.m10}" />
			<c:set var="sum_m9" value="${sum_m9+v.m9 }" />
			<c:set var="sum_m8" value="${sum_m8+v.m8}" />
			<c:set var="sum_m7" value="${sum_m7+v.m7}" />
			<c:set var="sum_m6" value="${sum_m6+v.m6 }" />
			<c:set var="sum_m5" value="${sum_m5+v.m5 }" />
			<c:set var="sum_m4" value="${sum_m4+v.m4}" />
			<c:set var="sum_m3" value="${sum_m3+v.m3 }" />
			<c:set var="sum_m2" value="${sum_m2+v.m2 }" />
			<c:set var="sum_m1" value="${sum_m1+v.m1 }" />
		
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="2">合计：</td>
			<td><fmt:formatNumber value="${sum_total}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m12}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m11}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m10}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m9}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m8}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m7}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m6}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m5}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m4}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m3}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m2}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_m1}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td colspan="2">总计：</td>
			<td><fmt:formatNumber value="${sum.total}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m12}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m11}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m10}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m9}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m8}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m7}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m6}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m5}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m4}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m3}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m2}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.m1}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>姓名<i class="w_table_split"></i></th>
			<!-- <th>导游证号<i class="w_table_split"></i></th> -->
			<th>已报账<i class="w_table_split"></i></th>
			<th>未报账<i class="w_table_split"></i></th>
			<th>团数<i class="w_table_split"></i></th>
			<th>带团人数<i class="w_table_split"></i></th>
			<th>计划购物<i class="w_table_split"></i></th>
			<th>实际购物<i class="w_table_split"></i></th>
			<th>人均<i class="w_table_split"></i></th>
			<th>完成率<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.guideName}（${v.guideMobile}）</td>
				<%-- <td>${v.guideNo}</td> --%>
				<td>${v.state2}</td>
				<td>${v.state0}</td>
				<td>${v.groupCount}</td>
				<td>${v.adult}</td>
				<td><fmt:formatNumber value="${v.jh}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${v.sj}" pattern="#.##" type="currency"/></td>
				<td>				
				<c:if test="${v.adult != '0' }">
				 <fmt:formatNumber value="${v.sj/v.adult}" pattern="#.##" type="currency" />
				</c:if>
				<c:if test="${v.adult == '0' }">
				 <fmt:formatNumber value="0.00" pattern="#.##" type="currency" />
				</c:if>
				</td>
				<td>
				<c:if test="${v.jh == '0.0000'}">0</c:if>
				<c:if test="${v.jh != '0.0000' }">
				 <fmt:formatNumber type="currency"   value="${v.sj/v.jh*100}" pattern="#.##" />
				</c:if>
				%
				</td>

			</tr>
			<c:set var="sum_state0" value="${sum_state0+v.state0 }" />
			<c:set var="sum_state2" value="${sum_state2+v.state2 }" />
			<c:set var="sum_groupcnt" value="${sum_groupcnt+v.groupCount }" />
			<c:set var="sum_adult" value="${sum_adult+v.adult }" />
			<c:set var="sum_jh" value="${sum_jh+v.jh }" />
			<c:set var="sum_sj" value="${sum_sj+v.sj }" />
		</c:forEach>
		<tr>
				<td colspan="2" style="text-align:right;">合计：</td>				
				<td>${sum_state2 }</td>
				<td>${sum_state0 }</td>
				<td>${sum_groupcnt }</td>
				<td>${sum_adult }</td>
				<td><fmt:formatNumber value="${sum_jh }" pattern="#.##" type="currency" /></td>
				<td><fmt:formatNumber value="${sum_sj }" pattern="#.##" type="currency" /></td>
				<td><fmt:formatNumber value="${sum_sj/sum_adult }" pattern="#.##" type="currency" /></td>
				<td>				
				</td>
				
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;">总计：</td>				
				<td>${state2 }</td>
				<td>${state0 }</td>
				<td>${groupCount }</td>
				<td>${adult }</td>
				<td><fmt:formatNumber value="${jh}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${sj}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${sj/adult}" pattern="#.##" type="currency"/></td>
				<td>				
				</td>
				
			</tr>
	</tbody>
	
</table>
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" import="java.util.Date,java.text.SimpleDateFormat" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>
<table cellspacing="0" cellpadding="0" class="w_table">
<col width="5%" /><col width="17%" /><col width="17%" /><col width="6%" /><col width="6%" /><col width="6%" />
		             	<col width="6%" /><col width="6%" /><col width="6%" /><col width="6%" /><col width="6%" /><col width="6%" /><col width="6%" /><col width="6%" />
			             
	<thead>
		<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >产品名称<i class="w_table_split"></i></th>
			<th >组团社<i class="w_table_split"></i></th>
			 <th >订单数<i class="w_table_split"></i></th>
			<th >总人数<i class="w_table_split"></i></th> 
			<th >0岁~2岁<i class="w_table_split"></i></th>
			<th >3岁~12岁<i class="w_table_split"></i></th>
			
			<th >13岁~23岁<i class="w_table_split"></i></th>
			<th  >24岁~28岁<i class="w_table_split"></i></th>
			<th >29岁~49岁<i class="w_table_split"></i></th>
			<th >50岁~55岁<i class="w_table_split"></i></th>
			<th >56岁~65岁<i class="w_table_split"></i></th>
			<th >66岁~100岁<i class="w_table_split"></i></th>
		</tr>
		
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
		
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName }</td>
				<td>${v.orderCount}</td>
				<td>${v.adultCount}大${v.childCount }小</td> 
				
					<td>
					${v['0~2']==null?0:v['0~2']}
					</td>
					<td>
					${v['3~12']==null?0:v['3~12']}
					</td>
					<td>
					${v['13~23']==null?0:v['13~23']}
					</td>
					<td>
					${v['24~28']==null?0:v['24~28']}
					</td>
					<td>
					${v['29~49']==null?0:v['29~49']}
					</td>
					<td>
					${v['50~55']==null?0:v['50~55']}
					</td>
					<td>
					${v['56~65']==null?0:v['56~65']}
					</td>
					<td>
					${v['65以上']==null?0:v['65以上']}
					</td>
					
			</tr>
			<c:set var="sum_age1" value="${sum_age1+v['0~2']}" />
			<c:set var="sum_age2" value="${sum_age2+v['3~12']}" />
			<c:set var="sum_age3" value="${sum_age3+v['13~23']}" />
			<c:set var="sum_age4" value="${sum_age4+v['24~28']}" />
			<c:set var="sum_age5" value="${sum_age5+v['29~49']}" />
			<c:set var="sum_age6" value="${sum_age6+v['50~55']}" />
			<c:set var="sum_age7" value="${sum_age7+v['56~65']}" />
			<c:set var="sum_age8" value="${sum_age8+v['65以上']}" /> 
					 <c:set var="sum_order" value="${sum_order+v.orderCount}" />  
			 <c:set var="sum_adult" value="${sum_adult+v.adultCount}" />  
			 <c:set var="sum_child" value="${sum_child+v.childCount}" />  
			
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			
			<td colspan="3" style="text-align: left">合计：</td>
			 <td>${sum_order }</td> 
		    <td>${sum_adult }大${sum_child }小</td> 
			<td>${sum_age1 }</td>
		    <td>${sum_age2 }</td>
		    <td>${sum_age3 }</td>
		    <td>${sum_age4 }</td>
		    <td>${sum_age5 }</td>
		    <td>${sum_age6 }</td>
		    <td>${sum_age7 }</td>
		    <td>${sum_age8 }</td>
		</tr>
	</tbody>
	 <tbody>
		<tr>
			
			
			<td colspan="4" style="text-align: left">总计：</td>
			<td>${personMap.totalAdult }大${personMap.totalChild }小</td> 
			<td>
		     	<c:choose>
		     		<c:when test="${ageMap['0~2']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['0~2'] }</c:otherwise>
		     	</c:choose></td>
		    
		    <td><c:choose>
		     		<c:when test="${ageMap['3~12'] eq null}">0</c:when>
		     		<c:otherwise>${ageMap['3~12'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['13~23']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['13~23'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['24~28']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['24~28'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['29~49']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['29~49'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['50~55']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['50~55'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['56~65']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['56~65'] }</c:otherwise>
		     	</c:choose></td>
		    <td><c:choose>
		     		<c:when test="${ageMap['65以上']  eq null}">0</c:when>
		     		<c:otherwise>${ageMap['65以上']}</c:otherwise>
		     	</c:choose></td> 
		</tr>
	</tbody> 
</table>

<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<colgroup>
		<col width="4%"/>
		<col width="8%"/>
		<col width="6%"/>
		<col width="14%"/>
		<col width="12%"/>
		<col width="6%"/>
		<col width="8%"/>
		<col width="7%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="6%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品行程<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>组团社团号<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>团款<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
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
				</td>
				<td style="text-align: left">${v.departureDate}</td>
				<td style="text-align: left">【${v.productBrandName}】${v.productName}</td>
				<td style="text-align: left">${v.supplierName}
					<%-- <c:if test="${v.supplierCode!=null }">
						<br/>${v.supplierCode}
					</c:if> --%>
				</td>
				<td style="text-align: left">${v.supplierCode}</td>
				<td>${v.receiveMode}</td>
				<td>${v.provinceName}${v.cityName}</td>
				<td>${v.saleOperatorName}</td>
				<td>${v.operatorName}</td>
				<td>
					${v.numAdult}+${v.numChild}+${v.numGuide}
				</td>
				<td><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.totalCash}" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.total-v.totalCash}" type="currency" pattern="#.##"/></td>
			</tr>
			<c:set var="sum_personCount" value="${sum_personCount+v.numAdult+v.numChild+v.numGuide}" />
			<c:set var="sum_adult" value="${sum_adult+v.numAdult}" />
			<c:set var="sum_child" value="${sum_child+v.numChild}" />
			<c:set var="sum_guide" value="${sum_guide+v.numGuide}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			<td colspan="10">合计：</td>
			<td>
				<fmt:formatNumber value="${sum_adult}" type="currency" pattern="#.##"/>+
				<fmt:formatNumber value="${sum_child}" type="currency" pattern="#.##"/>+
				<fmt:formatNumber value="${sum_guide}" type="currency" pattern="#.##"/>
				</td>
			<td><fmt:formatNumber value="${sum_totalCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalCashCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_totalBalanceCount}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			
			<td colspan="10">总计：</td>
			<td>
				<fmt:formatNumber value="${sum.personCountAdult}" type="currency" pattern="#.##"/>+
				<fmt:formatNumber value="${sum.personCountChild}" type="currency" pattern="#.##"/>+
				<fmt:formatNumber value="${sum.personCountGuide}" type="currency" pattern="#.##"/>
			</td>
			<td><fmt:formatNumber value="${sum.totalCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.totalCashCount}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.totalBalanceCount}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

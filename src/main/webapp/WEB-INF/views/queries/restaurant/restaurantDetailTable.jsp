<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp" %>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="8%" />
	<col width="20%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>团计调<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>餐厅名称<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>预定日期<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody><input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;"><c:choose>
                  		<c:when test="${item.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose></td>
				<td>${item.operator_name}</td>
				<td  style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td>${item.supplier_name}</td>
				<td>${item.cash_type}</td>
				<td>${item.booking_date}</td>
				<td><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_cash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total-item.total_cash}" pattern="#.##"/></td>
				<td><a href="javascript:void(0);" onclick="showRecord(${item.id})" class="def">明细</a>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+item.total-item.total_cash }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_balance }" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>总计:</td>
			<td><fmt:formatNumber value="${sum.totalCount }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.totalCashCount }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.totalCount-sum.totalCashCount }" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
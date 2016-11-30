shopVerifyList.jsp<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="10%" />
	<col width="15%" />
	<col width="15%" />
	<col width="5%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>团类型<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>应收<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
	              </c:if>
              </td>
				<td>
					<c:if test="${item.group_mode < 1}">散客</c:if>
					<c:if test="${item.group_mode > 0}">团队</c:if>
				</td>
				<td>${item.date_start}</td>
				<td style="text-align: left;" >【${item.product_brand_name}】${item.product_name}</td>
				<td style="text-align: left;" >${item.supplier_name}</td>
				<td>${item.operator_name}</td>
				<td>
					<c:if test="${not empty item.num_adult}">${item.num_adult}大</c:if><c:if test="${not empty item.num_child}">${item.num_child}小</c:if><c:if test="${not empty item.num_guide}">${item.num_guide}陪</c:if>
				</td>
				<td><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.balance }" pattern="#.##"/></td>
				<td>
					<a class="def" href="javascript:void(0)" onclick="showInRecord({order_id:'${item.order_id}',group_code:'${item.group_code}',supplier_id:'${item.supplier_id }',supplier_name:'${item.supplier_name }',supplier_type:'${item.supplier_type }',total:'${item.total }',total_cash:'${item.total_cash }',balance:'${item.balance }'})">收款记录</a>
				</td>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+item.balance }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td></td>
			<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_balance }" pattern="#.##"/></td>
			<td></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
	<jsp:param value="inRecordQueryList" name="fnQuery" />
	<jsp:param value="inRecordPagination" name="divId" />
</jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<col width="20%" />
	<col width="5%" />
	<col width="5%" />
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
			<th>商家名称<i class="w_table_split"></i></th>
			<th>类别<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
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
					<c:if test="${item.group_mode eq 0}">散客</c:if>
					<c:if test="${item.group_mode > 0}">团队</c:if>
				</td>
				<td>${item.date_start}</td>
				<td>${item.supplier_name}</td>
				<td>
					<c:forEach items="${sup_type_map }" var="tp">
						<c:if test="${tp.key eq item.supplier_type }">${tp.value }</c:if>
					</c:forEach>
				</td>
				<td>${item.operator_name}</td>
				<td><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${item.balance }" pattern="#.##"/></td>
				<td>
					<a class="def" href="javascript:void(0)" onclick="showPayDetail({order_id:'${item.order_id}',supplier_type:'${item.supplier_type }'})">明细</a>
					<a class="def" href="javascript:void(0)" onclick="showPayRecord({order_id:'${item.order_id}',group_code:'${item.group_code}',supplier_id:'${item.supplier_id }',supplier_name:'${item.supplier_name }',supplier_type:'${item.supplier_type }',total:'${item.total }',total_cash:'${item.total_cash }',balance:'${item.balance }'})">付款记录</a>
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
	<jsp:param value="payRecordQueryList" name="fnQuery" />
	<jsp:param value="payRecordPagination" name="divId" />
</jsp:include>
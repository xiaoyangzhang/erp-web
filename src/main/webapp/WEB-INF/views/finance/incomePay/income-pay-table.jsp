<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="6%" />
	<col width="20%" />
	<col width="8%" />
	<col width="8%" />
	<col >
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>收款日期<i class="w_table_split"></i></th>
			<th>支付方式<i class="w_table_split"></i></th>
			<th>摘要<i class="w_table_split"></i></th>
			<th>本次收款<i class="w_table_split"></i></th>
			<th>已下账<i class="w_table_split"></i></th>
			<th>未下账<i class="w_table_split"></i></th>
			<th>操作员<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="record" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;" >${record.supplierName}</td>

				<td><fmt:formatDate value="${record.payDate}" pattern="yyyy-MM-dd" /></td>
				<td>${record.payType}</td>
				<td style="text-align: left;" >${record.remark}</td>
				<td><fmt:formatNumber value="${record.cash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${record.detailCash}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${record.cash-record.detailCash}" pattern="#.##"/></td>
				<td>${record.userName}</td>
				<td>
					<a class="def" onclick="newWindow('收款详情', '<%=staticPath%>/financePay/incomeView.htm?payId=${record.id }')" href="javascript:void(0);">查看</a>
					<a class="def" onclick="toIncomeEdit('${record.id }')" href="javascript:void(0);">修改</a>
					<c:if test="${empty record.detailCount}">
						<a class="def" onclick="deleteIncome('${record.id }')" href="javascript:void(0);">删除</a>
					</c:if>
				</td>
			<c:set var="sum_cash" value="${sum_cash + record.cash }" />
			<c:set var="sum_detailCash" value="${sum_detailCash + record.detailCash }" />
			<c:set var="sum_balancecash" value="${sum_cash - sum_detailCash }" />
		</c:forEach>
		
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td style="text-align: right;">合计</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_detailCash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_balancecash }" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td style="text-align: right;">总合计</td>
			<td><fmt:formatNumber value="${fp.sumCash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${fp.sumDetailCash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${fp.sumBalanceCash}" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
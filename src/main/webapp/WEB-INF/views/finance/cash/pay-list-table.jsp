<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="5%" />
	<col width="20%" />
	<col width="15%" />
	<col width="5%" />
	<col width="10%" />
<%-- 	<col width="7%" /> --%>
	<col width="10%" />
<%-- 	<col width="7%" /> --%>
<%-- 	<col width="5%" /> --%>
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>单据号<i class="w_table_split"></i></th>
			<th>付款日期<i class="w_table_split"></i></th>
			<th>我方银行<i class="w_table_split"></i></th>
<!-- 			<th>我方户名<i class="w_table_split"></i></th> -->
			<th>支付方式<i class="w_table_split"></i></th>
<!-- 			<th>对方银行<i class="w_table_split"></i></th> -->
<!-- 			<th>对方户名<i class="w_table_split"></i></th> -->
			<th>摘要<i class="w_table_split"></i></th>
			<th>本次付款<i class="w_table_split"></i></th>
			<th>操作员<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="record" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;" >${record.supplier_name}</td>
				<td>${record.pay_code}</td>
				<td><fmt:formatDate value="${record.pay_date}" pattern="yyyy-MM-dd" /></td>
				<td style="text-align: left;" >${record.left_bank}</td>
<%-- 				<td>${record.left_bank_holder}</td> --%>
				<td>${record.pay_type}</td>
<%-- 				<td style="text-align: left;" >${record.right_bank}</td> --%>
<%-- 				<td>${record.right_bank_holder}</td> --%>
				<td style="text-align: left;" >${record.remark}</td>
				<td><fmt:formatNumber value="${record.cash}" pattern="#.##"/></td>
				<td>${record.user_name}</td>
				<td>
					<a class="def" onclick="newWindow('付款详情', '<%=staticPath%>/finance/payView.htm?payId=${record.id }')" href="javascript:void(0);">查看</a>
					<a class="def" onclick="toPayEdit('${record.id }')" href="javascript:void(0);">修改</a>
					<c:if test="${empty record.detail_count}">
						<a class="def" onclick="deletePay('${record.id }')" href="javascript:void(0);">删除</a>
					</c:if>
				</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash + record.cash }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="17%" />
	<col width="5%" />
	<col width="15%" />
	<col width="10%" />
	<col width="15%" />
	<col width="10%" />
	<col width="10%" />
	<col width="15%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>类型<i class="w_table_split"></i></th>
			<th>导游名称<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>付款人<i class="w_table_split"></i></th>
			<th>报账金额<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.group_id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.group_id}&operType=0')">${item.group_code}</a>
	              </c:if>
              	</td>
              	<td>
              		<c:if test="${item.type eq 1}">佣金报账</c:if>
              		<c:if test="${item.type eq 2}">导游报账</c:if>
              	</td>
				<td>${item.guide_name}</td>
				<td><fmt:formatDate value="${item.pay_date}" pattern="yyyy-MM-dd" /></td>
				<td>${item.pay_type}</td>
				<td>${item.user_name}</td>
				<td><fmt:formatNumber value="${item.cash }" pattern="#.##"/></td>
				<td>
					<a class="def" onclick="showDetail(${item.pay_id }, ${item.type }, '${item.isCommDeduction }')" href="javascript:void(0);">查看</a>
					<c:if test="${item.type eq 1}">
						<a class="def" onclick="deleteCommPay(${item.pay_id }, '${item.isCommDeduction }')" href="javascript:void(0);">删除</a>
					</c:if>
					<c:if test="${item.type eq 2}">
						<a class="def" onclick="deletePay(${item.pay_id })" href="javascript:void(0);">删除</a>
					</c:if>
				</td>
			</tr>
			<c:set var="sum_cash" value="${sum_cash+item.cash }" />
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
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="5%" />
	<col width="10%" />
	<col width="10%" />
	<col width="20%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<c:if test="${not empty reqpm.ids || not empty reqpm.isUpdate }">
		<col width="5%" />
	</c:if>
	<thead>
		<c:if test="${reqpm.hasHead eq true}">
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>订单号/日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已经结算<i class="w_table_split"></i></th>
			<th>未结算<i class="w_table_split"></i></th>
			<th>本次付款<i class="w_table_split"></i></th>
			<c:if test="${not empty reqpm.ids || not empty reqpm.isUpdate }">
				<th>操作<i class="w_table_split"></i></th>
			</c:if>
		</tr>
		</c:if>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="order" varStatus="status">
			<tr>
				<td class="serialnum">
					<label name="serialnum">${status.index+1}</label>
					<input name="detailId" value="${order.id}" type="hidden"/>
				</td>
				<td >
					<c:if test="${order.group_mode <= 0}">
	              		<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a> 
	              	</c:if>
	              	<c:if test="${order.group_mode > 0}">
	              		<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a>
	              	</c:if>
				</td>
				<td>${order.order_no}</td>
				<td>【${order.product_brand_name}】${order.product_name}</td>
				<td>${order.operator_name}</td>
				<td>
					<c:if test="${not empty order.total}">
						<fmt:formatNumber value="${order.total }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty order.total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty order.total_cash}">
						<fmt:formatNumber value="${order.total_cash }" pattern="#.##"/></td>
					</c:if>
					<c:if test="${empty order.total_cash}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty order.balance}">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty order.balance}">0</c:if>
				</td>

				<td>
					<c:if test="${empty reqpm.ids && empty reqpm.isUpdate} ">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${not empty reqpm.isView }">
						<fmt:formatNumber value="${order.cash }" pattern="#.##"/>
					</c:if>
					<c:if test="${not empty reqpm.ids}">
						<c:if test="${not empty order.balance}">
						<input type="text" name="amount" onchange="amountChange()" oid="${order.id }" 
						class="w-100bi" style="width: 90%;" value="<fmt:formatNumber value='${order.balance }' pattern="#.##"/>" />
						</c:if>
						<c:if test="${empty order.balance }">
							<input type="text" name="amount" onchange="amountChange()" oid="${order.id }" 
						class="w-100bi" style="width: 90%;" value="0" />
						</c:if>
					</c:if>
					<c:if test="${not empty reqpm.isUpdate}">
						<input type="text" name="amount" onchange="amountChange()" oid="${order.id }" 
						class="w-100bi" style="width: 90%" value="<fmt:formatNumber value='${order.cash }' pattern="#.##"/>" />
					</c:if>
				</td>
				<c:if test="${not empty reqpm.ids }">
					<td>
						<input type="checkbox" value="${order.id}"/>
						<a class="def" href="javascript:void(0)" onclick="removeDetail('${order.id}')">移除</a>
					</td>
				</c:if>
				<c:if test="${not empty reqpm.isUpdate}">
					<td>
						<input type="checkbox" value="${order.id}"/>
						<a class="def" href="javascript:void(0)" onclick="deleteDetail('${order.id}')">移除</a>
					</td>
				</c:if>
			</tr>
		</c:forEach>
	</tbody>
</table>
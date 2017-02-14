<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="5%" />
	<col width="10%" />
	<col width="13%" />
	<col  />
	<col width="5%" />
	
	<col width="5%" />
	<col width="5%" />
	<%-- <col width="5%" /> --%>
	<col width="5%" />
	<col width="5%" />
	<thead>
			<tr>
				<th>序号<i class="w_table_split"></i></th>
				<th>团号<i class="w_table_split"></i></th>
				<th>接站牌<i class="w_table_split"></i></th>
				<th>产品名称<i class="w_table_split"></i></th>
				<th>计调<i class="w_table_split"></i></th>
				
				<th>金额<i class="w_table_split"></i></th>
				<th>已收<i class="w_table_split"></i></th>
				<!-- <th>未收<i class="w_table_split"></i></th> -->
				<th>本次付款<i class="w_table_split"></i></th>
				<th>操作<i class="w_table_split"></i></th>
			</tr>
	</thead>
	<tbody  id="tbOrder">
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
				<td style="text-align: left;">${order.receive_mode}</td>
				<td style="text-align: left;">【${order.product_brand_name}】${order.product_name}</td>
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
				<%-- <td>
					<c:if test="${not empty order.balance}">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty order.balance}">0</c:if>
				</td> --%>
				<td style="text-align: center;">
					<%-- <c:if test="${empty reqpm.ids && empty reqpm.isUpdate} ">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${not empty reqpm.isView }">
						<fmt:formatNumber value="${order.cash }" pattern="#.##"/>
					</c:if>
					<c:if test="${not empty reqpm.ids}">
						<fmt:formatNumber value='${order.balance }' pattern="#.##"/>
					</c:if>
					<c:if test="${not empty reqpm.isUpdate}">
						<fmt:formatNumber value='${order.cash }' pattern="#.##"/>
					</c:if> --%>
					<fmt:formatNumber value='${order.cash }' pattern="#.##"/>
				</td>
				<td>
					<input type="checkbox" value="${order.id}"/>
					<a class="def" href="javascript:void(0)" onclick="deleteDetail('${order.id}')">移除</a>
				</td>
				
			</tr>
			
			<c:if test="${not empty order.total}">
				<c:set var="sumTotal" value="${sumTotal+order.total }" />
			</c:if>
			<c:if test="${empty order.total}">
				<c:set var="sumTotal" value="0" />
			</c:if>
			
			<c:if test="${not empty order.total_cash}">
				<c:set var="sumTotalCash" value="${sumTotalCash+order.total_cash }" />
			</c:if>
			<c:if test="${empty order.total_cash}">
				<c:set var="sumTotalCash" value="0" />
			</c:if>
			
			<c:if test="${empty reqpm.ids && empty reqpm.isUpdate} ">
				
				<c:set var="sumBalance" value="${sumBalance+order.balance }" />
			</c:if>
			<c:if test="${not empty reqpm.isView }">
				
				<c:set var="sumBalance" value="${sumBalance+order.cash }" />
			</c:if>
			<c:if test="${not empty reqpm.ids}">
				<c:set var="sumBalance" value="${sumBalance+order.balance }" />
			</c:if>
			<c:if test="${not empty reqpm.isUpdate}">
				<c:set var="sumBalance" value="${sumBalance+order.cash }" />
			</c:if>
			
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td style="text-align: right;">合计</td>
			<td><fmt:formatNumber value="${sumTotal }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumTotalCash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumBalance }" pattern="#.##"/></td>
			<td></td>
		</tr>
		
	</tfoot>
</table>
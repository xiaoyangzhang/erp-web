<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<style>
#autoCountDivId{
	text-align: right;
	padding-top: 1%;
}
</style>
<table cellspacing="0" cellpadding="0" class="w_table">
		<col width="8%"/>
		<col width="10%"/>
		<col width="10%"/>
		<c:if test="${isShow == 1 }"><col width="10%"/></c:if>
		<col width="15%"/>
		<col />
		<%-- <col width="10%"/> --%>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>结算价<i class="w_table_split"></i></th>
			<c:if test="${isShow == 1 }"><th>采购价<i class="w_table_split"></i></th></c:if>
			<th>数量<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<!-- <th><input type="checkbox" onclick="checkAll(this)"/>操作</th> -->
		</tr>
	</thead>
	<tbody id="tb_sup_contract_price_join">
		<c:forEach items="${pageBean.result }" var="item" varStatus="vs">
			<tr>
				<td>${vs.index+1 }</td>
				<td style="text-align: left;">${item.item_type_name }
					<input type="hidden" id="itemTypeName" name="itemTypeName" value="${item.item_type_name }"/>
				</td>
				<td style="text-align: center;"><fmt:formatNumber value="${item.contract_price }" pattern="#.##" type="currency"/>
					<input type="hidden" id="contractPrice" name="contractPrice" value="<fmt:formatNumber value="${item.contract_price }" pattern="#.##" type="currency"/>"/>
				</td>
				<c:if test="${isShow == 1 }">
					<td style="text-align: center;"><fmt:formatNumber value="${item.contract_sale }" pattern="#.##" type="currency"/>
						<input type="hidden" id="contractSale" name="contractSale" value="<fmt:formatNumber value="${item.contract_sale }" pattern="#.##" type="currency"/>"/>
					</td> 
				</c:if>
				<td style="text-align: center;">
					<input type="text" id="numPerson" name="numPerson" value=""  style="width: 40%;"/>
				</td>
				<td style="text-align: left;" id="note">${item.note }
					<input type="hidden" id="note" name="note" value="${item.note }"/>
				</td>
				<%-- <td>
					<input type="checkbox" name="item.id" value="${item.id }"/>选择
				</td> --%>
				
			</tr>
		</c:forEach>
		
	</tbody>
<!-- 	<tfoot>
		<tr>
			<td colspan="3" style="text-align: right;font-weight: bold;">合计</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
	</tfoot> -->
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

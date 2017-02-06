<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String staticPath = request.getContextPath();
%>

	<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 2%">序号<i class="w_table_split"></i></th>
			<th style="width: 9%">订单号<i class="w_table_split"></i></th>
			<th style="width: 6%">旺旺号<i class="w_table_split"></i></th>
			<th style="width: 7%">自编码<i class="w_table_split"></i></th>
			<th style="width: 20%">产品<i class="w_table_split"></i></th>
			<th style="width: 6%">订单来源<i class="w_table_split"></i></th>
			<th style="width: 6%">付款时间<i class="w_table_split"></i></th>
			<th style="width: 6%">单价<i class="w_table_split"></i></th>
			<th style="width: 4%">件数<i class="w_table_split"></i></th>
			<th style="width: 6%">已付金额<i class="w_table_split"></i></th>
			<th style="width: 6%">应收金额<i class="w_table_split"></i></th>
			<th style="width: 3%">是否是特单<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:set var="sumTotal" value="0"/>
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr <c:if test="${orders.isBrushSingle==1}">style="color:red"</c:if>><td>${v.count}</td>
				<td>${orders.tid}</td>
				<td>${orders.buyerNick}</td>
				<td style="text-align:left">${orders.outerIid}
				<td style="text-align:left">${orders.title}</td>
				<td>${orders.tradeFrom}</td>
				<td><fmt:formatDate value="${orders.payTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td>${orders.price}</td>
				<td>${orders.num}</td>
				<td><fmt:formatNumber value="${orders.stepPaidFee}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${orders.payment}" pattern="#.##"/></td>
				<td>
				    <c:if test="${orders.isBrushSingle==0}">否</c:if>
                    <c:if test="${orders.isBrushSingle==1}">是</c:if> 
                </td>
				</tr>
				<c:set var="sumNum" value="${sumNum + orders.num }"/>
				<c:set var="sumTotal" value="${sumTotal + orders.payment }"/>
				<c:set var="sumStepPaidFee" value="${sumStepPaidFee + orders.stepPaidFee }"/>
		</c:forEach>
			<tr>
				<td colspan="8" style="text-align: right">合计:</td>
				<td><fmt:formatNumber value="${sumNum}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumStepPaidFee}" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
				<td></td>
			</tr>
		</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>

<SCRIPT type="text/javascript">
	function  addTaobaoOrder(){
		var retVal = [];
		$("input[type='checkbox']").each(function(){
				if ($(this).prop("checked")){
					retVal.push($(this).val())
				}
		});
		//alert(retVal);
		newWindow('新增操作单',"<%=staticPath %>/taobao/addNewTaobaoOrder.htm?retVal="+retVal);
	}
</SCRIPT>
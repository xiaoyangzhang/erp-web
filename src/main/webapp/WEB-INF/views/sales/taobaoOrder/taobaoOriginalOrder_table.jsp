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
			<th style="width: 11%">自编码<i class="w_table_split"></i></th>
			<th style="width: 20%">产品<i class="w_table_split"></i></th>
			<th style="">卖家备注<i class="w_table_split"></i></th>
			<th style="width: 6%">付款时间<i class="w_table_split"></i></th>
			<th style="width: 6%">金额<i class="w_table_split"></i></th>
			<th style="width: 6%">订单来源<i class="w_table_split"></i></th>
			<th style="width: 5%">状态<i class="w_table_split"></i></th>
			<th style="width: 3%">是否是特单<i class="w_table_split"></i></th>
			<th style="width: 3%">选择</th>
		</tr>
	</thead>
	<tbody id="tbody">
		<c:set var="sumTotal" value="0"/>
		<c:forEach items="${pageBean.result}" var="orders" varStatus="v">
				<tr><td>${v.count}</td>
				<td>
				<c:if test="${orders.orderId != null}"><a href="javascript:void(0);" class="def" onclick="lookGroup(${orders.orderId})">${orders.tid}</a></td></c:if> 
				<c:if test="${orders.orderId == null}">${orders.tid}</td></c:if> 
				<td>${orders.buyerNick}</td>
				<td style="text-align:left">${orders.outerIid}
				<td style="text-align:left">${orders.title}
				<p style="color:#666; font-size:9pt;">${orders.skuPropertiesName}</p>
				</td>

				<td style="text-align:left">${fn:escapeXml(orders.sellerMemo)}</td>
				<td><fmt:formatDate value="${orders.created}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td>${orders.payment}</td>
				<td>${orders.tradeFrom}</td>
				<td><c:if test="${orders.myState=='NEW'}">未组单</c:if> 
						<c:if test="${orders.myState=='CONFIRM'}">已组单</c:if> 
						<c:if test="${orders.myState=='CANCEL'}">废弃</c:if> 
				</td>
				<td>
				    <c:if test="${orders.isBrushSingle==0}">否</c:if>
                    <c:if test="${orders.isBrushSingle==1}"><font color="red">是</font></c:if> 
                </td>
				<td><input type="checkbox" name="idss" value="${orders.id}" vars="${orders.tid}"  <c:if test="${orders.tid}">checked</c:if>/></td>
				</tr>
				<c:set var="sumTotal" value="${sumTotal + orders.payment }"/>
				
		</c:forEach>
			<tr>
				<td colspan="2" style="text-align: right">合计:</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
				<td></td>
				<td></td>
                <td colspan="2"><a class="def" href="javascript:void(0)" onclick="addTaobaoOrder()">组单</a></td>
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
	
	function lookGroup(id){
		newWindow('查看订单','taobao/toEditTaobaoOrder.htm?id='+id+'&see=0')
	}
</SCRIPT>
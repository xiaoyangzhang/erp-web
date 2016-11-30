<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源列表</title>
    <%@ include file="/WEB-INF/include/top.jsp" %>
</head>
<body>	
<div class="searchRow" style=" text-align:center;">
<h1><font size="5" face="arial">库存调整记录</font></h1>
</div>
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 5%">序号<i class="w_table_split"></i></th>
			<th style="width: 19%">时间<i class="w_table_split"></i></th>
			<th style="width: 15%">操作人<i class="w_table_split"></i></th>
			<th style="width:  16%">类型<i class="w_table_split"></i></th>
			<th style="width: 15%">变动数量<i class="w_table_split"></i></th>
			<th style="width: 15%">订单ID<i class="w_table_split"></i></th>
			<th style="width: 15%">淘宝订单ID<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${list}" var="orders" varStatus="v">
		 <tr>
		<%--  <c:set var="surplus" value="${surplus+orders.numBalance+0}"/> --%>
		 		<td>${v.count}</td>
				<td>${orders.createTime}</td>
				<td>${orders.createUser}</td>
				<td><c:if test="${orders.taobaoOrderId==0&&orders.orderId==0}">库存变更</c:if><c:if test="${orders.taobaoOrderId>0 || orders.orderId>0}">售出</c:if></td>
				<td <c:if test="${orders.taobaoOrderId>0 || orders.orderId>0}">style="color:red"</c:if>>${orders.num}</td>
				<td><a href="javascript:void(0)"   onclick="taobaoOrder(${orders.orderId})" class="def">${orders.orderId}</a></td>
				<td>${orders.taobaoOrderId}</td>
				</tr> 
				<c:if test="${orders.taobaoOrderId==0&&orders.orderId==0}"><c:set var="sum" value="${sum+orders.num}"/></c:if>
				<c:if test="${orders.taobaoOrderId>0 || orders.orderId>0}"><c:set var="sum" value="${sum-orders.num}"/></c:if>
		</c:forEach>
      </tbody>
      	<tfoot>
       			<tr class="footer1">
					<td colspan="4" style="text-align: right">合计:</td>
					<td>${sum }</td>
					<td></td>
					<td></td>
				</tr>
	</tfoot>
</table>
</body>
<script type="text/javascript">	
function taobaoOrder(orderId){
	if(orderId>0)
	newWindow("操作单","taobao/toEditTaobaoOrder.htm?orderId="+orderId);
}
</script>
</html>
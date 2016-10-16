<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源列表</title>
	<%@ include file="../../include/top.jsp" %>
</head>
<body>	
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 6%">序号<i class="w_table_split"></i></th>
			<th style="width: 13%">日期<i class="w_table_split"></i></th>
			<th style="width: 10%">入库<i class="w_table_split"></i></th>
			<th style="width: 10%">机动位<i class="w_table_split"></i></th>
			<th style="width: 10%">已售<i class="w_table_split"></i></th>
			<th style="width: 10%">预留<i class="w_table_split"></i></th>
			<th style="width: 10%">清预留<i class="w_table_split"></i></th>
			<th style="width: 10%">取消<i class="w_table_split"></i></th>
			<th style="width: 10%">剩余<i class="w_table_split"></i></th>
			<th style="width: 11%">操作人<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${list}" var="orders" varStatus="v">
		 <tr>
		 <c:set var="surplus" value="${surplus+orders.STOCK-orders.STOCKDISABLE-orders.ORDERSOLD-orders.ORDERRESERVE+orders.ORDERCLEAN+orders.ORDERCANCEL+0}"/>
		 		<td>${v.count}</td>
				<td>${orders.adjustTime}</td>
				<td>${orders.STOCK}</td>
				<td>${orders.STOCKDISABLE}</td>
				<td>${orders.ORDERSOLD}</td>
				<td>${orders.ORDERRESERVE}</td>
				<td>${orders.ORDERCLEAN}</td>
				<td>${orders.ORDERCANCEL}</td>
				<td>${surplus} </td>
				<td>${orders.userName}</td>
				</tr> 
		</c:forEach>
      </tbody>
</table>
</body>
</html>
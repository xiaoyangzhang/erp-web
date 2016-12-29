<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>机票实时销售明细</title>
	<%@ include file="../../include/top.jsp" %>
</head>
<body>	
<div class="searchRow" style=" text-align:center;">
<h1><font size="5" face="arial">机票实时销售明细：${dateStart}苏梅包机</font></h1>
</div>
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 5%">序号<i class="w_table_split"></i></th>
			<th style="width: 22%">产品<i class="w_table_split"></i></th>
			<th style="width: 7%">成人<i class="w_table_split"></i></th>
			<th style="width: 7%">儿童<i class="w_table_split"></i></th>
			<th style="width: 7%">婴儿<i class="w_table_split"></i></th>
			<th style="width: 9%">收入<i class="w_table_split"></i></th>
			<th style="width: 9%">成本<i class="w_table_split"></i></th>
			<th style="width: 9%">利润<i class="w_table_split"></i></th>
			<th style="width: 9%">明细<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${lists}" var="orders" varStatus="v">
		 <tr>
		 		<td>${v.count}</td>
				<td>${orders.productName}</td>
				<td>${orders.totalAdult}</td>
				<td>${orders.totalChild}</td>
				<td>${orders.totalBaby}</td>
				<td><fmt:formatNumber value="${orders.totalIncome}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.totalCost}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.totalIncome-orders.totalCost}" type="currency" pattern="#.##" /></td>
				<td>明细</td>
				</tr> 
				<c:set var="totalAdult" value="${totalAdult+orders.totalAdult}" />
				<c:set var="totalChild" value="${totalChild+orders.totalChild}" />
				<c:set var="totalBaby" value="${totalBaby+orders.totalBaby}" />
				<c:set var="totalIncome" value="${totalIncome+orders.totalIncome}" />
				<c:set var="totalCost" value="${totalCost+orders.totalCost}" />
		</c:forEach>
      </tbody>
       <tfoot>
		<tr class="footer1">
			<td></td>
            <td>合计</td>
            <td>${totalAdult}</td>
            <td>${totalChild}</td>
            <td>${totalBaby}</td>            
            <td><fmt:formatNumber value="${totalIncome}" type="currency" pattern="#.##" /></td>
 			<td><fmt:formatNumber value="${totalCost}" type="currency" pattern="#.##" /></td>
            <td><fmt:formatNumber value="${totalIncome-totalCost}" type="currency" pattern="#.##" /></td>
            <td></td>
		</tr>
	</tfoot>
</table>
</body>
</html>
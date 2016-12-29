<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>机票销售预算明细</title>
	<%@ include file="../../include/top.jsp" %>
</head>
<body>	
<div class="searchRow" style=" text-align:center;">
<h1><font size="5" face="arial">机票销售预算明细：${dateStart}苏梅包机</font></h1>
</div>
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 5%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">产品<i class="w_table_split"></i></th>
			<th style="width: 10%">库存<i class="w_table_split"></i></th>
			<th style="width: 10%">已售<i class="w_table_split"></i></th>
			<th style="width: 10%">剩余<i class="w_table_split"></i></th>
			<th style="width: 10%">成人价<i class="w_table_split"></i></th>
			<th style="width: 9%">机票<i class="w_table_split"></i></th>
			<th style="width: 9%">房费<i class="w_table_split"></i></th>
			<th style="width: 9%">接送<i class="w_table_split"></i></th>
			<th style="width: 9%">其他<i class="w_table_split"></i></th>
			<th style="width: 9%">利润<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${lists}" var="orders" varStatus="v">
		 <tr>
		 		<td>${v.count}</td>
				<td>${orders.productName}</td>
				<td>${orders.numStock}</td>
				<td>${orders.numSold}</td>
				<td>${orders.numStock-orders.numSold}</td>
				<td><fmt:formatNumber value="${orders.adultSuggestPrice-orders.adultSamePay-orders.adultProxyPay}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.adultCostTicket}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.adultCostHotel}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.adultCostJs}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.adultCostOther}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${orders.adultSuggestPrice-orders.adultSamePay-orders.adultProxyPay-orders.adultCostTicket-orders.adultCostHotel-orders.adultCostOther-orders.adultCostJs}" type="currency" pattern="#.##" /></td>
				</tr> 
				<c:set var="numStock" value="${numStock+orders.numStock}" />
				<c:set var="numSold" value="${numSold+orders.numSold}" />
			<%-- 	<c:set var="adultSuggestPrice" value="${adultSuggestPrice+orders.adultSuggestPrice}" />
				<c:set var="adultSamePay" value="${adultSamePay+orders.adultSamePay}" />
				<c:set var="adultProxyPay" value="${adultProxyPay+orders.adultProxyPay}" />
				<c:set var="adultCostTicket" value="${adultCostTicket+orders.adultCostTicket}" />
				<c:set var="adultCostHotel" value="${adultCostHotel+orders.adultCostHotel}" />
				<c:set var="adultCostJs" value="${adultCostJs+orders.adultCostJs}" />
				<c:set var="adultCostOther" value="${adultCostOther+orders.adultCostOther}" /> --%>
		</c:forEach>
      </tbody>
         <tfoot>
		<tr class="footer1">
			<td></td>
            <td>合计</td>
 			<td>${numStock}</td>
            <td>${numSold}</td>
            <td>${numStock-numSold}</td>
            <td></td>            
           	<td></td>
            <td></td>
 			<td></td>
            <td></td>
            <td></td>
		</tr>
	</tfoot>
</table>
</body>
</html>
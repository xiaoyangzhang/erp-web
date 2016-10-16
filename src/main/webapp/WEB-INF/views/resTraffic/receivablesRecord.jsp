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
    		<th style="width: 7%">序号<i class="w_table_split"></i></th>
			<th style="width: 20%">收款时间<i class="w_table_split"></i></th>
			<th style="width: 15%">金额<i class="w_table_split"></i></th>
			<th style="width: 13%">类别<i class="w_table_split"></i></th>
			<th style="width: 15%">收款人<i class="w_table_split"></i></th>
			<th style="width: 30%">备注<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${fpd}" var="orders" varStatus="v">
		 <tr>
		 		<td>${v.count }</td>
		 		<td>${orders.payDate }</td>
				<td><fmt:formatNumber value="${orders.cash }" pattern="#.##"/></td>
				<td>${orders.payType} </td>
				<td>${orders.userName}</td>
				<td>${orders.remark}</td>
				</tr> 
		</c:forEach>
      </tbody>
</table>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参团信息</title>
<%@ include file="../../../../include/top.jsp"%>
</head>
<body>
	<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>操作计调<i class="w_table_split"></i></th>
			<th>销售计调<i class="w_table_split"></i></th>
	</thead>
	<tbody>
       	<c:forEach items="${orders}" var="o" varStatus="v">
       		<tr>
              <td>${v.count}</td>
              <td>${o.tourGroup.groupCode}</td>
              <td>${o.supplierName}</td>
              <td>${o.departureDate}</td>
              <td>${o.productName}</td>
              <td>${o.operatorName}</td>
              <td>${o.saleOperatorName}</td>
                 
         	</tr>
       	</c:forEach>
	</tbody>
</table>
</body>
</html>
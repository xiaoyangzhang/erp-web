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
<div class="searchRow" style=" text-align:center;">
<h1><font size="5" face="arial">资源名称：${name}  开始日期：${dateStart }</font></h1>
</div>
	<table cellspacing="0" cellpadding="0" class="w_table">
       <thead>
    <tr>
    		<th style="width: 10%">序号<i class="w_table_split"></i></th>
			<th style="width: 13%">日期<i class="w_table_split"></i></th>
			<th style="width: 11%">入库<i class="w_table_split"></i></th>
			<th style="width: 11%">机动位<i class="w_table_split"></i></th>
			<th style="width: 11%">已售<i class="w_table_split"></i></th>
			<th style="width: 11%">预留<i class="w_table_split"></i></th>
			<th style="width: 11%">清预留<i class="w_table_split"></i></th>
			<th style="width: 11%">取消<i class="w_table_split"></i></th>
			<th style="width: 11%">剩余<i class="w_table_split"></i></th>
		</tr>
    </thead>
       <tbody>
 			<c:forEach items="${list}" var="orders" varStatus="v">
		 <tr>
		 <c:set var="surplus" value="${surplus+orders.STOCK-orders.STOCKDISABLE-orders.ORDERSOLD-orders.ORDERRESERVE+orders.ORDERCLEAN+orders.ORDERCANCEL+0}"/>
		 		<td>${v.count}</td>
				<td><a href="javascript:void(0)"   onclick="detailsStocklog(this,'${orders.id }','${orders.adjustTime}')" class="def">${orders.adjustTime}</a></td>
				<td>${orders.STOCK}</td>
				<td>${orders.STOCKDISABLE}</td>
				<td>${orders.ORDERSOLD}</td>
				<td>${orders.ORDERRESERVE}</td>
				<td>${orders.ORDERCLEAN}</td>
				<td>${orders.ORDERCANCEL}</td>
				<td>${surplus} </td>
				</tr> 
		</c:forEach>
      </tbody>
</table>
<script type="text/javascript">
function detailsStocklog(obj,resId,adjustTime){
  	layerInd = layer.open({
		type : 2,
		title : '资源销售日明细',
		shadeClose : true,
		shade : 0.5,
		area: ['600px', '400px'],
		content: 'detailsStocklog.do?resId='+resId+ "&adjustTime=" + adjustTime
	}); 
}
</script>
</body>
</html>
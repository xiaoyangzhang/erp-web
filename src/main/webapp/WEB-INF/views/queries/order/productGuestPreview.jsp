<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>打印页</title>
<%@ include file="../../../include/top.jsp"%>
<style media="print" type="text/css">
.NoPrint {
	display: none;
}
body {font-size:10pt !important;}
div{ font-size:10pt !important; } 
</style>

<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
	
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Excel" onclick="exportExcel6()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th >序号<i class="w_table_split"></i></th>
			<th >线路<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			
			</tr>
			<tbody>
			
				<c:forEach items="${productGuest}" var="v" varStatus="vs">
		
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">${v.productBrandName }-${v.productName }</td>
	           <td>${v.guestCnt }</td>
	           <td>${v.orderCount }</td>
			</tr>
			<c:set var="sum_personCount" value="${sum_personCount+v.guestCnt}" />
			 <c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount}" />
					
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			
			
			<td colspan="2" >合计：</td>
			 <td >${sum_personCount}</td>
			<td >${sum_orderCount}</td> 
		</tr>
	</tbody>
		</table>
		<table style="width: 100%;">
			<tr>
				<td>打印人：${printName} 打印时间：<fmt:formatDate value="${now}"
						type="date" pattern="yyyy-MM-dd" /></td>
			</tr>
		</table>
	</div>

</body>
</html>
<script type="text/javascript">
	function opPrint() {
		window.print();
	}
	function exportExcel6(){
		//alert(window.location.search);
		location.href="exportExcel6.htm?"+(window.location.search.length>0?location.search.substring(1):"");
	}
</script>
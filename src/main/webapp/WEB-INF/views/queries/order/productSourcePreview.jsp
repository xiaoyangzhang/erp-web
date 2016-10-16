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
			<input type="button" value="导出Excel" onclick="exportExcel7()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th style="width:10%">序号<i class="w_table_split"></i></th>
			<th >客源地<i class="w_table_split"></i></th>
			<th style="width:15%">成人人数<i class="w_table_split"></i></th>
			<th style="width:15%">儿童人数<i class="w_table_split"></i></th>
			
			</tr>
			<tbody>
			
				<c:forEach items="${guestSource}" var="v" varStatus="vs">
		
			<tr style="text-align:center">
				<td>${vs.count}</td>
				<td>${v.provinceName}</td>
				<td>${v.adultCnt }</td>
				<td>${v.childCnt }</td>
			</tr>
			<c:set var="sum_personCount" value="${sum_personCount+v.guestCnt}" />
			<c:set var="sum_adultCount" value="${sum_adultCount+v.adultCnt}" />
			<c:set var="sum_childCount" value="${sum_childCount+v.childCnt}" />
					
		</c:forEach>
			</tbody>
			<tfoot>
		<tr class="footer1" style="text-align:center">
			
			<td></td>
			<td><strong>合计：</strong></td>
			<td >${sum_adultCount }</td>
			 <td >${sum_childCount }</td>
		</tr>
	</<tfoot>>
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
	function exportExcel7(){
		//alert(window.location.search);
		location.href="exportExcel7.htm?"+(window.location.search.length>0?location.search.substring(1):"");
	}
</script>
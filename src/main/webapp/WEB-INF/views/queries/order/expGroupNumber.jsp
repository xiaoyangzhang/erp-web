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
			<input id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
			<th >序号<i class="w_table_split"></i></th>
			<th >客户名称<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >订单数<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${allGroupOrder}" var="v" varStatus="vs">
		
			<tr>
				<td style="text-align: center;">${vs.count}</td>
				<td style="text-align: center;">${v.supplierName}</td>
	           <td  style="text-align: center;">${v.numAdult}大${v.numChild }小</td>
	           <td style="text-align: center;">${v.supplierCount }</td>
			</tr>
			<c:set var="sum_adultCount" value="${sum_adultCount+v.numAdult}" />
			<c:set var="sum_childCount" value="${sum_childCount+v.numChild}" />
			 <c:set var="sum_supplierCount" value="${sum_supplierCount+v.supplierCount}" />
					
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			
			
			<td colspan="2" style="text-align: center;">合计：</td>
			 <td style="text-align: center;">${sum_adultCount}大${sum_childCount }小</td>
			<td style="text-align: center;">${sum_supplierCount}</td> 
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
</script>
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
<%@ include file="../../include/top.jsp"%>
<style media="print" type="text/css">
.NoPrint {
	display: none;
}
body {font-size:10pt !important;}
div{ font-size:10pt !important; } 
</style>

<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Excel" onclick="exportExcel4()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>商家名称<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>数量<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>
					${v.groupCode}
                  	
				</td>
				<td style="text-align: left">【${v.productBrandName}】${v.productName }</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td>${v.cashType}</td>
				<td>
					
				<fmt:formatDate value="${v.item_date}"
														pattern="yyyy-MM-dd" />
														
														</td>
				<td>
					
						${v.type1_name}
						
				</td>
				<td  >
					<fmt:formatNumber value="${v.item_price}" pattern="#.##" type="currency"/>
						
				</td>
				<td >
						<fmt:formatNumber value="${v.item_num}" pattern="#.##" type="number"/>
						
				</td>
				<td><fmt:formatNumber value="${v.total}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td>
				<td >${v.remark }</td>
			</tr>
			<c:set var="sum_count" value="${sum_count+v.item_num}" />
			<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
			<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
			<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			<td></td>
			<td colspan="7" style="text-align: left">合计：</td>
			<td ><fmt:formatNumber value="${sum_count}" pattern="#.##" type="number"/></td>
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalCashCount}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalBalanceCount}" pattern="#.##" type="currency"/></td>
			<td></td>
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
	function exportExcel4(){
		//alert(window.location.search);
		location.href="exportExcel4.htm?"+(window.location.search.length>0?location.search.substring(1):"");
	}
</script>
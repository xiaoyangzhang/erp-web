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
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Excel" onclick="exportExcel5()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="15%" />
	<col width="5%" />
	<col width="10%" />
	<col width="5%" />
	<col width="3%" />
	<col width="5%" />
	<col width="8%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
			<tr>
				<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>团计调<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>车队<i class="w_table_split"></i></th>
			<th>车型<i class="w_table_split"></i></th>
			<th>座位<i class="w_table_split"></i></th>
			<th>司机<i class="w_table_split"></i></th>
			<th>车牌<i class="w_table_split"></i></th>
			<th>用车日期<i class="w_table_split"></i></th>
			<th>结算方式<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.groupCode}</td>
				<td>${item.operatorName}</td>
				<td  style="text-align: left;">【${item.productBrandName}】${item.productName}</td>
				<td>${item.totalAdult}大${item.totalChild}小</td>
				<td style="text-align: left">${item.supplierName}</td>
				<td>${item.type1Name}</td>
				<td>${item.type2Name}</td>
				<td>${item.driverName}</td>
				<td>${item.carLisence}</td>
				<td>${item.itemDate} ~ ${item.itemDateTo}</td>
				<td>${item.cashType }</td>
				<td ><fmt:formatNumber value="${item.total }" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.total-item.totalCash}" pattern="#.##" type="currency"/></td>
				<td>${item.remark}</td>
				<%-- <td><a href="javascript:void(0);" onclick="showRecord(${item.id})" class="def">明细</a> --%>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.totalCash }" />
			<c:set var="sum_balance" value="${sum_balance+item.total-item.totalCash}" />
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			
			
			
			<td colspan="12">合计:</td>
			<td ><fmt:formatNumber value="${sum_total }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_cash }" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_balance }" pattern="#.##" type="currency"/></td>
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
	function exportExcel5(){
		//alert(window.location.search);
		location.href="exportExcel5.htm?"+(window.location.search.length>0?location.search.substring(1):"");
	}
</script>
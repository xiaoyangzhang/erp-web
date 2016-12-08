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
<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Excel" onclick="exportExcel()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
	<col width="3%" />
	<col width="7%" />
	<col width="7%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />

	<col width="8%" />
	<col width="15%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />

	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>地接社<i class="w_table_split"></i></th>
			<th>客人<i class="w_table_split"></i></th>
			<th>团类型<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>价格明细<i class="w_table_split"></i></th>
			<th>应付<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left">
				${item.group_code}
				</td>
				<td>${item.date_arrival}</td>
				<td style="text-align: left">${item.supplier_name}</td>
				<td>${item.receive_mode}</td>
				<td>
					<c:if test="${item.group_mode <1 }">散客</c:if>
					<c:if test="${item.group_mode > 0}">团队</c:if>
				</td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td style="text-align: left">【${item.product_brand_name}】${item.product_name }</td>
				<td>${fn:replace(item.detailInfo,';','</br>') }</td>
				<td ><fmt:formatNumber value="${item.total }" pattern="#.##"/></td>
				<td ><fmt:formatNumber value="${item.totalCash}" pattern="#.##"/></td>
				<td ><fmt:formatNumber value="${item.total-item.totalCash}" pattern="#.##"/></td>
				<td>${item.operator_name}</td>
			</tr>
			<c:set var="sum_total" value="${sum_total+item.total }" />
			<c:set var="sum_cash" value="${sum_cash+item.totalCash }" />
			<c:set var="sum_balance" value="${sum_balance+item.total-item.totalCash }" />
			<c:set var="sum_adult" value="${sum_adult+item.total_adult }" />
			<c:set var="sum_child" value="${sum_child+item.total_child }" />
			<c:set var="sum_guide" value="${sum_guide+item.total_guide}" />
		</c:forEach>
		<tr>
			
			<td colspan="5" >合计:</td>
			<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
			<td></td>
			<td></td>
			<td ><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${sum_balance }" pattern="#.##"/></td>
			<td></td>
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
	function exportExcel(){
		location.href="deliveryExportExcel.do?"+(window.location.search.length>0?location.search.substring(1):"");
	}

</script>
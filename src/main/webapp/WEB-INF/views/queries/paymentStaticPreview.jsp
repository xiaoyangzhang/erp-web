<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript">
    function opPrint() {
        window.print();
    }
 </script>
			</head>
				<body>
					<div class="print NoPrint">
						<div class="print-btngroup">
						    <input id="btnPrint" type="button" value="打印" onclick="opPrint();"/>
						    <input type="button"  value="导出到excel" onclick="toExportWord()" />
						    <input id="btnClose" type="button" value="关闭" onclick="window.close();"/>
						</div>
					</div>
					<div align="center">
						<img alt="" src="${imgPath}"/><br/>
						<font size="5">应收款统计表</font>
						<table class="w_table" id="payTable">
			<colgroup>
					<col width="5%" />
					<col width="18%" />
					<col width="11%" />
					<col width=11%" />
					<col width=11%" />
					<col width=11%" />
					<col width=11%" />
					<col width=11%" />
					<col width=11%" />
				</colgroup>
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>商家名称<i class="w_table_split"></i></th>
						<th>期初欠收<i class="w_table_split"></i></th>
						<th>订单数<i class="w_table_split"></i></th>
						<th>人数<i class="w_table_split"></i></th>
						<th>团款<i class="w_table_split"></i></th>
						<th>已收<i class="w_table_split"></i></th>
						<th>未收<i class="w_table_split"></i></th>
						<th>总未收<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${orders}" var="v" varStatus="vs">
						<tr>
							<td>${vs.count}</td>
							<td style="text-align: left">${v.supplierName}</td>
							<td><fmt:formatNumber value="${v.preTotal}" type="currency" pattern="#.##"/></td>
							<td>${v.orderCount}</td>
							<td>${v.numAdult==null?0:v.numAdult}大${v.numChild==null?0:v.numChild}小${v.numGuide==null?0:v.numGuide}陪</td>
							<td><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${v.totalCash}" type="currency" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${v.totalBalance+v.preTotal-v.preTotal}" type="currency" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${v.totalBalance+v.preTotal}" type="currency" pattern="#.##"/></td>
						</tr>
						<c:set var="sum_orderCount" value="${sum_orderCount+v.orderCount }" />
						<c:set var="sum_adult" value="${sum_adult+v.numAdult}" />
						<c:set var="sum_child" value="${sum_child+v.numChild}" />
						<c:set var="sum_guide" value="${sum_guide+v.numGuide}" />
						<c:set var="sum_totalCount" value="${sum_totalCount+v.total }" />
						<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash }" />
						<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.totalBalance+v.preTotal }" />
						<c:set var="sum_preTotal" value="${sum_preTotal+v.preTotal }" />
					</c:forEach>
				</tbody>
				<tbody>
					<tr>
						<td></td>
						<td colspan="1" style="text-align: right">合计：</td>
						<td><fmt:formatNumber value="${sum_preTotal}" type="currency" pattern="#.##"/></td>
					    <td><fmt:formatNumber value="${sum_orderCount}" type="currency" pattern="#.##"/></td>
			         	<td>
			         		<fmt:formatNumber value="${sum_adult}" type="currency" pattern="#.##"/>大
			         		<fmt:formatNumber value="${sum_child}" type="currency" pattern="#.##"/>小
			         		<fmt:formatNumber value="${sum_guide}" type="currency" pattern="#.##"/>陪
			         	</td>
						<td><fmt:formatNumber value="${sum_totalCount}" type="currency" pattern="#.##"/></td>
						<td><fmt:formatNumber value="${sum_totalCashCount}" type="currency" pattern="#.##"/></td>
						<td><fmt:formatNumber value="${sum_totalBalanceCount-sum_preTotal}" type="currency" pattern="#.##"/></td>
						<td><fmt:formatNumber value="${sum_totalBalanceCount}" type="currency" pattern="#.##"/></td>
					</tr>
				</tbody>
			</table>
			<table style="width: 100%;">
				<tr>
					<td class="rich_text">打印人：${printName}&nbsp;&nbsp;打印时间：${printTime}</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		$(function() {
			$('.rich_text').each(function(){
		        $(this).html($(this).text().replace(/,/g,'<br/>'));
		        $(this).html($(this).text().replace(/\n/g,'<br/>'));
		    });
		});
		
		function toExportWord(){
			window.location = "paymentStaticExport.do?startTime=${parameter.startTime}&endTime=${parameter.endTime}"+
			"&supplierName=${parameter.supplierName}"+
			"&paymentState=${parameter.paymentState}"+
			"&productName=${parameter.productName}"+
			"&saleOperatorIds=${parameter.saleOperatorIds}"+
			"&groupMode=${parameter.groupMode}"+
			"&orgIds=${parameter.orgIds}"+
			"&type=${parameter.type}";
		}
	</script>
</html>


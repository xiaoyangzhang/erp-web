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
			    <input type="button"  value="导出到Word" onclick="toExportWord()" />
			    <input id="btnClose" type="button" value="关闭" onclick="window.close();"/>
			</div>
		</div>
		<div align="center">
			<img alt="" src="${imgPath}"/><br/>
			<font size="5">应收款明细统计表</font>
			<table style="width: 100%;" border="1">
				<thead>
					<tr>
						<th style="width: 3%;">序号<i class="w_table_split"></i></th>
						<th style="width: 5%">团号<i class="w_table_split"></i></th>
						<th style="width: 5%">日期<i class="w_table_split"></i></th>
						<th style="width: 18%">产品行程<i class="w_table_split"></i></th>
						<th style="width: 14%">商家名称<i class="w_table_split"></i></th>
						<th style="width: 13%">接站牌<i class="w_table_split"></i></th>
						<th style="width: 5%">客源地<i class="w_table_split"></i></th>
						<th style="width: 5%">销售<i class="w_table_split"></i></th>
						<th style="width: 6%">计调<i class="w_table_split"></i></th>
						<th style="width: 4%">人数<i class="w_table_split"></i></th>
						<th style="width: 10%">账目明细<i class="w_table_split"></i></th>
						<th style="width: 4%;text-align: center"">团款<i class="w_table_split"></i></th>
						<th style="width: 4%;text-align: center"">已收<i class="w_table_split"></i></th>
						<th style="width: 4%;text-align: center"">未收<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${orders}" var="v" varStatus="vs">
						<tr>
							<td style="text-align: center;">${vs.count}</td>
							<td style="text-align: left">${v.groupCode}</td>
							<td style="text-align: left">${v.departureDate}</td>
							<td style="text-align: left">【${v.productBrandName}】${v.productName}</td>
							<td style="text-align: left">${v.supplierName}
								<c:if test="${v.supplierCode!=null }">
									<br/>${v.supplierCode}
								</c:if>
								<c:if test="${v.contactName!=null }">
									<br/>${v.contactName}
								</c:if>
							</td>
							<td>${v.receiveMode}</td>
							<td>${v.provinceName}${v.cityName}</td>
							<td style="text-align: center;">${v.saleOperatorName}</td>
							<td style="text-align: center;">${v.operatorName}</td>
							<td style="text-align: center;">
								${v.numAdult}+${v.numChild}+${v.numGuide}
							</td>
							<td class="rich_text">${v.prices}</td>
							<td style="text-align: center;"><fmt:formatNumber value="${v.total}" type="currency" pattern="#.##"/></td>
							<td style="text-align: center;"><fmt:formatNumber value="${v.totalCash}" type="currency" pattern="#.##"/></td>
							<td style="text-align: center;"><fmt:formatNumber value="${v.total-v.totalCash}" type="currency" pattern="#.##"/></td>
						</tr>
						<c:set var="sum_personCount" value="${sum_personCount+v.numAdult+v.numChild+v.numGuide}" />
						<c:set var="sum_adult" value="${sum_adult+v.numAdult}" />
						<c:set var="sum_child" value="${sum_child+v.numChild}" />
						<c:set var="sum_guide" value="${sum_guide+v.numGuide}" />
						<c:set var="sum_totalCount" value="${sum_totalCount+v.total}" />
						<c:set var="sum_totalCashCount" value="${sum_totalCashCount+v.totalCash}" />
						<c:set var="sum_totalBalanceCount" value="${sum_totalBalanceCount+v.total-v.totalCash}" />
					</c:forEach>
				</tbody>
				<tbody>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="text-align: right;">合计：</td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_adult}" type="currency" pattern="#.##"/>+<fmt:formatNumber value="${sum_child}" type="currency" pattern="#.##"/>+<fmt:formatNumber value="${sum_guide}" type="currency" pattern="#.##"/></td>
						<td></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalCount}" type="currency" pattern="#.##"/></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalCashCount}" type="currency" pattern="#.##"/></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalBalanceCount}" type="currency" pattern="#.##"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		$(function() {
			$('.rich_text').each(function(){
		        $(this).html($(this).text().replace(/,/g,'<br/>'));
		    });
		});
		function toExportWord(){
			window.location = "getOrders.do?startTime=${parameter.startTime}&endTime=${parameter.endTime}"+
			"&supplierName=${parameter.supplierName}"+
			"&supplierId=${parameter.supplierId}"+
			"&provinceId=${parameter.provinceId}"+
			"&cityId=${parameter.cityId}"+
			"&groupCode=${parameter.groupCode}"+
			"&paymentState=${parameter.paymentState}"+
			"&productName=${parameter.productName}"+
			"&saleOperatorIds=${parameter.saleOperatorIds}"+
			"&groupMode=${parameter.groupMode}"+
			"&type=${parameter.type}";
		}
	</script>
</html>


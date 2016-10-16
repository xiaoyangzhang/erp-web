<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>应收款对账明细</title>
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
						<td style="text-align: right;" colspan="9"> 合计：</td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_adult}" type="currency" pattern="#.##"/>+<fmt:formatNumber value="${sum_child}" type="currency" pattern="#.##"/>+<fmt:formatNumber value="${sum_guide}" type="currency" pattern="#.##"/></td>
						<td></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalCount}" type="currency" pattern="#.##"/></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalCashCount}" type="currency" pattern="#.##"/></td>
						<td style="text-align: center;"><fmt:formatNumber value="${sum_totalBalanceCount}" type="currency" pattern="#.##"/></td>
					</tr>
				</tbody>
			</table>
			<font size="5">收款明细表</font>
			<table style="width: 100%;" border="1">
				<thead>
					<tr>
						<th style="width: 5%;">序号<i class="w_table_split"></i></th>
						<th style="width: 25%">账号<i class="w_table_split"></i></th>
						<th style="width: 10">支付方式<i class="w_table_split"></i></th>
						<th style="width: 10%">收款金额<i class="w_table_split"></i></th>
						<th style="width: 30%">备注<i class="w_table_split"></i></th>
						<th style="width: 10%">收款时间<i class="w_table_split"></i></th>
						<th style="width: 10%">录入操作员<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${payDetailList}" var="v" varStatus="vs">
						<tr>
							<td style="text-align: center;">${vs.count}</td>
							<td style="text-align: left">${v.supplierName}</td>
							<td style="text-align: center">${v.payType}</td>
							<td style="text-align: center"><fmt:formatNumber value="${v.cash}" pattern="#.##" type="number"/></td>
							<td style="text-align: left">${v.remark}</td>
							<td style="text-align: center"><fmt:formatDate value="${v.payDate}" pattern="yyyy-MM-dd"/></td>
							<td style="text-align: center">${v.userName}</td>
						</tr>
						<c:set var="sum_cash" value="${sum_cash+v.cash}" />
					</c:forEach>
				</tbody>
				<tr>
							<td style="text-align: center;"></td>
							<td style="text-align: left"></td>
							<td style="text-align: center">合计：</td>
							<td style="text-align: center"><fmt:formatNumber value="${sum_cash}" pattern="#.##" type="number"/></td>
							<td style="text-align: left"></td>
							<td style="text-align: center"></td>
							<td style="text-align: center"></td>
						</tr>
			</table>
			</br>
			<table style="width: 100%;" border="1">
				<thead>
					<tr>
						<td rowspan="2" align="center">期初余额<i class="w_table_split"></i></td>
						<td colspan="2" align="center">本期发生<i class="w_table_split"></i></td>
						<td rowspan="2" align="center">期末余额<i class="w_table_split"></i></td>
					</tr>
					<tr>
						<td align="center">应收<i class="w_table_split"></i></td>
						<td align="center">已收<i class="w_table_split"></i></td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="text-align: center;"><fmt:formatNumber value="${orderPre.total-orderPre.totalCash}" pattern="#.##" type="number"/></td>
						<td style="text-align: center"><fmt:formatNumber value="${orderMiddle.total}" pattern="#.##" type="number"/></td>
						<td style="text-align: center"><fmt:formatNumber value="${orderMiddle.totalCash}" pattern="#.##" type="number"/></td>
						<td style="text-align: center"><fmt:formatNumber value="${orderPre.total-orderPre.totalCash+orderMiddle.total-orderMiddle.totalCash}" pattern="#.##" type="number"/></td>
					</tr>
				</tbody>
			</table>
			</br>
			<table style="width: 100%;">
				<tr>
					<td class="rich_text">${sb}</td>
				</tr>
				<tr>
					<td class="rich_text" style="width:50%">${sb1}</td>
					<td class="rich_text">${sb2}</td>
				</tr>
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
			window.location = "getPaymentData.do?startTime=${parameter.startTime}&endTime=${parameter.endTime}"+
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


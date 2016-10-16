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
	
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Excel" onclick="exportExcel()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px" cellspacing="0" cellpadding="0"
			border="1">
			<tr>
			<th rowspan="2">产品编号<i class="w_table_split"></i></th>
			<th rowspan="2">产品名称<i class="w_table_split"></i></th>
			<th rowspan="2">区域<i class="w_table_split"></i></th>
			<th rowspan="2">组团社<i class="w_table_split"></i></th>
			<th rowspan="2">最后更新日期<i class="w_table_split"></i></th>
			
			<th rowspan="2">价格组<i class="w_table_split"></i></th>
			<th rowspan="2">日期段<i class="w_table_split"></i></th>
			<th colspan="4">价格<i class="w_table_split"></i></th>
			</tr>
			<tr>
			<th >成人结算价<i class="w_table_split"></i></th>
			<th >儿童结算价<i class="w_table_split"></i></th>
			
			
			<th >成人成本价<i class="w_table_split"></i></th>
			<th >儿童成本价<i class="w_table_split"></i></th>
				
			</tr>
			<tbody>
			
				<c:forEach items="${productPriceList}" var="info" varStatus="vs">
		
			<tr>
				<td rowspan="${info.productInfo.rowSpan }">${info.productInfo.code }</td>
				<td rowspan="${info.productInfo.rowSpan }">【${info.productInfo.brandName }】${info.productInfo.nameCity }</td>
				<c:if test="${!empty info.productGroupSupplierList  }">
				<c:forEach	items="${info.productGroupSupplierList }" var="supplier" varStatus="supplierVS">
					<c:if test="${supplierVS.index==0 }">
						<td rowspan="${supplier.rowSpan }" >${supplier.province }${supplier.city }${supplier.area }${supplier.town }</td>
						<td rowspan="${supplier.rowSpan }">${supplier.supplierName }</td>
						<td rowspan="${supplier.rowSpan }"><fmt:formatDate value="${supplier.updateTime }" pattern="yyyy-MM-dd" /></td>
						
							
								<c:forEach items="${supplier.productGroupList }" var="group" varStatus="groupVS">
								<c:if test="${groupVS.index==0 }">
									<td rowspan="${group.rowSpan }">${group.name }</td>
									
										<c:forEach items="${group.groupPrices }" var="price" varStatus="priceVS">
											<c:if test="${priceVS.index==0 }">
												<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
												<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</c:if>
											
											<c:if test="${priceVS.index>0 }">
											<tr>
											<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
											<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</tr>
											</c:if>
											<c:set var="sum_settlementAdult" value="${sum_settlementAdult+price.priceSettlementAdult}" />
											 <c:set var="sum_settlementChild" value="${sum_settlementChild+price.priceSettlementChild}" />
											<c:set var="sum_costAdult" value="${sum_costAdult+price.priceCostAdult}" />
											<c:set var="sum_costChild" value="${sum_costChild+price.priceCostChild }" />
										</c:forEach>
									
								</c:if>
								<c:if test="${groupVS.index>0 }">
								<tr>
									<td rowspan="${group.rowSpan }">${group.name }</td>
									
										<c:forEach items="${group.groupPrices }" var="price" varStatus="priceVS">

											<c:if test="${priceVS.index==0 }">
												<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
												<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</c:if>
											<c:if test="${priceVS.index>0 }">
											<tr>
											<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
											<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</tr>
											</c:if>
											<c:set var="sum_settlementAdult" value="${sum_settlementAdult+price.priceSettlementAdult}" />
											 <c:set var="sum_settlementChild" value="${sum_settlementChild+price.priceSettlementChild}" />
											<c:set var="sum_costAdult" value="${sum_costAdult+price.priceCostAdult}" />
											<c:set var="sum_costChild" value="${sum_costChild+price.priceCostChild }" />
										</c:forEach>
									
								</tr>
								</c:if>
								</c:forEach>
							
						
					</c:if>
				
				<c:if test="${supplierVS.index>0 }">
				<tr>
				<td rowspan="${supplier.rowSpan }" >${supplier.province }${supplier.city }${supplier.area }${supplier.town }</td>
						<td rowspan="${supplier.rowSpan }">${supplier.supplierName }</td>
						<td rowspan="${supplier.rowSpan }"><fmt:formatDate value="${supplier.updateTime }" pattern="yyyy-MM-dd" /></td>
						
						
						<c:forEach items="${supplier.productGroupList }" var="group" varStatus="groupVS">
								<c:if test="${groupVS.index==0 }">
									<td rowspan="${group.rowSpan }">${group.name }</td>
									
										<c:forEach items="${group.groupPrices }" var="price" varStatus="priceVS">
											<c:if test="${priceVS.index==0 }">
												<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
												<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</c:if>
											<c:if test="${priceVS.index>0 }">
											<tr>
											<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
											<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</tr>
											</c:if>
											<c:set var="sum_settlementAdult" value="${sum_settlementAdult+price.priceSettlementAdult}" />
											 <c:set var="sum_settlementChild" value="${sum_settlementChild+price.priceSettlementChild}" />
											<c:set var="sum_costAdult" value="${sum_costAdult+price.priceCostAdult}" />
											<c:set var="sum_costChild" value="${sum_costChild+price.priceCostChild }" />
										</c:forEach>
									
								</c:if>
								<c:if test="${groupVS.index>0 }">
								<tr>
									<td rowspan="${group.rowSpan }">${group.name }</td>
									
										<c:forEach items="${group.groupPrices }" var="price" varStatus="priceVS">

											<c:if test="${priceVS.index==0 }">
												<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
												<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
												<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</c:if>
											<c:if test="${priceVS.index>0 }">
											<tr>
											<td><fmt:formatDate value="${price.groupDate }" pattern="yyyy-MM-dd" />~
											<fmt:formatDate value="${price.groupDateTo }" pattern="yyyy-MM-dd" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceSettlementChild }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostAdult }" pattern="#.##" /></td>
											<td><fmt:formatNumber value="${price.priceCostChild }" pattern="#.##" /></td>
											</tr>
											</c:if>
											<c:set var="sum_settlementAdult" value="${sum_settlementAdult+price.priceSettlementAdult}" />
											 <c:set var="sum_settlementChild" value="${sum_settlementChild+price.priceSettlementChild}" />
											<c:set var="sum_costAdult" value="${sum_costAdult+price.priceCostAdult}" />
											<c:set var="sum_costChild" value="${sum_costChild+price.priceCostChild }" />
										</c:forEach>
									
								</tr>
								</c:if>
								</c:forEach>
							</tr>
				</c:if>
				</c:forEach>
				</c:if>
				<c:if test="${empty info.productGroupSupplierList }">
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</c:if>
			</tr>
			
			
					
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			<td colspan="7" align="center" >合计：</td>
			 <td ><fmt:formatNumber value="${sum_settlementAdult}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_settlementChild}" pattern="#.##" type="currency"/></td> 
			<td ><fmt:formatNumber value="${sum_costAdult}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_costChild}" pattern="#.##" type="currency"/></td>
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
		location.href="<%=ctx%>/productInfo/exportExcel.do?productIds=${productIds}";
	}
</script>
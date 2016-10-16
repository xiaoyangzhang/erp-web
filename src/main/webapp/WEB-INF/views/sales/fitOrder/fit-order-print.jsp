<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.idTabs.min.js"></script>
    <link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
   	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<!--startprint1-->
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input	id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center"><img src="${imgPath }" />
	<h6 style="font-size: 30px;" align="center">散客订单</h6> </div>
   
    <table cellspacing="0" cellpadding="0" <c:if test="${reqpm.isPrint eq true}"> class="w_table black_tab" </c:if> <c:if test="${reqpm.isPrint ne true}"> class="w_table" </c:if>>
	<%-- <col width="7%" />
	<col width="10%" />
	<col width="50%" />
	<col width="10%" />
	<col width="10%" /> --%>
	<thead>
		<tr>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">出发日期<i class="w_table_split"></i></th>
			<th style="width: 15%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 15%">组团社<i class="w_table_split"></i></th>
			<th style="width: 5%">接站牌<i class="w_table_split"></i></th>
			<th style="width: 5%">客源地<i class="w_table_split"></i></th>
			<th style="width: 5%">联系人<i class="w_table_split"></i></th>
			<th style="width: 5%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="width: 5%">销售<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 5%">输单员<i class="w_table_split"></i></th>
			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
		
			<tr>
				<td style="font-weight: bold;">${v.count }</td>
				<td style="text-align: left;font-weight: bold;">${groupOrder.tourGroup.groupCode}</td>
				<td style="font-weight: bold;">${groupOrder.departureDate}</td>
				<td style="text-align: left;font-weight: bold;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
				<td style="text-align: left;font-weight: bold;">${groupOrder.supplierName}</td>
				<td style="font-weight: bold;">${groupOrder.receiveMode}</td>
				<td style="font-weight: bold;">${groupOrder.provinceName }${groupOrder.cityName }</td>
				<td style="font-weight: bold;">${groupOrder.contactName}</td>
				<td style="font-weight: bold;">${groupOrder.numAdult }大${groupOrder.numChild}小</td>
				<td style="font-weight: bold;"><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
				<td style="font-weight: bold;">${groupOrder.saleOperatorName}</td>
				<td style="font-weight: bold;" >${groupOrder.operatorName}</td>
				<td style="font-weight: bold;">${groupOrder.creatorName}</td>
		</tr>
		<c:set var="pageTotalAdult" value="${pageTotalAdult+groupOrder.numAdult }"/>
		<c:set var="pageTotalChild" value="${pageTotalChild+groupOrder.numChild }"/>
		<c:set var="pageTotal" value="${pageTotal+groupOrder.total }"/>
		</c:forEach>
		
		<tr>
			<td colspan="8" style="font-weight: bold;">合计:</td>
			<td style="font-weight: bold;">${pageTotalAdult}大${pageTotalChild}小</td>
			<td style="font-weight: bold;"><fmt:formatNumber value="${pageTotal}" type="currency" pattern="#.##" /></td>
			<td style="font-weight: bold;"></td>
			<td style="font-weight: bold;"></td>
			<td style="font-weight: bold;"></td>
			
		</tr>
	</tbody>
</table>
<table style="width: 100%;">
			<tr>
				<td>打印人：${printName}&nbsp;&nbsp; 打印时间：${printTime}
						</td>
			</tr>
		</table>
<!--endprint1-->
<script type="text/javascript">
/* (function(){
	var oper=1;
	bdhtml=window.document.body.innerHTML;//获取当前页的html代码
	sprnstr="<!--startprint"+oper+"-->";//设置打印开始区域
	eprnstr="<!--endprint"+oper+"-->";//设置打印结束区域
	prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
	
	prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
	window.document.body.innerHTML=prnhtml;
	window.print(); 
})(); */
function opPrint() {
	window.print();
}
</script>
</body>
</html>

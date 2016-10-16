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

<link  type="text/css" href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
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
		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th >序号<i class="w_table_split"></i></th>
			<th >团号<i class="w_table_split"></i></th>
			<th >人数<i class="w_table_split"></i></th>
			<th >计调<i class="w_table_split"></i></th>
			<th >导游<i class="w_table_split"></i></th>
			
			<th >商家<i class="w_table_split"></i></th>
			<th >日期<i class="w_table_split"></i></th>
			<th >方式<i class="w_table_split"></i></th>
			<th >项目<i class="w_table_split"></i></th>
			<th >备注<i class="w_table_split"></i></th>
			
			
			<th >单价<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			<th >免去数<i class="w_table_split"></i></th>
			<th >金额<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
		
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">
	            ${v.groupCode}</td>
      		<td>${v.totalAdult }大${v.totalChild }小${v.totalGuide }陪</td>
				<td>${v.operatorName}</td>
				<td>
					 <c:if test="${v.bookingGuideInfo!=null }">
				                  ${fn:replace(v.bookingGuideInfo,',','</br>') }
				                  	 
				                  	</c:if>
				</td>
				<td style="text-align: left">${v.supplierName}</td>
				<td ><fmt:formatDate value="${v.itemDate }"
						pattern="yyyy-MM-dd" /></td>
				<td>${v.cashType}</td>
				<td>${v.type1Name }</td>
				<td>${v.itemBrief }</td>
				<td>	<fmt:formatNumber value="${v.itemPrice }" pattern="#.##" type="currency"/></td>
				<td>	<fmt:formatNumber value="${v.itemNum }" pattern="#.#" type="number"/></td>
					
				<td>	<fmt:formatNumber value="${v.itemNumMinus }" pattern="#.#" type="number"/></td>
				<td ><fmt:formatNumber value="${v.itemTotal}" pattern="#.##" type="currency"/></td>
				<%-- <td > <fmt:formatNumber value="${v.totalCash}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${v.total-v.totalCash}" pattern="#.##" type="currency"/></td> --%>
			</tr>
			<c:set var="sum_totalCount" value="${sum_totalCount+v.itemTotal}" />
			 <c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" />
			<c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum }" />
					
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			
			
			<td colspan="11" >合计：</td>
			 <td ><fmt:formatNumber value="${sum_totalNum}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${sum_totalNumMinus}" pattern="#.##" type="currency"/></td> 
			<td ><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
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
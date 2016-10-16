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
<%@ include file="../../../../include/top.jsp"%>
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
		<h6 style="font-size: 30px;font-weight: bold;" align="center">订房通知单</h6>
		<br/><br/>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tbody>
				<tr>
					<th align="center">团号</td>
					<td style="font-weight: bold;" align="center">${groupInfo.groupCode }</td>
					<th align="center">人数</td>
					<td style="font-weight: bold;" align="center">${groupInfo.totalAdult }大${groupInfo.totalChild }小</td>
				</tr>
				<tr>
					<th align="center">产品</td>
					<td style="font-weight: bold;" align="center">【${groupInfo.productBrandName }】${groupInfo.productName }</td>
					<th  align="center">计调</td>
					<td style="font-weight: bold;" align="center">${groupInfo.operatorName }</td>
				</tr>
			</tbody>	
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th >序号</th>
			<th >酒店</th>
			<th >备注</th>
			
			<th >日期</th>
			<th >类别</th>
			
			<th >数量</th>
			<th >单价</th>
			<th >免去数</th>
			<th >金额</th>
			</tr>
			<tbody>
			
				<c:forEach items="${bookingList}" var="v" varStatus="vs">
		
			<tr >
				<td style="font-weight: bold;" align="center" rowspan="${fn:length(v.detailList)}" >${vs.count}</td>
				<td style="text-align: left;font-weight: bold;" rowspan="${fn:length(v.detailList)}">${v.supplierName}</td>
				<td style="font-weight: bold;"  rowspan="${fn:length(v.detailList)}">${v.remark}</td>
				
				
				<c:forEach items="${v.detailList }" var="detail" varStatus="status">
			<c:if test="${status.index==0 }">
				<td style="font-weight: bold;" align="center" ><fmt:formatDate value="${detail.itemDate }" pattern="yyyy-MM-dd" /></td>
				<td style="font-weight: bold;" align="center">${detail.type1Name }</td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemNum }" pattern="#.#" type="number"/></td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemPrice }" pattern="#.##" type="currency"/></td>
					
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemNumMinus }" pattern="#.#" type="number"/></td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemTotal}" pattern="#.##" type="currency"/></td>
		
				</c:if>
				</c:forEach>
			</tr>
				
					<c:forEach items="${v.detailList }" var="detail" varStatus="status">
			<c:if test="${status.index>0 }">
					<tr>
				<td style="font-weight: bold;" align="center" ><fmt:formatDate value="${detail.itemDate }" pattern="yyyy-MM-dd" /></td>
				<td style="font-weight: bold;" align="center">${detail.type1Name }</td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemNum }" pattern="#.#" type="number"/></td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemPrice }" pattern="#.##" type="currency"/></td>
					
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemNumMinus }" pattern="#.#" type="number"/></td>
				<td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${detail.itemTotal}" pattern="#.##" type="currency"/></td>
		</tr></c:if>
				
			 <c:set var="sum_totalCount" value="${sum_totalCount+detail.itemTotal}" />
			 <c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+detail.itemNumMinus}" />
			<c:set var="sum_totalNum" value="${sum_totalNum+detail.itemNum }" />
				</c:forEach>
				
					
		</c:forEach>
			</tbody>
			<tbody>
		<tr>
			<td style="font-weight: bold;" colspan="5" align="center">合计：</td>
			 <td style="font-weight: bold;" align="center" ><fmt:formatNumber value="${sum_totalNum}" pattern="#.#" type="currency"/></td>
			 <td></td>
			<td style="font-weight: bold;" align="center"><fmt:formatNumber value="${sum_totalNumMinus}" pattern="#.#" type="currency"/></td> 
			<td style="font-weight: bold;" align="center"><fmt:formatNumber value="${sum_totalCount}" pattern="#.##" type="currency"/></td>
		</tr>
	</tbody>
		</table>
		<table style="width: 100%;">
			<tr>
				<td style="font-weight: bold;">打印时间：<fmt:formatDate value="${printTime}"
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
		location.href="<%=ctx%>/booking/exportExcel.do?groupId=${groupId}";
	}
</script>
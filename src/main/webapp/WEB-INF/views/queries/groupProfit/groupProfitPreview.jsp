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
			<col width="5%" />
	<col width="10%" />
	<col width="25%" />
	<col width="9%" />
	<col width="5%" />
	<col width="10%" />
	<col width="8%" />
	<col width="8%" />
	<col width="10%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
			<th>审核人<i class="w_table_split"></i></th>
			<th>收入<i class="w_table_split"></i></th>
			<th>支出<i class="w_table_split"></i></th>
			<th>利润<i class="w_table_split"></i></th>
		</tr>
	</thead>
			<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr 
				<c:if test="${item.group_state eq 3 }">
					style="color:blue;" 
				</c:if>
				<c:if test="${item.group_state eq 4 }">
					style="color:#ee33ee;" 
				</c:if>
			>
				<td class="serialnum">
					<div class="serialnum_btn" groupId="${item.id}"></div> ${status.index+1}
				</td>
				<td style="text-align: left;">
	              ${item.group_code}
             	</td>
				<td style="text-align: left;">【${item.product_brand_name}】${item.product_name} </td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td>${item.operator_name}</td>
				<c:forEach items="${guideMap}" var="m">
					<c:if test="${m.key==item.id }">
						<td>${m.value }</td>
					</c:if>
				</c:forEach>
				<td style="text-align: left;"><fmt:formatDate value="${item.date_start}" pattern="MM-dd" />/
					<fmt:formatDate value="${item.date_end}" pattern="MM-dd" />
				</td>
				<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
				<td>
					<c:if test="${item.group_state==0 }">未确认</c:if>
					<c:if test="${item.group_state==1 }">已确认</c:if>
					<c:if test="${item.group_state==1 and nowDate-item.date_start.time < 0}">(待出团)</c:if>
					<c:if test="${item.group_state==1 and  !empty item.date_end and nowDate-item.date_end.time > 0}">(已离开)</c:if>
					<c:if test="${item.group_state==1 and  !empty item.date_end and nowDate-item.date_start.time > 0 and nowDate-item.date_end.time < 0 }">(行程中)</c:if>
					<c:if test="${item.group_state==2}">废弃</c:if>
					<c:if test="${item.group_state==3}">已审核</c:if>
					<c:if test="${item.group_state==4}">封存</c:if>
				</td>
				<td>${item.audit_user }</td>
				<td>
					<c:if test="${not empty item.total_income}">
						<fmt:formatNumber value="${item.total_income }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.total_income}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.total_cost}">
						<fmt:formatNumber value="${item.total_cost }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.total_cost}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty item.total_profit}">
						<fmt:formatNumber value="${item.total_profit }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.total_profit}">0</c:if>
				</td>
				
			</tr>
			<c:set var="sum_total_income" value="${sum_total_income+item.total_income }" />
			<c:set var="sum_total_cost" value="${sum_total_cost+item.total_cost }" />
			<c:set var="sum_total_profit" value="${sum_total_profit+item.total_profit }" />
			
			<c:set var="sum_total_adult" value="${sum_total_adult+item.total_adult }" />
			<c:set var="sum_total_child" value="${sum_total_child+item.total_child }" />
			<c:set var="sum_total_guide" value="${sum_total_guide+item.total_guide }" />
		</c:forEach>
		<tr>
			<td colspan="3">合计:</td>
			<td>${sum_total_adult }大${sum_total_child }小${sum_total_guide }陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_total_income }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total_cost }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total_profit}" pattern="#.##"/></td>
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
		location.href="groupProfitExportExcel.htm?"+(window.location.search.length>0?location.search.substring(1):"");
	}
</script>
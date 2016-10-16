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
			<input type="button" value="导出word" onclick="exportWord(${bookingId})" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		<h6 style="font-size: 30px;font-weight: bold;" align="center">${otherMap.supplierType }通知单</h6>
		<br/><br/>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="0">
			<tbody >
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">收件方：${agencyMap.supplier_name }</td>
					<td style="font-weight: bold;">发件方：${agencyMap.company }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">收件人：${agencyMap.contact }</td>
					<td style="font-weight: bold;">发件人：${agencyMap.user_name }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">电&nbsp;话：${agencyMap.contact_tel }</td>
					<td style="font-weight: bold;">电&nbsp;话：${agencyMap.user_tel }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">传&nbsp;真：${agencyMap.contact_fax }</td>
					<td style="font-weight: bold;">传&nbsp;真：${agencyMap.user_fax }</td>
				</tr>
			</tbody>	
		</table>
		<hr color="black" ><hr color="black" ><br/><br/>
		<span style="text-align: left;display:block;font-weight: bold;">我公司旅行团一行： ${groupMap.totaladult}大${groupMap.totalcg}陪${groupMap.totalchild}小人， 团号： ${groupMap.groupcode}
			 ， 导游：${groupMap.guide_name} ${groupMap.guide_tel}，
			现将预订单呈上，请及时安排落实并回复，谢谢！</span>
					
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr height="28px">
				<th >序号<i class="w_table_split"></i></th>
			<th >日期<i class="w_table_split"></i></th>
			<th >类别<i class="w_table_split"></i></th>
			<th >数量<i class="w_table_split"></i></th>
			<th >单价<i class="w_table_split"></i></th>
			
			<th >免去数<i class="w_table_split"></i></th>
			<th >金额<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${supplierMapList}" var="supplier" varStatus="vs">
				
		
		
			<tr height="28px">
				<td style="font-weight: bold;" align="center">${supplier.seq}</td>
				<td style="font-weight: bold;" align="center">${supplier.day }</td>
      			<td style="font-weight: bold;" align="center">${supplier.type }</td>
				<td style="font-weight: bold;" align="center">${supplier.item_num }</td>
				<td style="font-weight: bold;" align="center">${supplier.unit_price }</td>
				<td style="font-weight: bold;" align="center">${supplier.num_minus }</td>
				<td style="font-weight: bold;" align="center" >${supplier.total_price}</td>
					</tr>
			<%-- <c:set var="sum_totalCount" value="${sum_totalCount+v.itemTotal}" />
			 <c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" />
			<c:set var="sum_totalNum" value="${sum_totalNum+v.itemNum }" />
			 --%>		
			 
		
		</c:forEach>
			</tbody>
			<%-- <tbody>
		<tr>
			
			
			<td colspan="11" >合计：</td>
			 <td ><fmt:formatNumber value="${}" pattern="#.##" type="currency"/></td>
			<td ><fmt:formatNumber value="${}" pattern="#.##" type="currency"/></td> 
			<td ><fmt:formatNumber value="${}" pattern="#.##" type="currency"/></td>
		</tr>
	</tbody> --%>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<tbody>
					<tr height="90px">
						<td  style="font-weight: bold;" width="199px" align="center">备注</td>
						<td  style="font-weight: bold;" >${remarkMap.remark }
						
						客人名单：${remarkMap.customers} </td>
						</tr>
						<tr height="90px">
						<td  style="font-weight: bold;" width="199px" rowspan="3"></td>
						<td  style="font-weight: bold;" >
							&nbsp;&nbsp;&nbsp;
							<table>	 
							 <td  style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;旅行社盖章：</td>
							<td  style="font-weight: bold;" width="500px">供应商盖章：</td>
						</table>&nbsp;&nbsp;&nbsp;<table>
							<td  style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签字：</td>
							<td  style="font-weight: bold;" width="700px">签字：</td>
						</table>&nbsp;&nbsp;&nbsp;<table>
							<td  style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>
							<td  style="font-weight: bold;" width="700px">日期：</td> 
						</table>		
							
						</td>
					</tr>
				</tbody>
			</table><br/><br/>
		<table style="width: 100%;">
			<tr>
				<td  style="font-weight: bold;">打印时间：${otherMap.print_time}
						</td>
			</tr>
		</table>
	</div>

</body>
</html>
<script type="text/javascript">
	function opPrint() {
		window.print();
	}
	function exportWord(bookingId){
		location.href="download.htm?bookingId="+bookingId ; //供应商确认订单
		
	}
</script>
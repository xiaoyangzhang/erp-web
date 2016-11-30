<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>操作单导出到Excel</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>

<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/saleOperator.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<div class="print NoPrint">
			<div class="print-btngroup"
			    <input type="button"  value="导出到Excel" onclick="toExportWord()" />
			</div>
		</div>
		<div align="center">
			<img alt="" src="${imgPath}"/><br/>
			<font size="5">操作单</font>
	<div class="p_container">
			<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
				border="1">
			<thead>
				<tr>
					<th>序号<i class="w_table_split"></i></th>
					<th>团号<i class="w_table_split"></i></th>
					<th>日期<i class="w_table_split"></i></th>
					<th>产品名称<i class="w_table_split"></i></th>
					<th>客户<i class="w_table_split"></i></th>
					<th>客人信息<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
					<th>销售<i class="w_table_split"></i></th>
					<th>客人名单<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<tbody>
		       	<c:forEach items="${page.getResult()}" var="operator" varStatus="vs">
		       		<tr>
		              <td width="2%">${vs.count}</td>
		              <td style="text-align: left;" width="4%"> ${operator.groupCode}  </td>
		               <td style="text-align: left;" width="4%"> ${operator.departureDate}  </td>
		              <td width="8%" style="text-align: left">【${operator.productBrandName}】${operator.productName}</td>
		              <td width="8%" style="text-align: left;">${operator.supplierName}</td>
		              <td width="8%" style="text-align: left;">${operator.receiveMode}</td>
		              <!-- 人数 -->
		              <td width="3%">${operator.numAdult}+${operator.numChild}+${operator.numGuide}</td>
		              <td width="3%" style="text-align: left;">${operator.saleOperatorName}</td>
		              
		              <td width="30%" class="rich_text1" height="100%">
		              	<table class="in_table" border="1">
		              		<c:forEach items="${operator.guests}" var="l">
		              			<tr>
		              				<td style="text-align: left" width="25%">
		              					${l.name}
		              				</td>
		              				<td style="text-align: left" width="40%">
		              					${l.certificateNum}
		              				</td>
		              				<td style="text-align: left;" width="35%">
		              					${l.mobile}
		              				</td>
		              			</tr>
		              		</c:forEach>
		              	</table>
		              </td>
		         </tr>
		       	</c:forEach>
			</tbody>
		</table>
		</div>
	</div>
</body>
<script type="text/javascript">
$(function(){
	$('.rich_text').each(function(){
        $(this).html($(this).html().replace(/,/g,'<br/>'));
    });
	$('.rich_text1').each(function(){
        $(this).html($(this).html().replace(/@/g,'<br/>'));
    });
	$(".hl").each(function(index){
    	var vv = $(this) ;
    	$("#hotelLevel option").each(function(){ //遍历全部option 
	    	var key = $(this).val();
	        var value = $(this).text(); //获取option的内容 
        	if(key==vv.text().trim()){
        		vv.text(value);
        	}
	    });
    });
}) ;
function toExportWord(){
	window.location = "saleOperatorExcel.htm?startTime=${startTime}"+
			"&endTime=${endTime}"+
			"&supplierName=${supplierName}"+
			"&groupCode=${groupCode}"+
			"&productName=${productName}"+
			"&saleOperatorIds=${saleOperatorIds}"+
			"&guestName=${guestName}"+
			"&mobile=${mobile}"+  
			"&select=${select}";
			
}
</script>
</html>

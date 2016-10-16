<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>销售计调单1</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript">
    function opPrint() {
        window.print();
    }
 </script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/saleOperator.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<div class="print NoPrint">
			<div class="print-btngroup">
			    <input id="btnPrint" type="button" value="打印" onclick="opPrint();"/>
			    <input type="button"  value="导出到Excel" onclick="toExportWord()" />
			    <input id="btnClose" type="button" value="关闭" onclick="window.close();"/>
			</div>
		</div>
		<div align="center">
			<img alt="" src="${imgPath}"/><br/>
			<font size="5">销售计调单</font>
	<div class="p_container">
		<div style="display: none">
	    				<div class="dd_left">星级:</div>
	    				<select id="hotelLevel" name="hotelLevel" class="select160" style="width: 160px;text-align: right">
                			<c:forEach items="${jdxjList}" var="v" varStatus="vs">
								<option value="${v.id}" style="height: 23px;text-align: right">${v.value}</option>
							</c:forEach>
               			</select>
	    			</div>
			<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
				border="1">
			<thead>
				<tr>
					<th>序号<i class="w_table_split"></i></th>
					<th>团号<i class="w_table_split"></i></th>
					<th>产品名称<i class="w_table_split"></i></th>
					<th>组团社<i class="w_table_split"></i></th>
					<th>联系人<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
					<th>客人<i class="w_table_split"></i></th>
					<th>星级<i class="w_table_split"></i></th>
					<th>房量<i class="w_table_split"></i></th>
					<th>接机<i class="w_table_split"></i></th>
					<th>送机<i class="w_table_split"></i></th>
					<th>省内交通<i class="w_table_split"></i></th>
					<th>销售<i class="w_table_split"></i></th>
					<th>计调<i class="w_table_split"></i></th>
					<th>备注<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<tbody>
		       	<c:forEach items="${page.getResult()}" var="gl" varStatus="vs">
		       		<tr>
		              <td width="2%">${vs.count}</td>
		              <td style="text-align: left;" width="4%">
			              	${gl.groupCode}
		              </td>
		              <td width="8%" style="text-align: left">【${gl.productBrandName}】${gl.productName}</td>
		              <td width="8%" style="text-align: left;">${gl.supplierName}</td>
		              <td width="3%">${gl.contactName}</td>
		              <td width="3%">${gl.numAdult}+${gl.numChild}+${gl.numGuide}</td>
		              <td width="30%" class="rich_text1" height="100%">
		              	<table class="in_table" border="1">
		              		<c:forEach items="${gl.guests}" var="l">
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
		              <td width="4%" class="hl">${gl.hotelLevels}</td>
		              <td width="4%" class="rich_text" style="text-align: left">${gl.hotelNums}</td>
		              <td width="8%" class="rich_text" style="text-align: left">${gl.upAir}</td>
		              <td width="8%" class="rich_text" style="text-align: left">${gl.offAir}</td>
		              <td width="8%" class="rich_text" style="text-align: left">${gl.trans}</td>
		              <td width="3%">${gl.saleOperatorName}</td>
		              <td width="3%">${gl.operatorName}</td>
		              <td width="4%" style="text-align: left">${gl.remark}</td>
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

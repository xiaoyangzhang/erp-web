<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
</style>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
</head>
<body class="bodys">
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出Word" onclick="toExportWord()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center" class="divs">
		<img src="${imgPath}" /><br/>
		<font size="5">散客购物明细表</font>
		<table style="width: 100%; border-collapse: collapse; margin: 0px" border="1">
			<tr>
				<td style="text-align: center;width:10%;height:22px">团号</td>
				<td style="width:40%">${groupCode }</td>
				<td style="text-align: center;width:10%">人数</td>
				<td style="width:40%">${totalNum}</td>
			</tr>
			<tr>
				<td style="text-align: center;height:22px">导游</td>
				<td>${guide}</td>
				<td style="text-align: center">产品名称</td>
				<td>${productName}</td>
			</tr>
			<tr>
				<td style="text-align: center;height:22px">总购</td>
				<td></td>
				<td style="text-align: center">人均</td>
				<td></td>
			</tr>
		</table>
		<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:5%">序号</th>
		  			<th style="width:15%">接送方式</th>
		  			<th style="width:5%">人数</th>
		  			<th style="width:5%">客源地</th>
		  			<th style="width:5%">总购</th>
		  			<th style="width:5%">人均</th>
		  			<th style="width:5%">银店</th>
		  			<th style="width:5%">外围（翡翠）</th>
		  			<th style="width:5%">七彩（玉）</th>
		  			<th style="width:5%">七彩（茶）</th>
		  			<th style="width:5%">七彩（黄龙玉）</th>
		  			<th style="width:5%">七彩（其他）</th>
		  			<th style="width:5%">其他</th>
		  		</tr>
	  			<c:forEach items="${gops}" var="l" varStatus="v">
		  			<tr>
			  			<td style="text-align: center">${v.count }</td>
			  			<td>${l.receiveMode}</td>
			  			<td>${l.personNum}</td>
			  			<td>${l.place}</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  			<td>&nbsp;</td>
			  		</tr>
	  			</c:forEach>
			</table>
	</body>
	<div style="margin-left: -42%">(一)评分：A优、B良、C中、D一般、E差，（二）投诉：填 有或无 （三）我社以客人在当地签署的意见单为准，产生与意见单相违背问题，本社一概不予授理。</div>
	<div style="margin-left: -90%">打印人：${printName}  打印时间：${printTime }</div>
	<script type="text/javascript">
		function toExportWord(){
			window.location = "download.htm?groupId=${groupId}&num=4";
		}
		function opPrint() {
			window.print();
		}
	</script>
</html>

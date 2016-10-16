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
			<input type="button" value="导出Word" onclick="toExportWord()" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		<h4>客人名单(团号：${tourGroup.groupCode })</h4>
		<table style="width: 80%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th>序号</th>
				<th>姓名</th>
				<th>身份证</th>
				<th>年龄</th>
				<th>籍贯</th>
				<th>手机号</th>
			</tr>
			<c:forEach items="${guestList }" var="guest" varStatus="i" >
				<tr>
					<td style="text-align: center">${i.count}</td>
					<td style="padding-left: 10px;text-align: center">${guest.name}</td>
					<td style="padding-left: 10px;">${guest.certificateNum }</td>
					<td style="padding-left: 10px;text-align: center">${guest.age}</td>
					<td style="padding-left: 10px;">${guest.nativePlace}</td>
					<td style="padding-left: 10px;text-align: center">${guest.mobile}</td>
				</tr>
			</c:forEach>
		</table>
		<table style="width: 80%;">
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
	function toExportWord() {
		window.location = "download.htm?groupId=${tourGroup.id}&num=2"
	}
</script>
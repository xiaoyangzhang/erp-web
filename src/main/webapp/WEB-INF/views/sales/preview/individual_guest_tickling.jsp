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
		<font size="5">游客意见反馈表</font>
		<table style="width: 100%; border-collapse: collapse; margin: 0px" border="1">
			<tr>
				<td style="text-align: center;width:10%;height:30px">团号</td>
				<td style="width:40%">${groupCode }</td>
				<td style="text-align: center;width:10%">人数</td>
				<td style="width:40%">${totalNum}</td>
			</tr>
			<tr>
				<td style="text-align: center;height:30px">导游</td>
				<td>${guide}</td>
				<td style="text-align: center">产品名称</td>
				<td>${productName}</td>
			</tr>
			<tr>
				<td style="text-align: center;height:30px">说明</td>
				<td colspan="3">尊敬的贵宾：欢迎您来参加我们的旅游团，我们将尽最大的努力使您旅途愉快，为进一步提高服务质量，请各位贵宾对我们的接待留下宝贵的意见和建议！</td>
			</tr>
		</table>
		<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:5%;height:30px">序号</th>
		  			<th style="width:15%">接站方式</th>
		  			<th style="width:5%">人数</th>
		  			<th style="width:5%">导游讲解水平</th>
		  			<th style="width:5%">导游服务态度</th>
		  			<th style="width:5%">住宿环境</th>
		  			<th style="width:5%">住宿质量</th>
		  			<th style="width:5%">用餐环境</th>
		  			<th style="width:5%">用餐质量</th>
		  			<th style="width:5%">车辆态度</th>
		  			<th style="width:5%">车辆车貌</th>
		  			<th style="width:5%">行程景点</th>
		  			<th style="width:5%">有无投诉</th>
		  			<th style="width:5%">客人签名</th>
		  			<th style="width:5%">客人电话</th>
		  			<th style="width:15%">意见及建议</th>
		  		</tr>
		  		<c:if test="${groupMode>0}">
		  			<c:forEach items="${list}" var="lt" varStatus="v">
		  				<tr>
				  			<td style="height:30px">&nbsp;</td>
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
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
				  			<td>&nbsp;</td>
				  		</tr>
		  			</c:forEach>
		  		</c:if>
		  		<c:if test="${groupMode<=0}">
		  			<c:forEach items="${gops}" var="gop" varStatus="v">
			  			<tr>
				  			<td style="text-align: center;height:30px">${v.count }</td>
				  			<td>${gop.receiveMode}</td>
				  			<td>${gop.personNum}</td>
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
				  			<td>&nbsp;</td>
				  		</tr>
		  			</c:forEach>
		  		</c:if>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
					<td style="width:5%;text-align: right">备注</td>
					<td style="width:95%;height: 60px;"></td>
				</tr>
			</table>
	</body>
	<div style="margin-left: -42%">(一)评分：A优、B良、C中、D一般、E差，（二）投诉：填 有或无 （三）我社以客人在当地签署的意见单为准，产生与意见单相违背问题，本社一概不予授理。</div>
	<div style="margin-left: -90%">打印人：${printName}  打印时间：${printTime }</div>
	<script type="text/javascript">
		function toExportWord(){
			window.location = "download.htm?groupId=${groupId}&num=3";
		}
		function opPrint() {
			window.print();
		}
	</script>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript">
    function opPrint() {
        window.print();
    }
	function toExportWord(){
		window.location = "toSKConfirmPreviewExport.htm?groupId=${groupId}&supplierId="+$("#supplier option:selected").val()+"&num=0" ;
	}
	$(function() {
		$('.rich_text').each(function(){
			$(this).html($(this).html().replace(/\n\n/g,'<br/>'));
	        $(this).html($(this).html().replace(/\n/g,'<br/>'));
	    });
	});
</script>
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
		    <input id="btnPrint" type="button" value="打印" onclick="opPrint();"/>
		    <input type="button"  value="导出到Word" onclick="toExportWord()" />
		    <input id="btnClose" type="button" value="关闭" onclick="window.close();"/>
		</div>
	</div>
<div align="center">
<img alt="" src="${imgPath}"/><br/>
<font size="5">出团通知</font>
</div>
<p>尊敬的______，您好！您参加了我社 旅游团，团号是：</p>
<table>
<tr><td class="rich_text">
航班如下：


温馨提示：


</td></tr>
</table>

<table>
	<tr><td colspan="6"><font size="8">【${tour.productName}】${tour.productBrandName }</font></td></tr>
	<tr>
		<th style="width:10%">日期</th>
		<th>行程</th>
		<th style="width:6%">早</th>
		<th style="width:6%">中</th>
		<th style="width:6%">晚</th>
		<th style="width:12%">住宿</th>
	</tr>
  	<c:forEach items="${groupRouteDayVOs}" var="rl">
	<tr>
		<td style="text-align: center"><fmt:formatDate value="${rl.groupRoute.groupDate}" pattern="MM-dd"/></td>
		<td class="rich_text">${rl.groupRoute.routeDesp }</td>
		<td style="text-align: center">${rl.groupRoute.breakfast }</td>
		<td style="text-align: center">${rl.groupRoute.lunch }</td>
		<td style="text-align: center">${rl.groupRoute.supper }</td>
		<td style="text-align: center">${rl.groupRoute.hotelName }</td>
	</tr>
  	</c:forEach>
</table>

<p align="center"><font size="8">行前注意事项</font></p>
<div>
注意事项
</div>


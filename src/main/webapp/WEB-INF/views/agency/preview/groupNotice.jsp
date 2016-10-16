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
		window.location = "toGroupNoticeExport.htm?groupId=${tourGroup.id}";
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
<div  style="width:800px; margin:0 auto;">
<div align="center">
<img alt="" src="${imgPath}"/><br/>
<font size="5"><b>出团通知</b></font>
</div>
<p>尊敬的______，您好！您参加了我社<fmt:formatDate value="${tourGroup.dateStart}" pattern="yyyy年MM月dd日"/>的旅游团，团号是：${tourGroup.groupCode }</p>
<table border="1" width="100%">
<tr><td class="rich_text">${comment.groupComment}</td></tr>
</table>
<p>&nbsp;</p>
<table border="1">
	<tr><td colspan="6" align="center"><font size="4"><b>【${tourGroup.productName}】${tourGroup.productBrandName }</b></font></td></tr>
	<tr>
		<th style="width:10%">日期</th>
		<th>行程</th>
		<th style="width:6%">早</th>
		<th style="width:6%">中</th>
		<th style="width:6%">晚</th>
		<th style="width:12%">住宿</th>
	</tr>
  	<c:forEach items="${routeList}" var="rl">
	<tr>
		<td style="text-align: center"><fmt:formatDate value="${rl.groupDate}" pattern="MM-dd"/></td>
		<td class="rich_text">${rl.routeDesp }</td>
		<td style="text-align: center">${rl.breakfast }</td>
		<td style="text-align: center">${rl.lunch }</td>
		<td style="text-align: center">${rl.supper }</td>
		<td style="text-align: center">${rl.hotelName }</td>
	</tr>
  	</c:forEach>
</table>

<p>&nbsp;</p>
<p align="center"><font size="4"><b>行前注意事项</b></font></p>
<p><b>特别说明：欢迎参加此次旅行。为了确保您在本次旅途中的人身安全，我们特别请您遵守下列事项。这是我们应尽的告知责任，也是为了保障您的自身权益。</b></p>
<div class="rich_text">
${comment.groupNotice}
</div>

</div>
</body>
</html>
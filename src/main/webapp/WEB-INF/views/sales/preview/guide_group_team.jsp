<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/top.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript">
    function opPrint() {
        window.print();
    }
    function toExportWord(){
		if('${num}'!=3){
			window.location = "../bookingGuide/download.htm?guideId=${id}&num=${num}" ;
		}else{
			window.location = "../bookingGuide/download.htm?groupId=${tourGroup.id}&num=${num}" ;
		}
	}
 </script>
</head>
<body>
		<div class="print NoPrint">
			<div class="print-btngroup">
			    <input id="btnPrint" type="button" value="打印1" onclick="opPrint();"/>
			    <input type="button"  value="导出到Word" onclick="toExportWord()" />
			    <input id="btnClose" type="button" value="关闭" onclick="window.close();"/>
			</div>
		</div>
		<div align="center">
			<img alt="" src="${imgPath}"/><br/>
			<font size="5">${groupOrder.productName}导游行程单</font>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			  <tr>
			    <td style="text-align: right;width:12%;height:40px">团号：</td>
			    <td style="text-align: left;width:46%">${tourGroup.groupCode}</td>
			    <td style="text-align: right;width:12%">开团时间</td>
			    <td style="text-align: left;width:30%"><fmt:formatDate value="${tourGroup.dateStart}" pattern="yyyy-MM-dd"/></td>
			  </tr>
			  <tr>
			    <td style="text-align: right;width:12%;height:40px">计调：</td>
			    <td style="text-align: left;width:46%">${tourGroup.operatorName}(电话：${operatorMobile })</td>
			    <td style="text-align: right;width:12%">人数：</td>
			    <td style="text-align: left;width:30%">${tourGroup.totalAdult}+${tourGroup.totalChild}+${tourGroup.totalGuide}</td>
			  </tr>
			  <tr>
			    <td style="text-align: right;width:12%;height:40px">导游：</td>
			    <td class="rich_text" style="text-align: left;width:46%">${tourGuide}</td>
			    <td style="text-align: right;width:12%">司机：</td>
			    <td class="rich_text"style="text-align: left;width:30%">${driverString}</td>
			  </tr>
			  <tr>
			    <td style="text-align: right;width:12%;height:40px">全陪：</td>
			    <td style="text-align: left;width:46%" class="rich_text">${guestGuideString }</td>
			    <td style="text-align: right;width:12%">领队：</td>
			    <td style="text-align: left;width:30%" class="rich_text">${guestIsLeaderString }</td>
			  </tr>
			  <tr>
			   	<td style="text-align: right;width:12%;height:40px">产品：</td>
			    <td style="text-align: left" colspan="3">【${tourGroup.productBrandName}】${tourGroup.productName}</td>
			  </tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:12%">日期</th>
		  			<th style="width:58%">行程</th>
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
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<c:if test="${tourGroup.groupMode gt '0'}">
					<tr>
					    <td style="text-align: right;width:12%"">交通信息</td>
					    <td class="rich_text">${trans}</td>
				  	</tr>
				</c:if>
				<tr>
				    <td style="text-align: right;width:12%"">服务标准</td>
				    <td class="rich_text">${tourGroup.serviceStandard}</td>
			  	</tr>
			    <tr>
				    <td style="text-align: right">备注</td>
				    <td class="rich_text">${tourGroup.remark }</td>
			    </tr>
			    <tr>
				    <td style="text-align: right">内部备注</td>
				    <td class="rich_text">${tourGroup.remarkInternal}</td>
			    </tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:12%">类别</th>
		  			<th style="width:20%">名称</th>
		  			<th style="width:20%">联系方式</th>
		  			<th style="width:10%">结算方式</th>
		  			<th style="width:38%">明细</th>
		  		</tr>
			  	<c:forEach items="${ggpp}" var="go">
			  		<tr>
			  			<td style="text-align: center">${go.supplierType }</td>
			  			<td style="text-align: center">${go.supplierName }</td>
			  			<td style="text-align: center">${go.contacktWay}</td>
			  			<td style="text-align: center">${go.paymentWay }</td>
			  			<td class="rich_text">${go.detail}</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table style="width: 98%;">
				<tr>
				    <td>打印人：${printName}   打印时间：${printTime}</td>
			  	</tr>
			</table>
		</div>
	</body>
</html>
<script type="text/javascript">
	$(function() {
		$('.rich_text').each(function(){
			$(this).html($(this).html().replace(/\n\n/g,'<br/>'));
	        $(this).html($(this).html().replace(/\n/g,'<br/>'));
	    });
	}); 
</script>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet" type="text/css" />
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript">
    function opPrint() {
        window.print();
    }
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
			<font size="5">订车通知单</font>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			  <tr>
			  	<td  style="width: 15%;text-align: right; font-weight: bold;">单位名称</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;"></td>
			  	<td  style="width: 15%;text-align: right;font-weight: bold;">收件人</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;"></td>
			  	<td  style="width: 14%;text-align: right;font-weight: bold;">传真</td>
			  	<td  style="width: 26%;text-align: left;font-weight: bold;"></td>
			  </tr>
			  <tr>
			    <td  style="width: 15%;text-align: right;font-weight: bold;">发件单位</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;">${company}</td>
			  	<td  style="width: 15%;text-align: right;font-weight: bold;">发件人</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;">${user_name}</td>
			  	<td  style="width: 14%;text-align: right;font-weight: bold;">传真</td>
			  	<td  style="width: 26%;text-align: left;font-weight: bold;">${user_fax}</td>
			  </tr>
			  <tr>
			    <td  style="width: 15%;text-align: right;font-weight: bold;">团号</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;">${groupCode}</td>
			  	<td  style="width: 15%;text-align: right;font-weight: bold;">总人数</td>
			  	<td  style="width: 15%;text-align: left;font-weight: bold;">${totalPersons}</td>
			  	<td  style="width: 14%;text-align: right;font-weight: bold;">导游</td>
			  	<td  style="width: 26%;text-align: left;font-weight: bold;">${guideString }</td>
			  </tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:15%">日期</th>
		  			<th>行程</th>
		  			<th style="width:7%">早</th>
		  			<th style="width:7%">中</th>
		  			<th style="width:7%">晚</th>
		  			<th style="width:19%">住宿</th>
		  		</tr>
			  	<c:forEach items="${routeList}" var="rl">
			  		<tr>
			  			<td style="text-align: center"><fmt:formatDate value="${rl.groupRoute.groupDate}" pattern="MM-dd"/></td>
			  			<td class="rich_text" style="font-weight: bold;">${rl.groupRoute.routeDesp }</td>
			  			<td style="text-align: center;font-weight: bold;">${rl.groupRoute.breakfast }</td>
			  			<td style="text-align: center;font-weight: bold;">${rl.groupRoute.lunch }</td>
			  			<td style="text-align: center;font-weight: bold;">${rl.groupRoute.supper }</td>
			  			<td style="text-align: center;font-weight: bold;">${rl.groupRoute.hotelName }</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table id="tt" style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="40%" />
				<tr>
					<th style="text-align: center;font-weight: bold;">类型</th>
					<th style="text-align: center;font-weight: bold;">座位数</th>
					<th style="text-align: center;font-weight: bold;">用车日期</th>
					<th style="text-align: center;font-weight: bold;">返程日期</th>
					<th style="text-align: center;font-weight: bold;">备注</th>
				</tr>
				<c:forEach items="${carList}" var="cl">
			  		<tr>
			  			<td style="text-align: center">
			  				<c:forEach items="${ftcList}" var="ftc">
								<c:if test="${ftc.id==cl.modelNum }">${ftc.value }</c:if>
							</c:forEach>
			  			</td>
			  			<td style="text-align: center;font-weight: bold;">${cl.countSeat}</td>
			  			<td style="text-align: center;font-weight: bold;">${cl.requireDate}</td>
			  			<td style="text-align: center;font-weight: bold;">${cl.requireDateTo}</td>
			  			<td style="text-align: center;font-weight: bold;">${cl.remark}</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table id="tt" style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<tr>
					<th style="text-align: center;font-weight: bold;">车队</th>
					<th style="text-align: center;font-weight: bold;">座位数</th>
					<th style="text-align: center;font-weight: bold;">用车日期</th>
					<th style="text-align: center;font-weight: bold;">返程日期</th>
					<th style="text-align: center;font-weight: bold;">类别</th>
					<th style="text-align: center;font-weight: bold;">车牌</th>
					<th style="text-align: center;font-weight: bold;">司机</th>
					<th style="text-align: center;font-weight: bold;">金额</th>
				</tr>
				<c:forEach items="${details}" var="ds">
			  		<tr>
			  			<td style="text-align: center">
			  				${ds.supplierName }
			  			</td>
			  			<td style="text-align: center;font-weight: bold;">${ds.type2Name}</td>
			  			<td style="text-align: center;font-weight: bold;"><fmt:formatDate value="${ds.itemDate}" pattern="MM-dd"/></td>
			  			<td style="text-align: center;font-weight: bold;"><fmt:formatDate value="${ds.itemDateTo}" pattern="MM-dd"/></td>
			  			<td style="text-align: center;font-weight: bold;">${ds.type1Name}</td>
			  			<td style="text-align: center;font-weight: bold;">${ds.carLisence}</td>
			  			<td style="text-align: center;font-weight: bold;">${ds.driverName}</br>${ds.driverTel}</td>
			  			<td style="text-align: center;font-weight: bold;"><fmt:formatNumber value="${ds.itemPrice}" pattern="#.##" type="number"/></td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
				    <td style="width: 15%;text-align: center">备注</td>
				    <td></td>
			  	</tr>
			</table>
			<h3 align="left">请盖章确认后回传！谢谢！</h3>
			<table style="width: 98%;">
				<tr>
				    <td style="font-weight: bold;">打印人：${printName}  电话：${user_tel}  打印时间：${printTime}</td>
			  	</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		function toExportWord(){
			window.location = "toExport.do?groupId=${groupId}" ;
		}
	</script>
</html>



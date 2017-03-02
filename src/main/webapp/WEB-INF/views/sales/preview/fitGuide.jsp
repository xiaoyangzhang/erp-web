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
<style type="text/css">
table,table tr th,table tr td{border-color: #000;}
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
		<img src="${imgPath }" /><br/>
		<font size="5">散客导游单</font>
		<table style="width: 100%; border-collapse: collapse; margin: 0px" border="1">
			<tr>
				<td style="text-align: center;width:10%;height:22px">团号</td>
				<td style="width:40%">${tourGroup.groupCode }</td>
				<td style="text-align: center;width:10%">计调</td>
				<td style="width:40%">${tourGroup.operatorName }((电话：${operatorMobile })</td>
			</tr>
			<tr>
				<td style="text-align: center;height:22px">发团日期</td>
				<td><fmt:formatDate value="${tourGroup.dateStart }" type="date"
						pattern="yyyy-MM-dd" /></td>
				<td style="text-align: center">人数</td>
				<td>${tourGroup.totalAdult }大${tourGroup.totalChild }小</td>
			</tr>
			<tr>
				<td style="text-align: center;height:22px">司机</td>
				<td class="rich_text">${driverString }</td>
				<td style="text-align: center">导游</td>
				<td class="rich_text">${guideString }</td>
			</tr>
			<tr>
				<td style="text-align: center;height:22px">产品品牌</td>
				<td>${tourGroup.productBrandName }</td>
				<td style="text-align: center">产品名称</td>
				<td>${tourGroup.productName }</td>
			</tr>
		</table>
		<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:10%">日期</th>
		  			<th style="width:60%">行程</th>
		  			<th style="width:6%">早</th>
		  			<th style="width:6%">中</th>
		  			<th style="width:6%">晚</th>
		  			<th style="width:12%">住宿</th>
		  		</tr>
			  	<c:forEach items="${routeDayVOList}" var="rl">
			  		<tr>
			  			<td style="text-align: center"><fmt:formatDate value="${rl.groupRoute.groupDate}" pattern="yyyy-MM-dd"/></td>
			  			<td class="rich_text">${rl.groupRoute.routeDesp }</td>
			  			<td style="text-align: center">${rl.groupRoute.breakfast }</td>
			  			<td style="text-align: center">${rl.groupRoute.lunch }</td>
			  			<td style="text-align: center">${rl.groupRoute.supper }</td>
			  			<td style="text-align: center">${rl.groupRoute.hotelName }</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:10%">序号</th>
		  			<th style="width:18%">城市</th>
		  			<th style="width:18%">酒店名称</th>
		  			<th style="width:18%">用房数</th>
		  			<th style="width:18%">联系方式</th>
		  			<th style="width:18%">结算方式</th>
		  		</tr>
			  	<c:forEach items="${hotelList}" var="hl" varStatus="v">
			  		<tr>
			  			<td style="text-align: center">${v.count}</td>
			  			<td style="text-align: center">${hl.cityName}</td>
			  			<td style="text-align: center">${hl.supplierName}</td>
			  			<td style="text-align: center" class="rich_text">${hl.hotelNumStatic }</td>
			  			<td style="text-align: center">${hl.contact}</td>
			  			<td style="text-align: center">${hl.cashType}</td>
			  		</tr>
			  	</c:forEach>
			</table>
	</div>
	<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
		border="1">
		<tr>
			<th style="height:22px">序号</th>
			<th>客人</th>
			<th>人数</th>
			<th>客源地</th>
			<th>星级</th>
			<th>房量</th>
			<th>接机信息</th>
			<th>送机信息</th>
			<th>省内交通</th>
			<th>客人信息</th>
			<th>备注</th>
		</tr>
		<c:forEach items="${orderList }" var="po" varStatus="i">
			<tr>
				<td width="4%" align="center">${i.count}</td>
				<td width="6%">${po.receiveMode }</td>
				<td width="4%" align="center">${po.personNum }</td>
				<td width="5%" align="center">${po.place }</td>
				<td width="4%" align="center">${po.hotelLevel }</td>
				<td width="4%" align="center">${po.hotelNum }</td>
				<td  class="rich_text" width="10%">${po.airPickup }</td>
				<td  class="rich_text" width="10%">${po.airOff }</td>
				<td  class="rich_text" width="10%">${po.trans }</td>
				<td width="30%" height="100%">
					<table border="1" class="in_table">
						<col width="25%" />
						<col width="40%" />
						<col width="35%" />
						<tbody>
							<c:forEach items="${po.guests}" var="v">
								<tr>
									<td>${v.name }</td>
									<td>${v.certificateNum }</td>
									<td  class="rich_text">${v.mobile}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<%--${po.guests.size()}--%>
				</td>
				<td width="13%">${po.remark }</td>
				</tr>
			</tr>
		</c:forEach>
	</table>

	<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
		border="1">
		<tr>
			<th style="width:20%;height:22px;">类别</th>
			<th style="width:20%">名称</th>
			<th style="width:20%">联系方式</th>
			<th style="width:20%">结算方式</th>
			<th style="width:20%">明细</th>
		</tr>
		<c:forEach items="${mapList }" var="po">
			<tr>
				<td style="text-align: center; ">${po.supplierType}</td>
				<td style="text-align: left; padding-left: 5px">${po.supplierName}</td>
				<td>${po.contacktWay}</td>
				<td>${po.paymentWay }</td>
				<td style="text-align: left; padding-left: 5px">${po.detail }</td>
			</tr>
		</c:forEach>
	</table>
	<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
		border="1">
		<tr>
			<td>内部备注：${tourGroup.remarkInternal }</td>
		</tr>
	</table>
	<table style="width: 98%;;font-size: 10px;">
		<tr>
			<td>打印人：${printName} 打印时间：<fmt:formatDate value="${now}"
					type="date" pattern="yyyy-MM-dd" /></td>
		</tr>
	</table>

</body>
</html>
<script type="text/javascript">
	(function() {
		$('.rich_text').each(function() {
			$(this).html($(this).html().replace(/\n/g, '<br/>'));
			$(this).html($(this).html().replace(/,/g, '<br/>'));
		});
	})();
	function opPrint() {
		window.print();
	}
	function toExportWord() {
		window.location = "download.htm?groupId=${tourGroup.id}&num=5"
	}
</script>
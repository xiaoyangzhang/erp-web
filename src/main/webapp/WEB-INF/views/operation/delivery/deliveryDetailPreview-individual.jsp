<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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

body {
	font-size: 10pt !important;
}

div {
	font-size: 10pt !important;
}
</style>

<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />

</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出word"
				onclick="exportWord(${bookingId})" /> <input id="btnClose"
				type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		<h6 style="font-size: 30px; font-weight: bold;" align="center">散客团地接社通知单</h6>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tbody>
				<tr>
					<td style="font-weight: bold; width: 10%; text-align: right">收件方：</td>
					<td style="font-weight: bold;">${agencyMap.suppliername }</td>
					<td style="font-weight: bold; width: 10%; text-align: right">发件方：</td>
					<td style="font-weight: bold;">${agencyMap.company }</td>
				</tr>
				<tr>
					<td style="font-weight: bold; width: 10%; text-align: right">收件人：</td>
					<td style="font-weight: bold;">${agencyMap.contact }</td>
					<td style="font-weight: bold; width: 10%; text-align: right">发件人：</td>
					<td style="font-weight: bold;">${agencyMap.username }</td>
				</tr>
				<tr>
					<td style="font-weight: bold; width: 10%; text-align: right">电&nbsp;话：</td>
					<td style="font-weight: bold;">${agencyMap.contacttel }</td>
					<td style="font-weight: bold; width: 10%; text-align: right">电&nbsp;话：</td>
					<td style="font-weight: bold;">${agencyMap.usertel }</td>
				</tr>
				<tr>
					<td style="font-weight: bold; width: 10%; text-align: right">传&nbsp;真：</td>
					<td style="font-weight: bold;">${agencyMap.contactfax }</td>
					<td style="font-weight: bold; width: 10%; text-align: right">传&nbsp;真：</td>
					<td style="font-weight: bold;">${agencyMap.userfax }</td>
				</tr>
			</tbody>
		</table>
		<table style="height:50px;width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<td style="text-align: left;font-weight: bold;">
					我公司旅行团一行：
					${groupMap.totaladult}大${groupMap.totalcg}陪${groupMap.totalchild}小，产品：【${groupMap.productBrand}】${groupMap.productName}，
					团号： ${groupMap.groupcode} , 现将预订单呈上，请及时安排落实并回复，谢谢！
				</td>
			</tr>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<thead>
				<th>日期<i class="w_table_split"></i></th>
				<th>行程<i class="w_table_split"></i></th>
				<th>早<i class="w_table_split"></i></th>
				<th>中<i class="w_table_split"></i></th>
				<th>晚<i class="w_table_split"></i></th>
				<th>住宿<i class="w_table_split"></i></th>
			</thead>
			<tbody>
				<c:forEach items="${ routeMapList}" var="route">
					<tr>
						<td style="text-align: center; font-weight: bold;" width="10%;">${route.day }</td>
						<td style="text-align: center; font-weight: bold;" width="70%">${route.routedesp }</td>
						<td style="text-align: center; font-weight: bold;" width="5%">${route.isbreakfast }</td>
						<td style="text-align: center; font-weight: bold;" width="5%">${route.islunch }</td>
						<td style="text-align: center; font-weight: bold;" width="5%">${route.issupper }</td>
						<td style="text-align: center; font-weight: bold;" width="5%">${route.hotelname }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tbody>
				<tr>
					<td style="font-weight: bold; width: 10%" align="center">司机</td>
					<td style="font-weight: bold; width: 90%" align=""left"">${staffsMap.driverInfo }</td>
				</tr>
				<tr>
					<td style="font-weight: bold;width: 10%" align="center">导游</td>
					<td style="font-weight: bold;width: 90%" align="left">${staffsMap.guideInfo }</td>
				</tr>
				<tr>
					<td style="font-weight: bold;width: 10%" align="center">全陪</td>
					<td style="font-weight: bold;width: 90%" align=""left"">${staffsMap.accompanyInfo }</td>
				</tr>
				<tr>
					<td style="font-weight: bold;width: 10%" align="center">领队</td>
					<td style="font-weight: bold;width: 90%" align=""left"">${staffsMap.leaderInfo }</td>
				</tr>
				<tr>
					<td style="font-weight: bold;width: 10%" align="center">客人信息</td>
					<td style="font-weight: bold;width: 90%" align=""left"">${staffsMap.receivemode }</td>
				</tr>
			</tbody>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr height="28px">
				<th>序号<i class="w_table_split"></i></th>
				<th>项目<i class="w_table_split"></i></th>
				<th>描述<i class="w_table_split"></i></th>
				<th>单价<i class="w_table_split"></i></th>
				<th>次数<i class="w_table_split"></i></th>
				<th>人数<i class="w_table_split"></i></th>
				<th>金额<i class="w_table_split"></i></th>
			</tr>
			<tbody>
				<c:forEach items="${priceMapList}" var="price" varStatus="vs">
					<c:if test="${fn:length(price)>1 }">
					<tr height="28px">
						<td style="font-weight: bold;" align="center" width="10%">${price.seq}</td>
						<td style="font-weight: bold;" align="center" width="10%">${price.itemname}</td>
						<td style="font-weight: bold;" align="center" width="40%">${price.remark }</td>
						<td style="font-weight: bold;" align="center" width="10%"><fmt:formatNumber value="${price.unitprice}" pattern="#.##" type="number"/></td>
						<td style="font-weight: bold;" align="center" width="10%"><fmt:formatNumber value="${price.numtimes }" pattern="#.##" type="number"/></td>
						<td style="font-weight: bold;" align="center" width="10%"><fmt:formatNumber value="${price.numperson }" pattern="#.##" type="number"/></td>
						<td style="font-weight: bold;" align="center" width="10%"><fmt:formatNumber value="${price.totalprice }" pattern="#.##" type="number"/></td>
					</tr>
					<c:set var="sum_price" value="${sum_price+price.totalprice }" />
					</c:if>
				</c:forEach>
			</tbody>
			<tbody>
				<tr>
					<td colspan="7" style="text-align: right;font-weight: bold;">合计：<fmt:formatNumber value="${sum_price }" pattern="#.##" type="number"/></td>
				</tr>
			</tbody>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<th >序号<i class="w_table_split"></i></th>
				<th >客人<i class="w_table_split"></i></th>
				<th >人数<i class="w_table_split"></i></th>
				<th >星级<i class="w_table_split"></i></th>
				<th >房量<i class="w_table_split"></i></th>
				<th >接机信息<i class="w_table_split"></i></th>
				<th >送机信息<i class="w_table_split"></i></th>
				<th >省内交通<i class="w_table_split"></i></th>
				<th >客人信息<i class="w_table_split"></i></th>
				<th >备注<i class="w_table_split"></i></th>
			</tr>
			<tbody>
				<c:forEach items="${orderMapList}" var="order" varStatus="vs">
					<tr>
						<td style="width: 5%;font-weight: bold;text-align: center">${order.num}</td>
						<td style="width: 5%;font-weight: bold;">${order.guestStatic}</td>
						<td style="width: 5%;font-weight: bold;">${order.personNum }</td>
						<td style="width: 5%;font-weight: bold;">${order.hotelLevel }</td>
						<td style="width: 5%;font-weight: bold;">${order.hotelNum }</td>
						<td style="width: 15%;font-weight: bold;">${order.up }</td>
						<td style="width: 15%;font-weight: bold;">${order.off }</td>
						<td style="width: 15%;font-weight: bold;">${order.trans }</td>
						<td style="width: 15%;font-weight: bold;">${order.guestInfo }</td>
						<td style="width: 15%;font-weight: bold;">${order.remark }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tbody>
				<tr height="90px">
					<td style="font-weight: bold;" width="10%" align="center">订单备注</td>
					<td style="font-weight: bold;">${remarkMap.remark }</td>
				</tr>
				<tr height="90px">
					<td style="font-weight: bold;" width="10%" align="center">服务标准</td>
					<td style="font-weight: bold;">${remarkMap.serviceStandard }</td>
				</tr>
				<tr height="90px">
					<td style="font-weight: bold;" width="10%" align="center">团备注</td>
					<td style="font-weight: bold;">${remarkMap.groupRemark }</td>
				</tr>
				<tr height="90px">
					<td style="font-weight: bold;" width="10%" rowspan="3"></td>
					<td>&nbsp;&nbsp;&nbsp;
						<table>
							<td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;旅行社盖章：</td>
							<td style="font-weight: bold;" width="500px">供应商盖章：</td>
						</table>&nbsp;&nbsp;&nbsp;
						<table>
							<td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签字：</td>
							<td style="font-weight: bold;" width="700px">签字：</td>
						</table>&nbsp;&nbsp;&nbsp;
						<table>
							<td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>
							<td style="font-weight: bold;" width="700px">日期：</td>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
		<table style="width: 100%;" border="1">
			<tr>
				<td style="font-weight: bold;">打印时间：${otherMap.print_time}</td>
			</tr>
		</table>
	</div>

</body>
</html>
<script type="text/javascript">
	function opPrint() {
		window.print();
	}
	function exportWord(bookingId){
		location.href="deliveryExport.do?bookingId="+bookingId ; //供应商确认订单
	}
</script>
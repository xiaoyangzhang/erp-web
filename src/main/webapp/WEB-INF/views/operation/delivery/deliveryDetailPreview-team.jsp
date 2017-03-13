<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
			<input type="button" value="导出word" onclick="exportWord(${bookingId})" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" /><h6 style="font-size: 30px;font-weight: bold;" align="center" >定制团地接社通知单</h6>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="0">
			<tbody>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">收件方：${agencyMap.suppliername }</td>
					<td style="font-weight: bold;">发件方：${agencyMap.company }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">收件人：${agencyMap.contact }</td>
					<td style="font-weight: bold;">发件人：${agencyMap.username }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">电&nbsp;话：${agencyMap.contacttel }</td>
					<td style="font-weight: bold;">电&nbsp;话：${agencyMap.usertel }</td>
				</tr>
				<tr><td width="200px"></td>
					<td style="font-weight: bold;">传&nbsp;真：${agencyMap.contactfax }</td>
					<td style="font-weight: bold;">传&nbsp;真：${agencyMap.userfax }</td>
				</tr>
			</tbody>	
		</table>
		<hr color="black"/><hr color="black"/><br/><br/>
		<span style="text-align: left;display:block;font-weight: bold;">		我公司旅行团一行： ${groupMap.totaladult}大${groupMap.totalcg}陪${groupMap.totalchild}小人，产品：【${groupMap.productBrand}】${groupMap.productName}， 团号： ${groupMap.groupcode}
					 ， 
					现将预订单呈上，请及时安排落实并回复，谢谢！
				</span>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<thead>
					<th >日期<i class="w_table_split"></i></th>
			<th >行程<i class="w_table_split"></i></th>
			<th >早<i class="w_table_split"></i></th>
			<th >中<i class="w_table_split"></i></th>
			<th >晚<i class="w_table_split"></i></th>
			
			<th >住宿<i class="w_table_split"></i></th>
				</thead>
				<tbody>
				<c:forEach items="${ routeMapList}" var="route">
					<tr>
					<td style="font-weight: bold;" width="5%">${route.day }</td>
					<td style="font-weight: bold;" width="75%">${route.routedesp }</td>
					<td style="font-weight: bold;" width="5%">${route.isbreakfast }</td>
					<td style="font-weight: bold;" width="5%">${route.islunch }</td>
					<td style="font-weight: bold;" width="5%">${route.issupper }</td>
					<td style="font-weight: bold;" width="5%">${route.hotelname }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
			<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr height="28px">
				<th >序号<i class="w_table_split"></i></th>
			<th >项目<i class="w_table_split"></i></th>
			<th >描述<i class="w_table_split"></i></th>
			<th >单价<i class="w_table_split"></i></th>
			<th >次数<i class="w_table_split"></i></th>
			
			<th >人数<i class="w_table_split"></i></th>
			<th >金额<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
			<c:forEach items="${priceMapList}" var="price" varStatus="vs">				
				<c:if test="${fn:length(price)>1 }">
				<tr height="28px" >
					<td style="font-weight: bold;" align="center" width="199px">${price.seq}</td>
					<td style="font-weight: bold;" align="center" width="199px">${price.itemname}</td>
	      			<td style="font-weight: bold;" align="center" width="199px">${price.remark }</td>
					<td style="font-weight: bold;" align="center" width="199px">${price.unitprice }</td>
					<td style="font-weight: bold;" align="center" width="199px">${price.numtimes }</td>
					<td style="font-weight: bold;" align="center" width="199px">${price.numperson }</td>
					<td style="font-weight: bold;" align="center" width="199px">${price.totalprice }</td>
				</tr>
				<%-- <c:set var="sum_totalCount" value="${sum_totalCount+v.itemTotal}" />
				 <c:set var="sum_totalNumMinus" value="${sum_totalNumMinus+v.itemNumMinus}" />--%>	
				<c:set var="sum_price" value="${sum_price+price.totalprice }" />
			</c:if>
		</c:forEach>

		<tr>
			<td style="font-weight: bold;" align="center" ></td>
					<td style="font-weight: bold;" align="center" ></td>
	      			<td style="font-weight: bold;" align="center" ></td>
					<td style="font-weight: bold;" align="center" ></td>
					<td style="font-weight: bold;" align="center" ></td>
					<td style="font-weight: bold;" align="center" >合计</td>
					<td style="font-weight: bold;" align="center" >${sum_price }</td>
		</tr>
	</tfoot> 
		</table>

		
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr height="28px">
				<th >序号<i class="w_table_split"></i></th>
			<th >姓名<i class="w_table_split"></i></th>
			<th >性别<i class="w_table_split"></i></th>
			<th >手机<i class="w_table_split"></i></th>
			<th >身份证号<i class="w_table_split"></i></th>
			
			<th >籍贯<i class="w_table_split"></i></th>
			<th >年龄<i class="w_table_split"></i></th>
			<th >备注<i class="w_table_split"></i></th>
			</tr>
			<tbody>
			
				<c:forEach items="${orderMapList}" var="order" varStatus="vs">
			<tr height="28px" >
				<td style="font-weight: bold;" align="center" width="199px">${order.num}</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.name}</td>
      			<td style="font-weight: bold;" align="center" width="199px">${order.sex }</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.mobile }</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.IDCard }</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.address }</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.age }</td>
				<td style="font-weight: bold;" align="center" width="199px">${order.remark }</td>
			</tr>
		
			 <c:set var="HotelLevel" value="${order.hotelLevel}" />
			 <c:set var="hotelNum" value="${order.hotelNum}" />
			 <c:set var="up" value="${order.up}" />
			 <c:set var="off" value="${order.off}" />
			 <c:set var="trans" value="${order.trans}" />
		</c:forEach>
			</tbody>
			
		</table>
				<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<tbody>
					<tr><td  style="font-weight: bold;" align="left" >客人信息</td>
						<td style="font-weight: bold;" align="left">${staffsMap.receivemode }</td></tr>
						
					<tr>
						<td style="font-weight: bold;" align="left">司机</td>
						<td style="font-weight: bold;" align="left">${staffsMap.driverInfo }</td>
					</tr>
					<tr><td style="font-weight: bold;" align="left">导游</td>
						<td style="font-weight: bold;" align="left">${staffsMap.guideInfo }</td></tr>
					<tr><td style="font-weight: bold;" align="left">全陪</td>
						<td style="font-weight: bold;" align="left">${staffsMap.accompanyInfo }</td></tr>
					<tr><td style="font-weight: bold;" align="left">领队</td>
						<td style="font-weight: bold;" align="left">${staffsMap.leaderInfo }</td></tr>
					<tr><td  style="font-weight: bold;" align="left" >用房</td>
						<td style="font-weight: bold;" align="left">${HotelLevel }&nbsp;${hotelNum }</td></tr>
						<tr><td  style="font-weight: bold;" align="left" >接送信息</td>
						<td style="font-weight: bold;" align="left">${up }<br/>${off }<br/>${trans}</td></tr>
				</tbody>
			</table>
			<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<tbody>
					<tr height="90px">
						<td style="font-weight: bold;"  width="5%" align="center">订单备注</td>
						<td style="font-weight: bold;" >${remarkMap.remark }
						
						 </td>
						</tr>
					<tr height="90px">
						<td style="font-weight: bold;"  width="5%" align="center">服务标准</td>
						<td style="font-weight: bold;" >${remarkMap.serviceStandard }
						
						 </td>
						</tr>
					<tr height="90px">
						<td style="font-weight: bold;"  width="5%" align="center">团备注</td>
						<td style="font-weight: bold;" >${remarkMap.groupRemark }
						
						</td>
						</tr>
						<tr height="90px">
						<td style="font-weight: bold;"  width="5%" rowspan="3"></td>
						<td style="font-weight: bold;" >
							&nbsp;&nbsp;&nbsp;
							<table>	 
							 <td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;旅行社盖章：</td>
							<td style="font-weight: bold;" width="500px">供应商盖章：</td>
						</table>&nbsp;&nbsp;&nbsp;<table>
							<td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签字：</td>
							<td style="font-weight: bold;" width="700px">签字：</td>
						</table>&nbsp;&nbsp;&nbsp;<table>
							<td style="font-weight: bold;" width="700px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日期：</td>
							<td style="font-weight: bold;" width="700px">日期：</td> 
						</table>		
							
						</td>
					</tr>
				</tbody>
			</table>
		<table style="width: 100%;">
			<tr>
				<td style="font-weight: bold;"> 打印时间：${otherMap.print_time}
						</td>
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
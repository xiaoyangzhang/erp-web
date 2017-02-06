<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:useBean id="now" class="java.util.Date" />

<%@ include file="../../../include/top.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>打印页</title>
<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
<style media="print" type="text/css">
.NoPrint {
	display: none;
}

</style>
<style type="text/css">
table,table tr th,table tr td{border-color: #000;}
</style>
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
		<font size="5">散客计调单</font>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tr>
				<td style="text-align: center; width:10%;height:25px">团号</td>
				<td  style="width:41%">${tourGroup.groupCode }</td>
				<td style="text-align: center; width:12%">计调</td>
				<td>${tourGroup.operatorName }(电话：${operatormobile })</td>
			</tr>
			<tr>
				<td style="text-align: center;height:25px">发团日期</td>
				<td><fmt:formatDate value="${tourGroup.dateStart }" type="date"
						pattern="yyyy-MM-dd" /></td>
				<td style="text-align: center">人数</td>
				<td>${tourGroup.totalAdult }大${tourGroup.totalChild }小</td>
			</tr>
			<tr>
				<td style="text-align: center;height:25px">司机</td>
				<td class="rich_text" >${driverString }</td>
				<td  style="text-align: center">导游</td>
				<td class="rich_text">${guideString}</td>
			</tr>
			<tr>
				<td style="text-align: center;height:25px">产品品牌</td>
				<td>${tourGroup.productBrandName }</td>
				<td style="text-align: center">产品名称</td>
				<td>${tourGroup.productName }</td>
			</tr>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px;font-size: 10px;"
			border="1">
			<tr>
				<th>序号</th>
				<th>组团社</th>
				<th>销售</th>
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
					<td width="2%" align="center">${i.count}</td>
					<td width="8%" class="rich_text">${po.supplierName }</td>
					<td width="3%" align="center">${po.saleOperatorName }</td>
					<td width="5%" align="center">${po.receiveMode }</td>
					<td width="3%" align="center">${po.personNum }</td>
					<td width="5%" align="center">${po.place }</td>
					<td width="5%" align="center">${po.hotelLevel }</td>
					<td width="3%" align="center">${po.hotelNum }</td>
					<td class="rich_text" width="8%">${po.airPickup }</td>
					<td class="rich_text" width="8%">${po.airOff }</td>
					<td class="rich_text" width="8%">${po.trans }</td>
					<td width="30%" height="100%">
						<table border="1" class="in_table">
							<col width="20%" />
							<col width="40%" />
							<col width="40%" />
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
					</td>
<<<<<<< Updated upstream
					<td width="12%">${po.remark }</td>
=======
					
					<td width="12%">
						<c:if test="${tourGroup.bizId==1}">${po.remarkInternal }</c:if>
						<c:if test="${tourGroup.bizId!=1}">
							<c:if test="${empty po.remarkInternal}">${po.remark }</c:if>
							<c:if test="${not empty po.remarkInternal}">${po.remarkInternal }</c:if>
						</c:if>
					</td>
>>>>>>> Stashed changes
				</tr>
			</c:forEach>
			<tr>
					<td align="center" colspan="13"><strong>房量合计:${total}</strong></td>
				</tr>
		</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px" border="1">
			<tr>
				<td style="text-align: center;width:10%">地接</td>
				<td class="rich_text">${deliveryDetail }</td>
			</tr>
			<tr>
				<td style="text-align: center">内部备注</td>
				<td class="rich_text">${tourGroup.remarkInternal}</td>
			</tr>
		</table>
		<table style="width: 98%;">
			<tr>
				<td>打印人：${printName} 打印时间：<fmt:formatDate value="${now}"
						type="date" pattern="yyyy-MM-dd" /></td>
			</tr>
		</table>

	</div>
</body>
</html>
<script type="text/javascript">
	$(function() {
		$('.rich_text').each(function(){
			//$(this).html($(this).html().replace(/\n\n/g,'<br/>'));
	        $(this).html($(this).html().replace(/\n/g,'<br/>'));
	        $(this).html($(this).html().replace(/,/g,'<br/>'));
	        $(this).html($(this).html().replace(/，/g,'<br/>'));
	    });
	}); 
	function opPrint() {
		window.print();
	}
	function toExportWord() {
		window.location = "download.htm?groupId=${tourGroup.id}&num=1"
	}
</script>

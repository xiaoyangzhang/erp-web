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
			<font size="5">确认单</font>
			<table style="width: 90%; margin-left:10%">
			  <tr>
			    <td style="width:10%;text-align: right">收件方：</td>
			    <td style="width:15%;text-align: left">${groupOrder.supplierName}</td>
			    <td style="width:10%;text-align: right">收件人：</td>
			    <td  style="width:15%;text-align: left">${groupOrder.contactName}</td>
			    <td style="width:10%;text-align: right">电话：</td>
			    <td  style="width:15%;text-align: left">${groupOrder.contactTel }</td>
			    <td style="width:10%;text-align: right">传真：</td>
			    <td  style="width:15%;text-align: left">${groupOrder.contactFax }</td>
			  </tr>
			  <tr>
			    <td style="width:10%;text-align: right">发件方：</td>
			    <td  style="width:15%;text-align: left">${company}</td>
			    <td style="width:10%;text-align: right">发件人：</td>
			    <td  style="width:15%;text-align: left">${employee.name}</td>
			    <td style="width:10%;text-align: right">电话：</td>
			    <td  style="width:15%;text-align: left">${employee.mobile }</td>
			    <td style="width:10%;text-align: right">传真：</td>
			    <td  style="width:15%;text-align: left">${employee.fax }</td>
			  </tr>
			</table>
			<table style="width:100%;"  border="1">
				<tr>
					<td style="text-align: right;width:8%">团号</td>
					<td style="text-align: left;width:23%">${groupOrder.tourGroup.groupCode}</td>
					<td style="text-align: right;width:9%">人数</td>
					<td style="text-align: left;width:18%">${groupOrder.numAdult}+${groupOrder.numChild}+${groupOrder.numGuide}</td>
					<td style="text-align: right;width:12%">客源地</td>
					<td style="text-align: left">${groupOrder.provinceName}${groupOrder.cityName}</td>
				</tr>
				<tr>
					<td style="text-align: right">接站牌</td>
					<td style="text-align: left">${groupOrder.receiveMode}</td>
					<td style="text-align: right">出发日期</td>
					<td style="text-align: left">${groupOrder.departureDate}</td>
					<td style="text-align: right">导游</td>
					<td style="text-align: left" class="rich_text">${guideString}</td>
				</tr>
				<tr>
					<td style="text-align: right">产品</td>
					<td style="text-align: left" colspan="3">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
					<td style="text-align: right">全陪</td>
					<td style="text-align: left">${guestGuideString}</td>
				</tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:8%">日期</th>
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
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:8%">序号</th>
		  			<th style="width:15%">项目</th>
		  			<th >描述</th>
		  			<th style="width:6%">单价</th>
		  			<th style="width:6%">次数</th>
		  			<th style="width:6%">人数</th>
		  			<th style="width:12%">金额</th>
		  		</tr>
			  	<c:forEach items="${priceList}" var="pl" varStatus="vs">
			  		<tr>
			  			<td style="text-align: center">${vs.count}</td>
			  			<td style="text-align: center">${pl.itemName}</td>
			  			<td class="rich_text">${pl.remark}</td>
			  			<td style="text-align: center"><fmt:formatNumber value="${pl.unitPrice}" type="currency" pattern="#.##"/></td>
			  			<td style="text-align: center"><fmt:formatNumber value="${pl.numTimes}" type="currency" pattern="#.##"/></td>
			  			<td style="text-align: center"><fmt:formatNumber value="${pl.numPerson}" type="currency" pattern="#.##"/></td>
			  			<td style="text-align: center"><fmt:formatNumber value="${pl.totalPrice}" type="currency" pattern="#.##"/></td>
			  		</tr>
			  		<c:set var="sum_totalPrice" value="${sum_totalPrice+pl.totalPrice}" />
			  	</c:forEach>
			  	<c:if test="${agency!=1}">
			  		<tr>
			  			<td style="text-align: right; font-weight:700;" colspan="7" >
			  			应收:
			  				<fmt:formatNumber value="${sum_totalPrice}" type="currency" pattern="#.##"/>
			  			,已收:
			  			    <fmt:formatNumber value="${otherPrice}" type="currency" pattern="#.##"/>
			  			,余额:<fmt:formatNumber value="${sum_totalPrice-otherPrice}" type="currency" pattern="#.##"/>
			  			</td>
			  		</tr>
			  	</c:if>
			</table>
			<c:if test="${orderType==0 or orderType==-1}">
				<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
					<tr>
			  			<th style="width:8%">客人</th>
			  			<th style="width:10%">性别</th>
			  			<th style="width:10%">年龄</th>
			  			<th style="width:15%">电话</th>
			  			<th style="width:27%">证件号</th>
			  			<th>籍贯</th>
			  		</tr>
		  			<c:forEach items="${guests}" var="v">
		  			<tr>
		  				<td style="text-align: center">${v.name}</td>
			  			
			  			<td style="text-align: center">
			  				<c:if test="${v.gender==1}">男</c:if>
			  				<c:if test="${v.gender==0}">女</c:if>		
			  			</td>
			  			<td style="text-align: center">${v.age}</td>
			  			<td style="text-align: center">${v.mobile}</td>
			  			<td>${v.certificateNum}</td>
			  			<td>${v.nativePlace}</td>
			  			</tr>
		  			</c:forEach>
				</table>
			</c:if>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
					<tr>
			  			<th style="width:25%">银行名称</th>
			  			<th style="width:25%">开户行</th>
			  			<th style="width:25%">开户名</th>
			  			<th style="width:25%">账号</th>
			  		</tr>
		  			<c:forEach items="${accountList}" var="v">
		  			<tr>
		  				<td style="text-align: center">${v.bankName}</td>
			  			
			  			<td style="text-align: center">
			  				${v.bankAccount}
			  			</td>
			  			<td style="text-align: center">${v.accountName}</td>
			  			<td style="text-align: center">${v.accountNo}</td>
			  			</tr>
		  			</c:forEach>
				</table>
				
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
				    <td style="text-align: right" style="width:8%">房量<br/>统计</td>
				    <td class="rich_text">${hotelNum}</td>
			    </tr>
			    <c:if test="${agency==1}">
			    	<tr>
					    <td style="text-align: right" style="width:8%">银行<br/>账号</td>
					    <td class="rich_text">${bankCount}</td>
				    </tr>
			    </c:if>
			     <c:if test="${agency!=1}">
			    	<tr>
					    <td style="text-align: right" style="width:8%">接送<br/>信息</td>
					    <td class="rich_text">${upAndOff}</td>
				    </tr>
			    </c:if>
			    <tr>
				    <td style="text-align: right" style="width:8%">备注</td>
				    <td class="rich_text">${groupOrder.remark}</td>
			    </tr>
			    <tr>
				    <td style="text-align: right" style="width:8%">接待<br/>标准</td>
				    <td class="rich_text">${groupOrder.serviceStandard }</td>
			    </tr>
			    <tr>
				    <td style="width:8%"></td>
				    <td>
				    	<table style="width:100%">
				    		<tr>
							    <td>组团社盖章：</td>
							    <td>地接社盖章：</td>
						    </tr>
						    <tr>
							    <td>签字：</td>
							    <td>签字：</td>
						    </tr>
						    <tr>
							    <td>日期：</td>
							    <td>日期：</td>
						    </tr>
				    	</table>
				    </td>
			   </tr>
			</table>
			<table style="width: 98%;">
				<tr>
				    <td>打印人：${printName}   打印时间：${printTime}</td>
			  	</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		$(function(){
			$('.rich_text').each(function(){
				 $(this).html($(this).html().replace(/\n\n/g,'<br/>'));
		         $(this).html($(this).html().replace(/\n/g,'<br/>'));
		    });
		});
		
		function toExportWord(){
			window.location = "download.htm?orderId=${orderId}&num=1&agency=${agency}"
		}
	</script>
</html>


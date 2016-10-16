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
			<font size="5">结算单</font>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			  <tr>
			    <td style="text-align: right;width:18%">地接团号：</td>
			    <td style="text-align: left;width:34%">${groupOrder.tourGroup.groupCode}</td>
			    <td style="text-align: right;width:18%">组团社团号：</td>
			    <td>${groupOrder.supplierCode}</td>
			  </tr>
			  <tr>
			    <td style="text-align: right;width:18%">行程日期：</td>
			    <td style="text-align: left;width:34%">${groupOrder.departureDate}</td>
			    <td style="text-align: right;width:18%">人数：</td>
			    <td>${person}</td>
			  </tr>
			  <tr>
			    <td style="text-align: right;width:18%">全陪：</td>
			    <td style="text-align: left;width:34%" class="rich_text">${guest_guide}</td>
			    <td style="text-align: right;width:18%">领队：</td>
			    <td class="rich_text">${guest_leader}</td>
			  </tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			   <td>&nbsp;&nbsp;&nbsp;&nbsp;诚挚感谢贵公司的支持与信赖，贵公司旅行团行程已结束，现将结算单呈上，请详细核实每个项目，如有异议，请及时与我社协调更改并签字确认，谢谢！</td>
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
		  			<th style="width:10%">项目</th>
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
			  	<tr>
		  			<td style="text-align: right; font-weight:700;" colspan="7" >
		  			应收:
		  				<fmt:formatNumber value="${sum_totalPrice}" type="currency" pattern="#.##"/>
		  			    ,已收:
		  			    <fmt:formatNumber value="${otherPrice}" type="currency" pattern="#.##"/>
		  			    ,余额:<fmt:formatNumber value="${sum_totalPrice-otherPrice}" type="currency" pattern="#.##"/>
		  			</td>
		  		</tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th style="width:18%">账户类别</th>
		  			<th style="width:26%">用户</th>
		  			<th style="width:26%">开户行</th>
		  			<th style="width:30%">账户</th>
		  		</tr>
			  	<c:forEach items="${accountList}" var="rl">
			  		<tr>
			  			<td style="text-align: center">
			  			<c:if test="${rl.accountType ==1 }">个人账户 </c:if>
											<c:if test="${rl.accountType == 2 }">对公账户</c:if>
			  			</td>
			  			<td style="text-align: center">${rl.accountName }</td>
			  			<td style="text-align: center">${rl.bankAccount }</td>
			  			<td style="text-align: center">${rl.accountNo}</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			    <tr>
				    <td style="text-align: right;width:8%">备注</td>
				    <td class="rich_text">${groupOrder.remark }</td>
			    </tr>
			    <tr>
				    <td style="text-align: right">接待<br/>标准</td>
				    <td class="rich_text">${groupOrder.serviceStandard }</td>
			    </tr>
			    <tr>
				    <td></td>
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
</html>
<script type="text/javascript">
(function(){
    $('.rich_text').each(function(){
    	 $(this).html($(this).html().replace(/\n\n/g,'<br/>'));
        $(this).html($(this).html().replace(/\n/g,'<br/>'));
    });
})();

function toExportWord(){
	window.location = "download.htm?orderId=${orderId}&num=2" ;
}
</script>

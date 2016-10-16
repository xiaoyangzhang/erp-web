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
			<font size="5">散客结算单</font>
			<table style="width: 90%; margin-left:10%">
			  <tr>
			    <td style="width:20%">收件方：
			    	<select id="supplier" style="width:100px">
			    		<c:forEach items="${supplierList}" var="v">
			    			<option value="${v.id}" <c:if test="${supplierId==v.id}">selected="selected"</c:if>>${v.nameFull}</option>
			    		</c:forEach>
			    	</select>
			    </td>
			    <td style="width:30%">收件人：<span id="user">${supplier.contactName}</span> </td>
			    <td style="width:20%">电话：<span id="mobile">${supplier.contactMobile}</span></td>
			    <td style="width:30%">传真：<span id="fax">${supplier.contactFax}</span></td>
			  </tr>
			  <tr>
			    <td style="width:20%">发件方：${po.orgName}</td>
			    <td style="width:20%">收件人：${po.name}</td>
			    <td style="width:20%">电话：${po.mobile}</td>
			    <td style="width:20%">传真：${po.fax}</td>
			  </tr>
			</table>
			<table style="width: 100%; border-collapse: collapse; margin: 0px" border="1">
				<tr>
					<td style="text-align: center;width:10%;height:22px">团号</td>
					<td style="width:40%">${tour.groupCode}</td>
					<td style="text-align: center;width:10%">出团日期</td>
					<td style="width:40%"><fmt:formatDate value="${tour.dateStart}" pattern="yyyy-MM-dd"/></td>
				</tr>
				<tr>
					<td style="text-align: center;height:22px">人数</td>
					<td>${tour.totalAdult}+${tour.totalChild}</td>
					<td style="text-align: center">导游</td>
					<td>${guide}</td>
				</tr>
				<tr>
					<td style="text-align: center;height:22px" >产品名称</td>
					<td colspan="3">【${tour.productName}】${tour.productBrandName }</td>
				</tr>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
				<tr>
		  			<th>序号</th>
		  			<th>接站牌</th>
		  			<th>价格明细</th>
		  			<th>金额</th>
		  		</tr>
			  	<c:forEach items="${vos}" var="v" varStatus="vs">
			  		<tr>
			  			<td style="text-align: center;width:10%">${vs.count}</td>
			  			<td style="text-align: left;width:30%">${v.receiveMode}</td>
			  			<td class="rich_text" style="text-align: left;">${v.priceDetail}</td>
			  			<td style="text-align: center;width:10%"><fmt:formatNumber value="${v.totalPrice}" type="currency" pattern="#.##"/></td>
			  		</tr>
			  		<c:set var="sum_totalPrice" value="${sum_totalPrice+v.totalPrice}" />
			  	</c:forEach>
		  		<tr>
		  			<td style="text-align: center">合计：</td>
		  			<td style="text-align: center"></td>
		  			<td class="rich_text"></td>
		  			<td style="text-align: center"><fmt:formatNumber value="${sum_totalPrice}" type="currency" pattern="#.##"/></td>
		  		</tr>
			</table>
			<table style="width:100%;"  border="1">
				<tr>
					<th>序号</th>
		  			<th>客人</th>
		  			<th>人数</th>
		  			<th>客源地</th>
		  			<th>星级</th>
		  			<th>房量</th>
		  			<th>接送信息</th>
		  			<th>身份证号码</th>
		  			<th>备注</th>
		  		</tr>
		  		<c:forEach items="${gopps}" var="gopp" varStatus="vs">
			  		<tr>
			  			<td style="text-align:center;width:5%;">${vs.count}</td>
			  			<td class="rich_text" style="width:10%">${gopp.receiveMode}</td>
			  			<td style="text-align:center;width:5%">${gopp.personNum}</td>
			  			<td style="text-align:center;width:15%">${gopp.place}</td>
			  			<td style="text-align:center;width:5%">${gopp.hotelLevel}</td>
			  			<td style="width:10%">${gopp.hotelNum}</td>
			  			<td>
			  				${gopp.airPickup}</br>
			  				${gopp.airOff}</br>
			  				${gopp.trans}
			  			</td>
			  			<td style="width:15%">${gopp.certificateNums}</td>
			  			<td style="width:10%">${gopp.remark}</td>
			  		</tr>
			  	</c:forEach>
			</table>
			<table style="width:100%;border-collapse:collapse;margin: 0px"  border="1">
			    <tr>
				    <td style="text-align: right;width:10%">备注</td>
				    <td class="rich_text">${tour.remark }</td>
			    </tr>
			    <tr>
				    <td style="text-align: right">接待标准</td>
				    <td class="rich_text">${tour.serviceStandard }</td>
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
	<script type="text/javascript">
		$(function() {
			$('.rich_text').each(function(){
				$(this).html($(this).html().replace(/\n\n/g,'<br/>'));
		        $(this).html($(this).html().replace(/\n/g,'<br/>'));
		    });
		    $("#supplier").bind("change",function(){
		    	window.location = "toSKChargePreview.htm?groupId=${groupId}&supplierId="+$("#supplier option:selected").val() ;
		    }); 
		});
		function toExportWord(){
			window.location = "toSKConfirmPreviewExport.htm?groupId=${groupId}&supplierId="+$("#supplier option:selected").val()+"&num=1" ;
		}
	</script>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>机票订单查询</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>

</head>
<body>
	<div class="p_container">
		<form id="form" action="" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" value="${pageBean.pageSize }" />
			<!-- 
			<input type="hidden" name="sl" value="booking.selectbookingSupplier2DetailListPage" />
			<input type="hidden" name="ssl" value="booking.selectBookingTotal" />
			<input type="hidden" name="rp" value="queries/airTicket/airTicketDetailTable" /> -->
			<input type="hidden" name="flag" id="flag" value="1"/>
 			<input type="hidden" name="supplierType" id="supplierType" value="${condition.supplierType}"/>
			<input type="hidden" name="supplierId" id="supplierId" value="${condition.supplierId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">
						<select id="selectDate" name="dateType">
							<option value="start">出团日期</option>
							<option value="dep">用票日期</option>
							<option value="end">离团日期</option>
						</select></li><li>
					<input id="startTime" name="dateFrom" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						-<input id="endTime" name="dateTo" type="text" style="width: 100px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName"  type="text" value="${condition.supplierName}"/></li>
					<li class="text">团号</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">付款状态</li>
					<li>
		  				<select id="paymentState" name="paymentState">
							<option value=""></option>
							<option value="PAID">已付清</option>
							<option value="NOTPAID">未付清</option>
						</select>
					</li>
				
					<li class="text">产品</li>
					<li><input id="productBrandName" name="productName" type="text"/></li>
					
					<li class="text">航线</li>
					<li><input  class="filterAutoComplete" name="lineName" type="text" value=""/></li>

					<li class="text">接站牌</li>
					<li><input name="receiveMode" type="text" value=""/></li>
					
					<li class="text">计调</li>
					<li>
						<input id="operatorIds" name="operatorIds" type="hidden" value="${condition.operatorIds}"/>
						<input id="operatorName" name="operatorName" type="text" value="${condition.operatorName}" readonly="readonly"/>
						<a href="javascript:void(0);" onclick="selectUserMuti()">请选择</a>
					</li>
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
							<c:if test="${condition.groupMode=='1'}">
								<option value="" >全部</option>
								<option value="1" selected="selected">团客</option>
								<option value="0">散客</option>
							</c:if>
							<c:if test="${condition.groupMode=='0'}">
								<option value="">全部</option>
								<option value="1">团客</option>
								<option value="0" selected="selected">散客</option>
							</c:if>
							<c:if test="${condition.groupMode==null or condition.groupMode==''}">
								<option value="" selected="selected">全部</option>
								<option value="1">团客</option>
								<option value="0">散客</option>
							</c:if>
					</select></li>
					
					<li class="clear" />
					<li class="text">结算方式：</li>
					<li>
						<select name="cashType" id="cashType">
								<option value="">请选择</option>
								<c:forEach items="${cashType }" var="type">
									<option value="${type.value }">${type.value }</option>
								</c:forEach>
							</select>
					</li>
					<li>
						<input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
<script type="text/javascript">
$(function(){
	var vars={dateFrom : $.currentMonthFirstDay(),dateTo : $.currentMonthLastDay()};
	$("#startTime").val(vars.dateFrom);
	$("#endTime").val(vars.dateTo );	
	queryAirTicketList();
	
	$("input[name='lineName']").autocomplete(lineTemplateComplete);
	$("input[name='lineName']").click(function(){$(this).trigger(eKeyDown);});
});
function queryAirTicketList(page,pageSize) {
	if (!page){page=1;}
	if (!pageSize){pageSize=$("#pageSize").val();}
	$("#page").val(page);
	$("#pageSize").val(pageSize);
	
	var options = {
			url:"../query/getAirTicketDetail.do",
			type:"post",
			dataType:"html",
			success:function(data){
				$("#tableDiv").html(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.error("服务忙，请稍后再试");
			}
	};
	$("#form").ajaxSubmit(options);	
}
function searchBtn(){
	queryAirTicketList(1,$("#pageSize").val());
}
</script>	
</body>
</html>
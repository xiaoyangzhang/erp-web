<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>资源详细列表</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript">
$("document").ready(function(){
});
</script>
<style>
 .air_ticket_leg {width:100%; min-width:248px;}
 .air_ticket_leg td {padding:0 3px 0 3px;}
</style>
</head>
<body>
<div class="p_container" >
   <div class="p_container_sub">
   	<p class="p_paragraph_title"><b>机票信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table1" id="air_info">
		<thead>
		<tr>
			<th>采购单号</th>
			<th>航线名称</th>
			<th>航班信息</th>
			<th>机票供应商</th>
			<th>票数</th>
			<th>已申请</th>
			<th>剩余</th>
			<th>采购价/总价</th>
			<th>销售价</th>
			<th>押金</th>
			<th>最晚出票</th>
		</tr>
		</thead>
		<tbody>
		<tr style="height:50px;">
			<td>${resource.resourceNumber }</td>
			<td>${resource.po.lineName }</td>
			<td>${resource.legHtml}</td>
			<td>${resource.ticketSupplier }</td>
			<td>${resource.po.totalNumber}</td>
			<td>${resource.po.appliedNumber }</td>
			<td>${resource.po.availableNumber }</td>
			<td>${resource.po.buyPrice }</td>
			<td>${resource.price }</td>
			<td>${resource.advancedDeposit }</td>
			<td>${resource.endIssueTime }</td>
		</tr>
		</tbody>
		</table>
	</div>
	
	
	
	<div class="p_container_sub">
	<style>
	#guest_list td{height:30px;}
	#guest_list .selected td{background-color:SILVER;}
	</style>
   	<p class="p_paragraph_title"><b>游客信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table" id="guest_list">
		<thead>
		<tr>
			<th width="8%">团号</th>
			<th width="6%">订单出发日期</th>
			<th width="12%">产品</th>
			<th width="6%">接站牌</th>
			<th width="4%">申请</th>
			<th width="6%">状态</th>
			<th width="4%">游客姓名</th>
			<th width="8%">电话</th>
			<th width="10%">身份证</th>
			<th width="10%">组团备注</th>
			<th width="6%">价格</th>
			<th width="10%">订票备注</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${boList }" var="bo">
		  <c:forEach items="${bo.guestList }" var="guest" varStatus="status">
		  <tr id="${bo.id }">
		  <c:if test="${status.index==0}">
          <td rowspan="${bo.guestNumber }">
			<c:if test="${bo.groupOrder.groupMode <= 0}">
             	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${bo.groupOrder.groupId}&operType=0')">${bo.groupOrder.groupCode }</a> 
            </c:if>
            <c:if test="${bo.groupOrder.groupMode > 0}">
             	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${bo.groupOrder.groupId}&operType=0')">${bo.groupOrder.groupCode }</a>
            </c:if>
          	
          </td> 
          <td rowspan="${bo.guestNumber }">${bo.groupOrder.departureDate }</td>
          <td rowspan="${bo.guestNumber }">${bo.product }</td>
          <td rowspan="${bo.guestNumber }">${bo.groupOrder.receiveMode }</td>
          <td rowspan="${bo.guestNumber }">${bo.createrName }</td>
          <td rowspan="${bo.guestNumber }">${bo.status }</td>
          </c:if>
          <td>${guest.name }</td>
          <td>${guest.mobile }</td>
          <td>${guest.certificateNum }</td>
          <td>${guest.remark }</td>
          <td>${bo.orderMap[guest.id].price }</td>
          <td>${bo.orderMap[guest.id].comment }</td>
          </tr>
          </c:forEach>
		</c:forEach>
		</tbody>
		</table>
   </div>
   
    <a href="javascript:closeWindow();" class="button button-small" >关闭</a>
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>
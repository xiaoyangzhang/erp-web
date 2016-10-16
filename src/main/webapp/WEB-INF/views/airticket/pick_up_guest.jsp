<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%  String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
<script type="text/javascript">
$("document").ready(function(){
	
});
</script>
<style>
 .air_ticket_leg {width:100%; min-width:248px;}
 .air_ticket_leg td {padding:0 3px 0 3px;}
 .label_pick_guest{width:50px; height:26px; line-height:26px; display:block;}
</style>

</head>
<body>
<div id="guestPrice" style="display:none;"><input type="text" size="30" style="margin: 8px 20px 0 20px; align:center; text-align:right;"/></div>
<div id="guestComment" style="display:none;"><textarea style="margin: 8px 20px 0 20px; width:270px; height:66px;" maxlength="50"></textarea></div>
<div class="p_container">
	<form id='pickUpForm'>
   <div class="p_container_sub">
   	<p class="p_paragraph_title"><b>机票信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table1" id="air_info">
		<thead>
		<tr>
			<th>航线</th>
			<th>航段</th>
			<th>机票供应商</th>
			<th>票价（含机建\燃油）</th>
			<th>票数</th>
			<th>已申请</th>
			<th>剩余</th>
			<th>最晚出票</th>
		</tr>
		</thead>
		<tbody>
		<tr style="height:50px;">
			<td>${resourceBo.po.lineName }</td>
			<td>${resourceBo.legHtml }</td>
			<td>${resourceBo.ticketSupplier }</td>
			<td>${resourceBo.price }</td>
			<td>${resourceBo.po.totalNumber }</td>
			<td>${resourceBo.po.appliedNumber }</td>
			<td>${resourceBo.po.availableNumber }</td>
			<td><fmt:formatDate value="${resourceBo.po.endIssueTime}" pattern="yyyy-MM-dd HH:mm" /></td>
		</tr>
		</tbody>
		</table>
	</div>
	
	<div class="p_container_sub">
   	<p class="p_paragraph_title"><b>订单信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table1" id="air_info">
		<thead>
		<tr>
			<th>订单号</th>
			<th>出发日期</th>
			<th>产品名称</th>
			<th>组团社</th>
			<th>接站牌</th>
			<th>订单人数</th>
		</tr>
		</thead>
		<tbody>
		<tr style="height:50px;">
			<td>${bo.groupOrder.orderNo }</td>
			<td>${bo.groupOrder.departureDate }</td>
			<td>${bo.product }</td>
			<td>${bo.supplier }</td>
			<td>${bo.groupOrder.receiveMode }</td>
			<td>${bo.groupGuestNumber }</td>
		</tr>
		</tbody>
		</table>
	</div>

	<div class="p_container_sub">
   	<p class="p_paragraph_title"><b>接送机信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table1" id="air_info">
		<thead>
		<tr>
			<th width="40"><input type="checkbox" id="checkAll"/></th>
			<th>接送方式</th>
			<th>出发日期</th>
			<th>航班号</th>
			<th>出发城市</th>
			<th>到达城市</th>
			<th>线路类型</th>
			<th>出发机场</th>
			<th>出发时间</th>
			<th>到达机场</th>
			<th>到达时间</th>
			<th>目的地</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${resourceBo.legList}" var="leg" varStatus="status">
		<tr>
			<c:set var="i" value="${status.index}"/>
			<td><input type="checkbox" id="pickUpId[${i}]" name="checkIndex[${i}]" onchange="updateSelectAll();"/></td>
			<td>
				<input id="type1[${i}]" name="type[${i}]" type="radio" value="1" checked="true"/>
				<label for="type1[${i}]">送</label>
				<input id="type0[${i}]" name="type[${i}]" type="radio" value="0" />
				<label for="type0[${i}]">接</label>
			</td>
			<td><fmt:formatDate value="${leg.depDate}" pattern="yyyy-MM-dd" /><input type="hidden" name="departureDate[${i}]" 
				value="<fmt:formatDate value="${leg.depDate}" pattern="yyyy-MM-dd" />"></td>
			<td>${leg.airCode}<input type="hidden" name="classNo[${i}]" value="${leg.airCode}"></td>
			<td>${leg.depCity}<input type="hidden" name="departureCity[${i}]" value="${leg.depCity}"></td>
			<td>${leg.arrCity}<input type="hidden" name="arrivalCity[${i}]" value="${leg.arrCity}"></td>
			<td><select name="sourceType[${i}]"><option value="1">省外交通</option><option value="0">省内交通</option></select></td>
			<td><input type="text" name="departureStation[${i}]" /><br/><span id="airLineMsg${i}"></span></td>
			<td><input type="text" name="departureTime[${i}]"  value="<fmt:formatDate value="${leg.depTime}" pattern="HH:mm"/>"/></td>
			<td><input type="text" name="arrivalStation[${i}]"/></td>
			<td><input type="text" name="arrivalTime[${i}]"  value="<fmt:formatDate value="${leg.arrTime}" pattern="HH:mm"/>"/></td>
			<td><input type="text" name="destination[${i}]" /></td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
	<a href="javascript:submitPickUp()" class="button button-primary button-small" style="margin-left:15px;">保存</a>
	<button type="button" onclick="javascript:closeWindow();" class="button button-small">关闭</button>
	</form>
</div>
<script>
var airLines = [];
function updateAirLine(){
	var i=0;
	while ($("input[name='departureDate\["+i+"\]']").length>0){
		if ($("input[name='checkIndex\["+i+"\]']").attr('checked') || 
				($("input[name='departureTime\["+i+"\]']").val()!='' && $("input[name='arrivalTime\["+i+"\]']").val()!='')){
			// 如果已经输入了起飞时间 或到达时间,不从数据库里边取。
			i++;
			continue;
		}
		var depDate = $("input[name='departureDate\["+i+"\]']").val();
		var airCode = $("input[name='classNo\["+i+"\]']").val();
		var departureCity = $("input[name='departureCity\["+i+"\]']").val();
		var arrivalCity = $("input[name='arrivalCity\["+i+"\]']").val();
		var airLineURL = "<%=path%>/airticket/resource/getAirLine.do?date="+depDate+"&airCode="+airCode+"&depCity="+departureCity+"&arrCity="+arrivalCity;
		$.getJSON(airLineURL, callBack(i));
		i++;
	}
}
function callBack(i){
	return function(data){
		if ((data.result!=200)){
			$("#airLineMsg"+i).html(data.message);
			return;
		}
		$("input[name='departureStation\["+i+"\]']").val(data.depCity+data.depTerminal);
		$("input[name='departureTime\["+i+"\]']").val(data.depTime);
		$("input[name='arrivalStation\["+i+"\]']").val(data.arrCity+data.arrTerminal);
		$("input[name='arrivalTime\["+i+"\]']").val(data.arrTime); 
		};
}
function selectAll(){
	var checkAll=$("#checkAll").attr("checked")?true:false;
	var i=0;
	while ($("input[name='checkIndex\["+i+"\]']").length>0){
		$("input[name='checkIndex\["+i+"\]']").attr("checked", checkAll);
		i++;
	}
}
function updateSelectAll(){
	var i=0;
	while ($("input[name='checkIndex\["+i+"\]']").length>0){
		if (!$("input[name='checkIndex\["+i+"\]']").attr("checked")){
			$("#checkAll").attr("checked", false);
			return ;
		}
		i++;
	}
	$("#checkAll").attr("checked", true);
}
$(function(){
	$("#checkAll").change(selectAll);
	existingInfo = ${existingTransport};
	for(i in existingInfo){
		console.log(existingInfo[i]);
		loadExistingInfo(existingInfo[i]);
	}
	updateAirLine();
	updateSelectAll();
});

function loadExistingInfo(info){
	var i=0;
	while ($("input[name='checkIndex\["+i+"\]']").length>0){
		//var depDate = info.departureTime.substr(0,10);
		if($("input[name='departureCity\["+i+"\]']").val().trim()==info.departureCity &&
				$("input[name='departureDate\["+i+"\]']").val().trim()==info.departureDate &&
				$("input[name='classNo\["+i+"\]']").val().trim() ==info.classNo && 
				$("input[name='arrivalCity\["+i+"\]']").val().trim() ==info.arrivalCity){
			
			if(info.type == 1){
				$("input:radio[name='type\["+i+"\]']").eq(0).attr("checked",'checked');
				$("input:radio[name='type\["+i+"\]']").eq(1).removeAttr("checked");
			}else{
				$("input:radio[name='type\["+i+"\]']").eq(0).removeAttr("checked");
				$("input:radio[name='type\["+i+"\]']").eq(1).attr("checked",'checked');
			}
			
			$("input[name='checkIndex\["+i+"\]']").attr("checked", true);
			$("select[name='sourceType\["+i+"\]']").val(info.sourceType);
			$("input[name='departureStation\["+i+"\]']").val(info.departureStation);
			$("input[name='departureTime\["+i+"\]']").val(info.departureTime);
			$("input[name='arrivalStation\["+i+"\]']").val(info.arrivalStation);
			$("input[name='arrivalTime\["+i+"\]']").val(info.arrivalTime);
			$("input[name='destination\["+i+"\]']").val(info.destination);
		}
		i++;
	}
	//TODO
}

function submitPickUp(){
	var i=0;
	var vars = [];
	while ($("input[name='checkIndex\["+i+"\]']").length>0){
		if ($("input[name='checkIndex\["+i+"\]']").attr("checked")){
			var v={
				type:$("input[name='type\["+i+"\]']:checked").val(),
				classNo:$("input[name='classNo\["+i+"\]']").val(),
				departureCity:$("input[name='departureCity\["+i+"\]']").val(),
				arrivalCity:$("input[name='arrivalCity\["+i+"\]']").val(),
				sourceType:$("select[name='sourceType\["+i+"\]']").val(),
				departureStation:$("input[name='departureStation\["+i+"\]']").val(),
				departureDate:$("input[name='departureDate\["+i+"\]']").val(),
				departureTime:$("input[name='departureTime\["+i+"\]']").val(),
				arrivalStation:$("input[name='arrivalStation\["+i+"\]']").val(),
				arrivalTime:$("input[name='arrivalTime\["+i+"\]']").val(),
				destination:$("input[name='destination\["+i+"\]']").val()
			}
			vars.push(v);
		}
		i++;
	}

	var jsonStr =  JSON.stringify(vars);
	YM.post("savePickUp.do", {resourceId: ${resourceBo.po.id}, orderId: ${bo.po.groupOrderId}, data:jsonStr}, function(){
		$.success("操作成功");
	});
}

</script>

</body>
</html>
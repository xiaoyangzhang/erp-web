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
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
<script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
<script type="text/javascript">
var ticketPrice="${resourceBo.price }";
function showResourceList(){
	$("#divSelectResource").css({display:"block"});
	$("#divShowResource").css({display:"none"});
	resourceFilter();
}
function cancelSelectResource(resourceId){
	$("#divSelectResource").css({display:"none"});
	$("#divShowResource").css({display:"block"});
}
function selectResource(resourceId, resourceNumber){
	$("input[name='resourceId']").val(resourceId);
	$("input[name='resourceNumber']").val(resourceNumber);
	$("#divSelectResource").css({display:"none"});
	$("#divShowResource").css({display:"block"});
	$.get("resourceInfo.htm?id="+resourceId, function(data){
		$("#air_info tbody").html(data);
		setDefaultPrice(); // 重新选择了机票资源，要刷新下边的价格为新资源的默认价格。
	});
}
function resourceFilter(){
	 var vars = getQueryFilter();
	 if (!vars.date_from && !vars.date_to){
		 vars.date_from = $.currentMonthFirstDay();
		 vars.date_to = $.currentMonthLastDay();
		 vars.date_type="start";
		 $("input[name='date_from']").val(vars.date_from);
		 $("input[name='date_to']").val(vars.date_to);
	 }
	 vars["ajax"]=1;
	 $.get("../resource/list.htm" + $.makeUrlFromVars(vars), function(data){
		 $("#divResourceList").html(data);
	 });
}
function getQueryFilter(){
	var vars = [];
	 var resource_number = $("input[name='resource_number']").val();
	 var date_from = $("input[name='date_from']").val();
	 var date_to = $("input[name='date_to']").val();
	 var dep_city = $("input[name='dep_city']").val();
	 var line_name = $("input[name='line_name']").val();
	 var endIssueDateFrom = $("input[name='endIssueDateFrom']").val();
	 var endIssueDateTo = $("input[name='endIssueDateTo']").val();
	 if (resource_number){vars["resource_number"]=resource_number;}
	 if (date_from){
		 vars["date_type"]=$("#filterDateType").val();
		 vars["date_from"]=date_from;
	 }
	 if (date_to){
		 vars["date_type"]=$("#filterDateType").val();
		 vars["date_to"]=date_to;
	 }
	 if (endIssueDateFrom){vars["endIssueDateFrom"]=endIssueDateFrom;}
	 if (endIssueDateTo){vars["endIssueDateTo"]=endIssueDateTo;}
	 if (dep_city){vars["dep_city"]=dep_city;}
	 if (line_name){vars["line_name"]=line_name;}
	 return vars;
}
function resourceQueryList(p, ps){ // pagination: p=page number; ps= page size
	var vars = getQueryFilter();
 	vars["p"] = p; vars["ps"] = ps; vars["ajax"]=1;
	 $.get("../resource/list.htm" + $.makeUrlFromVars(vars), function(data){
		 $("#divResourceList").html(data);
	 });
 }
</script>
<style>
.searchRow li.text {text-align: right;margin-right: 10px; }
.searchRow li input{width:90px;}
 .air_ticket_leg {width:100%; min-width:248px;}
 .air_ticket_leg td {padding:0 3px 0 3px;}
</style>
</head>
<body>
<div class="p_container" >
   <input type="hidden" name="id" value="${bo.id }"/>
   <!-- 选择机票资源 -->
   <div class="p_container_sub" id="resourceList">
   	<p class="p_paragraph_title"><b>机票信息</b></p>
   	<input name="resourceId" type="hidden" value="${bo.resourceId }"/>
   	<input name="resourceNumber" type="hidden" value="${bo.resourceNumber }"/>
   	<div id="divShowResource">
   		<a href="javascript:showResourceList();" class="button button-primary button-small">选择机票资源</a>
		<table cellspacing="1" cellpadding="1" class="w_table1" id="air_info">
		<thead>
		<tr>
			<th>航线</th>
			<th>行程开始日期</th>
			<th>航段</th>
			<th>机票供应商</th>
			<th>票价（含机建\燃油）</th>
			<th>可用票数</th>
			<th>最晚出票</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${resourceBo!=null}">
		<tr style="height:80px;">
			<td>${resourceBo.po.lineName }</td>
			<td><fmt:formatDate value="${resourceBo.po.startDate}" pattern="yyyy-MM-dd" /></td>
			<td>${resourceBo.legHtml }</td>
			<td>${resourceBo.ticketSupplier }</td>
			<td>${resourceBo.price }</td>
			<td>${resourceBo.po.availableNumber }</td>
			<td><fmt:formatDate value="${resourceBo.po.endIssueTime}" pattern="yyyy-MM-dd HH:mm" /></td>
		</tr>
		</c:if>
		</tbody>
		</table>
	</div>
	<div id="divSelectResource" style="display:none;">
		<a id="" href="javascript:cancelSelectResource();" class="button button-primary button-small">取消</a>
		<div class="searchRow">
		<form id="searchResourceForm">
		<ul>
			<li class="text" style="width:115px;">
			<select id="filterDateType" style="width:105px;"><option value="start">开始日期:</option>
					<option value="dep">航班日期:</option></select></li>
			<li><input name="date_from" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
				value="${page.parameter.depDateFrom }"/>—
				<input name="date_to" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
				value="${page.parameter.depDateTo }"/>
			</li><li class="seperator"></li>
			<li class="text">采购单号：</li>
			<li><input name="resource_number" type="text" value="${page.parameter.resourceNumber }"/></li>
			<li class="seperator">
			<li class="text">航线名称：</li>
			<li><input name="line_name" type="text" value="${page.parameter.lineName }"/></li><li class="seperator">
			<li class="text">出发地：</li>
			<li><input name="dep_city" type="text" value="${page.parameter.depCity }"/></li><li class="seperator">
			<li class="text" style="width:100px;">最晚出票日期：</li>
				<li><input name="endIssueDateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateFrom }"/>—
					<input name="endIssueDateTo" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateTo }"/><li class="seperator">
			<li style="margin-left:20px;">
				<a href="javascript:resourceFilter();" class="button button-primary button-small">查询</a>
			</li>
			<li class="clear"></li>
		</ul>
		</form>
		</div>
		<div id="divResourceList"></div>
	</div>
   </div>
  <!-- 选择机票资源 END -->




<!-- 选择组团订单 -->
<div class="p_container_sub">
   	<p class="p_paragraph_title"><b>订单信息</b></p>
<script>
function groupFilter(){
	var vars=YM.getFormData("searchGroupOrderForm");
	 if (!vars.dateFrom && !vars.dateTo){
		 vars.dateFrom = monthFirstDay();
		 vars.dateTo = monthLastDay();
		 $("input[name='dateFrom']").val(vars.dateFrom);
		 $("input[name='dateTo']").val(vars.dateTo);
	 }

	$.get("showGroupOrder.htm"+ $.makeUrlFromVars(vars), function(data){
		 $("#divGroupOrderList").html(data);
	});
}
function groupQueryList(p, ps){
	var vars = YM.getFormData("searchGroupOrderForm");
 	vars["p"] = p; vars["ps"] = ps; vars["ajax"]=1;
	 $.get("showGroupOrder.htm" + $.makeUrlFromVars(vars), function(data){
		 $("#divGroupOrderList").html(data);
	 });
}
function showGroupOrderList(){
	$("#divSelectGroupOrder").css({display:"block"});
	$("#divShowGroupOrder").css({display:"none"});
	//$.get("showGroupOrder.htm", function(data){$("#divGroupOrderList").html(data);});
	groupFilter();
}
function cancelSelectGroupOrder(){
	$("#divSelectGroupOrder").css({display:"none"});
	$("#divShowGroupOrder").css({display:"block"});
}
function selectGroupOrder(id){
	$("input[name='groupOrderId']").val(id);
	$("#divSelectGroupOrder").css({display:"none"});
	$("#divShowGroupOrder").css({display:"block"});
	$.get("groupOrderInfo.htm?id="+id, function(data){
		$("#group_order_info tbody").html(data);
	});
	refreshGuestList(id);
}
</script>
   	<input name="groupOrderId" type="hidden" value="${bo.groupOrderId }"/>
   	<div id="divShowGroupOrder">
   	<a href="javascript:showGroupOrderList();" class="button button-primary button-small">选择组团订单</a>
   	<form id="formGroupFilter">
		<table cellspacing="1" cellpadding="1" class="w_table1" id="group_order_info">
		<thead>
		<tr>
			<th>订单号</th>
			<th>开始日期</th>
			<th>产品名称</th>
			<th>组团社</th>
			<th>接站牌</th>
			<th>订单人数</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${bo!=null }">
		<tr style="height:80px;">
			<td>${bo.groupOrder.orderNo }</td>
			<td>${bo.groupOrder.departureDate }</td>
			<td>${bo.groupOrder.productName }</td>
			<td>${bo.groupOrder.supplierName }</td>
			<td>${bo.groupOrder.receiveMode }</td>
			<td>${bo.groupGuestNumber }</td>
		</tr>
		</c:if>
		</tbody>
		</table>
	</form>
	</div>
	<div id="divSelectGroupOrder" style="display:none;">
			<a id="" href="javascript:cancelSelectGroupOrder();" class="button button-primary button-small">取消</a>
		<div class="searchRow">
		<form id="searchGroupOrderForm">
			<ul>
				<li>出发日期：</li><li><input name="dateFrom" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
				—— <input name="dateTo" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/></li>
				<li class="text">申请状态：</li><li><select name="airApplyState"><option></option>
					<option value="N" selected="true">未申请</option><option value="Y">已申请</option></select></li>
				<li class="text">订单号：</li><li><input name="orderNo" type="text"/></li>
				<li class="text">产品：</li><li><input name="productName" type="text"/></li>
				<li class="text">接站牌：</li><li><input name="receiveMode" type="text"/></li>
				<li style="margin-left:20px;">
					<a href="javascript:groupFilter();" class="button button-primary button-small">查询</a>
				</li>
				<li class="clear"></li>
			</ul>
		</form>
		</div>
		<div id="divGroupOrderList"></div>
	</div>
	
</div>  <!-- 选择组团订单 END -->





<!-- 选择游客 -->
	<div class="p_container_sub">
<script>
$("document").ready(function(){
	guestIds = [${bo.guestIds }];
	$("input[name='chkGuest']").val(guestIds);
	for(i=0; i<guestIds.length; i++){
		$("#guest_list #guest"+guestIds[i]).addClass("selected");
	}
	initListener();
});

flagCheckingAll = false;
function initListener(){
	$("input[name='chkGuestAll']").change(function(){
		chkAll = $("input[name='chkGuestAll']").attr("checked");
		if (typeof(chkAll)=="undefined"){chkAll=false;}
		$("input[name='chkGuest']").each(function(){
			curCheck = $(this).attr("checked");
			if (typeof(curCheck)=="undefined") {curCheck=false;}
			if (curCheck!=chkAll){
				$(this).attr("checked", chkAll);
				$(this).trigger('change');
			}
		});
	});
	$("input[name='chkGuest']").each(function(){$(this).change(function(){
		guestCheckChange($(this).val());
		if (!$(this).attr("checked")){
			$("input[name='chkGuestAll']").attr("checked", false);
		}
	})});
}
function guestCheckChange(guestId){
	if ($("#trGuest"+guestId+" input[name=chkGuest]").is(":checked")){
		$("#trGuest"+guestId + " #price").text(ticketPrice);
		$("#trGuest"+guestId + " #comment").after('<a href="javascript:changeComment('+guestId+');">备注</a>');
	}else {
		$("#trGuest"+guestId + " #price").text("");
		$("#trGuest"+guestId + " a").remove();
	}
}
function refreshGuestList(groupOrderId){
	$.get("groupOrderGuest.htm?id="+groupOrderId, function(data){
		$("#guest_list tbody").html(data);
		initListener();
	});
}
function setDefaultPrice(){
	$("input[name='chkGuest']:checked").each(function(){
		guestId = $(this).val();
		$("#trGuest"+guestId + " #price").text(ticketPrice);
	});
}
function changePrice(guestId){
	$('#guestPrice input').val($("#trGuest"+guestId + " #price").text());
	layer.open({
		type : 1, title : '修改价格', closeBtn : false,
		area : [ '260px', '130px' ], shadeClose : false,
		content : $('#guestPrice'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			var price=$('#guestPrice input').val();
			$("#trGuest"+guestId + " #price").text(price);
			layer.close(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}
function changeComment(guestId){
	$('#guestComment textarea').val($("#trGuest"+guestId + " #comment").text());
	layer.open({
		type : 1, title : '修改备注（最多50字）', closeBtn : false,
		area : [ '320px', '170px' ], shadeClose : false,
		content : $('#guestComment'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			comment=$('#guestComment textarea').val();
			$("#trGuest"+guestId + " #comment").text(comment);
			layer.close(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}
</script>
   	<p class="p_paragraph_title"><b>游客信息</b></p>
<div id="guestPrice" style="display:none;"><input type="text" size="30" style="margin: 8px 20px 0 20px; align:center; text-align:right;"/></div>
<div id="guestComment" style="display:none;"><textarea style="margin: 8px 20px 0 20px; width:270px; height:66px;" maxlength="50"></textarea></div>

		<table cellspacing="1" cellpadding="1" class="w_table1" id="guest_list">
		<thead>
		<tr>
			<th width="5%"><input type="checkbox" name="chkGuestAll"/><i class="w_table_split"></i></th>
			<th width="15%">游客姓名<i class="w_table_split"></i></th>
			<th width="10%">身份证号<i class="w_table_split"></i></th>
			<th width="10%">联系方式<i class="w_table_split"></i></th>
			<th width="15%">组团备注<i class="w_table_split"></i></th>
			<th width="10%">价格<i class="w_table_split"></i></th>
			<th width="20%">订票备注<i class="w_table_split"></i></th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${guests }" var="guest" varStatus="status">
		<tr style="height:30px;" id="trGuest${guest.id }">
			<td><input type="checkbox" name="chkGuest" id="chkGuest${guest.id }" value="${guest.id }"></input></td>
			<td>${guest.name }</td>
			<td>${guest.certificateNum }</td>
			<td>${guest.mobile }</td>
			<td>${guest.remark }</td>
			<td><span id="price"><c:if test="${bo.orderMap[guest.id]!=null}">${bo.orderMap[guest.id].price}</c:if></span></td>
			<td><span id="comment"><c:if test="${bo.orderMap[guest.id]!=null}">${bo.orderMap[guest.id].comment}</c:if></span>
				<c:if test="${bo.orderMap[guest.id]!=null}"><a href="javascript:changeComment(${guest.id });">备注</a></c:if></td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
   </div>
<!-- 选择游客 END -->

<script>
function submitRequest(){
	var id = $("input[name='id']").val();
	var resourceId = $("input[name='resourceId']").val();
	var groupOrderId = $("input[name='groupOrderId']").val();
	var guestIds = [];
	$("input[name='chkGuest']:checked").each(function(){guestIds.push($(this).val());});
	if (!resourceId){alert("请选择一个机票资源"); return false;}
	if (!groupOrderId){alert("请选择一个订单"); return false;}
	if (guestIds.length==0){alert("请选择至少一个游客"); return false;}
	orderList = new Array();
	for(i=0; i<guestIds.length;i++){
		var tmpPrice = $("#trGuest"+guestIds[i]+" #price").text();
		var tmpComment = $("#trGuest"+guestIds[i]+" #comment").text();
		var orderInfo = {"guestId":guestIds[i], "price":$.trim(tmpPrice), "comment":$.trim(tmpComment)};
		orderList.push(orderInfo);
	}
	var jsonOrders = JSON.stringify(orderList);
	var param={
			"resourceId": resourceId,
			"resourceNumber": $("input[name='resourceNumber']").val(),
			"groupOrderId": groupOrderId,
			"jsonOrders" : jsonOrders
	};
	if (id){param["id"]=id;}
	YM.post("save.do", param, function(){
		$.success("操作成功");
		 window.setTimeout(function(){
		   <c:choose>
			 <c:when test="${bo!=null}">
			 refreshWindow("机票申请${bo.groupOrder.orderNo }", "<%=path%>/airticket/request/edit.htm?id=${bo.id }");
			 </c:when>
			 <c:otherwise>
			 refreshWindow("新增机票申请", "<%=path%>/airticket/request/add.htm");
			 </c:otherwise>
		   </c:choose>
		 }, 1000);
	});
}
</script>

	    <button  type="button" onclick="submitRequest();" class="button button-action button-small" >提交申请</button>
	    <button  type="button" onclick="javascript:closeWindow();" class="button button-small" >关闭</button>
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>
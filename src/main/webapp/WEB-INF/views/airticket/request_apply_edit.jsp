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
<style>tr.selected{background-color:#DDF9A9!important;}
.air_ticket_leg tbody tr:nth-child(even){background-color:transparent!important;}
 button.disable{ background-color:#d7d7d7!important; color:#f0f0f0!important; }
</style>
<script type="text/javascript">
var ticketPrice;

function selectResource(resourceId, resourceNumber, price){
	$("input[name='resourceId']").val(resourceId);
	$("input[name='resourceNumber']").val(resourceNumber);
	$("#divResourceList tr").removeClass("selected");
	$("#divResourceList #tr_"+resourceId).addClass("selected");
	$("#radio_"+resourceId).attr("checked", "checked");
	ticketPrice = price;
	$("#guest_list #price").html(ticketPrice);
	/*$.get("resourceInfo.htm?id="+resourceId, function(data){
		$("#air_info tbody").html(data);
		setDefaultPrice(); // 重新选择了机票资源，要刷新下边的价格为新资源的默认价格。
	});*/
}
function resourceFilter(){
	 $("#divResourceList").html("加载中...");
	 var vars = getQueryFilter();
	 if (!vars.date_from && !vars.date_to){
		 vars.date_from = $.currentMonthFirstDay();
		 vars.date_to = $.currentMonthLastDay();;
		 vars.date_type="start";
		 $("input[name='date_from']").val(vars.date_from);
		 $("input[name='date_to']").val(vars.date_to);
	 }
	 vars["ajax"]=1; vars["apply"]=1;
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
	 var type = $("select[name='type']").val();
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
	 if (type){vars['type']=type;}
	 return vars;
}
function resourceQueryList(p, ps){ // pagination: p=page number; ps= page size
	var vars = getQueryFilter();
 	vars["p"] = p; vars["ps"] = ps; vars["ajax"]=1;vars["apply"]=1;
	 $.get("../resource/list.htm" + $.makeUrlFromVars(vars), function(data){
		 $("#divResourceList").html(data);
	 });
 }
$(function(){
	resourceFilter();
})
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
   <input type="hidden" name="id"/>
   <!-- 选择机票资源 -->
   <div class="p_container_sub" id="resourceList">
   	<p class="p_paragraph_title"><b>机票信息</b></p>
  
	<div id="divSelectResource" >
		<div class="searchRow">
		<form id="searchResourceForm">
		<ul>
			<li class="text" style="width:115px;">
			<select id="filterDateType" style="width:105px;"><option value="start">开始日期:</option>
					<option value="dep">航班日期:</option></select></li>
			<li><input name="date_from" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> - 
				<input name="date_to" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
			</li><li class="seperator"></li>
			<li class="text">采购单号：</li>
			<li><input name="resource_number" type="text" /></li>
			<li class="seperator">
			<li class="text">航线名称：</li>
			<li><input name="line_name" type="text"/></li><li class="seperator">
			<li class="text">出发地：</li>
			<li><input name="dep_city" type="text"/></li><li class="seperator">
			<li class="text" style="width:100px;">最晚出票日期：</li>
				<li><input name="endIssueDateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> -
					<input name="endIssueDateTo" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/><li class="seperator">
			<li class="text" style="width:100px;">资源类型：</li>
				<li><select name="type"><option value="">全部</option><option value="AIR">机票</option><option value="TRAIN">火车票</option></select><li class="seperator">
			
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
   	<input name="groupOrderId" type="hidden" value="${order.id }"/>
   	<div id="divShowGroupOrder">
   	<form id="formGroupFilter">
		<table class="w_table" id="group_order_info">
		<thead>
		<tr>
			<th>订单号</th>
			<th>开始日期</th>
			<th>产品名称</th>
			<th>组团社</th>
			<th>接站牌</th>
			<th>订单人数</th>
			<th>销售</th>
		</tr>
		</thead>
		<tbody>
		<c:if test="${order!=null }">
		<tr style="">
			<td>${order.orderNo }</td>
			<td>${order.departureDate }</td>
			<td>${order.productName }</td>
			<td>${order.supplierName }</td>
			<td>${order.receiveMode }</td>
			<td>${order.numAdult}大${order.numChild}小${order.numGuide}陪</td>
			<td>${order.saleOperatorName}</td>
		</tr>
		</c:if>
		</tbody>
		</table>
	</form>
	</div>
	
</div>  <!-- 选择组团订单 END -->





<!-- 选择游客 -->
	<div class="p_container_sub">
<script>
$("document").ready(function(){
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

		<table class="w_table" id="guest_list">
		<thead>
		<tr>
			<th width="50"><input type="checkbox" name="chkGuestAll" checked="checked"/><i class="w_table_split"></i></th>
			<th width="100">游客姓名<i class="w_table_split"></i></th>
			<th width="150">身份证号<i class="w_table_split"></i></th>
			<th width="100">联系方式<i class="w_table_split"></i></th>
			<th width="100">组团备注<i class="w_table_split"></i></th>
			<th width="100">价格<i class="w_table_split"></i></th>
			<th width="100">订票备注<i class="w_table_split"></i></th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${guestList }" var="guest" varStatus="status">
		<tr style="height:30px;" id="trGuest${guest.id }">
			<td><input type="checkbox" name="chkGuest" id="chkGuest${guest.id }" value="${guest.id }" checked="checked"/></td>
			<td>${guest.name }</td>
			<td>${guest.certificateNum }</td>
			<td>${guest.mobile }</td>
			<td>${guest.remark }</td>
			<td><span id="price"></span></td> 
			<td><span id="comment"></span><a href="javascript:changeComment(${guest.id });">备注</a></td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
   </div>
<!-- 选择游客 END -->

<script>
var isSubmited=false;
function submitDisable(){
	$("#submitRequest").addClass("disable");
	isSubmited=true;
}
function submitEnable(){
	$("#submitRequest").removeClass("disable");
	isSubmited=false;
}
function submitRequest(){
	if (isSubmited){return;}
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
	submitDisable();// 防止二次提交
	YM.post("save.do", param, function(){
		$.success("操作成功");
		 window.setTimeout(function(){
		   <c:choose>
			 <c:when test="${bo!=null}">
			 refreshWindow("机票申请${order.orderNo }", "<%=path%>/airticket/request/edit.htm?id=${bo.id }");
			 </c:when>
			 <c:otherwise>
			 refreshWindow("查看机票申请${order.orderNo }", "<%=path%>/airticket/request/applyEdit.htm?orderId=${order.id}");
			 </c:otherwise>
		   </c:choose>
		 }, 1000);
	},
	function(){submitEnable();});
}
</script>

	    <button  type="button" id="submitRequest" onclick="submitRequest();" class="button button-action button-small" >提交申请</button>
	    <button  type="button" onclick="javascript:closeWindow();" class="button button-small" >关闭</button>
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>
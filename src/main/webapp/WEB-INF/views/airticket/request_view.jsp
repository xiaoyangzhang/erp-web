<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<% String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
<script type="text/javascript">
function changeAllPrice(orderIds){
	firstGuestId=$("input[name='ckbGuest']:checked").val();
	$('#guestPrice input').val($("#guest"+firstGuestId + " #price").text());
	layer.open({
		type : 1,
		title : '修改价格',
		closeBtn : false,
		area : [ '260px', '130px' ],
		shadeClose : false,
		content : $('#guestPrice'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			price=$('#guestPrice input').val();
			YM.post("changePrices.do",{"orderIds":orderIds, "price":price}, function(){
				layer.close(index);
				$.success("执行成功");
				window.setTimeout(function(){
					 window.location.href="<%=path%>/airticket/request/${arrange}view.htm?id=${bo.id }";
				 }, 1000);
			});
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}
function changePrice(guestId, orderId){
	$('#guestPrice input').val($("#guest"+guestId + " #price").text());
	layer.open({
		type : 1,
		title : '修改价格',
		closeBtn : false,
		area : [ '260px', '130px' ],
		shadeClose : false,
		content : $('#guestPrice'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			price=$('#guestPrice input').val();
			YM.post("changePrice.do",{"orderId":orderId, "price":price}, function(){
				layer.close(index);
				$.success("执行成功");
				$("#guest"+guestId + " #price").text(price);
			});
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}
function changeComment(guestId, orderId){
	$('#guestComment textarea').val($("#guest"+guestId + " #comment").text());
	layer.open({
		type : 1,
		title : '修改备注（最多50字）',
		closeBtn : false,
		area : [ '320px', '170px' ],
		shadeClose : false,
		content : $('#guestComment'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			comment=$('#guestComment textarea').val();
			YM.post("changeGuestComment.do",{"orderId":orderId, "comment":comment}, function(){
				layer.close(index);
				$.success("执行成功");
				$("#guest"+guestId + " #comment").text(comment);
			});
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}
</script>
<style>
 .air_ticket_leg {width:100%; min-width:248px;}
 .air_ticket_leg td {padding:0 3px 0 3px;}
</style>
</head>
<body>
<div id="guestPrice" style="display:none;"><input type="text" size="30" style="margin: 8px 20px 0 20px; align:center; text-align:right;"/></div>
<div id="guestComment" style="display:none;"><textarea style="margin: 8px 20px 0 20px; width:270px; height:66px;" maxlength="50"></textarea></div>

<div class="p_container">
   <div class="p_container_sub">
   	<p class="p_paragraph_title"><b>机票信息</b></p>
		<table class="w_table" id="air_info">
		<thead>
		<tr>
			<th width="100">采购单号<i class="w_table_split"></i></th>
      		<th width="100">行程开始日期<i class="w_table_split"></i></th>
      		<th width="150">航线<i class="w_table_split"></i></th>
      		<th width="280">航段<i class="w_table_split"></i></th>
      		<th width="50">票数<i class="w_table_split"></i></th>
      		<th width="50">已申请<i class="w_table_split"></i></th>
      		<th width="50">剩余<i class="w_table_split"></i></th>
      		<th width="70">单价<i class="w_table_split"></i></th>
      		<th width="80">最晚出票<i class="w_table_split"></i></th>
      		<th width="80">备注<i class="w_table_split"></i></th>
		</tr>
		</thead>
		<tbody>
		<tr style="height:50px;">
			<td>${resourceBo.resourceNumber }</td>
            <td>${resourceBo.startDate }</td>
            <td>${resourceBo.po.lineName }</td>
            <td>${resourceBo.legHtml }</td>
            <td>${resourceBo.po.totalNumber }</td>
            <td>${resourceBo.po.appliedNumber }</td>
            <td>${resourceBo.po.availableNumber }</td>
            <td>${resourceBo.price }</td>
            <td>${resourceBo.endIssueTime}</td>
            <td><pre>${resourceBo.comment}</pre></td>
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
	<script>
	$("document").ready(function(){
		guestIds = [${bo.guestIds}];
		$("input[name='ckbGuest']").val(guestIds);
		for(i=0; i<guestIds.length; i++){
			$("#guest_list #guest"+guestIds[i]).addClass("selected");
		}
	});
	function goBookingSupplier(groupId, orderId, bookingId){
// 		if (!groupId){alert("这是散客订单，请等并团后再改价。");return ;}
		$.getJSON("checkBookingSupplier.do?bookingId="+bookingId, function(ret){
			if (ret.exists){
				if(ret.supplierType == 9){
					newWindow('修改机票订单', '<%=path%>/booking/toAddAirTicket?groupId='+groupId+'&bookingId='+bookingId+'&orderId='+orderId);	
				}else if(ret.supplierType == 10){
					newWindow('修改火车票订单','<%=path%>/booking/toAddTrainTicket?groupId='+groupId+'&bookingId='+bookingId);
				}
			}else {
				$.error('订单已被删除.');
			}
		});
		
	}
	</script>
	<style>
	#guest_list td{height:30px;}
	#guest_list .selected td{background-color:SILVER;}
	</style>
   	<p class="p_paragraph_title"><b>游客信息</b></p>
		<table cellspacing="1" cellpadding="1" class="w_table" id="guest_list">
		<thead>
		<tr>
			<th width="5%">&nbsp;<i class="w_table_split"></i></th>
			<th width="15%">游客姓名<i class="w_table_split"></i></th>
			<th width="10%">身份证号<i class="w_table_split"></i></th>
			<th width="10%">联系方式<i class="w_table_split"></i></th>
			<th width="15%">组团备注<i class="w_table_split"></i></th>
			<th width="10%">价格 
			 	<c:if test="${isArrange and (bo.po.status!='ISSUED')}">
				<a href="javascript:changeAllPrice('${bo.orderIds}');">改价</a></c:if>
				<i class="w_table_split"></i></th>
			<th width="20%">订票备注<i class="w_table_split"></i></th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${guests }" var="guest" varStatus="status">
		<tr id="guest${guest.id }">
			<td><input type="checkbox" name="ckbGuest" disabled="disabled" value="${guest.id }"></input></td>
			<td>${guest.name }</td>
			<td>${guest.certificateNum }</td>
			<td>${guest.mobile }</td>
			<td>${guest.remark }</td>
			<td><c:if test="${bo.orderMap[guest.id]!=null}">
				<span id="price">${bo.orderMap[guest.id].price}</span>
				<c:if test="${isArrange and (bo.po.status!='ISSUED')}">
				<a href="javascript:changePrice(${guest.id }, ${bo.orderMap[guest.id].id});">改价</a></c:if>
				</c:if></td>
			<td><c:if test="${bo.orderMap[guest.id]!=null}">
				<span id="comment">${bo.orderMap[guest.id].comment}</span>
				<c:if test="${isArrange }">
				<a href="javascript:changeComment(${guest.id }, ${bo.orderMap[guest.id].id});">改备注</a></c:if>
				</c:if></td>
		</tr>
		</c:forEach>
		</tbody>
		</table>
	<c:if test="${isArrange and (bo.po.status=='ISSUED')}">
		<c:if test="${stateFinance !=1}">
			<p style="padding:3px 2px 3px 2px;"><a href="javascript:goBookingSupplier(${bo.groupOrder.groupId==null?0:bo.groupOrder.groupId},${bo.po.groupOrderId}, ${bo.po.bookingSupplierId});">修改计调订单</a></p>
		</c:if>
		<c:if test="${stateFinance ==1}">
			<p style="padding:3px 2px 3px 2px;">该计调订单已被审核！</p>
		</c:if>	</c:if>
   </div>
   
   
   
<div class="p_container_sub">
  <p class="p_paragraph_title"><b>备注</b></p>
  <textarea disabled="disabled" style="width:600px; height:150px; margin:2px 15px 2px 15px;">${bo.comment }</textarea>
</div>
</div><!--  end of p_container -->
<c:if test="${confirm!=null}">
<script>
function confirmRequest(id){
	if (!confirm("确认以上订单的机票申请吗？")){
		return false;
	}
	YM.post("confirm.do",{"id":id}, function(){
		 $.success("执行成功");
		 window.setTimeout(function(){
			 //window.location.href="list.htm";
			 refreshWindow("核对机票申请${bo.groupOrder.orderNo}", "<%=path%>/airticket/request/view.htm?id=${bo.id }");
		 }, 1000);
	});
}
</script>
    <button  type="button" onclick="confirmRequest(${bo.id });" class="button button-primary button-small">确认</button>
</c:if>
    <a href="javascript:closeWindow();" class="button button-small" >关闭</a>

<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>
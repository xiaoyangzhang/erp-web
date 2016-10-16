<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<% String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>机票资源申请</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
<script src="<%=staticPath %>/assets/js/jquery-ui/jquery.tooltip.js"></script>
<style>
.searchRow li.text {text-align: right;margin-right: 10px; }
.searchRow li input{width:90px;}
 .air_ticket_leg {width:100%; min-width:248px;}
 .air_ticket_leg td {padding:0 3px 0 3px;}
 a.lineName {background: #DCDCDC;    color: black; text-decoration: none;}
</style>
</head>
<body>
<div class="p_container" >
<div id="action_confirm" style="display:none; padding:5px 5px 5px 5px;">
<p style="line-height:20px;">添加说明：（选填）</p>
<textarea name="comment" rows="5" cols="60"></textarea>
</div>	
<script>
var firstView = true;
function groupFilter(){
	var vars=YM.getFormData("searchGroupOrderForm");
	if (!vars.dateFrom && !vars.dateTo && firstView){
		 vars.dateFrom = $.currentMonthFirstDay();
		 vars.dateTo = $.currentMonthLastDay();
		 $("input[name='dateFrom']").val(vars.dateFrom);
		 $("input[name='dateTo']").val(vars.dateTo);
		 firstView=false;
	}
	$("#divGroupOrderList").html("<p>加载中...</p>");
	$.post("applyList.do", vars, function(data){
		$("#divGroupOrderList").html(data);
	});
}
function groupQueryList(p, ps){
	var vars = YM.getFormData("searchGroupOrderForm");
 	vars["p"] = p; vars["ps"] = ps; vars["ajax"]=1;
 	$.post("applyList.do", vars, function(data){
		$("#divGroupOrderList").html(data);
	});
}
$(function(){
	groupFilter();
});

function toConfirm(id, groupCode){
	newWindow("核对机票申请", "<%=path%>/airticket/request/view.htm?confirm=1&id="+id);
}
function refreshPage(){
	groupFilter();
}
function doAction(action, id){
	layer.open({
		type : 1,
		title : '确认执行',
		closeBtn : false,
		area : [ '400px', '190px' ],
		shadeClose : false,
		content : $('#action_confirm'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			comment=$("#action_confirm textarea[name='comment']").val();
			YM.post(action,{"id":id, "comment":comment}, function(){
				layer.close(index);
				$.success("执行成功");
				window.setTimeout(function(){
				  refreshPage();
				}, 1000);
			});
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

</script>
	<div id="divSelectGroupOrder" class="p_container_sub" >
		<div class="searchRow">
		<form id="searchGroupOrderForm">
		<dd class="inl-bl">
		<div class="dd_left">出发日期：</div>
		<div class="dd_right grey">
			<input name="dateFrom" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
			- <input name="dateTo" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
			</div>
		</dd>
		<dd class="inl-bl"><div class="dd_left">申请状态：</div>
		<div class="dd_right grey">
			<select name="airApplyState"><option value=""></option>
			<option value="N">未申请</option><option value="Y">已申请</option></select></div></dd>
		<dd class="inl-bl"><div class="dd_left">订单号：</div>
		<div class="dd_right grey"><input name="orderNo" type="text" style="width:90px;"/></div></dd>
		<dd class="inl-bl"><div class="dd_left">产品：</div>
		<div class="dd_right grey"><input name="productName" type="text" style="width:90px;"/></div></dd>
		<dd class="inl-bl"><div class="dd_left">接站牌：</div>
		<div class="dd_right grey"><input name="receiveMode" type="text" style="width:90px;"/></div></dd>
   		<dd class="inl-bl"><div class="dd_right" style="padding-left:10px;">部门:
 				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" style="width:90px;"/>
				<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/></div>
		<div class="dd_right" style="padding-left:10px;">销售:
	    		<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()" style="width:90px;"/>
				<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/></div></dd>
		<dd class="inl-bl"><div class="dd_left">出票状态：</div>
			<div class="dd_right" style="padding-left:10px;">
				<select name="issueStatus">
				<option></option><option value="ARRANGING">待安排</option>
				<option value="CONFIRMING">待确认</option>
				<option value="REJECTED">退回</option>
				<option value="ISSUING">待出票</option>
				<option value="ISSUED">已出票</option></select></div></dd>
		<dd class="inl-bl"><div class="dd_right" style="padding-left:10px;">
				<a href="javascript:groupFilter();" class="button button-primary button-small">查询</a></div></dd>
		
		<div class="clear"></div>
		</form>
		</div>
	</div>
<div id="divGroupOrderList"></div>

</div>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</body>
</html>
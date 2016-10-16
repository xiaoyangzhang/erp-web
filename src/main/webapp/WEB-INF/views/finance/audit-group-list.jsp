<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团收支审核</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />

<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css" />
<style type="text/css">
	h2{color:red;}
	.p_paragraph_content label{display:inline-block;width:60px;}
</style>
<script type="text/javascript" src="<%=staticPath%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">

var groupId = "${reqpm.groupId}";
var sup = [];
<c:forEach items="${sup }" var="s" varStatus="status">
	sup.push({"index":"${status.index}", "id": "${s.id}", "name": "${s.name}"});
</c:forEach>

function checkAll(ckbox) {
	
	var table = $(ckbox).parent().parent().parent().parent();
	if ($(ckbox).attr("checked")) {
		$(table).find("input[name='audit_id']").each(function(){
			if($(this).attr('disabled') != 'disabled'){
				$(this).attr('checked', 'checked');		
			}	
		});
	} else {
		$(table).find("input[name='audit_id']").each(function(){
			if($(this).attr('disabled') != 'disabled'){
				$(this).removeAttr("checked");
			}	
		});
	}
}

function checkAllCommission(ckbox) {
	
	var table = $(ckbox).parent().parent().parent().parent();
	if ($(ckbox).attr("checked")) {
		$(table).find("input[name='commission_id']").attr('checked', 'checked');
	} else {
		$(table).find("input[name='commission_id']").removeAttr("checked");
	}
}

function getFinanceGuide(obj){
	
	var finangeGuide = [];
	
	var bookingId = $(obj).parent().parent().find("select[name='bookingId']");
	if(bookingId.length > 0 && !bookingId.attr("disabled")){
		var financeTotal = $(obj).parent().parent().find("input[name='financeTotal']");
		var supplierType = $(obj).parent().parent().find("input[name='supplierType']");
		var groupId = $(obj).parent().parent().find("input[name='groupId']");
		var cashType = $(obj).parent().parent().find("select[name='cashType']");
		finangeGuide.push('"groupId":'+ $(groupId).val());
		finangeGuide.push('"bookingId":"'+ $(bookingId).val() +'"');
		finangeGuide.push('"bookingIdLink":'+ $(obj).val());
		finangeGuide.push('"cashType":"'+ $(cashType).val() +'"');
		finangeGuide.push('"supplierType":'+ $(supplierType).val());
		finangeGuide.push('"total":'+ $(financeTotal).val());	
	}
	if(finangeGuide.length > 0){
		return '{'+ finangeGuide.join(",") +'}';	
	}else{
		return null;
	}
}

function postAudit() {
	
	var typeList = [];
	typeList.push({"feeType":"order", "divId": "order"});
	typeList.push({"feeType":"otherin", "divId": "otherin"});
	typeList.push({"feeType":"del", "divId": "del"});
	
	for(var i = 0; i < sup.length; i++){
		typeList.push({"feeType":"sup", "divId": "sup"+ sup[i].index});
	}
	
	var financeGuideArr = [];
	var list = [];
	for(var i = 0; i < typeList.length; i++){
		var item = typeList[i];
		
		var checkedArr = [];
		var unCheckedArr = [];
		
		var inputName = "audit_id";
		if(item.feeType == "comm"){
			inputName = "commission_id";
		}
		$("#"+ item.divId + " input[name='"+ inputName +"']").each(function(i, o) {
			if ($(o).attr("checked")) {
				checkedArr.push($(o).val());
			} else {
				unCheckedArr.push($(o).val());
			}
			var financeGuide = getFinanceGuide(o);
			if(financeGuide){
				financeGuideArr.push(financeGuide);	
			}
		});	
		
		if(item.feeType == "order"){
			inputName = "audit_price_id";
		}
		var priceCheckedArr = [];
		var priceUnCheckedArr = [];
		$("#"+ item.divId + " input[name='"+ inputName +"']").each(function(i, o) {
			if ($(o).attr("checked")) {
				priceCheckedArr.push($(o).val());
			} else {
				priceUnCheckedArr.push($(o).val());
			}
		});
		
		list.push("{\"checkedIds\":\""+checkedArr.join() +
					"\", \"unCheckedIds\":\""+ unCheckedArr.join() + 
					"\",\"feeType\":\""+ item.feeType +
					"\",\"priceCheckedIds\":\""+ priceCheckedArr.join() +
					"\",\"priceUnCheckedIds\":\""+ priceUnCheckedArr.join() + "\" }");
	}	

	var data = "{\"groupId\": \""+ groupId +"\", \"list\": ["+ list.join(",") +"] }";
	YM.post("auditList.do", {"data": data, "financeGuides": "["+ financeGuideArr.join(",") +"]"}, function(data) {
		$.success('操作成功');
		loadList();
	});
}

function loadList() {
	var data = {};
	data.groupId = groupId;
	data.groupState = "${group.group_state}";

	//组团社
	data.feeType = "order";
	data.sl = "fin.selectOrderList";
	data.rp = "finance/audit/income-order-listView";
	var orderUrl = "<%=staticPath%>/finance/querySettleList.htm?edit=${optMap['AUDIT']}";
	$("#order").load(orderUrl, data);
	
	//其他收入
	data.feeType = "otherin";
	data.supType = "120";
	data.sl = "fin.selectSupplierList";
	data.rp = "finance/audit/income-supplier-listView";
	$("#otherin").load("<%=staticPath%>/finance/querySettleList.htm", data);
	
	//地接社
	data.feeType = "del";
	data.sl = "fin.selectDeliveryList";
	data.rp = "finance/audit/income-delivery-listView";
	$("#del").load("<%=staticPath%>/finance/querySettleList.htm", data);
	
	data.feeType = "sup";
	for(var i = 0; i < sup.length; i++){
		var item = sup[i];
		data.supType = item.id;
		data.sl = "fin.selectSupplierList";
		data.rp = "finance/audit/income-supplier-listView";
		var listUrl = "<%=staticPath%>/finance/querySettleList.htm?edit=${optMap['AUDIT']}";
		$("#sup"+ item.index).load(listUrl, data);
	}
}

//给新增按钮添加链接
function setAddBtn(){
	var groupId = "${reqpm.groupId}";
	
	$("#otherinAddBtn").click(function(){
		newWindow("新增收入", "<%=staticPath%>/booking/editIncome.htm?groupId="+ groupId);
	});
	
	$("#delAddBtn").click(function(){
		newWindow("新增下接社", "<%=staticPath%>/booking/delivery.htm?gid="+ groupId);
	});
	
	var title = "";
	var addUrl = "";
	for(var i = 0; i < sup.length; i++){
		var item = sup[i];
		var supType = item.id;
		//餐厅
		if(supType == 2){
	    	title = "新增餐饮订单";
			addUrl = "<%=staticPath%>/booking/toAddEat?groupId="+ groupId;
	    }
	 	// 酒店
	    else if(supType == 3){
	    	title = "新增酒店订单";
			addUrl = "<%=staticPath%>/booking/toAddHotel?groupId="+ groupId;
	    }
	 	// 车队
	    else if(supType == 4){
	    	title = "新增车辆订单";
			addUrl = "<%=staticPath%>/booking/toAddCar?groupId="+ groupId;
	    }
	 	// 景区
	    else if(supType == 5){
	    	title = "新增门票订单";
			addUrl = "<%=staticPath%>/booking/toAddSight?groupId="+ groupId;
	    }
	 	// 娱乐
	    else if(supType == 7){
	    	title = "新增娱乐订单";
			addUrl = "<%=staticPath%>/booking/toAddFun?groupId="+ groupId;
	    }
	 	// 导游
	    else if(supType == 8){
	    	title = "安排导游";
			addUrl = "<%=staticPath%>/bookingGuide/guideDetailListView.htm?groupId="+ groupId;
	    }
	 	// 机票
	    else if(supType == 9){
	    	title = "新增机票订单";
			addUrl = "<%=staticPath%>/booking/toAddAirTicket?groupId="+ groupId;
	    }
	 	// 火车票
	    else if(supType == 10){
	    	title = "新增火车票订单";
			addUrl = "<%=staticPath%>/booking/toAddTrainTicket?groupId="+ groupId;
	    }
	 	// 高尔夫
	    else if(supType == 11){
	    	title = "新增高尔夫订单";
			addUrl = "<%=staticPath%>/booking/toAddGolf?groupId="+ groupId;
	    }
	 	// 保险
	    else if(supType == 15){
	    	title = "新增保险订单";
			addUrl = "<%=staticPath%>/booking/toAddInsurance?groupId="+ groupId;
	    }
	 	// 其它
	    else if(supType == 121){
	    	title = "新增支出";
			addUrl = "<%=staticPath%>/booking/editOutcome.htm?groupId="+ groupId;
	    }
		
		(function(index, title, addUrl){
			$("#sup"+ index +"AddBtn").click(function(){
				newWindow(title, addUrl);
			});
		})(item.index, title, addUrl);
	}
}

$(document).ready(function() {
	loadList();
	setAddBtn();
});

</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<dl class="p_paragraph_content">
				<div class="title_h w-1100 ml-20 mt-20 mb-20">
					<b>审核结算单</b>
				</div>
				<div class="group_con w-1100 pl-20">
					<p class="group_h">
						<b>团信息</b>
					</p>
					<div class="group_msg">
						<dd class="inl-bl w-300">
							<div class="dd_left">团号：</div>
							<div class="dd_right">${group.group_code }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-600">
							<div class="dd_left">计调：</div>
							<div class="dd_right">${group.operator_name }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">人数：</div>
							<div class="dd_right">
								<c:if test="${not empty group.total_adult}">${group.total_adult}大</c:if><c:if test="${not empty group.total_child}">${group.total_child}小</c:if><c:if test="${not empty group.total_guide}">${group.total_guide}陪</c:if>
							</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-700">
							<div class="dd_left">产品名称：</div>
							<div class="dd_right">【${group.product_brand_name }】 ${group.product_name }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">状态：</div>
							<div class="dd_right">
								<c:if test="${group.group_state eq 0}">未确认</c:if>
								<c:if test="${group.group_state eq 1}">已确认</c:if>
								<c:if test="${group.group_state eq 2}">作废</c:if>
								<c:if test="${group.group_state eq 3}">已审核</c:if>
								<c:if test="${group.group_state eq 4}">已封存</c:if>
							</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-600">
							<div class="dd_left">起始日期：</div>
							<div class="dd_right">${group.date_start }~${group.date_end }</div>
							<div class="clear"></div>
						</dd>
					</div>
				</div>
			</dl>
			<dl class="p_paragraph_content">
				<h2>
					<label>销售单</label>
				</h2>
				<div id="order"	class="p_container_sub"></div>
				
				<h2>
					<label>其他收入</label>
					<c:if test="${group.group_state ne 4 and group.group_state ne 3  and optMap['EDIT']}">
						<a id="otherinAddBtn" href="javascript:void(0)" class="button button-primary button-small" >新增</a>
					</c:if>
				</h2>
				<div id="otherin" class="p_container_sub"></div>
				
				<h2>
					<label>地接社</label>
					<c:if test="${group.group_state ne 4 and group.group_state ne 3  and optMap['EDIT']}">
						<a id="delAddBtn" href="javascript:void(0)" class="button button-primary button-small" >新增</a>
					</c:if>
				</h2>
				<div id="del" class="p_container_sub"></div>
				
				<c:forEach items="${sup }" var="s" varStatus="status">
					<c:if test="${s.id ne 121 }">
					<h2>
						<label>
							${s.name }
						</label>
						<c:if test="${group.group_state ne 4 and group.group_state ne 3 and optMap['EDIT']}">
							<a id="sup${status.index}AddBtn" href="javascript:void(0)" class="button button-primary button-small" >新增</a>
						</c:if>
					</h2>
					<div id="sup${status.index}" class="p_container_sub"></div>
					</c:if>
				</c:forEach>
				<c:forEach items="${sup }" var="s" varStatus="status">
					<c:if test="${s.id eq 121 }">
					<h2>
						<label>
							${s.name }支出
						</label>
						<c:if test="${group.group_state ne 4 and group.group_state ne 3 and optMap['EDIT']}">
							<a id="sup${status.index}AddBtn" href="javascript:void(0)" class="button button-primary button-small" >新增</a>
						</c:if>
					</h2>
					<div id="sup${status.index}" class="p_container_sub"></div>
					</c:if>
				</c:forEach>
			</dl>
		</div>
		<div style="text-align: center;margin-bottom:200px;">		
			<c:if test="${group.group_state ne 4 and group.group_state ne 3 }">
			<button onclick="postAudit()" class="button button-primary button-small">确定</button>
			</c:if>
			<button onclick="closeWindow()" class="button button-primary button-small">关闭</button>
			<button onclick="window.location.reload();" class="button button-primary button-small">刷新</button>
		</div>
		<div id="operateLogsDiv"></div>
	</div>

</body>
</html>

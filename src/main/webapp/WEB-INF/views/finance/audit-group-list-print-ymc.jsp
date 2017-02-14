<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />

<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css" />
<style type="text/css">
	h2{color:red;}
	.p_paragraph_content label{display:inline-block;width:60px;}
  	.w_table thead th {border:1px solid black !important;}
  	.w_table td {border-color:black !important;}
  	.w_table thead th {background:none !important;}
  	.group_msg {border-color:black !important;}
</style>
<style media="print" type="text/css">
	.NoPrint{display:none;}
</style>
<script type="text/javascript" src="<%=staticPath%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">
function opPrint() {
    window.print();
}

var groupId = "${reqpm.groupId}";
var sup = [];
<c:forEach items="${sup }" var="s" varStatus="status">
	sup.push({"index":"${status.index}", "id": "${s.id}", "name": "${s.name}"});
</c:forEach>

function loadList() {
	var data = {};
	data.groupId = groupId;
	data.isShow = true;

	//组团社
	<c:if test="${order.count > 0}">
		data.feeType = "order";
		data.sl = "fin.selectOrderList";
		data.rp = "finance/audit/income-order-listView";
		$("#order").load("<%=staticPath%>/finance/querySettleList.htm", data);
	</c:if>
	
	//购物
	<c:if test="${shop.count > 0}">
		data.feeType = "shop";
		data.sl = "fin.selectShopList";
		data.rp = "finance/audit/income-shop-listView";
		$("#shop").load("<%=staticPath%>/finance/querySettleList.htm", data);
	</c:if>
	
	//佣金
	<c:if test="${comm.count > 0}">
		$("#comm").load("<%=staticPath%>/finance/guide/commissionList.htm", {groupId:data.groupId,isShow:true});
	</c:if>
	
	//其他收入
	<c:if test="${otherin.count > 0}">
		data.feeType = "otherin";
		data.supType = "120";
		data.sl = "fin.selectSupplierList";
		data.rp = "finance/audit/income-supplier-listView";
		$("#otherin").load("<%=staticPath%>/finance/querySettleList.htm", data);
	</c:if>
	
	//地接社
	<c:if test="${del.count > 0}">
		data.feeType = "del";
		data.sl = "fin.selectDeliveryList";
		data.rp = "finance/audit/income-delivery-listView";
		$("#del").load("<%=staticPath%>/finance/querySettleList.htm", data);
	</c:if>
	
	data.feeType = "sup";
	console.log(sup.length);
	for(var i = 0; i < sup.length; i++){
		var item = sup[i];
		console.log(item);
		data.supType = item.id;
		data.sl = "fin.selectSupplierList";
		data.rp = "finance/audit/income-supplier-listView";
		$("#sup"+ item.index).load("<%=staticPath%>/finance/querySettleList.htm", data);
	}
}
$(document).ready(function() {
	loadList();
});

</script>
</head>
<body>
<!--startprint1-->
	<div class="p_container">
		<div class="p_container_sub">
			<dl class="">
				<div class="group_con">
					<p class="group_h">
						<b>团信息</b>
					</p>
					<div class="group_msg">
						<dd class="inl-bl w-300">
							<div class="dd_left">团号：</div>
							<div class="dd_right">${group.group_code }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
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
						<dd class="inl-bl w-300">
							<div class="dd_left">起始日期：</div>
							<div class="dd_right">${group.date_start }~${group.date_end }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">产品名称：</div>
							<div class="dd_right">【${group.product_brand_name }】 ${group.product_name }</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">收入：</div>
							<div class="dd_right"><fmt:formatNumber value="${group.total_income}" pattern="#.##"/>元</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">支出：</div>
							<div class="dd_right"><fmt:formatNumber value="${group.total_cost-group.total_commls }" pattern="#.##"/>元</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">单团利润：</div>
							<c:set var="totalProfit" value="${group.total_profit+group.total_commls }" />
							<div class="dd_right"><fmt:formatNumber value="${totalProfit }" pattern="#.##"/>元</div>
							<div class="clear"></div>
						</dd>
						<dd class="inl-bl w-300">
							<div class="dd_left">人均利润：</div>
							<div class="dd_right">
								<c:if test="${group.person_num eq 0}"><fmt:formatNumber value="${totalProfit }" pattern="#.##"/>元</c:if>
								<c:if test="${group.person_num ne 0}"><fmt:formatNumber value="${totalProfit / group.person_num }" pattern="#.##"/>元</c:if>
							</div>
							<div class="clear"></div>
						</dd>
					</div>
				</div>
			</dl>
			<dl class="p_paragraph_content">
				<c:if test="${order.count > 0}">
					<h2>
						<label>销售单</label>
					</h2>					
					<div id="order"	class="p_container_sub"></div>
				</c:if>
				<%-- <c:if test="${shop.count > 0}">
					<h2>
						<label>购物</label>
					</h2>
					<div id="shop" class="p_container_sub"></div>
				</c:if>
				
				<c:if test="${comm.count > 0}">
					<h2>
						<label>佣金</label>
					</h2>
					<div id="comm" class="p_container_sub"></div>
				</c:if> --%>
				
				<c:if test="${otherin.count > 0}">
					<h2>
						<label>其他收入</label>
					</h2>
					<div id="otherin" class="p_container_sub"></div>
				</c:if>
				
				<c:if test="${del.count > 0}">
					<h2>
						<label>地接社</label>
					</h2>
					<div id="del" class="p_container_sub"></div>
				</c:if>
				
				<c:forEach items="${sup }" var="s" varStatus="status">
					<c:if test="${s.id ne 121 }">
					<h2>
						<label>
							${s.name }
						</label>
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
					</h2>
					<div id="sup${status.index}" class="p_container_sub"></div>
					</c:if>
				</c:forEach>
			</dl>
			${printMsg }
			<div class="print NoPrint">
				<c:if test="${reqpm.isPrint ne true}">
  					<a class="button  button-primary button-small mr-20" href="<%=staticPath%>/finance/auditGroupListPrintYMC.htm?groupId=${reqpm.groupId }&isPrint=true" target="_blank">打印预览</a>
 					<%-- 导出 --%>
					<a target="_blank" href="<%=staticPath%>/finance/queryAuditGroupExcelList.htm?groupId=${reqpm.groupId }&isPrint=true"
					   class="button button-primary button-small">导出到Excel</a>
 				</c:if>
 				<c:if test="${reqpm.isPrint eq true}">
  					<a class="button  button-primary button-small mr-20" onclick="opPrint();" href="#" >打印</a>
 				</c:if>
 			</div>
		</div>
	</div>
 <!--endprint1-->
</body>
</html>

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
<title>销售收入</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/css/finance/finance.css" />
<script type="text/javascript" src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>

</head>
<script type="text/javascript">
	
	function getFinanceGuide(obj){
		
		var finangeGuide = [];
		
		var bookingId = $(obj).parent().parent().find("select[name='bookingId']");
		if(bookingId && !$(bookingId).attr("disabled")){
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
	
	function getPriceAuditData(pm){
		
		var priceCheckedArr = [];
		var priceUnCheckedArr = [];
		$("input[name='audit_price_id']").each(function(i, o) {
			if ($(o).attr("checked")) {
				priceCheckedArr.push($(o).val());
			} else {
				priceUnCheckedArr.push($(o).val());
			}
		});
		pm.priceCheckedIds = priceCheckedArr.join();
		pm.priceUnCheckedIds = priceUnCheckedArr.join();
	}
	
	function postAudit(ckbox) {
		var checkedArr = [];
		var unCheckedArr = [];
		var financeGuideArr = [];
		$("input[name='audit_id']").each(function(i, o) {
			if ($(o).attr("checked")) {
				checkedArr.push($(o).val());
			} else {
				unCheckedArr.push($(o).val());
			}
			if("sup" == "${reqpm.feeType}" || "otherin" == "${reqpm.feeType}"){
				var financeGuide = getFinanceGuide(o);
				if(financeGuide){
					financeGuideArr.push(financeGuide);	
				}
			}
		});
		var pm = {};
		pm.checkedIds = checkedArr.join();
		pm.unCheckedIds = unCheckedArr.join();
		if(financeGuideArr.length > 0){
			pm.financeGuides = "["+ financeGuideArr.join(",") +"]";
		}
		pm.groupId = "${reqpm.groupId}";
		//pm.supType = "${reqpm.supType}";
		pm.feeType = "${reqpm.feeType}";
		
		if(pm.feeType == "shop"){
			var comCheckedArr = [];
			var comUnCheckedArr = [];
			$("input[name='commission_id']").each(function(i, o) {
				if ($(o).attr("checked")) {
					comCheckedArr.push($(o).val());
				} else {
					comUnCheckedArr.push($(o).val());
				}
			});
			pm.comCheckedIds = comCheckedArr.join();
			pm.comUnCheckedIds = comUnCheckedArr.join();
		}
		
		if(pm.feeType == "order"){
			getPriceAuditData(pm);
		}
		
		YM.post("audit.do", pm, function(data) {
			$.success('操作成功');
			loadList();
		});
	}

	function checkAll(ckbox) {
		if ($(ckbox).attr("checked")) {
			$("input[name='audit_id']").each(function(){
				if($(this).attr('disabled') != 'disabled'){
					$(this).attr('checked', 'checked');		
				}	
			});
		} else {
			$("input[name='audit_id']").each(function(){
				if($(this).attr('disabled') != 'disabled'){
					$(this).removeAttr("checked");
				}	
			});
		}
	}
	
	function checkAllCommission(ckbox) {
		if ($(ckbox).attr("checked")) {
			$("input[name='commission_id']").attr('checked', 'checked');
		} else {
			$("input[name='commission_id']").removeAttr("checked");
		}
	}

	function divExpand(btnObj, subId, data) {
		//切换 (展开/收缩)小图标
		var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
		$(btnObj).attr("class", cssName);

		//收起来
		if (cssName == "serialnum_btn") {
			$("#td_" + subId).parent().slideUp().remove();
			return;
		} else {
			//如果已经加载过数据则不再重复请求，直接展开
			if ($("#td_" + subId).length > 0) {
				$("#td_" + subId).parent().slideDown().show();
				return;
			}
		}

		//展开 
		var trContainer = '<tr ><td colspan="10" id="td_'+subId+'"></td></tr>';
		$(btnObj).closest("tr").after(trContainer);
		vTrObj = $("#td_" + subId).slideDown();
		data.subId = subId;
		$("#td_" + subId).load("../common/queryList.htm", data);
	}
	
	function loadHead(){
		var data = {};
		data.groupId = "${reqpm.groupId}";
		data.sl = "fin.selectGroupList";
		data.rp = "finance/group-info";

		$("#headDiv").load("../common/queryOne.htm", data);
	}

	function loadList() {
		var data = {};
		data.groupId = "${reqpm.groupId}";
		data.supType = "${reqpm.supType}";
		data.feeType = "${reqpm.feeType}";
		data.groupState = "${group.groupState}";
		switch (data.feeType) {
		case "order":
			data.sl = "fin.selectOrderList";
			data.rp = "finance/audit/income-order-listView";
			break;
		case "shop":
			data.sl = "fin.selectShopList";
			data.rp = "finance/audit/income-shop-listView";
			$("#commissionDiv").load("<%=staticPath%>/finance/guide/commissionList.htm", {groupId:data.groupId});
			var title = "新增购物";
			var addUrl = "<%=staticPath%>/bookingFinanceShop/toAddShop.htm?groupId=${reqpm.groupId}&type=1";
			break;
		case "del":
			data.sl = "fin.selectDeliveryList";
			data.rp = "finance/audit/income-delivery-listView";
			var title = "新增下接社"
			var addUrl = "<%=staticPath%>/booking/delivery.htm?gid=${reqpm.groupId}";
			break;
		case "sup":
			data.sl = "fin.selectSupplierList";
			data.rp = "finance/audit/income-supplier-listView";
			break;
		case "otherin":
			data.sl = "fin.selectSupplierList";
			data.rp = "finance/audit/income-supplier-listView";
			var title = "新增收入";
			var addUrl = "<%=staticPath%>/booking/editIncome.htm?groupId=${reqpm.groupId}";
			break;
		}
			var listUrl = "<%=staticPath%>/finance/querySettleList.htm?edit=${optMap['AUDIT']}";
		$("#listDiv").load(listUrl, data);
	}
	
	//给新增按钮添加链接
	function setAddBtn(){
		var groupId = "${reqpm.groupId}";
		var supType = "${reqpm.supType}";
		var feeType = "${reqpm.feeType}";
		var groupState = "${group.groupState}";
		
		var title = "";
		var addUrl = "";
		switch (feeType) {
			case "order":
				$("#orderAddBtn").css("display", "none");
				break;
			case "shop":
				title = "新增购物";
				addUrl = "<%=staticPath%>/bookingFinanceShop/toAddShop.htm?groupId="+ groupId +"&type=1";
				$("#orderAddBtn").html("新增购物");
				$("#editCommBtn").css("display", "");
				$("#editCommBtn").click(function(){
					newWindow("编辑佣金","<%=staticPath%>/finance/guide/addCommission.htm?groupId="+ groupId);
				});
				break;
			case "del":
				title = "新增下接社";
				addUrl = "<%=staticPath%>/booking/delivery.htm?gid="+ groupId;
				break;
			case "otherin":
				title = "新增收入";
				addUrl = "<%=staticPath%>/booking/editIncome.htm?groupId="+ groupId;
				break;
			case "sup":
			 	// 餐厅
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
				break;
		}
		
		$("#orderAddBtn").click(function(){
			newWindow(title, addUrl);
		});
	}

	$(document).ready(function() {
		loadList();
		loadHead();
		setAddBtn();
	});

</script>
<body>
	<div class="p_container" style="background-color:#ffffff;" >
		<div id="headDiv"></div>
		<div class="p_container_sub" id="listDiv"></div>
		<div class="p_container_sub" id="commissionDiv"></div>
		<div style="text-align: center;">
			<c:if test="${group.groupState ne 4 and group.groupState ne 3}">
				<button id="btn_audit" onclick="postAudit()" class="button button-primary button-small">确定</button>
			</c:if>
			<a onclick="closeWindow()" href="javascript:void(0);" class="button button-primary button-small">关闭</a>
			<c:if test="${group.groupState ne 4 and group.groupState ne 3 and optMap['EDIT']}">
				<a id="orderAddBtn" href="javascript:void(0)"  class="button button-primary button-small" >新增</a>
				<a id="editCommBtn" href="javascript:void(0)"  class="button button-primary button-small" style="display:none" >编辑佣金</a>
			</c:if>
		</div>
	</div>
	
</body>
</html>

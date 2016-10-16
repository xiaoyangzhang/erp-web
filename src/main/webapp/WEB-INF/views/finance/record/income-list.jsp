<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款明细</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
     $(function() {
 		function setInRecordData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#inRecordStartMin").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#inRecordStartMax").val(endTime);			
 		}
 		
 		function setPayRecordData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#payRecordStartMin").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#payRecordStartMax").val(endTime);			
 		}
 		
 		setInRecordData();
 		setPayRecordData();
 	 
 	});
</script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0)" id="showInRecordBtn" class="selected" onclick="showInRecordDiv(this)">收款明细</a></li>
			<li><a href="javascript:void(0)" id="showPayRecordBtn" onclick="showPayRecordDiv(this)">付款明细</a></li>
			<li class="clear"></li>
		</ul>
		<div id="inRecordDiv">
			<div class="p_container_sub">
				<form id="inRecordQueryForm">
					<input type="hidden" name="page" id="inRecordPage" />
					<input type="hidden" name="pageSize" id="inRecordPageSize" />
					<input type="hidden" name="sl" value="fin.selectIncomeRecordListPage" />
					<input type="hidden" name="rp" value="finance/record/income-list-table" />
					<div class="searchRow">
						<ul>
							<li class="text">出团日期:</li>
							<li>
								<input name="start_min" type="text" id="inRecordStartMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~
								<input name="start_max" id="inRecordStartMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							</li>
							<li class="text">收款状态:</li>
							<li><select name="status" class="w-100bi">
									<option value="">全部</option>
									<option value="0">已收清</option>
									<option value="1">未收清</option>
							</select></li>
							<li class="text">团类型:</li>
							<li><select name="group_mode" class="w-100bi">
									<option value="">全部</option>
									<option value="0">散客</option>
									<option value="1">团队</option>
							</select></li>
							<li class="clear" />
							<li class="text"></li>
						<!-- </ul>
						<ul> -->
							<li class="text">团号:</li>
							<li><input name="group_code" type="text" /></li>
							<li class="text">商家名称:</li>
							<li><input name="supplier_name" type="text" /></li>
							<li class="text">商家类型:</li>
							<li><select name="supplier_type" class="w-100bi">
									<option value="">全部</option>
									<c:forEach items="${sup_type_map_in }" var="tp">
										<option value="${tp.key }">${tp.value }</option>
									</c:forEach>
							</select></li>
							<li class="text">产品名称:</li>
							<li><input name="product_name" type="text" /></li>
							<li class="text"></li>
							<li><input type="button" id="btnQuery" onclick="inRecordSearchBtn()" class="button button-primary button-small" value="查询"></li>
						</ul>
					</div>
				</form>
			</div>
			<div id="inRecordTableDiv"></div>
			<div id="inRecordPopDiv" style="display: none" class="searchRow">
				<ul>
					<li class="text">团号:</li>
					<li id="_in_record_group_code"></li>
					<li class="text">商家:</li>
					<li id="_in_record_supplier_name"></li>
					<li class="text">金额:</li>
					<li id="_in_record_total"></li>
					<li class="text">已收:</li>
					<li id="_in_record_total_cash"></li>
					<li class="text">未收:</li>
					<li id="_in_record_balance"></li>
				</ul>
				<div id="inRecordPopTableDiv"></div>
			</div>
		</div>
		
		<div id="payRecordDiv" style="display:none;">
			<div class="p_container_sub">
				<form id="payRecordQueryForm">
					<input type="hidden" name="page" id="payRecordPage" />
					<input type="hidden" name="pageSize" id="payRecordPageSize" />
					<input type="hidden" name="sl" value="fin.selectPayRecordListPage" />
					<input type="hidden" name="rp" value="finance/record/pay-list-table" />
					<div class="searchRow">
						<ul>
							<li class="text">出团日期:</li>
							<li>
								<input name="start_min" type="text" id="payRecordStartMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~
								<input name="start_max" id="payRecordStartMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							</li>
							<li class="text">付款状态:</li>
							<li><select name="status" class="w-100bi">
									<option value="">全部</option>
									<option value="0">已付清</option>
									<option value="1">未付清</option>
							</select></li>
							<li class="text">团类型:</li>
							<li><select name="group_mode" class="w-100bi">
									<option value="">全部</option>
									<option value="0">散客</option>
									<option value="1">团队</option>
							</select></li>
							<li class="clear" />
							<li class="text"></li>
							<li class="text">团号:</li>
							<li><input name="group_code" type="text" /></li>
							<li class="text">商家名称:</li>
							<li><input name="supplier_name" type="text" /></li>
							<li class="text">商家类型:</li>
							<li><select name="supplier_type" class="w-100bi">
									<option value="">全部</option>
									<c:forEach items="${sup_type_map_pay }" var="tp">
										<c:if test="${tp.value ne '娱乐' and tp.value ne '导游' and tp.value ne '高尔夫'}">
											<option value="${tp.key }">${tp.value }</option>
										</c:if>
									</c:forEach>
							</select></li>
							<li class="text"></li>
							<li><input type="button" id="btnQuery" onclick="payRecordSearchBtn()" class="button button-primary button-small" value="查询"></li>
						</ul>
					</div>
				</form>
			</div>
			<div id="payRecordTableDiv"></div>
			<div id="payRecordPopDiv" style="display: none" class="searchRow">
				<ul>
					<li class="text">团号:</li>
					<li id="_pay_record_group_code"></li>
					<li class="text">商家:</li>
					<li id="_pay_record_supplier_name"></li>
					<li class="text">金额:</li>
					<li id="_pay_record_total"></li>
					<li class="text">已付:</li>
					<li id="_pay_record_total_cash"></li>
					<li class="text">未付:</li>
					<li id="_pay_record_balance"></li>
				</ul>
				<div id="payRecordPopTableDiv"></div>
			</div>
			<div id="payRecordPopDetailTableDiv"></div>
		</div>
	</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
	function showInRecord(o) {
		
		for(p in o){
			if(p == "total" || p == "total_cash" || p == "balance"){
				var value = o[p];
				var pointPos = value.indexOf(".");
				value = value.substring(0, pointPos+3);
				o[p] = value;
			}
			$("#_in_record_"+p).text(o[p]);
		}
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierId = o.supplier_id;
		data.payDirect = 1;
		data.sl = "fin.selectCashRecordList";
		data.rp = "finance/record/pay-record-list-table";
		$("#inRecordPopTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '收款记录',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#inRecordPopDiv"),
			btn : [ '确定', '取消' ],
			yes : function(index) {
	
				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
	
	function showPayRecord(o) {
		
		for(p in o){
			if(p == "total" || p == "total_cash" || p == "balance"){
				var value = o[p];
				var pointPos = value.indexOf(".");
				value = value.substring(0, pointPos+3);
				o[p] = value;
			}
			$("#_pay_record_"+p).text(o[p]);
		}
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierId = o.supplier_id;
		data.payDirect = 0;
		data.sl = "fin.selectCashRecordList";
		data.rp = "finance/record/pay-record-list-table";
		$("#payRecordPopTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '付款记录',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#payRecordPopDiv"),
			btn : ['取消'],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
	
	function showPayDetail(o) {
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierType = o.supplier_type;
		data.payDirect = 0;
		data.sl = "fin.selectPayOrderDetailList";
		data.rp = "finance/record/pay-detail-list-table";
		$("#payRecordPopDetailTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '订单明细',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#payRecordPopDetailTableDiv"),
			btn : ['取消' ],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
	
	function inRecordQueryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#inRecordPage").val(page);
		$("#inRecordPageSize").val(pagesize);

		var options = {
			url : "../common/queryListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#inRecordTableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#inRecordQueryForm").ajaxSubmit(options);
	}
	
	function inRecordSearchBtn(){
		inRecordQueryList(1, $("#inRecordPageSize").val());
	}
	
	function payRecordQueryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#payRecordPage").val(page);
		$("#payRecordPageSize").val(pagesize);

		var options = {
			url : "../common/queryListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#payRecordTableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#payRecordQueryForm").ajaxSubmit(options);
	}
	
	function payRecordSearchBtn(){
		payRecordQueryList(1, $("#payRecordPageSize").val());
	}
	
	function showInRecordDiv(obj){
		$("#showInRecordBtn").attr("class", "selected");
		$("#showPayRecordBtn").attr("class", "");
		
		$("#inRecordDiv").css({"display":""});
		$("#payRecordDiv").css({"display":"none"});
	}
	
	function showPayRecordDiv(obj){
		$("#showInRecordBtn").attr("class", "");
		$("#showPayRecordBtn").attr("class", "selected");
		
		$("#inRecordDiv").css({"display":"none"});
		$("#payRecordDiv").css({"display":""});
	}
	
	$(function() {
		inRecordQueryList();
		payRecordQueryList();
	});
</script>
</html>
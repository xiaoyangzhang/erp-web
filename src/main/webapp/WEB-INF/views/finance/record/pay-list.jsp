<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>付款明细</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#startMin").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#startMax").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="inrecord.htm">收款明细</a></li>
			<li><a href="payrecord.htm" class="selected">付款明细</a></li>
			<li class="clear"></li>
		</ul>

		<div id="payRecordDiv">
			<div class="p_container_sub">
				<form id="queryForm">
					<input type="hidden" name="page" id="page" />
					<input type="hidden" name="pageSize" id="pageSize" />
					<input type="hidden" name="sl" value="fin.selectPayRecordListPage" />
					<input type="hidden" name="rp" value="finance/record/pay-list-table" />
					<div class="searchRow">
						<ul>
							<li class="text">出团日期:</li>
							<li><input name="start_min" type="text" id="startMin" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="start_max" id="startMax" type="text" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
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
										<option value="${tp.key }">${tp.value }</option>
									</c:forEach>
							</select></li>
							<li class="text"></li>
							<li><input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="查询"></li>
						</ul>
					</div>
				</form>
			</div>
			<div id="tableDiv"></div>
			<div id="popDiv" style="display: none" class="searchRow">
				<ul>
					<li class="text">团号:</li>
					<li id="_group_code"></li>
					<li class="text">商家:</li>
					<li id="_supplier_name"></li>
					<li class="text">金额:</li>
					<li id="_total"></li>
					<li class="text">已付:</li>
					<li id="_total_cash"></li>
					<li class="text">未付:</li>
					<li id="_balance"></li>
				</ul>
				<div id="popTableDiv"></div>
			</div>
			<div id="popDetailTableDiv" style="display: none"></div>
		</div>
	</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
	function showDetail(o) {
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierType = o.supplier_type;
		data.payDirect = 0;
		data.sl = "fin.selectPayOrderDetailList";
		data.rp = "finance/record/pay-detail-list-table";
		$("#popDetailTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '订单明细',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDetailTableDiv"),
			btn : ['取消' ],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
	
	function showRecord(o) {
		
		for(p in o){
			if(p == "total" || p == "total_cash" || p == "balance"){
				var value = o[p];
				var pointPos = value.indexOf(".");
				value = value.substring(0, pointPos+3);
				o[p] = value;
			}
			$("#_"+p).text(o[p]);
		}
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierId = o.supplier_id;
		data.payDirect = 0;
		data.sl = "fin.selectCashRecordList";
		data.rp = "finance/record/pay-record-list-table";
		$("#popTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '付款记录',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDiv"),
			btn : ['取消'],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
	
	function queryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);

		var options = {
			url : "../common/queryListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#tableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#queryForm").ajaxSubmit(options);
	}
	
	$(function() {
		queryList();
	});
</script>
</html>
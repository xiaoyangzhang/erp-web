<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理员订单</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
	#sale_operator_name_id{
		width: 305;
	}
</style>
</head>
<body>
	<div class="p_container">
			<div class="p_container_sub" id="list_search">
				<form id="queryResAdminOrderForm" method="post">
					<input type="hidden" name="page" id="searchPage"　value="${pageBean.page }"/>
					<input type="hidden" name="pageSize" id="searchPageSize"　value="${pageBean.pageSize }"/>
					<div class="searchRow">
					<dl class="">
						<dd class="inl-bl">
							<div class="dd_left">
								<select name="dateType" id="dateType">
									<option value="1">出团日期</option>
									<option value="2">输单日期</option>
								</select>
							</div>
							<div class="dd_right grey">
								<input type="text" id="startTime_id" name="startTime" class="Wdate"
									onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
								 ~
								 <input type="text" id="endTime_id" name="endTime" class="Wdate"
									onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">订单号：</div>
							<div class="dd_right grey">
								<input type="text" name="orderId" value="" id="order_ids" style="width:100px"/>
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">接站牌：</div>
							<div class="dd_right grey">
								<input type="text" name="receiveMode" id="receive_mode_id" value="" style="width:100px" />
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">产品名称:</div>
							<div class="dd_right grey">
								<input type="text" name="productName" id="product_name_id" value="" />							
							</div>
							<div class="clear"></div>
						</dd>
					</dl>
					<div class="clear"></div>
					<dl class="">
						<dd class="inl-bl">
							<div class="dd_left">组团社：</div>
							<div class="dd_right grey">
								<input type="text" name="supplierName" id="supplierName_id" value="" style="width:185px" />
							</div>
						</dd>
						
						<dd class="inl-bl">
							<div class="dd_left">尾款时限</div>
							<div class="dd_right grey">
								<input type="text" name="extHour" id="ext_res_clean_time_id" value=""  style="width:66px"
									onkeyup="value=value.replace(/[^\d]/g,'')" /><span>分钟内</span>
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">计调：</div>
							<div class="dd_right grey">
								<input type="text" name="saleOperatorName" id="sale_operator_name_id" value="" style="width:100px" />
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left"></div>
							<div class="dd_right grey">
								<select name="type" id="type_id">
									<option value="">类型</option>
									<option value="0">预留</option>
									<option value="1">购买</option>
								</select>
								<select name="extResState" id="ext_res_state_id">
									<option value="">订单状态</option>
									<option value="0">待确认</option>
									<option value="1">已确认</option>
									<option value="2">正常取消</option>
									<option value="3">任务取消</option>
								</select>
								<select name="gatherState" id="gatherState_id">
									<option value="">收款状态</option>
									<option value="0">已收清</option>
									<option value="1">未收清</option>
								</select>
							</div>

						</dd>
						<dd class="inl-bl">
							<div class="dd_right">
								<button type="button" onclick="searchBtn()"
									class="button button-primary button-small">查询</button>
								<a href="javascript:void(0);" id="toTrafficOrderExcelId" target="_blank" onclick="toTrafficOrderExcel()" class="button button-primary button-small">导出到Excel</a>
							</div>
							<div class="clear"></div>
						</dd>

					</dl>
					</div>
				</form>
			</div>
			<div id="resAdminOrderTableList">
				<!-- 显示table列表 -->
			</div>
	</div>
</body>
<script type="text/javascript">
$(function () {
	function setTime() {
		var curDate = new Date();
		var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
		$("#startTime_id").val(startTime);
		var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
		var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
		var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
		$("#endTime_id").val(endTime);
	}
	setTime();
});

function reloadPage(){
	$.success('操作成功',function(){
		layer.closeAll();
		queryList($("#searchPage").val(), $("#searchPageSize").val());
	});
}

function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"loadResAdmOrderInfo.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#resAdminOrderTableList").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#queryResAdminOrderForm").ajaxSubmit(options);	
}	

function searchBtn(){
	queryList(null,$("#searchPageSize").val());
}

$(function () {
	queryList();
});

function goLogStock(orderId){
	showInfo("订单日志","950px","550px","<%=staticPath%>/basic/singleList.htm?tableName=group_order&tableId=" + orderId);
}

function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5, 		
 		area : [width,height],
 		content : url
 	});
 }
 
/* 导出到Excel */
function toTrafficOrderExcel(){
	$("#toTrafficOrderExcelId").attr("href","toResAdminOrderExcel.htm?startTime="+$("#startTime_id").val()
			+"&endTime="+$("#endTime_id").val()
			+"&dateType="+$("#dateType").val()
			+"&orderId="+$("#order_ids").val()
			+"&receiveMode="+$("#receive_mode_id").val()
			+"&productName="+$("#product_name_id").val()
			+"&supplierName="+$("#supplierName_id").val()
			+"&extHour="+$("#ext_res_clean_time_id").val()
			+"&saleOperatorName="+$("#sale_operator_name_id").val()
			+"&type="+$("#type_id").val()
			+"&extResState="+$("#ext_res_state_id").val()
			+"&gatherState="+$("#gatherState_id").val()
			+"&page="+$("#searchPage").val()
			+"&pageSize="+$("#searchPageSize").val());
}
</script>
</html>
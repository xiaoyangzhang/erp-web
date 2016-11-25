<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>资源订单列表</title>
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
				<form id="queryResOrderForm" method="post">
					<input type="hidden" name="page" id="searchPage"　value="${page.page }"/>
					<input type="hidden" name="pageSize" id="searchPageSize"　value="${page.pageSize }"/>
					<div class="searchRow">
					<dl class="">
						<dd class="inl-bl">
							<!-- <div class="dd_left">日期:</div> -->
							<div class="dd_left">
								<select name="dateType">
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
								<input type="text" name="orderId" value="" id="order_ids"/>
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">接站牌：</div>
							<div class="dd_right grey">
								<input type="text" name="receiveMode" id="receive_mode_id" value="" />
							</div>
						</dd>
						<!-- <dd class="inl-bl">
							<div class="dd_left">产品名称：</div>
							<div class="dd_right grey">
								<input type="text" name="productName" id="product_name_id" value="" />
							</div>
						</dd> -->
						<dd class="inl-bl">
							<div class="dd_left">产品名称:</div>
							<div class="dd_right grey">
								<%-- <select class="select160" name="productBrandId">
									<option value="">选择品牌</option>
									<c:forEach items="${brandProductList}" var="proName">
										<option value="${proName.id }">${proName.value }</option>
									</c:forEach>
								</select> --%>
								<input type="text" name="productName" id="product_name_id" value="" />							
							</div>
							<div class="clear"></div>
						</dd>
						
						
						<dd class="inl-bl">
							<div class="dd_left">尾款时限</div>
							<div class="dd_right grey">
								<input type="text" name="extHour" id="ext_res_clean_time_id" value=""  
									onkeyup="value=value.replace(/[^\d]/g,'')" /><span>分钟内</span>
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">下单员：</div>
							<div class="dd_right grey">
								<input type="text" name="saleOperatorName" id="sale_operator_name_id" value="" />
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">类型：</div>
							<div class="dd_right grey">
								<select name="type" id="type_id">
									<option value="">全部</option>
									<option value="0">预留</option>
									<option value="1">购买</option>
								</select>
							</div>

						</dd>
						<dd class="inl-bl">
							<div class="dd_left">订单状态：</div>
							<div class="dd_right grey">
								<select name="extResState" id="ext_res_state_id">
									<option value="">全部</option>
									<option value="0">待确认</option>
									<option value="1">已确认</option>
									<option value="2">正常取消</option>
									<option value="3">任务取消</option>
								</select>
							</div>
						</dd>
						<dd class="inl-bl">
							<div class="dd_left">收款状态：</div>
							<div class="dd_right grey">
								<select name="gatherState" id="gatherState_id">
									<option value="">全部</option>
									<option value="0">已收清</option>
									<option value="1">未收清</option>
								</select>
							</div>

						</dd>
						<dd class="inl-bl">
							<div class="dd_right">
								<button type="button" onclick="searchBtn()"
									class="button button-primary button-small">查询</button>
							</div>
							<div class="clear"></div>
						</dd>

					</dl></div>
				</form>
			</div>
			<div id="resGroupOrderTableList">
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
		url:"loadResGroupOrderInfo.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#resGroupOrderTableList").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#queryResOrderForm").ajaxSubmit(options);	
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
</script>
</html>
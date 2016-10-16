<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>下接社统计</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=staticPath %>/assets/js/chart/highcharts.js"></script>
<script type="text/javascript">
$(function() {
	var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
	$("input[name='startTime']").val(vars.dateFrom);
	$("input[name='endTime']").val(vars.dateTo );	
	
	
})
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<form id="queryForm" action="deliveryDetailList.htm" method="post">

			
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li>
						<select name="dateType" id="dateType">
							<option value="0">出团日期</option>
							<option value="1">输单日期</option>
						</select>
						<input name="startTime" id="startTime" type="text" class="Wdate" value="" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="endTime" id="endTime" type="text" class="Wdate" value="" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">组团社</li>
					<li><input id="supplierName"  name="supplierName" style="width: 200px" type="text"/></li> 
				
					<li class="text">产品</li>
					<li><input id="productName"   name="productName" type="text" placeholder="输入产品名称或品牌"/></li>
					<li class="clear"/>
					<li class="text">
						
					</li>
					<li>部门: <input type="text" name="orgNames" id="orgNames"
							stag="orgNames" readonly="readonly" onclick="showOrg()" /> <input
							name="orgIds" id="orgIds" stag="orgIds" type="hidden" value="" />
							计调:
							<select name="operType" id="operType">
							<option value="0">销售计调</option>
							<option value="1">操作计调</option>
						</select>
							 <input type="text" name="operatorName"
							id="saleOperatorName" stag="userNames" readonly="readonly"
							onclick="showUser()" /> <input name="saleOperatorIds"
							id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
						<li class="clear" />
						<li><input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="查询">
					<!-- <a href="javascript:void(0)" id="preview7" onclick="toPreview7()"  class="button button-glow button-rounded button-raised button-primary button-small" >
						打印预览</a> -->
					</li>
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
<script type="text/javascript">

$(document).ready(function () {
	queryList();
});  
    
function queryList() {
	var options = {
		url:"guestInfoStatics.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList();
}


/* function toPreview7(){
	$("#preview7").attr("target","_blank").attr("href","../query/productSourcePreview.htm?dateType="+$("#dateType").val()+"&startDate="+
			$("#startDate").val()+"&endDate="+$("#endDate").val()+"&supplierName="+$("#supplierName").val()+"&productName="+$("#productName").val()+
			"&orderMode="+$("#orderMode").val()+"&operatorType="+$("#operatorType").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&orgIds="+$("#orgIds").val());
	
} */
</script>
</html>
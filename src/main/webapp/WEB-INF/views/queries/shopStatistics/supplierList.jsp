<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>购物统计</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/shopStatistics.js"></script>
	<script type="text/javascript">
     $(function() {
    	 var vars={
 	   			 dateFrom : $.currentMonthFirstDay(),
 	   		 	dateTo : $.currentMonthLastDay()
 	   		 	};
 		$("#startTime").val(vars.dateFrom);
 		$("#endTime").val(vars.dateTo );	
 		
 	
 	 
 });
     function queryList(page,pagesize) {	
    	    if (!page || page < 1) {
    	    	page = 1;
    	    }
    	    
    	    $("#page").val(page);
    	    $("#pageSize").val(pagesize);
    	    
    	    var options = {
    			url:"../common/queryListPage.htm",
    	    	type:"post",
    	    	dataType:"html",
    	    	success:function(data){
    	    		$("#tableDiv").html(data);
    	    	},
    	    	error:function(XMLHttpRequest, textStatus, errorThrown){
    	    		$.error("服务忙，请稍后再试");
    	    	}
    	    };
    	    $("#form").ajaxSubmit(options);	
    	    
    	}
     </script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="toGuideList.htm;"  class="selected">购物统计</a></li>
			<li><a href="shopSelectList.htm" >购物查询</a></li>
			<li><a href="shopInfoDetailList.htm">购物明细</a></li>
			<li class="clear"></li>
		</ul>
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="shop.selectSupplierListPage" />
			<input type="hidden" name="rp" value="queries/shopStatistics/supplierTable" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul style="margin-left: 25px;">
					<li class="text">统计方式:</li>
					<li>
						<input type="radio" id="guide"  />导游
						<input type="radio" id="guideManage"/>导管
						<input type="radio" id="shop"  />购物店
						<input type="radio" id="product"  />产品
						<input type="radio" checked="checked" id="supplier" />组团社(仅团队)
					</li>
					<li class="clear"/>
				</ul>
				<ul style="margin-left: 25px;">
					<li class="text">团日期</li>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${first}" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last}" />
					</li>
					<li class="text">组团社</li>
					<li><input id="supplier" name="supplier" type="text"/></li>
					<li class="text">操作计调</li>
					<li>
						<input id="operatorIds" name="operatorIds" type="hidden"/>
						<input id="operatorName" name="operatorName" type="text" readonly="readonly"/>
						<a href="javascript:void(0);" onclick="selectUserMuti()">请选择</a>
						<a href="javascript:void(0);" onclick="toClear()">重置</a>
					</li>
					<li>
						<a href="javascript:void(0);" id="btnQuery" onclick="queryList()" class="button button-primary button-small">查询</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.freezeheader.js"></script>
	<script type="text/javascript">
	$(function() {
		var vars={
				 dateFrom : $.currentMonthFirstDay(),
			 	dateTo : $.currentMonthLastDay()
			 	};
		$("#startTime").val(vars.dateFrom);
		$("#endTime").val(vars.dateTo );	
	
	 
});
	</script>
</head>
<body>
    <div class="p_container" >
    <form id="queryForm">
		<input type="hidden" name="page" id="page" value="1"/>
		<input type="hidden" name="pageSize" id="pageSize" value="10"/>
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_right grey">						
	    				<select id="dateType" name="dateType">
	    					<option value="groupDate">团日期</option>
	    					<option value="appliDate">进店日期</option>
	    				</select>
						<input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="groupCode" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">团类别:</div>
	    			<div class="dd_right grey">
						<select id="groupMode" name="groupMode">
							<option value="">请选择</option>
							<option value="1">团队</option>
							<option value="0">散客</option>							
						</select>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="productName" id="productName" value="" class="w-120"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>

	    		<dd class="inl-bl" style="float: right;">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
	    			<div class="dd_left">
						<a href="javascript:void();" id="btn_audit" onclick="print();" class="button button-primary button-rounded button-small">打印</a>   				
	    			</div>
	    			
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>
    <div id="showApplyDiv"></div>     
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>           
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">


function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 15;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/bookingShop/shopTJList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList(null,$("#NumberPageSize").val());
}

$(function() {
	queryList();
});

function print(){
	 window.open ("<%=staticPath%>/bookingShop/shopTJPrint.do?"+ $("#queryForm").serialize()); 
}

</script>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
   	</script>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</head>
<script type="text/javascript">
		$(function(){
			var vars={
	    			 dateFrom : $.currentMonthFirstDay(),
	    		 	dateTo : $.currentMonthLastDay()
	    		 	};
	    		 	$("#startTime").val(vars.dateFrom);
	    		 	 $("#endTime").val(vars.dateTo );	
	 	
		})
		
	</script>
<body>
    <div class="p_container" >
     
 	<form id="searchBookingGuideForm">
	    	<div class="p_container_sub" >
			<div class="searchRow">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">团日期:</div>
	    			<div class="dd_right grey">
	    			<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value="${page.pageSize }"/>
						<input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode"  class="w-200"/>
						<!-- <a href="javascript:void(0);" onclick="multiReset()">重置</a> -->
	    			</div>
	    			
	    			
	    				<dd class="inl-bl">
	    		<div class="dd_right">部门:
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
	    			</div>
							</dd>
							
						<dd class="inl-bl">
	    			<div class="dd_left">计调:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="operatorName"  class="w-200"/>
	    			</div>
	    			</dd>
							
	    		 		<dd class="inl-bl">
	    			<div class="dd_left">产品:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="productName"  class="w-200"/>
	    			</div>
	    			</dd>
	    			
	    			
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游姓名:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="guideName"  class="w-200"/>
						<!-- <a href="javascript:void(0);" onclick="multiReset()">重置</a> -->
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">调派人:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="userName"  class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">是否已报账：</div>
	    			<div class="dd_right grey">
	    				<select name="stateBooking">
	    					<option value="">全部</option>
	    					<option value="2">是</option>
	    					<option value="0">否</option>
	    				</select>
	    			</div>
	    			
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</div>
	    	</div>
	    	</form>
	    	 <!--#tabContainer结束-->
    </div>
    <div id="tableDiv"></div>    
    			
				
       
        
        
     
<script type="text/javascript">
$(document).ready(function () {
	queryList();
	
	 
});
    
    
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"bookingGuideListSelect.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchBookingGuideForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList(null,$("#searchPageSize").val());
}


/**
 * 重置查询条件
 */
function multiReset(){
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
	
}
</script>
</body>
</html>

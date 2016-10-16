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
   
</head>
<body>
    <div class="p_container" >
     
	    <ul class="w_tab">
	    	<li><a href="listCount.htm" class="selected">带团统计</a></li>
			<li><a href="listSelect.htm">带团查询</a></li>
			<li class="clear"></li>
	    </ul>

	    	<form id="searchBookingGuideForm">
	    	<div class="p_container_sub" >
			<div class="searchRow">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">团日期:</div>
	    			<div class="dd_right grey">
	    			<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value=""/>
						<input type="text"  name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text"  name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
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
	    			<div class="dd_left">是否已报账：</div>
	    			<div class="dd_right grey">
	    				<select name="state0">
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
		url:"bookingGuideListCount.do",
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
	queryList();
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

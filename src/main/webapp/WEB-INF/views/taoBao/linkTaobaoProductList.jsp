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
    <title>产品列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
     
</head>
<body>
  <div class="p_container" >
        <div class="p_container_sub" >
	    	<div class="searchRow">
	    	<form id="searchTaoBaoProductForm">
                <dd class="inl-bl">
                    <div class="dd_left">自编码：</div>
                    <div class="dd_right">
                    	<input name="outerId" type="text" class="w-100"/>
                    	<input id="tb_stock_id" type="hidden" name="stockId" value="${stockId }"/> 
                    	<input type="hidden" id="searchPage" name="page"  value=""/>
                    	<input type="hidden" id="searchPageSize" name="pageSize"  value=""/></div>
                    <div class="clear"></div>
                </dd>
                
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
		    			<input type="text" name="title" />
	    			</div>
                    <div class="clear"></div>
                </dd>
                
                <dd class="inl-bl">
	    			<div class="dd_left">套餐名称：</div>
	    			<div class="dd_right">
		    			<input type="text" name="pidName" />
	    			</div>
                    <div class="clear"></div>
                </dd>
                
                   <dd class="inl-bl">
                    <div class="dd_right">
                    	<button type="button" onclick="searchBtn();" class="button button-primary button-small">查询</button>
                    </div>
                    <div class="clear"></div>
                </dd>
                </form>
	    	</div>
	    	<div id="TaoBaoProductDiv">
						
			</div>
        </div>
    </div>
</body>
<script type="text/javascript">

function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);

	var options = {
		url:"findTaoBaoProduct.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#TaoBaoProductDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchTaoBaoProductForm").ajaxSubmit(options);	
}

function searchBtn(){
	queryList(null,$("#searchPageSize").val());
}
$(function () {
	queryList();
});

function reloadPage(){
	$.success('操作成功',function(){
		layer.closeAll();
		queryList($("#searchPage").val(), $("#searchPageSize").val());
	});
}
</script>
</html>

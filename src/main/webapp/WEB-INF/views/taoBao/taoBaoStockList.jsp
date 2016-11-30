<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>淘宝库存查询</title>
<%@ include file="../../include/top.jsp"%>

</head>
<body>
	
<div class="p_container">
	<form method="post" id="taoBaoSockForm">
	<div class="p_container_sub">
			<div class="searchRow">
					<input type="hidden" name="page" id="searchPage" value="${page.page}"> 
					<input type="hidden" name="pageSize" id="searchPageSize" value="${page.pageSize}">
					<ul >
						<li class="text"> 库存名称:</li>
						<li ><input type="text" name="stockName" id="stockName_id" value=""/> </li>
						<li class="text"> </li>
						<li >
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<button type="button" class="button button-primary button-small" onclick="tbStockAddBtn()">新增</button>
						<li class="clear"/>
						
					</ul>
			</div>
	</div>
	</form>
	
	<dl class="p_paragraph_content">
		<div id="contentTable"></div>
	</dl>
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
		url:"findTaoBaoStockList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#contentTable").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#taoBaoSockForm").ajaxSubmit(options);	
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

function tbStockAddBtn(){
	layer.open({
		type : 2,
		title : '新增淘宝库存',
		shadeClose : true,
		shade : 0.5,
		area: ['460px', '260px'],
		content: '<%=path%>/taobaoProect/toAddtBStockInfo.htm'
	});
}
</script>
</html>

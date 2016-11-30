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
    <title>淘宝产品列表【库存】选择</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
</head>
<body>
  <div class="p_container" >
  <form id="searchTaoBaoProductForm">
  <div class="p_container_sub">
			<div class="searchRow">
                 	<input type="hidden" name="stockDate" value="${stockDate }"/> 
                 	<input type="hidden" id="searchPage" name="page"  value="${pageBean.page }"/>
                 	<input type="hidden" id="searchPageSize" name="pageSize"  value="${pageBean.pageSize }"/>
               	库存名：<input type="text" name="stockName" class="w-100" value="${pageBean.stockName }" />
				自编码：<input type="text" name="outerId" class="w-100" value="${pageBean.outerId }" />
				产品名称：<input type="text" name="title" value="${pageBean.title }" />
	    		<button id="search_btn_id" type="button" onclick="searchBtn();" class="button button-primary button-small">查询</button>
                   
	</div>
	</div>
    </form>
	<div class="p_paragraph_content">
	    	<div id="TaoBaoProductDiv"> </div>
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
		url:"TaoBaoProductStock_Table.do",
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
	queryList(1,$("#searchPageSize").val());
}
$(function () {
	searchBtn();
});


</script>
<script type="text/javascript">
document.onkeydown = function (e) { 
	var theEvent = window.event || e; 
	var code = theEvent.keyCode || theEvent.which; 
	if (code == 13) { 
		$("#search_btn_id").click(); 
	} 
}
</script>
</html>

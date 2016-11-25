<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>新增淘宝库存</title>
<%@ include file="../../include/top.jsp"%>

</head>
<body>
	<div class="p_container">
	<form method="post" id="taoBaoUpdateSockForm">
	<div class="p_container_sub">
			<div class="searchRow">
					<ul >
						<li class="text"> </li>
						<li class="text"> 库存名称：</li>
						<li ><input style="width: 200px;" type="text" name="stockName" id="stockName_id" value=""/> </li>
						
					</ul>
					<ul >
						<li class="text"> </li>
						<li class="text"> 提前归零天数：</li>
						<li ><input style="width: 200px;" type="text" name="clearDayReset" id="clearDayReset_id" value=""/> </li>
						
					</ul>
					<ul >
						<li class="text"> </li>
						<li class="text"> 备注：</li>
						<li ><input style="width: 200px;" type="text" name="brief" id="brief_id" value="${taobaoStockBean.brief }"/> </li>
						
					</ul>
			</div>
	</div>
			<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
				<button type="button" onclick="toUpdateTbStock()" class="button button-primary button-small">保存</button>
				<button type="button" onclick="closeStock()" class="button button-primary button-small">关闭</button>
			</div>
	</form>
</div>
</body>
<script type="text/javascript">

function toUpdateTbStock() {
	var stockName_id = $("#stockName_id").val();
	var clearDayReset_id = $("#clearDayReset_id").val();
	var brief_id = $("#brief_id").val();
	
	$.ajax({
		type : "post",
		url : "<%=path%>/taobaoProect/saveTaobbaoStock.do",
		data:{stockName:stockName_id,clearDayReset:clearDayReset_id,brief:brief_id},
		dataType : "json",
		success : function(data) {
			if (data.success == '1') {
				$.success('保存成功！', function(){
					//queryList($("#searchPage").val(), $("#searchPageSize").val());
					parent.reloadPage();
				});
			}
		},
		error : function() {
			parent.$.error('系统异常，请与管理员联系');
		}
	});
	
	
}

/* 关闭 */
function closeStock(){
	var index = parent.layer.getFrameIndex(window.name);
	parent.layer.close(index);
}
</script>
</html>
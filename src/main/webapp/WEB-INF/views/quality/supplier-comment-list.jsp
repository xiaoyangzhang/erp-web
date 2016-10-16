<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商家评论</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>
	<div class="p_container">
		<li>${supplierName} ${supplierEnName}</li>
		<ul id="verifyTabs" class="w_tab">
			<li><a href="supplierCommentList.htm"  class="selected">评论列表</a></li>
			<li><a href="supplierTagList.htm" >印象标签列表</a></li>
			<li class="clear"></li>
		</ul>

		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="groupId" id="groupId"  value="${groupId }" />
			<input type="hidden" name="supplierId" id="supplierId"  value="${supplierId }" />
			<input type="hidden" name="sl" value="com.yihg.supplier.dao.SupplierCommentMapper.selectSupplierCommentListPage" />
			<input type="hidden" name="rp" value="quality/supplier-comment-list-table" />
			<input type="hidden" name="svc" value="commonSupplierService"  />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">关键字:</li>
						<li><input name="theKey" type="text" /></li>
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="查询"></li>
					</ul>
				</div>
			</div>
		</form>
	<div id="tableDiv"></div>
	<div id="addReplyDiv"></div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

	function queryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		if (!pagesize || pagesize < 1) {
			pagesize = 10;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);

		var options = {
			url : "<%=staticPath%>/quality/supplierCommentList.do",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#tableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#queryForm").ajaxSubmit(options);
	}
	
	$(function() {
		queryList();
	});
	
function updateComment(id,state){
		
		$.post("updateCommentState.do", {"id": id,"state":state}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success(data.msg);
				queryList();
			}else{
				$.error(data.msg);
			}
		});
	}
	
	
function addReply(id) {
	
	var data = {};
	data.id = id;
 	$("#addReplyDiv").load("addReply.htm", data);
	
	layer.open({
		type : 1,
		title : '回复',
		closeBtn : false,
		area : [ '400px', '300px' ],
		shadeClose : false,
		content : $("#addReplyDiv"),
		btn : [ '确定', '取消' ],
		yes : function(index) {
			submitReply(index,id);
			layer.close(index);
			queryList();
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

function submitReply(index,id){
	var reply=$("#replyMsg").val();
	$.post("saveReply.do",  {"reply": reply,"id": id}, function(data){
		data = $.parseJSON(data);
		if(data.success == true){
			$.success(data.msg);
		}else{
			layer.msg(data.msg, {icon: 5});
		}
	});
}
	
</script>
</html>
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
			<li><a href="supplierCommentList.htm"  >评论列表</a></li>
			<li><a href="supplierTagList.htm" class="selected">印象标签列表</a></li>
			<li class="clear"></li>
		</ul>

		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="groupId" id="groupId"  value="${groupId }" />
			<input type="hidden" name="supplierId" id="supplierId"  value="${supplierId }" />
			<input type="hidden" name="sl" value="com.yihg.supplier.dao.SupplierCommentMapper.selectSupplierTagListPage" />
			<input type="hidden" name="rp" value="quality/supplier-tag-list-table" />
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
	<div id="addVerifyRecordDiv"></div>
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
			url : "../common/queryListPage.htm",
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
	
function updateTag(name,state){
	alert(111);
		$.post("updateTagState.do", {"name": name,"state":state}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success(data.msg);
				queryList();
			}else{
				$.error(data.msg);
			}
		});
	}
</script>
</html>
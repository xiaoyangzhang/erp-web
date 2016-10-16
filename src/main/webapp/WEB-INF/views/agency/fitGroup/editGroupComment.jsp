<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团编辑</title>
<%@ include file="../../../include/top.jsp"%>
<style>
p.comment_title {margin: 10px 0 3px 20px; font-weight:bold;}
textarea {height:150px; width:80%; margin-left:20px;}
</style>
<script>
function submitComment(){
	var data = {groupId: ${group.id}, 
		groupComment: $("#groupComment").val(),
		groupNotice: $("#groupNotice").val()
	};
	YM.post("saveGroupComment.do", data, function(){
		$.success("操作成功");
	});
}
</script>
</head>
<body>
<div class="p_container">
<div class="p_container_sub">
	<p class="p_paragraph_title"><b>散客团：${group.groupCode}</b></p>
	<p class="comment_title">出团说明：</p>
	<textarea id="groupComment">${comment.groupComment }</textarea>
	<p class="comment_title">注意事项：</p>
	<textarea id="groupNotice">${comment.groupNotice }</textarea>
	<p class="comment_title"><button class="button button-primary button-small" onclick="javascript:submitComment();">保存</button></p>
</div>
</div>
</body>
</html>
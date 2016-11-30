<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>发送消息</title>
</head>
<%@ include file="../../../include/top.jsp"%>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
<body>
	<div>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">
					<i class="red">* </i>标题：
				</div>
				<div class="dd_right">
					<input class="IptText300" id="msg_title" type="text" />
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">
					<i class="red">* </i>内容：
				</div>
				<div class="dd_right">
					<textarea id="msg_info" style="width: 300px; height: 150px; overflow-y: hidden;"></textarea>
				</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">
					<i class="red">* </i>接收人员：
				</div>
				<input id="operatorName" name="operatorName" type="text" stag="userNames" value="" style="width: 300px" readonly
					onclick="showUser();"  /> 
					<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value="" />
			</dd>
		</dl>
	</div>
</body>
<script type="text/javascript">
$(function(){
    $("#operatorName").click(function() {
        $("#divUser").attr("style","position:fixed;left:130px; top: 5px");
    });
});
</script>
</html>
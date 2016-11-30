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
<title>消息详细</title>
</head>
<%@ include file="../../../include/top.jsp"%>
<body>
	<div>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">标题：</div>
				<div class="dd_right">${msg.msgTitle}</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">内容：</div>
				<div class="dd_right">${msg.msgText}</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">发送人：</div>
				<div class="dd_right">${msg.operatorName}</div>
				<div class="clear"></div>
			</dd>
			<dd>
				<div class="dd_left">发送时间：</div>
				<div class="dd_right">${msg.createTime}</div>
				<div class="clear"></div>
			</dd>
		</dl>
	</div>
</body>
</html>
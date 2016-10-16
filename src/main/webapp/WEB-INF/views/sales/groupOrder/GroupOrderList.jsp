<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>未并团列表</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>

	<div class="p_container">
		<div id="tabContainer">
			<ul class="w_tab">
				<li><a href="#list_search" onclick="loading(0)"
					class="selected">未并团</a></li>
				<li><a href="#list_kaifang" onclick="loading(1)" class="">已并团</a></li>
				<li class="clear"></li>
			</ul>

			<iframe class="p_container_sub" id="list_search" src="" width="100%"
				height="1000px"></iframe>
			<iframe class="p_container_sub" id="list_kaifang"
				src="" width="100%" height="1000px"></iframe>

		</div>
		<!--#tabContainer结束-->
	</div>
	<script type="text/javascript">
		$(function() {
			$("#tabContainer").idTabs();
		});

		var loading = function(type) {
			if (type == 0) {
				if ($("#list_search").attr("src") == '') {
					$("#list_search").attr("src", "toNotGroupList.htm?reqType=0");
				}
			} else {
				if ($("#list_kaifang").attr("src") == '') {
					$("#list_kaifang").attr("src", "toYesGroupList.htm?reqType=0");
				}
			}
		}
	</script>

</body>
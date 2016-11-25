<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>淘宝单统计</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
	<div class="p_container">
		<div id="tabContainer">
			<ul class="w_tab">
				<li><a href="#list_search" onclick="loading(0)" class="selected">店铺销售统计</a></li>
				<li><a href="#list_search1" onclick="loading(1)" class="">预售产品统计</a></li>
				<li><a href="#list_search2" id="bookingDetail" onclick="loading(2)" class="">非预售产品统计</a></li>
				<li><a href="#list_search3"  onclick="loading(3)" class="">客服销售统计</a></li>
				<li class="clear"></li>
			</ul>

			<iframe class="p_container_sub" id="list_search" src="" width="100%"
				height="1000px"></iframe>
			<iframe class="p_container_sub" id="list_search1"
				src="" width="100%" height="1000px"></iframe>
			<iframe class="p_container_sub" id="list_search2"
				src="" width="100%" height="1000px"></iframe>
			<iframe class="p_container_sub" id="list_search3"
				src="" width="100%" height="1000px"></iframe>

		</div>
		<!--#tabContainer结束-->
	</div>
	<script type="text/javascript">
		$(function() {
			$("#tabContainer").idTabs();
		});

		var loading = function(num) {
			if (num == 0) {
				if ($("#list_search").attr("src") == '') {
					$("#list_search").attr("src", "shopSalesStatistics.htm");
				}
			} else if(num==1){
				if ($("#list_search1").attr("src") == '') {
					$("#list_search1").attr("src", "presellProductStatistics.htm");
				}
			}
			 else if (num==2) {
				if ($("#list_search2").attr("src") == '') {
					$("#list_search2").attr("src", "notPresellProductStatistics.htm");
				}
			}
			else {
				if ($("#list_search3").attr("src") == '') {
					$("#list_search3").attr("src", "saleOperatorSalesStatistics.htm");
				}
			} 
		} ;
	</script>

</body>
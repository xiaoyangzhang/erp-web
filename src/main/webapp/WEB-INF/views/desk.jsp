<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<html>
<head>
<title>云旅游ERP系统</title>
<%@ include file="../include/top.jsp"%>
<style type="text/css">
  	.index_conbox{margin: 100px 50px;width: 1000px;}
  	.index_conbox ul{overflow: hidden;}
  	.index_conbox ul li{float: left;margin: 20px 30px; text-align: center;}
  	.index_conbox ul li a{display: block;width: 250px;height: 150px;border: solid 1px #E7EFF1;border-radius: 3px;color: #666666;}
  	.index_conbox ul li a img{margin-top: 10px; width: 90px;height: 90px;}
  	.index_conbox ul li a p{margin-top: 10px; font-size: 20px;}
  </style>
</head>
<body onresize="onResize_AutoHeight()">
	<div class="p_container" >
		<div class="index_conbox">
			<ul>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-1.png"/>
						<p><b>产品列表</b></p>
					</a>
				</li>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-2.png"/>
						<p><b>团队管理</b></p>
					</a>
				</li>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-3.png"/>
						<p><b>散客订单</b></p>
					</a>
				</li>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-4.png"/>
						<p><b>结算单</b></p>
					</a>
				</li>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-5.png"/>
						<p><b>收付明细</b></p>
					</a>
				</li>
				<li>
					<a href="####">
						<img src="<%=staticPath %>/assets/img/index-6.png"/>
						<p><b>用户管理</b></p>
					</a>
				</li>
			</ul>
		</div>
    </div>
</html>
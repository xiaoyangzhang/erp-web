<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<%@ include file="../include/path.jsp"%>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">
<title>旅道旅行社管理系统-登录</title>
<link href="<%=staticPath %>/assets/css/login/login.css" rel="stylesheet" />
<link href="<%=staticPath %>/assets/js/supersized/supersized.css" rel="stylesheet" />
<!-- Javascript -->
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/layer.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/extend/layer.ext.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/layer/message.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/supersized/supersized.3.2.7.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/login.js"></script>
<!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
<script type="text/javascript">
	if(top!=this){
		top.location = "<%=ctx%>/login.htm";
	}
</script>
<style>
#ft {font-size: 12px;color: #666;line-height: 22px;text-align: center;width: 100%;position: absolute;bottom: 0;padding-bottom: 5px;font-family: arial;}
#ft .g {color: #666;text-decoration: none;margin: 0;}
</style>
</head>
<body>
<div class="page-container">
	<form id="loginForm" action="login.do" method="post">
		<div class="loginBox">
			<div class="head">
				<p class="logo left"></p>
				<h1>旅道旅行社管理系统</h1>
			</div>
			<div class="clear"></div>
			<div class="row">
				<p class="ico_01 left"></p>
				<p class="right">
					<input type="text" id="code" name="code" placeholder="企业编号"
						maxlength="20" class="input inp_w1" value="${code }" />
				</p>
			</div>
			<div class="clear"></div>
			<div class="row">
				<p class="ico_02 left"></p>
				<p class="right">
					<input type="text" id="loginName" name="loginName" value="${loginName }"
						placeholder="用户名" maxlength="20" class="input inp_w1" />
				</p>
			</div>
			<div class="clear"></div>
			<div class="row">
				<p class="ico_03 left"></p>
				<p class="right">
					<input type="password" id="password" name="password"
						maxlength="20" placeholder="密码" class="input inp_w1"
						oncontextmenu="return false" onpaste="return false" />
				</p>
			</div>
			<div class="clear"></div>
			<div class="row">
				<p class="ico_04 left"></p>
				<p class="right">
					<input type="text" id="verify" name="verify" placeholder="验证码"
						class="input inp_w2" maxlength="4" oncontextmenu="return false"
						onpaste="return false" /> <img id="verifycode" style="width:94px;backgroud-color:white;"/><b class="ico_05" id="refreshcode"></b>
				</p>
			</div>
			<div class="clear"></div>
			<div class="row">
				<p class="rember">
					<label><b class="ico_checkUn" id="isRemember"></b><span
						class="txtRemember">记住用户名</span></label>
				</p>
			</div>
			<div class="clear"></div>
			<c:if test="${not empty errMsg}">
				<div class="row">
					<p class="rember" id="pHint"><span class="hint">${errMsg}</span></p>
	            </div>
	            <div class="clear"></div>
            </c:if>
			<input type="submit" id="btnSubmit" value="登 录" class="btn" />
		</div>
	</form>
</div>


<script type="text/javascript">
	$(function(){
		supersized('<%=staticPath%>');
	});
</script>
<div id='ft'>

&nbsp;©&nbsp;<%=Calendar.getInstance().get(Calendar.YEAR) %> 深圳全禾巨  - <a href="http://www.miibeian.gov.cn" target="_blank" class="g">粤ICP备15082149号-1</a>
</div>
</body>
</html>

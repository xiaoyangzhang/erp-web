<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body style="margin: 0 auto">
	<div class="navbar navbar-default" id="navbar">
		<%@ include file="/WEB-INF/include/header.jsp"%>
	</div>
	
	<div class="main-container" id="main-container">
		

		<div class="main-container-inner">

			<a class="menu-toggler" id="menu-toggler" href="#"> <span
				class="menu-text"></span>
			</a>

			<%@ include file="/WEB-INF/include/left.jsp"%>
			<div class="main-content">
				<div class="breadcrumbs" id="breadcrumbs">
							<ul class="breadcrumb">
						<li><i class="icon-home home-icon"></i> <a href="#">首页</a></li>
					</ul>
				</div>

				<div>
					<iframe name="mainFrame" id="mainFrame" frameborder="0"
						src="" style="margin: 0 auto; width: 100%; height:800px;"></iframe>
				</div>

			</div>
		</div>
		<!-- /.main-container-inner -->

		<a href="#" id="btn-scroll-up"
			class="btn-scroll-up btn btn-sm btn-inverse"> <i
			class="icon-double-angle-up icon-only bigger-110"></i>
		</a>
	</div>


</body>
</html>


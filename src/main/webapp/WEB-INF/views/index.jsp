<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<html>
<head>
<title>云旅游ERP系统</title>
<%@ include file="../include/top.jsp"%>
<script type="text/javascript" src="<%=staticPath %>/assets/js/tabslide.js"></script>
</head>
<body onresize="onResize_AutoHeight()">
	<div class="head">
		<div class="logo">
			<span class="fl mt-5"><img src="<%=ctx%>/assets/img/logo.png"></span>
			<span class="logo-word fl">旅道 云旅游ERP系统</span>
		</div>
		<div class="msg-title">
			<span class="mr-20 fl"><em class="re-icon icon"></em>返回官网</span> <span
				class="mr-20 fl">帮助</span> <span class="mr-20 fl">通讯录</span><span
				class="mr-50 fl"><a href="images/v_home" target="_blank"
				style="color: #d8dee1">图片空间</a></span> <span class="fl pr-20 sms"> <span
				class="fl">消息</span> <em class="ml-10 icon yellow-icon"></em> <strong
				class="num">12</strong>
				<ul class="newDown">
					<li>公告</li>
					<li>内容</li>
					<li>私信</li>
				</ul>
			</span> <span class="fl mr-10"><span class="fl">提醒</span><em
				class="ml-10 icon yellow-icon"></em><strong class="num">12</strong></span>
			<span class="fl name"> <span class="fl mt-3 mr-10"> <img
					src="<%=ctx%>/assets/img/head-img.png">
			</span> <span class="fl mr-10">${userSession.name }</span> <em class="icon icon-down"></em>
				<ul class="nameDown">
					<li><a class="def" title="修改密码" href="#" onclick="editPass('${userSession.employeeId}','${userSession.name}')">修改密码</a></li>
					<li><a class="def" title="修改个人资料" href="#" onclick="editProfile()">个人资料</a></li>
					<li><a href="logout.htm">退出</a></li>
				</ul>
			</span>
		</div>
	</div>
	<!--end head-->
	<table class="mbody">
		<tbody>
			<tr>
				<td class="left_Menu">
					<div class="left_Menu_con">
						<c:forEach items="${userSession.menuList }" var="menu">
							<dl>
								<dt>
									<em class="icon menu-icon"></em> <span class="fl">${menu.name }</span> <em
										class="icon sel-down"></em> <em class="cl"></em>
								</dt>
								<c:forEach items="${menu.childMenuList }" var="child">
									<dd>
										<a title='${child.name }' 
											lang='<%=ctx%>${child.url}'>${child.name }</a>
									</dd>
								</c:forEach>
							</dl>
						</c:forEach>
					</div>
				</td>
				<td class="right_Menu" style="vertical-align:top; height:100%;position:relative;">
					<div class="left-td-hide"></div>					
					<div class="list-title content-tabs">
				    	<a href="javascript:void(0)" class="tab-left J_tabLeft"></a>
				    	<a href="javascript:void(0)" class="tab-right J_tabRight"></a>
				    	
				    	<div class="J_menuTabs">  		
							<ul class="ul-style1 page-tabs-content" id="sysMenuTab">
					
							</ul>
				    	</div>
				    </div>
				</td>
			</tr>
		</tbody>
	</table>

</body>
<script type="text/javascript">
	LeftNav();
	headSlide();
	barInit();
	onResize_AutoHeight();
	
	//给弹出框赋值
	function editPass(id,name){	
		layer.open({
		    type: 2,
		    title: '修改密码',
		    skin: 'layui-layer-rim', //加上边框
		    area: ['480px', '260px'], //宽高
		    content: "employee/resetPwd.htm?id="+id,
		});	
	}
	
	//编辑个人资料
	function editProfile(){	
		layer.open({
		    type: 2,
		    title: '修改个人资料',
		    skin: 'layui-layer-rim', //加上边框
		    area: ['700px', '400px'], //宽高
		    content: "employee/editProfile.htm",
		});	
	}
	$(function () {
		$(".left-td-hide").click(function () {
			$(".left_Menu").fadeToggle(0);
			$(".left-td-hide").toggleClass("left-td-show")
		});
	})
	
</script>
<style type="text/css">
	.left-td-hide{
		position: absolute;
		top: 35%;
		left: 0;
		width: 10px;
		height: 80px;
		overflow: hidden;
		background: url(assets/img/icon-left-nav.jpg) no-repeat scroll;
		background-position: -3px 0;
		cursor: pointer;
		border-bottom-right-radius: 3px;
		border-top-right-radius: 3px; 
		color: #fff;
		font-size: 20px;
		}
	.left-td-show{
		background-position: -17px 0;
	}
</style>

</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<html>
<head>
<title>云旅游ERP系统</title>
<%@ include file="../include/top.jsp"%>
<script type="text/javascript" src="<%=staticPath%>/assets/js/tabslide.js"></script>
<script type="text/javascript" src="<%=staticPath%>/assets/js/toastr/toastr.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.cookie.js"></script>
<link href="<%=staticPath%>/assets/css/toastr/toastr.min.css" rel="stylesheet" type="text/css" />
</head>
<body onresize="onResize_AutoHeight()">
	<div class="head">
		<div class="logo">
			<span class="fl mt-5"><img src="<%=ctx%>/assets/img/logo.png"></span> 
			<span class="logo-word fl">旅道 云旅游ERP系统</span>
		</div>
		<div class="msg-title">
			<span class="mr-20 fl"><em class="re-icon icon"></em>返回官网</span> 
			<span class="mr-20 fl">帮助</span> <span class="mr-20 fl">通讯录</span>
			<span class="mr-50 fl">
			    <a href="images/v_home" target="_blank" style="color: #d8dee1">图片空间</a>
			</span> 
			<span class="fl pr-20 sms" onclick="showMsgList(0);">
			    <span class="fl">公告</span> 
			    <em class="ml-10 icon yellow-icon"></em>
                <strong class="num" id="totalCount">${readCount}</strong>
				<%-- <ul class="newDown">
					<li onclick="showMsgList(0);">公告 <label id="readCount">${readCount}</label></li>
					<li onclick="showMsgList(1);">业务 <label id="unreadCount">${unreadCount}</label></li>
					<li>私信</li>
				</ul> --%>
			</span> 
		    <span class="fl mr-10" onclick="showMsgList(1);">
		        <span class="fl">业务</span>
			    <em class="ml-10 icon yellow-icon"></em>
			    <strong class="num">${unreadCount}</strong>
			</span>
			<span class="fl name"> 
			    <span class="fl mt-3 mr-10"><img src="<%=ctx%>/assets/img/head-img.png"></span>
			<span class="fl mr-10">${userSession.name }</span> <em class="icon icon-down"></em>
				<ul class="nameDown">
					<li><a class="def" title="修改密码" href="#" onclick="editPass('${userSession.employeeId}','${userSession.name}')">修改密码</a></li>
					<li><a class="def" title="修改个人资料" href="#" onclick="editProfile()">个人资料</a></li>
					<li><a href="logout.htm">退出</a></li>
				</ul>
			</span>
		</div>
	</div>
	
	<div style="display: none">
	    <div class="form-group">
	        <input class="form-control" id="title" type="text">
	    </div>
	    <div class="form-group">
	        <textarea class="form-control" id="message" rows="3"></textarea>
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
									<em class="icon menu-icon"></em> <span class="fl">${menu.name }</span> <em class="icon sel-down"></em> <em class="cl"></em>
								</dt>
								<c:forEach items="${menu.childMenuList }" var="child">
									<dd>
										<a title='${child.name }' lang='<%=ctx%>${child.url}'>${child.name }</a>
									</dd>
								</c:forEach>
							</dl>
						</c:forEach>
					</div>
				</td>
				<td class="right_Menu" style="vertical-align: top; height: 100%; position: relative;">
					<div class="left-td-hide"></div>
					<div class="list-title content-tabs">
						<a href="javascript:void(0)" class="tab-left J_tabLeft"></a> <a href="javascript:void(0)" class="tab-right J_tabRight"></a>

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
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" 
      + request.getServerPort() + path + "/";
    String wsPath = "ws://" + request.getServerName() + ":" + request.getServerPort()
      + path + "/";
%>
<script type="text/javascript" 
  src="<%=staticPath%>/assets/js/sockjs/sockjs.min.js"></script>

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
		
		//建立socket连接 实时接收信息
	    var sock;
	    if ('WebSocket' in window) {
	      sock = new WebSocket("<%=wsPath%>socketServer");
	      } else if ('MozWebSocket' in window) {
	        sock = new MozWebSocket("<%=wsPath%>socketServer");
	      } else {
	        sock = new SockJS("<%=basePath%>sockjs/socketServer");
		}
		sock.onopen = function(e) {
			//console.log('open=' + e);
		};
		sock.onmessage = function(e) {
			//console.log('msg=' + e)
			
			// 更新数量
			$("#totalCount").html(parseInt($("#totalCount").html()) + 1);
			// 更新对应类型数量
			if (e.data.split("&")[2] == "0") {
			    $("#readCount").html(parseInt($("#readCount").html()) + 1);
			} else if (e.data.split("&")[2] == "1") { 
			    $("#unreadCount").html(parseInt($("#unreadCount").html()) + 1);
			}
			
			// e.data=title&orderId
            showMsg(e.data);
		};
		sock.onerror = function(e) {
			console.log('error=' + e);
		};
		sock.onclose = function(e) {
			//console.log('clo=' + e);
		}
	});
	
    var $toastlast;
	function showMsg(data) {
		var msg = "";
		var dataStr = data.split("&");
        toastr.options = {
        		  "closeButton": true,
        		  "debug": false,
        		  "newestOnTop": false,
        		  "progressBar": true,
        		  "positionClass": "toast-top-center",
        		  "preventDuplicates": false,
        		  "showDuration": "99999999",
        		  "hideDuration": "99999999",
        		  "timeOut": "99999999",
        		  "extendedTimeOut": "99999999",
        		  "showEasing": "swing",
        		  "hideEasing": "linear",
        		  "showMethod": "fadeIn",
        		  "hideMethod": "fadeOut"
        		}

        toastr.options.onclick = function () {
            if (dataStr[2] == "0") {
                showView(dataStr[3]);
            } else if (dataStr[2] == "1") {
                newWindow('查看订单', 'taobao/toEditTaobaoOrder.htm?id='+dataStr[1]+'&see=1');
            }
        };
        
        var $toast = toastr['warning'](msg, dataStr[0]);
        $toastlast = $toast;

        if(typeof $toast === 'undefined'){
            return;
        }
	}
	
	function showMsgList(msgType) {
		layer.open({
			type : 2,
            title : '消息查看',
            closeBtn : false,
            area : [ '1200px', '600px' ],
            shadeClose : true,
            content : 'msgInfo/showMsgList.htm?msgType='+msgType,
            btn: ['关闭'],
            cancel: function(index){
                layer.close(index);
            }
		});
	}

	function showView(mid) {
	    parent.layer.open({ 
            type : 2,
            title : '公告详细',
            closeBtn : false,
            area : [ '800px', '600px' ],
            shadeClose : true,
            content : '<%=staticPath%>/msgInfo/showMsgDetail.htm?mid='+mid,
            btn: ['关闭'],
            success: function() {
                $.ajax({
                    type : "post",
                    url : "<%=staticPath%>/msgInfo/modifyStatus.do",
                    data : {
                        midId : mid
                    },
                    dataType : "json"
                });
            },
            cancel: function(index){
                layer.close(index);
            }
        });
	}
</script>
<style type="text/css">
.left-td-hide {
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

.left-td-show {
	background-position: -17px 0;
}
</style>

</html>

<script type="text/javascript">
	(function(){
		//防止多个帐号登录同一个浏览器时 用户操作数据会串掉
		$(document).on("mouseover",function(e){
			$.cookie("YIHG_ERP_USER_SESSION",yihg_erp_web_config["yihg_erp_user_token"]);
		});
	})();
</script>
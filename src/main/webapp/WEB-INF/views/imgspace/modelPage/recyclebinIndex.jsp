<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="/WEB-INF/include/path.jsp" %>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<meta name="data-spm" content="a1z28">
<meta name="renderer" content="webkit">
<title>回收站</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <script src="${staticPath}/assets/imgspace/bootstrap/js/jquery-1.10.1.min.js" type="text/javascript"></script>
	<script src="${staticPath}/js/jquery-form.js" type="text/javascript"></script>
	<script src="${staticPath}/assets/imgspace/js/layer/layer.js" type="text/javascript"></script>
	<script src="${staticPath}/assets/imgspace/js/layer/laypage.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/assets/imgspace/js/recycle/recycle.css">

<!-- start seller-top css 3.1-->
<link rel="stylesheet" href="<%=staticPath%>/assets/imgspace/js/recycle/seller-global-min.css">
<!-- end seller-top css 3.1-->

<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/imgspace/js/recycle/top.css">
<script src="<%=staticPath%>/assets/imgspace/js/recycle/seller-global-min.js" charset="utf-8"></script>

<link rel="stylesheet" type="text/css" href="<%=staticPath%>/assets/imgspace/js/recycle/common.css">
<style type="text/css">
	.without-img {
	  background-image: url("../images/T10moYFwlcXXbtZ_ga-204-618.png");
	  background-repeat: no-repeat;
	  width: 100%;
	  height: 95px;
	  background-position: 14px -283px;
	}
	
	
</style>


<link href="<%=path%>/assets/imgspace/js/recycle/index-min.css" rel="stylesheet">
<script type="text/javascript" async="" src="<%=path%>/assets/imgspace/js/recycle/index.js"></script>
</head>
<body>
	<div id="wrap">
		<div class="top-pannel">
			<div class="not-manage-nav">
				<div class="navbar">
					<div class="navbar-inner">
						<a class="brand"
							href="">图片空间</a>
						<ul class="nav">
							<li><a
								href="">首&nbsp;&nbsp;页</a></li>
							<li class="active"><a
								href="">图片管理</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="main-pannel">

			<div class="page-bar clearfix">
				<div class="select-bar clearfix" id="J_SelectBar" style="display: none;">
						<li class="icon2 undo" ><a
							href="javascript:;" onclick="restoreImage();">还原</a></li>
						<li class="icon2 delete"><a
							href="javascript:;" onclick="perpetualDelRestore();">永久删除</a></li>
				</div>

			</div>
			<div class="pic-container list-show" id="J_PicContainer">
				<div id="J_Picture" class="clearfix ui-selectable">
					<div class="list-head clearfix">
						<div class="span1">名称</div>
						<div class="span2">类型</div>
						<div class="span2">图标</div>
						<div class="span2">删除时间</div>
					</div>
			 <div id="recycleBinPageId">
				<jsp:include page="recyclebinList.jsp"/>
			</div>
				</div>
			</div>
			<div class="page-footer" id="J_PageFooter">
				<div class="pager-container clearfix">
					<div class="pull-left" id="J_Pager">
						<div class="pagination pull-left ">
							<div id="paginator" ></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" name="imageId" id="imageId">
		<input type="hidden" name="imgpageNum" id="imgpageNum">
	</div>
	

	
<script type="text/javascript">
	layer.config({
	    extend: 'extend/layer.ext.js'
	});
	/** 选择图片**/
	function  openImageSpace(){
		layer.photos({
	        photos: '.photosDemo',
	        shade :0.3,
	        shift:-1,
	        area: ['600px', '400px'],
		    closeBtn: 2,
		    shadeClose :true
	    });
	}
	
	/** 选择元素**/
	function selectNode(obj){
		 showMenu();
		 var imageId = $(obj).attr("imageId");
		 console.log("imageId.."+imageId);
		 $("#imageId").val(imageId);
		var a = $(obj).siblings();
		$.each(a,function(name,value){
			$(obj).attr("class","item ui-widget-content ui-selectee ui-selected");
			if($(this).hasClass("item ui-widget-content ui-selectee")){
				$(this).attr("class","item ui-widget-content ui-selectee");
			}
		}); 
	}
	
	/** 还原回收站内容 **/
	function restoreImage(){
		var imageId = $("#imageId").val();
		var pageNum=$("#imgpageNum").val();
		layer.confirm('请确定是否还原选中的图片? 默认还原到系统根目录 ', {
			btn : [ '确定', '取消' ], //按钮
			shade : 0.3,
			title:"提示"
		},function(index) {
			$.ajax({
				url:"<%=path%>/images/restoreImage",
				type: "post",  
				data:{imageId:imageId},
				dataType: "json",
				async:false,  
				cache:false, 
				success:function(data){
					if(data.sucess){
						layer.close(index);
						if(data.sucess){
							paging(pageNum);
						}
					}
				},error:function(){
					layer.close(index);
					layer.msg('服务器未响应', {icon:3,time:1500}); 
				}
			});
		}, function(index) {
			layer.close(index);
		});
		
	}
	
	/**永久删除**/
	function perpetualDelRestore(){
		var imageId = $("#imageId").val();
		var pageNum=$("#imgpageNum").val();
		layer.confirm('请确定是否还原选中的图片?', {
			btn : [ '确定', '取消' ], //按钮
			shade : 0.3,
			title:"提示"
		},function(index) {
			$.ajax({
				url:"<%=path%>/images/perpetualDelRestore",
				type: "post",  
				data:{imageId:imageId},
				dataType: "json",
				async:false,  
				cache:false, 
				success:function(data){
					layer.close(index);
					if(data.sucess){
						paging(pageNum);
					}
				},error:function(){
					layer.close(index);
					layer.msg('服务器未响应', {icon:3,time:1500}); 
				}
			});
		}, function(index) {
			layer.close(index);
		});
		
		
		
		
	}
	
	/** 按钮控制**/
	function showMenu(){
		$("#J_SelectBar").attr("style","display: block;");
	}
	
</script>

<script type="text/javascript">
		/************************分页模块js ***************************/
		$().ready(function(){
		    var curr='${pb.page}'==''?1:'${pb.page}';
		    laypage({
			    cont: document.getElementById('paginator'), //容器。值支持id名、原生dom对象，jquery对象,
			    pages: '${pb.totalPage}',//总页数
			    curr:curr,
			    skin: '#666', //加载内置皮肤，也可以直接赋值16进制颜色值，如:#c00
			    groups: 7,  //连续显示分页数
			    jump: function(obj){ //触发分页后的回调
			    	if(obj.curr!=curr){	    		
			    		paging(obj.curr);
			    	}
			      $("#imgpageNum").val(obj.curr);
			    }
			});
		});
		 /************************分页模块js end***************************/
		 
	function paging(pageNum){
		$.ajax({ 
			type: "post", 
			url:"<%=path%>/images/recyclebinList", 
			data:{pageNum:pageNum},
			dataType:"html",
			success : function(data) { 
				$("#recycleBinPageId").html(data);
			},
			error: function(jqXHR, textStatus, errorThrown){
				layer.msg('服务器忙，请稍后再试!', {icon:3,time:1500}); 
	    	}
	    }); 
    }
</script>

</body>
</html>
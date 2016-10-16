<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>图片管理</title>
<%@include file="/WEB-INF/views/imgspace/include/base.jsp" %>
<script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/jqueryZclip/jquery.zclip.min.js" ></script>
<link href="<%=staticPath %>/assets/imgspace/css/common.css" rel="stylesheet" type="text/css">
<link href="<%=staticPath %>/assets/imgspace/css/manage.css" rel="stylesheet" type="text/css">
 <link href="<%=staticPath %>/assets/imgspace/css/imagesSpace.css" type="text/css" rel="stylesheet">
 <style type="text/css">
 	.modal-footer {
	  border-top: 0;
	  margin-top: 250px;
	}
 </style>
</head>


<body>
<div id="wrap">
    <div class="top-pannel" style="display:none;">
			<div class="not-manage-nav">
				<div class="navbar">
					<div class="navbar-inner">
						<a class="brand"
							href="v_home">图片空间</a>
						<ul class="nav">
							<li><a
								href="<%=ctx %>/index.htm">首&nbsp;&nbsp;页</a></li>
							<li class="active"><a
								href="v_home">图片管理</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
    <div class="left-pannel">
        <div class="tree-container">
            <h2 class="head">图片目录</h2>
            <div class="tree-handle" style="display:none;">
                <div class="search-tree">
                    <input id="J_search_folder" type="search" placeholder="按文件夹名称实时搜索">
                    <input type="button" class="search-btn">
                </div>
            </div>
            <div id="J_MainTreeRoom" class="treeRoom">
                <ul id="J_MainTree" class="ztree">
                    <li id="J_MainTree_1" class="level0" tabindex="0" hidefocus="true" treenode=""><span id="J_MainTree_1_switch" title="" class="button level0 switch root_open" treenode_switch=""></span><a id="J_MainTree_1_a" class="level0 curSelectedNode" treenode_a="" onclick="floadDubble('0')" target="_blank" title="我的图片"><span id="J_MainTree_1_ico" title="" treenode_ico="" class="button ico_open"></span><span id="J_MainTree_1_span">我的图片</span></a>
                        <ul id="J_MainTree_1_ul" class="level0" >
                        </ul>
                    </li>
                </ul>
            </div>
            <div class="rightButton">
                <ul>
                    <li class="tree-add" onclick="javascript:goldlog.record('/tu.1.2','','','H1673831')"><span class="icon"></span><span>新建</span></li>
                    <li class="tree-move"><span class="icon"></span><span>移动</span></li>
                    <li class="tree-rename"><span class="icon"></span><span>重命名</span></li>
                    <li class="tree-delete"><span class="icon"></span><span>删除</span></li>
                </ul>
            </div>
        </div>
    </div>
    


    <div class="main-pannel">
    
       		<script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/layer/laypage.js"></script>
        <div class="tms"> </div>
        <div class="all-control-bar">
            <ol class="breadcrumb" id="J_Crumbs">
                <li class="active home"><i class="icon"></i>我的图片</li>
            </ol>
            <div class="control">
                <div class="control-buttons" id="J_UpAndNew">
                    <button type="button" class="btn btn-primary up" onclick="openUploadWin();" ><span class="up-icon"></span>上传图片/文档</button>
                    <button type="button" class="btn btn-default new" onclick="foald();"><span class="new-icon" ></span>新建文件夹</button>
                    <a type="button" href="<%=ctx %>/images/recyclebin" class="btn btn-default" style="display:none;"><span class="recycle-icon"></span>回收站</a> </div>
                <div class="search" id="J_SearForm">
                    <div class="search-form">
                        <input type="text" id="search-name" value="" class="form-control search-input"  placeholder="按文件夹名称/图片名称搜索" >
                        <input type="button" class="search-btn" data-spm-click="gostr=/tbimage;locaid=d4916829" onclick="toPage(1)">
                    </div>
                </div>
            </div>
        </div>
        <div class="page-bar clearfix">
            <div class="select-bar clearfix" id="J_SelectBar">
                <ul class="controlBar selected-controls" id="image_menu" style="display: none;">
                   <li class="delete" style="display: list-item;">
                        <a href="javascript:;" onclick="deleteImageNode();"><i class="icon"></i>删除<span class="line"></span></a>&nbsp;
                        <a href="javascript:;" onclick="openImageMarkPage();" style="display:none;"><i class="rename"></i>生成水印<span class="line"></span></a>&nbsp;
                        <a href="javascript:;" onclick="renameDialogFun();">重命名<span class="line"></span></a>&nbsp;
                        <a href="javascript:;" onclick="replaceDialogFun();">替换<span class="line"></span></a>&nbsp;
                        <a href="javascript:;" onclick="moveDialogFun();" style="display:none;">移动<span class="line"></span></a>
                    </li>
                </ul>
            </div>
            <div class="sort-bar" id="J_SortBar">
                <div class="sort my-dropdown">
                    <div class="drop-label">排序:</div>
                    
                        <div class="dropdown" id="J_Sort"> <a id="showOrder" class="dropdown-toggle down" fileds="CREATE_TIME" order="DESC" data-type="0">时间</a>
                        
                        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                            <li role="presentation"> <a role="menuitem" data-type="0" class="time down" href="javascript:void(0)" onclick="orderToPage('CREATE_TIME','DESC')" data-spm-click="gostr=/tbimage;locaid=d4916857">时间</a> </li>
                            <li role="presentation"> <a role="menuitem" data-type="1" class="time up" href="javascript:void(0)" onclick="orderToPage('CREATE_TIME','ASC')" data-spm-click="gostr=/tbimage;locaid=d4916853">时间</a> </li>
                            <li role="presentation"> <a role="menuitem" data-type="6" class="name down" href="javascript:void(0)" onclick="orderToPage('IMG_NAME','DESC')" data-spm-click="gostr=/tbimage;locaid=d4916869">名称</a> </li>
                            <li role="presentation"> <a role="menuitem" data-type="7" class="name up" href="javascript:void(0)" onclick="orderToPage('IMG_NAME','ASC')" data-spm-click="gostr=/tbimage;locaid=d4916873">名称</a> </li>
                        </ul>
                    </div>
                </div>
                <div class="btn-group show-type">
                    <button type="button" id="J_ShowList" class="btn btn-default" title="列表模式" data-spm-click="gostr=/tbimage;locaid=d4916845"><span class="list icon"></span></button>
                    <button type="button" id="J_ShowPic" class="btn btn-default" title="大图模式" data-spm-click="gostr=/tbimage;locaid=d4916849"><span class="big-pic icon active"></span></button>
                </div>
                <div class="page-msg" id="J_TopPagination"> </div>
            </div>
        </div>
        
        <div  id="content" ajaxPageUrl="<%=ctx %>/images/v_model">
        
        </div>
    
    </div>
    <input type="hidden" name="parentImageId" id="parentImageId">
</div>


 <link rel="stylesheet" href="<%=staticPath %>/assets/imgspace/js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css"/>
 <script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/zTree/jquery.ztree.core-3.5.js"></script>
 <script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/zTree/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript">

    
    jQuery(document).ready(function() {       

		   $.fn.zTree.init($("#J_MainTree_1_ul"), setting, ${dirs});
		   var treeObj = $.fn.zTree.getZTreeObj("J_MainTree_1_ul");
		   treeObj.expandAll(true);
		   floadDubble(0);
    });
    
    var href="<%=ctx %>/images/v_list?";
	function zTreeOnClick(event, treeId, treeNode) {
		var imageId = treeNode.id;
		//console.log("imageId..."+imageId);
		floadDubble(imageId);
	};
	
	var setting = {
			check: {
				enable: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			view: {
				showIcon: false,
				selectedMulti: false
		    },
		    callback:{
		    	onClick: zTreeOnClick
		    }
		};

	function reload(){
	    $.ajax({
			type:'post',
			url:href,
			error:function(){
				layer.msg('服务器忙，请稍后再试!', {icon:3,time:1500}); 
			},
			success:function(data){
				$("#content").html(data);
			}
		});
	}
    
	function floadDubble(imageId){
		$("#parentImageId").val(imageId);
		/*   $.ajax({
				type:'post',
				url:'${path}/images/v_model',
				data:"imgId="+imageId,
				dataType:"html",
				error:function(){ 
					$.error('服务器忙，请稍后再试！');
				},
				success:function(data){
					//$("#content").html(data);
					toPage(1); 	
				}
			});  */
		toPage(1); 		
		
	}
	
	
	$("#search-name").keypress(function(event){  
	    var keycode = (event.keyCode ? event.keyCode : event.which);  
	    if(keycode == '13'){  
	    	toPage(1); 
	    };
	}); 
	
	function orderToPage(field,order){
		
		if(field=='CREATE_TIME'){
			$("#showOrder").text("时间");
		}
		if(field=='IMG_NAME'){
			$("#showOrder").text("名称");
		}
		if(order=="DESC"){
			$("#showOrder").attr("class","dropdown-toggle down");
		}
		if(order=="ASC"){
			$("#showOrder").attr("class","dropdown-toggle up");
		}
		$("#showOrder").attr("fileds",field);
		$("#showOrder").attr("order",order);
		toPage(1);
		
	}
	
	
	
   	
    var toPage= function (page){
    	
        var parent_id = $("#parentImageId").val();
        
        var orderObj=$("#showOrder");
       
	    var data='imgId='+parent_id+'&page='+page+"&name="+$("#search-name").val()+"&sortFields="+orderObj.attr("fileds") +"&order="+orderObj.attr("order");
		var content=$("#content");
		//alert("content.attr(ajaxPageUrl)"+content.attr("ajaxPageUrl"));
		var ajaxPageUrl=content.attr("ajaxPageUrl")==undefined?"#":content.attr("ajaxPageUrl");
		$.ajax({ 
			type: "post", 
			url:ajaxPageUrl, 
			data:data,
			dataType:"html",
			success : function(msg) { 
				content.html(msg);				
				paginator();
			},
			error: function(jqXHR, textStatus, errorThrown){
				layer.msg('服务器忙，请稍后再试!', {icon:3,time:1500}); 
	    	}
	    }); 
	 };
	
	
	
</script>
</body>
</html>

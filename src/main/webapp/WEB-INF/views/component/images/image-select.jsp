<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<%@include file="/WEB-INF/include/top.jsp" %>
<link href="<%=ctx %>/assets/css/component/img-select.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="pop_opacity"></div>
	<div class="pop_Box">
		<div class="pop_main">
			<div class="pop_treeBox">
				<ul id="J_MainTree_1_ul" class="ztree" ></ul>			
			</div>
			<div class="pop_btnBox">
				<input type="hidden" id="showOrder" fileds="create_time" order="DESC"/>
		    	<span class="fl">排序 <select name="orderField" onchange="changeOrder(this)" ><option sortFiled="create_time" orderBy="DESC">按时间降序</option><option sortFiled="create_time" orderBy="ASC">按时间升序</option><option sortFiled="img_name" orderBy="DESC">按名称降序</option><option sortFiled="img_name" orderBy="ASC">按名称升序</option></select></span>   
		    	<span class="fl"><input type="text" id="search-name"  name="" value="" placeholder="输入关键字"><a href="javascirpt:toPage(1)" class="pop_search"></a></span>
		    	<span class="fr"><a href="javascript:openUploadWin()" class="button button-primary button-rounded button-small pop_upload">上传图片</a></span>
		    	<div class="clear"></div>
		    </div>
		    <div class="pop_uploadBox"  id="content" ajaxPageUrl="<%=ctx %>/component/imgList.do">
		    	
		    </div>
    	<input type="hidden" name="parentImageId" id="parentImageId">
    	</div>
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
    
    var href="<%=ctx%>/images/v_list?";
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
		toPage(1); 		
	}

	$("#search-name").keypress(function(event){  
	    var keycode = (event.keyCode ? event.keyCode : event.which);  
	    if(keycode == '13'){  
	    	toPage(1); 
	    };
	}); 
	
	function changeOrder(obj){
		var option = $(obj).find("option:selected");
		var sortField = option.attr("sortFiled");
		var orderBy = option.attr("orderBy");
		orderToPage(sortField,orderBy);
	}
	
	function orderToPage(field,order){
		$("#showOrder").attr("fileds",field);
		$("#showOrder").attr("order",order);
		toPage(1);
	}
   	
    var toPage= function (page){
        var parent_id = $("#parentImageId").val();
        var orderObj=$("#showOrder");
	    var data='imgId='+parent_id+'&page='+page+"&name="+$("#search-name").val()+"&sortFileds="+orderObj.attr("fileds") +"&order="+orderObj.attr("order");
	    //var data = "{imgId:"+parent_id+",page:"+page+",sortFields:'"+orderObj.attr("fileds")+"',order:'"+orderObj.attr("order");	      
		var content=$("#content");
		//alert("content.attr(ajaxPageUrl)"+content.attr("ajaxPageUrl"));
		var ajaxPageUrl=content.attr("ajaxPageUrl")==undefined?"#":content.attr("ajaxPageUrl");
		//console.log(ajaxPageUrl);
		$.ajax({ 
			type: "post", 
			url:ajaxPageUrl, 
			data:data,
			dataType:"html",
			success : function(msg) {						
				content.html(msg);
			},
			error: function(jqXHR, textStatus, errorThrown){
				layer.msg('服务器忙，请稍后再试!', {icon:3,time:1500}); 
	    	}
	    }); 
	 };
	 
	 
	 function getImgSelected(){
		var imgArr = new Array();
		$("#content .pop_imgDelete[lang='on']").each(function(){
			imgArr.push({name:$(this).attr("alt"),path:$(this).attr("path"),thumb:$(this).attr("thumb")});  
		});
		return imgArr;
	 }
	 
	 
	 /***********************上传模块js****************************/
	   //上传窗口对象	
	   var  uploadWin;
	   //打开上传窗口
	   function openUploadWin(){	
		   
		   var parent_id = $("#parentImageId").val();
		   var url="<%=ctx%>/images/toUploadPage?parentId="+parent_id;
		   
		   $.post(url, {}, function(str){
			   
			   uploadWin =   layer.open({
			        type: 1,
			        title:'上传图片/文档',
			        area: ['700px', '500px'],
			        content: str //注意，如果str是object，那么需要字符拼接。
			    });
			});
		};
		//关闭上传窗口
	    function closeUploadWin(){
	    	
	 	   layer.close(uploadWin);
	 	   
	 	  //toPage(1);//
	 	  //floadDubble($("#parentImageId").val());
	 	   
	    }
	    /***********************上传模块js end****************************/
</script>
</body>
</html>
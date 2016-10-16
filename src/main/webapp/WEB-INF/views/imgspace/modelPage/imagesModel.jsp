<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
 <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
 <%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>

<%@include file="/WEB-INF/include/path.jsp" %>
        <div class="pic-container" id="J_PicContainer" >
            <div id="J_Picture" class="clearfix ui-selectable" >
                <div class="list-head clearfix">
                    <div class="span1">名称</div>
                    <div class="span2">类型</div>
                    <div class="span2">尺寸</div>
                    <div class="span2">大小</div>
                    <div class="span2">是否引用</div>
                    <div class="span2">更新时间</div>
                </div>
                <c:forEach items="${pb.result}" var="data">
                	<c:if test="${data.type == 0}">
		                <div class="item ui-widget-content ui-selectee"
							parentId="${data.imgId}" onclick="selectNode(this);" fileName = "${fn:escapeXml(data.imgName)}"
							ondblclick="floadDubble('${data.imgId}');" imageType="0">
		                    <div class="folder">
		                        <div class="base-msg">
		                            <div class="folder-msg">
		                                <div class="without-img"></div>
		                            </div>
		                            <div class="folder-name" title="${fn:escapeXml(data.imgName)}">${fn:escapeXml(data.imgName)}</div>
		                            <input type="text" value="${fn:escapeXml(data.imgName)}">
		                        </div>
		                        <div class="out">文件夹</div>
		                        <div class="out"></div>
		                        <div class="out"></div>
		                        <div class="out"></div>
		                        <div class="out">${fn:escapeXml(data.createTime)}</div>
		                    </div>
		                </div>
		                		
                	</c:if>

			<c:if test="${data.type == 1}">
				<div class="item ui-widget-content" image_id="image_id" ondblclick="openImageSpace();" parentId="${data.imgId}" onclick="selectNode(this);" imageType="1" fileName="${fn:escapeXml(data.imgName)}">
					<div class="image">
						<div class="base-msg">
							<div class="img-container photosDemo">
								<img alt="${fn:escapeXml(data.imgName)}" title="双击查看"									 
									<c:choose>
										<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.doc') }">
											src="<%=staticPath %>/assets/imgspace/images/thumbnail-word.jpg"
										</c:when>
										<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.docx') }">
											src="<%=staticPath %>/assets/imgspace/images/thumbnail-word.jpg"
										</c:when>
										<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.pdf') }">
											src="<%=staticPath %>/assets/imgspace/images/thumbnail-pdf.png"											
										</c:when>
										<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.xls') }">
											src="<%=staticPath %>/assets/imgspace/images/thumbnail-excel.png"
										</c:when>
										<c:otherwise>
											<c:if test="${data.filePath==null }">
												layer-src="" src=""
											</c:if>
											<c:if test="${data.filePath ne null }">
											    layer-src="${images_source}${fn:escapeXml(data.filePath)}"											
											    src="${images_200}${cf:thumbnail(data.filePath,'200x200') }"
											</c:if>
										</c:otherwise>
									</c:choose>
								/>								
							</div>
							
							<div title="picture.jpg" class="img-name" >
								${fn:escapeXml(data.imgName)}
							</div>
							<input type="text" value="${fn:escapeXml(data.imgName)}">
							
							<div class="qout icon"></div>
							<ul class="handle clearfix" style="display:none;">
								<li title="预览图片"
									class="copy-pic" ><span class="icon open-image" id="copy-pic" ></span></li>
								<li title="复制链接"
									data-clipboard-text="${images_source}${fn:escapeXml(data.filePath)}"
									class="copy-link"><span class="icon copy-links"
									id="copy-link"></span></li>
								<li title="复制代码"
									data-clipboard-text="${images_source}${fn:escapeXml(data.filePath)}"
									data-clipboard-name="${fn:escapeXml(data.imgName)}"
									class="copy-code"><span class="icon copy-codes"
									id="copy-code"></span></li>
							</ul>
						</div>
					</div>
				</div>
			</c:if>
		</c:forEach>
            </div>
        </div>

        
         <!-- BEGIN 分页-->
	     <div class="page-footer">
			  <div class="pager-container clearfix" style="width: 100%;padding-left: -120%;height: 32px;padding-top: 5px;opacity:1;">
	                 <div  id="paginator" >
	                 
	                   
				     </div>
			  </div>
		 </div>
	    <!-- END  分页 -->

<div id="sysNodeList" style="display: none">
	<div class="grey_box Branch1">
		<form action="" method="post" id="myflaodForm">
			<input type="hidden" name="parentId" value="1">
			<div class="info_box">
				<div class="box332 ">
					<div class="box_title">文件夹名称：</div>
					<div class="box_text">
						<input type="text" class="text width120" id="fileName"
							name="fileName" />
					</div>
				</div>
				<br /> <br /> <br />
				<div class="box332 ">
					<input type="button" id="newflaod" class=" btns btn_yellow"
						value="确&nbsp;&nbsp;&nbsp;定" /> <input type="reset"
						id="clearSysNode" class=" btns btn_gray"
						value="取&nbsp;&nbsp;&nbsp;消" />
				</div>
			</div>
		</form>
		<input type="hidden" name="deleteImageId" id="deleteImageId">
		<input type="hidden" name="imageType" id="imageType">
	</div>
</div>


<input type="hidden" name="imgName" id="imgFileName">




<!-- 
	重命名
 -->
<div id="renameDialogDiv" style="display: none">
	<div class="grey_box Branch1">
		<form action="" method="post" id="renameDialogFrom">
			<div class="info_box">
				<div class="box332 ">
					<div class="box_title">文件名称：</div>
					<div class="box_text">
						<input type="text" class="text width120" id="imgName"
							name="imgName" />
					</div>
				</div>
				<br /> <br /> <br />
				<div class="box332 ">
					<input type="button" id="renameDialogBtn" class=" btns btn_yellow"
						value="确&nbsp;&nbsp;&nbsp;定" /> <input type="reset"
						id="closeRenameDialog" class=" btns btn_gray"
						value="取&nbsp;&nbsp;&nbsp;消" />
				</div>
			</div>
		</form>
	</div>
</div>






<div id="ImageMarkPageId" style="display: none;width: 500px;height: 600px;">
       <div style="margin-left: 30px;margin-top: 30px;">
            <form id="imageMakrFormId" enctype="multipart/form-data" >
                 <div>
                                        水印透明度:<input type="range" name="alpha" id="alphaId" value="30" style="width:100px;"/><span id="alphaValue"></span>
                 </div>
                 <br />
                  <div>
                                          上边距:<input type="number" name="positionWidth" value="57" style="width:50px;" id="positionWidth">
                  </div>
                   <br />
                  <div>
                                          下边距:<input type="number" name="positionHeight" value="89" style="width:50px;" id="positionHeight">
                  </div>
                   <br />
                   <div>
                                          水印图片width:<input type="number" name="iconImageWidth" value="80" style="width:50px;" id="positionWidth">
                  </div>
                   <br />
                  <div>
                                           水印图片height:<input type="number" name="iconImageHeight" value="80" style="width:50px;" id="positionHeight">
                  </div>
                  <div>  <span>水印状态:&nbsp;</span>
                         <input type="radio" name="status" value="1" id="qiyong" checked="checked"> <span>启用</span> &nbsp;
                         <input type="radio" name="status" value="0" id="jinyong"> <span>禁用</span>
                  </div>
                   <br />
                  <div>
                      <input type="file" name="iconPath" id="iconPath" >
                  </div>
                   <br />
                   <div style="display:none; width:300px;height: 300px;" id="icogId">
                     <img alt="" style="width:400px;height: 300px;" src="" id="iconImageId">
                  </div> 
                  <br />
                   <div>
                        <input type="button"  id="generateImageMark" value="水印预览" />
                       &nbsp;
                        <input type="button"  id="cancelImageMark" value="取消" />&nbsp;
                        <input type="button"  id="createIconImage" value="水印生成" style="display: none;" />
                   </div>
                   <input type="hidden" name="iconImagePath" id="iconImagePath">
            </form>
       </div>
    </div>


<!-- 文件替换html -->
<div id="replaceDialogDiv" style="display: none" >
    <div class="grey_box Branch1">
        <form id="replaceDialogFrom" enctype="multipart/form-data" method="post" action="replaceImage">
           <input type="hidden" name="imageId"  id="replaceImageId">
            <div class="info_box">
                <div class="box332 ">
                    <div class="box_title"> 文件名称：</div>
                    <div class="box_text">
                        <input type="file" name="iconPath" id="iconPath" >
                    </div>
                </div>
                <!-- <div class="box332 " style="display:none;">
                    <div class="box_title"> 是否使用水印：</div>
                    <div class="box_text">
                        <input type="checkbox" class="text width120" id="isUseLog"  name="isUseLog" />
                    </div>
                </div> -->
                <br /> <br /> <br />
                <div class="box332 ">
                    <input type="button" id="replaceDialogBtn" class=" btns btn_yellow"
                        value="确&nbsp;&nbsp;&nbsp;定" /> <input type="reset"
                        id="closeReplaceDialog" class=" btns btn_gray"
                        value="取&nbsp;&nbsp;&nbsp;消" />
                </div>
            </div>
        </form>
    </div>
</div>


<!-- 文件重命名 -->
<script type="text/javascript">

/******** rename start ***********/
var renameDialog;
function renameDialogFun(){
    $("#imgName").val($("#imgFileName").val());
    var imageId = $("#deleteImageId").val();
    console.log("imageId.."+imageId);
    if(imageId == null || imageId == ""){
        layer.msg('请选择要重命名的元素', {icon:2,time:1500}); 
        return false;
    } 
    renameDialog =  layer.open({
        type: 1,
        title: '重命名',
        area : ['auto','auto'],
        shadeClose: true,
        area: ['360px', '240px'],
        shade: 0.3,
        content: $('#renameDialogDiv')
    });
}
$("#renameDialogBtn").on("click",function(){
    var imgName = $("#imgName").val();
    var imageType = $("#imageType").val();
    var parentImageId = $("#parentImageId").val(); //父节点id
    var imageId = $("#deleteImageId").val();
    if(imgName == null || imgName == ""){
        layer.msg('名称不能为空', {icon:2,time:1500}); 
        return false;
    }
    $.ajax({
        url:"<%=ctx%>/images/imageRename",
        type: "post",  
        data:{imageId:imageId,imgName:imgName},
        dataType: "json",
        async:false,  
        cache:false, 
        success:function(data){
            if(data.success){
                layer.close(renameDialog);
	               layer.msg('重命名成功', {
						icon : 6,
						time : 1500
					});
					if (imageType == 1) {
						floadDubble(parentImageId);
					} else {
						window.location = window.location;
					}
				}
			},
			error : function() {
				layer.close(renameDialog);
				layer.msg('服务器未响应', {
					icon : 3,
					time : 1500
				});
			}
		});
	});
	$("#closeRenameDialog").on("click", function() {
		layer.close(renameDialog);
	});
	
	/******** rename end ***********/
	
	
	/******** replaceImage start ***********/
	var replaceDialog;
	function replaceDialogFun(){
		var imageId = $("#deleteImageId").val();
		var imageType = $("#imageType").val();
		//console.log("imageId.."+imageId);
	    if(imageId == null || imageId == ""){
	        layer.msg('请选择要替换的元素', {icon:2,time:1500}); 
	        return false;
	    } 
		if(imageType == 0){
			 layer.msg('只能替换图片', {icon:2,time:1500}); 
		     return false;
		}
	    replaceDialog =  layer.open({
	        type: 1,
	        title: '替换',
	        area : ['auto','auto'],
	        shadeClose: true,
	        area: ['360px', '240px'],
	        shade: 0.3,
	        content: $('#replaceDialogDiv')
	    });
	}
	
	$("#replaceDialogBtn").on("click",function(){
		$("#replaceImageId").val($("#deleteImageId").val());
		/* if($("#isUseLog").is(':checked')){
			$("#isUseLog").val("true");
		}else{
			$("#isUseLog").val("false");
		} */
		
		var parentImageId = $("#parentImageId").val();
		var options = {
                url: "<%=ctx%>/images/replaceImage",
                type: "post",
                dataType: 'json',
                cache:false,
                async: false,
                success:function(data){
                	 if(data.success){
                		 layer.msg('文件替换成功', {
     						icon : 6,
     						time : 1500
     					});
                	 	floadDubble(parentImageId);
                   	}
					layer.close(replaceDialog);
               },
               error:function(XMLHttpRequest, textStatus, errorThrown){
                   layer.msg('图片替换失败', {icon:3,time:1500}); 
                   layer.close(replaceDialog);
               }
           }
         $("#replaceDialogFrom").ajaxSubmit(options); 
         /* $("#replaceDialogFrom")[0].submit(); */
	  });
    
	
	$("#closeReplaceDialog").on("click", function() {
		layer.close(replaceDialog);
	});
	
	
	
	/******** replaceImage end ***********/
</script>


<script type="text/javascript">
    var imageMarkPage;
    /** 打开 生成水印的页面  **/
    function openImageMarkPage(){
         /* var imageId = $("#deleteImageId").val();
         console.log("生成水印的页面 ..."+imageId); */
      imageMarkPage = layer.open({
             type: 1,
             title: '生成水印',
             area : ['auto','auto'],
             shadeClose: true,
             shade: 0.3,
             content: $('#ImageMarkPageId')
      }); 
        
    }
    
     $("#alphaId").on("mouseup",function(){
         var alphaValue = $("#alphaId").val();
          $("#alphaValue").text(alphaValue+"%"); 
      });
      
    
    
    $("#generateImageMark").on("click",function(){
        
        var iconPath = $("#iconPath").val();
        console.log("iconPath.."+iconPath);
        if(iconPath == null || iconPath == ""){
            layer.msg('清先选择水印图片', {icon:3,time:1500}); 
            return false;
        }
        
        var options = {
                 url: "<%=ctx%>/imageMark/logo",
                 type: "post",
                 dataType: 'json',
                 cache:false,
                 async: false,
                 success:function(data){
                     if(data.success){
                        $("#icogId").attr("style","display:block");
                        $("#iconImageId").attr("src",data.icoImagePath);
                        $("#createIconImage").attr("style","display:block");
                        $("#iconImagePath").val(data.uploadFileUrl);
                    } 
                    
                },
                error:function(XMLHttpRequest, textStatus, errorThrown){
                    layer.msg('水印图片生成失败', {icon:3,time:1500}); 
                }
            }
        $("#imageMakrFormId").ajaxSubmit(options);
    }); 
    
    $("#cancelImageMark").on("click",function(){
        layer.close(imageMarkPage);
    });
    
    /** 水印生成 **/
    $("#createIconImage").on("click",function(){
        var options = {
             url: "<%=ctx%>/imageMark/createIcon",
             type: "post",
             dataType: 'json',
             cache:false,
             async: false,
             success:function(data){
                 if(data.success){
                    layer.msg('水印图片生成成功', {icon:6,time:1500}); 
                    layer.close(imageMarkPage);
                } 
            },
            error:function(XMLHttpRequest, textStatus, errorThrown){
                layer.msg('水印图片生成失败', {icon:3,time:1500}); 
            }
        }
        $("#imageMakrFormId").ajaxSubmit(options);
    });
    
   
    
</script>

<script type="text/javascript">

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
	


/************************分页模块js ***************************/

var  paginator=function(){	 
    var pages='${pb.totalPage}';
    var curr='${pb.page}'==''?1:'${pb.page}';
    laypage({
	    cont: document.getElementById('paginator'), //容器。值支持id名、原生dom对象，jquery对象,
	    pages: pages,//总页数
	    curr:curr,
	    skin: '#666', //加载内置皮肤，也可以直接赋值16进制颜色值，如:#c00
	    groups: 7,  //连续显示分页数
	    jump: function(obj){ //触发分页后的回调
	    	if(obj.curr!=curr){	    		
	    		toPage(obj.curr);
	    	}
	    }
	});
};

 /************************分页模块js end***************************/


</script>


<script type="text/javascript">

/** 选择元素**/
function selectNode(obj){
	$("#image_menu").attr("style","display:block;");
	var imageType = $(obj).attr("imageType");
	var parentId = $(obj).attr("parentId");
	var fileName = $(obj).attr("fileName");
	$("#imageType").val(imageType);
	$("#deleteImageId").val(parentId);
	$("#imgFileName").val(fileName);
	var a = $(obj).siblings();
	$.each(a,function(name,value){
		$(obj).attr("class","item ui-widget-content ui-selectee ui-selected");
		if($(this).hasClass("item ui-widget-content ui-selectee")){
			$(this).attr("class","item ui-widget-content ui-selectee ");
		}
	}); 
}

/** 删除所选择的节点 **/
function deleteImageNode(){
   var parentId = $("#deleteImageId").val();
   var parentImageId = $("#parentImageId").val();
   var imageType = $("#imageType").val();
   if(parentId == null || parentId == ""){
       layer.msg('请选择要删除的元素', {icon:2,time:1500}); 
       return false;
   } 
   layer.confirm('请确定是否删除选中文件夹及包含的所有图片? ', {
		btn : [ '确定', '取消' ], //按钮
		shade : 0.3,
		title:"提示"
	},function(index) {
		debugger
		$.ajax({
			url : "<%=ctx%>/images/imageDelete",
			type: "post",  
			data:{parentId:parentId},
			dataType: "json",
			async:false,  
			cache:false,
			success:function(data){
				if(data.success){
					layer.close(index);
					layer.msg('删除成功', {icon:6,time:1500}); 
					if(imageType == 1){
						floadDubble(parentImageId);
					}else{
						window.location = window.location;
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


/***************************************************/
	var nodeDialg;
	function foald(){
		nodeDialg =  layer.open({
            type: 1,
            title: '新建文件夹',
            area : ['auto','auto'],
            shadeClose: true,
            area: ['360px', '240px'],
            shade: 0.3,
            content: $('#sysNodeList')
        });
	}
	
	
	//设置enter键快捷查询
	$('#myflaodForm').find('input').keyup(function(event){
		if(event.keyCode == '13'){
			$("#newflaod").click();
		}
	});
	
	/** 新建文件夹**/
	$("#newflaod").on("click",function(){
		var fileName = $("#fileName").val();
		console.log("..."+$("#parentImageId").val());
		var imageId = $("#parentImageId").val();
		if(fileName == null || fileName == ""){
			layer.msg('名称不能为空', {icon:2,time:1500}); 
			return false;
		}
		
		$.ajax({
			url:"<%=ctx%>/images/newFile",
			type: "post",  
			data:{parentId:imageId,fileName:fileName},
			dataType: "json",
			async:false,  
			cache:false, 
			success:function(data){
				if(data.success){
					layer.close(nodeDialg);
					layer.msg('新建成功', {icon:6,time:1500}); 
					window.location = window.location;
				}
			},
			error:function(){
				layer.close(nodeDialg);
				layer.msg('新建失败', {icon:3,time:1500}); 
			}
		});
	});
	
	$("#clearSysNode").on("click",function(){
		layer.close(nodeDialg);
	});
</script>










<script type="text/javascript">


	$('.copy-links').zclip({
	    path: "<%=staticPath%>/assets/imgspace/js/jqueryZclip/ZeroClipboard.swf",
	    copy: function(){
	        return $(this).parent(".copy-link").attr("data-clipboard-text");  //$(".copy-link").attr("data-clipboard-text");
	},
	afterCopy: function(){//复制成功 
		layer.msg('链接复制成功', {icon:6,time:1500}); 
	} 
	});
	
	$('.copy-codes').zclip({ 
	    path: "<%=staticPath%>/assets/imgspace/js/jqueryZclip/ZeroClipboard.swf",
	    copy: function(){
	        return getImageCode(this);
	},
	afterCopy: function(){//复制成功 
	    layer.msg('代码复制成功', {icon:6,time:1500}); 
	} 
	});
	
	$(".copy-pic").click(function(){
		var url = $(this).parent().parent().find(".photosDemo img").attr("layer-src");
		layer.open({
		    type: 2,
		    title: false,
		    closeBtn: false,
		    area: ['600px', '400px'],
		    skin: 'layui-layer-nobg', //没有背景色
		    shadeClose: true,
		    content: url
		});
	})
	
	function getImageCode(thethis){
		 var imageName =  $(thethis).parent(".copy-code").attr("data-clipboard-name");     
		 var iamgeUrl =   $(thethis).parent(".copy-code").attr("data-clipboard-text");   
		 var imageCode = '<img src="'+iamgeUrl+'" alt=" '+ imageName + '"/>';
		 return imageCode;
	}
</script>


<script type="text/javascript">
	/* function newfolder() {
		layer.msg('代码复制成功', {icon:6,time:1500}); 
	} */
	
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
		        area: ['700px', '600px'],
		        content: str //注意，如果str是object，那么需要字符拼接。
		    });
		});
	};
	//关闭上传窗口
    function closeUploadWin(){
    	
 	   layer.close(uploadWin);
 	   
 	  //toPage(1);//
 	  floadDubble($("#parentImageId").val());
 	   
    }
    /***********************上传模块js end****************************/
    
</script>



<!-- 
	文件移动
 -->
<script type="text/javascript">
    var moveDialog;
	function moveDialogFun(){
		$("#moveDialogDivId").append(html);
		$.ajax({ 
			type: "post", 
			url:"<%=ctx%>/images/openTreeWindow", 
			dataType:"html",
			success : function(data) { 
				$("#moveDialogDivId").html(data);
			},
			error: function(jqXHR, textStatus, errorThrown){
				layer.msg('服务器忙，请稍后再试!', {icon:3,time:1500}); 
	    	}
	    }); 
		
		moveDialog = layer.open({
	        type: 1,
	        title: '移动文件',
	        area : ['350px','510px'],
	        shadeClose: true,
	        shade: 0.3,
	        content: $('#moveDialogDivId')
	    });
		
		
	}
</script>
<input type="hidden" name="moveImageId" id="moveImageId"></input>
<div id="moveDialogDivId" style="display: none;">
	
</div>



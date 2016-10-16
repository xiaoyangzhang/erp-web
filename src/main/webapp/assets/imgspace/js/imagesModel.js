
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
                 url: "<%=path%>/imageMark/logo",
                 type: "post",
                 dataType: 'json',
                 cache:false,
                 async: false,
                 success:function(data){
                     if(data.sucess){
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
             url: "<%=path%>/imageMark/createIcon",
             type: "post",
             dataType: 'json',
             cache:false,
             async: false,
             success:function(data){
                 if(data.sucess){
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
    
   
    

layer.config({
    extend: 'extend/layer.ext.js'
});
/** 选择图片**/
function  openImageSpace(){
    layer.photos({
        photos: '.photosDemo',
        shade :0.5,
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





/** 选择元素**/
function selectNode(obj){
    var imageId = $(obj).attr("parentId");
    var imageType = $(obj).attr("imageType");
    $("#imageType").val(imageType);
    $("#deleteImageId").val(imageId);
    console.log(imageId);
    console.log("imageType.."+imageType);
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
   var imageId = $("#parentImageId").val();
   var imageType = $("#imageType").val();
   console.log("imageId"+parentId);
   console.log("imageType..ssds.."+imageType);
   console.log("parentId..ssds.."+parentId);
   layer.confirm('请确定是否删除选中文件夹及包含的所有图片? ', {
        btn : [ '确定', '取消' ], //按钮
        shade : 0.3,
        title:"提示"
    },function(index) {
        $.ajax({
            url : "<%=path%>/images/imageDelete",
            type: "post",  
            data:{parentId:parentId},
            dataType: "json",
            async:false,  
            cache:false,
            success:function(data){
                if(data.sucess){
                    layer.close(index);
                    layer.msg('删除成功', {icon:6,time:1500}); 
                    if(imageType == 1){
                        floadDubble(imageId);
                    }else{
                        window.location = "<%=path%>/images/v_home";
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
    
    $("#newflaod").on("click",function(){
    	alert(1);
        var fileName = $("#fileName").val();
        console.log("..."+$("#parentImageId").val());
        var imageId = $("#parentImageId").val();
        if(fileName == null || fileName == ""){
            layer.msg('名称不能为空', {icon:2,time:1500}); 
            return false;
        }
        
        $.ajax({
            url:"<%=path%>/images/newFile",
            type: "post",  
            data:{parentId:imageId,fileName:fileName},
            dataType: "json",
            async:false,  
            cache:false, 
            success:function(data){
                if(data.sucess){
                    layer.close(nodeDialg);
                    layer.msg('新建成功', {icon:6,time:1500}); 
                    //reload();
                    //floadDubble(imageId);
                    window.location = "<%=path%>/images/v_home";
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


    $('.copy-links').zclip({
        path: "<%=path%>/js/jqueryZclip/ZeroClipboard.swf",
        copy: function(){
            return $(this).parent(".copy-link").attr("data-clipboard-text");  //$(".copy-link").attr("data-clipboard-text");
    },
    afterCopy: function(){//复制成功 
        layer.msg('链接复制成功', {icon:6,time:1500}); 
    } 
    });
    
    $('.copy-codes').zclip({ 
        path: "<%=path%>/js/jqueryZclip/ZeroClipboard.swf",
        copy: function(){
            return getImageCode(this);
    },
    afterCopy: function(){//复制成功 
        layer.msg('代码复制成功', {icon:6,time:1500}); 
    } 
    });
    
    function getImageCode(thethis){
         var imageName =  $(thethis).parent(".copy-code").attr("data-clipboard-name");     
         var iamgeUrl =   $(thethis).parent(".copy-code").attr("data-clipboard-text");   
         var imageCode = '<img src="'+iamgeUrl+'" alt=" '+ imageName + '"/>';
         return imageCode;
    }


    /* function newfolder() {
        layer.msg('代码复制成功', {icon:6,time:1500}); 
    } */
    
    /***********************上传模块js****************************/
   //上传窗口对象 
   var  uploadWin;
   //打开上传窗口
   function openUploadWin(){    
       
       var parent_id = $("#parentImageId").val();
       var url="<%=path%>/images/toUploadPage?parentId="+parent_id;
       
       $.post(url, {}, function(str){
           
           uploadWin =   layer.open({
                type: 1,
                title:'上传图片',
                area: ['800px', '600px'],
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
    
    
    
    

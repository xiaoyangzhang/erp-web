<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<%@include file="/WEB-INF/include/path.jsp" %>

<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/imgspace/js/webuploader/webuploader.css" />
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/imgspace/js/webuploader/style.css" />
</head>
<body>
    <div id="wrapper">
        <div id="container">
            <!--头部，相册选择和格式选择-->

            <div id="uploader">
                <div class="queueList">
                    <div id="dndArea" class="placeholder">
                        <div id="filePicker"></div>
                        <p>或将文件拖到这里(支持上传图片、word、excel和pdf)</p>
                    </div>
                </div>
                <div class="statusBar" style="display:none;">
                    <div class="progress">
                        <span class="text">0%</span>
                        <span class="percentage"></span>
                    </div><div class="info"></div>
                    <div class="btns">
                        <div id="filePicker2"></div><div class="uploadBtn">开始上传</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
	    jQuery(document).ready(function() {       
			 if('${parentId}'==''){
				 $.warn("请先选择父级目录");
				 location.reload();
			 }
		});
	    
	    
        // 添加全局站点信息
       var BASE_URL = '<%=staticPath %>/assets/imgspace/js/webuploader';
       var UPLOAD_URL = '<%=ctx %>/js/ueditor/jsp/imageUp?parentId='+${parentId};
   
    </script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/webuploader/webuploader.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/webuploader/webuploaderhandler.js"></script>
</body>
</html>
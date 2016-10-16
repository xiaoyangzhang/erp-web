<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="/WEB-INF/include/path.jsp" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Ueditor</title>
<script src="<%=staticPath %>/assets/imgspace/bootstrap/js/jquery-1.10.1.min.js" type="text/javascript"></script>
</head>

<body>
     <div>
		<script id="editor"  type="text/plain" style="width:818px;">
        	  <p>请编辑商品详细信息</p>
    	</script>
	</div>	

</body>



<script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/ueditor/ueditor.config.js"></script>

<script type="text/javascript" src="<%=staticPath %>/assets/imgspace/js/ueditor/ueditor.all.js"></script>

<script type="text/javascript">
	//实例化编辑器
	/* var ue = new UE.ui.Editor();
	ue.render("editor");  */
	
	  var ue = UE.getEditor('editor', {
	        serverUrl: "<%=ctx %>/assets/imgspace/js/ueditor/jsp/imageUp1"
	    }); 
	
</script>
</html>

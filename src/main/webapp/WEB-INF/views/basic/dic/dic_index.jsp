<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta charset="UTF-8">
    <%@ include file="../../../include/top.jsp"%>
	<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=staticPath %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript">
		var setting = {
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					onClick: zTreeOnClick
				}
			};

			var zNodes = ${dicTypeJson};
			
			function zTreeOnClick(event, treeId, treeNode) {			    
			    var id=treeNode.id;
			    $("#frame").attr("src","dicList.htm?type="+id);
			};
			
			$(document).ready(function(){
				var t = $("#treeArea");
				$.fn.zTree.init(t, setting, zNodes);
							
			});
    </script>
</head>
<body>
	<div style="width:100%;height:100%;">
		<div style="float:left;width:200px;left:10px;position:absolute;top:20px;">
			<ul id="treeArea" class="ztree"></ul>
		</div>
		<div style="float:left;left:200px;position:absolute;top:20px;right:10px;bottom:10px;">
			<iframe id="frame" frameborder="0" scrolling="auto" style="width:100%;height:100%;" src=""></iframe>
		</div>
	</div>
</body>
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript">
		var setting = {
				data: {
					simpleData: {
						enable: true,
						idKey: "id",
						pIdKey: "pId",
						rootPId: 0
					}
				},
				callback: {
					onClick: zTreeOnClick
				}
			};

			var zNodes = ${orgJosnStr};
			
			function zTreeOnClick(event, treeId, treeNode) {			    
			    var id=treeNode.id;
			    $("#frame").attr("src","getOrg?orgId="+id);
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


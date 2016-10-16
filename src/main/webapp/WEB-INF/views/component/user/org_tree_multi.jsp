<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<script src="<%=ctx %>/assets/js/jquery-1.8.3.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
    <script type="text/javascript">
    var setting = {
    		check: {
    			enable: true,   			
    			chkStyle: "checkbox",
    			chkboxType: { "Y": "s", "N": "ps" }
    		},
    		data: {
    			simpleData: {
    				enable: true,
    				idKey: "id",
    				pIdKey: "pId",
    				rootPId: "0"
    			}
    		}
    	};
    	 
    	var zNodes =${orgJsonStr}; 
    	var treeObj;
    	$(document).ready(function() {
    		treeObj = $.fn.zTree.init($("#treeArea"), setting,zNodes );
    	});
    	
    	function getOrgList(){
    		var orgArray = new Array();
    		var nodes = treeObj.getCheckedNodes(true);    		
    		for (var i = 0; i < nodes.length; i++) {
    			var node = nodes[i];
    			var parentNode = node.getParentNode();
    			var name="";
    			if(parentNode){
    				name=parentNode.name+" > ";
    			}
    			name+=node.name;
    			orgArray.push({id:node.id,name:name});
    		}
    		return orgArray;
    	}
    </script>
</head>
<body>
	<div style="float:left;width:360px;height:390px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>	
</body>
</html>


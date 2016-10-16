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
    			chkboxType: { "Y": "ps", "N": "ps" }
    		},
    		data: {
    			simpleData: {
    				enable: true,
    				idKey: "id",
    				pIdKey: "pId",
    				rootPId: "0"
    			}
    		},
    		async:{
    			enable: false
    		}
    	};
    	 
    	var zNodes =${orgJsonStr}; 
    	var treeObj;
    	$(document).ready(function() {
    		treeObj = $.fn.zTree.init($("#treeArea"), setting,zNodes );
   			var nodes = treeObj.transformToArray(treeObj.getNodes());//获取所有选择的节点
       		/* for(var i=0;i<nodes.length;i++){    			
       		    if(nodes[i].isParent){
       		    	nodes[i].nocheck=true;   
       		    }
       		}
       		treeObj.refresh(); */
    		
    	});
    	
    	function getOrgList(){
    		var orgArray = new Array();
    		var nodes = treeObj.getCheckedNodes(true);    		
    		for (var i = 0; i < nodes.length; i++) {
    			var node = nodes[i];  	
    			//if(node.isParent == false){
	    		orgArray.push({id:node.id,name:node.name});    				
    			//}
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


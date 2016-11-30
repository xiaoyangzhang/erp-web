<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String ctx = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
    		view: {
				dblClickExpand: false
			},

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
    				rootPId: "o_0"
    			}
    		},
    		callback: {
    			onCheck: treeNodeOnCheck,
    			onClick: treeNodeOnClick
    		}
    	};
    	 

    	var zNodes =${orgUserJsonStr}; 
    	var treeObj;
    	$(document).ready(function() {
    		treeObj = $.fn.zTree.init($("#treeArea"), setting,zNodes );
    	});
    	
    	function getUserList(){
    		var userArray = new Array();
    		var nodes = treeObj.getCheckedNodes(true);    		
    		for (var i = 0; i < nodes.length; i++) {
    			var node = nodes[i];
    			if(node.type=="user"){
    				userArray.push({type:'user',id:node.employeeId});
    			}else{
    				userArray.push({type:'org',id:node.oid});
    			}
    		}
    		return userArray;
    	}
    	
    	function treeNodeOnCheck(event, treeId, treeNode){
    		if(treeNode.type=='user'){
    			setParentNode_uncheck(treeNode);
    		}else{
    			setChildNode_uncheck(treeNode);
    		}
    		treeObj.refresh();
    	}
    	function setParentNode_uncheck(curNode){
    		var parent = curNode.getParentNode();
			if(parent){
				parent.checked=false;
				setParentNode_uncheck(parent);
			}
    	}
    	function setChildNode_uncheck(curNode){
    		var subs = curNode.children;
    		if (subs){
	    		for(var i=0,len=subs.length; i<len; i++){
	    			if(subs[i].type=='user'){
	    				subs[i].checked=false;
	    			}else{
	    				setChildNode_uncheck(subs[i]);
	    			}
	    		}
    		}
    	}
    	
    	//点击节点时，收起来
    	function treeNodeOnClick(e,treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("treeArea");
			zTree.expandNode(treeNode);
    	}
    </script>
</head>
<body>
	<input type="hidden" name="employeeId" id="employeeId" value="${employeeId }" />
	<div style="float:left;width:360px;height:360px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>	
</body>
</html>


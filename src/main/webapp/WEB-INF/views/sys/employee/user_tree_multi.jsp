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
    				rootPId: "o_0"
    			}
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
    				userArray.push({employeeId:node.employeeId,pId:node.orgId,position:node.position,name:node.name,mobile:node.mobile,phone:node.phone,fax:node.fax});
    			}
    		}
    		return userArray;
    	}
    	
    </script>
</head>
<body>
<form action="" id="mainForm">
	<input type="hidden" name="employeeId" id="employeeId" value="${employeeId }" />
	<div style="float:left;width:360px;height:460px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>	
	</form>
</body>
</html>


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
    		var obj = {};
    		var userArray = new Array();
    		var nodes = treeObj.getCheckedNodes(true);    		
    		for (var i = 0; i < nodes.length; i++) {
    			var node = nodes[i];
    			if(node.type=="user"){
    				userArray.push({employeeId:node.employeeId});
    			}
    		}
    		obj.userArray = userArray;
    		obj.type="reverse";
    		return obj;
    	}
    	
    </script>
    <style type="text/css">    
    	ul{list-style:none;font-size:10px;padding:0px;margin:0px;}
    	.w_tab{height: 33px;line-height: 16px;margin-left: 10px;}
	    .w_tab li{ border: 1px solid #e7eff1;border-bottom:none; margin-right: 2px; background: url(<%=ctx%>/assets/img/tab_bk.gif) repeat-x;  float: left;}
	    .w_tab li.clear{ clear: both;border:none; margin-right: 0px; background: none;float: none; display: inline-block; }
	    .w_tab li a{display: block; color: #999999;text-align: center;   font-weight:bold; padding: 8px 13px}
	    .w_tab li a.selected {
	        height: 13px;
	        background: #ffffff none repeat scroll 0 0;
	        border-top: 4px solid #68c1e7;
	        color: #68c1e7;
	        position: relative;
	    }
    </style>
</head>
<body>
<ul class="w_tab">
			<li><a href="orgUserDateRightTree.htm?employeeId=${employeeId }">我看谁</a></li>
			<li><a href="orgUserDateRightTreeReverse.htm?employeeId=${employeeId }" class="selected" >谁看我</a></li>
	</ul>
<form action="" id="mainForm">
	<input type="hidden" name="employeeId" id="employeeId" value="${employeeId }" />
	<div style="float:left;width:360px;height:360px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>	
	</form>
</body>
</html>


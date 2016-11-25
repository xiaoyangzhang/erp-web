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
    			chkStyle: "radio",
    			radioType: "all"
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
    		loadTree();
    	});
    	
    	function loadTree(){
    		/* if(treeObj){
    			treeObj.destroy();
    		} */
    		if(typeof(zNodes)=="string")
    			zNodes = eval("("+zNodes+")");
    		treeObj = $.fn.zTree.init($("#treeArea"), setting,zNodes );
    	}
    	
    	function getUserList(){
    		var userArray = new Array();
    		var nodes = treeObj.getCheckedNodes(true);    		
    		for (var i = 0; i < nodes.length; i++) {
    			var node = nodes[i];
    			if(node.type=="user"){
    				userArray.push({id:node.oid,pos:node.pos,name:node.name,mobile:node.mobile,phone:node.phone,fax:node.fax});
    			}
    		}
    		return userArray;
    	}
    	
    	$(function(){
    		$("#btnQuery").click(function(){
    			var name = $.trim($("#name").val());
    			if(name){	    			
					$.post("orgUserTree.do",{name:name,type:'single'},function(data){
						if(data.success){
							zNodes = data.orgUserJsonStr;
							console.log(zNodes);
							loadTree();							
						}else{
							console.log(1);
						}
					},"json");
    			}
    		});
    		$("#btnReset").click(function(){
    			location.href="orgUserTree.htm?type=single";
    		});
    	});
    </script>
</head>
<body>
	<label style="font-size:12px;">名称：</label><input name="name" id="name" />
	<input type="hidden" name="type" id="type" value="single" />
	<input type="button" id="btnQuery" value="查询" />
	<input type="button" id="btnReset" value="重置" />
	<hr/>
	<div style="float:left;width:360px;height:360px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>	
</body>
<script type="text/javascript">
/* 回车事件  */
document.onkeydown = function (e) { 
	var theEvent = window.event || e; 
	var code = theEvent.keyCode || theEvent.which; 
	if (code == 13) { 
		$("#btnQuery").click(); 
	} 
}
</script>
</html>


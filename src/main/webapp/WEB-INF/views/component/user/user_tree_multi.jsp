<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<%@ include file="/WEB-INF/include/path.jsp"%>
	<script src="<%=ctx %>/assets/js/jquery-1.8.3.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=staticPath %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-form.js"></script>
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
    	var expIdArr = [];
    	$(document).ready(function() {    		
    		var expIds = $("#expIds").val();
    		if(expIds){
    			expIdArr = expIds.split(',');    			
    		}
    		loadTree();    		
    	});
    	
    	function loadTree(){
    		/* if(treeObj){
    			treeObj.destroy();
    		} */
    		if(typeof(zNodes)=="string")
    			zNodes = eval("("+zNodes+")");
    		treeObj = $.fn.zTree.init($("#treeArea"), setting,zNodes );
    		if(expIdArr.length>0){
    			var allUserNodes = treeObj.getNodesByParam("type","user");
       			for(var i=0;i<allUserNodes.length;i++){
       				var curNode = allUserNodes[i];
       				var nodeId = curNode.id;
       				var uid = nodeId.split('_')[1];
       				if($.inArray(uid,expIdArr)>-1){
       					treeObj.setChkDisabled(curNode,true);
       				}
       			}
    		}   			    		
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
    		
    		//console.log(userArray);
    		return userArray;
    	}   	
    	
    	$(function(){
    		$("#btnQuery").click(function(){
    			var name = $.trim($("#name").val());
    			if(name){	    			
					$.post("orgUserTree.do",{name:name,type:'multi'},function(data){
						if(data.success){
							zNodes = data.orgUserJsonStr;							
							loadTree();							
						}else{
							//console.log(1);
						}
					},"json");
    			}
    		});
    		$("#btnReset").click(function(){
    			location.reload();
    		});
    	});
    </script>
</head>
<body>
	<form id="mainForm">		
		<input type="hidden" name="expIds" id="expIds" value="${expIds }" />
		<label style="font-size:12px;">名称：</label><input name="name" id="name" />
		<input type="hidden" name="type" id="type" value="multi" />
		<input type="button" id="btnQuery" value="查询" />
		<input type="button" id="btnReset" value="重置" />
	</form>
	<hr/>
	<div style="float:left;width:360px;height:360px;">
		<ul id="treeArea" class="ztree"></ul>
	</div>
</body>
<script type="text/javascript">
document.onkeydown = function (e) { 
	var theEvent = window.event || e; 
	var code = theEvent.keyCode || theEvent.which; 
	if (code == 13) { 
		$("#btnQuery").click(); 
	} 
}
</script>
</html>


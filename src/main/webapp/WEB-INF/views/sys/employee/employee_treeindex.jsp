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
    		check: {
    		
    			enable: true
    			
    		},
    		data: {
    			simpleData: {
    				enable: true
    			}
    		},
    		callback: {
    			onClick: zTreeOnClick
    		}
    	};
    	
    function zTreeOnClick(event, treeId, treeNode) {
    	 $("#frame").attr("src", "listEmployee?orgId="+treeNode.id);
    };


    function getChildNodes() {   
    	var treeObj = $.fn.zTree.getZTreeObj("treeArea");
    	
    	var nodes = treeObj.getCheckedNodes(true);
    	
    	if(nodes.length==1){
    		/*  for(var i = 0; i < nodes.length; i++) {           
    				nodeSiteId[i] = nodes[i].id;    
    				nodeSiteName[i] = nodes[i].name;      
    			} */
    	
    	}else if(nodes.length==0){
    		$.warn("请选择一条记录操作！");
    	}else{
    		$.warn("您每次只能选择一条记录操作！");
    	}
    	
    	
    	

        //$("#menuIds").val(nodeSite.join(","));
    	//return nodes.join(",");
    }
    	 
    	var zNodes =${orgJosnStr}; 
    	//console.log(zNodes);
    	$(document).ready(function() {
    		var treeObj =  $.fn.zTree.init($("#treeArea"), setting,zNodes );
    		var node = treeObj.getNodesByFilter(function (node) { return node.level == 0 }, true);
    		$("#frame").attr("src","listEmployee?orgId="+node.id);
    	/* for(i in zNodes){
    		zNodes[i].onclick=function(){
    			$("#frame").attr("src","listEmployee?orgId="+zNodes[i].id);
    	}
    	} */
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


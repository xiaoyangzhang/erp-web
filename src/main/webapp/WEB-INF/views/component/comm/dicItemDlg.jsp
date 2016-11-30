<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String ctx = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>选择</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<script src="<%=ctx %>/assets/js/jquery-1.8.3.min.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
    <script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
	<script type="text/javascript">
		 var dicSetting = {
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
			},
			callback: {
				onCheck: treeObjOnCheck
			}
		};

		var dataNodes =${dicJSON};
		var treeObj;
		function loadDicTree(){
			if(typeof(dataNodes)=="string")
				dataNodes = eval("("+dataNodes+")");
			treeObj = $.fn.zTree.init($("#treeDicItem"), dicSetting, dataNodes );
			treeObj.refresh();
			
			var checkIds = '${checkIds}'
			if(checkIds != '' ){
				var ids =checkIds.split(",");
				for(var i = 0 ; i < ids.length; i ++ ) { 
					treeObj.checkNode(treeObj.getNodeByParam("id",ids[i]),true); 
				} 
			}
		}

		var dicIdArr = new Array();
		var dicNameArr = new Array();
		function treeObjOnCheck(event, treeId, treeNode){
			var nodes = treeObj.getCheckedNodes();
			dicIdArr.length =0; 
			dicNameArr.length=0;
			for(var i=0;i<nodes.length;i++){
					dicIdArr.push(nodes[i].id);
					dicNameArr.push(nodes[i].name);
			}	
			$("#dicNames").val(dicNameArr.join(','));
			$("#dicIds").val(dicIdArr.join(','));	
		}

		$(document).ready(function() {
			loadDicTree();
		});
</script>    
</head>
<body>
	<input type="hidden" name="dicNames" id="dicNames" value=""/> 
	<input type="hidden" name="dicIds" id="dicIds" value="" />
	 <div id="divDicItem" style="float:left;">
		<ul id="treeDicItem" class="ztree"></ul>
	</div>
</body>
</html>



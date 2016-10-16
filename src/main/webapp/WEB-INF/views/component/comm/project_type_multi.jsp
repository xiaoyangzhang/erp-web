<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.exhide-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
 <script type="text/javascript">
 var projectTypeSetting = {
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
		onCheck: treeTypeObjOnCheck
	}
};

var zProjectTypeNodes =${projectTypeJsonStr};

var treeProjectTypeObj;
var treeUserObj;

var userTreeNodes ;

function loadProjectTypeTree(){
	if(typeof(zProjectTypeNodes)=="string"){
		zProjectTypeNodes = eval("("+zProjectTypeNodes+")");
	}
		
	treeProjectTypeObj = $.fn.zTree.init($("#treeProjectType"),  projectTypeSetting, zProjectTypeNodes );
	userTreeNodes= treeProjectTypeObj.transformToArray(treeProjectTypeObj.getNodes());
	treeProjectTypeObj.refresh();
}

var typeCodeArr = new Array();
var typeValueArr = new Array();

function treeTypeObjOnCheck(event, treeId, treeNode){
	var nodes = treeProjectTypeObj.getCheckedNodes();
	typeCodeArr.length =0; 
	typeValueArr.length=0;	
	
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].isParent || !nodes[i].checked){
			continue;
		}
		else{
			typeCodeArr.push("'"+ nodes[i].id +"'");
			typeValueArr.push(nodes[i].name);
		}
	}	
	
	$("input[stag='typeValues']").val(typeValueArr.join(','));
	$("input[stag='typeCodes']").val(typeCodeArr.join(','));	
}

function showProjectType(){
	var orgObj = $("input[stag='typeValues']");
	var orgOffset = orgObj.offset();
	$("#divProjectType").css({left:orgOffset.left + "px", top:orgOffset.top + orgObj.outerHeight() + "px"}).slideDown("fast");

	
	var ids =  $("input[stag='typeCodes']").val();
	if(ids != '' ){
		ids =ids.split(",");
		for(var i = 0 ; i < ids.length; i ++ ) { 
			treeProjectTypeObj.checkNode(treeProjectTypeObj.getNodeByParam("id",ids[i]),true); 
		} 
	}
}

function hideProjectType() {
	$("#divProjectType").fadeOut("fast");
}

function onBodyDownForProjectType(event) {
	if (!(event.target.stag == "typeValues" || event.target.id == "divProjectType" || $(event.target).parents("#divProjectType").length>0)) {
		hideProjectType();
	}
}

$(document).ready(function() {
	loadProjectTypeTree();
	
	$("body").bind("mousedown", onBodyDownForProjectType);
});


 </script>
 <style type="text/css">
 	ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #f0f6e4;width:220px;height:360px;overflow-y:scroll;overflow-x:auto;}
 </style>
 <div id="divProjectType" style="display:none; position: absolute;z-index:999">
	<ul id="treeProjectType" class="ztree" style="margin-top:0; width:160px; height: 200px;"></ul>
</div>

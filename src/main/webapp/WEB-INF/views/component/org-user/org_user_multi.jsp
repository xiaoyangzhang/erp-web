<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.exhide-3.5.min.js"></script>
 <script type="text/javascript" src="<%=ctx %>/assets/js/json2.js"></script>
 <script type="text/javascript">
 var orgSetting = {
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
		onCheck: treeObjOnCheck,
		onClick: OrgNodeOnClick
	}
};

var userSetting = {
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
		onCheck: treeUserOnCheck,
		onClick: EmpNodeOnClick
	}
};

var zOrgNodes =${orgJsonStr}; 
var zUserNodes = ${orgUserJsonStr};
var treeOrgObj;
var treeUserObj;
var userTreeNodes ;

//点击节点时，收起来
function OrgNodeOnClick(e,treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("treeOrg");
	zTree.expandNode(treeNode);
}
function EmpNodeOnClick(e,treeId, treeNode) {
	var zTree = $.fn.zTree.getZTreeObj("treeUser");
	zTree.expandNode(treeNode);
}


function loadOrgTree(){
	if(typeof(zOrgNodes)=="string")
		zOrgNodes = eval("("+zOrgNodes+")");
	treeOrgObj = $.fn.zTree.init($("#treeOrg"), orgSetting,zOrgNodes );
	userTreeNodes= treeOrgObj.transformToArray(treeOrgObj.getNodes());
	//var nodes = treeOrgObj.transformToArray(treeOrgObj.getNodes());
	//for(var i=0;i<nodes.length;i++){
	//	var node = nodes[i];
		//if(node.isParent){
		//	node.nocheck=true;
		//}
	//}
	treeOrgObj.refresh();
}

function loadUserTree(){
	if(typeof(zUserNodes)=="string")
		zUserNodes = eval("("+zUserNodes+")");
	treeUserObj = $.fn.zTree.init($("#treeUser"), userSetting,zUserNodes );	
	//$("#treeUser li:first").before("<li><input type='text' id='userName' name='userName' style='width:120px;'/></li>");
	//<input type="text" id="userName" name="userName" style="">&nbsp;&nbsp;查询
}

$(document).ready(function() {
	loadOrgTree();
	loadUserTree();
	
	$("body").bind("mousedown", onBodyDown);
});

var orgIdArr = new Array();
var orgNameArr = new Array();
var userIdArr = new Array();
var userNameArr = new Array();

var userTreeOrgIdArr = new Array();
var userTreeUserIdArr = new Array();

function treeObjOnCheck(event, treeId, treeNode){
	var nodes = treeOrgObj.getCheckedNodes();
	orgIdArr.length =0; 
	orgNameArr.length=0;	
	userIdArr.length=0;
	userNameArr.length=0;	
	userTreeOrgIdArr.length = 0;
	userTreeUserIdArr.length=0;
	
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].isParent || !nodes[i].checked){
			continue;
		}
		else{
			orgIdArr.push(nodes[i].id);
			orgNameArr.push(nodes[i].name);
		}
	}	
	var curOrgId;
	var curUserTreeNode;	
	for(var j=0;j<orgIdArr.length;j++){	
		//当前节点
		curOrgId = "o_"+orgIdArr[j];
		curUserTreeNode = treeUserObj.getNodeByParam("id",curOrgId);
		//当前单位节点
		userTreeOrgIdArr.push(curUserTreeNode.id);
		var parentNode = curUserTreeNode.getParentNode();
		while(!!parentNode){
			if($.inArray(parentNode.id,userTreeOrgIdArr)==-1){
				userTreeOrgIdArr.push(parentNode.id);
			}
			parentNode = parentNode.getParentNode();
		}
		var subNodes = curUserTreeNode.children;
		if(subNodes && subNodes.length>0){
			for(var m=0;m<subNodes.length;m++){
				userTreeUserIdArr.push(subNodes[m].id);
			}
		}
	}
	
	$("input[stag='orgNames']").val(orgNameArr.join(','));
	$("input[stag='orgIds']").val(orgIdArr.join(','));	
	$("input[stag='userNames']").val("");
	$("input[stag='userIds']").val("");
}

function treeUserOnCheck(event, treeId, treeNode){
	userIdArr.length=0;
	userNameArr.length=0;
	var nodes = treeUserObj.getCheckedNodes();
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].isParent){
			continue;
		}
		else{
			userIdArr.push(nodes[i].oid);
			userNameArr.push(nodes[i].name);
		}
	}
	$("input[stag='userNames']").val(userNameArr.join(','));
	$("input[stag='userIds']").val(userIdArr.join(','));
}

function showOrg(){
	var orgObj = $("input[stag='orgNames']");
	var orgOffset = orgObj.offset();
	$("#divOrg").css({left:orgOffset.left + "px", top:orgOffset.top + orgObj.outerHeight() + "px"}).slideDown("fast");

	
	var ids =  $("input[stag='orgIds']").val();
	if(ids != '' ){
	ids =ids.split(",");
	for(var i = 0 ; i < ids.length; i ++ ) { 
		treeOrgObj.checkNode(treeOrgObj.getNodeByParam("id",ids[i]),true); 
	} 
	}
	//$("body").bind("mousedown", onBodyDown);
}

function hideOrg() {
	$("#divOrg").fadeOut("fast");
	//$("body").unbind("mousedown", onBodyDown);
}

function showUser(isReset){
	if(isReset){
		$("#searUsrName").val('');
		
		userIdArr.length=0;
		userNameArr.length=0;	
		
		$("input[stag='userNames']").val("");
		$("input[stag='userIds']").val("");
	}
	var userName = $("#searUsrName").val();	
	
	var userObj = $("input[stag='userNames']");
	
	//过滤显示和隐藏人员树节点
	//if(relatedNodeId.length>0){
	var hasSelected = userObj.val()!='';
	var allOrgNodes = treeUserObj.getNodesByParam("type","org");
	var allUserNodes = treeUserObj.getNodesByParam("type","user");
	
	var userOrgCnt = userTreeOrgIdArr.length;
	for(var i=0,len=allOrgNodes.length;i<len;i++){
		var curNode = allOrgNodes[i];
		if(isReset && curNode.checked){
			treeUserObj.checkNode(curNode,false);
		}
		if((userOrgCnt>0 && $.inArray(curNode.id,userTreeOrgIdArr)==-1)){
			treeUserObj.hideNode(curNode);		
		}else{
			treeUserObj.showNode(curNode);
		}			
	}
	var userCnt = userTreeUserIdArr.length;
	//显示用户的父节点单位id，用户下面的显示过滤
	var leafOrgIdArr = new Array();
	for(var i=0,len=allUserNodes.length;i<len;i++){
		var curNode = allUserNodes[i];
		
		if(isReset && curNode.checked){
			treeUserObj.checkNode(curNode,false);
		}
		
		if(userCnt>0 && $.inArray(curNode.id,userTreeUserIdArr)==-1 ){
			treeUserObj.hideNode(curNode);
		}else{
			treeUserObj.showNode(curNode);
			if($.inArray(curNode.pId,leafOrgIdArr)==-1){
				leafOrgIdArr.push(curNode.pId);
			}
			if(userName && curNode.name.indexOf(userName)==-1){
				treeUserObj.hideNode(curNode);
				continue;
			}
		}
	}
	//过滤掉没有子节点显示的单位
	for(var i=0,len=leafOrgIdArr.length;i<len;i++){
		var curNode = treeUserObj.getNodeByParam("id",leafOrgIdArr[i]);
		while(!!curNode){
			var arr = treeUserObj.getNodesByParam("isHidden",false,curNode);
			if(arr.length==0){
				treeUserObj.hideNode(curNode);
			}
			curNode = curNode.getParentNode();
		}
	}
	
	treeUserObj.refresh();
	
	var userOffset = userObj.offset();
	$("#divUser").css({left:userOffset.left + "px", top:userOffset.top + userObj.outerHeight() + "px"}).slideDown("fast");
	
	var ids =  $("input[stag='userIds']").val();
	if(ids != '' ){
		ids =ids.split(",");
		for(var i = 0 ; i < ids.length; i ++ ) { 
			treeUserObj.checkNode(treeUserObj.getNodeByParam("oid",ids[i]),true); 
		} 
	}
}

function hideUser() {
	$("#divUser").fadeOut("fast");
	//$("body").unbind("mousedown", onBodyDown);
}

function onBodyDown(event) {
	if (!(event.target.stag == "orgNames" || event.target.id == "divOrg" || $(event.target).parents("#divOrg").length>0)) {
		hideOrg();
	}
	if (!(event.target.stag == "userNames" || event.target.id == "divUser" || $(event.target).parents("#divUser").length>0)) {
		hideUser();
	}
}

function searchUser(){
	showUser();
}

function resetUser(){
	showUser(true);
}
 </script>
 <style type="text/css">
 	ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #f0f6e4;width:250px;height:360px;overflow-y:scroll;overflow-x:auto;}
 	#divUser{padding-top: 10px;border: 1px solid #617775;background: #f0f6e4;width:250px;height:360px;overflow-y:scroll;overflow-x:auto;}
 	#treeUser{margin-top: 10px;border:none;background: #f0f6e4;width:auto;height:auto;overflow-y:visible;overflow-x:visible;}
 	.tree-search{padding-left:10px;}
 </style>
 <div id="divOrg" style="display:none; position: absolute;z-index:999">
	<ul id="treeOrg" class="ztree" style="margin-top:0; width:160px; height: 300px;"></ul>
</div>
<div id="divUser" style="display:none; position: absolute;z-index:999">
	<div class="tree-search"><input type="text" id="searUsrName" value="" class="w-100" onkeyup="searchUser()" ><a href="javascript:;" class="blue" onclick="searchUser()">搜索</a>&nbsp;&nbsp;<a href="javascript:;" class="blue" onclick="resetUser()">重置</a></div>
	<ul id="treeUser" class="ztree" style="margin-top:0; width:160px; height: 300px;">
	
	</ul>
</div>


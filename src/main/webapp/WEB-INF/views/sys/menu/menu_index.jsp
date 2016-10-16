<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页-权限菜单管理</title>
<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0" /> -->
<%@ include file="../../../include/top.jsp"%>
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" id="viewport" />
<link rel="stylesheet" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.js"></script>

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
			//var mid = treeNode.tId.split("_")[1];
			
			/* if(treeNode.pId==null || treeNode.pId=='0'){
				$("body").tip({ynclose :true,status : "error",content :"根菜单不能修改！"});
			}else{
				$("#orgFrame").attr("src","getMenu?menuId="+treeNode.id);
			} */
			
		  	// alert(treeNode.tId + ", " + treeNode.name); 
		}


		function getChildNodes() {   
			var treeObj = $.fn.zTree.getZTreeObj("treeArea");
			
			var nodes = treeObj.getCheckedNodes(true);
			if(nodes.length==1){
				alert(nodes[0].id);
			}else if(nodes.length==0){
				$.warn("请选择一条记录操作！");
			}else{
				$.warn("您每次只能选择一条记录操作！");
			}
		}
		
		function showItems(items){
			for(var i=0;i<items.length;i++){
				var item ={
						id:items[i].menuId,pId:items[i].parentId,checked:false,name:items[i].name,open:true
				};
				zNodes.push(item);
				if(items[i].childMenuList!=null &&  items[i].childMenuList.length>0){
					showItems(items[i].childMenuList);
				}
			}
		}
		
		var zNodes = [];
		var items =${items};
		showItems(items);
		
			$(document).ready(function() {
				$.fn.zTree.init($("#menutree"), setting,zNodes );
				
			});
		
</script>
</head>
<body>
<div style="width:100%;height:100%;">
		<div style="float:left;width:200px;left:10px;position:absolute;top:20px;">
			<ul id="menutree" class="ztree"></ul>
		</div>
		<div style="float:left;left:200px;position:absolute;top:20px;right:10px;bottom:10px;display:none;">
			<iframe id="frame" frameborder="0" scrolling="auto" style="width:100%;height:100%;" src=""></iframe>
		</div>
	</div>
</body>
</html>


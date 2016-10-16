<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta charset="UTF-8">
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
<script type="text/javascript"
	src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.min.js"></script>
<script type="text/javascript"
	src="<%=ctx %>/assets/js/ztree/jquery.ztree.exedit-3.5.js"></script>
<SCRIPT type="text/javascript">
	var setting = {
		view : {
			addHoverDom : addHoverDom,
			removeHoverDom : removeHoverDom,
			selectedMulti : false,
		},
		async : {
			enable : true,
			url : "getRegion.do",
			autoParam : [ "id", "name", "level" ],

			dataFilter : filter
		},
		edit : {
			enable : true,
			removeTitle:"删除",
			renameTitle:"编辑"
		},
		data : {
			simpleData : {
				enable : true
			}
		},
		callback : {
			onClick : zTreeOnClick,
			beforeRemove : beforeRemove,
			/* beforeRename : beforeRename */
			beforeEditName : beforeEditName
		}
	};

	function filter(treeId, parentNode, childNodes) {
		if (!childNodes)
			return null;
		for (var i = 0, l = childNodes.length; i < l; i++) {
			childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
		return childNodes;
	}
	//修改子节点
	function beforeEditName(event, treeId, treeNode) {
		var id = treeNode.id;
		$("#frame").attr("src", "regionEdit.htm?id=" + id);
	};
	//修改子节点
	function zTreeOnClick(event, treeId, treeNode) {
		var id = treeNode.id;
		$("#frame").attr("src", "regionEdit.htm?id=" + id);
	};
	function beforeRemove(treeId, treeNode) {
				var zTree = $.fn.zTree.getZTreeObj("treeArea");
		// 		zTree.selectNode(treeNode);

		var r = confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
		if (r) {

			$.ajax({
				type : "get",
				url : "isNode.do",
				async : true,
				data : {
					id : treeNode.id
				},
				dataType : 'json',
				success : function(data) {
					if (data.success == true) {
						if (data.sucess) {
							$.success("成功");
							zTree.removeNode(treeNode,false); 
						}

					} else {
						$.warn("不允许删除，存在子节点");
						
					}
				},
				error : function(data, msg) {
					$.error("失败");

				}
			});

		}
		return false;
	}
	

	var newCount = 1;
	function addHoverDom(treeId, treeNode) {
		var sObj = $("#" + treeNode.tId + "_span");
		if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0)
			return;
		var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
				+ "' title='新增子节点' onfocus='this.blur();'></span>";
		sObj.after(addStr);
		var btn = $("#addBtn_" + treeNode.tId);
		if (btn)
			btn.bind("click", function() {
				$("#frame").attr("src", "regionAdd.htm?id=" + treeNode.id+"&level=" + treeNode.level);

				/* var zTree = $.fn.zTree.getZTreeObj("treeArea");
				zTree.addNodes(treeNode, {
					id : (100 + newCount),
					pId : treeNode.id,
					name : "new node" + (newCount++)
				}); */
				return false;
			});
	};
	function removeHoverDom(treeId, treeNode) {
		$("#addBtn_" + treeNode.tId).unbind().remove();
	};

	$(document).ready(function() {

		$.fn.zTree.init($("#treeArea"), setting);

	});
</SCRIPT>
<style type="text/css">
.ztree li span.button.add {
	margin-left: 2px;
	margin-right: -1px;
	background-position: -144px 0;
	vertical-align: top;
	*vertical-align: middle
}
</style>
</head>
<body>
	<div style="width: 100%; height: 100%;">
		<div
			style="float: left; width: 200px; left: 10px; position: absolute; top: 20px;">
			<ul id="treeArea" class="ztree"></ul>
		</div>
		<div
			style="float: left; left: 200px; position: absolute; top: 20px; right: 10px; bottom: 10px;">
			<iframe id="frame" frameborder="0" scrolling="auto"
				style="width: 100%; height: 100%;" src=""></iframe>
		</div>
	</div>

</body>
</html>
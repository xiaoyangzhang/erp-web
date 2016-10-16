<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>添加角色</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

<!-- ztree -->
	<link rel="stylesheet" href="<%=ctx %>/assets/css/ztree/demo.css" type="text/css">
	<link rel="stylesheet" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.js"></script>
	<SCRIPT type="text/javascript">
	var setting = {
			check: {
				enable: true,
				//chkStyle:"checkbox"
				chkStyle: "checkbox",
				chkboxType: { "Y": "ps", "N": "s" }
			},
			data: {
				simpleData: {
					enable: true
				}
			}
		};

		var zNodes =${menuJosnStr};
		
		
		
		$(document).ready(function(){
			$.fn.zTree.init($("#menutree"), setting, zNodes);
			
			
		});
		
		function getChildNodes() {   
			var treeObj = $.fn.zTree.getZTreeObj("menutree");
			//获取选中的节点集合
			var nodes = treeObj.getCheckedNodes(true);
			if(nodes.length==0){
				return false;
			}
			var nodeSiteId = new Array();      
			var nodeSiteName = new Array();      
			for(var i = 0; i < nodes.length; i++) {           
				nodeSiteId[i] = nodes[i].id;      
				nodeSiteName[i] = nodes[i].name;      
			} 
			document.getElementById('menuIds').value=nodeSiteId.join(",");
			document.getElementById('menutree').value=nodeSiteName.join(",");
			return true;
		}
		$(document).ready(function(){
			$(".roleName").focus();
		});
		
	</SCRIPT>
</head>
<body>

	<div class="p_container" >
		<div class="p_container_sub" >
			<p class="p_paragraph_title"><b>角色信息</b></p>
		<form class="form-horizontal" role="form" action="submit"  method="post" id="mainform">
			<input type="hidden" name="roleId" id="roleId" class="roleId">
			 <input type="hidden" name="groupName" id="groupName" value=""/> 
			<dl class="p_paragraph_content">
              		<dd>
	    			<div class="dd_left"><i class="red">* </i>名称:</div> 
	    			<div class="dd_right"><input type="text" id="form-field-1"
						class="col-xs-10 col-sm-5 roleName" name="name" />
	    			</div>
					<div class="clear"></div>
	    			</dd>
              		<dd>
	    			<div class="dd_left"><i class="red">* </i>角色组:</div> 
	    			<div class="dd_right">
	    			<select id="groupId" name="groupId">
	    				<option></option>
	    				<c:forEach items="${ roleGroup}" var="group">
	    				
	    				<option value="${group.id }">${group.value }</option>
	    				</c:forEach>
	    			</select>
	    			</div>
					<div class="clear"></div>
	    			</dd>
			
					<dd>
	    			<div class="dd_left">编码:</div> 
	    			<div class="dd_right"><input type="text" id="form-field-1" 
						class="col-xs-10 col-sm-5" name="code" />
	    			</div>
					<div class="clear"></div>
	    			</dd>
	    			
	    			<dd>
	    			<div class="dd_left">状态:</div> 
	    			<div class="dd_right" style="width: auto;"> 
	    				 <input name="status" type="radio"
								class="ace" checked="checked" value="1"/> <span class="lbl">有效</span>
						 <input name="status" type="radio"
						class="ace" value="0"/> <span class="lbl">无效</span>
						
	    			</div>
					<div class="clear"></div>
	    			</dd>
			
					<dd>
	    			<div class="dd_left">菜单权限:</div> 
	    			<div class="dd_right" > 
						<div style="float:left;width:500px;">
						<ul id="menutree" class="ztree"></ul>
						</div>
						<input type="hidden" id="menuIds" name="menuIds" value="" class="col-xs-10 col-sm-5" />
	    			</div>
					<div class="clear"></div>
	    			</dd>
			
			
					<dd>
	    			<div class="dd_left">描述:</div> 
	    			<div class="dd_right"><textarea rows="3" cols="90" name="comment"></textarea>
	    			</div>
					<div class="clear"></div>
	    			</dd>
			
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<input class="button button-primary button-small " type="submit" id="btnsave" value="提交"/> &nbsp;
						&nbsp; &nbsp;<input class="button button-primary button-small" type="button" onclick="javascript:history.go(-1);" value="返回" />
					</div>
				</dd>
			
			</dl>
		</form>
		</div>
	</div>
	<script type="text/javascript">
$(function(){
	$("#mainform").validate({
		rules : {
			'name' : {
				required : true
			}
		},
		messages : {
			'name' : {
				required : "请输入角色名称"
			}
		},
		errorPlacement : function(error, element) { // 指定错误信息位置
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) { // 如果是radio或checkbox
				var eid = element.attr('name'); // 获取元素的name属性
				error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var flag=getChildNodes();
			if(flag){
				$("#groupName").val($("#groupId").find("option:selected").text());
				form.submit();
			}
			else{
				$.info("请选择菜单权限");
				return false;
			}
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}		
	})
})

</script>	
</body>
</html>


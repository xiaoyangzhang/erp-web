<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html>
<html>
<head>
    <title></title>
	<%@ include file="../../../include/top.jsp"%>     
</head>
<body>
<div class="p_container_sub">
		<p class="p_paragraph_title"><b>编辑区域</b></p>
		<form  class="definewidth m20" id="myFormId">
		<input type="hidden" name="id" value="${region.id}" />
		<input type="hidden" name="pid" value="${region.pid}" />
		<c:if test="${region!=null}">
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">名称</div> 		
				<div class="dd_right">					
            		<input type="text" name="name" value="${region.name }" class="IptText300"/>
            	</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left">排序</div> 		
				<div class="dd_right">					
            		<input type="text" name="orderid" value="${region.orderid }" class="IptText300"/>
            	</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left">名称</div> 		
				<div class="dd_right">					
            		<input type="radio" name="status"  value="1" <c:if test="${region.status==1}">checked="checked"</c:if> checked="checked"  /><span>是</span>
				<input type="radio" name="status" value="0" <c:if test="${region.status==0}">checked="checked"</c:if>  /><span>否</span>
            	</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"></div> 		
				<div class="dd_right">					
            		<button type="submit" class="button button-primary button-small" type="button" id="btnSave">保存</button> 
            	</div>
				<div class="clear"></div>						
			</dd>
			</dl>
	</c:if>
</form>
</div>
<script>

$(function(){

	$("#myFormId").validate(
			{
				onkeyup : false,
				rules : {
					'code' : {
						required : true,
						rangelength:[1,20]
					},'orderid' : {
						required : true,
						isNum : true
					}
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':input')) {
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					$.ajax({
		                type: "post",
		                cache:false,
		                url:"submitRegion.do",
		                data:$('#myFormId').serialize(),// 你的formid
		                async: true,
		                dataType: 'json',
		                success: function(data) {
		                	if(data.success == true){
		                		if(data.sucess){
		                			$.success("操作成功");
		    		        	 }
		                	}else{
		                		$.error(data.msg);
		                	}
		                },
		                error: function(data,msg) {
		                	$.error(data.msg);
		                }
		            });
				}
			});
});
</script>
</body>
</html>
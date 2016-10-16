<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>首页</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	<div class="p_container">
		<div class="p_container" >
			 <div class="p_container_sub" id="tab1">
		    	<form id="editForm">
		    	<input type="hidden" id="id" name="employeeId" value="${user.employeeId }"/>
		    	<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left">用户名</div> 
		    			<div class="dd_right">
		    				<input type="text" id="userName" value="${user.name }" name="name" class="IptText300" disabled="" />
		    			</div>
						<div class="clear"></div>
		    		</dd>
		    		<dd>
		    			<div class="dd_left"><i class="red">* </i>新密码</div> 
		    			<div class="dd_right">
		    				<input type="password" id="password" name="password" class="IptText300" />
		    			</div>
						<div class="clear"></div>
		    		</dd>
		    		<dd>
		    			<div class="dd_left"></div> 
		    			<div class="dd_right">
							<button type="submit" class="button button-primary button-small">确认</button>
		    				<button type="button" id="btnClose" class="button button-primary button-small">关闭</button>
		    			</div>
						<div class="clear"></div>		    			
		    		</dd>
		    	</dl>
				</form>
			</div>
		</div>
	</div>
	<!-- 修改用户密码弹窗 -->
	<script type="text/javascript">
	$(function(){	
		$("#editForm").validate({
				errorElement : 'span',
				errorClass : 'help-block',
				focusInvalid : false,
				onkeyup : false,
				rules : {
					'password' : {
						required:true
					}				
				},					
				highlight : function(element) {
					$(element).closest('.form-group').addClass(
							'has-error');
				},
				success : function(label) {
					label.closest('.form-group').removeClass(
							'has-error');
					label.remove();
				},
				errorPlacement : function(error, element) {
					element.parent('span').append(error);
				},
				submitHandler : function(form) {
					$.ajax({
		                type: "post",
		                cache:false,
		                url:"updatePass",
		                data:$('#editForm').serialize(),// 你的formid
		                async: true,
		                dataType: 'json',
		                success: function(data) {
		                	if(data.success){	
		                		// alert("212");
		                		$.success('密码修改成功',function(){closeDia();});			                		
		                	}else{
		                		$.error('密码修改失败',function(){closeDia();});
		                	}
		                }			               
		            });
				}
			});
		
		function closeDia(){
			var index = parent.layer.getFrameIndex(window.name); 
			parent.layer.close(index);
		}
		
		$("#btnClose").click(function(){
			closeDia();
		})
	});
	</script>
</body>
</html>

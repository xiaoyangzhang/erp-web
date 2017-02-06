<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>编辑个人资料</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

	<link rel="stylesheet" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.js"></script>
	

<script type="text/javascript" src="<%=ctx %>/assets/js/sys/emp.js"></script>
<style type="text/css">
	.help-block{color:red;}
</style>
</head>
<body>
	 <div class="p_container" >
		<div class="p_container_sub" >			
			<form id="editForm" action="saveProfile.do">
              	<dl class="p_paragraph_content">
              	<dd>
	    			<div class="dd_left form-group" >组织机构</div> 
	    			<div class="dd_right">
	    				${orgName }
	    			</div>	    			
					<div class="clear"></div>
	    		</dd>				
				<dd>
					<div class="dd_left form-group" ><i class="red">* </i>用户名:</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="employeeId" id="employeeId" value="${empPo.employeeId }" readOnly/>
						<input type="text" name="loginName" class="w-200" id="loginName" readOnly
							value="${empPo.loginName }"    />
	    			</div>
					<div class="dd_left form-group"><i class="red">* </i>姓名:</div>
					<div class="dd_right">
						<input type="text" name="name"
							value="${empPo.name }" class="w-200" />
					</div>
					<div class="clear"></div>
				</dd>

				<dd>
					<div class="dd_left form-group"><i class="red">* </i>手机号:</div>
					<div class="dd_right">
						<input type="text" name="mobile"
							value="${empPo.mobile }" class="w-200" />
					</div>
					<div class="dd_left">职务:</div>
					<div class="dd_right">
						<input type="text" name="position"
							value="${empPo.position }" class="w-200" />
					</div>
					<div class="clear"></div>
				</dd>				
				<dd>
					<div class="dd_left">固定电话:</div>
					
					<div class="dd_right">
						<input type="text" name="phone"
							value="${empPo.phone }" class="w-200" />
					</div>
					<div class="dd_left">传真:</div>
					
					<div class="dd_right">
						<input type="text" name="fax"
							value="${empPo.fax }" class="w-200" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left form-group">邮箱: </div>
					<div class="dd_right">
						<input type="text"  name="email"
							value="${empPo.email }" class="w-200" />
					</div>
					<div class="dd_left">QQ号码: </div>
					<div class="dd_right">
						<input type="text" name="qqCode"
							value="${empPo.qqCode }" class="w-200" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">性别: </div>
					<div class="dd_right" style="width: auto;">
						<input name="gender" type="radio" class="ace" value="1"
							<c:if test="${empPo.gender==1 || empty empPo}"> checked="checked" </c:if> />
						<span class="lbl">男</span> <input name="gender" type="radio"
							class="ace" value="0"
							<c:if test="${empPo.gender==0}"> checked="checked" </c:if> />
						<span class="lbl">女</span>
					</div>
					<div class="clear"></div>
				</dd>		
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button class="button button-primary button-small" type="submit" id="btnsave"  >提交 </button>&nbsp;
						&nbsp; &nbsp;
						<button type="button" id="btnClose" class="button button-primary button-small" >关闭</button>
					</div>
					<div class="clear"></div>
				</dd>
			</form>
		</div>
</div>
<script type="text/javascript">
$(function(){	
	$("#editForm").validate({
			errorElement : 'span',
			errorClass : 'help-block',
			focusInvalid : false,
			onkeyup : false,
			rules : {
				'mobile' : {
					required:true
				},
				'name' : {
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
				var options={
						type:"post",
						dataType:"json",
						success:function(data){
							if(data.success){	
		                		$.successR('信息修改成功',function(){closeDia();});
		                	}else{
		                		$.errorR('信息修改失败',function(){closeDia();});
		                	}							
						},
						error:function(){
							$.errorR("服务器忙，请稍后再试");
						}
				};
				$(form).ajaxSubmit(options);
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

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

	<link rel="stylesheet" href="<%=ctx %>/assets/css/ztree/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/ztree/jquery.ztree.excheck-3.5.js"></script>
	

<script type="text/javascript" src="<%=ctx %>/assets/js/sys/emp.js"></script>
<style type="text/css">
	.help-block{color:red;}
	.role-block{display: inline-block;}
</style>
</head>
<body>
	 <div class="p_container" >
		<div class="p_container_sub" >
			<p class="p_paragraph_title"><b>用户信息</b></p>
			<form action="saveEmployee" method="post" id="saveEmployee">
				<input type="hidden" name="bizId" id="bizId" value="${bizId }" />
				<input type="hidden" name="isSuper" id="isSuper" value="${empPo.isSuper }" />
				
              		<dl class="p_paragraph_content">
              		<dd>
	    			<div class="dd_left form-group" ><i class="red">* </i>用户名:</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="employeeId" id="employeeId" value="${empPo.employeeId }"/>
						<input type="text" name="loginName" class="IptText300" id="loginName"
							value="${empPo.loginName }"    />
	    			</div>
					<div class="clear"></div>
	    		</dd>
				<c:if test="${empPo.employeeId== null || empPo.employeeId=='' }">
				<dd>
					<div class="dd_left form-group"><i class="red">* </i>密码:</div> 

					<div class="dd_right">
						<input type="text" name="password"
							value="${empPo.password }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				</c:if>
				
				<dd>
					<div class="dd_left form-group"><i class="red">* </i>姓名:</div>
					<div class="dd_right">
						<input type="text" name="name"
							value="${empPo.name }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>

				<dd>
					<div class="dd_left">职务:</div>
					<div class="dd_right">
						<input type="text" name="position"
							value="${empPo.position }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left form-group"><i class="red">* </i>手机号:</div>
					
					<div class="dd_right">
						<input type="text" name="mobile"
							value="${empPo.mobile }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left">电话:</div>
					
					<div class="dd_right">
						<input type="text" name="phone"
							value="${empPo.phone }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left">传真:</div>
					
					<div class="dd_right">
						<input type="text" name="fax"
							value="${empPo.fax }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left form-group">邮箱: </div>
					<div class="dd_right">
						<input type="text"  name="email"
							value="${empPo.email }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left">QQ号码: </div>
					<div class="dd_right">
						<input type="text" name="qqCode"
							value="${empPo.qqCode }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</dd>

				<dd>
					<div class="dd_left"><i class="red">* </i>组织机构: </div>
					<div class="dd_right">
						
						<input type="text" id="orgName" value="${orgName}" class="IptText300" readOnly />
						<input type="hidden" id="orgId" name="orgId" value="${orgId}" />
						<input type="button" value="请选择" id="orgBtn" class="button button-primary button-small" onclick="selectOrg()"/>
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left"><i class="red">* </i>角色: </div>
				 	<div class="dd_right" style="width:600px;padding:5px 5px 5px 5px;
				 	 border:solid 1px #a5a5a5">
				 	<c:forEach items="${roleGroup }" var="group">
				 <b>	${group.value }:&nbsp;&nbsp;</b>
				 		<c:forEach items="${roleList}" var="role">
				 		<c:if test="${group.id == role.groupId }">
				 	<span class="role-block">	<input name="roles" type="checkbox" value="${role.roleId }" 
				 			 <c:if test="${not empty roles}">
				 				<c:forEach items="${roles}" var="r">
				 					<c:if test="${role.roleId eq r.roleId }">
				 						checked="checked"
				 					</c:if>
				 				</c:forEach>
				 			</c:if> 
				 		/> ${role.name }</span>
				 		</c:if>
				 			
				 		
				 		</c:forEach>	<br/>
				 		</c:forEach>
				 		<b style="color: red">未分组：&nbsp;&nbsp;</b>	
				 		 	<c:forEach items="${roleList}" var="role">							
				 		<c:if test="${role.groupId ==0 or role.groupId ==null }">
				 		<span class="role-block">	<input name="roles" type="checkbox" value="${role.roleId }" 
				 			  <c:if test="${not empty roles}">
				 				<c:forEach items="${roles}" var="r">
				 					<c:if test="${role.roleId eq r.roleId }">
				 						checked="checked"
				 					</c:if>
				 				</c:forEach>
				 			</c:if>  
				 		/> ${role.name }</span>
				 		</c:if>
				 		</c:forEach>
						<input name="role" type="hidden" id="roleIds" value="">	
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
					<div class="dd_left form-group">是否启用: </div>
					<div class="dd_right" style="width: auto;">
						<input name="status" type="radio" class="ace" value="1"
							<c:if test="${empPo.status==1 || empty empPo}"> checked="checked" </c:if> />
						<span class="lbl">是</span> <input name="status" type="radio"
							class="ace" value="0"
							<c:if test="${empPo.status==0}"> checked="checked" </c:if> />
						<span class="lbl">否</span>
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button class="button button-primary button-small" type="submit" id="btnsave"  >提交 </button>&nbsp;
						&nbsp; &nbsp;
						<button type="button" onclick="closeWindow()" class="button button-primary button-small" >关闭</button>
					</div>
					<div class="clear"></div>
				</dd>
			</form>
		</div>
</div>
</body>
<div id="orgTree" style=" position: absolute;">
	<ul id="orgTree" class="ztree" style="margin-top:0; width:180px; height: 300px;"></ul>
</div>
<script type="text/javascript">
/* function gotoList(orgId){
	location.href="listEmployee?orgId="+orgId;
} */

function selectOrg(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择组织机构',
		closeBtn : false,
		area : [ '400px', '490px' ],
		shadeClose : false,
		content : '<%=ctx%>/component/orgTree.htm', //单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//orgArr返回的是org对象的数组
			var orgArr = win.getOrgList();    				
			if(orgArr.length==0){
				$.warn("请选择组织结构");
				return false;
			}
			
			//for(var i=0;i<orgArr.length;i++){
				//console.log("id:"+orgArr[i].id+",name:"+orgArr[i].name);
			//}
			$("#orgId").val(orgArr[0].id);
			$("#orgName").val(orgArr[0].name);
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
</script>
</html>

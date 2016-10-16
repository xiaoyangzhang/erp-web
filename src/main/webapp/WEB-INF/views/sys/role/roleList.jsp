<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>角色管理</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
<script>
/***
 * 查询方法
 */
  $(function(){
	 queryList();
 }) 
function queryList(page,pagesize) {
    
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"roleList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#roleList").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.warn("服务忙，请稍后再试");
    	}	  
    }
    $("#queryForm").ajaxSubmit(options);	
}


//删除
function del(id,name){
	bootbox.setDefaults({locale:"zh_CN"});
	bootbox.confirm("确定要删除角色["+name+"]吗?", function(result) {
		if(result) {
			$.ajax({
				 type: "post",
		         cache:false,
		         url:"deleteRole",
		         data:{roleId:id},
		         dataType:"json",
		         success:function(data){
		        	 if(data.result=="idnull"){
		        		 $.warn("参数不能为空");
		        	 }else if(data.result=="occupied"){
		        		 $.warn("");
		        	 }else{
		        		 $.success("删除成功");
		        		 window.location=window.location;
		        	 }
		         },error:function(data){
		        	 $.warn("操作失败");
		        }
			});
		}
	});
}

function add(){
	window.location.href="addRole";
}
function copyRole(roleId){
	$.ajax({
		 type: "post",
        cache:false,
        url:"copyRole.do",
        data:{roleId:roleId},
        dataType:"json",
        success:function(data){
       	 if(data.success){
       		 $.success("复制成功");
       		window.location=window.location;
       	 }else{
       		 $.warn("复制失败");
       		// window.location=window.location;
       	 }
        },error:function(data){
       	 $.warn("复制失败");
       }
	});
}
</script>
</head>
<body>
	<div class="p_container" >
	<div class="p_container_sub" >
	<div class="searchRow"><ul>
			<form id="queryForm">
					
	       			<input name="page" type="hidden" id="page">
	       			 <input name="pageSize" type="hidden" id="pageSize" value="${pageSize }"> 
	 				<li class="text">名称：</li><li><input type="text" name="name"
						id="" /></li>
					<li>
					<input type="button" id="btnQuery" value="查询" class="button button-primary button-small"   />
					&nbsp;&nbsp;&nbsp;&nbsp;
					</li>
			</form>
					<li><button class="button button-primary button-small" id="btnAdd" onclick="add()">新增</button></li>
					</ul>
			</div>
			</div>
			
		</div>
	
	<div class="table-responsive" id="roleList">
		<%-- <jsp:include page="roleTableList.jsp"></jsp:include> --%>
	</div>
</body>
<script type="text/javascript">
$("#btnQuery").click(function(){
	 queryList(1,$("#pageSize").val());
})
</script>
</html>


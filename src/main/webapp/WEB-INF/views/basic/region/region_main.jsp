<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
    <title>区域列表</title>
    <%@ include file="../../../include/top.jsp"%>
</head>
<body>
<form class="form-inline definewidth m20" action="dicTypeList.htm" method="get">  
    类型值：
    <input type="text" name="name" id="name"class="abc input-default" placeholder="" value="${name }">&nbsp;&nbsp;  
    <button id="btnQuery" class="btn btn-primary">查询</button>&nbsp;&nbsp; <button type="button" class="btn btn-success" id="addnew">新增类型</button>
</form>
<table class="table table-bordered table-hover definewidth m10" >
    <thead>
    <tr>
        <th>序号</th>
        <th>编码</th>
        <th>值</th>        
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    	<c:forEach var="type" items="${list }" >
	     <tr>
             <td>${type.orderId}</td>
            <td>${type.code }</td>
            <td>${type.value }</td>
            <td>
               <a href="editDicType.htm?id=${type.id }" class="def">编辑</a>
               <a href="javascript:del('${type.id}')" class="def">删除</a>
            </td>
        </tr>
        </c:forEach>
      </tbody>      
</table>        
<script type="text/javascript">
	$(function () {
		$('#addnew').click(function(){
			window.location.href="addDicType.htm?pid=${pid}";
		 });
		$("#btnQuery").click(function(){
			window.location.href = "dicTypeList.htm?pid=${pid}&name="+encodeURI(encodeURI($("#name").val()));
		})
	});
	
	function del(id){
		if(confirm("确定要删除吗？")){
			$.ajax({
				type: 'POST',
		        url: 'delDicType.do',
		        dataType: 'json',		        
		        data: {
		            id: id
		        },
		        success: function(data) {
		            if (data.sucess == true) {
		            	$.success("操作成功",function(){
		            		window.location.href=window.location.href;
		            	});
		               	
		            }else{
						$.error(data.msg);
					}
		        },
		        error: function(data,msg) {
		            $.error("操作失败"+msg);
		        }
			});	
		}
	}
</script>
	</body>
</html>

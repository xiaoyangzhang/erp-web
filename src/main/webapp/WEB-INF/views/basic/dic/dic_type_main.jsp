<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<!DOCTYPE html>
<html>
<head>
    <title>字典类型管理</title>
    <%@ include file="../../../include/top.jsp"%>
</head>
<body>
<div class="p_container" >
	<div class="p_container_sub" >	
		<form action="dicTypeList.htm" method="get">
	    	<div class="searchRow">
	               <ul>
	                   <li class="text">类型值：</li><li><input type="text" name="name" id="name" placeholder="" value="${name }"></li>
	                   <li class="text"></li><li>
	                   		<button id="btnQuery" class="button button-primary button-small">查询</button>&nbsp;&nbsp; 
	                   		<button type="button" class="button button-primary button-small" id="addnew">新增</button>
	                       </li>
	                   <li class="clear"/>
	               </ul>
	    	</div>  
	    </form>  	
      </div>
<table cellspacing="0" cellpadding="0" class="w_table" >
	<colgroup>
		<col width="10%" />
		<col width="40%" />
		<col width="40%" />
		<col width="10%" />
	</colgroup>
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
</div>      
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
		$.confirm("确定要删除吗？",function(){
			$.ajax({
				type: 'POST',
		        url: 'delDicType.do',
		        dataType: 'json',		        
		        data: {
		            id: id
		        },
		        success: function(data) {
		            if (data.success == true) {
		               	window.location.href=window.location.href;
		            }else{
						$.error(data.msg);
					}
		        },
		        error: function(data,msg) {
		            $.error("操作失败"+msg);
		        }
			});	
		});
	}
</script>
	</body>
</html>

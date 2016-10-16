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
	<form action="dicList.htm" method="get">
    	<div class="searchRow">
               <ul>
                   <li class="text">类型名称：</li><li><input type="text" name="name" id="name" placeholder="" value="${name }"></li>                   
                   <li class="text"></li><li>
                   		<button id="btnQuery" class="button button-primary button-small">查询</button>&nbsp;&nbsp; 
                   		<c:if test="${share==0 }">
                   			<button type="button" class="button button-primary button-small" id="addnew">新增</button>
                   		</c:if>
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
        <th>排序号</th>
        <th>名称</th>
        <th>值</th>
        <!-- <th>字典类型</th> -->
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    	<c:forEach var="dic" items="${list }" varStatus="status" >
	     <tr>
            <td>${dic.orderId }</td>
            <td>${dic.code }</td>
            <td>${dic.value }</td>
            
            <td>
            	<c:if test="${share==0 }">
            		<a href="editDic.htm?id=${dic.id }" class="def">编辑</a>
               		<a class="def" href="javascript:del('${dic.id}')">删除</a>
               	</c:if>
            </td>
        </tr>
        </c:forEach>
      </tbody>      
</table>
</div>
	</body>
</html>

<script>
	$(function () {
		$('#addnew').click(function(){
			window.location.href="addDic.htm?type=${type}";
		 });
		
		$("#btnQuery").click(function(){
			window.location.href = "dicList.htm?type=${type}&name="+encodeURI(encodeURI($("#name").val()));
		})
	});
	
	function del(id){
		$.confirm("确定要删除吗？",function(){
			$.ajax({
				type: 'POST',
		        url: 'delDic.do',
		        dataType: 'json',		        
		        data: {
		            id: id
		        },
		        success: function(data) {
		            if (data.success == true) {
		               	window.location.href=window.location.href;
		            }else{
						$.error("操作失败"+data.msg);
					}
		        },
		        error: function(data,msg) {
		            $.error("操作失败"+msg);
		        }
			});	
		})
	}
</script>
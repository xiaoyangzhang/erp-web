<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>


</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub">
	    	<p class="p_paragraph_title"><b>分配购物店</b>
	    	</p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20 w-1100">
	    				<table cellspacing="0" cellpadding="0" class="w_table tab_guide">
	    					<col width="5%"/><col width="15%"/><col width="20%"/><col width="10%"/><col width="10%"/>
	    					<thead>
	    						<th>序号<i class="w_table_split"></i></th>
	    						<th>购物店<i class="w_table_split"></i></th>
	    						<th>进店日期<i class="w_table_split"></i></th>
	    						<th>导游<i class="w_table_split"></i></th>
	    						<th>操作</th>
	    					</thead>
	    					  <c:forEach items="${shoplist}" var="shop" varStatus="status">
		    					<tr id="${shop.id }">
		    						<td>
		    							${status.count }
		    						</td>
		    						<td>
		    							${shop.supplierName }
		    						</td>
		    						<td>
		    							${shop.shopDate }
		    						</td>
		    						<td>
		    							${shop.guideName }
		    						</td>
		    						
		    						<td><a href="editShop.htm?id=${shop.id }&groupId=${groupId}" class="def">修改</a>
		    							<a href="#" onclick="del(${shop.id})" class="def">删除</a>
		    						</td>
		    					</tr>
		    				</c:forEach>
		    		
	    				</table>
	    			<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
							<a href="editShop.htm?groupId=${groupId }" class="btn_guide_add button button-primary button-small ml-10">添加</a>
	    					<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							</div>

						</dd>
					</dl>
				</div>	
	    			</div>
	    		</dd>
	    		
	    	</dl>
	    	  <div id="groupDetail">
            	
            </div>    
        </div>
       
    </div>
    
</body>
<script type="text/javascript">
function del(id){	
	$.confirm("确认删除此购物店吗？",function(){
			  $.post("deleteShop.do",{id:id},function(data){
			   		if(data.success){
			   			$.info('删除成功！');
			   			$("#"+id).remove();
			   			
			   		}else{
			   			$.info(data.msg);
			   		}
			  },"json");
	},function(){
		  $.info('取消删除！');
		
	});

}
$(function(){
	$("#groupDetail").load("<%=path %>/booking/groupDetail.htm?gid=${groupId }");
})

</script>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
</head>
<body>
   <div class="p_container" >
	    <div class="p_container_sub">
	    	<p class="p_paragraph_title"><b>新增导游</b>
	    		
	    	</p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20 w-1100">
	    			<form action="">
	    				<table cellspacing="0" cellpadding="0" class="w_table">
	    					<col width="20%"/><col width="15%"/><col width="15%"/><col width="20%"/><col width="10%"/><col width="10%"/>
	    					<thead>
	    						<th>上团时间 ~ 下团时间<i class="w_table_split"></i></th>
	    						<th>导游<i class="w_table_split"></i></th>
	    						<th>结对司机<i class="w_table_split"></i></th>
	    						<th>备注<i class="w_table_split"></i></th>
	    						<th>是否默认<i class="w_table_split"></i></th>
	    						<th>操作</th>
	    					</thead>
	    					 <c:forEach items="${vo}" var="group" >
	    					<tr id="${group.guide.id }">
	    						<td>
	    						 <c:forEach items="${group.guideTimes}" var="times" varStatus="i">
	    							${times.timeStart}
	    						 ~ ${times.timeEnd}<br />
	    						</c:forEach>
	    						</td>
	    						
	    						
	    						<td>
	    							${group.guide.guideName}<br />
	    							<span class="grey">
	    							${group.guide.guideMobile}
	    							</span>
	    						</td>
	    						<td>
	    							${group.guide.driverName}
	    						</td>
	    						<td>
	    							${group.guide.remark}
	    						</td>
	    						<td>
	    							<c:if test="${group.guide.isDefault eq 1}">是</c:if>
	    							<c:if test="${group.guide.isDefault eq 0}">否</c:if>
	    						</td>
	    						<td>
	    						<c:if test="${view ne 1 }">
	    							<c:if test="${group.guide.stateFinance ne 1}">
	    							<a href="toEditGuideView.htm?groupId=${groupId }&id=${group.guide.id }" class="def">修改</a>
	    							<a href="#" onclick="del(${group.guide.id })" class="def">删除</a>
	    							</c:if>
	    							<c:if test="${group.guide.isDefault eq 1}">默认导游</c:if>
	    							<c:if test="${group.guide.isDefault eq 0}"><a href="#" onclick="def(${group.guide.id },${groupId })" class="def">设为默认</a></c:if>
	    						</c:if>
	    							
	    						</td>
	    						
	    					</tr>
	    					</c:forEach>
	    				
          			
	    				</table>
	    					<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
							<c:if test="${view ne 1 }"><a href="toEditGuideView.htm?groupId=${groupId }" class="button button-primary button-small ml-10">添加</a></c:if>
							<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							</div>

						</dd>
					</dl>
				</div>
	    				</form>
	    			</div>
	    			
	    		</dd>
	    		
	    	</dl>
	    	<div id="groupDetail"></div> 
        </div>
       
    </div>

</body>
<script type="text/javascript">
$(function(){
	<%-- $("#groupDetail").load("<%=path %>/booking/groupDetail.htm?gid=${groupId }"); --%>
	$("#groupDetail").load("<%=ctx %>/booking/groupDetail.htm?gid=${groupId }&stype=8");
});

$(function guideAdd () {
	$(".btn_guide_add").unbind("click").click(function () {
		$(this).before('<input type="text" id="groupDate" name="groupDate" class="Wdate" onClick="WdatePicker({dateFmt:'+"'yyyy-MM-dd HH:ss'"+'})" value="" class="w-120"/> ~ <input type="text" id="groupDate" name="groupDate" class="Wdate" onClick="WdatePicker({dateFmt:'+"'yyyy-MM-dd HH:ss'"+'})" value="" class="w-120"/><br />')
	})
})


function del(id){	
		$.confirm("确认删除此导游吗？",function(){
				  $.post("<%=ctx %>/bookingGuide/deletetailGuide.do",{id:id},function(data){
				   		if(data.success){
				   			$.success('删除成功！');
				   			$("#"+id).remove();
				   			
				   		}else{
				   			$.error(data.msg);
				   		}
				  },"json");
		},function(){
			  $.info('取消删除！');
			
		});
	
	}
function def(id,groupId){	

			  $.post("defTetailGuide.do",{id:id,groupId:groupId},function(data){
			   		if(data.success){
			   			location.reload()
			   			
			   		}else{
			   			$.info(data.msg);
			   		}
			  },"json");
	}




</script>
</html>

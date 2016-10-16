<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath %>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>	
	<div class="p_container" >
		<form id="queryForm">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />		
			
			<div class="p_container_sub" >
		    	<div class="searchRow">
	                <ul>
	                    <li class="text">名字</li>
	                    <li><input type="text" name="name" class="IptText300" /></li>
						<li class="text">区域</li><li>
	                    	<select name="provinceId" id="provinceId" class="input-small">
								<option value="">请选择省</option>	
								<c:forEach items="${allProvince}" var="province">
									<option value="${province.id }">${province.name }</option>
								</c:forEach>						
							</select> 
							<select name="cityId" id="cityId" class="input-small">
								<option value="">请选择市</option>
							</select>
	                    </li>
	                    <li class="text"></li>
	                    <li>
		                	<input type="button" id="btnQuery" class="button button-primary button-small" value="搜索">							                   
	                    </li>
	                    <li class="clear"/>
	                </ul>	                
		    	</div>
	        </div>
		</form>		
	</div>
		<div id="guideDiv" class="p_container w-800 m-a" style="width:900px;">
			<%-- <jsp:include page="imp-guide-list-table.jsp"></jsp:include> --%>
		</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	queryList();
});

$("#btnQuery").on("click",function(){
	queryList();
});

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"impGuideList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#guideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		alert("服务忙，请稍后再试");
    	}	  
    }
    $("#queryForm").ajaxSubmit(options);	
}

 var region = new Region('<%=ctx%>',"provinceId","cityId");
region.init();

 function getGuide(){
	if($('input:radio[name=subRad]:checked').length==0){
		$.warn("请选择导游！");
		return false;
	}else{
		 var id=$('input:radio[name=subRad]:checked').attr("gid");
			
		 var name=$('input:radio[name=subRad]:checked').attr("gname");
		 var mobile=$('input:radio[name=subRad]:checked').attr("gmobile");
		 var guide = {id:id,name:name,mobile:mobile};
		
		 return guide;
	}
	
} 

</script>
</html>
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
	                    <li class="text">姓名</li>
	                    <li><input type="text" name="name"  /></li>
						<li class="text">等级</li>
						<li>
							<select name="level">
								<option value="">全部</option>
								<c:forEach items="${djList }" var="dj">
									<option value="${dj.id }">${dj.value }</option>
								</c:forEach>
							</select>
						</li>
	                    <li class="text">手机号</li>
						<li><input type="text" name="mobile" /></li>
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
		<div id="guideDiv" class="p_container w-890 m-a">
			<jsp:include page="impGuideArchivesList-table.jsp"></jsp:include>
		</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
$("#btnQuery").on("click",function(){
	queryList(1,10);
});

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 10;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"impGuideArchivesList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#guideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}	  
    }
    $("#queryForm").ajaxSubmit(options);	
}

var region = new Region('<%=ctx%>',"provinceId","cityId");
region.init();

function getGuideList(){
	 var arr = new Array();
	 $('input[name="subBox"]').each(function(){
		 if($(this).attr("checked") == "checked"){
			 arr.push({guideId:$(this).attr("guideId")});
		 }
	 });
	 
	 return arr;
}

</script>
</html>
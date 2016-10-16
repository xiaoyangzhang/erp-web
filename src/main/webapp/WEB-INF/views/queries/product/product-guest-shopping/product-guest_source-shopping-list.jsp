<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>产品客源地购物分析</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="/WEB-INF/include/top.jsp" %>
   
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
        <script type="text/javascript" src="<%=staticPath%>/assets/js/web-js/sales/regional.js"></script>
    
     <script type="text/javascript">
     	$(function(){
     		var vars={
     	   			 dateFrom : $.currentMonthFirstDay(),
     	   		 	dateTo : $.currentMonthLastDay()
     	   		 	};
     		$("#dateStart").val(vars.dateFrom);
     		$("#dateEnd").val(vars.dateTo );	
     		
     		
     	})
     </script>
</head>

<body>
    <div class="p_container" >
      <div id="tabContainer">
<form  id="queryForm">
		<input name="page" type="hidden" id="page"/>
	    <input type="hidden" id="pageSize" name="pageSize"/>
	    <div class="p_container_sub" id="list_search">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">日期:</div>
	    			<div class="dd_right grey">
						<input type="text" id="dateStart" name="dateStart" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="dateEnd" name="dateEnd" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">省份:</div>
	    			<div class="dd_right grey">
	    				<select id="provinceCode" name="provinceId">
	    					<option value="">请选择</option>
	    					<c:forEach items="${allProvince}" var="province">
								<option value="${province.id }">${province.name }</option>
							</c:forEach>
	    				</select>
	    				<select name="cityId" id="cityCode" class="input-small">
									
						</select>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">品牌:</div>
	    			<div class="dd_right grey">
	    				 <input type="text" name="productBrandName" id="productBrandName" value="" class="w-200"/> 
	    				
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="operatorName" id="operatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    		</dd>	    		
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" id="btnQuery" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
	    					
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	<dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" id="contentDiv" >
                    
    			 </div>
				 <div class="clear"></div>
	    		</dd>
            </dl>
        </div>
        
      </div><!--#tabContainer结束-->
    </div>
    
    
<script type="text/javascript">
$(document).ready(function () {
	queryList();
});
function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}
 function queryList(page,pageSize) {
	     if (!page || page < 1) {
	    	page = 1;
	    } else{
	    	$("#page").val(page);
	    }
	     if (!pageSize ) {
	    	pageSize = 10;
	    } else{
	    	$("#pageSize").val(pageSize);
	    }
	    var url="guestSourceShoppingList.do";
	    
	    var options = {
			url:url,
	    	type:"post",
	    	dataType:"html",
	    	success:function(data){
	    		$("#contentDiv").html(data);
	    	},
	    	error:function(XMLHttpRequest, textStatus, errorThrown){
	    		$.error("服务忙，请稍后再试");
	    	}	  
	    }
	    $("#queryForm").ajaxSubmit(options);	
	} 
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>结算单</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
     $(function() {
    	 var vars={
       			 dateFrom : $.currentMonthFirstDay(),
       		 	dateTo : $.currentMonthLastDay()
       		 	};
       		 	$("#startMin").val(vars.dateFrom);
       		 	 $("#startMax").val(vars.dateTo );	
 		//setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="fin.selectSettleListPage" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期:</li>
					<li><input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="start_max" id="startMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">团号:</li>
					<li><input name="group_code" id="group_code" type="text"/></li>
					<li class="text">产品名称:</li>
					<li><input name="product_name" id="product_name" type="text"/></li>
					<li class="clear"/>
					
				<!-- </ul>
				<ul> -->
	    			<li class="text">部门:</li>
	    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			<li class="text">计调:</li>
	    			<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
					<li class="text">团状态:</li>
					<li><select name="group_state" id="group_state">
							<option value="" selected="selected">全部</option>
							<option value="1">已确认</option>
							<option value="3">已审核</option>
							<option value="4">封存</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
						<input type="reset" class="button button-primary button-small" value="重置">
						<a href="javascript:void(0)"  onclick="toPreviewProfit()"  class="button button-primary button-small" >
						打印预览</a>
					</li>
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"<%=staticPath%>/query/settleListPage.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function() {
	queryList();
});
function toPreviewProfit(){
	window.open("<%=ctx%>/query/groupProfitPreview.htm?start_min="+
			$("#startMin").val()+"&start_max="+$("#startMax").val()+"&group_code="+$("#group_code").val()+"&product_name="+$("#product_name").val()
			+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()+"&group_state="+$("#group_state").val()
			+"&sl="+$("input[name='sl']").val()
			);
}
</script>
</html>
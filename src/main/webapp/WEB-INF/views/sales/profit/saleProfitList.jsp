<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>销售利润统计</title>
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
	<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="saleProfitForm">
					<input type="hidden" name="page" id="page" />
					<input type="hidden" name="pageSize" id="pageSize" />
					<ul>
						<li class="text">出团日期:</li>
						<li>
							<input type="text" id="tourGroupStartTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.startTime}" pattern="yyyy-MM-dd"/>'/>
							~ 
							<input type="text" id="tourGroupEndTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.endTime}" pattern="yyyy-MM-dd"/>'/>
						</li>
						<li class="text">团号:</li><li><input type="text" name="groupCode" id="groupCode"/></li>
						<li class="text">产品:</li><li><input type="text" name="productName" id="productName"/></li>
					</ul>
					<ul>
						<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()" style="width: 185px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>
						</li>
						<li class="text">计调:</li>
						<li>
							<input type="text" name="operatorName" id="operatorName" stag="userNames" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
						<li style="padding-left:10px">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
						</li>
						<li class="clear"></li>
						</ul>
						
				</form>
			</div>
			</div>
			<dl class="p_paragraph_content">
					<div id="content"></div>
			</dl>

	</div>
</body>
<script type="text/javascript">
function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"toSaleProfitTableByTour.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#saleProfitForm").ajaxSubmit(options);	
}

$(function() {
	setData();
	queryList();
});

function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}

function setData(){
	var curDate=new Date();
	 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
	 $("#tourGroupStartTime").val(startTime);
	var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
     $("#tourGroupEndTime").val(endTime);			
}
</script>
</html>

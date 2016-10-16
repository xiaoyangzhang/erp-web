<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<script type="text/javascript">
$(function() {
	var vars={
			 curDate : $.currentDay()
		 	};
		 	$("#startTime").val(vars.curDate);

 
});
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form method="post" id="groupDateStartListForm">
					<input type="hidden" name="page" id="orderPage"/> 
					<input type="hidden" name="pageSize" id="orderPageSize" value="${pageSize}"/> 
					<input type="hidden" name="operType" value="1" />
					<dd class="inl-bl">
						<div class="dd_left">今日出团:</div>
						<div class="dd_right grey">
							<input name="startTime" id="startTime" type="text" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">部门:</div>
						<div class="dd_right">
							<input type="text" name="orgNames" id="orgNames" stag="orgNames"
								readonly="readonly" onclick="showOrg()" /> <input name="orgIds"
								id="orgIds" stag="orgIds" type="hidden" value="" /> 操作计调: <input
								type="text" name="operatorName" id="saleOperatorName"
								stag="userNames" readonly="readonly" onclick="showUser()" /> <input
								name="operatorIds" id="saleOperatorIds" stag="userIds"
								type="hidden" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团类型:</div>
						<div class="dd_right">
							<select name="groupMode" class="w-100bi">
								<option value="">全部</option>
								<option value="1">散客</option>
								<option value="2">团队</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
				
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()"
								class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">

				<div id="content_start"></div>
			</dl>

		</div>

	</div>
	<script type="text/javascript">

	$(document).ready(function () {
		searchBtn();
	});  
	
	function queryList(page,pageSize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#orderPage").val(page);
		$("#orderPageSize").val(pageSize);
		var options = {
				url:"groupDateQueryData.do",
		    	type:"post",
		    	dataType:"html",
		    	success:function(data){
		    		$("#content_start").html(data);
		    	},
		    	error:function(XMLHttpRequest, textStatus, errorThrown){
		    		$.error("服务忙，请稍后再试");
		    	}
		    };
		    $("#groupDateStartListForm").ajaxSubmit(options);	
	}

	function searchBtn() {
		var pageSize=$("#orderPageSize").val();
		queryList(1,pageSize);
	}

	</script>
</body>
</html>
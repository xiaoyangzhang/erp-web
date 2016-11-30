<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>利润查询</title>
<%@ include file="../../../include/top.jsp"%>

	<script type="text/javascript">
     	$(function(){
     		var date={
     				 dateFrom : $.currentMonthFirstDay(),
         		 	dateTo : $.currentMonthLastDay()
         		 	};
         		 	$("#tourGroupStartTime").val(date.dateFrom);
         		 	 $("#tourGroupEndTime").val(date.dateTo );	
     		queryList();
     	})
     	function queryList(page,pageSize){
     		if(!page || page<1){
     			$("#page").val(1);
     		}
     		$("#page").val(page);
     		$("#pageSize").val(pageSize);
     		var options={
     			url:"bookingProfit.do",
     			type:"post",
     			dataType:"html",
     			success:function(data){
     				$("#content").html(data);
     			},
     			error:function(XMLHttpRequest,msg){
     				$.error("服务器忙，请稍后再试");
     			}
     		};
     		$("#form").ajaxSubmit(options);
     	}
     	function searchBtn(){
     		queryList();
     	}
     </script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="form">
					<input type="hidden" name="page" id="page" value="${page.page }" />
					<input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize }" />
					<ul>
						<li class="text">出团日期:</li>
						<li>
							<input type="text" id="tourGroupStartTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.startTime}" pattern="yyyy-MM-dd"/>'/> 
							~
							<input type="text" id="tourGroupEndTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.endTime}" pattern="yyyy-MM-dd"/>'/>
						</li>
					
						<li class="text">团号:</li>
						<li>
							<input type="text" name="groupCode" id="groupCode"/>
						</li>
					
						<li class="text">产品:</li>
						<li>
							<input type="text" name="productName" id="productName"/>
						</li>
						<li class="text">部门:</li>
						<li>
	    					<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</li>    		
						<li>计调:</li>
						<li>
							<input type="text" name="operatorName" id="operatorName" stag="userNames" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
					
						<li>
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
							<a href="javascript:void(0);" id="toProfitOperatorNameExcelId" target="_blank" onclick="toProfitOperatorNameExcel()" class="button button-primary button-small">导出到Excel</a>
						</li>
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
/* 内部结算（计调）导出到Excel */
function toProfitOperatorNameExcel(){
	$("#toProfitOperatorNameExcelId").attr("href","toProfitOperatorExcel.do?startTime="+$("#tourGroupStartTime").val()
			+"&endTime="+$("#tourGroupEndTime").val()
			+"&groupCode="+$("#groupCode").val()
			+"&productName="+$("#productName").val()
			+"&orgIds="+$("#orgIds").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&page="+$("#page").val()
			+"&pageSize="+$("#pageSize").val());
}
</script>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>部门订单分析</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=staticPath%>/assets/js/web-js/sales/regional.js"></script>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	<script type="text/javascript">
	
	$(function() {
		var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
		 $("input[name='startTime']").val(vars.dateFrom);
		 $("input[name='endTime']").val(vars.dateTo ); 
});
	</script>
</head>
<body>
	<div class="p_container">
		
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" value="" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期</li>
						<li><select id="dateType" name="dateType">
							<option value="0">输单日期</option>
							<option value="1">订单日期</option>
						</select>
					<%-- <input id="startTime" name="startTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){changeMaxDate();}})" value="${startTime }" />
					~<input id="endTime" name="endTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){changeMaxDate();}})"  value="${endTime }" /> --%>
					<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
						~ 
					<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">产品名称：</li>
					<li><input id="productName"  name="productName" type="text"/></li>
					<li class="text">组团社</li>
					<li><input id="supplierName"  name="supplierName" style="width: 200px" type="text"/></li>
					<li class="text">部门:</li>
					<li>
    					<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
					</li>
					<li class="text">销售:</li>
					<li>	<!-- <select name="operType">
								<option value="0">操作计调</option>
								<option value="1">销售计调</option>
							</select> -->
							<input type="text" name="saleOperatorName" id="saleOperatorName"  stag="userNames" readonly="readonly"  onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
					</li>
						<li class="text"></li>
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<!-- <dl class="p_paragraph_content">
		
			<div style="padding-left:20px; padding-right:20px;">
				<button type="button" style="float:left;" onclick="dateGo(-7);" class="button button-primary button-small">前7天</button>
				<button type="button" style="float:right;" onclick="dateGo(7);" class="button button-primary button-small">后7天</button>
			</div>
			<div class="clear"></div>
	</dl> -->
	<div id="tableDiv"></div>
	<script type="text/javascript">
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/departmentOrderListPage.do",
				type:"post",
				dataType:"html",
				
				success:function(data){
					$("#tableDiv").html(data);
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					$.error("服务忙，请稍后再试");
				}
		};
		$("#form").ajaxSubmit(options);	
		
	}
	$("#btnQuery").click(function(){
		 queryList(1,$("#pageSize").val());
	})
	$(function(){
			queryList();
		})
		
function changeMaxDate(){
	var dateStr =  $("#startTime").val();	
	var date = new Date(dateStr.replace(/-/g,"/"));
	var maxDate = new Date(date.valueOf() + 6*24*60*60*1000);
	var year = maxDate.getFullYear();
	var month = maxDate.getMonth()+1;
	var day = maxDate.getDate();
	var maxDateStr = year+"-";
	if(month<10){maxDateStr+="0"+month+"-"}
	else{maxDateStr+= month+"-"};
	if(day<10){maxDateStr+="0"+day+""}
	else{maxDateStr += day+"";}
	$("#endTime").val(maxDateStr);
}

function changeMinDate(){
	var dateStr =  $("#endTime").val();	
	var date = new Date(dateStr.replace(/-/g,"/"));
	var minDate = new Date(date.valueOf() - 6*24*60*60*1000);
	
	var year = minDate.getFullYear();
	var month = minDate.getMonth()+1;
	var day = minDate.getDate();
	var minDateStr = year+"-";
	if(month<10){minDateStr+="0"+month+"-"}
	else{minDateStr+= month+"-"};
	if(day<10){minDateStr+="0"+day+""}
	else{minDateStr += day+"";}
	
	$("#startTime").val(minDateStr);
}
		
	/* function dateGo(day){
		//修改开始日期
		var dateStr =  $("#startTime").val();	
		var date = new Date(dateStr.replace(/-/g,"/"));
		var curDate = new Date(date.valueOf() + day*24*60*60*1000);
		var year = curDate.getFullYear();
		var month = curDate.getMonth()+1;
		var day = curDate.getDate();
		var curDateStr = year+"-";
		if(month<10){curDateStr+="0"+month+"-"}
		else{curDateStr+= month+"-"};
		if(day<10){curDateStr+="0"+day+""}
		else{curDateStr += day+"";}
		$("#startTime").val(curDateStr);
		//修改结束日期
		dateStr =  $("#startTime").val();	
		date = new Date(dateStr.replace(/-/g,"/"));
		var maxDate = new Date(date.valueOf() + 6*24*60*60*1000);
		var year = maxDate.getFullYear();
		var month = maxDate.getMonth()+1;
		var day = maxDate.getDate();
		var maxDateStr = year+"-";
		if(month<10){maxDateStr+="0"+month+"-"}
		else{maxDateStr+= month+"-"};
		if(day<10){maxDateStr+="0"+day+""}
		else{maxDateStr += day+"";}
		$("#endTime").val(maxDateStr);
		
		queryList();
	} */
	</script>
</body>
</html>
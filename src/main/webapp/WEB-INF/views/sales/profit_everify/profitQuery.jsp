<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
	<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="profitGroupListForm">
					<input type="hidden" name="page" id="page" value="${page.page }">
					<input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize}">
					<ul>
						<li class="text">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</li>
						<li>
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">团号:</li><li><input name="groupCode" id="groupCode" type="text"/> </li>
						<li class="text">客人:</li><li><input name="receiveMode" id="receiveMode" type="text" style="width: 218px;"/> </li>
						<li class="text">客户:</li><li><input name="supplierName" id="supplierName" type="text" /> </li>
					</ul>
					<ul>
						<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames"readonly="readonly" onclick="showOrg()" style="width:186px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" type="hidden" />
						</li>
						<li class="text">
							<select name="operType" id="operType">
								<option value="1">销售</option>
								<option value="2">计调</option>
								<option value="3">输单</option>
							</select>
						</li>
						<li>
							<input id="saleOperatorName" type="text" name="saleOperatorName" stag="userNames" readonly="readonly" onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
						<li class="text">产品:</li>
						<li>
							<select name="productBrandId" id="productBrandId" style="width:80px"><option value=""
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select><input name="productName" id="productName" type="text" 　placeholder="请输入产品名称"/>
						</li>
						<li class="text">业务:</li><li>
						<select name="orderMode" id="orderMode">
								<option value="">请选择</option>
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}">${v.value}</option>
							</c:forEach>		
							</select>
						</li>
					</ul>
					<ul>
						<li class="text">状态:</li><li> <select name="stateFinance" id="stateFinance">
								<option value="">审核状态</option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
							</select><select name="orderLockState" id="orderLockState">
								<option value="">流程状态</option>
								<option value="0">未提交</option>
								<option value="1">接收中</option>
								<option value="2">已接收</option>
							</select>
						</li>
						<li style="padding-left:10px">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small">查询</button>
							<a href="javascript:void(0);" id="toProfitSaleExcelId" target="_blank" onclick="toProfitSaleExcel()" class="button button-primary button-small">导出到Excel</a>
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
function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"toProfitEverifyTable.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#profitGroupListForm").ajaxSubmit(options);	
}

$(function() {
	setData()
	queryList();
});

function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}
function setData(){
	var curDate=new Date();
	 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
	 $("#startTime").val(startTime);
	var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
     $("#endTime").val(endTime);			
}

/* 内部结算（销售）导出到Excel */
function toProfitSaleExcel(){
	$("#toProfitSaleExcelId").attr("href","toProfitSaleExcel.do?startTime="+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&dateType="+$("#dateType").val()
			+"&groupCode="+$("#groupCode").val()
			+"&receiveMode="+$("#receiveMode").val()
			+"&orgIds="+$("#orgIds").val()
			+"&operType="+$("#operType").val()
			+"&supplierName="+$("#supplierName").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&productName="+$("#productName").val()
			+"&productBrandId="+$("#productBrandId").val()
			+"&orderMode="+$("#orderMode").val()
			+"&stateFinance="+$("#stateFinance").val()
			+"&orderLockState="+$("#orderLockState").val()
			+"&page="+$("#page").val()
			+"&pageSize="+$("#pageSize").val());
}
</script>
</html>
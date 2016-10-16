<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style type="text/css">
		.w_table thead tr td{height:30px; text-align: center;font-weight:700; border: 1px solid #a3c1e9;background:#f4f5f6;}
	</style>
	<script type="text/javascript">
	$(function() {
		function setData(){
			var curDate=new Date();
			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
			 $("input[name='startTime']").val(startTime);
			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
		    var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
			var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
		     $("input[name='endTime']").val(endTime);			
		}
		setData();
	})
	</script>
</head>
<body>
    <div class="p_container" >
    <form id="queryForm">
		<input type="hidden" name="page" id="page" value="1"/>
		<input type="hidden" name="pageSize" id="pageSize" value="10"/>
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_right grey">						
	    				出团日期:
						<input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品品牌：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productBrandName" id="productBrandName" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
	    		</dd>
				
	    		<dd class="inl-bl">
	    			<div class="dd_left">类型：</div>
	    			<div class="dd_right">
	    				<select name="type" id="type">
	    					<option value="">全部</option>
	    					<option value="0">散客</option>
	    					<option value="1">团队</option>
	    				</select>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
					<div class="dd_left">
						<a href="javascript:void();" id="btn_audit" onclick="print();" class="button button-primary button-rounded button-small">打印</a>   				
	    			</div>
	    			<a href="javascript:archive('Incremental');" class="button button-primary button-small button-green">归档</a>
	    			<!-- <div class="dd_left">
						<button type="button" onclick="archive();" class="button button-primary button-rounded button-small">归档</button>
	    			</div> -->
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    	<dl class="p_paragraph_content" style="margin-top:0px;margin-bottom:0px;text-align:right;">
    			<dd>最新归档时间：${recordEndTime}</dd>
    		</dl>
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>
    <div id="showApplyDiv"></div>           
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>      
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function archive(type){
	if (type=='All'){
		if (!confirm("确定要执行全归档？这要花几分钟的时间")){return;}
		var openUrl = "<%=path%>/tjGroup/archiveAllGroupProfit.do";//弹出窗口的url
	}else {
		var openUrl = "<%=path%>/tjGroup/archiveIncrementalGroupProfit.do";//弹出窗口的url
	}
	var iWidth=400; //弹出窗口的宽度;
	var iHeight=200; //弹出窗口的高度;
	var iTop = (window.screen.availHeight-30-iHeight)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-iWidth)/2; //获得窗口的水平位置;
	window.open (openUrl,'归档','height='+ iHeight +',width='+ iWidth +',top='+ iTop +',left='+ iLeft +',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}

<%-- function archive(){
	var openUrl = "<%=path%>/tjGroup/initGroupProfitTable.do";//弹出窗口的url
	var iWidth=400; //弹出窗口的宽度;
	var iHeight=200; //弹出窗口的高度;
	var iTop = (window.screen.availHeight-30-iHeight)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-iWidth)/2; //获得窗口的水平位置;
	window.open (openUrl,'归档','height='+ iHeight +',width='+ iWidth +',top='+ iTop +',left='+ iLeft +',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
} --%>

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 15;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/tjGroup/selectLineProfitList.do",
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

function print(){
	window.open ("<%=staticPath%>/tjGroup/lineProfitPrint.htm?"+ $("#queryForm").serialize());
}

</script>
</html>

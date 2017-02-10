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
    <title>下接社列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript">
	$(function() {
		var vars={dateFrom : $.currentMonthFirstDay(),dateTo : $.currentMonthLastDay()};
		$("#groupDateStart").val(vars.dateFrom);
		$("#groupDateEnd").val(vars.dateTo );	
	});
	</script>
</head>
<body>
    <div class="p_container">
    	<form id="queryForm">
    		<input type="hidden" id="searchPage" name="page"  />
    		<input type="hidden" id="searchPageSize" name="pageSize"  />
    		<input type="hidden" id="supplierType" name="supplierType"  value="${supplierType }"/>
    		<input type="hidden" id="isShow" name="isShow"  value="${isShow }"/>
    		<input  type="hidden" id="selectDate" name="selectDate" value="0">
    		<div class="p_container_sub" >
				<div class="searchRow">
					<ul>
						<li class="text">团日期:</li>
		    			<li>						
							<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
		    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
		    			</li>
			    			
		    			<li class="text">团号:</li>
		    			<li>
		    				<input type="text" name="groupCode" id="" value="" class="w-200"/>
		    			</li>
		    			
		    			<li class="text">产品名称:</li>
		    			<li>
		    				<input type="text" name="productBrandName" id="" value="" class="w-200"/>
		    			</li>
		    			
		    			<li class="text">下接社名称:</li>
		    			<li>
		    				<input type="text" name="supplierName" id="supplierName" value="" class="w-200"/>
		    			</li>
					</ul>
					<ul>
						<li class="text">部门:</li>
		    			<li>
		    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" style="width: 187px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
		    			</li>
		    			<li class="text">计调:</li>
		    			<li>
		    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()" style="width: 200px;"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
		    			</li>
		    			<li class="text">安排状态:</li>
		    			<li>
		    				 <select class="select160" name="arrangementState">
									<option value="">全部</option>
									<option value="1">已安排</option>
									<option value="0">未安排</option>
									
								</select>
		    			</li>
		    			<li class="text"></li>
		    			<li>
		    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
		    			</li>
					</ul>
				</div>
			</div>
    		
    	</form>
    	<div id="tableDiv"></div>
    </div>
    
</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
<script type="text/javascript">
$(document).ready(function () {
	queryList();
	$("#tabContainer").idTabs();
});  
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}	
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var isShow = $("#isShow").val();
	var options = {
		url:"deliveryList2.do",
    	type:"post",
    	dataType:"html",
    	date:{isShow:isShow},
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	var pageSize=$("#searchPageSize").val();
	queryList(1,pageSize);
}

/**
 * 页面选择部分调用函数(多选)
 */
function selectUserMuti(num){
	var width = window.screen.width ;
	var height = window.screen.height ;
	var wh = (width/1920*650).toFixed(0) ;
	var hh = (height/1080*500).toFixed(0) ;
	wh = wh+"px" ;
	hh = hh+"px" ;
	var lh = (width/1920*400).toFixed(0) ;
	var th = (height/1080*100).toFixed(0) ;
	lh = lh+"px" ;
	th = th+"px" ;
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		offset : [th,lh],
		area : [wh,hh],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList();   
			
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
				}
			}
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 重置查询条件
 */
function multiReset(){
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
	
}

</script>

</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游订单审核</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript">
     $(function() {
    	 var vars={
 				 dateFrom : $.currentMonthFirstDay(),
 			 	dateTo : $.currentMonthLastDay()
 			 	};
 		$("#groupDateStart").val(vars.dateFrom);
 		$("#groupDateEnd").val(vars.dateTo );	
 	
 	 
 });
     </script>
     	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
     
</head>
<body>
    <div class="p_container" >
      <div id="tabContainer">    

	    <div class="p_container_sub" id="list_search">
	    	<form id="searchBookingGuideForm">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">团日期:</div>
	    			<div class="dd_right grey">
	    			<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value="${page.pageSize }"/>
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode" id="" value="" class="w-200" style="width: 120px"/>
	    			</div>
	    			
	    		</dd>
	    			<dd class="inl-bl">
	    			<div class="dd_left">产品名称:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="productBrandName" id="" value="" class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">部门:</div>
	    			<div class="dd_right">
	    			<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">计调:</div>
	    			<div class="dd_right">
	    			<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
							</div>
	    			
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游名称:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="guideName" id="guideName" value="" class="w-200" style="width: 130px"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态:</div>
	    			<div class="dd_right grey">
	    				<select name="state" id="state">
	    					<option value="">全部</option>
	    					<option value="0">未报账</option>
	    					<option value="1">计调处理中</option>
	    					<option value="2">财务处理中</option>
	    					<option value="3">已报账</option>
	    				</select>
	    			</div>
	    			
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">锁单状态:</div>
	    			<div class="dd_right grey">
	    				<select name="stateLockType" id="stateLockType">
	    					<option value="">全部</option>
	    					<option value="0">未锁</option>
	    					<option value="1">已锁</option>
	    				</select>
	    			</div>
	    			
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	
            <dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" id="bookingGuideDiv" >
                     
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
    
    
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"lockListTable.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#bookingGuideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchBookingGuideForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList(null,$("#searchPageSize").val());
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
</body>
</html>

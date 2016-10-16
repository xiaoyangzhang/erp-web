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
    <title>计调管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../../include/top.jsp" %>
   
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/js/web-js/kalendae/kalendae.css"/>
    
    <script type="text/javascript" src="../assets/js/jquery.idTabs.min.js"></script>
    <script src="<%=staticPath %>/assets/js/web-js/kalendae/kalendae.standalone.js" type="text/javascript"></script>
     <script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#startTime").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		    var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 			var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#endTime").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>

<body>
    <div class="p_container" >
      <div id="tabContainer">
<form action="" id="queryForm">
		<input name="page" type="hidden" id="page" value="1"/>
	    <input type="hidden" id="pageSize" name="pageSize"  value=""/>
		<input  type="hidden" id="supplierType" name="supplierType" value="${supplierType }">
		<input  type="hidden" id="selectDate" name="selectDate" value="0">
	    <div class="p_container_sub" id="list_search">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">出团日期:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="startTime" id="startTime" value="" readonly="readonly" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> —
	    				<input type="text" name="endTime" id="endTime" value="" readonly="readonly" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode" id="groupCode" value="" class="w-200" style="width: 120px"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称:</div>
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
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
	    			</div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">安排状态:</div>
	    			<div class="dd_right grey">
	    				 <select class="select160" name="arrangementState">
								<option value="">全部</option>
								<option value="1">已安排</option>
								<option value="0">未安排</option>
								
							</select>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    		
	    			<div class="dd_left">供应商名称：</div>
	    		
	    			<div class="dd_right grey">
	    				<input type="text" name="supplierName" id="supplierName" value="" class="w-200" style="width: 180px"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" id="btnQuery" class="button button-primary button-small">搜索</button>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	<div id="supplierDiv">
			<%-- <jsp:include page="supplier-list-table.jsp"></jsp:include> --%>
			</div>
        </div>
        
      </div><!--#tabContainer结束-->
    </div>
    
    
<script type="text/javascript">
$(function() {
		
	queryList();
	
	 
});
 $("#btnQuery").click(function(){
	 queryList();
 })
 function queryList(page,pageSize) {
	    if (!page || page < 1) {
	    	page = 1;
	    }
	    $("#page").val(page);
	    $("#pageSize").val(pageSize);
		 var url="golfList.do";
	    	
	    
	    
	    var options = {
			url:url,
	    	type:"post",
	    	dataType:"html",
	    	//data:{
	    	//	pageSize:pageSize
	    		//saleOperatorName:$("#saleOperatorName").val(),
	    		//saleOperatorIds:$("#saleOperatorIds").val()
	    	//},
	    	success:function(data){
	    		$("#supplierDiv").html(data);
	    	},
	    	error:function(XMLHttpRequest, textStatus, errorThrown){
	    		$.error("服务忙，请稍后再试");
	    	}	  
	    }
	    $("#queryForm").ajaxSubmit(options);	
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
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</body>
</html>

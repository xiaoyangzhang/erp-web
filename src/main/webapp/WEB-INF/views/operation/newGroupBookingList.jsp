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
    <title>计调统计信息</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript" src="<%=staticPath %>/assets/js/largetab.js"></script>
     <script type="text/javascript">
     	$(function(){
     		var vars={
     				 dateFrom : $.currentMonthFirstDay(),
     			 	dateTo : $.currentMonthLastDay()
     			 	};
     		$("#groupDateStart").val(vars.dateFrom);
     		$("#groupDateEnd").val(vars.dateTo );	
     		
     	})
     </script>
</head>

<body>
    <div class="p_container" >
      <div id="tabContainer">
<form  id="queryForm">
		<input name="page" type="hidden" id="page"/>
	    <input type="hidden" id="pageSize" name="pageSize"/>
	    <div class="p_container_sub" id="list_search">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">团日期:</div>
	    			<div class="dd_right grey">
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode" id="groupCode" value="" class="w-120"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="productBrandName" id="productBrandName" value="" class="w-120"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团类别:</div>
	    			<div class="dd_right grey">
						<select id="groupMode" name="groupMode">
							<option value="">请选择</option>
							<option value="1">团队</option>
							<option value="0">散客</option>							
						</select>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">接站牌:</div>
	    			<div class="dd_right grey">
						<input type="text" name="receiveMode" id="receiveMode" value="" class="w-120"/>
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
	    			<div class="dd_left">类型:</div>
	    			<div class="dd_right grey">
						<select id="supplierType" name="supplierType">
							<option value="">请选择</option>
							<option value="8">导游</option>
							<option value="3">酒店</option>
							<option value="4">车辆</option>
							<option value="2">餐厅</option>
							<option value="5">景点</option>
							<option value="9">飞机</option>
							<option value="10">火车</option>
							<option value="15">保险</option>
							<option value="16">下接社</option>
						</select>
	    				<input type="text" name="supplierName" id="supplierName" value="" class="w-120"/>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" id="btnQuery" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
	    					
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	<dl class="p_paragraph_content">
    			 <div id="supplierDiv2" >
                    
    			 </div>
				 <div class="clear"></div>
            </dl>
        </div>
        
      </div><!--#tabContainer结束-->
    </div>
     
<script type="text/javascript">
$(document).ready(function () {
	queryList();
});
function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}
 function queryList(page,pageSize) {
	     if (!page || page < 1) {
	    	page = 1;
	    } else{
	    	$("#page").val(page);
	    }
	     if (!pageSize ) {
	    	pageSize = 10;
	    } else{
	    	$("#pageSize").val(pageSize);
	    }
	    var url="newGroupBookingTable.do";
	    
	    var options = {
			url:url,
	    	type:"post",
	    	dataType:"html",
	    	success:function(data){
	    		$("#supplierDiv2").html(data);
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
 
 function showSightBooking(groupId){
	 showInfo("门票安排","850px","500px",'<%=ctx %>/booking/newGroupSightBookingInfo.htm?groupId='+groupId);
 }
 
 function showHotelBooking(groupId){
	 showInfo("酒店安排","850px","500px",'<%=ctx %>/booking/newGroupHotelBookingInfo.htm?groupId='+groupId);
 }
 
 function showEatBooking(groupId){
	 showInfo("餐厅安排","850px","500px",'<%=ctx %>/booking/newGroupEatBookingInfo.htm?groupId='+groupId);
 }
 
 function showCarBooking(groupId){
	 showInfo("车辆安排","850px","500px",'<%=ctx %>/booking/newGroupCarBookingInfo.htm?groupId='+groupId);
 }
 
 function showAirBooking(groupId){
	 showInfo("机票安排","850px","500px",'<%=ctx %>/booking/groupAirTicketBookingInfo.htm?groupId='+groupId);
 }
 
 function showTrainBooking(groupId){
	 showInfo("火车票安排","850px","500px",'<%=ctx %>/booking/groupTrainTicketBookingInfo.htm?groupId='+groupId);
 }
 
 function showInsuranceBooking(groupId){
	 showInfo("保险安排","850px","500px",'<%=ctx %>/booking/groupInsuranceBookingInfo.htm?groupId='+groupId);
 }
 
 function showShopBooking(groupId){
	 showInfo("购物店安排","850px","500px",'<%=ctx %>/bookingShop/groupShopBookingList.htm?groupId='+groupId);
 }
 
 function showIncomeBooking(groupId){
	 showInfo("其他收入","850px","500px",'<%=ctx %>/booking/groupIncomeBookingInfo.htm?groupId='+groupId);
 }
 
 function showOutcomeBooking(groupId){
	 showInfo("其他支出","850px","500px",'<%=ctx %>/booking/groupOutcomeBookingInfo.htm?groupId='+groupId);
 }
 
 function showDeliveryBooking(groupId){
	 showInfo("下接社安排","850px","500px",'<%=ctx %>/booking/groupDeliveryBookingList.htm?gid='+groupId);
 }
 
 function showNewDeliveryBooking(groupId){
	 showInfo("下接社安排","850px","500px",'<%=ctx %>/booking/newGroupDeliveryBookingList.htm?groupId='+groupId);
 }
 
 function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5,
 		area : [width,height],
 		content : url
 	});
 }
</script>
<style type="text/css">
.db{display:block;}
</style>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>

</body>
</html>

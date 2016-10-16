<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>财务管理-领单</title>
	<%@ include file="../../../include/top.jsp"%>
	<script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#groupDateStart").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#groupDateEnd").val(endTime);			
 		}
 		setData();
 	//queryList();	
 	
 	 
 });
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
	    				<select name="dateType">
	    					<option value="groupDate">团日期</option>
	    					<option value="appliDate">申请日期</option>
	    				</select>
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="groupCode" value="" class="w-200"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productName" id="" value="" class="w-300"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游：</div>
	    			<div class="dd_right">
	    				<input style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showGuideList();" type="text" name="guide" id="guide" value="" class="w-100"/>
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
	    			<div class="dd_left">申请人：</div>
	    			<div class="dd_right">
	    				<input  style="cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" onclick="showList();" type="text" name="applicant" id="applicant" value="" class="w-200"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态：</div>
	    			<div class="dd_right">
	    				<select name="stateType">
	    					<option value="">全部</option>
	    					<option value="APPLIED">已申请</option>
	    					<option value="RECEIVED">已领单</option>
	    					<option value="VERIFIED">已销单</option>
	    				</select>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	    				
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>  
    <div id="showWindowDiv"> </div>    
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>       
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"../finance/billList.do",
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

function showOperateLogs(id,guideId) {
	
	var data = {};
	data.id = id;
	data.guideId = guideId;
	$("#showWindowDiv").load("apply.htm", data);
	
	layer.open({
		type : 1,
		title : '领单申请',
		closeBtn : false,
		area : [ '1000px', '500px' ],
		shadeClose : false,
		content : $("#showWindowDiv"),
		btn : [ '确定', '取消' ],
		yes : function(index) {

			//一般设定yes回调，必须进行手工关闭
			layer.close(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

function distribute(id,guide_id,group_code,guide_name,applicant,appli_time){
	var url = [];
	url.push("<%=staticPath%>/finance/diatributeBill.htm?");
	url.push("id="+ id);
	url.push("guideId="+ guide_id);
	url.push("groupCode="+ group_code);
	url.push("guideName="+ encodeURIComponent(guide_name));
	url.push("applicant="+ encodeURIComponent(applicant));
	url.push("appliTime="+ appli_time);
	newWindow('领单管理-派单', url.join('&'));
}


$(function() {
	queryList();
});

$(function() {
	 $("#applicant").autocomplete({
		  source: function( request, response ) {
			  var name=encodeURIComponent(request.term);
			  $.ajax({
				  type : "get",
				  url : "../finance/fuzzyApplicantList.do",
				  data : {
					  name : name
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {
								  label : v.applicant,
								  value : v.applicant
							  }
						  }));
					  }
				  },
				  error : function(data,msg){
				  }
			  });
		  },
		  focus: function(event, ui) {
			    $(".adress_input_box li.result").removeClass("selected");
			    $("#ui-active-menuitem")
			        .closest("li")
			        .addClass("selected");
			},
		  minLength : 0,
		  autoFocus : true,
		  delay : 300
	});
	 
	 $("#guide").autocomplete({
		  source: function( request, response ) {
			  var name=encodeURIComponent(request.term);
			  $.ajax({
				  type : "get",
				  url : "<%=staticPath %>/finance/guide/getGuideNameList.do",
				  data : {
					  name : name
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {
								  label : v.guide_name,
								  value : v.guide_name
							  }
						  }));
					  }
				  },
				  error : function(data,msg){
				  }
			  });
		  },
		  focus: function(event, ui) {
			    $(".adress_input_box li.result").removeClass("selected");
			    $("#ui-active-menuitem")
			        .closest("li")
			        .addClass("selected");
			},
		  minLength : 0,
		  autoFocus : true,
		  delay : 300
	});
	 
});

function showList(){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $('#applicant').trigger(e);
	}
	
function showGuideList(){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $('#guide').trigger(e);
	}
//取消销单
function delVerify(order_id,guide_id,group_code){
	var type=$('#supplierType').val();
	$.ajax({
		url:"<%=staticPath%>/finance/delVerify.do",
		data:"order_id="+order_id+"&guide_id="+guide_id+"&group_code="+group_code+"&type=delVerify",
		type:"POST",
		success:function(msg){
			searchBtn();
		}
	})
}

//取消领单单
function delReceived(group_id,guide_id){
	var type=$('#supplierType').val();
	$.ajax({
		url:"<%=staticPath%>/finance/delReceived.do",
		data:"group_id="+group_id+"&guide_id="+guide_id,
		type:"POST",
		success:function(msg){
			searchBtn();
		}
	})
}
</script>
</html>

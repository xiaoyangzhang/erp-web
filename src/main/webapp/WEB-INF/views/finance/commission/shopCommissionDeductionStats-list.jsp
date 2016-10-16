<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>购物审核</title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" /> 
	<script type="text/javascript">
	 $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#startMin").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#startMax").val(endTime);			
 		}
 		setData();
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
	    			<div class="dd_right">			
	    				<div class="dd_left">团日期：</div>
						<input type="text" id="startMin" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="startMax" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productName" id="productName" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">部门:</div>
	    			<div class="dd_right">
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden"/>	    				
	    			</div>
	    			<div class="dd_left">计调:</div>
	    			<div class="dd_right">
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" id="guideId" name="guideId" />
	    				<input type="text" id="guideName" name="guideName" value="" ></div>
					<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态:</div>
	    			<div class="dd_right">	
	    			<select name="status">
	    				<option value="">全部</option>
    					<option value="1">已审核</option>
    					<option value="0">未审核</option>
    				</select>
    				</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">录入状态:</div>
	    			<div class="dd_right">	
	    			<select name="lrStatus">
	    				<option value="">全部</option>
    					<option value="1">已录入</option>
    					<option value="0">未录入</option>
    				</select>
    				</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">项目：</div>
	    			<div class="dd_right">
						<input type="text" stag="typeValues" value="" readonly="readonly" onclick="showProjectType()"/>
						<input name="commProjectTypeCodes" stag="typeCodes" value="" type="hidden" />
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
	    			<div class="dd_left">
						<a href="javascript:void();" id="btn_audit" onclick="postCommAudit()" class="button button-primary button-rounded button-small">审核</a>   				
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>
    <div id="showApplyDiv"></div>       
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
    <%@ include file="/WEB-INF/views/component/comm/project_type_multi.jsp" %>         
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
   		url:"<%=path%>/finance/queryShopCommissionDeductionStats.do",
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

function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[name='audit_id']").attr('checked', 'checked');
	} else {
		$("input[name='audit_id']").removeAttr("checked");
	}
}

function postCommAudit(ckbox) {
	var checkedArr = [];
	var unCheckedArr = [];
	$("input[name='audit_id']").each(function(i, o) {
		
		var json = '{"groupId":'+ $(o).attr("groupId") +', \"id\":' + $(o).val() +'}';
		if ($(o).attr("checked")) {
			checkedArr.push(json);
		} else {
			unCheckedArr.push(json);
		}
	});
	var pm = {};
	pm.checkedIds = '['+ checkedArr.join() +']';
	pm.unCheckedIds = '['+ unCheckedArr.join() +']';
	YM.post("<%=staticPath%>/finance/auditCommDeduction.do", pm, function(data) {
		$.success('操作成功');
		queryList();
	});
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
			
			$("#operator_id").val("");
			$("#operator_name").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#operator_name").val($("#operator_name").val()+userArr[i].name);
					$("#operator_id").val($("#operator_id").val()+userArr[i].id);
				}else{
					$("#operator_name").val($("#operator_name").val()+userArr[i].name+",");
					$("#operator_id").val($("#operator_id").val()+userArr[i].id+",");
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
	$("#operator_name").val("");
	$("#operator_id").val("");
	
}

function searchBtn() {
	queryList();
}

$(function(){
	queryList();
});

</script>
</html>

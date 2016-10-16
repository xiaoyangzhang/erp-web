<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>财务管理-领单</title>
	<%@ include file="../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<script type="text/javascript">
     
     </script>
     	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
     
</head>
<body>
    <div class="p_container" >
    <form id="queryForm">

			<input type="hidden" name="page" id="page" value="1"/>
			<input type="hidden" name="pageSize" id="pageSize" value="${pageBean.pageSize }"/>
			<!-- <input type="hidden" name="sl" value="fin.selectSettleListPage" />dataUser
			<input type="hidden" name="rp" value="finance/settle-list-table" /> -->
			
			<input type="hidden" name="dataUser" id="dataUser" value="${dataUser}"/>
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_left">
	    				<select name="dateType">
	    					<option value="groupDate">团日期</option>
	    					<option value="appliDate">申请日期</option>
	    				</select>
	    			</div>
	    			<div class="dd_right grey">						
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="" value="" class="w-200"/>
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
	    				<input type="text" name="guide" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">部门:</div>
	    			<div class="dd_right">
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">计调:</div>
	    			<div class="dd_right">
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">申请人：</div>
	    			<div class="dd_right">
	    				<input type="text" name="applicant" id="" value="" class="w-200"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态：</div>
	    			<div class="dd_right">
	    				<select name="state">
	    					<option value="">全部</option>
	    					<option value="UNAPPLIED">未申请</option>
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
    <div id="showApplyDiv"></div>                
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
   /*  if (!pagesize || pagesize < 1) {
    	pagesize = 10;
    } */
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/booking/receiveOrderList.do",
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
	queryList(null,$("#pageSize").val());
}

//查看领单详情
function showView(groupCode,groupId, guideId, guideName, isAdd) {
	
	var data = {};
	data.groupCode = groupCode;
	data.groupId = groupId;
	data.guideId = guideId;
	data.guideName = guideName;
	data.isAdd = isAdd;
	$("#showApplyDiv").load("apply.htm", data);
	
	layer.open({
		type : 1,
		title : '领单申请',
		closeBtn : false,
		area : [ '1000px', '500px' ],
		shadeClose : false,
		content : $("#showApplyDiv"),
		btn : ['取消' ],
		cancel : function(index) {
			layer.close(index);
		}
	});
}

//申请领单
function applyOrUpdate(groupId, guideId, guideName, type, isAdd) {
	
	var data = {};
	data.groupId = groupId;
	data.guideId = guideId;
	data.guideName = guideName;
	data.isApplyOrUpdate = type;
	if(isAdd){
		data.isAdd = isAdd;	
	}
	
	$("#showApplyDiv").load("apply.htm", data);
	
	layer.open({
		type : 1,
		title : '领单申请',
		closeBtn : false,
		area : [ '1000px', '500px' ],
		shadeClose : false,
		content : $("#showApplyDiv"),
		btn : [ '提交申请', '取消' ],
		yes : function(index) {
			submitApplyList(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

function submitApplyList(index){
	
	var verifyRet = verifyApplyList();
	console.log(verifyRet);
	if(!verifyRet){
		return;
	}
	
	var content = getApplyList();
	$.post("<%=path%>/booking/batchSaveBillDetail.do", {"json":content}, function(data){
		if(data.success){	
			queryList();
			//关闭对话框
			layer.close(index);
   		}else{
   			$.info(data.msg);
   		}
	}, "json");	
}

function deleteBill(groupId, guideId){
	
	var data = {};
	data.groupId = groupId;
	data.guideId = guideId;
	
	$.post("<%=path%>/booking/deleteBill.do", data, function(data){
		if(data.success){	
			queryList();
   		}else{
   			$.info(data.msg);
   		}
	}, "json");	
}

		
	 

$(function() {
	var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
	$("#groupDateStart").val(vars.dateFrom);
	$("#groupDateEnd").val(vars.dateTo );	
	queryList();
});

//取消领单单
function delReceived(group_id,guide_id){
	var type=$('#supplierType').val();
	$.ajax({
		url:"<%=staticPath%>/finance/delReceived.do",
		data:"group_id="+group_id+"&guide_id="+guide_id,
		type:"POST",
		success:function(msg){
		 	queryList();
		}
	})
}
</script>
</html>

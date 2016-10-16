
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加订单</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<style type="">
	#addVerifyForm p{
		padding:10px;
	}
	#addVerifyForm label{
		display:inline-block;
		width:100px;
	}
	
	#addVerifyForm span{
		display:inline-block;
		width:200px;
	}
</style>
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

<div class="p_container">
	<form id="addVerifyTableQueryForm">
		<input type="hidden" name="page" id="page" />
		<input type="hidden" name="pageSize" id="pageSize" />
		<input type="hidden" name="supplierType" id="supplierType"  value="${reqpm.supplierType}" />
		<input type="hidden" name="supplier_name" id="supplier_name"  value="${reqpm.supplierName}" />
		<div class="p_container_sub">
			<div class="searchRow">
				<ul>
					<li class="text">订单日期:</li>
					<li>
						<input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~
						<input name="start_max" id="startMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">团号:</li>
					<li><input name="group_code" type="text" class="w-200"/></li>
					
					<c:if test="${reqpm.supplierType eq 1}">
						<li class="text">接站牌:</li>
						<li><input name="receive_mode" type="text" class="w-200"/></li>
					</c:if>
					<c:if test="${reqpm.supplierType ne 1}">
						<li class="text">订单号:</li>
						<li><input name="booking_no" type="text" class="w-200"/></li>
					</c:if>
					<li class="text" style="width:60px;">状态:</li>
					<li><select name="status" class="w-100bi">
							<option value="">全部</option>
							<option value="0">未对账</option>
							<option value="1">已对账</option>
							<option value="2">未审核</option>
					</select></li>
					
					<li class="text">产品名称:</li>
					<li><input name="product_name" type="text" style="width:185px"/></li>
					<li class="text">部门:</li>
	    			<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" class="w-200"/>
	    				<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>
	    			</li>							  
					<li>
		    			<li class="text">计调:</li>
		    			<div class="dd_right">
		    				<input type="text" name="operator_name" id="operator_name" value="" readonly="readonly"/>
							<input name="operator_id" id="operator_id" value="" type="hidden" value=""/> 
		    				<a href="javascript:void(0);" onclick="selectUserMuti()" > 请选择</a>
							<a href="javascript:void(0);" onclick="multiReset()" >重置</a>
		    			</div>
		    		</li>
					<li class="text" style="width:75px;"></li>
					<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
				</ul>
			</div>
		</div>
	</form>
	<div id="addVerifyTableDiv"></div>
	<div style="padding-top:30px;text-align:center;">
		<input type="button"  onclick="saveVerifyDetail()" class="button button-primary button-small" value="确定">&nbsp;&nbsp;&nbsp;
		<input type="button"  onclick="closeAddVerifyLayer()" class="button button-primary button-small" value="关闭">
	</div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

var index = parent.layer.getFrameIndex(window.name); //获取窗口索引

function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	if (!pagesize || pagesize < 5) {
		pagesize = 5;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);
	var options = {
		url : "queryVerifyDetailOrders.do",
		type : "post",
		dataType : "html",
		success : function(data) {
			$("#addVerifyTableDiv").html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			$.error("服务忙，请稍后再试");
		}
	}
	$("#addVerifyTableQueryForm").ajaxSubmit(options);
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
		offset : ['10px', '10px'],
		area : ['650px', '300px'],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
			var layerDiv = $(".layui-layer-title").parent();
			$(layerDiv).css({"top":"80px", "left":"250px"});
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

function selectAll(){
	
	var flag = false;
	if($("#select_all").attr("checked")){
		flag = true;
	}
	$("input:checkbox").each(function(){
		if(!$(this).attr("disabled")){
			$(this).attr("checked", flag);
		}
	});
}

function saveVerifyDetail(){

	var ids = [];
	$("#detailOrderTable input:checkbox").each(function(){
		  var obj = $(this);
		  var value = obj.val();
		  if(obj.attr("checked") && value){
			  ids.push(value);
		  }
	});
	parent.loadJoinedTableTemp(ids);
	parent.layer.close(index);
}

function closeAddVerifyLayer(){
	parent.layer.close(index);
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function() {
	queryList();
});
</script>
</html>
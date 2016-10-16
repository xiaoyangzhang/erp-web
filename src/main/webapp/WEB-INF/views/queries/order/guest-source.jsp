<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>下接社统计</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=staticPath %>/assets/js/chart/highcharts.js"></script>
<script type="text/javascript">
$(function() {
	var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
	$("input[name='startDate']").val(vars.dateFrom);
	$("input[name='endDate']").val(vars.dateTo );	
	
	
})
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<form id="queryForm" action="deliveryDetailList.htm" method="post">

			
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li>
						<select name="dateType" id="dateType">
							<option value="0">订单出发日期</option>
							<option value="1">订单录入日期</option>
						</select>
						<input name="startDate" id="startDate" type="text" class="Wdate" value="${startDate }" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="endDate" id="endDate" type="text" class="Wdate" value="${endDate }" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">组团社名称</li>
					<li><input name="supplierName" id="supplierName" type="text"/></li>
					<li class="text">产品</li>
					<li><input id="productName"   name="productName" type="text" placeholder="输入产品名称或品牌"/></li>
					<li class="clear"/>
					<li class="text">
						
					</li>
					<li>部门: <input type="text" name="orgNames" id="orgNames"
							stag="orgNames" readonly="readonly" onclick="showOrg()" /> <input
							name="orgIds" id="orgIds" stag="orgIds" type="hidden" value="" />
							计调:
							<select name="operatorType" id="operatorType">
							<option value="0">销售计调</option>
							<option value="1">操作计调</option>
						</select>
							 <input type="text" name="operatorName"
							id="saleOperatorName" stag="userNames" readonly="readonly"
							onclick="showUser()" /> <input name="operatorIds"
							id="operatorIds" stag="userIds" type="hidden" />
						</li>
						<li class="clear" />
					<li class="text">团类型</li>
					<li><select name="orderMode" id="orderMode" class="w-100bi">
							<option value="">全部</option>
							<option value="0">散客</option>
							<option value="1">团队</option>
					</select></li>
					<li class="clear" />
					<li class="text">显示条数</li>
						<li><select name="showNum"  class="w-100bi">
								<option value="10" selected="selected">10</option>
								<option value="20">20</option>
								<option value="30">30</option>
								<option value="50">50</option>
								<option value="100">100</option>

						</select></li>
						<li class="clear" />
					<li><input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="查询">
					<a href="javascript:void(0)" id="preview7" onclick="toPreview7()"  class="button button-glow button-rounded button-raised button-primary button-small" >
						打印预览</a>
					</li>
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
<script type="text/javascript">

$(document).ready(function () {
	queryList();
});  
    
function queryList() {
	var options = {
		url:"guestSourceStatics.do",
    	type:"post",
    	dataType:"html",
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
	queryList();
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
			
			$("#operatorIds").val("");
			$("#operatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#operatorName").val($("#operatorName").val()+userArr[i].name);
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id);
				}else{
					$("#operatorName").val($("#operatorName").val()+userArr[i].name+",");
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id+",");
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
	$("#operatorName").val("");
	$("#operatorIds").val("");
	
}
function toPreview7(){
	$("#preview7").attr("target","_blank").attr("href","../query/productSourcePreview.htm?dateType="+$("#dateType").val()+"&startDate="+
			$("#startDate").val()+"&endDate="+$("#endDate").val()+"&supplierName="+$("#supplierName").val()+"&productName="+$("#productName").val()+
			"&orderMode="+$("#orderMode").val()+"&operatorType="+$("#operatorType").val()
			+"&operatorIds="+$("#operatorIds").val()
			+"&orgIds="+$("#orgIds").val());
	
}
</script>
</html>
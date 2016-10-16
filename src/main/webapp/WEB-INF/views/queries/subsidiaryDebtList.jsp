<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>子公司欠款统计</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
	<script type="text/javascript">
     $(function() {
    	 var vars={
    			 dateFrom : $.currentMonthFirstDay(),
    		 	dateTo : $.currentMonthLastDay()
    		 	};
    		 	$("#startTime").val(vars.dateFrom);
    		 	 $("#endTime").val(vars.dateTo );	
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toPaymentList()" class="selected">子公司欠款统计</a></li>
			<li class="clear"></li>
		</ul>
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="pay.selectSubsidiaryListPage" />
			<input type="hidden" name="rp" value="queries/subsidiaryDebtTable" />
			<input type="hidden" name="ssl" value="pay.selectSubsidiaryTotal" />
			<div class="p_container_sub" >
			<div class="searchRow">
			<!-- 这五个隐藏域用作sql查询参数 -->
				<input type="hidden" name="lj" id="lj" value="${lj}"/>
				<input type="hidden" name="lm" id="lm" value="${lm}"/>
				<input type="hidden" name="yx" id="yx" value="${yx}"/>
				<input type="hidden" name="yp" id="yp" value="${yp}"/>
				<input type="hidden" name="llt" id="llt" value="${llt}"/>
				<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
				<ul>
					<li class="text">出团日期</li>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName" type="text"/></li>
					<li class="clear"/>
					<li class="text">部门:</li>
	    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			<li class="text">计调:</li>
	    			<li>
	    					<select name="operType">
								<option value="0">操作计调</option>
								<option value="1">销售计调</option>
							</select>
	    			<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	  
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode" style="width:100px;text-align: right;">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<a href="javascript:void(0);" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small">查询</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
</body>

<script type="text/javascript">
	function toClear(){
	$("#operatorIds").val("");
	$("#operatorName").val("");
}
function selectUserMuti(){
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

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"toSubsidiaryDebt.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#form").ajaxSubmit(options);	
    
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function() {
	queryList();
});
</script>
</html>
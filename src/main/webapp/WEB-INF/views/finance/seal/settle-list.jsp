<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>结算单</title>
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
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="fin.selectSettleListPage" />
			<input type="hidden" name="rp" value="finance/seal/settle-list-table" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期:</li>
					<li><input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="start_max" id="startMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">团号:</li>
					<li><input name="group_code" type="text"/></li>
					<li class="text">产品名称:</li>
					<li><input name="product_name" type="text"/></li>
											<li class="clear"/>
					
				<!-- </ul>
				<ul> -->
					<li class="text">部门:</li>
	    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			<li class="text">计调:</li>
	    			<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
					<li class="text">团状态:</li>
					<li><select name="group_state">
							<option value="" selected="selected">全部</option>
							<option value="1">已确认</option>
							<option value="3">已审核</option>
							<option value="4">封存</option>
					</select></li>
					<li class="text">审核人</li>
					<li><select id="audit_user" name="audit_user">
							<option value="">全部</option>
							<c:forEach items="${auditorList}" var="audi">
									<option value="${audi.auditUser}">${audi.auditUser}</option>
							</c:forEach>	
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
						<input type="reset" class="button button-primary button-small" value="重置">
					</li>
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<div style="padding: 10px;">
		<input type="button" class="button button-primary button-small" value="封存" onclick="batchSeal()" />
	</div>
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
		url:"settleSealList.do",
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

function batchSeal(){
	
	var ids = [];
	$("input:checkbox").each(function(){
		  var obj = $(this);
		  var value = obj.val();
		  if(obj.attr("checked") && value){
			  ids.push(value);
		  }
	});
	
	YM.post("batchSeal.do",{groupIds:ids.join(",")},function(){
		$.success("封存成功");
		searchBtn();
	});
}

function unseal(groupId){
	
	YM.post("unseal.do",{groupId:groupId},function(){
		$.success("解封成功");
		searchBtn();
	});
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function() {
	queryList();
});
</script>
</html>
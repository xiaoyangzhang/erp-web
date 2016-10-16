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
	<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.freezeheader.js"></script>
	<script type="text/javascript">
	$(function() {
		function setData(){
			 $("input[name='startTime']").val($.currentMonthFirstDay());
		     $("input[name='endTime']").val($.currentMonthLastDay());
		}
		setData();
	})
	</script>
</head>
<body>
    <div class="p_container" >
    <form id="queryForm">
			
			<input type="hidden" name="isShow" id="isShow" value="${reqpm.isShow }"/>
			<input type="hidden" name="page" id="page" value="1"/>
			<input type="hidden" name="pageSize" id="pageSize" value="10"/>
			<!-- <input type="hidden" name="sl" value="fin.selectSettleListPage" />
			<input type="hidden" name="rp" value="finance/settle-list-table" /> -->
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_right grey">						
	    				<select name="dateType">
	    					<option value="groupDate">团日期</option>
	    					<option value="appliDate">进店日期</option>
	    				</select>
						<input type="text" id="startMin" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="startMax" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">购物店：</div>
	    			<div class="dd_right">
	    				<input type="text" name="shopStore" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">购物项目：</div>
	    			<div class="dd_right">
	    				<input type="text" name="shopItem" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productName" id="" value="" class="w-100"/>
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
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<input type="text" id="guideName" name="guideName" class="w-100"></div>
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
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
	    			<c:if test="${reqpm.isShow ne true }">
	    				<div class="dd_left">
							<a href="javascript:void();" id="btn_audit" onclick="postShopAudit()" class="button button-primary button-rounded button-small">审核</a>   				
		    			</div>
	    			</c:if>
	    			<div class="dd_left">
						<a href="javascript:void();" id="btn_audit" onclick="print();" class="button button-primary button-rounded button-small">打印</a>   				
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
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 15;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/finance/toBookingShopVerifyList.do",
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
	queryList();
}

$(function() {
	queryList();
});


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

function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[name='audit_id']").attr('checked', 'checked');
	} else {
		$("input[name='audit_id']").removeAttr("checked");
	}
}

function postShopAudit(ckbox) {
	
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
	YM.post("<%=staticPath%>/finance/auditShop.do", pm, function(data) {
		$.success('操作成功');
		queryList();
	});
}

function imp(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择导游',
		closeBtn : false,
		area : [ '1080px', '620px' ],
		shadeClose : false,
		content : '<%=staticPath%>/bookingGuide/impGuideList.htm',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//orgArr返回的是org对象的数组
			var arr = win.getGuide(); 
		
			$("#guideId").val(arr.id);
			$("#guideName").val(arr.name);
		
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

function print(){
	window.open ("<%=staticPath%>/finance/toBookingShopVerifyPrint.do?"+ $("#queryForm").serialize());
}
</script>
</html>

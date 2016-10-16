<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" /> 
	<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.freezeheader.js"></script> 
	<script type="text/javascript">
	$(function() {
		 var vars={
				 dateFrom : $.currentMonthFirstDay(),
			 	dateTo : $.currentMonthLastDay()
			 	};
		$("#startMin").val(vars.dateFrom);
		$("#startMax").val(vars.dateTo );
		
		$("#saleType").change(function(){
			var s = $(this).children('option:selected').val();
			if(s == 1){
				$("#groupMode").val("");
			}
			if(s == 0){
				$("#groupMode").val(1);
			}
		})
	})
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
	    					<option value="appliDate">进店日期</option>
	    				</select>
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
	    			<div class="dd_left">组团社：</div>
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden"/>	    				
	    			</div>
	    			<div class="dd_right">
	    				<select id="saleType" name="saleType">
	    					<option value="1">计调：</option>
	    					<option value="0">销售：</option>
	    				</select>
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">类型：</div>
	    			<div class="dd_right">
	    				<select id="groupMode" name="groupMode" class="w-100bi"/>
	    					<option value="">全部</option>
							<option value="0">散客</option>
							<option value="1">团队</option>
	    				</select>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品：</div>
	    			<div class="dd_right">
	    				<input type="text" value="" name="productName">
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<br/>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导管：</div>
	    			<div class="dd_right">
	    				<input type="text" value="" style="width:185px;" name="guideManageName">
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left" >导游：</div>
	    			<div class="dd_right" >
	    				<input type="text" value="" class="w-100" name="guideName">
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">购物店：</div>
	    			<div class="dd_right">
	    				<input type="text" value="" class="w-100" name="shopSupplierName">
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right" style="margin-left:10px;">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>
						<button type="button" onclick="print()" class="button button-primary button-rounded button-small">打印</button>
<!-- 						<button type="button" onclick="archive('All')" class="button button-primary button-small button-green">全归档</button> -->
						<!-- <button type="button" onclick="archive('Incremental')" class="button button-primary button-small button-green">归档</button>  -->
	    			</div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    	<%-- <dl class="p_paragraph_content" style="margin-top:0px;margin-bottom:0px;text-align:right;">
	    		<dd>最新归档时间：${recordEndTime }</dd>
	    	</dl> --%>
	    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>
    <div id="showCommDiv"></div>        
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>        
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function archive(type){
	if (type=='All'){
		if (!confirm("确定要执行全归档？这要花几分钟的时间")){return;}
		var openUrl = "<%=staticPath%>/tj/archiveAllGroupShop.do";//弹出窗口的url
	}else {
		var openUrl = "<%=staticPath%>/tj/archiveIncrementalGroupShop.do";//弹出窗口的url
	}
	var iWidth=400; //弹出窗口的宽度;
	var iHeight=200; //弹出窗口的高度;
	var iTop = (window.screen.availHeight-30-iHeight)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-iWidth)/2; //获得窗口的水平位置;
	window.open (openUrl,'归档','height='+ iHeight +',width='+ iWidth +',top='+ iTop +',left='+ iLeft +',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}

function print(){
	window.open ("<%=staticPath%>/tj/toGroupShopListPrint.htm?"+ $("#queryForm").serialize());
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

function showCommission(groupId){
	
	var data = {};
	data.groupId = groupId;
	data.isShow = true;
	$("#showCommDiv").load("<%=staticPath%>/finance/guide/commissionList.htm", data);
	
	layer.open({
		type : 1,
		title : '佣金明细',
		closeBtn : false,
		area : [ '900px', '400px' ],
		shadeClose : false,
		content : $("#showCommDiv"),
		btn : [ '确定', '取消' ],
		yes : function(index) {
			layer.close(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

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
   		url:"<%=staticPath%>/tj/selectTJGroupShopList.do",
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
	queryList(null,$("#NumberPageSize").val());
}

$(function() {
	queryList();
});

</script>
</html>

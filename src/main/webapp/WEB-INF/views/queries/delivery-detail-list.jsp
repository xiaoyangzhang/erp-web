<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>下接社明细</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
	
	
	</script>
		<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		<!-- <ul class="w_tab">
			<li><a href="deliveryList.htm">下接社统计</a></li>
			<li><a href="deliveryDetailList.htm" class="selected">下接社明细</a></li>
			<li class="clear"></li>
		</ul> -->
		<form id="queryForm">
			<input type="hidden" name="supplier_id" id="supplier_id" value="${parameters.supplier_id }"/>
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="rdm.selectDeliveryCashDetailListPage" />
			<input type="hidden" name="ssl" value="rdm.selectDeliveryCashDetailSum" />
			<input type="hidden" name="rp" value="queries/delivery-detail-list-table" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text"><select id="dateType" name="dateType">
							
							
							<option value="0" ${parameters.dateType eq 0?'selected="selected"':'' }>出团日期</option>
							<option value="1" ${parameters.dateType eq 1?'selected="selected"':'' }>到达日期</option>
							<option value="2" ${parameters.dateType eq 2?'selected="selected"':'' }>离团日期</option>
							
						</select></li>
					<li><input name="start_min" type="text" id="startTime" class="Wdate" style="width: 120px" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${parameters.start_min }"/>
						~<input name="start_max" type="text" id="endTime" class="Wdate"style="width: 120px" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${parameters.start_max }" />
					</li>
					<li class="text">地接社名称</li>
					<li><input name="supplier_name" id="supplierName" type="text" /></li>
					<li class="text">产品</li>
					<li><input id="productName"  name="productName" type="text" style="width: 200px" placeholder="输入产品名称或品牌" value="${parameters.productName }"/></li>
					
					<li class="text">付款状态</li>
					<li><select name="status" id="status" class="w-100bi">
							<option value="">全部</option>
							<option value="0" ${parameters.status eq 0?'selected="selected"':'' }>已付清</option>
							<option value="1" ${parameters.status eq 1?'selected="selected"':'' }>未付清</option>
					</select></li>
					<li class="clear" />
				<!-- </ul>
				<ul> -->
					<li class="text">团号</li>
					<li><input name="group_code" id="groupCode" type="text"/></li>
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${parameters.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds"  type="hidden" value="${parameters.orgIds }"/>	
						</li>
						<li class="text">计调:</li>
					<li>	
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="${parameters.saleOperatorName }" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${parameters.saleOperatorIds }"/>
						
						
					</li>
					<li class="text">团类型</li>
					<li><select name="group_mode" id="groupMode" class="w-100bi">
							<option value="">全部</option>
							<option value="0" ${parameters.group_mode < 1?'selected="selected"':'' }>散客</option>
							<option value="1" ${parameters.group_mode > 0?'selected="selected"':'' }>团队</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li><button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
						<a href="javascript:void(0)" id="preview" onclick="toPreview()"  class="button button-primary button-small" >
						打印预览</a>
					</li>
				</ul>
			</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
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
		url:"../query/getSupplierStatistics",
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
    $("#supplier_id").val("");
}

	$(function() {
		queryList();
	});
	$("#btnQuery").click(function(){
		 queryList(1,$("#searchPageSize").val());
	})
	function toPreview(){
	window.open("<%=ctx%>/query/deliveryDetailPreview.htm?dateType="+$("#dateType").val()+"&start_min="+
			$("#startTime").val()+"&start_max="+$("#endTime").val()+"&supplier_name="+$("#supplierName").val()+"&productName="+$("#productName").val()+
			"&group_code="+$("#groupCode").val()+"&group_mode="+$("#groupMode").val()
			+"&status="+$("#status").val()+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&pageSize="+$("#pageSize").val()+"&sl="+$("input[name='sl']").val()+"&rp="+$("input[name='rp']").val()+"&ssl="+$("input[name='ssl']").val()+"&supplier_id="
			+$("#supplier_id").val());
	
}

	</script>
</html>
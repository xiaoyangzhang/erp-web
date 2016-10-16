<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应收款统计</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
	
	
	</script>
		<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		
		<form id="queryForm" action="deliveryDetailList.htm" method="post">
			<input type="hidden" name="supplier_id" id="supplier_id" />
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="rdm.selectAccountListPage" />
			<input type="hidden" name="ssl" value="rdm.selectAccountSum" />
			<input type="hidden" name="rp" value="queries/account/account-list-table" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">团日期</li>
					<li><input name="start_min" id="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="start_max" id="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">地接社名称</li>
					<li><input name="supplier_name" type="text"/></li>
					<li class="text">产品</li>
					<li><input id="productName"  name="productName" type="text" style="width: 200px" placeholder="输入产品名称或品牌"/></li>
					
					<li class="text">付款状态</li>
					<li><select name="status" id="status" class="w-100bi">
							<option value="">全部</option>
							<option value="0">已付清</option>
							<option value="1">未付清</option>
					</select></li>
					<li class="clear" />
				<!-- </ul>
				<ul> -->
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	
						</li>
						<li class="text">计调:</li>
					<li>	
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li>
					<li class="text">团类型</li>
					<li><select name="group_mode" id="group_mode" class="w-100bi">
							<option value="">全部</option>
							<option value="0">散客</option>
							<option value="1">团队</option>
					</select></li>
					
					<li class="text">商家类别</li>
					<li><select name="supplierType" id="supplierType" class="w-100bi">
							<option value="">全部</option>
							<c:forEach items="${suppliers}" var="sup" >
								<option value="${sup.key }">${sup.value }</option>
							</c:forEach>
					</select></li>
					<!-- <li class="clear" /> -->
					<li class="text"></li>
					<li><button id="btnQuery" type="button"  class="button button-primary button-small">查询</button></li>
				</ul>
			</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function deliveryDetail(supid){
		$("#supplier_id").val(supid);
		newWindow("地接社订单详情","<%=ctx%>/query/deliveryDetailList.htm?dateType="+$("#dateType").val()+"&start_min="+
				$("#startTime").val()+"&start_max="+$("#endTime").val()+"&productName="+$("#productName").val()+
				"&group_mode="+$("#group_mode").val()
				+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()
				+"&supplier_id="+$("#supplier_id").val()
				+"&status="+$("#status").val());
		/* layer.open({ 
			type : 2,
			title : '地接社订单详情',
			shadeClose : true,
			shade : 0.5,
			area : ['1200px','800px'],
			content : "../query/deliveryDetailList.htm?dateType="+$("#dateType").val()+"&start_min="+
			$("#startTime").val()+"&start_max="+$("#endTime").val()+"&productName="+$("#productName").val()+
			"&group_mode="+$("#group_mode").val()
			+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&supplier_id="+$("#supplier_id").val()
			+"&status="+$("#status").val()
		});  */
}

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
    		url:"../query/getAccountDetail.do",
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

	

 

$(function() {
	//setData();
	var vars={
    			 dateFrom : $.currentMonthFirstDay(),
    		 	dateTo : $.currentMonthLastDay()
    		 	};
    		 	$("#startTime").val(vars.dateFrom);
    		 	 $("#endTime").val(vars.dateTo );	
	queryList();
});
	$("#btnQuery").click(function(){
		 queryList(1,$("#searchPageSize").val());
	})
	</script>
</html>
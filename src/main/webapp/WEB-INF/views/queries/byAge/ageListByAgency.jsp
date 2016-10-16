<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
	<script type="text/javascript">
	
	$(function() {
		var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
   		 	$("#startTime").val(vars.dateFrom);
   		 	 $("#endTime").val(vars.dateTo );	
		queryList();
});
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/getAgeListByAgency",
				type:"post",
				/*async:true,*/
				dataType:"html",
				/*data:{
					startTime:$("#startTime").val(),
					endTime:$("#endTime").val()
				},*/
				success:function(data){
					$("#tableDiv").html(data);
					
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					$.error("服务忙，请稍后再试");
				}
		};
		$("#form").ajaxSubmit(options);	
		
	}

	</script>
		<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		<!-- <ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toAgeListByProduct()" class="selected">按产品分析</a></li>
			<li><a href="javascript:void(0);" onclick="toAgeListByProductAndAgency()">按产品+旅行社分析</a></li>
			<li class="clear"></li>
		</ul> -->
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.selectAgeByAgencyListPage" />
			<!-- <input type="hidden" name="ssl" value="booking.selectAgeCount" /> -->
			<input type="hidden" name="rp" value="queries/byAge/ageTableByAgency" />
			<input type="hidden" id="bizId" name="bizId" value="${bizId }"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">出团日期</li>
						<li>
					<input id="startTime" name="startTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						~<input id="endTime" name="endTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						</li>
				 <li class="text">组团社</li>
					<li><input id="supplierName"  name="supplierName" style="width: 200px" type="text"/></li> 
					<!-- <li class="text">产品品牌</li>
					<li>
							<input id="productBrandName"  name="productBrandName" type="text" style="width: 200px" placeholder="输入品牌或产品名称"/> </li>
					
					 -->
					<li class="text">性别</li>
					<li><select id="gender" name="gender">
							<option value="" selected="selected">全部</option>
							<option value="1">男</option>
							<option value="0">女</option>
					</select></li>
					<li class="clear" />
					<li class="text">团类型</li>
					<li><select id="orderType" name="orderType">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
					<li>	<select name="operType">
								<<option value="0">销售计调</option>
								<option value="1">操作计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li>
					<li>
				 	<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
					 </li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
<script type="text/javascript">
$("#btnQuery").click(function(){
	 queryList(1,$("#searchPageSize").val());
})
</script>
</html>
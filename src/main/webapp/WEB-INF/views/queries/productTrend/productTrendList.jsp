<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>产品收客趋势</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>

</head>
<body>
	<div class="p_container">
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" value="" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">日期:</li>
						<li>
							<input id="startTime" name="startTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
							 	~
							<input id="endTime" name="endTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						</li>
						
						<li class="text">产品名称:</li>
						<li>
							<select class="select160" name="productBrandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName"/>	
						</li>
						
						
						<li class="text">部门:</li>
						<li>
							<!-- <input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" />
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value="" /> -->
							<%-- <input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/> --%>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>
						</li>	
						<li class="text">销售:</li>	
						<li>
						<input type="text" name="saleOperatorName" id="saleOperatorName"
								value="${groupOrder.saleOperatorName}" stag="userNames" readonly="readonly"  onclick="showUser()"/> <input
								name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
								value="${groupOrder.saleOperatorIds}" />
						</li>
						
						<li class="text">团类型:</li>
						<li>
							<select id="groupMode" name="groupMode">
								<option value="" selected="selected">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
							</select>
						</li>
					
							
						<li class="clear" />
						<li style="margin-left:2%;">
							<input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
						</li>
						<li class="clear"></li>
					</ul>
				</div>
			</div>
		</form>
	</div>
	<!-- table -->
	<div id="tableList"></div>

</body>	

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
			url:"../query/productTrendList.htm",
			type:"post",
			dataType:"html",
			success:function(data){
				$("#tableList").html(data);
				
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.error("服务忙，请稍后再试");
			}
	};
	$("#form").ajaxSubmit(options);	
	
}
	
	function searchBtn(){
		queryList(null,$("#pageSize").val());
	}
     </script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</html>
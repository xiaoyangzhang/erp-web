<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应收款统计</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/payment.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize"  />
			<input type="hidden" name="sl" value="pay.selectPaymentListPage2" />
			<input type="hidden" name="rp" value="queries/paymentTable" />
			<input type="hidden" id="supplierId" name="supplierId" value=""/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">出团日期:</li>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${first}" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last}" />
					</li>
					<li class="text">商家名称:</li>
					<li><input id="supplierName"  name="supplierName" type="text"/></li>
					<li class="text">产品名称:</li>
					<li><input id="productName"  name="productName" type="text"/></li>
					<li class="text">收款状态:</li>
					<li>
		  				<select id="paymentState" name="paymentState">
							<option value="" selected="selected">全部</option>
							<option value="1">已付清</option>
							<option value="0">未付清</option>
						</select>
					</li>
					<li class="clear"/>
					<li class="text">部门:</li> 	
					<li>
						<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/> 
					</li>
					<li class="clear" />
					<li>
						<!-- <input type="hidden" name="type" id="type" value="0"/> -->
						<select id="type" name="type" >
								<option value="0">计调</option>
								<option value="1">销售</option>
						</select></li>
					<li>	
					<li>
						<input type="text" name="userNames" stag="userNames" id="operatorName" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value=""/> 
					</li>
					<li class="clear" />
					<li class="text">团类型:</li>
					<li><select id="groupMode" name="groupMode">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
						<a href="javascript:void(0);" id="toPaymentStaticPreview" target="_blank" onclick="toPaymentStaticPreview()" class="button button-primary button-small">导出Excel</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<script type="text/javascript">
		$("#btnQuery").click(function(){
			 queryList(1,$("#searchPageSize").val());
		})
		function paymentDetail(supplierId){
			newWindow('应收款明细','<%=ctx%>/query/paymentDetailList?supplierName='+$("#supplierName").val()+"&supplierId="+supplierId+"&startTime="+$("#startTime").val()+"&endTime="+
								$("#endTime").val()+"&productName="+$("#productName").val()+"&paymentState="+$("#paymentState").val()+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()
								+"&type="+$("#type").val()+"&groupMode="+$("#groupMode").val()+"&orgNames="+$("#orgNames").val()+"&userNames="+$("#operatorName").val()
			)
		}
		$(function() {
			var vars={
					 dateFrom : $.currentMonthFirstDay(),
				 	dateTo : $.currentMonthLastDay()
				 	};
			//if($("#startTime").val()){
				 	$("#startTime").val(vars.dateFrom);//}
			//if($("#endTime").val()){
				 	 $("#endTime").val(vars.dateTo );	//}
			queryList(1,$("#searchPageSize").val());
		});
	</script>
</body>
</html>
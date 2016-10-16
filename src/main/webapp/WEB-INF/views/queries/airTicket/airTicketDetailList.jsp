<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>机票订单明细统计</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
	
	<script type="text/javascript">
		$(function(){
			
				queryList();			
		})
function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/getSupplierStatistics",
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
			<li><a href="javascript:void(0);" onclick="toAirTicketList(1)">机票统计</a></li>
			<li><a href="javascript:void(0);" onclick="toAirTicketBooking()">订单统计</a></li>
			<li><a href="javascript:void(0);" onclick="toAirTicketDetailList()" class="selected">订单明细</a></li>
			<li class="clear"></li>
		</ul> -->
		<form id="form" action="<%=ctx%>/query/paymentDetailList" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.bookingSupplierDetailListPage" />
			<input type="hidden" name="ssl" value="booking.bookingSupplierDetailTotal" />

			<input type="hidden" name="rp" value="queries/airTicket/airTicketDetailTable" />
 			<input type="hidden" name="supplierType" id="supplierType" value="${condition.supplierType}"/>
			<input type="hidden" name="supplierId" id="supplierId" value="${condition.supplierId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text"><select id="selectDate" name="selectDate">
							
							<option value="0" ${condition.selectDate eq 0?'selected="selected"':'' }>出团日期</option>
							<option value="1" ${condition.selectDate eq 1?'selected="selected"':'' }>用票日期</option>
							<option value="2" ${condition.selectDate eq 2?'selected="selected"':'' }>离团日期</option>
						</select><li>
					<input id="startTime" name="startTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.startTime }" />
						~<input id="endTime" name="endTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=" ${condition.endTime }" />
						</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName"style="width: 200px" type="text" /></li>
					<li class="text">团号</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<%-- <li class="text">收款状态</li>
					<li>
		  				<select id="paymentState" name="paymentState">
							<c:if test="${condition.paymentState=='1'}">
								<option value="">全部</option>
								<option value="1" selected="selected">已付清</option>
								<option value="0">未付清</option>
							</c:if>
							<c:if test="${condition.paymentState=='0'}">
								<option value="">全部</option>
								<option value="1">已付清</option>
								<option value="0" selected="selected">未付清</option>
							</c:if>
							<c:if test="${condition.paymentState==null or condition.paymentState==''}">
								<option value="" selected="selected">全部</option>
								<option value="1">已付清</option>
								<option value="0">未付清</option>
							</c:if>
						</select>
					</li>
					<li class="clear"/> --%>
				
					<li class="text">产品</li>
					<li><input id="productBrandName" name="productBrandName" type="text" value="${condition.productBrandName}"/></li>
					
					 <li class="text">班次</li>
					<li><input  name="ticketFlight" id="ticketFlight" type="text" value=""/></li> 
					</ul><ul>
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${condition.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value="${condition.orgIds }"/>	
						</li>
						<li class="text">计调:</li>
					<li>	
						<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="${condition.saleOperatorName }" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${condition.saleOperatorIds }"/>
						
						
					</li>
					
				 
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
							<option value="">全部</option>
							<option value="0" ${condition.groupMode < 1?'selected="selected"':'' }>散客</option>
							<option value="1" ${condition.groupMode > 0?'selected="selected"':'' }>团队</option>
					</select></li>
					
					<li class="clear" />
					<li class="text">结算方式：</li>
					<li>
						<select name="cashType" id="cashType">
								
								<option value="">请选择</option>
								
								<c:forEach items="${cashType }" var="type">
									<option value="${type.value }" <c:if test="${type.value eq condition.cashType }">selected</c:if> >${type.value }</option>
								</c:forEach>
								
							</select>
					</li>
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
						<a href="javascript:void(0)" id="preview3" onclick="toPreview3()"  class="button button-primary button-small" >
						打印预览</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
<script >
function toPreview3(){
	$("#preview3").attr("target","_blank").attr("href","../query/ticketDetailPreview.htm?selectDate="+$("#selectDate").val()+"&startTime="+
			$("#startTime").val()+"&endTime="+$("#endTime").val()+"&supplierName="+$("#supplierName").val()+"&productBrandName="+$("#productBrandName").val()+
			"&groupCode="+$("#groupCode").val()+"&groupMode="+$("#groupMode").val()+"&cashType="+$("#cashType").val()
			+"&page="+$("#page").val()+"&ticketFlight="+$("#ticketFlight").val()+"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&pageSize="+$("#pageSize").val()+"&sl="+$("input[name='sl']").val()+"&rp="+$("input[name='rp']").val()+"&ssl="+$("input[name='ssl']").val()+"&supplierId="
			+$("#supplierId").val()+"&supplierType="+$("#supplierType").val()+"&bizId="+$("#bizId").val());
	
}

$("#btnQuery").click(function(){
	 queryList(1,$("#searchPageSize").val());
})
</script>
</html>
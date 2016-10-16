<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>领单查询</title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style>
	.p_container_sub .Wdate{width: 100px;}
	</style>
</head>
<body>
<script>
function searchBtn(){
	var vars=YM.getFormData("queryForm");vars["ps"] = ${pageBean.pageSize};
	window.location.href = "billStatistics.htm" + $.makeUrlFromVars(vars);
}

 /* $(function() {
	function setData(){
		var curDate=new Date();
		var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
		 $("input[name='depDateFrom']").val(startTime);
		var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
	    var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
	    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
	     $("input[name='depDateTo']").val(endTime);			
	}
	setData();
//queryList();
})   */
function queryList(p, ps){
	var vars = $.getUrlVars();
 	vars["p"] = p;
 	vars["ps"] = ps;
 	window.location.href = "billStatistics.htm" + $.makeUrlFromVars(vars);
}
$("document").ready(function(){
	$("#queryForm select[name='billType']").val("${pageBean.parameter.billType}");
	$("#queryForm select[name='billState']").val("${pageBean.parameter.billState}");
});
</script>
<div class="p_container" >
    <form id="queryForm" name="formBillFilter">
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl pl-10">
	    			<div class="dd_left">发团日期</div>
	    			<div class="dd_right grey">						
						<input type="text" placeholder="从" name="depDateFrom" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" 
								value="<fmt:formatDate value="${pageBean.parameter.depDateFrom}" pattern="yyyy-MM-dd"/>" /> —
	    				<input type="text" placeholder="到" name="depDateTo" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" 
	    						value="<fmt:formatDate value="${pageBean.parameter.depDateTo}" pattern="yyyy-MM-dd"/>" />
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号：</div>
	    			<div class="dd_right">
	    				<input type="text" name="groupCode" id="" value="${pageBean.parameter.groupCode}" class="w-160"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称：</div>
	    			<div class="dd_right">
	    				<input type="text" name="productName" id="" value="${pageBean.parameter.productName}" class="w-160"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游：</div>
	    			<div class="dd_right">
	    				<input type="text" name="guideName" id="" value="${pageBean.parameter.guideName}" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		
	    		<dd class="inl-bl">
	    			<div class="dd_left">单据类型：</div>
	    			<div class="dd_right">
	    				<select name="billType" style="width:100px;">
	    					<option value="">全部</option>
	    					<c:forEach items="${billTypeList}" var="dicBill">
								<option value="${dicBill.code}">${dicBill.value}</option>
							</c:forEach>
	    				</select>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">状态：</div>
	    			<div class="dd_right">
	    				<select name="billState">
	    					<option value="">全部</option>
	    					<option value="APPLIED">已申请</option>
	    					<option value="RECEIVED">已领单</option>
	    					<option value="VERIFIED">已销单</option>
	    				</select>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">单据商家：</div>
	    			<div class="dd_right">
	    				<input type="text" name="billSupplier" value="${pageBean.parameter.billSupplier}" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	    				
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	  </form>
    </div>
<div id="tableDiv">
<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:600px;" >
	<thead><tr>
		<th>团号</th>
		<th>发团日期</th>
		<th>产品名称</th>
		<th>计调</th>
		<th>人数</th>
		<th>导游</th>
		<th>单据类型</th>
		<th>申请数量</th>
		<th>实际数量</th>
		<th>销单数量</th>
		<th>状态</th>
	</tr></thead>
	<tbody>
	<c:forEach items="${pageBean.result}" var="map" varStatus="status">
		<tr>
			<td style="text-align: left;">
	              <c:if test="${map.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${map.id}&operType=0')">${map.group_code}</a> 
	              </c:if>
	              <c:if test="${map.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${map.id}&operType=0')">${map.group_code}</a>
	              </c:if>
             	</td>
			<td>${map.date_start}</td>
			<td style="text-align: left;">【${map.product_brand_name}】${map.product_name}</td>
			<td>${map.operator_name}</td>
			<td>${map.total_adult}大${map.total_child}小${map.total_guide}陪</td>
			<td>${map.guide_name}</td>
			<td>${map.bill_type}</td>
			<td>${map.num}</td>
			<td>${map.received_num}</td>
			<td>${map.returned_num}</td>
			<td>${map.appli_state}</td>
		</tr>
	</c:forEach>
	<tr><td colspan="6"></td><td>本页合计</td><td>${pageTotal.num}</td><td>${pageTotal.received_num}</td><td>${pageTotal.returned_num}</td><td></td></tr>
	<tr><td colspan="6"></td><td>总合计</td><td>${total.num_total}</td><td>${total.received_total}</td><td>${total.returned_total}</td><td></td></tr>
</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
</div>
</body>
</html>

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
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/bookingCount.js"></script>
	<script type="text/javascript">
	
	$(function() {
		function setDate(){
			
			 var curDate=new Date();
			 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
			 $("#startTime").val(startTime);
			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
		     var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
		     $("#endTime").val(endTime); 
			}
			setDate();
		queryList();
});
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/getNumAndOrder",
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
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toEntertainmentList()" class="selected">娱乐统计</a></li>
			<li><a href="javascript:void(0);" onclick="toEntertainmentDetailList()">娱乐明细</a></li>
			<li class="clear"></li>
		</ul>
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="booking.selectBookingSupplierListPage" />
			<input type="hidden" name="rp" value="queries/entertainment/entertainmentTable" />
			<input type="hidden" id="supplierId" name="supplierId" value=""/>
			<input type="hidden" id="bizId" name="bizId" value="${bizId }"/>
			<input type="hidden" id="supplierType" name="supplierType" value="${supplierType }"/>
			<input type="hidden" id="flag" name="flag" value="2"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期</li>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
						<input type="hidden" name="selectDate" value="0">
					</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName" type="text"/></li>
					<li class="text">收款状态</li>
					<li>
		  				<select id="paymentState" name="paymentState">
							<option value="" selected="selected">全部</option>
							<option value="1">已付清</option>
							<option value="0">未付清</option>
						</select>
					</li>
					<li class="clear"/>
				<!-- </ul>
				<ul> -->
					<li class="text">计调</li>
					<li>
						<input id="operatorIds" name="operatorIds" type="hidden"/>
						<input id="operatorName" name="operatorName" type="text"/>
						<a href="javascript:void(0);" onclick="selectUserMuti()">请选择</a>
					</li>
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
							<option value="" selected="selected">全部</option>
							<option value="1">团客</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						
					 	<input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="统计">
					 </li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
</html>
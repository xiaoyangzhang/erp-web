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
	src="<%=ctx%>/assets/js/web-js/views/payment.js"></script>
	<script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#startTime").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#endTime").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toPaymentList(1)">应收款统计</a></li>
			<li><a href="javascript:void(0);" onclick="toPaymentDetailList(1)" class="selected">应收款明细</a></li>
			<li class="clear"></li>
		</ul>
		<form id="form" action="<%=ctx%>/query/paymentDetailList" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="pay.selectPaymentDetailListPage" />
			<input type="hidden" name="ssl" value="pay.selectPaymentTotal" />
			<input type="hidden" name="rp" value="queries/paymentDetailTable" />
			<input type="hidden" name="supplierId" id="supplierId" value="${condition.supplierId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">出团日期</li>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.startTime}"/>
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.endTime}"/>
					</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName" type="text" value="${condition.supplierName}"/></li>
					<li class="text">团号</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">收款状态</li>
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
					<li class="clear"/>
				</ul>
				<ul>
					<li class="text">产品行程</li>
					<li><input id="productName" name="productName" type="text"/></li>
					<li class="text">员工</li>
					<li>
						<input id="operatorIds" name="operatorIds" type="hidden" value="${condition.operatorIds}"/>
						<input id="operatorName" name="operatorName" type="text" value="${condition.operatorName}"/>
						<a href="javascript:void(0);" onclick="selectUserMuti()">请选择</a>
					</li>
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
							<c:if test="${condition.groupMode=='1'}">
								<option value="" >全部</option>
								<option value="1" selected="selected">团客</option>
								<option value="0">散客</option>
							</c:if>
							<c:if test="${condition.groupMode=='0'}">
								<option value="">全部</option>
								<option value="1">团客</option>
								<option value="0" selected="selected">散客</option>
							</c:if>
							<c:if test="${condition.groupMode==null or condition.groupMode==''}">
								<option value="" selected="selected">全部</option>
								<option value="1">团客</option>
								<option value="0">散客</option>
							</c:if>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="查询">
						<a href="javascript:void(0);" class="button button-primary button-small" onclick="toClear()">重置</a>
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
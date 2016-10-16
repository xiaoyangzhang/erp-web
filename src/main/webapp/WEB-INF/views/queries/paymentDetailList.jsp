<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应收款明细</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/payment.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<form id="form" action="<%=ctx%>/query/paymentDetailList" method="post">
			<input type="hidden" name="page" id="page"/>
			<input type="hidden" name="pageSize" id="pageSize"/>
			<input type="hidden" name="sl" value="pay.selectPaymentDetailListPage" />
			<input type="hidden" name="ssl" value="pay.selectPaymentTotal" />
			<input type="hidden" name="rp" value="queries/paymentDetailTable" />
			<input type="hidden" name="supplierId" id="supplierId" value="${condition.supplierId}"/>
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期</li>
					<li><select id="dateType" name="dateType">
							<option value="1" <c:if test="${condition.dateType=='1'}">selected</c:if>>订单日期</option>
							<option value="0" <c:if test="${condition.dateType=='0'}">selected</c:if>>输单日期</option>
						</select>
					<li><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.startTime}"/>
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${condition.endTime}"/>
					</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName" type="text" value="${condition.supplierName}"/></li>
					<li class="text">接站牌:</li>
					<li><input type="text" name="receiveMode" id="receiveMode" value=""/> </li>
					<li class="text">客源地:</li>
						<li>
							<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }">${province.name}</option>
								</c:forEach>
							</select>
							<select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
								<option value="${city.id }">${city.name }</option>
								</c:forEach>
							</select>
						</li>
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
				<!-- </ul>
				<ul> -->
					<li class="text">产品名称</li>
					<li><input id="productName" name="productName" type="text" value="${condition.productName }"/></li>
					<li class="text">部门:</li> 	
					<li>
						<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${condition.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds"  type="hidden" value="${condition.orgIds }"/> 
					</li>
					<li class="clear" />
					<li>
						<!-- <input type="hidden" name="type" id="type" value="0"/> -->
						<select id="type" name="type" >
								<option value="0" ${reqpm.type==0?'selected':"" }>计调</option>
								<option value="1" ${reqpm.type==1?'selected':"" }>销售</option>
						</select></li>
					<li>	
					<li>
						<input type="text" name="userNames" stag="userNames" id="operatorName" value="${condition.userNames }" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${condition.saleOperatorIds }"/> 
					</li>
					<li class="clear" />
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode">
							<c:if test="${condition.groupMode=='1'}">
								<option value="" >全部</option>
								<option value="1" selected="selected">团队</option>
								<option value="0">散客</option>
							</c:if>
							<c:if test="${condition.groupMode=='0'}">
								<option value="">全部</option>
								<option value="1">团队</option>
								<option value="0" selected="selected">散客</option>
							</c:if>
							<c:if test="${condition.groupMode==null or condition.groupMode==''}">
								<option value="" selected="selected">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
							</c:if>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
						<a href="javascript:void(0);" id="toPreview" target="_blank" onclick="toPreview()" class="button button-primary button-small">导出Excel</a>
					</li>
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
		$(function() {
			var vars={
			   dateFrom : $.currentMonthFirstDay(),
		 	   dateTo : $.currentMonthLastDay()
		 	};
			if(!$("#startTime").val()){$("#startTime").val(vars.dateFrom);}
			if(!$("#endTime").val()){$("#endTime").val(vars.dateTo );}
			//设置默认日期，调用查询
			queryList(1,$("#searchPageSize").val());
		});
	</script>
</body>
</html>
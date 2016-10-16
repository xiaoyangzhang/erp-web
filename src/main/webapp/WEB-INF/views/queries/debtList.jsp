<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>欠款信息</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/debt.js"></script>
			<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</head>
<body>
	<div class="p_container">
		<!-- <ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toPaymentList()" class="selected">欠款统计</a></li>
			<li class="clear"></li>
		</ul> -->
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="pay.selectDebtListPage" />
			<input type="hidden" name="ssl" value="pay.getDebtTotal" />
			<input type="hidden" name="rp" value="queries/debtTable" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<input type="hidden" id="currentYear" value="${yearLimit}"/>
				<ul>
					<li class="text">年限</li>
					<li>
						<a class="button button-tinier button-plus" onclick="yearControl(0)">－</a>
						<input readonly="readonly" id="yearLimit"  name="yearLimit" value="${yearLimit}" type="text"  
							style="width:50px;text-align:center;margin-left:-2px;margin-right: -2px;"/>
						<a class="button button-tinier button-plus"  onclick="yearControl(1)">＋</a>
					</li>
					<li class="text">商家名称</li>
					<li><input id="supplierName"  name="supplierName" type="text"/></li>
					<li class="clear"/>
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
					<li>	<select name="operType">
								<option value="0">操作计调</option>
								<option value="1">销售计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li>
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode" style="width:100px;text-align: right;">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
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
	<script type="text/javascript">
	$("#btnQuery").click(function(){
		 queryList(1,$("#searchPageSize").val());
	})
	</script>
</body>
</html>
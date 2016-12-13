<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团列表</title>
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=ctx%>/assets/css/operate/operate.css" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/fitGroupSale.js"></script>
	
<link rel="stylesheet" href="<%=ctx%>/assets/js/jqgrid/css/ui.jqgrid.css">
<script src="<%=ctx%>/assets/js/jqgrid/js/i18n/grid.locale-cn.js"></script>
<script src="<%=ctx%>/assets/js/jqgrid/js/jquery.jqGrid.min.js"></script>
</head>
<body>
	<div class="p_container">
		<!-- <form action="toFitGroupList.htm" method="post" id="toFitGroupListForm"> -->
		<form method="post" id="toFitGroupListForm">
			<div class="p_container_sub">
				<div class="searchRow">
					<input type="hidden" name="page" id="groupPage" value="${tourGroup.page}"> <input type="hidden"
						name="pageSize" id="groupPageSize" value="${tourGroup.pageSize}">

					<ul>
						<li class="text">出团日期:</li>
						<li>
							<input name="startTime" type="text" id="startTime" value='<fmt:formatDate value="${tourGroup.startTime }" pattern="yyyy-MM-dd"/>'
								class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />~
							<input name="endTime" id="endTime" value='<fmt:formatDate value="${tourGroup.endTime}" pattern="yyyy-MM-dd"/>'
								type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">团号:</li>
						<li><input id="groupCode" name="groupCode" type="text" value="${tourGroup.groupCode}" /></li>
						<li class="text">产品:</li>
						<li><input id="productName" name="productName" type="text" value="${tourGroup.productName}" /></li>
						<li class="clear" />
					</ul>
					<ul>
						<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${tourGroup.orgNames }"
								readonly="readonly" onclick="showOrg()" style="width: 185px" /> 
							<input name="orgIds" id="orgIds" stag="orgIds" value="${tourGroup.orgIds }" type="hidden" />
						</li>
						<li class="text">计调:</li>
						<li>
							<input type="text" name="operatorName" id="saleOperatorName" value="${tourGroup.operatorName}"
								stag="userNames" readonly="readonly" onclick="showUser()" /> 
							<input name="operatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${tourGroup.operatorIds}" />
						</li>
						<li class="text">状态:</li>
						<li>
							<select name="groupState" id="groupState">
									<option value="-2" selected="selected">团状态</option>
									<option value="0"
										<c:if test="${tourGroup.groupState==0 }"> selected="selected" </c:if>>未确认</option>
									<option value="1"
										<c:if test="${tourGroup.groupState==1 }"> selected="selected" </c:if>>已确认</option>
									<option value="2"
										<c:if test="${tourGroup.groupState==2 }"> selected="selected" </c:if>>已废弃</option>
									<option value="3"
										<c:if test="${tourGroup.groupState==3 }"> selected="selected" </c:if>>已审核</option>
									<option value="4"
										<c:if test="${tourGroup.groupState==4 }"> selected="selected" </c:if>>已封存</option>
							</select> 
							<select name="groupMode" id="groupMode">
									<option value="" selected="selected">团类型</option>
									<option value="0"
										<c:if test="${tourGroup.groupMode==0 }"> selected="selected" </c:if>>散客</option>
									<option value="-1"
										<c:if test="${tourGroup.groupMode==-1 }"> selected="selected" </c:if>>一地散</option>
							</select>
						</li>
						<li class="text"></li>
						<li><button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button></li>
						<li class="clear" />
					</ul>
				</div>
			</div>
		</form>
	</div>
<!-- Jqgrid  Table  start -->
<div class="p_container">
    <div class="jqGrid_fitGroup">
        <table id="fitGroupTable"></table>
        <div id="fitGroupPage"></div>
    </div>
</div>
<script src="<%=ctx%>/assets/js/moment.js"></script>
<script src="<%=ctx%>/assets/js/accounting.min.js"></script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</body>
<!-- Jqgrid  Table  end -->
	<!-- 改变状态 -->
	<div id="stateModal" style="display: none">
		<form class="definewidth m20" id="stateInfoForm">
			<input type="hidden" name="id" id="modalgroupId" />
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">状态:</div>
					<div class="dd_right">
						<select name="groupState" id="modalGroupState">
							<option value="0">未确认</option>
							<option value="1">已确认</option>
							<option value="2">废弃</option>
							<option value="3">封存</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="submit" class="button button-primary button-small">确定</button>
			</div>
		</form>
	</div>
	<div id="exportWord"
		style="display: none; text-align: center; margin-top: 10px">
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skqrd"
				class="button button-primary button-small">散客确认单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skjsd"
				class="button button-primary button-small">散客结算单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skjd"
				class="button button-primary button-small">散客计调单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skdyd"
				class="button button-primary button-small">导游单行程单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skdydwxc"
				class="button button-primary button-small">散客导游单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="krmd"
				class="button button-primary button-small">客人名单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="krmdjs"
				class="button button-primary button-small">客人名单-接送</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="ykyjfkd"
				class="button button-primary button-small">游客反馈意见单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" id="skgwmxd" target="_blank"
				class="button button-primary button-small">散客购物明细单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" id="skgwmxd2" target="_blank"
				class="button button-primary button-small">散客购物明细单2</a>
		</div>
	</div>

</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>接送信息列表</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/transport.js"></script>
<style type="text/css">
	.Wdate {
		width:95px;
	}
</style>

</head>
<body>
	<div class="p_container">
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="transport.selectTransportListPage" />
			<input type="hidden" name="rp" value="queries/transport/transportTable" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
		            <li class="text" style="text-align: right;width:80px;">出发时间：</li>
					<li style="margin-left: 15px;"><input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${first}" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last}" />
					</li>
					<li class="text" style="text-align: right;width:80px;">接送方式：</li>
					<li>
		  				<select id="coachMethod" name="coachMethod" style="width: 104px;text-align: right">
							<option value="" selected="selected">请选择</option>
							<option value="0" style="height:20px;">接</option>
							<option value="1" style="height:20px;">送</option>
						</select>
					</li>
					<li class="text" style="text-align: right;width:80px;">交通类型：</li>
					<li><select id="transportType" name="transportType" style="width: 104px;text-align: right">
							<option value="" selected="selected">请选择</option>
		                	<c:forEach items="${transportTypeList}" var="v" varStatus="vs">
								<option id="it" value="${v.id}" style="height:20px;">${v.value}</option>
							</c:forEach>
		            </select></li>
					<li class="clear"/>
					<li class="text" style="text-align: right;width:123px;">始发-终点：</li>
					<li style="margin-left: 7px"><input id="departureCity"  name="departureCity" type="text"/></li><li>-></li>
					
					<li><input id="arrivalCity"  name="arrivalCity" type="text"/></li>
					<li class="text" style="text-align: right;width:80px;">目的地：</li>
					<li><input id="destination"  name="destination" type="text"/></li>
					
					<li class="text" style="text-align: right;width:80px;">团号：</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text" style="text-align: right;width:80px;">接站牌：</li>
					<li><input id="receiveMode"  name="receiveMode" type="text"/></li>
					
					<li class="clear"/>
					<li class="text"></li>
					<li style="margin-left:12px;">
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>利润查询</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/orderLock.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
	<script type="text/javascript">
     $(function() {
 		 var vars={
				 dateFrom : $.currentMonthFirstDay(),
			 	dateTo : $.currentMonthLastDay()
			 	};
		$("#tourGroupStartTime").val(vars.dateFrom);
		$("#tourGroupEndTime").val(vars.dateTo );
 	 
 });
     </script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form method="post" id="form">
					<input type="hidden" name="page" id="page" />
					<input type="hidden" name="pageSize" id="pageSize" />
					<dd class="inl-bl">
						
						<div class="dd_left">
							<select name="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</div>
						<div class="dd_right grey">
							<input type="text" id="tourGroupStartTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/> 
							<input type="text" id="tourGroupEndTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=""/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input type="text" name="tourGroup.groupCode" id="tourGroupGroupCode" value="${groupOrder.tourGroup.groupCode}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品:</div>
						<div class="dd_right grey">
							<input type="text" name="tourGroup.productName" id="tourGroupProductName" value="${groupOrder.tourGroup.productName}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客源地:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }" <c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
							</select>
							<select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
								<option value="${city.id }">${city.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
						锁单状态:
						</div>
						<div class="dd_right">
						<select name="orderLockState">
								<option value="">全部</option>
								<option value="1">锁单</option>
								<option value="0">未锁单</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">订单状态:</div>
						<div class="dd_right grey">
							<select name="state" id="orderState">
									<option value="-1" selected="selected">全部</option>
									<option value="1">已并团</option>
									<option value="2">未并团</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
						团类型:
						</div>
						<div class="dd_right">
						<select name="orderType">
								<option value="">全部</option>
								<option value="1">团队</option>
								<option value="0">散客</option>
								<option value="-1">一地散</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">接站牌:</div>
						<div class="dd_right grey">
							<input name="receiveMode" id="receiveMode" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						
						<div class="dd_right">
						部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</div> 
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
							<select id="select" name="select" style="width:80px;text-align: right;">
								<option value="0">计调</option>
								<option value="1">销售</option>
							</select>
						</div>   		
						<div class="dd_right">
						
							<input type="text" name="tourGroup.operatorName" stag="userNames" id="operatorName" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${groupOrder.saleOperatorIds}"/> 
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
							<button type="button" onclick="batchUpdate();" class="button button-primary button-small" style="margin-left: 35px;">批量变更</button> 
						</div>
						<div class="clear"></div>
					</dd>
				</form>
		</dl>
		<dl class="p_paragraph_content">
		<div id="content"></div>
		</dl>
		</div>
	</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团订单列表</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/fitOrderList_agency.js"></script>

</head>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form method="post" id="FitOrderListForm">
					<input type="hidden" id="isSales" value="${isSales}"> 
					<input type="hidden" name="page" id="orderPage" value="${page.page}"> 
					<input type="hidden" name="pageSize" id="orderPageSize" value="${page.pageSize}">
					<dd class="inl-bl">
						<div class="dd_left">
							<select name="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</div>
						<div class="dd_right grey">
							<input name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> 
							~ 
							<input name="endTime"  type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input name="groupCode" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品品牌:</div>
						<div class="dd_right grey">
							<select name="productBrandId"><option value="-1"
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productName" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">订单状态:</div>
						<div class="dd_right grey">
							<select name="state">
									<option value="-1" selected="selected">全部</option>
									<option value="1">已并团</option>
									<option value="2">未并团</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">锁单状态:</div>
						<div class="dd_right grey">
							<select name="orderLockState">
									<option value="-1" selected="selected">全部</option>
									<option value="1">已锁单</option>
									<option value="0">未锁单</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">订单类别:</div>
						<div class="dd_right grey">
							<select name="type">
									<option value="-1" selected="selected">全部</option>
									<option value="0">预留</option>
									<option value="1">确认</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">收款状态:</div>
						<div class="dd_right grey">
							<select name="cashState">
									<option value="-1" selected="selected">全部</option>
									<option value="1">已收清</option>
									<option value="0">未收清</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客户:</div>
						<div class="dd_right grey">
							<input name="supplierName" type="text"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客人:</div>
						<div class="dd_right grey">
							<input name="receiveMode" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					
					<dd class="inl-bl">
						<div class="dd_left">客源地:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }">${province.name}</option>
								</c:forEach>
							</select> <select name="cityId" id="cityCode">
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
							部门:
						</div>
						<div class="dd_right">
						
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						计调:
						<select name="operType">
								<!-- 							<option value="-1">全部</option> -->
								<option value="1" <c:if test="${groupOrder.operType==1 }">selected="selected"</c:if>  >销售计调</option>
								<option value="2" <c:if test="${groupOrder.operType==2 }">selected="selected"</c:if>>操作计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName"
								value="${groupOrder.saleOperatorName}" stag="userNames" readonly="readonly"  onclick="showUser()"/> <input
								name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
								value="${groupOrder.saleOperatorIds}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客源类别:</div>
						<div class="dd_right grey">
							<select name="sourceTypeId" >
								<option value="-1">请选择</option>
								<c:forEach items="${sourceTypeList }" var="source">
									<option value="${source.id }"
										<c:if test="${source.id==groupOrder.sourceTypeId }"> selected="selected" </c:if>>${source.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
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
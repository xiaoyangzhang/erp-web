<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>已确认团</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
	.Wdate{width:95px;}
</style>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
		<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form  action="findTourGroupByCondition.htm"  method="post" id="tourGroupForm">
					<input type="hidden" name="yesOrNo" id="yesOrNo" value="yes"/>
					<input type="hidden" name="pageSize" id="size" value="${page.pageSize}"/>
					<input type="hidden" id="searchPage" name="page"  value="${page.page}"/>
					
					<dd class="inl-bl">
						<div class="dd_left">
							<select name="dateType">
								<option value="1" <c:if test="${groupOrder.dateType==1 }">selected="selected"</c:if> >出团日期</option>
								<option value="2" <c:if test="${groupOrder.dateType==2 }">selected="selected"</c:if> >输单日期</option>
							</select>
					
						</div>
						<div class="dd_right grey">
							<input type="text" id="tourGroupStartTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${first}"/> 
							—
							<input type="text" id="tourGroupEndTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last}"/>
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
						<div class="dd_left">组团社:</div>
						<div class="dd_right grey">
							<input type="text" name="supplierName" id="supplierName" value="${groupOrder.supplierName}"/>
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
									<option value="${city.id }" <c:if test="${groupOrder.cityId==city.id  }"> selected="selected" </c:if>>${city.name }</option>
									</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">部门:</div>
						<div class="dd_right">
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						计调:
						<select name="operType">
			<!-- 							<option value="-1">全部</option> -->
								<option value="1">销售计调</option>
								<option value="2">操作计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${groupOrder.saleOperatorIds}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
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
	<!-- 改变状态 -->
	<div id="stateModal" style="display: none">
		<input type="hidden" name="id" id="modalgroupId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">状态:</div>
				<div class="dd_right">
					<select name="groupState" id="modalGroupState">
						<option value="0">未确认</option>
						<option value="1">已确认</option>
						<option value="2">废弃</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="button" class="button button-primary button-small" onclick="editOrderGroupInfo()">确定</button>
		</div>
	</div>
	<div id="exportWord" style="display: none;text-align: center;margin-top: 10px">
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleOrder" class="button button-primary button-small">确认单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleCharge" class="button button-primary button-small">结算单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleOrderNoRoute" class="button button-primary button-small">确认单-无行程</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleChargeNoRoute" class="button button-primary button-small">结算单-无行程</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="tddyd" class="button button-primary button-small">导游行程单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="guestNames" class="button button-primary button-small">客人名单</a>
		</div>
	</div>
</html>


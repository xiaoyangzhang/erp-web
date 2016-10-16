<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>销售计调单</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/saleOperator.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
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
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input type="text" id="startTime" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/> 
							—
							<input type="text" id="endTime" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value=''/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">组团社:</div>
						<div class="dd_right grey">
							<input type="text" name="supplierName" id="supplierName" value="${groupOrder.tourGroup.productName}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input type="text" name="groupCode" id="groupCode" value=""/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品:</div>
						<div class="dd_right grey">
							<input type="text" name="productName" id="productName" value=""/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客人:</div>
						<div class="dd_right grey">
							<input type="text" name="guestName" id="guestName" value=""/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">电话:</div>
						<div class="dd_right grey">
							<input type="text" name="mobile" id="mobile" value=""/>
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
							<input type="text" name="operatorName" stag="userNames" id="operatorName" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${groupOrder.saleOperatorIds}"/> 
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
	    				<div class="dd_left">状态:</div>
	    				<div class="dd_right">
	    				<select id="mergeGroupState" name="mergeGroupState" >
								<option value="1" >已并团</option>
								<option value="0" >未并团</option>
								<option value="" >所有</option>
               			</select>
               			</div>
						<div class="clear"></div>
	    			</dd>
	    			<div style="display: none">
	    				<div class="dd_left">星级:</div>
	    				<select id="hotelLevel" name="hotelLevel" class="select160" style="width: 160px;text-align: right">
                			<c:forEach items="${jdxjList}" var="v" varStatus="vs">
								<option value="${v.id}" style="height: 23px;text-align: right">${v.value}</option>
							</c:forEach>
               			</select>
	    			</div>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
							<a href="javascript:void(0);" id="toPreview" target="_blank" onclick="toPreview()" class="button button-primary button-small">预览</a>
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

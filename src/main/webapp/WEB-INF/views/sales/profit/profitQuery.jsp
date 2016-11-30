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
	src="<%=ctx%>/assets/js/web-js/sales/profit.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="form">
				<!-- bizId的作用主要用来区分是地接版还是组团版 根据这里跳转到不同的table方法 -->
					<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
					<input type="hidden" name="page" id="page" />
					<input type="hidden" name="pageSize" id="pageSize" />
					<ul class="inl-bl">
						<li class="text">出团日期:</li>
						<li>
							<input type="text" id="tourGroupStartTime" name="tourGroup.startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.startTime}" pattern="yyyy-MM-dd"/>'/> 
							—
							<input type="text" id="tourGroupEndTime" name="tourGroup.endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.endTime}" pattern="yyyy-MM-dd"/>'/>
						</li>
					
						<li class="text">团号:</li>
						<li>
							<input type="text" name="tourGroup.groupCode" id="tourGroupGroupCode" value="${groupOrder.tourGroup.groupCode}"/>
						</li>
						
						<li class="text">客户:</li>
						<li>
							<input type="text" name="supplierName" id="supplierName" value="${groupOrder.supplierName}"/>
						</li>
					
						<li class="text">客人信息:</li>
						<li>
							<input type="text" name="receiveMode" id="tourGroupProductName" value="${groupOrder.receiveMode}"/>
						</li>
					</ul>
					<ul>
						<li class="text">部门:</li>
						<li>
	    					<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()" style="width:186px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</li> 
						<li class="text">
							<select id="select" name="select" style="width:80px;text-align: right;margin-left: 5px;">
								<option value="0">计调</option>
								<option value="1">销售</option>
							</select>
						</li>   		
						<li class="text">
						
							<input type="text" name="tourGroup.operatorName" stag="userNames" id="operatorName" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${groupOrder.saleOperatorIds}"/> 
						</li>
						<li class="text" style="width: 142px;">产品:</li>
						<li>
							<input type="text" name="tourGroup.productName" id="tourGroupProductName" value="${groupOrder.tourGroup.productName}"/>
						</li>
					
						<li class="text">客源地:</li>
						<li>
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
						</li>
						
						<li style="padding-left:10px">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
						</li>
						<li class="clear"></li>
					</ul>
					
				</form>
			</div>
		</div>
		<dl class="p_paragraph_content">
			<div id="content"></div>
		</dl>
	</div>
</body>
</html>

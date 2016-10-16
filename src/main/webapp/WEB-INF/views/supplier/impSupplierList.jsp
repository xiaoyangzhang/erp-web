<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/impSupplier.js"></script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form class="definewidth m20" id="searchSupplierForm"
					action="toImpSupplierList.htm" method="post">
					<input type="hidden" name="page" value="${supplierInfo.page}"
						id="searchPage" /> <input type="hidden" name="pageSize"
						value="${supplierInfo.pageSize}" id="searchPageSize" /> <input
						type="hidden" name="supplierType"
						value="${supplierInfo.supplierType }" />

					<dd class="inl-bl">
						<div class="dd_left">名称:</div>
						<div class="dd_right grey">
							<input type="text" name="nameFull"
								value="${supplierInfo.nameFull }" class="input-small" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">区域:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择省</option>
								<c:forEach items="${allProvince}" var="province">
									<option value="${province.id }"
										<c:if test="${province.id==supplierInfo.provinceId }">selected="selected"</c:if>>${province.name }</option>
								</c:forEach>
							</select> <select name="cityId" id="cityCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择市</option>
								<c:forEach items="${cityList }" var="city">
									<option value="${city.id }"
										<c:if test="${city.id==supplierInfo.cityId }">selected="selected"</c:if>>${city.name }</option>
								</c:forEach>
							</select> <select name="areaId" id="areaCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择区县</option>
								<c:forEach items="${areaList }" var="area">
									<option value="${area.id }"
										<c:if test="${area.id==supplierInfo.areaId }">selected="selected"</c:if>>${area.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">状态:</div>
						<div class="dd_right grey">
							<select name="state" style="width: 100px; text-align: right;">
								<option value="0"
									<c:if test="${supplierInfo.state==0}"> selected="selected" </c:if>>全部</option>
								<option value="1"
									<c:if test="${supplierInfo.state==1}"> selected="selected" </c:if>>正常</option>
								<option value="2"
									<c:if test="${supplierInfo.state==2}"> selected="selected" </c:if>>审核中</option>
								<option value="4"
									<c:if test="${supplierInfo.state==4}"> selected="selected" </c:if>>未通过</option>
								<option value="3"
									<c:if test="${supplierInfo.state==3}"> selected="selected" </c:if>>停用</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<c:if test="${supplierInfo.supplierType!=1}">
					<dd class="inl-bl">
						<div class="dd_left">级别:</div>
						<div class="dd_right grey">
							<select name="level">
								<option value="0"
									<c:if test="${supplierInfo.level==0 }"> selected="selected" </c:if>>全部</option>
								<c:forEach items="${levelList}" var="level">
									<option value="${level.id }"
										<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					</c:if>
					<c:if test="${supplierInfo.supplierType==1}">
						<dd class="inl-bl">
							<div class="dd_left">组团社类别:</div>
							<div class="dd_right grey">
								<select name="level">
									<option value="0"
										<c:if test="${supplierInfo.level==0 }"> selected="selected" </c:if>>全部</option>
									<c:forEach items="${travelagencylevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</select>
							</div>
							<div class="clear"></div>
						</dd>
					</c:if>
					<dd class="inl-bl">
						<div class="dd_right">
							<button class="button button-primary button-small ml-10"
								onclick="impSearchBtn();">搜索</button>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">
				<table class="w_table">
					<colgroup>
						<col width="10%">
						<col width="30%">
						<col width="15%">
						<col width="35%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th><i class="w_table_split"></i></th>
							<th>名称<i class="w_table_split"></i></th>
							<c:if test="${supplierInfo.supplierType!=1}">
								<th>级别<i class="w_table_split"></i></th>
							</c:if>
							<c:if test="${supplierInfo.supplierType==1}">
								<th>组团社类别<i class="w_table_split"></i></th>
							</c:if>
							<th>区域<i class="w_table_split"></i></th>
							<th>状态<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<c:forEach items="${page.result}" var="supplierInfo"
						varStatus="status">
						<tr>

							<td><input type="checkbox" name="supplierChecked"
								<c:if test="${supplierInfo.state!=1 }"> disabled="disabled" </c:if>
								value="${supplierInfo.id}" /></td>
							<td style="text-align: left;">${supplierInfo.nameFull}</td>
							<td><c:if test="${supplierInfo.supplierType!=1}">
									<c:forEach items="${levelList}" var="level">
										<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
									</c:forEach>
								</c:if> <c:if test="${supplierInfo.supplierType==1}">
									<c:forEach items="${travelagencylevelList}" var="level">
										<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
									</c:forEach>
								</c:if></td>
							<td style="text-align: left;">${supplierInfo.provinceName }${supplierInfo.cityName }${supplierInfo.areaName }${supplierInfo.townName }</td>


							<td><c:if test="${supplierInfo.state==1 }">
									<span style="color: green">正常</span>
								</c:if> <c:if test="${supplierInfo.state==2 }">审核中</c:if> <c:if
									test="${supplierInfo.state==3 }">
									<span style="color: red">已停用</span>
								</c:if></td>
						</tr>

					</c:forEach>
				</table>

				<jsp:include page="/WEB-INF/include/page.jsp">
					<jsp:param value="${page.page }" name="p" />
					<jsp:param value="${page.totalPage }" name="tp" />
					<jsp:param value="${page.pageSize }" name="ps" />
					<jsp:param value="${page.totalCount }" name="tn" />
				</jsp:include>
			</dl>
			<div class="Footer">
				<button type="button"
					class="button button-primary button-rounded button-small"
					onclick="impSupplier();">导入</button>
				<button type="button"
					class="button button-primary button-rounded button-small"
					onclick="toAddSupplier(${supplierInfo.supplierType});">新增</button>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">
	function toAddSupplier(supplierType){
		//var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
		parent.window.location = "toAddSupplier.htm?supplierType="+supplierType;
	}
</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table class="w_table">
	<colgroup>
		<col width="8%">
		<col width="40%">
		<col class="size_hidden" width="40%">
		<col width="12%">
    </colgroup>
	<thead>
		<tr>	
			<th>&nbsp;<i class="w_table_split"></i></th>
			<th>名称<i class="w_table_split"></i></th>					
			<th class="size_hidden">地址<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>					
		</tr>
	</thead>
	<c:forEach items="${page.result}" var="supplierInfo"
		varStatus="status">
		<tr>
			<td><input type="checkbox" <c:if test="${supplierInfo.state!=1 }">disabled</c:if> sid="${supplierInfo.id}" onclick="chkSupplier(this,'${supplierInfo.id}','${supplierInfo.nameFull}','${supplierInfo.supplierType}','${typeMap[supplierInfo.supplierType]}','${supplierInfo.provinceName}','${supplierInfo.cityName}','${supplierInfo.areaName}','${supplierInfo.townName}')" /></td>
			<td>${supplierInfo.nameFull}</td>					
			<td class="size_hidden">${supplierInfo.provinceName }${supplierInfo.cityName }${supplierInfo.areaName }${supplierInfo.townName }</td>
			<td><c:if
					test="${supplierInfo.state==1 }">
					<span style="color: green">正常</span>
				</c:if> <c:if test="${supplierInfo.state==2 }">审核中</c:if> <c:if
					test="${supplierInfo.state==3 }">
					<span style="color: red">已停用</span>
				</c:if>
				<c:if
					test="${supplierInfo.state==4 }">
					<span style="color: red">未通过</span>
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
		
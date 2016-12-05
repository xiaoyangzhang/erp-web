<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table class="w_table">
	<colgroup>
		<col width="8%">
		<col width="45%">
		<col width="30%">
		<col width="17%">
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" id="chkall" onclick="checkAllSupplier(this);"/><i class="w_table_split"></i></th>
			<th>名称<i class="w_table_split"></i></th>
			<th class="size_hidden">地址<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="supplier">
			<tr>
				<td><input type="checkbox" class="single-org-supplier-auth" value="${supplier.id}" onclick="checkSingleSupplier(this);"/></td>
				<td>${supplier.nameFull}</td>
				<td>${supplier.provinceName}${supplier.cityName}${supplier.areaName}${supplier.townName}</td>
				<td>
					<c:if
						test="${supplier.state==1 }">
						<span style="color: green">正常</span>
					</c:if>
					
					<c:if test="${supplier.state==2 }">
						<span>审核中</span>
					</c:if> 
					
					<c:if test="${supplier.state==3 }">
						<span style="color: red">已停用</span>
					</c:if>
					<c:if test="${supplierInfo.state==4 }">
						<span style="color: red">未通过</span>
					</c:if>
				</td>	
			</tr>	
		</c:forEach>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table class="w_table">
	<colgroup>
		<col width="8%">
		<col width="10%">
		<col width="35%">		
		<col  width="10%">
		
    </colgroup>
	<thead>
		<tr>	
			<th><input type="checkbox" id="chkall" onclick="chkAll(this)" /><i class="w_table_split"></i></th>
			<th>产品编号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>					
			<th >目的地<i class="w_table_split"></i></th>
							
		</tr>
	</thead>
	<c:forEach items="${page.result}" var="productInfo"
		varStatus="status">
		<tr>
			<td><input type="checkbox" name="chk" <%-- <c:if test="${productInfo.state!=2 }">disabled</c:if> --%> state="${productInfo.state }" sid="${productInfo.id}" 
			sbrand="${productInfo.brandName}" sproduct="${productInfo.nameCity  }" onclick="chkSupplier(this)"/></td>
			<td>${productInfo.code}</td>
			<td>【${productInfo.brandName}】${productInfo.nameCity }</td>					
			<td >${productInfo.destProvinceName }/${productInfo.destCityName }</td>
							
		</tr>

	</c:forEach>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
		
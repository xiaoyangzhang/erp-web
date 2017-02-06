<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table cellpadding="0" class="w_table" > 
    <thead>
    	<tr>
    		<th>选择<i class="w_table_split"></i></th>
    		<th>自编码<i class="w_table_split"></i></th>
			<th>套餐名称<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${pageBean.result}" var="tbpResult" varStatus="status">
		<tr id="${tbpResult.id }">
			<td width="5%"><input type="checkbox" name="tpsId" id="tpsId" value="${tbpResult.tpsId}"></td>
			<td width="25%">${tbpResult.outerId }</td>
			<td width="40%" style="text-align:left;">${tbpResult.title }</td>
			<td width="30%" style="text-align:left;">${tbpResult.pidName }</td>
       </tr>
     </c:forEach>
    </tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

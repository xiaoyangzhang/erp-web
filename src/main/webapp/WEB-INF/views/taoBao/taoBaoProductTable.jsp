<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table cellpadding="0" class="w_table" > 
    <thead>
    	<tr>
    		<th>选择<i class="w_table_split"></i></th>
    		<th>自编码<i class="w_table_split"></i></th>
    		<th>产品名称<i class="w_table_split"></i></th>
    		
    	</tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="tbpResult" varStatus="status">
       <tr id="${tbpResult.id }"> 
       	  <td width="8%"><input type="checkbox" name="productId" id="productId" value="${tbpResult.id}"></td>
          <td width="30%">${tbpResult.outerId }</td>
          <td width="60%" style="text-align:left;">${tbpResult.title }</td> 
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

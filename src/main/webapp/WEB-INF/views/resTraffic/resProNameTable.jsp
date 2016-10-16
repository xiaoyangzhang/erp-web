<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table cellpadding="0" class="w_table" > 
    <thead>
    	<tr>
    		<th>选择<i class="w_table_split"></i></th>
    		<th>产品编号<i class="w_table_split"></i></th>
    		<th>产品名称<i class="w_table_split"></i></th>
    		<!-- <th>计调</th> -->
    		
    	</tr>
    </thead>
    <tbody>
    <c:forEach items="${page.result}" var="productInfo" varStatus="status">
       <tr id="${productInfo.id }"> 
       	  <td width="8%"><input type="checkbox" name="cb" id="cb" value="${productInfo.id}"></td>
          <td width="20%">${productInfo.code }</td>
          <td width="60%" style="text-align:left;">${productInfo.brandName }${productInfo.nameCity }</td> 
        <%--   <td>${productInfo.operatorName }</td> --%>
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
		
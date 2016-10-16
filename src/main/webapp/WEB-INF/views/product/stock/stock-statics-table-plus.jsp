<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="16%"/>
    <col width="4%"/>
     <col width="4%"/>
     <col width="4%"/>
     <col width="4%"/>
   <col width="4%"/>
     <col width="4%"/>
     <col width="4%"/>
     <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/>
    <col width="4%"/> 
    <thead>
    <tr>        
        <th rowspan="2">产品名称</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[0].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[1].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[2].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[3].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[4].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[5].itemDate}"/><br>总量|收客|剩余</th>
    	<th colspan="3" ><fmt:formatDate pattern="yyyy-MM-dd" value="${ page.result[0].stockList[6].itemDate}"/><br>总量|收客|剩余</th>
    </tr>
      
	
    </thead>
    <tbody>
     <c:forEach items="${page.result}" var="item" varStatus="status">
        <tr >
        	<td >【${item.brandName }】${item.productName }</td>
        	<c:forEach items="${item.stockList }" var="stock" >
        	
        	<td>${stock.stockCount }</td>
        	<td>${stock.receiveCount }</td>
        	<td>${stock.stockCount-stock.receiveCount }</td>
        	</c:forEach>
        </tr>
    </c:forEach> 
    </tbody>
</table>
 <jsp:include page="/WEB-INF/include/page.jsp">
    <jsp:param value="${page.page }" name="p"/>
    <jsp:param value="${page.totalPage }" name="tp"/>
    <jsp:param value="${page.pageSize }" name="ps"/>
    <jsp:param value="${page.totalCount }" name="tn"/>
</jsp:include> 
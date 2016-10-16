<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="55%"/>
    <col width="15%"/>
    <col width="10%"/>
    <col width="10%"/>
    <col width="10%"/>
    <thead>
    <tr>        
        <th>产品名称<i class="w_table_split"></i></th>
        <th>日期<i class="w_table_split"></i></th>
        <th>总量<i class="w_table_split"></i></th>
        <th>收客<i class="w_table_split"></i></th>
        <th>剩余</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.result}" var="item" varStatus="status">
        <tr>
            <td style="text-align:left" rowspan="7">【${item.brandName }】${item.productName }</td>
           	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${item.itemVoList[0].groupDate }"/></td>
           	<td>${item.itemVoList[0].stockCount}</td>
           	<td>${item.itemVoList[0].receiveCount}</td>
           	<td>${item.itemVoList[0].stockCount-item.itemVoList[0].receiveCount}</td>            		
        </tr>
       	<c:forEach items="${item.itemVoList}" var="vo" varStatus="st">
       		<c:if test='${st.index>0}'>
	       		<tr>
		           	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${vo.groupDate }"/></td>
		           	<td>${vo.stockCount}</td>
		           	<td>${vo.receiveCount}</td>
		           	<td>${vo.stockCount-vo.receiveCount}</td>
	       		</tr>
       		</c:if> 
        </c:forEach>
    </c:forEach>
    </tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
    <jsp:param value="${page.page }" name="p"/>
    <jsp:param value="${page.totalPage }" name="tp"/>
    <jsp:param value="${page.pageSize }" name="ps"/>
    <jsp:param value="${page.totalCount }" name="tn"/>
</jsp:include>
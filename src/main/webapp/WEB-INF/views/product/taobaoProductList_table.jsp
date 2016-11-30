<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
String staticPath = request.getContextPath();
%>

<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="5%"/>
    <col width="30%"/>
    <col width="60%"/>
    <col width="5%"/>
    <thead>
    <tr>
        <th>序号<i class="w_table_split"></i></th>
        <th>自编码<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody class="wtbodys">
    <c:forEach items="${page.result}" var="list" varStatus="status">
        <tr id="${list.id }">
            <td>${status.count}</td>
            <td>${list.outerId }</td>
            <td style="text-align:left">
               ${list.title }</td>
            <td> </td>
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


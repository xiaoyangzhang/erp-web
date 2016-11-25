<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
    <thead>
    <tr>
        <th style="width: 3%">序号<i class="w_table_split"></i></th>
        <th style="width: 10%">公告标题<i class="w_table_split"></i></th>
        <th>公告内容<i class="w_table_split"></i></th>
        <th style="width: 10%">发送时间<i class="w_table_split"></i></th>
        <th style="width: 3%">总数<i class="w_table_split"></i></th>
        <th style="width: 3%">未读<i class="w_table_split"></i></th>
        <th style="width: 3%">已读<i class="w_table_split"></i></th>
        <th style="width: 5%">操作</th>
    </tr>
    </thead>
    <tbody>
    
    <c:forEach items="${pageBean.result}" var="msg" varStatus="v">
        <tr>
            <td>${v.count}</td>
            <td style="text-align:left;">${msg.msgTitle}</td>
            <td style="text-align:left;">${msg.msgText}</td>
            <td>${msg.createTime}</td>
            <td>
                ${msg.totalCount}
            </td>
            <td>
                <font style="color: red">${msg.unReadCount}</font>
            </td>
            <td>
                <font style="color: blue">${msg.readCount}</font>
            </td>
            <td>
                <a href="javascript:void(0);" onclick="showNoticeView(${msg.id});">查看</a>
            </td>
        </tr>
    </c:forEach>
    
    </tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
    <jsp:param value="${pageBean.page }" name="p"/>
    <jsp:param value="${pageBean.totalPage }" name="tp"/>
    <jsp:param value="${pageBean.pageSize }" name="ps"/>
    <jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>
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
        <th style="width: 10%">消息标题<i class="w_table_split"></i></th>
        <th style="width: 15%">消息内容<i class="w_table_split"></i></th>
        <th style="width: 5%">消息发送人<i class="w_table_split"></i></th>
        <th style="width: 7%">发送时间<i class="w_table_split"></i></th>
        <th style="width: 5%">状态<i class="w_table_split"></i></th>
        <th style="width: 8%">操作</th>
    </tr>
    </thead>
    <tbody>
    
    <c:forEach items="${pageBean.result}" var="msg" varStatus="v">
        <tr>
            <td>${v.count}</td>
            <td style="text-align:left;">${msg.msgTitle}</td>
            <td style="text-align:left;">${msg.msgText}</td>
            <td>${msg.operatorName}</td>
            <td>${msg.createTime}</td>
            <td>
                <c:if test="${msg.status==0}">
                    <a href="javascript:void(0);" onclick="readMsg(${msg.midId});">未读</a>
                </c:if>
                <c:if test="${msg.status==1}">已读</c:if>
            </td>
            <td>
                <a href="javascript:void(0);" onclick="showMsgView(${msg.midId},${msg.id});">查看信息</a>
                <a href="javascript:void(0);" onclick="showDetail(${msg.orderId});">查看单据</a>
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
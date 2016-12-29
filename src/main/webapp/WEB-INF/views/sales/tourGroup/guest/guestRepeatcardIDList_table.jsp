<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String staticPath = request.getContextPath();
%>


	<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="5%"/>
    <col width="8%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="6%"/>
    <col width="13%"/>
    <col width="13%"/>
    <col width="6%"/>
    <col />
    <thead>
    <tr>
    	<th>序号<i class="w_table_split"></i></th>
        <th>姓名<i class="w_table_split"></i></th>
        <th>性别<i class="w_table_split"></i></th>
        <th>年龄<i class="w_table_split"></i></th>
        <th>手机号<i class="w_table_split"></i></th>
        <th>证件号<i class="w_table_split"></i></th>
        <th>籍贯<i class="w_table_split"></i></th>
        <th>参团次数<i class="w_table_split"></i></th>
        <th>团号<i class="w_table_split"></i></th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="guest" varStatus="status">
        <tr id="${guest.id }">
        	<td>${status.count }</td>
 			<td>${guest.name }</td>
 			<td>
 				<c:if test="${guest.gender==0 }">女</c:if> 
 				<c:if test="${guest.gender==1 }">男</c:if>
 			</td>
            <td>${guest.age } </td>
            <td>${guest.mobile } </td>
            <td>${guest.certificateNum } </td>       
            <td style="text-align:left">${guest.nativePlace }</td>
            <td>${guest.times } </td>
            <td style="text-align:left">${guest.groupCode } </td>
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

</script>
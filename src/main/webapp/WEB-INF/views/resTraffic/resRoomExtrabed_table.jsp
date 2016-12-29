<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String staticPath = request.getContextPath();
%>


	<table cellspacing="0" cellpadding="0" class="w_table">
    <col width="5%"/>
    <col width="15%"/>
    <col />
    <col width="15%"/>
    <col width="15%"/>
    <thead>
    <tr>
    	<th>序号<i class="w_table_split"></i></th>
        <th>日期<i class="w_table_split"></i></th>
        <th>产品名称<i class="w_table_split"></i></th>
        <th>数量<i class="w_table_split"></i></th>
        <th>加床<i class="w_table_split"></i></th>
       
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="room" varStatus="status">
        <tr id="${room.id }">
        	<td>${status.count }</td>
 			<td>${room.departureDate }</td>
            <td style="text-align:left">【${room.productBrandName }】 ${room.productName } </td>       
            <td>${room.countDoubleRoom } </td>
            <td>${room.extraBed }</td>
        </tr>
        <c:set var="sumCountDoubleRoom" value="${sumCountDoubleRoom+ room.countDoubleRoom}"></c:set>
        <c:set var="sumExtraBed" value="${sumExtraBed+ room.extraBed}"></c:set>
    </c:forEach>
    </tbody>
    <tfoot>
		<tr class="footer1">
			<td></td>
            <td></td>
 			<td style="text-align:right;">页合计</td>
            <td>${sumCountDoubleRoom }</td>
            <td>${sumExtraBed }</td>
		</tr>
		<tr class="footer2">
			<td></td>
            <td></td>
 			<td style="text-align:right;">总合计</td>
            <td>${sum.count_double_room }</td>
            <td>${sum.extrabed }</td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>

</script>
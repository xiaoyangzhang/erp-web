<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="30%" />
	<col width="5%" />
	<col width="15%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>标签<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td  >${item.tag_name}</td>
				<td  >${item.count_tag}</td>
				<td>
					<c:if test="${'1'== item.pub_state}">
					<a class="def" href="javascript:void(0)" onclick="updateTag('${item.tag_name}','${item.pub_state}')">隐藏</a>
				</c:if>
				<c:if test="${'0'== item.pub_state}">
					<a class="def" href="javascript:void(0)" onclick="updateTag('${item.tag_name}','${item.pub_state}')">发布</a>
				</c:if>
				</td>
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
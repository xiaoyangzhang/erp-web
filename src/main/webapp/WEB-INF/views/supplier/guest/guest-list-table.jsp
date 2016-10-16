<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>创建日期<i class="w_table_split"></i></th>
			<th>姓名<i class="w_table_split"></i></th>
			<th>电话<i class="w_table_split"></i></th>
			<th>身份证号<i class="w_table_split"></i></th>
			<th>性别<i class="w_table_split"></i></th>
			<th>年龄<i class="w_table_split"></i></th>
			<th>住址<i class="w_table_split"></i></th>
			<th>旅游记录<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th>操作员<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td ><fmt:formatDate value="${item.createTime}" pattern="yyyy/MM/dd" /></td>
				<td >${item.name}</td>
				<td >${item.mobile}</td>
				<td >${item.idCardNo}</td>
				<td >
					<c:if test="${item.gender eq 'F'}">
						女
					</c:if>
					<c:if test="${item.gender eq 'M'}">
						男
					</c:if>
				</td>
				<td >${item.age}</td>
				<td >${item.addr}</td>
				<td ><a class="def" href="javascript:void(0)" onclick="travelRecords('${item.idCardNo}');">查看</a></td>
				<td >${item.remark}</td>
				<td >${item.userName}</td>
				<td>
					<a class="def" href="javascript:void(0)" onclick="newWindow('查看客人','<%=staticPath %>/supplierGuest/editGuest.htm?check=true&id=${item.id}')">查看</a>
					<a class="def" href="javascript:void(0)" onclick="newWindow('修改客人','<%=staticPath %>/supplierGuest/editGuest.htm?id=${item.id}')">编辑</a>
					<a class="def" href="javascript:void(0)" onclick="deleteGuest(${item.id})">删除</a>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
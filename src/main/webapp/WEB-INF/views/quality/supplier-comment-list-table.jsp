<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="5%" />
	<col width="30%" />
	<col width="30%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="15%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>用户名<i class="w_table_split"></i></th>
			<th>评论内容<i class="w_table_split"></i></th>
			<th>回复内容<i class="w_table_split"></i></th>
			<th>评分<i class="w_table_split"></i></th>
			<th>时间<i class="w_table_split"></i></th>
			<th>客户端<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td  >${item.creator_name}</td>
				<td  >${item.content}</td>
				<td colspan="1">
					<c:if test="${not empty item.supplierCommentReplyDetailList}">
					<table cellspacing="0" cellpadding="0" class="w_table" style="border-top:0px;">
						<col width="100%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.supplierCommentReplyDetailList}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.supplierCommentReplyDetailList) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"border-bottom:0px;\"" />
								</c:if>
							<tr>
								<td ${borderCss } >${bill.content }</td>
							<tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
				<td><fmt:formatNumber value="${item.level }" pattern="#.#"/></td>
				<td><fmt:formatDate value="${item.create_time}" pattern="yyyy-MM-dd" /></td>
				<td>${item.source}</td>
				<td>
				<c:if test="${'1'== item.pub_state}">
					<a class="def" href="javascript:void(0)" onclick="updateComment('${item.id}','${item.pub_state}')">隐藏</a>
				</c:if>
				<c:if test="${'0'== item.pub_state}">
					<a class="def" href="javascript:void(0)" onclick="updateComment('${item.id}','${item.pub_state}')">发布</a>
				</c:if>
					<a class="def" href="javascript:void(0)" onclick="addReply('${item.id}');">回复</a>
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
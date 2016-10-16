<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table" >
<col width="3%"><col width="7%"><col width="5%"><col width="5%"><col width="5%"><col width="5%"><col width="5%"><col width="10%">
<col width="5%"><col width="5%"><col width="5%"><col width="8%">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>咨询日期<i class="w_table_split"></i></th>
			<th>姓名<i class="w_table_split"></i></th>
			<th>电话<i class="w_table_split"></i></th>
			<th>客人来源<i class="w_table_split"></i></th>
			<th>意向游玩<i class="w_table_split"></i></th>
			<th>信息渠道<i class="w_table_split"></i></th>
			<th>咨询主题<i class="w_table_split"></i></th>
			<th>接待人<i class="w_table_split"></i></th>
			<th>跟进人<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td ><fmt:formatDate value="${v.consultDate }" pattern="yyyy-MM-dd" /></td>
				<td>${v.name}</td>
				<td>${v.phone}</td>
				<td>${v.guestSourceName}</td>
				<td>${v.intentionDestName}</td>
				<td>${v.infoSourceName}</td>
				<td>${v.topic}</td>
				<td>${v.receiverName}</td>
				<td>${v.followerName}</td>
				<td>
					<c:if test="${v.state==0 }">未开始</c:if>
					<c:if test="${v.state==1 }">跟进中</c:if>
					<c:if test="${v.state==2 }">已成团</c:if>
					<c:if test="${v.state==3 }">结束</c:if>
				</td>
				<td>
					<a class="" href="javascirpt:void(0)" onclick="viewConsultInfo(${v.id})">查看</a>
					<a class="" href="javascirpt:void(0)" onclick="followConsult(${v.id})">跟进</a>
					<c:if test="${v.state!=3 }">
					<a class="" href="javascirpt:void(0)" onclick="del(${v.id})">删除</a>
					</c:if>
				</td>
			</tr>
			
		</c:forEach>
	</tbody>
	
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

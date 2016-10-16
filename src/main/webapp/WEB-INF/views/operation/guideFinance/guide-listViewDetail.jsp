<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../../../include/path.jsp" %>

          	<div class="in_tab mb-30">
				<p class="in_tab_title"><b>需求订单</b></p>
				<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<tr>
						<th>语种</th>
						<th>客户名称</th>
						<th>年限</th>
						<th>性别</th>
						<th>备注</th>
					</tr>
					
					<c:forEach items="${groupRequirements }" var="require">
						<tr>
	          			
		 					<td>${require.language }</td>
	          				<td>${require.nameFull }</td>
	          				<td>${require.ageLimit }</td>
	          				<td>
	          				<c:if test="${require.gender==1}">男</c:if><c:if test="${require.gender==0}">女</c:if></td>
	          				<td>${require.remark }</td>
		 				</tr>
					</c:forEach>
			
			</table>
				
				<p class="in_tab_title"><b>导游单</b></p>
          		<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
          			<col width="10%" /><col width="10%" /><col width="10%" /><col width="10%" /><col width="10%" />
 					<col width="8%" /><col width="30%" /><col width="10%" />
          			<tr>
          				<th>订单号</th>
          				<th>订单时间</th>
          				<th>预订员</th>
          				<th>上团时间</th>
          				<th>下团时间</th>
          				<th>导游</th>
          				<th>备注</th>
          				<th>操作</th>
          			</tr>
          			 <c:forEach items="${vo}" var="group">
          				 <c:forEach items="${group.guideTimes}" var="times" varStatus="i">
	          			<tr>
	          			<c:if test="${i.count==1}">
	          			<td rowspan="${fn:length(group.guideTimes)}">${group.guide.bookingNo}</td>
	          				<td rowspan="${fn:length(group.guideTimes)}"><fmt:formatDate value="${group.guide.bookingDate}" pattern="yyyy-MM-dd"/></td>
	          				<td rowspan="${fn:length(group.guideTimes)}">${group.guide.userName}</td>
				        </c:if>
				          	<td >${times.timeStart}</td>
				          	<td >${times.timeEnd}</td>
				          	
				        <c:if test="${i.count==1}">
				        	<td rowspan="${fn:length(group.guideTimes)}">${group.guide.guideName}<br/>${group.guide.guideMobile}</td>
				          	<td rowspan="${fn:length(group.guideTimes)}">${group.guide.remark}</td>
	          				<td rowspan="${fn:length(group.guideTimes)}">
	          					<a class="def" href="javascript:void(0)" onclick="newWindow('报账单','<%=staticPath %>/bookingGuideFinance/finance.htm?bookingId=${group.guide.id}&groupId=${groupId}')">报账单</a>
	          					 <c:if test="${groupMode==0}">
			                  		<a class="def" href="download.htm?guideId=${group.guide.id}&num=2">打印出团单</a>
			                  	 </c:if>
			                  	 <c:if test="${groupMode>0}">
			                  		<a class="def" href="download.htm?guideId=${group.guide.id}&num=1">打印出团单</a>
			                  	 </c:if>
	          				</td>
	          			 </c:if>	
	          			</tr>
	          			</c:forEach>
          			</c:forEach>
          		</table>
          	</div>  	

<script type="text/javascript">

</script>
		
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<p class="p_paragraph_title">
	<b>需求订单</b>
</p>
<dl class="p_paragraph_content">
	<dd>
		<div class="pl-20 pr-20 w-1100">
			<table class="w_table"  border="" cellspacing="0" cellpadding="0">
					<col width="20%" />
					<%-- <col width="20%" /> --%>
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					
				<tbody>
					<tr style="background: #F4F5F6;">
						<td rowspan="1"><b>语种</b></td>
						<!-- <td rowspan="1"><b>客户名称</b></th> -->
						<td rowspan="1"><b>年限</b></th>
						<td rowspan="1"><b>性别</b></th>
						
						<td rowspan="1"><b>备注</b></td>
					</tr>
					
					<c:forEach items="${bookingInfo.requirementInfos }" var="require">
						<tr>
	          			
		 					<td>${require.language }</td>
	          				<%-- <td>${require.nameFull }</td> --%>
	          				<td>${require.ageLimit }</td>
	          				<td>
	          				<c:choose>
	          					
	          				<c:when test="${require.gender==1}">女</c:when><c:when test="${require.gender==0}">男</c:when>
	          				<c:otherwise>不限</c:otherwise>
	          				</c:choose>
	          				</td>
	          				
	          				<td>${require.remark }</td>
		 				</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</dd>
</dl>
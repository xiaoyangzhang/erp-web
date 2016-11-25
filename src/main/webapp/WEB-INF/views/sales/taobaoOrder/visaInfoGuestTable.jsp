<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<%
	String path = ctx;
%>
</head>
<body class="blank_body_bg">
	<div class="p_container blank_page_bg">
		<form id="saveResourceForm">
			<dl class="p_paragraph_content">

				<table class="w_table" style="margin-left: 0px">
					<thead>
						<tr>
							<th>客户<i class="w_table_split"></i></th>
							<th>手机<i class="w_table_split"></i></th>
							<!-- <th>计调</th> -->
							<th>拍下日期<i class="w_table_split"></i></th>
							<th>收件日期<i class="w_table_split"></i></th>
							<th>送签日期<i class="w_table_split"></i></th>
							<th>发件日期<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${groupOrderList}" var="visa" varStatus="vs">
							<tr>
								<td width="10%">${visa.guestName }</td>
								<td width="10%">${visa.mobile }</td>

								<td width="20%">${visa.patTime }</td>
								<td width="20%">${visa.receiptTime }</td>
								<td width="20%">${visa.sendSignTime }</td>
								<td>${visa.sendTime }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</dl>
		</form>
	</div>
</body>

</html>

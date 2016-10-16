<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>新增产品_价格设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
     
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub" id="tab1">
			<p class="p_paragraph_title">
				<b>组团社列表</b>
			</p>
			<table cellspacing="0" cellpadding="0" class="w_table ml-20"
				id="priceTable">
				<col width="10%" />
				<col width="40%" />
				<col width="50%" />
				<thead>
					<tr>
						<th><input type="checkbox" name="chkall" /><i class="w_table_split"></i></th>
						<th>区域<i class="w_table_split"></i></th>
						<th>组团社</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${groupSuppliers}" var="gs" varStatus="status">
						<tr id="${gs.id }">
							<td><input type="checkbox" name="chk" /></td>
							<td>${gs.province }${gs.city }</td>
							<td>${ gs.supplierName}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</dl>
		</div>
	</div>
</body>
</html>

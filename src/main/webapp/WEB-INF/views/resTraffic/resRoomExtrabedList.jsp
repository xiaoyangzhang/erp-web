<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源列表</title>
	<%@ include file="../../include/top.jsp" %>
<SCRIPT type="text/javascript">
		$(function () {
			function setData() {
				var curDate = new Date();
				var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
				$("#startTime").val(startTime);
				var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
				var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
				var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
				$("#endTime").val(endTime);

			}
			setData();
		});

</SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
		<form id="extrabedForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" >日期</li>
						<li>
							<input name="startTime" id="startTime" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="endTime" id="endTime" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
						
						<li class="text" >产品名称</li>
						<li>
							<select class="select160" name="productBrandId" id="productBrandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName" id="productName"/>					
						</li>
						
						<li class="text" style="width:35px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">查询</button>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="extrabedRoomTable"></div>
	</div>

<script type="text/javascript">
function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);

	var options = {
		url: "<%=staticPath %>/resTraffic/resRoomExtrabed_table.do",
		type: "post",
		dataType: "html",
	success: function (data) {
			$("#extrabedRoomTable").html(data);
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			$.error("服务忙，请稍后再试");
		}
	}
	$("#extrabedForm").ajaxSubmit(options);
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}


$(function () {
	queryList();
});
</script>
</body>
</html>
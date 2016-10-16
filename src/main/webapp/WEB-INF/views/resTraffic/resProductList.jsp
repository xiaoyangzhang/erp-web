<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>产品列表</title>
	<%@ include file="../../include/top.jsp" %>
	<SCRIPT type="text/javascript">
		$(function () {
			function setData() {
				var curDate = new Date();
				// var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
				var today=curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-"+curDate.getDate();
				$("#startMin").val(today);
				var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
				var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
				var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
				$("#startMax").val(endTime);

			}
			setData();
//queryList();
		});
	
		
		function queryList(page, pagesize) {
			if (!page || page < 1) {
				page = 1;
			}
			$("#page").val(page);
			$("#pageSize").val(pagesize);

			var options = {
				url: "<%=staticPath %>/resTraffic/resProductList_table.do",
				type: "post",
				dataType: "html",
			success: function (data) {
					$("#tableDiv").html(data);
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert("服务忙，请稍后再试");
				}
			}
			$("#queryForm").ajaxSubmit(options);
		}

		function searchBtn() {
			queryList(1, $("#pageSize").val());
		}
		

		$(function () {
			queryList();
		});
		
</SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
		<form id="queryForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">日期</li>
						<li>
							<input name="startMin" id="startMin" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="" style="width:90px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
			
						<li class="text">类型</li>
						<li>
							<select name="resMethod" id="resMethod">
								<option value="AIR">飞机</option>
								<option value="TRAIN">火车</option>
								<option value="car">汽车</option>
							</select>
						</li>
						
							<li class="text"style="width:100px;">产品名称</li>
						<li><input type="text" name="productName"/></li>
						
						<li class="text"style="width:100px;">资源名称</li>
						<li><input type="text" name="resName"/></li>
						
						<li class="text" style="width:35px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>
</body>
</html>
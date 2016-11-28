<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>预售产品统计</title>
	<%@ include file="../../../include/top.jsp" %>
	<SCRIPT type="text/javascript">
		$(function () {
			function setData() {
				var curDate = new Date();
				var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
				$("#startMin").val(startTime);
				var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
				var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
				var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
				$("#startMax").val(endTime);
				var today=curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-"+curDate.getDate();
				//$("#today").val(today);
				//$("#today1").val(today);
				
				$("#startTime").val(today);
				$("#endTime").val(today);

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
				url: "<%=staticPath %>/taobao/notPresellProductStatistics_table.do",
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
		
		function detail(obj){
			var url = "/taobao/taobaoOriginalOrder.htm?startMin="+$("#today").val()+"&startMax="+$("#today1").val()
					+"&isBrushSingle="+$("#isBrushSingle").val()+"&myStoreId="+$("#myStoreId").val()+"&title="+$("#title").val()+"&outerIid="+obj;
			newWindow('淘宝原始单','<%=staticPath %>'+url);
		}

</SCRIPT>
</head>
<body>
<div class="p_container" id=aaaa>
		<form id="queryForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${page.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${page.pageSize }"/>
			<%-- <input type="hidden" name="authClient" id="authClient" value="${authClient}"/> --%>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" >产品名称</li>
						<li><input type="text" name="title"/></li>
						
						<li class="text" style="">
						<select name="dateType" id="dateType">
								<option value="1" <c:if test="${dateType=='1' }" >selected="selected"</c:if>>下单时间</option>
								<option value="2" <c:if test="${dateType=='2' }" >selected="selected"</c:if>>付款时间</option>
							</select>
						</li>
						<li>
							<input name="startMin" id="today" type="text" value="${start_min}" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
							~
							<input name="startMax" id="today1" type="text" value="${start_max}" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
						</li>
					
						<li class="text">订单来源：</li>
						<li>
							<select name="isBrushSingle">
								<option value="">全部</option>
								<option value="1">淘宝</option>
								<option value="0">正常下单</option>	
							</select>
						</li>
					
							<li class="text" >店铺</li>
							<li><select id="myStoreId" name="myStoreId"> 
								<c:if test="${optMap_AY}"><option value="AY">爱游</option></c:if>
								<c:if test="${optMap_YM}"><option value="YM">怡美</option></c:if>
								<c:if test="${optMap_JY}"><option value="JY">景怡</option></c:if>
								<c:if test="${optMap_TX}"><option value="TX">天翔</option></c:if>
								<c:if test="${optMap_OUTSIDE}"><option value="OUTSIDE">出境店</option></c:if>
							</select></li>
						
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
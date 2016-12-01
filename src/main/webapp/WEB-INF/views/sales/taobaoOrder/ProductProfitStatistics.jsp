<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>产品利润统计</title>
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
				url: "<%=staticPath %>/taobao/ProductProfitStatistics_table.do",
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

		/* 导出到Excel */
		function excelProductProfit(){
			window.location = "excelProductProfit.do?startMin="+$("#startMin").val()
					+"&startMax="+$("#startMax").val()
					+"&productName="+$("#productName").val()
					+"&supplierName="+$("#supplierName").val()
					+"&orgIds="+$("#orgIds").val()
					+"&operatorIds="+$("#operatorIds").val()
					+"&orderMode="+$("#orderMode").val();
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
						<li class="text" style="">出团日期</li>
						<li>
							<input name="startMin" id="startMin" type="text" value="" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
					
						<li class="text" >产品名称</li>
						<li><input type="text" name="productName" id="productName"/></li>
						
							<li class="text" >平台来源</li>
						<li><input type="text" name="supplierName" id="supplierName"/></li>
						
						<li class="text">业务:</li><li>
						<select name="orderMode" id="orderMode">
								<option value="">请选择</option>
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}">${v.value}</option>
							</c:forEach>		
							</select>
						</li>
						
						<li class="text">部门:</li>
						<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" style="width: 205px;"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	</li>    				
						<li class="text">计调</li>
						<li >
	    				<input type="text" name="operatorName" id="operatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="operatorIds" id="operatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
							</li>
						<li class="text" style="width:35px;"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">搜索</button>
							<a href="javascript:void(0);"  target="_blank" onclick="excelProductProfit()" class="button button-primary button-small">导出到Excel</a>
						</li>
							<li class="clear"/>
					</ul>
				</div>
			</div>
		</form>
		<div id="tableDiv"></div>
	</div>

</body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</html>
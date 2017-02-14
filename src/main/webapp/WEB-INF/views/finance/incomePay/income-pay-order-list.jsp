<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>添加订单</title>
	<%@ include file="../../../include/top.jsp" %>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
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
			}

			setData();
		});
		
	</SCRIPT>
</head>
<body>
<div class="p_container">

		<form id="incomeOrderPayAddForm">
			<input type="hidden" name="page" id="page"/>
			<input type="hidden" name="pageSize" id="pageSize"/>

			<input type="hidden" name="supplierId" value="${reqpm.supplierId}"/>
			<input type="hidden" name="supType" value="${reqpm.supType}"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">
							<select name="dateType">
								<option value="groupDate">出团日期</option>
								<option value="orderDate">订单日期</option>
							</select>
						</li>
						<li>
							<input name="startMin" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							~
							<input name="startMax" id="startMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
						</li>
						<li class="text">团号：</li>
						<li><input type="text" name="groupCode"/></li>
						<c:if test="${reqpm.supType eq 1}">
							<li class="text">接站牌：</li>
						</c:if>
						<c:if test="${reqpm.supType ne 1}">
							<li class="text">订单号：</li>
						</c:if>
						<li><input type="text" name="orderNo"/></li>
					</ul>
					<ul>
						<li class="text">部门：</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" style="width: 185px;" 
							       readonly="readonly" onclick="showOrg()"/>
							<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden"/>
						</li>
						<li class="text">计调：</li>
						<li>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" 
							       readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden"/>
						</li>
						
						
						<li class="text">状态：</li>
						<li>
							<select name="payState" style="width: 80px;">
								<option value="unPaid">未下账</option>
								<option value="paid">已下账</option>
							</select>
						</li>
						<li class="text" style="width:40px;"></li>
					
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">查询
							</button>
						</li>
					</ul>
				</div>
			</div>
		</form>
		<div id="incomeOrderPayAddDiv"></div>
</div>
</body>
<script type="text/javascript">
function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	if (!pagesize || pagesize < 5) {
		pagesize = 5;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);

	var options = {
		url: "<%=staticPath %>/financePay/incomeOrderPayAddListTable.do",
		type: "post",
		dataType: "html",
		success: function (data) {
			$("#incomeOrderPayAddDiv").html(data);
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			alert("服务忙，请稍后再试");
		}
	}
	$("#incomeOrderPayAddForm").ajaxSubmit(options);
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function () {
	queryList();
});

function getSidAndAmountValue() {
	var dataObj = [];
	$('#tbOrderObj tr').each(function () {
		//获取选择的orderID
		var checkboxObj = $(this).find("input[type='checkbox']");
		//获取选择的order本次收款金额
		//var amount = $(this).find("input[name='itemTotalCash']");
		var itemAmounts = $(this).find("input[name='itemAmounts']"); //下账金额
		if (checkboxObj.is(':checked') || parseFloat(itemAmounts.val()) != 0) {
			var data = {};
			data.sid = checkboxObj.attr('sid');
			data.itemAmounts = itemAmounts.val();
			/* data.itemAmounts = itemAmounts.val(); */
			dataObj.push(data);
		}
	});
	return dataObj;
}
</script>
</html>
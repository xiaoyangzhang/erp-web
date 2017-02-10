<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>添加基础价</title>
	<%@ include file="../../../include/top.jsp" %>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
<div class="p_container">

		<form id="deliverySubjoinAddForm">
			<input type="hidden" name="page" id="page"/>
			<input type="hidden" name="pageSize" id="pageSize"/>
			<input type="hidden" name="supplierId" id="supplierId" value="${supplierId }"/>
			<input type="hidden" name="isShow" id="isShow" value="${isShow }"/>
			<input type="hidden" name="dateArrival" id="dateArrival" value="${dateArrival }"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">产品：</li>
						<li><input type="text" id="productName" name="productName" value="" /></li>
						
						<li class="text"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">查询
							</button>
						</li>
					</ul>
				</div>
			</div>
		</form>
		<div id="deliverySubjoinAddDiv"></div>
</div>
</body>
<script type="text/javascript">
function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	if (!pagesize || pagesize < 6) {
		pagesize = 6;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);
	
	var productName_id= $("#productName_id").val();
	var supplierId= $("#supplierId").val();
	var isShow= $("#isShow").val();
	var dateArrival= $("#dateArrival").val();
	var options = {
		url: "../booking/deliverySubJoinPriceAddTable.do",
		type: "post",
		dataType: "html",
		date:{productName:productName_id,supplierId:supplierId,isShow:isShow,dateArrival:dateArrival},
		success: function (data) {
			$("#deliverySubjoinAddDiv").html(data);
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			alert("服务忙，请稍后再试");
		}
	}
	$("#deliverySubjoinAddForm").ajaxSubmit(options);
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function () {
	queryList();
});

/* 获取选中的信息方法 */
function getChBoxJoinID() {
	var dataBaseObj = [];

	$('#tb_sup_contract_price_join tr').each(function () {
		//获取选择的ID
		var checkboxObj = $(this).find("input[type='checkbox']");
		var numPerson = $(this).find("input[name='numPerson']");//人数（数量）
		var itemTypeName = $(this).find("input[name='itemTypeName']");//项目
		var contractPrice = $(this).find("input[name='contractPrice']");//结算价
		
		var contractSale = $(this).find("input[name='contractSale']");//采购价   
		var note = $(this).find("input[name='note']");//备注
		/* if (checkboxObj.is(':checked')) { */
		if(numPerson.val() !=null && numPerson.val()!=''){
			var data = {};
			data.pid = checkboxObj.attr('value');
			data.itemTypeName = itemTypeName.val();//项目
			data.note = note.val();//备注
			data.contractPrice = contractPrice.val();//结算价
			data.contractSale = contractSale.val();//采购价
			data.numPerson = numPerson.val();//数量--人数
			dataBaseObj.push(data);
		}
	});
	return dataBaseObj;
}


</script>
</html>
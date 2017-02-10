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

		<form id="deliveryBaseAddForm">
			<input type="hidden" name="page" id="page"/>
			<input type="hidden" name="pageSize" id="pageSize"/>
			<input type="hidden" name="supplierId" id="supplierId" value="${supplierId }"/>
			<input type="hidden" name="isShow" id="isShow" value="${isShow }"/>
			<input type="hidden" name="dateArrival" id="dateArrival" value="${dateArrival }"/>
			
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						
						<li class="text">项目：</li>
						<li>
							<select name="itemType" id="itemType_id">
								<option value="" selected="selected">全部</option>
	            				<c:forEach items="${typeList}" var="v" varStatus="vs">
	            					<option value="${v.id}">${v.value}</option>
	            				</c:forEach>
	            			</select>
	            		</li>
						
						<li class="text">产品：</li>
						<li><input type="text" id="productName_id" name="productName" value="" /></li>
						
						<li class="text"></li>
						<li>
							<button type="button" class="button button-primary button-small" onclick="searchBtn()">查询
							</button>
						</li>
					</ul>
				</div>
			</div>
		</form>
		<div id="deliveryBaseAddDiv"></div>
</div>
</body>
<script type="text/javascript">
function queryList(page, pagesize) {
	if (!page || page < 1) {
		page = 1;
	}
	if (!pagesize || pagesize < 8) {
		pagesize = 8;
	}
	$("#page").val(page);
	$("#pageSize").val(pagesize);
	
	var itemType_id= $("#itemType_id").val();
	var productName_id= $("#productName_id").val();
	var supplierId= $("#supplierId").val();
	var isShow= $("#isShow").val();
	var dateArrival= $("#dateArrival").val();
	var options = {
		url: "../booking/deliveryBasePriceAddTable.do",
		type: "post",
		dataType: "html",
		date:{itemType:itemType_id,productName:productName_id,supplierId:supplierId,isShow:isShow,dateArrival:dateArrival},
		success: function (data) {
			$("#deliveryBaseAddDiv").html(data);
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) {
			alert("服务忙，请稍后再试");
		}
	}
	$("#deliveryBaseAddForm").ajaxSubmit(options);
}

function searchBtn() {
	queryList(1, $("#pageSize").val());
}

$(function () {
	queryList();
});

/* 获取选中的信息方法 */
function getChBoxBaseID() {
	var dataBaseObj = [];

	$('#tb_sup_contract_price tr').each(function () {
		//获取选择的ID
		var checkboxObj = $(this).find("input[type='checkbox']");
		var numPerson = $(this).find("input[name='numPerson']");//人数（数量）
		var itemTypeName = $(this).find("input[name='itemTypeName']");//项目
		var price = $(this).find("input[name='price']");//结算价
		var salePrice = $(this).find("input[name='salePrice']");//采购价   
		var note = $(this).find("input[name='note']");//备注
		/* if (checkboxObj.is(':checked')) { */
		if(numPerson.val() !=null && numPerson.val()!=''){
			var data = {};
			data.pid = checkboxObj.attr('value');
			data.itemTypeName = itemTypeName.val();//项目
			data.note = note.val();//备注
			data.price = price.val();//结算价
			data.salePrice = salePrice.val();//采购价 
			data.numPerson = numPerson.val();//数量--人数
			dataBaseObj.push(data);
		 }
	});
	return dataBaseObj;
}

</script>
</html>
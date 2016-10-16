<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>佣金列表</title>
	<%@ include file="../../../include/path.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>
<div id="printDiv">
	<div>
		<form>
			<input id="groupId" value="${reqpm.groupId}" type="hidden" />
			<table id="commissionTable" cellspacing="0" cellpadding="0" class="w_table">
				
				<c:if test="${reqpm.isShow eq true }">
					<col width="10%" />
					<col width="25%" />
					<col width="25%" />
					<col width="20%" />
					<col width="20%" />
				</c:if>
				<c:if test="${reqpm.isShow ne true }">
					<col width="3%" />
					<col width="25%" />
					<col width="20%" />
					<col width="10%" />
					<col width="10%" />
					<col width="11%" />
					<col width="11%" />
					<col width="10%" />
				</c:if>
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>导游<i class="w_table_split"></i></th>
						<th>项目<i class="w_table_split"></i></th>
						<th>类型<i class="w_table_split"></i></th>
						<th>金额<i class="w_table_split"></i></th>
						<c:if test="${reqpm.isShow ne true }">
							<th>已收<i class="w_table_split"></i></th>
							<th>未收<i class="w_table_split"></i></th>
							<th><input type="checkbox" onclick="checkAllCommission(this)" />全选</th>
						</c:if>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${comList}" var="com" varStatus="status">
					<tr>
						<td class="serialnum">${status.index+1}</td>
						<td> ${com.guideName }</td>
						<td>
							<c:forEach items="${dicInfoList}" var="dicInfo">
								<c:if test="${dicInfo.code eq com.commissionType}">${dicInfo.value }</c:if>
							</c:forEach>
						</td>
						<td>
							<c:if test="${com.total > 0}">发放</c:if>
							<c:if test="${com.total <= 0}">扣除</c:if>
						</td>
						<td>
							<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
							<fmt:formatNumber value="${total}" pattern="#.##"/>
						</td>
						<c:if test="${reqpm.isShow ne true }">
							<td>
								<c:set var="totalCash" value="${fn:replace(com.totalCash,'-', '')}" />
								<fmt:formatNumber value="${totalCash }" pattern="#.##"/>
							</td>
							<td>
								<fmt:formatNumber value="${total - totalCash }" pattern="#.##"/>
							</td>
							<td><input type="checkbox" name="commission_id" value="${com.id}" ${com.stateFinance eq 1 ? 'checked' : ''} />审核</td>
							<c:set var="sum_cashTotal" value="${sum_cashTotal + com.totalCash }" />
						</c:if>
						<c:set var="sum_total" value="${sum_total + com.total }" />
					</c:forEach>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>合计:</td>
						<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
						<c:if test="${reqpm.isShow ne true }">
							<td><fmt:formatNumber value="${sum_cashTotal }" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${sum_total-sum_cashTotal }" pattern="#.##"/></td>
							<td></td>
						</c:if>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

var guideList = [];
(function(){
	<c:forEach items="${guideList}" var="item" varStatus="status">
		var guide = {};
		guide.id = "${item.guideId }";
		guide.name = "${item.guideName }";
		guideList.push(guide);
	</c:forEach>
})();

function getGuideName(guideId){
	if(!guideId){
		return "";
	}
	
	for(var i = 0; i < guideList.length; i++){
		var item = guideList[i]; 
		if(item.id == guideId){
			return item.name;
		}
	}
	return "";
}

function verifyCommissionList(){
	
	var flag = true;
	var trArr = $("#commissionTable tbody tr");
	if(!trArr){
		return flag;
	}
	
	for(var i = 0; i < trArr.length; i++){
		
		var inputs = $(trArr[i]).find("input,select");
		for(var j = 0; j < inputs.length; j++){
			var item = inputs[j];
			if($(item).attr("name") == "remark"){
				continue;
			}
			
			if($(item).val()){
				$(item).css("border-color", "#e7eff1");
				
				var reg = /^[1-9]+[0-9]*]*$/;
				if($(item).attr("total") == "num" && !reg.test($(item).val())){
					$(item).css("border-color", "red");
					flag = false;		
				}
			}else{
				$(item).css("border-color", "red");
				flag = false;	
			}
		}
	}
	
	return flag;
}

function getCommissionList(){
	
	var data = [];
	$("#commissionTable tbody tr").each(function(){

		var obj = [];
		var inputs = $(this).find("input,select");
		for(var i = 0; i < inputs.length; i++){
			var item = inputs[i];
			var itemName = $(item).attr("name");
			var itemVal = $(item).val();
			obj.push('\"'+ itemName +'\":\"'+ itemVal +'\"');
			if(itemName == "guideId"){
				obj.push('\"guideName\":\"'+ getGuideName(itemVal) +'\"');
			}
		}
		data.push("{"+obj.join(",")+ ", groupId:${reqpm.groupId}}");
	});
	
	var content = '['+ data.join(",") + ']';
	return content;
}

function submitCommissionList(index){
	
	var verifyRet = verifyCommissionList();
	if(!verifyRet){
		return;
	}
	
	var content = getCommissionList();
	var data = {};
	data.groupId = $("#groupId").val();
	data.content = content;
	$.post("<%=staticPath%>/finance/guide/saveCommission.do", data, function(data){
// 		alert(data.msg);
		if(data.success){	
			//关闭对话框
			$.success(data.msg);
			location.reload()
   		}else{
   			$.error(data.msg);
   		}
	}, "json");	
}


$(function() {

});


</script>
</html>
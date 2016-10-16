<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>
<div id="printDiv">
<!--startprint1-->
	<div class="p_container" >
		<form id="queryForm">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
	
			<div class="p_container_sub" >
		    	<div class="searchRow" style="padding:25px;text-align:right;">
		    	<c:if test="${reqpm.isPrint ne true}">
		    		<button type="button" onclick="addRow()" class="button button-primary button-rounded button-small">新增</button>
		    	</c:if>
		    	</div>
	        </div>
		</form>		
	</div>
	<div>
		<form>
			<input id="groupId" value="${reqpm.groupId}" type="hidden" />
			<table id="commissionTable" cellspacing="0" cellpadding="0" class="w_table">
				<col width="5%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
				<col width="10%" />
				<col width="15%" />
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>导游<i class="w_table_split"></i></th>
						<th>项目<i class="w_table_split"></i></th>
						<th>类型<i class="w_table_split"></i></th>
						<th>金额<i class="w_table_split"></i></th>
						<th>状态<i class="w_table_split"></i></th>
						<th>操作<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
				<c:set var="aa" value="0"></c:set>
					<c:forEach items="${comList}" var="com" varStatus="status">
					<c:set var="aa" value="${aa +1 }"></c:set>
					<c:set var="paid" value="false"></c:set>
					<c:set var="stateFinance" value="false"></c:set>
					<c:set var="disabledCss" value=""></c:set>
					<c:set var="inputDisabled" value=""></c:set>
					<c:if test="${not empty com.total}">	
						<c:if test="${com.total.compareTo(com.totalCash) eq 0 or com.stateFinance eq 1}">
							<c:if test="${com.total.compareTo(com.totalCash) eq 0}">
								<c:set var="paid" value="true"></c:set>
							</c:if>
							<c:if test="${com.stateFinance eq 1}">
								<c:set var="stateFinance" value="true"></c:set>
							</c:if>
							<c:set var="disabledCss" value="bgcolor='#E3E3E3'"></c:set>
							<c:set var="inputDisabled" value="disabled='disabled'"></c:set>		
						</c:if>
					</c:if>
					
					<tr>
						<td class="serialnum" ${disabledCss }>${status.index+1}</td>
						<td ${disabledCss }>
							<select id="guideId" name="guideId" style="width:98%" ${inputDisabled }>
								<c:forEach items="${guideList}" var="guide" >
									<option value="${guide.guideId }" 
										<c:if test="${com.guideId eq guide.guideId}">selected="selected"</c:if>
									>${guide.guideName }</option>
								</c:forEach>
							</select>
						</td>
						<td ${disabledCss }>
							<select id="commissionType" name="commissionType" style="width:98%" ${inputDisabled }>
								<option value="">请选择</option>
								
								<c:forEach items="${dicInfoList}" var="dicInfo">
								<option value="${dicInfo.code }" 
									<c:if test="${dicInfo.code eq com.commissionType}">selected="selected"</c:if>
								>${dicInfo.value }</option>
								</c:forEach>
							</select>
						</td>
						<td ${disabledCss }>
							<input type="radio" name="cashType${status.index}" value="扣除" ${inputDisabled } checked="checked" >扣除</input>
						</td>
						<td ${disabledCss }>
							<c:set var="total" value="${fn:replace(com.total,'-', '')}" />
							<input type="text" name="total" style="width:95%" ${inputDisabled } value="<fmt:formatNumber value="${total}" pattern="#.##"/>" />
						</td>
						<td ${disabledCss }>
							<c:if test="${paid eq false}">未结算</c:if>
							<c:if test="${paid eq true}">已结算</c:if>
						</td>
						<td ${disabledCss }>
							<c:if test="${paid eq false and stateFinance eq false}">
								<a class="button button-rounded button-tinier" onclick="delRow(this)">删除</a>
							</c:if>
						</td>
					</tr>
					<c:set var="sum_total" value="${sum_total+com.total }" />
					</c:forEach>
				</tbody>
			</table>
			
			<table  cellspacing="0" cellpadding="0" class="w_table">
				<col width="5%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
				<col width="10%" />
				<col width="15%" />
				<tbody>
					<tr>
						<td colspan="4">合计：</td>
						<td><fmt:formatNumber value="${sum_total}" pattern="#.##" type="currency"/></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<!--endprint1-->
	<div style="text-align: center;margin-top:40px;">
		<a id="btn_audit" onclick="submitCommissionList()" class="button button-primary button-small">确定</a>&nbsp;&nbsp;&nbsp;
<%-- 		<a href="<%=staticPath %>/finance/guide/addCommission.htm?groupId=${reqpm.groupId}&isPrint=true" target="_blank"  class="button button-primary button-small">打印</a>&nbsp;&nbsp;&nbsp;	
 --%>		<a class="button button-primary button-small" href="javascript:void(0)" onclick="newWindow('打印','<%=staticPath %>/finance/guide/addCommission2.htm?groupId=${reqpm.groupId }')">打印预览</a>&nbsp;&nbsp;&nbsp;
		
		<a onclick="closeWindow()" class="button button-primary button-small">关闭</a>
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

var commissionTypeList = [];
(function(){
	<c:forEach items="${dicInfoList}" var="dicInfo">
		var comm = {};
		comm.code = "${dicInfo.code }";
		comm.value = "${dicInfo.value }";
		commissionTypeList.push(comm);
	</c:forEach>
})();

function getCommissionName(type){
	if(!type){
		return "";
	}
	
	for(var i = 0; i < commissionTypeList.length; i++){
		var item = commissionTypeList[i];
		if(item.code == type){
			return item.value;
		}
	}
	return "";
}

function getRowHtml(index){
	var arr = [];
	arr.push('<tr>');
		arr.push('<td class="serialnum">');
			arr.push('<div class="serialnum_btn"></div>' + parseInt(index+1));
		arr.push('</td>');
		
		arr.push('<td>');
			arr.push('<select id="guideId" name="guideId" style="width:98%" >');
		for(var i = 0; i < guideList.length; i++){
				var item = guideList[i];
				arr.push('<option value="'+ item.id +'">'+ item.name +'</option>');
		}
			arr.push('</select>');
		arr.push('</td>');	
		arr.push('<td>');
			arr.push('<select id="commissionType" name="commissionType" style="width:98%" >');
				arr.push('<option value="">请选择</option>');
				<c:forEach items="${dicInfoList}" var="dicInfo">
					arr.push('<option value="${dicInfo.code }" >${dicInfo.value }</option>');
				</c:forEach>
			arr.push('</select>');
		arr.push('</td>');
		arr.push('<td>');
			arr.push('<input type="radio"  name="cashType'+index+'" value="扣除" checked="checked">扣除</input>');
		arr.push('</td>');
		arr.push('<td><input type="text" name="total" style="width:95%" /></td>');
		arr.push('<td></td>');
		arr.push('<td><a class="button button-rounded button-tinier" onclick="delRow(this);">删除</a></td>');
	arr.push('</tr>');
	return arr.join("");
}

function addRow(){
	var trArr = $("#commissionTable tbody tr");
	var serialNum = trArr.length;
	
	var trHtml = getRowHtml(serialNum);
	if(serialNum == 0){
		$("#commissionTable tbody").html(trHtml);	
	}else{
		$("#commissionTable tbody tr").last().after(trHtml);
	}
}

function delRow(obj){
	$(obj).parent().parent().remove();

	var index = 1;
	$("#commissionTable tbody tr").each(function(){
		var firstTd = $(this).children(":first");
		firstTd.html('<div class="serialnum_btn" ></div>' + index);
		index ++;
	});
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
	$("#commissionTable tbody tr").each(function(index){
		var obj = [];
		var inputs = $(this).find("input,select");
		for(var i = 0; i < inputs.length; i++){
			var item = inputs[i];
			if($(item).attr("disabled")){
				continue;
			}
			
			var yiType = $(item).attr("type");
			if(yiType=="radio"){
				if($(item).attr("checked")){
					var itemName = "cashType";
					var itemVal = $(item).val();
					obj.push('\"'+ itemName +'\":\"'+ itemVal +'\"');
					if(itemName == "guideId"){
						obj.push('\"guideName\":\"'+ getGuideName(itemVal) +'\"');
					}else if(itemName == "commissionType"){
						obj.push('\"commissionName\":\"'+ getCommissionName(itemVal) +'\"');
					}
				}
			}else{
				var itemName = $(item).attr("name");
				var itemVal = $(item).val();
				obj.push('\"'+ itemName +'\":\"'+ itemVal +'\"');
				if(itemName == "guideId"){
					obj.push('\"guideName\":\"'+ getGuideName(itemVal) +'\"');
				}else if(itemName == "commissionType"){
					obj.push('\"commissionName\":\"'+ getCommissionName(itemVal) +'\"');
				}
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
	$.post("<%=staticPath%>/finance/guide/saveCommissionDeduction.do", data, function(data){
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
	if(${comList.size()} == 0){
		var trHtml = getRowHtml(0);
		$("#commissionTable tbody").html(trHtml);	
	}
});

(function(){
	var isPrint = "${reqpm.isPrint}";
	if(isPrint){
		var oper=1;
		bdhtml=window.document.body.innerHTML;//获取当前页的html代码
		sprnstr="<!--startprint"+oper+"-->";//设置打印开始区域
		eprnstr="<!--endprint"+oper+"-->";//设置打印结束区域
		prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)+18); //从开始代码向后取html
		
		prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html
		window.document.body.innerHTML=prnhtml;
		window.print(); 
	}
	
})();


</script>
</html>
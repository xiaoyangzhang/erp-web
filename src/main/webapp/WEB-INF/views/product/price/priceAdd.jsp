<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>领单申请</title>
	<%@ include file="../../../include/top.jsp"%>
	<style type="text/css">
	 .black_tab thead tr th{border:1px solid #000;background:none;}
	  .black_tab tbody tr td{border:1px solid #000;}
	</style>
</head>
<body>
<div id="printDiv">
<!--startprint1-->	
	<div class="p_container" >
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
	
			<div class="p_container_sub" align="left">
		    	<div class="searchRow" style="padding:2 5px;text-align:right;">
		    		<button type="button" onclick="addRow();" class="button button-primary button-rounded button-small">新增</button>
		    	</div>
	        </div>
	</div>
		<div id="guideDiv">
		<form>
			<input id="groupId" value="${reqpm.groupId}" type="hidden" />
			<table id="applyTable" cellspacing="0" cellpadding="0"  class="w_table" >
				<col width="5%" />
				<col width="20%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<thead>
					<tr>
						<th rowspan="2">序号<i class="w_table_split"></i></th>
						<th rowspan="2">日期段<i class="w_table_split"></i></th>
						<th colspan="2">市场价<i class="w_table_split"></i></th>
						<th colspan="2">结算价<i class="w_table_split"></i></th>
						<th colspan="2">成本价<i class="w_table_split"></i></th>
						<th rowspan="2">操作<i class="w_table_split"></i></th>
					</tr>
					<tr>
						<th>成人<i class="w_table_split"></i></th>
						<th>儿童<i class="w_table_split"></i></th>
						<th>成人<i class="w_table_split"></i></th>
						<th>儿童<i class="w_table_split"></i></th>
						<th>成人<i class="w_table_split"></i></th>
						<th>儿童<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${productGroupPrices}" var="item" varStatus="status">
						
						<tr>
							<td class="serialnum">
								<div class="serialnum_btn"></div> ${status.index+1}
							</td>
							<td>
								<input type="hidden" name="id" notids="${item.id }"  tag="priceId" value="${item.id }"  />
			                  	<input type="text" readonly="readonly" name="groupDate" tag="groupDate"  value="<fmt:formatDate value="${item.groupDate }" pattern="yyyy-MM-dd" />" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
			                  	 ~ <input type="text" name="groupDateTo" tag="groupDateTo" readonly="readonly" value="<fmt:formatDate value="${item.groupDateTo }" pattern="yyyy-MM-dd" />" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							</td>
							<td><input type="text" id="price_suggest_adult" name="price_suggest_adult" value="${item.priceSuggestAdult}"/></td>
							<td><input type="text" id="price_suggest_child" name="price_suggest_child" value="${item.priceSuggestChild}"/></td>
							<td><input type="text" id="price_settlement_adult" name="price_settlement_adult" value="${item.priceSettlementAdult}"/></td>
							<td><input type="text" id="price_settlement_child" name="price_settlement_child" value="${item.priceSettlementChild}"/></td>
							<td><input type="text" id="price_cost_adult" name="price_cost_adult" value="${item.priceCostAdult}"/></td>
							<td><input type="text" id="price_cost_child" name="price_cost_child" value="${item.priceCostChild}"/></td>
							<td><a class="button button-rounded button-tinier" onclick="delRow(this);">删除</a></td>
						</tr>
					</c:forEach>
					
				</tbody>
			</table>
		</form>
		</div>
		<div class="dan_btn mt-30" align="center">
			
			<a  onclick="submitApplyList();" class="button  button-primary button-small mr-20" >提交</a>
			<a href="javascript:closeWindow()" class="button button-rounded button-action button-small">取消</a>
		</div>
		<!--endprint1-->
</div>
</body>
<script type="text/javascript">

function getRowHtml(index){
	var arr = [];
	arr.push('<tr>');
		arr.push('<td class="serialnum">');
			arr.push('<div class="serialnum_btn"></div>' + parseInt(index+1));
		arr.push('</td>');
		arr.push('<td>');
		arr.push('<input type="text" readonly="readonly" name="groupDate" tag="groupDate"   class="Wdate" onClick="WdatePicker({dateFmt:\'yyyy-MM-dd\'})"/>');
		arr.push(' ~ <input type="text" name="groupDateTo" tag="groupDateTo" readonly="readonly"   class="Wdate" onClick="WdatePicker({dateFmt:\'yyyy-MM-dd\'})"/>');
		arr.push('</td>');
		arr.push('<td><input type="text" id="price_suggest_adult" name="price_suggest_adult" value="${item.price_suggest_adult}"/></td>');
		arr.push('<td><input type="text" id="price_suggest_child" name="price_suggest_child" value="${item.price_suggest_child}"/></td>');
		arr.push('<td><input type="text" id="price_settlement_adult" name="price_settlement_adult" value="${item.price_settlement_adult}"/></td>');
		arr.push('<td><input type="text" id="price_settlement_child" name="price_settlement_child" value="${item.price_settlement_child}"/></td>');
		arr.push('<td><input type="text" id="price_cost_adult" name="price_cost_adult" value="${item.price_cost_adult}"/></td>');
		arr.push('<td><input type="text" id="price_cost_child" name="price_cost_child" value="${item.price_cost_child}"/></td>');
		arr.push('<td><a class="button button-rounded button-tinier" onclick="delRow(this);">删除</a></td>');
	arr.push('</tr>');
	return arr.join("");
}

function addRow(){
	var trArr = $("#applyTable tbody tr");
	var serialNum = trArr.length;
	
	var trHtml = getRowHtml(serialNum);
	if(serialNum == 0){
		$("#applyTable tbody").html(trHtml);	
	}else{
		$("#applyTable tbody tr").last().after(trHtml);
	}
}

function delRow(obj){
	$(obj).parent().parent().remove();

	var index = 1;
	$("#applyTable tbody tr").each(function(){
		var firstTd = $(this).children(":first");
		firstTd.html('<div class="serialnum_btn" ></div>' + index);
		index ++;
	});
}

function verifyApplyList(){
	
	var flag = true;
	var trArr = $("#applyTable tbody tr");
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
				if($(item).attr("name") == "num" && !reg.test($(item).val())){
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

function getApplyList(){
	
	var data = [];
	var notIds = [];
	$("#applyTable tbody tr").each(function(){

		var obj = [];
		var inputs = $(this).find("input,select");
		for(var i = 0; i < inputs.length; i++){
			var item = inputs[i];
			var id = $(item).attr("notids");
			if(id){
				notIds.push(id);	
			}
			
			obj.push('\"'+ $(item).attr("name") +'\":\"'+ $(item).val()+'\"');
		}
		data.push("{"+obj.join(",")+"}");
		
	});
	var content = '{"groupId":"'+ $("#groupId").val() +'","notIds":"'+ notIds.join(",") +'", "list":['+ data.join(",") + ']}';
	return content;
}

$(function() {
	var isAdd = "${reqpm.isAdd}";
	if(isAdd == "true"){
		var trHtml = getRowHtml(0);
		$("#applyTable tbody").html(trHtml);	
	}
});

function submitApplyList(){
	
	var verifyRet = verifyApplyList();
	console.log(verifyRet);
	 if(!verifyRet){
		return;
	}
	
	var content = getApplyList();
	console.log(content);
	$.post("<%=staticPath%>/productInfo/price/savePriceGroup.do", {"json":content}, function(data){
		if(data.success){	
			$.info("添加成功！");
			location.reload();
   		}else{
   			$.info(data.msg);
   		}
	}, "json");	
}

</script>
</html>
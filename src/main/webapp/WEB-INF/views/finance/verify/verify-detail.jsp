<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>对账单</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>
	<div class="p_container">
	<input type="hidden" name="supplierType" id="supplierType"  value="${verify.supplierType}" />
	<div class="p_container_sub">
		<div class="searchRow">
			<ul>
				<c:if test="${verify.supplierType eq 1 }">
					<li class="text">组团社:</li>
				</c:if>
				<c:if test="${verify.supplierType eq 16 }">
					<li class="text">地接社:</li>
				</c:if>
				<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
					<li class="text">商家:</li>
				</c:if>
				<li class="text" style="width:200px;text-align:left;">${verify.supplierName}</li>
				<li class="text">账期:</li>
				<li class="text" style="width:400px;text-align:left;">
					<fmt:formatDate pattern='yyyy/MM/dd' value='${verify.dateStart}' />
					~
					<fmt:formatDate pattern='yyyy/MM/dd' value='${verify.dateEnd}' />
				</li>
			</ul>
		</div>
	</div>
	<div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<c:if test="${verify.supplierType eq 1 }">
				<col width="3%" />
				<col width="14%" />
			
				<col width="11%" />
				<col width="7%" />
				<col width="3%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="3%" />
				<col width="3%" />
				<col width="3%" />
				<col width="5%" />
				<col width="5%" />
				<col width="10%" />
				<col width="5%" />
			</c:if>
			<c:if test="${verify.supplierType eq 16}">
				<col width="3%" />
				<col width="14%" />
				
				<col width="13%" />
				<col width="3%" />
				
				<col width="6%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="13%" />
				<col width="5%" />
			</c:if>
			<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
				<col width="3%" />
				<col width="16%" />
				
				<col width="10%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="13%" />
				<col width="5%" />
			</c:if>
			<thead>
				<th>序号<i class="w_table_split"></i></th>
				<th>产品<i class="w_table_split"></i></th>
				
				<c:if test="${verify.supplierType eq 1 }">
					<th>团号<i class="w_table_split"></i></th>
					<th>接站牌<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
				</c:if>
				<c:if test="${verify.supplierType eq 16 }">
					<th>团号<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
				</c:if>
				<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
					<th>团号<i class="w_table_split"></i></th>
				</c:if>
				
				<th>日期<i class="w_table_split"></i></th>
				<th>计调<i class="w_table_split"></i></th>
				<th>明细<i class="w_table_split"></i></th>
				<th>金额<i class="w_table_split"></i></th>
				<th>已结算<i class="w_table_split"></i></th>
				<th>未结算<i class="w_table_split"></i></th>
				<th>调账<i class="w_table_split"></i></th>
				<th>实付<i class="w_table_split"></i></th>
				<th>备注<i class="w_table_split"></i></th>
				<th>操作<i class="w_table_split"></i></th>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<div id="tableDiv"></div>
	<div id="tableDivTemp"></div>
	<div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<c:if test="${verify.supplierType eq 1 }">
				<col width="3%" />
				<col width="14%" />
			
				<col width="11%" />
				<col width="7%" />
				<col width="3%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="3%" />
				<col width="3%" />
				<col width="3%" />
				<col width="5%" />
				<col width="5%" />
				<col width="10%" />
				<col width="5%" />
			</c:if>
			<c:if test="${verify.supplierType eq 16}">
				<col width="3%" />
				<col width="14%" />
				
				<col width="13%" />
				<col width="3%" />
				
				<col width="6%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="13%" />
				<col width="5%" />
			</c:if>
			<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
				<col width="3%" />
				<col width="16%" />
				
				<col width="10%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="13%" />
				<col width="5%" />
			</c:if>
			<thead>
			</thead>
			<tbody>
				<tr>
					<td></td>
					<td></td>
					
					<c:if test="${verify.supplierType eq 1 }">
						<td></td>
						<td></td>
						<td></td>
					</c:if>
					<c:if test="${verify.supplierType eq 16 }">
						<td></td>
						<td></td>
					</c:if>
					<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
						<td></td>
					</c:if>
					
					<td></td>
					<td></td>
					<td colspan="1" style="text-align: center;">合计：</td>
				    <td id="totalPrice"><fmt:formatNumber value="${total_price}" type="currency" pattern="#.##"/></td>
		         	<td id="totalCash"><fmt:formatNumber value="${total_cash}" type="currency" pattern="#.##"/></td>
					<td id="totalNot"><fmt:formatNumber value="${total_not}" type="currency" pattern="#.##"/></td>
					<td id="totalAdjust"><fmt:formatNumber value="${total_adjust}" type="currency" pattern="#.##"/></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div style="padding-top:10px;">
		<input type="button"  onclick="addVerifyDetail()" class="button button-primary button-small" value="添加订单">
	</div>
	<div style="padding-top:100px;text-align:center;">
		<input type="button"  onclick="updateVerifyDetail()" class="button button-primary button-small" value="确定">&nbsp;&nbsp;&nbsp;
		<input type="button"  onclick="closeWindow()" class="button button-primary button-small" value="关闭">&nbsp;&nbsp;&nbsp;
		<input type="button"  onclick="print()" class="button button-primary button-small" value="打印">
	</div>
	<div id="addVerifyDetailDiv"></div>
	<div id="popDiv" style="display: none" class="searchRow">
		<div id="popTableDiv"></div>
	</div>
</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

	detailData = {};
	function collectData(exceptId){
		$("tbody tr").each(function(){
			var orderId = $(this).find("input[name='orderId']").val();
			if(orderId && orderId != exceptId ){
				var totalAdjust = $(this).find("input[name='totalAdjust']").val();
				var remark = $(this).find("textarea[name='remark']").val();
				detailData[orderId] = {"totalAdjust": totalAdjust, "remark":remark};
			}
		});
	}
	
	function reSetData(){
		$("tbody tr").each(function(){
			var orderId = $(this).find("input[name='orderId']").val();
			if(orderId){
				var obj = detailData[orderId];
				if(obj){
					$(this).find("input[name='totalAdjust']").val(obj["totalAdjust"] ? obj["totalAdjust"] : 0);	
					$(this).find("textarea[name='remark']").val(obj["remark"]);
				}
			}
		});
	}
	
	function addVerifyDetail() {
		
		collectData();
		
		var verifyId = "${verify.id}";
		var supplierType = "${verify.supplierType}";
		var supplierName = "${verify.supplierName}";
		var url ="addVerifyDetail.htm?verifyId="+ verifyId +"&supplierType="+ supplierType +"&supplierName="+ supplierName; 
		layer.open({
		    type: 2,
		    title : '添加订单',
		    area: ["1000px", "530px"],
		    content:url
		});
	}
	
	function updateVerifyDetail(){
		
		var flag = true;
		var reg = /^[-+]?[0-9]+(\.[0-9]+)?$/;
		
		var records = [];
		$("tbody tr").each(function(){
			var record = [];
			$(this).find("input,textarea").each(function(){
				var name = $(this).attr("name");
				var value = $(this).val();
				if(name == "totalAdjust" && (!value || !reg.test(value))){
					flag = false;
					$(this).css("border-color", "red");
				}else{
					$(this).css("border-color", "");
				}
				
				record.push("\""+ name +"\":\""+ value +"\"");
			});
			records.push("{"+ record.join(",") +"}");
		});
		
		if(!flag){
			return;
		}
		
		var data = {};
		data.verifyId = "${verify.id}";
		data.supplierType = "${verify.supplierType}";
		
		records.pop();
		data.records = "["+ records.join(",") +"]";
		YM.post("updateVerifyDetail.do", data, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success(data.msg);
				location.reload();
			}else{
				$.error("服务忙，请稍后再试");
			}
		});
	}
	
	function totalDetail(bookingId) {
		var supId=$("#supplierType").val();
		 if(!bookingId){
			return;
		}
		
		var data = {};
		data.supplierType = supId;
		data.bookingId = bookingId;
		data.mode = 0;
		data.sl = "fin.selectAmountDetailOrderListPage";
		data.rp = "finance/verify/amountDetailListTable";
		$("#popTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '金额详细信息',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDiv"),
			btn : [ '确定', '取消' ],
			yes : function(index) {

				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		}); 
	}
	
	function loadJoinedTableExist(){
		
		var data = {};
		data.verifyId = ${verify.id};
		$("#tableDiv").load("queyrVerifyDetail.do", data, callBack);
	}
	
	var idArrTemp = [];
	function loadJoinedTableTemp(ids){
		
		if(ids){
			for(var i = 0; i < ids.length; i++){
				var item = ids[i];
				if(!isContain(idArrTemp, item)){
					idArrTemp.push(item);
				}
			}
		}
		if(idArrTemp.length == 0){
			return 
		}
		
		var data = {};
		data.ids = idArrTemp.join(",");
		data.page = 1;
		data.pageSize = 50;
		data.supplierType = $("#supplierType").val();
		$("#tableDivTemp").load("queyrVerifyDetailTemp.do", data, callBack);
	}
	
	function isContain(arr, item){
		
		if(!arr){
			return false;
		}
		
		for(var i = 0; i < arr.length; i++){
			if(item == arr[i]){
				return true;
			}
		}
		return false;
	}
	
	function callBack(){
		
		refreshSerialnum();
		sumOrders();
		reSetData();
	}
	
	// 移除明细
	function removeDetail(oid){
		idArrTemp.splice($.inArray(oid, idArrTemp),1);
		if(idArrTemp.length==0){
			$("#tableDivTemp").empty();
			return;
		}
		collectData(oid);
		loadJoinedTableTemp(idArrTemp);
	}
	
	//删除数据库详情
	function deleteDetail(verifyId,detailId,total,totalCash,totalAdjust,bookingId){
		
		collectData(bookingId);
		
		var data = {};
		data.verifyId = verifyId;
		data.detailId = detailId;
		data.total = total;
		data.totalCash = totalCash;
		data.totalAdjust = totalAdjust;
		
		YM.post("deleteVerifyDetail.do", data, function(data){
			
			loadJoinedTableExist();
			loadJoinedTableTemp();
		});
	}
	
	function refreshSerialnum(){
		var i = 1;
		$("label[name='serialnum']").each(function(){
			$(this).html(i);
			i++;
		});
	}
	
	function sumOrders(){
		var totalPrice = 0;
		$("input[name='total']").each(function(){
			totalPrice += parseFloat($(this).val());
		});
		$("#totalPrice").text(totalPrice);
		
		var totalCash = 0;
		$("input[name='totalCash']").each(function(){
			totalCash += parseFloat($(this).val());
		});
		$("#totalCash").text(totalCash);
		
		var totalNot = 0;
		$("input[name='totalNot']").each(function(){
			totalNot += parseFloat($(this).val());
		});
		$("#totalNot").text(totalNot);
		
		sumAdjust();
	}
	
	function sumAdjust(){
		var totalAdjust = 0;
		$("input[name='totalAdjust']").each(function(){
			if(!isNaN($(this).val())){
				totalAdjust += parseFloat($(this).val());	
			}
			
			cacuTotalFact(this);
		});
		
		if((totalAdjust+"").indexOf(".") > -1){
			$("#totalAdjust").text(totalAdjust.toFixed(2));
		}else{
			$("#totalAdjust").text(totalAdjust);
		}
	}
	
	function cacuTotalFact(obj, total){
		if(!obj){
			return;
		}
		
		var totalAdjust = $(obj).val();
		
		var totalObj = $(obj).parent().parent().find("input[name='total']")[0];
		var total = $(totalObj).val();
		var totalFact = parseFloat(total) + parseFloat(totalAdjust);
		
		var totalFactObj = $(obj).parent().parent().find("label[name='totalFact']")[0];
		$(totalFactObj).html(totalFact);	
	}
	
	function print(){
		window.open ("<%=staticPath%>/verify/verifyDetailPrint.htm?verifyId=${reqpm.verifyId }&isShow=true");
	}
	
	(function(){
		loadJoinedTableExist();
	})();

</script>
</html>
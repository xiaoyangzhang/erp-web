<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>机位库存状态</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
.input_num{ width: 50px; text-align: center; }
.input_read{background-color:#eee;}
</style>
</head>
<body>
	<div class="p_container">
		<!-- table  start -->
		
			<dl class="p_paragraph_content">
			<dd>
				<div class="pl-10 pr-10" style="padding-bottom: 1%;">
					<table cellspacing="0" cellpadding="0" class="w_table">
						<col width="20%" />
						<col width="20%" />
						<col width="15%" />
						<col width="15%" />
						<col width="16%" />
						<col width="16%" />
						<thead>
							<tr>
								<th rowspan="2">总数量<i class="w_table_split"></i></th>
								<th rowspan="2">机动位<i class="w_table_split"></i></th>
								<th rowspan="2">已售<i class="w_table_split"></i></th>
								<th rowspan="2">剩余<i class="w_table_split"></i></th>
								<th colspan="2">产品绑定<i class="w_table_split"></i></th>
							</tr>
							<tr>
								<th>已分配<i class="w_table_split"></i></th>
								<th>未分配<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<tbody>
							<td>
								<input class="input_res_id" type="hidden" name="id" value="${trafficResBean.id }"/>
								<input class="res_num_stock_old" type="hidden" name="numStock" value="${trafficResBean.numStock }"/>
								<input class="res_num_disable_old" type="hidden" name="numDisable" value="${trafficResBean.numDisable }"/>
								<input class="res_num_balance_old" type="hidden" name="numBalance" value="${trafficResBean.numBalance }" title="剩余"/>
								<input class="res_num_allocated_old" type="hidden" name="numBalance" value="${sumResProBean.numStock }" title="已分配"/>
								<input class="res_num_undistributed_old" type="hidden" name="numBalance" value="${trafficResBean.numBalance-sumResProBean.numStock }" title="未分配"/>
								<input class="input_num" name="numStock" id="txtNumStock" type="text"  onblur="editStock('stock')" value="${trafficResBean.numStock }"/>
							</td>
							<td><input class="input_num" type="text" name="numDisable" id="txtNumDisable" onblur="editStock('disable')" value="${trafficResBean.numDisable }"/></td>
							<td><input class="input_num input_read" readonly type="text" id="txtSold"  value="${trafficResBean.numSold }"/></td>
							<td><input class="input_num input_read" readonly type="text" id="txtBalance"  value="${trafficResBean.numBalance  }"/></td>
							<td><input class="input_num input_read" readonly type="text" id="txtAllocated"  value="${sumResProBean.numStock }"/></td>
							<td><input class="input_num input_read" readonly type="text" id="txtUndistributed"  value="${(trafficResBean.numSold+trafficResBean.numBalance)-sumResProBean.numStock }"/></td>
						</tbody>
					</table>
				</div>
				<div class="pl-10 pr-10" style="padding-bottom: 1%;">
					<table cellspacing="0" cellpadding="0" class="w_table" id="tbProduct">
						<col width="8%" />
						<col />
						<col width="16%" />
						<col width="15%" />
						<thead>
							<tr>
								<th rowspan="2">序号<i class="w_table_split"></i></th>
								<th rowspan="2">产品名<i class="w_table_split"></i></th>
								<th rowspan="2">已售<i class="w_table_split"></i></th>
								<th rowspan="2">已分配<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${resBindingProList }" var="resPro" varStatus="v">
								<tr>
									<td>${v.index+1 }</td>
									<td style="text-align: left;">${resPro.productName }</td>
									<td>${resPro.numSold }</td>  
									<td>
										<input type="hidden" name="txtProStockIni"  value="${resPro.numStock }"/>
										<input type="hidden" name="txtProSold"  value="${resPro.numSold }"/>
										<input class="input_num" name="txtProStock"  type="text"  value="${resPro.numStock }" onblur="editProduct(this);" />
										<input id="res_pro_id" type="hidden" name="id" value="${resPro.id}"/>
									</td>
								</tr>
							</c:forEach>
						</tbody>
						 <tfoot>
							<tr class="footer1">
					 			<td colspan="2">合计</td>
					            <td>${sumResProBean.numSold }</td>            
					            <td ><span id="sumProductTotal">${sumResProBean.numStock}</span></td>
							</tr>
						</tfoot>
					</table>
				</div>
			</dd>
				<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
					<button type="button" onclick="updateResNumSold()" class="button button-primary button-small">保存</button>
					<button type="button" onclick="closePop()" class="button button-primary button-small">取消</button>
				</div>
		</dl>
	</div>
</body>
<script type="text/javascript">
function isNum(val){
	if (val != null && val != "")
    {
        return !isNaN(val);
    }
    return false;
}


 var iniStock = 0,  iniDisable = 0, iniBalance = 0, iniAllocated = 0, iniUndistributed = 0,
 	txtStock = $("#txtNumStock"),
 	txtDisable = $("#txtNumDisable"),
 	txtSold = $("#txtSold"),
 	txtBalance = $("#txtBalance"),
 	txtAllocated = $("#txtAllocated"),
 	txtUndistribute = $("#txtUndistributed");
 
 	init();
 	
 	function init(){
 		iniStock = $(".res_num_stock_old").val();
 	 	iniDisable = $(".res_num_disable_old").val();
 	 	iniBalance = $(".res_num_balance_old").val();
 	 	iniAllocated = $(".res_num_allocated_old").val();
 	 	iniUndistributed = $(".res_num_undistributed_old").val();
 	 	
 	 	if (!isNum(iniDisable)) iniDisable = 0;
 	 	if (!isNum(iniAllocated)) {iniAllocated = 0;txtAllocated.val(0);}
 	}
 	
 	function checkValidate(){
 		if (!isNum(txtStock.val())) txtStock.val(iniStock);
 		if (!isNum(txtDisable.val())) txtDisable.val(iniDisable);
 		if (!isNum(txtSold.val())) txtSold.val(0);
 		if (!isNum(txtBalance.val())) txtBalance.val(0);
 		if (!isNum(txtAllocated.val())) txtAllocated.val(0);
 		if (!isNum(txtUndistribute.val())) txtUndistribute.val(0);
 	}  
 	
 	function calcBalance(){
 		checkValidate();
 		
 		//剩余 = 总量 - 机动 - 已售
 		var balance = parseInt(txtStock.val()) - parseInt(txtDisable.val()) - parseInt(txtSold.val());
 		txtBalance.val(balance);
 		
 		//已分配
 		var sum = 0;
 		$("#tbProduct input[name='txtProStock']").each(function(){
			sum += parseInt($(this).val());
		});
 		txtAllocated.val(sum);
 		$("#sumProductTotal").text(sum);
 		
 		//未分配 = (已售 + 剩余) - 已分配
 		var undistributed = parseInt(txtSold.val()) + balance - parseInt(txtAllocated.val());
 		txtUndistribute.val(undistributed);
 	}
 	
 	function editStock(txtType){
 		calcBalance();
 		if (parseInt(txtUndistribute.val()) < 0){
 			parent.$.error("未分配数量不能大于0！");
 			if (txtType == 'stock') txtStock.val(iniStock);
 			if (txtType == 'disable') txtDisable.val(iniDisable);
 	 		calcBalance();
 		}else{
 			if (txtType == 'stock') iniStock = txtStock.val();
 			if (txtType == 'disable') iniDisable = txtDisable.val();
 		}
 	}
 	function editProduct(obj){
		var  rowStock = parseInt($(obj).val()),
			 rowStockIni = parseInt($(obj).closest("tr").find("input[name='txtProStockIni']").val()),
			 rowSold = parseInt($(obj).closest("tr").find("[name='txtProSold']").val());
		
		if(rowStock != 0) {
			if (!isNum(rowStock)) $(obj).val(rowStockIni);
		}
		
		if (rowSold > rowStock){
			parent.$.error("分配数量不能小于已售数量！");
			$(obj).val(rowStockIni);
		}
		calcBalance();
		if (parseInt(txtUndistribute.val()) < 0){
 			parent.$.error("未分配数量不能大于0！");
 			$(obj).val(rowStockIni);
 	 		calcBalance();
 		}
	}
 	
	
	function updateResNumSold(){
		var productAry = [];
		$("#tbProduct").find("input[name='txtProStock']").each(function() {  
			var num = $(this).val();  
			var id = $(this).next().val();
			productAry.push("{id:"+id+", numStock:"+num+"}");
	    });
		var productData = "["+productAry.join(",")+"]";
		var resId = $(".input_res_id").val();
		
		var oldNumStock = $(".res_num_stock_old").val();
		var oldNumDisable = $(".res_num_disable_old").val();

		var newNumStock = $("#txtNumStock").val();
		var newNumDisable = $("#txtNumDisable").val();
		
		var res_num_stock = parseInt(newNumStock)-parseInt(oldNumStock);
		var res_num_disable = parseInt(newNumDisable)-parseInt(oldNumDisable);
		
		$.ajax({
			type : "post",
			url : "<%=path%>/resTraffic/toSaveResNumsSold.do",
			data:{productList:productData,numStock:newNumStock,numDisable:newNumDisable,id:resId,
				poorNumStock:res_num_stock,poorNumDisable:res_num_disable},
			dataType : "json",
			success : function(data) {
				if (data.success) {
					parent.reloadPage();
				}
			},
			error : function() {
				parent.$.error('系统异常，请与管理员联系');
			}
		});
	}

/* 取消 */
function closePop(){
	var index = parent.layer.getFrameIndex(window.name);
	parent.layer.close(index);
}
</script>
</html>
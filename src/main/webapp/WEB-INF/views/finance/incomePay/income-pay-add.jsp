<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>收款新增</title>
	<%@ include file="../../../include/top.jsp" %>
	<link rel="stylesheet" type="text/css" href="../assets/css/finance/finance.css"/>
	<script type="text/javascript" src="../assets/js/jquery.idTabs.min.js"></script>
	<script type="text/javascript" src="../assets/js/web-js/supplierComplete.js"></script>
	<style type="text/css">
		
		.searchTab tr td {
			height: 25px;
			padding: 5px;
		}
		.searchTab tr td:nth-child(odd) {
			min-width: 90px;
			text-align: right;
		}
		.searchTab tr td:nth-child(even) {
			min-width: 200px;
		}
		.l_textarea_mark {
			border: 1px solid #dbe4e6;
			border-radius: 3px;
			width: 35%;
			height:70px;
			min-height: 40px;
			padding: 5px 10px;
			line-height: 20px;
		}
	</style>
<script type="text/javascript">
/* 选择供应商 */
function selectSupplier() {
	var oldSupplierId = $("#supplierId").val(), newSupplierId;
	layer.openSupplierLayer({
		title: '选择供应商',
		area: ['1000px', '480px'],
		content: getContextPath() + '/component/supplierList.htm?type=single&supplierType=' + $("#sel_supplier_type").val(),
		callback: function (arr) {
			$('#tableDivTemp').html("");
			idArrTemp = [];
			if (arr.length > 0) {
				$("#supplierId").val(arr[0].id);
				$("#supplierName").val(arr[0].name);
				$("#supplierType").val(arr[0].type);
				newSupplierId = arr[0].id;
			}
		}
	});
}

</script>
</head>
<body>

<div class="p_container">
	<div class="p_container_sub">
		<dl class="p_paragraph_content">
			<form method="post" id="payForm">
				<input type="hidden" name="id" id="pay_id" value="${pay.id}"/>
				<input type="hidden" name="details" id="details"/>
				<input type="hidden" name="supplierId" id="supplierId" value="${pay.supplierId}"/>
				<input type="hidden" name="supplierType" id="supplierType" value="${pay.supplierType}"/>
				<input type="hidden" name="payDirect" value="1"/>
				<p class="p_paragraph_title"><b>收款信息</b></p>
				<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tr>
						<td>供应商类别：</td>
						<td>
							<select id="sel_supplier_type" class="w-100bi" style="width: 71%;" 
									<c:if test="${not empty pay.supplierType}">
										disabled="disabled"
									</c:if>>
								<c:forEach items="${supplierTypeMapIn }" var="tp">
									<option value="${tp.key }"
											<c:if test="${pay.supplierType eq tp.key}"> selected="selected" </c:if>
									>${tp.value }</option>
								</c:forEach>
							</select>
							</select>
						</td>
					</tr>
					<tr>
						<td><i class="red">* </i>商家名称：</td>
						<td style="text-align:left; width: 550px;">
							<input type="text" name="supplierName" id="supplierName" style="width: 70%;"
									<c:if test="${not empty pay }">
										readonly="readonly"
									</c:if>
                                            value="${pay.supplierName }"/>
							<c:if test="${empty pay }">
								<a class="blue" href="javascript:void(0)" onclick="selectSupplier()">选择</a>
							</c:if>
						</td>
					</tr>
					<tr>
						<td>交易日期：</td>
						<td><c:if test="${not empty pay }">
								<input type="text" name="payDate" style="width: 40%;" 
								       value="<fmt:formatDate value="${pay.payDate }" pattern="yyyy-MM-dd"/>"
								       readonly="readonly" class="Wdate"
								       onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							</c:if>
							<c:if test="${empty pay }">
								<input type="text" name="payDate" style="width: 40%;" 
								       value="<fmt:formatDate value="${currDate }" pattern="yyyy-MM-dd"/>"
								       readonly="readonly" class="Wdate"
								       onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<td>收款金额：</td>
						<td>
							<input type="text" name="cash" id="cash" 
								value="<fmt:formatNumber value="${pay.cash }" pattern="#.##" type="number"/>" class="input-w80" style="width: 40%;" />
						</td>
					</tr>
					
					<tr>
						<td>支付方式：</td>
						<td><select name="payType" class="w-100bi" style="width: 40%;">
							<c:forEach items="${payTypeList}" var="item">
								<option value="${item.value}"
								        <c:if test="${pay.payType eq item.value}">selected="selected"</c:if>
								>${item.value}</option>
							</c:forEach>
						</select></td>
						<td></td>
					</tr>
						
					<tr>
						<td>摘要：</td>
						<td colspan="3">
							<textarea name="remark" rows="" cols="" class="l_textarea_mark">${pay.remark }</textarea>
						</td>
					</tr>
					<tr>
						<td>操作员：</td>
						<td>${operatePerson } </td>
					</tr>
				</table>
			</form>
			<p class="p_paragraph_title">
				<b>订单信息</b>
			</p>
			<div id="tableDivExist"></div>
			
			<div>
				<div  style="width: 50%;float: right; text-align: right;">
					<button type="button" onclick="payDelete()" class="button button-primary button-small mt-10">删除选中</button>
					<button id="btn_select_id" type="button" onclick="paySelectAll()" class="button button-primary button-small mt-10">全选</button>
				</div>
				<div  style="width: 50%;">
					<button type="button" onclick="incomeOrderAdd()" class="button button-primary button-small mt-10">添加</button>
				</div>
			</div>
			<div class="payment_footer" style="margin-top: 1%; margin-right: 4%;">
				<%-- <c:if test="${pay.id eq null}"> --%>
					<button href="#" onclick="paySave()" id="btnSave" class="button button-primary button-small mt-10">保存</button>
				<%-- </c:if> --%>
				<button href="#" onclick="closeWindow()" class="button button-primary button-small mt-10">关闭
				</button>
			</div>
		</dl>
	</div>
</div>
</body>
<script type="text/javascript">
	/* 【保存】方法 */
	function paySave(){
		$("#payForm").validate({
			rules: {
				'supplierName': {
					required: true
				}
			},
			messages: {
				'supplierName': {
					required: "请选择商家名称"
				}
			},
			errorPlacement: function (error, element) { // 指定错误信息位置
				debugger
				if (element.is(':radio') || element.is(':checkbox')
						|| element.is(':input')) { // 如果是radio或checkbox
					var eid = element.attr('name'); // 获取元素的name属性
					error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
				} else {
					error.insertAfter(element);
				}
			},
			submitHandler: function (form) {
				var options = {
						url : 'incomePaySave.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.sucess == true) {
	   			            	$.success("保存成功",function(){
				            		refreshWindow("修改收款处理","../financePay/incomePayAdd.htm?payId="+data['supplierId']);
	   			            	});
	   			            }else{
	   							$.error("操作失败");
	   						}
						},
						 error: function(data,msg) {
		   			            $.error("操作失败"+msg);
		   			        }
					}
					$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
		$("form").submit();
	}
	
	/* 添加订单 */
	var win;
	var idArrExist = [];//只用于存储orderID
	var idArrTemp = [];//用于存储orderID和金额
	var sidAndAmount;
	function incomeOrderAdd(){
		var supplierId = $("#supplierId").val();
		var supType = $("#supplierType").val();
		var payId = $("#pay_id").val();
		if (!supplierId) {
			$.error("请选择供应商名称");
			return;
		}
		if(!payId){
			$.error("请先保存收款信息！");
			return;
		}
		layer.open({
			type: 2,
			title: '添加订单',
			closeBtn: false,
			area: ['1000px', '540px'],
			shadeClose: false,
			content: "incomeOrderPayAddList.htm?supplierId=" + supplierId + "&supType=" + supType,
			btn: ['确定', '取消'],
			success: function (layero, index) {
				win=window[layero.find('iframe')[0]['name']];
			},
			/* 确定按钮 */
			yes:function(index){
				//发送请求，加载添加订单时选中的订单
				/* $.getJSON('../financePay/loadOrderPayTable.do',function(data){
					$("#loadOrderDiv").html(data);
				}); */
				sidAndAmount = win.getSidAndAmountValue();  // 获得sid和本次金额
				if(sidAndAmount.length>0){
					for(var i=0;i<sidAndAmount.length;i++){
						var detailInfo = {};
						//idArrTemp.push(sidAndAmount[i].sid);
						detailInfo.locOrderId = sidAndAmount[i].sid;
						idArrExist.push(sidAndAmount[i].sid);
						//idArrTemp.push(sidAndAmount[i].amount);
						detailInfo.cash = sidAndAmount[i].itemAmounts;
						/* detailInfo.cash = sidAndAmount[i].itemAmounts; */
						idArrTemp.push(detailInfo);
					}
				}
				
				//1、先将选中的订单信息插入子表中
				$("#details").val(JSON.stringify(idArrTemp));
				var supType = $("#supplierType").val();
				var details = $("#details").val();
				
				payDetailInsert(supType,payId,details,idArrTemp);//插入操作的方法
				layer.close(index);
			},
			//取消按钮
			cancel:function(index){
				layer.close(index);
			}
		});
	}
	
	/* 将选中的订单信息插入子表中 */
	function payDetailInsert(supType,payId,details){

		$.ajax({
			type:"post",
			url:"../financePay/incomePayDetailInsert.do",
			data:{supplierType:supType,details:details,payId:payId},
			dataType:"json",
			success:function(data){
				if (data.success == true) {
	            	$.success("保存成功",function(){
	            	//2、插入成功后将在查询出信息进行显示
            		//refreshWindow("修改收款处理","../financePay/loadOrderPayTable.do?ids="+details+"&supplierType="+supType+"&payId="+payId);
	            	loadJoinedTableTemp();
	            	});
	            }else{
					$.error("操作失败");
				}
			},
			error:function(data,msg){
				$.error("订单明细保存失败" + msg);
			}
		}); 
	}
	
	/* 点击添加订单中的确定按钮添加订单到新增页面 */
	function loadJoinedTableTemp() {
		var data = {};
		data.hasHead = true;
		data.isView = "true";
		data.supType = "${pay.supplierType }";
		data.payId = "${pay.id }";
		data.sl = "fin.selectIncomeViewList";
		data.rp = "finance/incomePay/income-pay-list-table";
		$("#tableDivExist").load("../common/queryList.htm", data); 
	}
	
	$(function(){
		loadJoinedTableTemp();
	}) 
	
	//点击单条订单记录，移除时删除收款明细子表
	function deleteDetail(orderId) {
		var payId = "${pay.id }";
		//发送ajax请求，进行删除
		$.ajax({
			type:"post",
			url:"../financePay/deletePayDetailOrder.do",
			data:{orderId:orderId,payId:payId},
			dataType:"json",
			success:function(data){
				if (data.success == true) {
	            	$.success("删除成功",function(){
	            		location.reload();
	            	});
	            }else{
					$.error("删除失败");
				}
			},
			error:function(data,msg){
				$.error("删除失败" + msg);
			}
		});
	}
	
	/* 删除选中：即批了移除 */
	function payDelete(){
		var payId = "${pay.id }";
		//获取选中的orderID
		var dataOrder = [];
		$('#tbOrder tr').each(function () {
			//获取选择的orderID
			var checkboxOrderObj = $(this).find("input[type='checkbox']");
			if (checkboxOrderObj.is(':checked')) {
				//var ss = checkboxOrderObj.attr('value');
				dataOrder.push(checkboxOrderObj.attr('value'))
			}
		});
		if(dataOrder == 0){
			$.error("请先选择需要删除的订单");
			return;
		}
		//将数组转换为字符串
		var orderIdStr = dataOrder.join();
		//发送ajax请求，进行批量删除
		$.ajax({
			type:"post",
			url:"../financePay/batchDelPayDetailOrder.do",
			data:{dataOrder:orderIdStr,payId:payId},
			dataType:"json",
			success:function(data){
				if (data.success == true) {
	            	$.success("删除成功",function(){
	            		location.reload();
	            	});
	            }else{
					$.error("删除失败");
				}
			},
			error:function(data,msg){
				$.error("删除失败" + msg);
			}
		});
	}
	
	/* 全选事件 */
	function paySelectAll(){		
		if($("#btn_select_id").text() == '全选'){
			 $(":checkbox").attr("checked", "true");  
			 $("#btn_select_id").text("反选")
			 return;
		}
		if($("#btn_select_id").text() == '反选'){
			 $(":checkbox").removeAttr("checked");  
			 $("#btn_select_id").text("全选")
			 return;
		}	
		
	}
</script>
</html>

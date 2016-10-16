<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>付款新增</title>
	<%@ include file="../../../include/top.jsp" %>
	<link rel="stylesheet" type="text/css" href="../assets/css/finance/finance.css"/>
	<script type="text/javascript" src="../assets/js/jquery.idTabs.min.js"></script>
	<script type="text/javascript" src="../assets/js/web-js/supplierComplete.js"></script>
	<!-- <link rel="stylesheet" type="text/css" href="../assets/js/kalendae/kalendae.css" />
	<script src="../assets/js/kalendae/kalendae.standalone.js" type="text/javascript"></script> -->
	<script type="text/javascript">
		var win;
		var idArrExist = [];
		var idArrTemp = [];
		var amountsObj;
		function orderJoin() {
			var supplierId = $("#supplierId").val();
			var supType = $("#supplierType").val();

			if (!supplierId) {
				$.error("请选择供应商");
				return;
			}

			layer.open({
				type: 2,
				title: '关联订单',
				closeBtn: false,
				area: ['1000px', '480px'],
				shadeClose: false,
				content: "payJoinList.htm?supplierId=" + supplierId + "&supType=" + supType,//
				btn: ['确定', '取消'],
				success: function (layero, index) {
					win = window[layero.find('iframe')[0]['name']];
				},
				yes: function (index) {
					amountsObj = win.getAmountsValue();  // 获得sid和下账金额
					var winCheckArr = win.getChecked();
					for (var i = 0; i < winCheckArr.length; i++) {
						var item = winCheckArr[i];
						if (!isContain(idArrExist, item) && !isContain(idArrTemp, item)) {
							idArrTemp.push(item);
						}
					}

					loadJoinedTableTemp();
					layer.close(index);
				},
				cancel: function (index) {
					layer.close(index);
				}
			});
		}

		function loadJoinedTableTemp() {
			if (idArrTemp.length == 0) {
				return;
			}
			var data = {};
			if ("${pay.id}") {
				data.hasHead = false;
				//移出重复ID
// 			removeRepeat();
			} else {
				data.hasHead = true;
			}
			data.ids = idArrTemp.join();
			data.supType = $("#supplierType").val();//;
			data.sl = "fin.selectPayList";
			data.rp = "finance/cash/pay-joined-list-table";
			$("#tableDivTemp").load("../common/queryList.htm", data, tempCallback);
		}

		function tempCallback() {
			// 加载下账实际金额 包括上次未下完的
			if(amountsObj.length>0){
				for(var i=0;i<amountsObj.length;i++){
					$('#tableDivExist table tr').each(function(){
						var sid =$(this).find("input[name='detailId']");
						if(sid.val()==amountsObj[i].sid){
							$(this).find("input[name='amount']").val(amountsObj[i].itemAmounts);
						}
					});
					$('#tableDivTemp table tr').each(function(){
						var sid =$(this).find("input[name='detailId']");
						if(sid.val()==amountsObj[i].sid) {
							$(this).find("input[name='amount']").val(amountsObj[i].itemAmounts);
						}
					});
				}
			}

			amountChange();
			refreshSerialnum();
		}

		function loadJoinedTableExist() {
			var data = {};
			data.isUpdate = true;
			data.hasHead = true;
			data.supType = "${pay.supplierType }";
			data.payId = "${pay.id }";
			data.oids = idArrExist.join();
			data.sl = "fin.selectPayViewList";
			data.rp = "finance/cash/pay-joined-list-table";
			$("#tableDivExist").load("../common/queryList.htm", data, existCallback);
		}

		function existCallback() {
			amountChange();
			setExistDetailIds();
			refreshSerialnum();
		}

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
					oldSupplierId !== newSupplierId && getSupplierBankAccountById(newSupplierId, false);
				}
			});
		}

		function amountChange() {
			var sum = 0;
			$("input[name='amount']").each(function (i, o) {
				if (!o.value)
					return;
				if (isNaN(o.value)) {
					$.error("付款金额请录入数字");
					o.value = 0;
					return false;
				}
				sum += parseInt(o.value);
			});
			$("#amountSum").text(sum);
		}

		function pay() {
			$("form").validate({
				rules: {
					'payDate': {
						required: true
					},
					'supplierName': {
						required: true
					}
				},
				messages: {
					'payDate': {
						required: "请输入日期"
					},
					'supplierName': {
						required: "请选择商家"
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
					var arr = [];
					$("input[name='amount']").each(function (i, o) {
						if (!o.value)
							return;
						if (isNaN(o.value)) {
							$.error("付款金额请录入数字");
							o.value = 0;
							return false;
						}
						var d = {};
						d.locOrderId = $(o).attr("oid");
						d.cash = o.value;
						arr.push(d);
					});
					if (confirm("确认保存吗？")) {
						$("#idPayBtn").attr("disabled", "disabled").attr("value", "保存.."); //防止重复提交
						$("#details").val(JSON.stringify(arr));
						YM.post("pay.do", YM.getFormData("payForm"), function (data) {
							location.href = "payView.htm?payId=" + data;
						});
					}

				},
				invalidHandler: function (form, validator) { // 不通过回调
					return false;
				}
			});
			$("form").submit();
		}
		//银行选择级联
		function bankSelectRelation(obj, type) {
			var o = $(obj), selectedOption = o.find("option:selected");
			var bank_account = selectedOption.attr("bank_account"), account_name = selectedOption.attr("account_name");
			$("#" + type + "BankOpen").val(bank_account || '');
			$("#" + type + "BankHolder").val(account_name || '');
		}
		//选择供应商以后加载账户信息
		function getSupplierBankAccountById(sid) {
			$.ajax({
				type: 'get',
				url: 'querySupplierBankAccountList.do',
				dataType: 'json',
				data: {
					sid: sid
				},
				success: function (data) {
					$("#rightBank option:gt(0)").remove();
					$("#rightBankOpen").val('');
					$("#rightBankHolder").val('');
					var accountList = data.accountList;
					for (var i in accountList) {
						var backName = accountList[i].bankName;
						var selectedStr = "";
						if ("${pay.rightBank}" == backName) {
							selectedStr = ' selected="selected" ';
						}
						var op = [];
						op.push('<option value="' + backName + '" bank_account="' + accountList[i].bankAccount + '"');
						op.push(' account_name="' + accountList[i].accountName + '"');
						op.push(selectedStr);
						op.push(' >');
						op.push(backName);
						op.push('</option>');
						$("#rightBank").append(op.join(""));
					}
				},
				error: function (data, msg) {
					$.error("操作失败" + msg);
				}
			});
		}

		// 移除明细
		function removeDetail(oid) {
			idArrTemp.splice($.inArray(oid, idArrTemp), 1);
			if (idArrTemp.length == 0) {
				$("#tableDivTemp").empty();
				return;
			}
			loadJoinedTableTemp();
		}

		//删除数据库表明细
		function deleteDetail(oid) {
			idArrExist.splice($.inArray(oid, idArrExist), 1);
			if (idArrExist.length == 0) {
				idArrExist.push("99999");
				loadJoinedTableExist();
				idArrExist = [];
			} else {
				loadJoinedTableExist();
			}
			amountChange();
		}

		function batchRemoveDetail() {

			var removeIds = [];
			$("input:checkbox").each(function () {
				if (!$(this).attr("disabled") && $(this).attr("checked")) {
					removeIds.push($(this).val());
				}
			});

			if (removeIds.length == 0) {
				$.error("请选择要移除的订单！");
				return;
			}

// 		var data = {};
// 		data.payId = "${pay.id}";
// 		data.supplierType = "${pay.supplierType}";
// 		data.locOrderIds = removeIds.join(",");
// 		YM.post("batchDeleteFinancePayDetail.do", data, function(data){
// 			data = $.parseJSON(data);
// 			if(data.success == true){
// 				for(var i = 0; i < removeIds.length; i++){
// 					var inArrTempIndex = $.inArray(removeIds[i], idArrTemp);
// 					if(inArrTempIndex != -1){
// 						idArrExist.splice(inArrTempIndex, 1);	
// 					}
// 				}
// 				loadJoinedTableExist();
// 			}else{
// 				$.error(data.msg);
// 			}
// 		});

			for (var i = 0; i < removeIds.length; i++) {
				var inArrTempIndex = $.inArray(removeIds[i], idArrTemp);
				if (inArrTempIndex != -1) {
					idArrTemp.splice(inArrTempIndex, 1);
				}
			}

			if (idArrTemp.length == 0) {
				$("#tableDivTemp").empty();
			} else {
				loadJoinedTableTemp();
			}

			for (var i = 0; i < removeIds.length; i++) {
				var inArrExistIndex = $.inArray(removeIds[i], idArrExist);
				if (inArrExistIndex != -1) {
					idArrExist.splice(inArrExistIndex, 1);
				}
			}

			if (idArrExist.length == 0) {
				idArrExist.push("99999");
				loadJoinedTableExist();
				idArrExist = [];
			} else {
				loadJoinedTableExist();
			}
			amountChange();
		}

		function removeRepeat() {
			var ids = [];
			for (var i = 0; i < idArrTemp.length; i++) {
				var item = idArrTemp[i];
				if (!isContain(idArrExist, item)) {
					ids.push(item);
				}
			}
			idArrTemp = ids;
		}

		function isContain(arr, item) {

			if (!arr) {
				return false;
			}

			for (var i = 0; i < arr.length; i++) {
				if (item == arr[i]) {
					return true;
				}
			}
			return false;
		}

		function setExistDetailIds() {

			idArrExist = [];
			$("input[name='detailId']").each(function () {
				var id = $(this).val();
				if (id) {
					idArrExist.push(id);
				}
			});
		}

		function refreshSerialnum() {
			var i = 1;
			$("label[name='serialnum']").each(function () {
				$(this).html(i);
				i++;
			});
		}

		function selectAll() {
			if (!$("#select_all").attr("checked")) {
				var flag = true;
				$("#select_all").html("<b>反选</b>");
			} else {
				var flag = false;
				$("#select_all").html("<b>全选</b>");
			}
			$("#select_all").attr("checked", flag);

			$("input:checkbox").each(function () {
				if (!$(this).attr("disabled")) {
					$(this).attr("checked", flag);
				}
			});
		}

		$(document).ready(function () {
			getSupplierBankAccountById($("#supplierId").val(), true);
			if ("${pay.id}") {
				loadJoinedTableExist();
			}
		});

		$(function () {
			supplierComplete.supplierType = $("#sel_supplier_type");
			supplierComplete.select = function (event, v) {
				$("input[name='supplierId']").val(v.item.id);
				$("input[name='supplierType']").val($("#sel_supplier_type").val());
			};
			$("input[name='supplierName']").autocomplete(supplierComplete);
			$("input[name='supplierName']").click(function () {
				$(this).trigger(eKeyDown);
			});
		});
	</script>
</head>
<body>

<div class="p_container">
	<div id="tabContainer">
		<div class="p_container_sub">
			<dl class="p_paragraph_content">
				<div class="payment_con">
					<form action="pay.do" method="post" id="payForm">
						<input type="hidden" name="id" id="id" value="${pay.id}"/>
						<input type="hidden" name="details" id="details"/>
						<input type="hidden" name="supplierId" id="supplierId" value="${pay.supplierId}"/>
						<input type="hidden" name="supplierType" id="supplierType" value="${pay.supplierType}"/>
						<input type="hidden" name="payDirect" value="0"/>
						<div class="payment_bill">
							<p class="bill_head">
								<b>付款单据</b>
							</p>
							<div class="bill_time">
								<dd class="inl-bl">
									<div class="dd_left">供应商类别:</div>
									<div class="dd_right">
										<select id="sel_supplier_type" class="w-100bi"
												<c:if test="${not empty pay.supplierType}">
													disabled="disabled"
												</c:if>
										>
											<c:forEach items="${supplierTypeMapPay }" var="tp">
												<c:if test="${tp.key ne 8 }">
													<option value="${tp.key }"
															<c:if test="${pay.supplierType eq tp.key}"> selected="selected" </c:if>
													>${tp.value }</option>
												</c:if>
											</c:forEach>
										</select>
										</select>
									</div>
									<div class="clear"></div>
								</dd>
								<dd class="inl-bl">
									<div class="dd_left">年月日:</div>
									<div class="dd_right">
										<c:if test="${not empty pay }">
											<input type="text" name="payDate"
											       value="<fmt:formatDate value="${pay.payDate }" pattern="yyyy-MM-dd"/>"
											       readonly="readonly" class="Wdate"
											       onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
										</c:if>
										<c:if test="${empty pay }">
											<input type="text" name="payDate"
											       value="<fmt:formatDate value="${currDate }" pattern="yyyy-MM-dd"/>"
											       readonly="readonly" class="Wdate"
											       onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
										</c:if>
									</div>
									<div class="clear"></div>
								</dd>
								<dd class="inl-bl">
									<div class="dd_left">第:</div>
									<div class="dd_right">
										<input type="text" name="payCode" value="${pay.payCode }" class="w-120"/> 号
									</div>
									<div class="clear"></div>
								</dd>
							</div>
							<table border="" cellspacing="0" cellpadding="0" class="w_table">
								<col width="10%"/>
								<col width="40%"/>
								<col width="10%"/>
								<col width="40%"/>
								<tr>
									<td>商家名称</td>
									<td style="text-align:left">
										<input type="text" name="supplierName" id="supplierName" style="width: 290px;"
												<c:if test="${not empty pay }">
													readonly="readonly"
												</c:if>
                                               value="${pay.supplierName }"/>
										<c:if test="${empty pay }">
											<a class="blue" href="javascript:void(0)" onclick="selectSupplier()">选择</a>
										</c:if>
									</td>
									<td>支付方式</td>
									<td><select name="payType" class="w-100bi">
										<c:forEach items="${payTypeList}" var="item">
											<option value="${item.value}"
											        <c:if test="${pay.payType eq item.value}">selected="selected"</c:if>
											>${item.value}</option>
										</c:forEach>
									</select></td>
								</tr>
								<tr>
									<td>我方银行</td>
									<td><select name="leftBank" class="w-100bi"
									            onchange="bankSelectRelation(this,'left');">
										<option value="">请选择</option>
										<c:forEach items="${bizAccountList}" var="item">
											<option value="${item.bankName}" bank_account="${item.bankAccount}"
											        account_name="${item.accountName}"
													<c:if test="${pay.leftBank eq item.bankName}"> selected="selected" </c:if>
											>
													${item.bankName}
											</option>
										</c:forEach>
									</select></td>
									<td>对方银行</td>
									<td>
										<select name="rightBank" class="w-100bi"
										        onchange="bankSelectRelation(this,'right');" id="rightBank">
											<option value="">请选择</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>开户行</td>
									<td><input type="text" name="leftBankOpen" id="leftBankOpen" class="w-100bi"
									           value="${pay.leftBankOpen }"/></td>
									<td>开户行</td>
									<td><input type="text" name="rightBankOpen" id="rightBankOpen" class="w-100bi"
									           value="${pay.rightBankOpen }"/></td>
								</tr>
								<tr>
									<td>户名</td>
									<td><input type="text" name="leftBankHolder" id="leftBankHolder" class="w-100bi"
									           value="${pay.leftBankHolder }"/></td>
									<td>户名</td>
									<td><input type="text" name="rightBankHolder" id="rightBankHolder" class="w-100bi"
									           value="${pay.rightBankHolder }"/></td>
								</tr>

								<tr>
									<td>摘要</td>
									<td colspan="3"><textarea name="remark" rows="" cols=""
									                          class="w-100bi">${pay.remark }</textarea></td>
								</tr>
							</table>
							<div class="bill_footer">
								<dd class="inl-bl">
									<div class="dd_left">操作员:</div>
									<div class="dd_right">${operatePerson }</div>
									<div class="clear"></div>
								</dd>
							</div>
						</div>
					</form>
				</div>
				<div id="tableDivExist"></div>
				<div id="tableDivTemp"></div>
				<div class="payment_footer">
					<div class="btn_abs">
						<a href="javascript:void(0)" class="btn_gldd" onclick="batchRemoveDetail()"><b>批量移除</b></a>
						<a href="javascript:void(0)" id="select_all" class="btn_gldd"
						   onclick="selectAll()"><b>全选</b></a>
					</div>
					<p class="">
						——— 本次共计付款：<label id="amountSum"></label>元 ———
					</p>
					<a href="javascript:void(0)" class="btn_gldd" onclick="orderJoin()"><b>关联订单</b></a><br/>
					<button href="#" onclick="pay()" id="idPayBtn" class="button button-primary button-small mt-10">付款
					</button>
					<button href="#" onclick="closeWindow()" class="button button-primary button-small mt-10">关闭
					</button>
				</div>
			</dl>
		</div>
	</div>
</div>
</body>
</html>

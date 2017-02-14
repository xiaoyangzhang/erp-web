<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款详情</title>
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css"
	href="../assets/css/finance/finance.css" />
<script type="text/javascript" src="../assets/js/jquery.idTabs.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="../assets/js/kalendae/kalendae.css" />
<script src="../assets/js/kalendae/kalendae.standalone.js"
	type="text/javascript"></script>
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
	$(function() {
		var data = {};
		data.hasHead = true;
		data.isView = "true";
		data.supType = "${pay.supplierType }";
		data.payId = "${pay.id }";
		data.sl = "fin.selectIncomeViewList";
		data.rp = "finance/cash/income-joined-list-table";
		$("#tableDiv").load("../common/queryList.htm", data);
	})
</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<dl class="p_paragraph_content">

				<form method="post" id="payForm">
					<input type="hidden" name="id" id="pay_id" value="${pay.id}" /> <input
						type="hidden" name="details" id="details" /> <input type="hidden"
						name="supplierId" id="supplierId" value="${pay.supplierId}" /> <input
						type="hidden" name="supplierType" id="supplierType"
						value="${pay.supplierType}" /> <input type="hidden"
						name="payDirect" value="1" />
					<p class="p_paragraph_title">
						<b>收款信息</b>
					</p>
					<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
						<colgroup>
							<col width="10%" />
							<col width="40%" />
							<col width="10%" />
							<col width="40%" />
						</colgroup>
						
						<tr>
							<td><i class="red">* </i>商家名称：</td>
							<td style="text-align: left; width: 550px;">
								<input type="text" name="supplierName" id="supplierName"
								style="width: 70%;" value="${pay.supplierName }" readonly="true" />
							</td>
						</tr>
						<tr>
							<td>交易日期：</td>
							<td>
								<input type="text" name="payDate" style="width: 40%;"
									value="<fmt:formatDate value="${pay.payDate }" pattern="yyyy-MM-dd"/>"
									readonly="true"/>
								
							</td>
						</tr>
						<tr>
							<td>收款金额：</td>
							<td><input type="text" name="cash" id="cash" readonly="true" 
								value="<fmt:formatNumber value="${pay.cash }" pattern="#.##" type="number"/>"
								class="input-w80" style="width: 40%;" /></td>
						</tr>

						<tr>
							<td>支付方式：</td>
							<td>
								<input type="text" name="supplierName" id="supplierName"
								style="width: 70%;" value="${pay.payType }" readonly="true" />
							</td>
							<td></td>
						</tr>

						<tr>
							<td>摘要：</td>
							<td colspan="3"><textarea name="remark" rows="" cols="" readonly="true" 
									class="l_textarea_mark">${pay.remark }</textarea></td>
						</tr>
						<tr>
							<td>操作员：</td>
							<td>${operatePerson }</td>
						</tr>
					</table>
				</form>

				<p class="p_paragraph_title">
					<b>订单信息</b>
				</p>
				<c:if test="${not empty pay.detailCount}">
					<div id="tableDiv"></div>
				</c:if>
				<div class="payment_footer" style="margin-top: 1%;  margin-right: 4%;">
					<a onclick="closeWindow()" href="javascript:void(0);"
						class="button button-primary button-small">关闭</a>
				</div>
			</dl>
		</div>

	</div>
</body>
</html>

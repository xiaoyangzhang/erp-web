<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>收款详情</title>
<%@ include file="../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="../assets/css/finance/finance.css" />
<script type="text/javascript" src="../assets/js/jquery.idTabs.min.js"></script>
<link rel="stylesheet" type="text/css" href="../assets/js/kalendae/kalendae.css" />
<script src="../assets/js/kalendae/kalendae.standalone.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
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
		<div id="tabContainer">
			<div class="p_container_sub">
				<dl class="p_paragraph_content">
					<div class="payment_con">
						<form action="pay.do" method="post">
							<input type="hidden" name="details" id="details" />
							<input type="hidden" name="supplierId" id="supplierId" />
							<input type="hidden" name="supplierType" id="supplierType" />
							<div class="payment_bill">
								<p class="bill_head">
									<b>收款单据</b>
								</p>
								<div class="bill_time">
									<dd class="inl-bl">
										<div class="dd_left">年月日:</div>
										<div class="dd_right"><fmt:formatDate value="${pay.payDate }"  type="date" dateStyle="default"/></div>
										<div class="clear"></div>
									</dd>
									<dd class="inl-bl">
										<div class="dd_left">第:</div>
										<div class="dd_right">${pay.payCode }号</div>
										<div class="clear"></div>
									</dd>
								</div>
								<table border="" cellspacing="0" cellpadding="0" class="w_table">
									<col width="10%" />
									<col width="40%" />
									<col width="10%" />
									<col width="40%" />
									<tr>
										<td>商家名称</td>
										<td>${pay.supplierName }</td>
										<td>方式</td>
										<td>${pay.payType }</td>
									</tr>
									<tr>
										<td>我方银行</td>
										<td>${pay.leftBank }</td>
										<td>对方银行</td>
										<td>${pay.rightBank }</td>
									</tr>
									<tr>
										<td>开户行</td>
										<td>${pay.leftBankOpen }</td>
										<td>开户行</td>
										<td>${pay.rightBankOpen }</td>
									</tr>
									<tr>
										<td>户名</td>
										<td>${pay.leftBankHolder }</td>
										<td>户名</td>
										<td>${pay.rightBankHolder }</td>
									</tr>
									<tr>
										<td>摘要</td>
										<td colspan="3">${pay.remark }</td>
									</tr>
								</table>
								<div class="bill_footer">
									<dd class="inl-bl">
										<div class="dd_left">操作员:</div>
										<div class="dd_right">${pay.userName }</div>
										<div class="clear"></div>
									</dd>
								</div>
							</div>
						</form>
					</div>
					<c:if test="${not empty pay.detailCount}">
					<div id="tableDiv"></div>
					</c:if>
					<div class="payment_footer">
						<c:if test="${pay.detailCount > 0 }">
						<p class="">
							——— 本次共计收款：<fmt:formatNumber value="${pay.cash }" pattern="#.##"/>元 ———
						</p>
						</c:if>
						<a onclick="closeWindow()" href="javascript:void(0);" class="button button-primary button-small">关闭</a>
					</div>
				</dl>
			</div>
		</div>
	</div>
</body>
</html>

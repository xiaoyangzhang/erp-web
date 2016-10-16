<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>
<title>Insert title here</title>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="toEditSupplier.htm?id=${supplierId}&operType=${operType}">基本信息</a></li>
			<li><a href="javascript:void(0)" class="selected">结算信息</a></li>
			<li><a href="toContactManList.htm?id=${supplierId}&operType=${operType}">联系人</a></li>
			<li><a
				href="toFolderList.htm?id=${supplierId}&supplierType=${supplierType}&operType=${operType}">图片</a></li>

			
			<li class="clear"></li>
		</ul>

		<div class="p_container_sub" id="tab2">
			<p class="p_paragraph_title">
				<b>银行帐号</b>
			</p>

			<dl class="p_paragraph_content">
				<c:if test="${operType==1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button
							class="button button-primary button-small"
							type="button" onclick="addBankDIV()">添加</button>
					</div>
					<div class="clear"></div>
				</dd>
				</c:if>
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table">
							<thead>
								<tr>
									<th width="15%">类别<i class="w_table_split"></i></th>
									<th width="10">银行<i class="w_table_split"></i></th>
									<th width="15">开户行<i class="w_table_split"></i></th>
									<th width="15">开户名<i class="w_table_split"></i></th>
									<th width="30%">帐号<i class="w_table_split"></i></th>
									<c:if test="${operType==1}"><th width="15%">操作</th></c:if>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${supplierVO.supplierBankaccountList }"
									var="supplierBankaccount" varStatus="index">
									<tr>
										<td><c:if test="${supplierBankaccount.accountType==1 }">个人账户 </c:if>
											<c:if test="${supplierBankaccount.accountType==2 }">对公账户</c:if></td>
										<td>${supplierBankaccount.bankName }</td>
										<td>${supplierBankaccount.bankAccount }</td>
										<td>${supplierBankaccount.accountName }</td>
										<td style="text-align: left;">${supplierBankaccount.accountNo }</td>
										<c:if test="${operType==1}"><td><a class="def"
											href="javascript:void(0);"
											onclick="toEditBank(${supplierBankaccount.id })">修改</a> <a
											href="javascript:void(0);"
											class="def"
											onclick="delBank(${supplierBankaccount.id })">删除</a></td></c:if>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			<p class="p_paragraph_title">
				<b>发票信息</b>
			</p>
			<!-- 			<dd> -->
			<!-- 				<div class="dd_left">开具正规发票：</div> -->
			<!-- 				<div class="dd_right" style="width: 80%"> -->
			<!-- 					<input type="radio" name="isBill" value="0">是</input><input -->
			<!-- 						type="radio" name="isBill" value="1">否</input> -->
			<!-- 				</div> -->
			<!-- 				<div class="clear"></div> -->
			<!-- 			</dd> -->


			<dl class="p_paragraph_content">
			<c:if test="${operType==1}">
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right" style="width: 80%">
						<button
							class="button button-primary button-small"
							type="button" onclick="billModalDIV()">添加</button>
					</div>
					<div class="clear"></div>
				</dd>
				</c:if>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right" style="width:40%">
						<table cellspacing="0" cellpadding="0" class="w_table">
							<thead>
								<tr>
									<th width="50%">名称</th>
									<th width="20%">是否是默认发票</th>
									<c:if test="${operType==1}"><th width="30%">操作</th></c:if>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${supplierVO.supplierBillList}"
									var="supplierBill" varStatus="billIndex">
									<tr>
										<td style="text-align: left;">${supplierBill.billName }</td>
										<td><c:if test="${supplierBill.isDefault==0  }">是 </c:if>
											<c:if test="${supplierBill.isDefault==1  }">否 </c:if></td>
										<c:if test="${operType==1}"><td><a href="javascript:void(0);"
											onclick="toEditBill(${supplierBill.id })"
																		   class="def">修改</a> <a
											href="javascript:void(0);"
											onclick="delBill(${supplierBill.id })"
											class="def">删除</a> <c:if
												test="${supplierBill.isDefault==1 }">
												<a href="javascript:void(0);"
												   class="def"
													onclick="setDefaultBill(${supplierBill.id},${supplierId})">设置为默认发票</a>
											</c:if></td></c:if>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</div>
	</div>
	<script type="text/javascript">
	
function addBankDIV(){
	$('#saveBankInfo')[0].reset();
	layer.open({ 
		type : 1,
		title : '添加银行信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '300px', '350px' ],
		content :$('#bankModal')
	});

	
	
}
function billModalDIV(){
	$('#saveBillInfo')[0].reset();
	layer.open({ 
		type : 1,
		title : '添加发票信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '300px', '200px' ],
		content :$('#billModal')
	});
}

</script>
	<!-- 银行增加弹出层开始 -->


	<div id="bankModal" style="display: none">
		<form id="saveBankInfo">
			<input type="hidden" name="supplierId" value="${supplierId}" />
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">类别</div>
					<div class="dd_right">
						<select name="accountType" style="width: 160px">
							<option value="1">个人账户</option>
							<option value="2">对公账户</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">银行</div>
					<div class="dd_right">
						<select name="bankId" style="width: 160px">
							<c:forEach items="${bankList }" var="bank">
								<option value="${bank.id }">${bank.value }</option>
							</c:forEach>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">开户行</div>
					<div class="dd_right">
						<input type="text" name="bankAccount" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">开户名</div>
					<div class="dd_right">
						<input type="text" name="accountName" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">帐号</div>
					<div class="dd_right">
						<input type="text" name="accountNo" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit"
							class="button button-primary button-small">提交</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>


	<!-- 银行增加弹出层结束 -->


	<!-- 银行修改弹出层开始 -->
	<div id="bankEditModal" style="display: none">
		<form id="editBankInfo">
			<input type="hidden" name="id" id="bankAccountId" value="" /> <input
				type="hidden" name="supplierId" value="${supplierId}" />
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">类别</div>
					<div class="dd_right">
						<select name="accountType" id="accountType">
							<option value="1">个人账户</option>
							<option value="2">对公账户</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">银行</div>
					<div class="dd_right">
						<select name="bankId" id="bankId">
							<c:forEach items="${bankList }" var="bank">
								<option value="${bank.id }">${bank.value }</option>
							</c:forEach>
							<option value="1">工商银行</option>
							<option value="2">招商银行</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">开户行</div>
					<div class="dd_right">
						<input type="text" name="bankAccount" id="bankAccount"
							class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">开户名</div>
					<div class="dd_right">
						<input type="text" name="accountName" id="accountName"
							class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">帐号</div>
					<div class="dd_right">
						<input type="text" name="accountNo" id="accountNo"
							class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit"
							class="button button-primary button-small">提交</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>

	<!-- 银行修改弹出层结束 -->


	<!-- 发票增加弹出层开始 -->
	<div id="billModal" style="display: none">
		<form id="saveBillInfo">
			<input type="hidden" name="supplierId" value="${supplierId}" /> <input
				type="hidden" name="isDefault" value="1" />
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">名称</div>
					<div class="dd_right">
						<input type="text" name="billName" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit"
							class="button button-primary button-small">提交</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>
	<!-- 发票增加弹出层结束 -->

	<!-- 发票修改弹出层开始 -->
	<div id="billEditModal" style="display: none">
		<form class="definewidth m20" id="editBillInfo">
			<input type="hidden" name="id" id="billId" value="${supplierId}" />
			<input type="hidden" name="supplierId" value="${supplierId}" /> <input
				type="hidden" name="isDefault" id="isDefault" value="" />

			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">名称</div>
					<div class="dd_right">
						<input type="text" name="billName" id="billName"
							class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit"
							class="button button-primary button-small">提交</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>
	<!-- 发票修改弹出层结束 -->


</body>
</html>
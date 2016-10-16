<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/css/product/product_rote.css"
	rel="stylesheet" />
	<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/configBizInfo.js"></script>
<title>配置商家信息</title>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub" id="tab2">
			<p class="p_paragraph_title">
				<b>银行帐号</b>
			</p>
			<form action="" id="mainForm" method="post">
			<input type="hidden" id="bizId" name="bizId" value="${bizId }"/>
			<dl class="p_paragraph_content">
				
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button
							class="button button-primary button-small"
							type="button" id="addBank">添加</button>
					</div>
					<div class="clear"></div>
				</dd>
				
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table" id="bankTbl">
							<thead>
								<tr>
									<th>类别<i class="w_table_split"></i></th>
									<th>银行<i class="w_table_split"></i></th>
									<th>开户行<i class="w_table_split"></i></th>
									<th>开户名<i class="w_table_split"></i></th>
									<th>帐号<i class="w_table_split"></i></th>
									<th>操作<i class="w_table_split"></i></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${bankaccountList}"
									var="bank" varStatus="index">
									<tr>
										<td><c:if test="${bank.accountType==1 }">个人账户 </c:if>
											<c:if test="${bank.accountType==2 }">对公账户</c:if></td>
										<td>${bank.bankName }</td>
										<td>${bank.bankAccount }</td>
										<td>${bank.accountName }</td>
										<td>${bank.accountNo }</td>
										<td><a class="def"
											href="javascript:void(0);"
											onclick="toEditBank(${bank.id })">修改</a> <a
											href="delBank.do?id=${bank.id} "
											class="def"
											>删除</a></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			</form>
			<p class="p_paragraph_title">
				<b>商家LOGO</b>
			</p>
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left"></div>
                <div class="dd_right addImg" >
				<span class="ulImg"> 
				<c:if test="${logo ne null}">
				<img src="${config.imgServerUrl }${logo }" id="imgs" /><!-- <i
						class="icon_del" style="display: none"  id="delImg" onclick="imgDelete()"></i>  -->
						<input type="hidden" name="logo"	id="logo" value="${logo }" /> 
                </c:if>
                </span>
                </div>
                <label onclick="selectAttachment(this)" class="ulImgBtn"></label>
                <div class="clear"></div>
				</dd>
			</dl>
		</div>
		</div>
		<script type="text/html">
		<div id="imgTemp" style="display: none">
					<span class="ulImg"> <img src="$src" />
						<input type="hidden" name="logo"	value="$path" /> 
						
						
					</span>
				</div></script>
		<!-- 银行增加弹出层开始 -->
<script type="text/html" id="bankHtml">
<tr>
<td tag='accountType'>$accountType</td><td tag='bankName'>$bankName</td><td tag='bankAccount'>$bankAccount</td>
<td tag='accountName'>$accountName</td><td tag='accountNo'>$accountNo</td>
<td><a class="button button-rounded button-tinier" href="javascript:void(0);"onclick="toEditBank(${supplierBankaccount.id })">修改</a> 
<a href="javascript:void(0);"	class="button button-rounded button-tinier"	onclick="delBank(this,${supplierBankaccount.id })">删除</a></td>
</tr>
</script>
<script type="text/javascript">

var layindex=0;
$(function(){
	$("#addBank").click(function(){
		layindex = addBankDIV();	
		validator = addValidate("saveBankInfo");
	});
	$("#saveBankInfo #bankCancel").click(function(){
		if(layindex>0){
			layer.close(layindex);
		}
	});
	
	$("#editBankInfo #bankCancel").click(function(){
		if(layindex>0){
			layer.close(layindex);
		}
	});
})

	
function addValidate(formid){
	return $("#"+formid).validate({
		rules:{
			
			'bankAccount':{
				required: true,
				maxlength:20
				
			},
			'accountName':{
				required: true,
				maxlength:20
				//isDouble:true
			},
			'accountNo':{
				required: true
				//maxlength:20
				//isDouble:true
			}
		},
		messages: {
			'bankAccount':{
				required: "请输入开户行",
				maxlength:"长度小于20"
			},
			'accountName':{
				required: "请输入开户名",
				maxlength:"长度小于20"
			},
			'accountName':{
				required: "请输入帐号"
				//maxlength:"长度小于20"
			}
		},
		errorPlacement : function(error, element) { // 指定错误信息位置
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) { // 如果是radio或checkbox
				var eid = element.attr('name'); // 获取元素的name属性
				error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			$(form).find("#bankName").val($(form).find("#bankId").find("option:selected").text());
			form.submit();
		}
	});
}

 


function addBankDIV(){
	
	//$("#saveBankInfo")[0].reset();
	var index=layer.open({
	    type: 1,
	    skin: 'layui-layer-rim', //加上边框
	    area: ['700px', '420px'], //宽高
	    content: $("#bankModal")
	});
	return index;	
}

function toEditBank(id){
	$.getJSON("getSysBankInfo.do?id="+id,function(data){
		//alert(data.id);
		$("#editBankInfo #accountType").val(data.accountType);
		$("#editBankInfo #bankAccountId").val(data.id);
		$("#editBankInfo #bankId").val(data.bankId);
		$("#editBankInfo #bankAccount").val(data.bankAccount);
		$("#editBankInfo #accountName").val(data.accountName);
		$("#editBankInfo #accountNo").val(data.accountNo);
		
	});
	layindex=layer.open({
	    type: 1,
	    skin: 'layui-layer-rim', //加上边框
	    area: ['700px', '420px'], //宽高
	    content: $("#bankEditModal")
	});
	addValidate("editBankInfo");	
}


</script>

	<div id="bankModal" style="display: none">
		<form id="saveBankInfo" action="saveBank.do" method="post">
			<%-- <input type="hidden" name="bizId" value="${bizId}" /> --%>
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">类别</div>
					<div class="dd_right">
						<select name="accountType" id="accountType" style="width: 160px">
							<option value="1">个人账户</option>
							<option value="2">对公账户</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">银行</div>
					<div class="dd_right">
						<input type="hidden" name="bankName" id="bankName"/>
						<select name="bankId" id="bankId" style="width: 160px">
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
						<input type="text" id="bankAccount" name="bankAccount" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">开户名</div>
					<div class="dd_right">
						<input type="text" name="accountName" id="accountName" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">帐号</div>
					<div class="dd_right">
						<input type="text" name="accountNo" id="accountNo" class="IptText301" />
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="submit"
							class="button button-primary button-small">提交</button>
						<input type="button" id="bankCancel"
									class="button button-primary button-small"
									value="取消" />
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>


	<!-- 银行增加弹出层结束 -->


	<!-- 银行修改弹出层开始 -->
	<div id="bankEditModal" style="display: none">
		<form id="editBankInfo" action="saveBank.do" method="post">
			<input type="hidden" name="id" id="bankAccountId" value="" /> <%-- <input
				type="hidden" name="supplierId" value="${supplierId}" /> --%>
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
					<input type="hidden" name="bankName" id="bankName"/>
						<select name="bankId" id="bankId">
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
						<input type="button" id="bankCancel"
									class="button button-primary button-small"
									value="取消" />
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
		</form>
	</div>

	<!-- 银行修改弹出层结束 -->


	
</body>

</html>

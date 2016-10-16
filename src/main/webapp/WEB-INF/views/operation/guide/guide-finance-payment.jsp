<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
</head>
	<script type="text/javascript">
	$(function() {
		function setData(){
			var curDate=new Date();
			var payDate=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+curDate.getDate();
			 $("input[name='payDate']").val(payDate);
		}
		setData();
	})
	</script>
<body>
  <div class="p_container" >
      <div id="tabContainer">        
        <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="useroom_tab pl-20 pr-20">
	    				<table cellspacing="0" cellpadding="0" border="1" class="w_table">
	    					<col width="3%"/>
	    					<col width="30%"/>
	    					<col width="30%"/>
	    					<col width="5%"/>
	    					<col width="5%"/>
	    					<col width="8%"/>
	    					<col width="3%"/>
	    					<thead>
	    						<tr>
	    							<th>序号</th>
	    							<th>商家名称</th>
	    							<th>明细</th>
	    							<th>报账金额</th>
	    							<th>报账人</th>
	    							<th>报账时间</th>
	    							<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
	    						</tr>	
	    					</thead>
	    					<tbody>
	    					<c:set var="index" value="0"></c:set>
	    					 <c:forEach items="${map}" var="item">
	    					 	<c:if test="${not empty item.value}">
	    					 	  <c:forEach items="${item.value}" var="list" varStatus="status">
	    					 	  <c:set var="index" value="${index + 1 }"></c:set>
		    						<tr id="${list.fid }">
		    							<td>${index}</td>
			    						<td>${list.supplierName }</td>
			    						<td> 
			    							<c:forEach items="${list.supplierDetail}" var="supplierDetail" >
			    							 	${supplierDetail }<br>
			    							 </c:forEach>
			    						</td>
			    						
			    						<c:if test="${list.supplierType eq 120 }">
			    							<c:set var="listFtotal" value="${0-list.ftotal }" />
			    						</c:if>
			    						<c:if test="${list.supplierType ne 120 }">
			    							<c:set var="listFtotal" value="${list.ftotal }" />
			    						</c:if>
			    						<td><fmt:formatNumber value="${listFtotal }" type="number" pattern="#.##"/></td>
			    						<td>${list.payusername }</td>
			    						<c:if test="${list.pstatus == 1}">
			    							<td><fmt:formatDate value="${list.paytime }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
			    						</c:if>
			    						<c:if test="${list.pstatus == 0}">
			    							<td></td>
			    						</c:if>
										<td>
											<c:if test="${list.pstatus == 0}">	
												<input type="checkbox" name="audit_id" ftotalValue="${list.ftotal}" ftype="${list.supplierType}" value="${list.id}"
													<c:if test="${list.stateFinance ne 1 }">
														disabled="disabled"
													</c:if>
												/>
											</c:if>
										</td>
										<c:set var="sumTotal" value="${sumTotal + listFtotal }" />
									</tr>
		    					  </c:forEach>
		    					</c:if>	
	    					  </c:forEach>
	    					
    					 	  <c:forEach items="${guideComms}" var="item" varStatus="status">
    					 	  	<c:set var="index" value="${index + 1 }"></c:set>
	    						<tr>
	    							<td>${index }</td>
		    						<td>佣金</td>
		    						<td>${item.commissionName }</td>
									<td><fmt:formatNumber value="${item.total }" type="number" pattern="#.##"/></td>
									<td>${item.payUserName}</td>
									<td>
										<c:if test="${not empty item.payTime }">
											<fmt:formatDate value="${item.payTime }" pattern="yyyy-MM-dd HH:mm:ss" />
										</c:if>
									</td>
									<td>
										<c:if test="${item.stateFinance eq 1 and item.total ne item.totalCash}">	
											<input type="checkbox" name="comm_id" ftotalValue="${item.total}" value="${item.id}"/>
										</c:if>
										<c:if test="${item.stateFinance ne 1}">
											<input type="checkbox" disabled />
										</c:if>
									</td>		
									<c:set var="sumTotal" value="${sumTotal + item.total }" />    						
								</tr>
	    					  </c:forEach>
	    					  
	    					  <c:forEach items="${guideCommDeductions}" var="item" varStatus="status">
    					 	  	<c:set var="index" value="${index + 1 }"></c:set>
	    						<tr>
	    							<td>${index }</td>
		    						<td>佣金</td>
		    						<td>${item.commissionName }</td>
									<td><fmt:formatNumber value="${item.total }" type="number" pattern="#.##"/></td>
									<td>${item.payUserName}</td>
									<td>
										<c:if test="${not empty item.payTime }">
											<fmt:formatDate value="${item.payTime }" pattern="yyyy-MM-dd HH:mm:ss" />
										</c:if>
									</td>
									<td>
										<c:if test="${item.stateFinance eq 1 and item.total ne item.totalCash}">	
											<input type="checkbox" name="comm_deduction_id" ftotalValue="${item.total}" value="${item.id}"/>
										</c:if>
										<c:if test="${item.stateFinance ne 1}">
											<input type="checkbox" disabled />
										</c:if>
									</td>		
									<c:set var="sumTotal" value="${sumTotal + item.total }" />    						
								</tr>
	    					  </c:forEach>
	    					  
	    					  	<tr>
									<td></td>
									<td></td>
									<td>合计：</td>
									<td><fmt:formatNumber value="${sumTotal }" type="number" pattern="#.##"/></td>
									<td></td>
									<td></td>
									<td></td>
	    					  	</tr>
	    					</tbody>
	    				</table>
	    			</div>
			    </dd>
	    	</dl>
        </div>
      </div>
      
		<div align="center">
			<a href="javascript:void();" id="btn_audit" onclick="showPayForm('${reqpm.bookingId }')" class="button button-primary button-rounded button-small">付款</a>
			<a href="javascript:void();" onclick="closeWindow();" class="button button-primary button-rounded button-small">关闭</a>   				
		</div>
		<div class="clear"></div>
		
    </div>  
    		<div class="p_container" id="pay_div" style="display: none">
			<form class="form-horizontal" id="payForm">
				
				<input type="hidden" name="groupId" value="${groupId }"/>
				<input type="hidden" name="guideId" value="${guideId }"/>
				<input type="hidden" name="bookingGuideId" id="bookingGuideId"/>
				<input type="hidden" name="checkedArr" id="checkedArr"/>
				<input type="hidden" name="commissionIds" id="commissionIds"/>
				<input type="hidden" name="commissionDeductionIds" id="commissionDeductionIds"/>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">报账金额:</div>
						<div class="dd_right">
							 <label id="totalPay"></label>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">报账人:</div>
						<div class="dd_right">
							<a>${pay_user_name}</a>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">年月日:</div>
						<div class="dd_right">
							<input type="text" name="payDate" readonly="readonly" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">支付方式:</div>
						<div class="dd_right">
							<select name="payType" class="w-100bi" style="width: 300px">
								<c:forEach items="${payTypeList}" var="item">
									<option value="${item.value}">${item.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">银行:</div>
						<div class="dd_right">
							<select name="leftBank" class="w-100bi" onchange="bankSelectRelation(this,'left');">
								<option value="">请选择</option>
								<c:forEach items="${bizAccountList}" var="item">
									<option value="${item.bankName}" bank_account="${item.bankAccount}" account_name="${item.accountName}"
										<c:if test="${pay.leftBank eq item.bankName}"> selected="selected" </c:if>
									>
										${item.bankName}
									</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">开户行:</div>
						<div class="dd_right">
							<input type="text" name="leftBankOpen" id="leftBankOpen" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">户名:</div>
						<div class="dd_right">
							<input type="text" name="leftBankHolder" id="leftBankHolder" class="w-100bi" style="width: 300px"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">摘要:</div>
						<div class="dd_right">
							<textarea name="remark" rows="3" style="width: 300px"></textarea>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
			</form>
		</div>

</body>
<script type="text/javascript">
function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[name='audit_id']").attr('checked', 'checked');
	} else {
		$("input[name='audit_id']").removeAttr("checked");
	}
	
	if ($(ckbox).attr("checked")) {
		$("input[name='comm_id']").attr('checked', 'checked');
	} else {
		$("input[name='comm_id']").removeAttr("checked");
	}
	
	if ($(ckbox).attr("checked")) {
		$("input[name='comm_deduction_id']").attr('checked', 'checked');
	} else {
		$("input[name='comm_deduction_id']").removeAttr("checked");
	}
}

function showPayForm(bookId){
	var checkedArr = [];
	var totalPay=0;
	$("input[name='audit_id']").each(function(i, o) {
		var json = $(o).val();
		if ($(o).attr("checked") && !$(o).attr("disabled")) {
			checkedArr.push(json);
			if($(o).attr("ftype")==120){
				totalPay=parseFloat(totalPay)-parseFloat($(o).attr("ftotalValue"));
			}else{
				totalPay=parseFloat(totalPay)+parseFloat($(o).attr("ftotalValue"));
			}
		} 
	});
	
	var commissionIds = [];
	$("input[name='comm_id']").each(function(i, o) {
		var commId = $(o).val();
		if ($(o).attr("checked")) {
			commissionIds.push(commId);
			totalPay=parseFloat(totalPay)+parseFloat($(o).attr("ftotalValue"));
		} 
	});
	
	var commissionDeductionIds = [];
	$("input[name='comm_deduction_id']").each(function(i, o) {
		var commId = $(o).val();
		if ($(o).attr("checked")) {
			commissionDeductionIds.push(commId);
			totalPay=parseFloat(totalPay)+parseFloat($(o).attr("ftotalValue"));
		} 
	});
	
	$('#totalPay').html(totalPay);
	if(checkedArr.length==0 && commissionIds.length == 0 && commissionDeductionIds.length == 0){
		return;
	}
	
	$('#checkedArr').val(checkedArr);
	$("#bookingGuideId").val(bookId);
	$("#commissionIds").val(commissionIds);
	$("#commissionDeductionIds").val(commissionDeductionIds);
	
	layer.open({
		type : 1,
		title : '导游付款',
		closeBtn : false,
		area : [ '600px', '350px' ],
		shadeClose : false,
		content : $('#pay_div'),
		btn : [ '付款', '取消' ],
		yes : function(index) {
			guidePay(index);
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

function guidePay(index){
	$("#payForm").validate({
		rules : {
			'payDate' : {
				required : true
			},
			'payCode' : {
				required : true
			},
			'checkedArr' : {
				required : true
			}
		},
		messages : {
			'payDate' : {
				required : "请输入日期"
			},
			'payCode' : {
				required : "请输入单据号"
			},
			'checkedArr' : {
				required : "请选择需要报账的项目"
			}
		},
		errorPlacement : function(error, element) { // 指定错误信息位置
			debugger
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) { // 如果是radio或checkbox
				var eid = element.attr('name'); // 获取元素的name属性
				error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			YM.post("<%=staticPath%>/finance/guide/payGuideBillPlus.do",YM.getFormData("payForm"),function(){
				$.success("付款成功");
				layer.close(index);
				window.location.reload();
			});
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	$("#payForm").submit();	
}

//银行选择级联
function bankSelectRelation(obj,type){
	var o = $(obj),selectedOption = o.find("option:selected");
	var bank_account = selectedOption.attr("bank_account"),account_name = selectedOption.attr("account_name");
	$("#"+type+"BankOpen").val(bank_account || '');
	$("#"+type+"BankHolder").val(account_name || '');
}


</script>
</html>

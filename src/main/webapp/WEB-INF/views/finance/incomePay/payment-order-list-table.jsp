<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<style>
#autoCountDivId{
	text-align: right;
	padding-top: 1%;
}
</style>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="4%"/>
	<col width="13%"/>
	<col />
	<col width="7%"/>
	<col width="7%"/>
	<col width="7%"/>
	
	<col width="7%"/>
	<col width="10%"/>
	<col width="8%"/>
	<col width="5%"/>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			
			<%-- <c:if test="${reqpm.supType eq 1}">
				<th>接站牌<i class="w_table_split"></i></th>
				<th>人数<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 6}">
				<th>明细<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 12}">
				<th>方式<i class="w_table_split"></i></th>
				<th>明细<i class="w_table_split"></i></th>
			</c:if> --%>
			
			<th>计调<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>下账金额<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th><input type="checkbox" onclick="checkAll(this)"/>全选</th>
		</tr>
	</thead>
	<tbody id="tbOrderObj">
		<c:set var="sumTotal" value="0"/>
		<c:set var="sumTotalCash" value="0"/>
		<c:set var="sumBalanceCash" value="0"/>
		<c:forEach items="${pageBean.result}" var="order" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td style="text-align: left;">
					<c:if test="${order.group_mode <= 0}">
						<a class="def" href="javascript:void(0)"
						   onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a>
					</c:if>
					<c:if test="${order.group_mode > 0}">
						<a href="javascript:void(0);" class="def"
						   onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a>
					</c:if>
				</td>
				<td style="text-align: left;">【${order.product_brand_name}】${order.product_name}</td>
				
				<%-- <c:if test="${reqpm.supType eq 1}">
					<td style="text-align: left;">${order.receive_mode }</td>
					<td>${order.num_adult }大${order.num_child }小</td>
				</c:if>
				<c:if test="${reqpm.supType eq 6}">
					<td>${order.details}</td>
				</c:if>
				<c:if test="${reqpm.supType eq 12}">
					<td>${order.cash_type}</td>
					<td>${order.details}</td>
				</c:if> --%>
				
				<td>${order.operator_name}</td>
				<td>
					<c:if test="${not empty order.total}">
						<fmt:formatNumber value="${order.total }" pattern="#.##"/>
						<input type="hidden" name="itemTotal"
						       value="<fmt:formatNumber value="${order.total }" pattern="#.##"/>"/>
					</c:if>
					<c:if test="${empty order.total}">
						0
						<input type="hidden" name="itemTotal" value="0"/>
					</c:if>
				</td>
				<td>
					<c:if test="${not empty order.total_cash}">
						<fmt:formatNumber value="${order.total_cash }" pattern="#.##"/>
						<input type="hidden" name="itemTotalCash"
						       value="<fmt:formatNumber value="${order.total_cash }" pattern="#.##"/>"/>
					</c:if>
					<c:if test="${empty order.total_cash}">
						0
						<input type="hidden" name="itemTotalCash" value="0"/>
					</c:if>
				</td>
				<td>
					<c:if test="${not empty order.balance}">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
						<input type="hidden" name="itemBalance"
						       value="<fmt:formatNumber value="${order.balance }" pattern="#.##"/>"/>
					</c:if>
					<c:if test="${empty order.balance}">
						0
						<input type="hidden" name="itemBalance" id="itemBalance" value="0"/>
					</c:if>
				</td>
				<!-- 下账金额 -->
				<!-- <td><label id="itemAmounts">0</label></td> -->
				<td><input type="text" id="itemAmounts" name="itemAmounts" style="width: 90%;text-align: center;" onblur="itemAmountsChange();"
						       value="<fmt:formatNumber value="0" pattern="#.##"/>"/></td>
				<td>
					<c:if test="${order.state_seal eq 1}">已封存</c:if>
					<c:if test="${order.state_seal eq 0}">
						<c:if test="${order.state_finance ne 1}">未审核</c:if>
						<c:if test="${order.state_finance eq 1}">已审核</c:if>
					</c:if>
				</td>
				<td>
					<input type="checkbox" sid="${order.id}" 
						groupCode="${order.group_code}" onclick="checkboxChange(this)"/>
				</td>
				<c:if test="${not empty order.total}">
					<c:set var="sumTotal" value="${sumTotal + order.total }"/>
				</c:if>
				<c:if test="${not empty order.total_cash}">
					<c:set var="sumTotalCash" value="${sumTotalCash + order.total_cash }"/>
				</c:if>
				<c:if test="${not empty order.balance}">
					<c:set var="sumBalanceCash" value="${sumBalanceCash + order.balance }"/>
				</c:if>
			</tr>
		</c:forEach>
		
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<c:if test="${reqpm.supType eq 1}">
				<td></td>
				<td></td>
			</c:if>
			<c:if test="${reqpm.supType eq 6}">
				<td></td>
			</c:if>
			<c:if test="${reqpm.supType eq 12}">
				<td></td>
				<td></td>
			</c:if>
	
			<td style="text-align: right;font-weight: bold;">合计</td>
			<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumTotalCash}" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumBalanceCash}" pattern="#.##"/></td>
			<td><label id="sumAmounts">0</label></td>
			<td></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<div class="p_container" id="autoCountDivId">
	<label>自动计算：</label>
	<input type="text" id="autoCountAmountsId" name="autoCountAmounts" value="" style="width: 80px;" />
	<input id="cbAmounts" type="checkbox" onclick="autoCount(this);"/>选择
	<!-- <input type="button" id="autoCount_id" 
		onclick="autoCount(this);" class="button button-primary button-small" value="选择"> --></li>
</div>
<script type="text/javascript">

/* 自动计算>鼠标移开事件 */
function autoCount(obj){
	var autoCountAmounts = parseFloat($("#autoCountAmountsId").val()); // 获取自动计算金额
	/* var reg = /^[0-9]+.?[0-9]*$/;//用来验证数字，包括小数的正则
	if(!reg.test(autoCountAmounts)){
		alert("请输入正确的数字格式！");
		return;
	} */
	var tbOrderObj = $('#tbOrderObj tr'); // 列表
	if (obj.checked) {
		if (isNaN(autoCountAmounts)) {
			alert('自动计算金额输入有误，请检查后重新输入！');
			obj.checked = false;
		} else {
			if (autoCountAmounts != 0) {
				tbOrderObj.each(function () { // 循环
					var currentRowPay = 0;
					var checkboxObj = $(this).find("input[type='checkbox']"); // 选择框
					var itemBalance = parseFloat($(this).find("input[name='itemBalance']").val()); // 未付金额
					var itemAmounts = $(this).find("input[name='itemAmounts']"); //本次下账
					
					if (autoCountAmounts == 0) return false;
					
					if (autoCountAmounts > 0){
						currentRowPay = parseFloat(autoCountAmounts) > parseFloat(itemBalance) ? parseFloat(itemBalance) : parseFloat(autoCountAmounts);
					}else{
						if (parseFloat(itemBalance) > 0){
							currentRowPay = 0;
						}else{
							currentRowPay = parseFloat(autoCountAmounts) > parseFloat(itemBalance) ? parseFloat(autoCountAmounts) : parseFloat(itemBalance);
						}
					}
					
					autoCountAmounts -= currentRowPay;
					
					
					//alert('after:amounts='+amounts);
					itemAmounts.val(currentRowPay);
					checkboxObj.attr('checked', true);
					/* if(autoCountAmounts > 0 && autoCountAmounts>parseFloat(itemBalance)){
						//获取到下账金额
						var itemAmounts = $(this).find("label[id='itemAmounts']"); //本次下账
						
						//将未付款的值赋给下账金额
						itemAmounts.val(parseFloat(itemBalance));
						//自动计算金额-下账金额
						currentRowPay = parseFloat(autoCountAmounts)-parseFloat(itemAmounts.val());
						
						if (parseFloat(autoCountAmounts) < 0){
							currentRowPay = itemBalance;
						}else{
							currentRowPay = parseFloat(autoCountAmounts) > parseFloat(itemBalance) ? parseFloat(itemBalance) : parseFloat(autoCountAmounts);
						}				
						autoCountAmounts -= currentRowPay;
						itemAmounts.val(parseFloat(currentRowPay));
						checkboxObj.attr('checked', true);//设置为选择状态
					} */
					
					/* currentRowPay = autoCountAmounts > parseFloat(itemBalance) ? itemBalance : autoCountAmounts-itemBalance; */
				})
				
				//计算合计
				var checkSumAmounts = 0;
				$("input[name='itemAmounts']").each(function (i, o) {
					checkSumAmounts += parseFloat(o.value);
				});
				
				$("#sumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
			}else {
				alert('请输入计算金额！');
				obj.checked = false;
			}
		}
	} else {
		tbOrderObj.each(function () { // 循环计算
			var checkboxObj = $(this).find("input[type='checkbox']"); // 选择框
			var itemAmounts = $(this).find("input[name='itemAmounts']");
			itemAmounts.val(0);
			checkboxObj.attr('checked', false);
			
		});
	}
	
	
}
/* 鼠标移开事件：合计金额（下账金额） */
function itemAmountsChange(){
	//计算合计
	var checkSumAmounts = 0;
	$("input[name='itemAmounts']").each(function (i, o) {
		checkSumAmounts += parseFloat(o.value);
	});
	
	$("#sumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
}
/* 选择复选框时将未付金额带入下账金额中 */
function checkboxChange(obj){
	var itemAmounts = $(obj).parent().parent().find("input[name='itemAmounts']");
	if ($(obj).is(':checked')) {
		// 下账金额
		if (itemAmounts.val() == 0) {
			itemAmounts.val($(obj).parent().parent().find("input[name='itemBalance']").val());
		}

	} else {
		itemAmounts.val(0); // 单行未选中 下账金额修改为0
	}
	//计算合计
	var checkSumAmounts = 0;
	$("input[name='itemAmounts']").each(function (i, o) {
		checkSumAmounts += parseFloat(o.value);
	});
	
	$("#sumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
}

/* 全选功能 */
function checkAll(ckbox){
	if($(ckbox).attr("checked")){
		$("input[type='checkbox']").each(function(){
			$(this).attr("checked","checked");
			$('#tbOrderObj tr').each(function () {
				//获取选择的orderID
				var checkboxObj = $(this).find("input[type='checkbox']");
				//获取选择的未付金额
				var itemBalance = parseFloat($(this).find("input[name='itemBalance']").val()); // 未付金额
				var itemAmounts = $(this).find("input[name='itemAmounts']"); //下账金额
				
					itemAmounts.val(itemBalance);
				
				
			});
			
		});
	}else{
		$("input[type='checkbox']").removeAttr("checked");
		$('#tbOrderObj tr').each(function () {
			//获取选择的orderID
			var checkboxObj = $(this).find("input[type='checkbox']");
			//获取选择的未付金额
			var itemBalance = parseFloat($(this).find("input[name='itemBalance']").val()); // 未付金额
			var itemAmounts = $(this).find("input[name='itemAmounts']"); //下账金额
			itemAmounts.val(0);
		});
	}
	//计算合计
	var checkSumAmounts = 0;
	$("input[name='itemAmounts']").each(function (i, o) {
		checkSumAmounts += parseFloat(o.value);
	});
	
	$("#sumAmounts").html(Math.round(parseFloat(checkSumAmounts) * 100) / 100);
	/* trigger() 方法触发被选元素的指定事件类型。 */
	$("input[type='checkbox']").trigger("onchange");
}


</script>
<jsp:include page="/WEB-INF/include/page-center.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

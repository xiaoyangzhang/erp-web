<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String staticPath = request.getContextPath();
%>
<div style="height:320px;overflow-y:auto;">
	<table cellspacing="0" cellpadding="0" class="w_table">
		<c:if test="${reqpm.supType eq 1}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="20%"/>
			<col width="8%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>
		<c:if test="${reqpm.supType eq 6}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="19%"/>
			<col width="19%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>
		<c:if test="${reqpm.supType eq 12}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="20%"/>
			<col width="8%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>

		<thead>
		<tr>
			<th><input type="checkbox" onclick="checkAll(this)"/>全选</th>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			
			<c:if test="${reqpm.supType eq 1}">
				<th>接站牌<i class="w_table_split"></i></th>
				<th>人数<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 6}">
				<th>明细<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 12}">
				<th>方式<i class="w_table_split"></i></th>
				<th>明细<i class="w_table_split"></i></th>
			</c:if>
			
			<th>计调<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>下账金额<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
		</tr>
		</thead>
		<tbody id="tbObj">
		
		<c:set var="sumTotal" value="0"/>
		<c:set var="sumTotalCash" value="0"/>
		<c:set var="sumBalanceCash" value="0"/>
		
		<c:forEach items="${pageBean.result}" var="order" varStatus="status">
			<tr>
				<td><input type="checkbox" sid="${order.id}" groupCode="${order.group_code}"
				           onchange="chk(this,'${order.id}','${order.group_code}')"/>
				</td>
				<td class="serialnum">${status.index+1}</td>
				
				<td>
					<c:if test="${order.group_mode <= 0}">
						<a class="def" href="javascript:void(0)"
						   onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a>
					</c:if>
					<c:if test="${order.group_mode > 0}">
						<a href="javascript:void(0);" class="def"
						   onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${order.group_id}&operType=0')">${order.group_code}</a>
					</c:if>
				</td>
				<td>【${order.product_brand_name}】${order.product_name}</td>
				
				<c:if test="${reqpm.supType eq 1}">
					<td>${order.receive_mode }</td>
					<td>${order.num_adult }大${order.num_child }小</td>
				</c:if>
				<c:if test="${reqpm.supType eq 6}">
					<td>${order.details}</td>
				</c:if>
				<c:if test="${reqpm.supType eq 12}">
					<td>${order.cash_type}</td>
					<td>${order.details}</td>
				</c:if>
				
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
						<input type="hidden" name="itemBalance" value="0"/>
					</c:if>
				</td>
				<td><label id="itemAmounts">0</label></td>
				<td>
					<c:if test="${order.state_seal eq 1}">已封存</c:if>
					<c:if test="${order.state_seal eq 0}">
						<c:if test="${order.state_finance ne 1}">未审核</c:if>
						<c:if test="${order.state_finance eq 1}">已审核</c:if>
					</c:if>
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
		<tr>
			<td></td>
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

			<td>合计：</td>
			<td><fmt:formatNumber value="${sumTotal}" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumTotalCash}" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sumBalanceCash}" pattern="#.##"/></td>
			<td><label id="sumAmounts">0</label></td>
			<td></td>
		</tr>
		</tbody>
	</table>
</div>
<div style="overflow-y:scroll;">
	<table cellspacing="0" cellpadding="0" class="w_table">
		<c:if test="${reqpm.supType eq 1}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="20%"/>
			<col width="8%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>
		<c:if test="${reqpm.supType eq 6}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="19%"/>
			<col width="19%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>
		<c:if test="${reqpm.supType eq 12}">
			<col width="5%"/>
			<col width="4%"/>
			<col width="14%"/>
			<col width="20%"/>
			<col width="8%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="9%"/>
		</c:if>
		<thead></thead>
		<tbody>
		<tr>
			<td colspan="4">下账金额：<input type="text" id="amounts" value="0"/> 元
				<input id="cbAmounts" type="checkbox" onclick="computeAmounts(this);"/>选择
			</td>
			<td>选中合计：</td>
			<td><label id="checkSumTotal">0</label></td>
			<td><label id="checkSumTotalCash">0</label></td>
			<td><label id="checkSumBalance">0</label></td>
			<td><label id="checkSumAmounts">0</label></td>
			<td></td>
		</tr>
		</tbody>
	</table>
</div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>
<script>
	// 计算下账金额
	function computeAmounts(obj) {
		var amounts = parseFloat($("#amounts").val()); // 下账金额
		var tbObj = $('#tbObj tr'); // 列表

		if (obj.checked) {
			if (isNaN(amounts)) {
				alert('下账金额输入有误，请检查后重新输入！');
				obj.checked = false;
			} else {
				if (amounts != 0) {
					tbObj.each(function () { // 循环计算
						var checkboxObj = $(this).find("input[type='checkbox']"); // 选择框
						var itemBalance = parseFloat($(this).find("input[name='itemBalance']").val()); // 未收金额
						var itemAmounts = $(this).find("label[id='itemAmounts']");
						if (amounts == 0) return;
						
						
						var isAdd = false;
						if (amounts > 0 && parseFloat(itemBalance) > 0) {
							itemBalance = amounts > parseFloat(itemBalance) ? itemBalance : amounts;
							amounts -= itemBalance;
							isAdd = true;
						}
						if (amounts < 0 && parseFloat(itemBalance) < 0) {
							itemBalance = amounts < parseFloat(itemBalance) ? itemBalance : amounts;
							amounts -= itemBalance;
							isAdd = true;
						}
						if (isAdd){
							itemAmounts.html(itemBalance);
							checkboxObj.attr('checked', true);
							chk(checkboxObj, checkboxObj.attr('sid'), checkboxObj.attr('groupCode'));
						}
					});
				} else {
					alert('请输入下账金额！');
					obj.checked = false;
				}
			}
		} else {
			tbObj.each(function () { // 循环计算
				var checkboxObj = $(this).find("input[type='checkbox']"); // 选择框
				var itemAmounts = $(this).find("label[id='itemAmounts']");
				itemAmounts.html(0);
				checkboxObj.attr('checked', false);
				chk(checkboxObj, checkboxObj.attr('sid'), checkboxObj.attr('groupCode'));
			});
		}
	}
</script>
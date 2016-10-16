<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>

<c:set var="canUpdate" value="${reqpm.groupState ne 4 and reqpm.groupState ne 3}" />

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="25%" />
	<col width="15%" />
	<col width="7%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<c:if test="${empty reqpm.isShow }">	
		<col width="6.6%" />
		<col width="6.6%" />
		<col width="6.6%" />
		<c:if test="${canUpdate}">
			<col width="5%" />
			<col width="5%" />
		</c:if>
		<c:if test="${!canUpdate}">
			<col width="10%" />
		</c:if>
	</c:if>
	<c:if test="${not empty reqpm.isShow }">	
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家<i class="w_table_split"></i></th>
			<th>消费金额<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>商品名称<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
			<c:if test="${empty reqpm.isShow }">
				<th>操作<i class="w_table_split"></i></th>
				<c:if test="${canUpdate}">
				<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
				</c:if>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="shop" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${shop.supplier_name}</td>
				<td>
					<c:if test="${not empty shop.total_face}">
						<fmt:formatNumber value="${shop.total_face}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty shop.total_face}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty shop.total_repay}">
						<fmt:formatNumber value="${shop.total_repay}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty shop.total_repay}">0</c:if>
				</td>
				<td>
					${shop.guide_name}
				</td>
				<td>
					<c:if test="${not empty shop.total}">
						<fmt:formatNumber value="${shop.total}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty shop.total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty shop.total_cash}">
						<fmt:formatNumber value="${shop.total_cash}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty shop.total_cash}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty shop.balance}">
						<fmt:formatNumber value="${shop.balance}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty shop.balance}">0</c:if>
				</td>
				<td colspan="3">${shop.details}</td>
				<c:if test="${empty reqpm.isShow }">
					<td>
						<c:if test="${!canUpdate or shop.state_finance eq 1 }">
							<a class="def" href="javascript:void(0)" onclick="showDetailShop({booking_id:'${shop.id}'})">查看</a>
						</c:if>
						<c:if test="${canUpdate  and shop.state_finance ne 1 }">
							<a class="def" href="javascript:void(0)" onclick="newWindow('修改消费','<%=path%>/bookingFinanceShop/toFactShop.htm?id=${shop.id}&groupId=${reqpm.groupId }')">修改</a>
						</c:if>
					</td>
					<c:if test="${canUpdate}">
						<td><input type="checkbox" name="audit_id" value="${shop.id}" ${not empty shop.audit_time?'checked':''} />审核</td>
					</c:if>
				</c:if>
			</tr>
			<c:set var="sum_total" value="${sum_total+shop.total }" />
			<c:set var="sum_cash" value="${sum_cash+shop.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+shop.balance }" />
		</c:forEach>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>合计:</td>
			<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_balance }" pattern="#.##"/></td>
			<td></td>
			<td></td>
			<td></td>
			<c:if test="${empty reqpm.isShow }">
				<td></td>
				<c:if test="${canUpdate}">
				<td></td>
				</c:if>
			</c:if>
		</tr>
	</tbody>
</table>
<div id="popDetailTableDiv" style="display: none"></div>
<script type="text/javascript">

	function showDetailShop(o) {
		var data = {};
		data.bookingId = o.booking_id;
		data.sl = "fin.selectShopDetailList";
		data.rp = "finance/audit/income-shop-listViewDetail";
		$("#popDetailTableDiv").load("../common/queryList.htm", data);
		
		layer.open({
			type : 1,
			title : '订单明细',
			closeBtn : false,
			area : [ '1000px', '500px' ],
			shadeClose : false,
			content : $("#popDetailTableDiv"),
			btn : ['取消' ],
			yes : function(index) {
				layer.close(index);
			}
		});
	}
</script>
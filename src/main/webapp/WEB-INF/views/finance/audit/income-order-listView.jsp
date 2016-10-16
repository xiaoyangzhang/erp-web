<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>

<c:set var="canUpdate" value="${reqpm.groupState ne 4 and reqpm.groupState ne 3}" />

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="7%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<c:if test="${empty reqpm.isShow }">
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<c:if test="${canUpdate}">
			<col width="5%" />
			<col width="5%" />
		</c:if>
		<c:if test="${!canUpdate}">
			<col width="10%" />
		</c:if>
		<c:set var="colspanCount" value="7" />
	</c:if>
	<c:if test="${not empty reqpm.isShow }">
		<col width="6.6%" />
		<col width="6.6%" />
		<col width="6.6%" />
		<col width="6.6%" />
		<col width="6.6%" />
		<col width="6.6%" />
		<c:set var="colspanCount" value="6" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已收<i class="w_table_split"></i></th>
			<th>未收<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<c:if test="${empty reqpm.isShow }">
				<th>审核<i class="w_table_split"></i></th>
				<th>操作<i class="w_table_split"></i></th>
				<c:if test="${canUpdate}">
					<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
				</c:if>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="order" varStatus="status">
			<tr>
				<td class="serialnum">
					<div class="serialnum_btn" subId="${order.id}"></div> ${status.index+1}
				</td>
				<td>${order.supplier_name}</td>
				<td>${order.sale_operator_name}</td>
				<td>${order.receive_mode}<br/>${order.province_name}${order.city_name}</td>
				<td>
					<c:if test="${not empty order.num_adult}">${order.num_adult}大</c:if><c:if test="${not empty order.num_child}">${order.num_child}小</c:if><c:if test="${not empty order.num_guide}">${order.num_guide}陪</c:if>
				</td>
				<td><fmt:formatNumber value="${order.total }" pattern="#.##"/></td>
				<td>
					<c:if test="${not empty order.total_cash}">
						<fmt:formatNumber value="${order.total_cash }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty order.total_cash}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty order.balance}">
						<fmt:formatNumber value="${order.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty order.balance}">0</c:if>
				</td>
				<td colspan="${colspanCount}" >${order.details }</td>
				<c:if test="${empty reqpm.isShow }">
					<td>
						<c:if test="${order.state_finance eq 1 }">
							<a class="def" href="javascript:void(0)" onclick="showDetailOrder({id:'${order.id}'})">查看</a>
						</c:if>
						<c:if test="${canUpdate and order.state_finance ne 1 }">
							<!-- 散客订单 -->
							<c:if test="${order.order_type eq 0 and optMap['CWGL_JSDSH_EDIT']}">
								<c:if test="${empty order.priceId }">
									<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','fitOrder/toEditFirOrder.htm?orderId=${order.id}&operType=1')">编辑</a>
								</c:if>
								<c:if test="${!empty order.priceId }">
									<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${order.id}')">编辑</a>
								</c:if>
							</c:if>
							<!-- 定制订单 -->
							<c:if test="${order.order_type eq 1 and optMap['CWGL_JSDSH_EDIT']}">
								<a class="def" href="javascript:void(0)" 
									onclick="newWindow('编辑订单','<%=path%>/teamGroup/toEditTeamGroupInfo.htm?groupId=${reqpm.groupId }&operType=1')">修改</a>
							</c:if>		
							<!-- 一地散订单 -->	
							<c:if test="${order.order_type eq -1 and optMap['CWGL_JSDSH_EDIT']}">
								<a class="def" href="javascript:void(0)" 
									onclick="newWindow('编辑订单','<%=path%>/specialGroup/toEditSpecialGroup.htm?id=${order.id }')">修改</a>
							</c:if>
						</c:if>
					</td>
					<c:if test="${canUpdate && optMap['CWGL_JSDSH_AUDIT']}">
					<td>
						<input type="checkbox" name="audit_id" value="${order.id}" 
							${not empty order.audit_time?'checked':''} 
						/>审核
					</td>
					</c:if>
				</c:if>
			</tr>
			<c:set var="sum_total" value="${sum_total+order.total }" />
			<c:set var="sum_cash" value="${sum_cash+order.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+order.balance }" />
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
			<td></td>
			<td></td>
			<td></td>
			<c:if test="${empty reqpm.isShow }">
				<td></td>
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
	/**
	$(".serialnum div").bind("click", function() {
		var data = {};
		data.sl = "fin.selectOrderDetailList";
		data.rp = "finance/audit/income-order-listViewDetail";
		divExpand(this, $(this).attr("subId"), data);
	});
	**/
	
	function showDetailOrder(o) {
		
		var data = {};
		data.subId = o.id;
		data.mode = 0;
		data.sl = "fin.selectOrderDetailList";
		data.rp = "finance/audit/income-order-listViewDetail";
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

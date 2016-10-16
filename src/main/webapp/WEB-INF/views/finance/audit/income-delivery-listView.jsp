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
	<col width="10%" />
	<col width="7%" />
	<col width="7%" />
	<col width="8%" />
	<c:if test="${empty reqpm.isShow }">
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
	</c:if>
	<c:if test="${empty reqpm.isShow }">
		<col width="8.3%" />
		<col width="8.3%" />
		<col width="8.3%" />
		<col width="8.3%" />
		<col width="8.3%" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付<i class="w_table_split"></i></th>
			<th>未付<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<c:if test="${empty reqpm.isShow }">
				<th>操作<i class="w_table_split"></i></th>
				<c:if test="${canUpdate}">
				<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
				</c:if>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="del" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${del.supplier_name}</td>
				<td>${del.create_date}</td>
				<td>
					<c:if test="${not empty del.total}">
						<fmt:formatNumber value="${del.total}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty del.total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty del.total_cash}">
						<fmt:formatNumber value="${del.total_cash}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty del.total_cash}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty del.balance}">
						<fmt:formatNumber value="${del.balance}" pattern="#.##"/>
					</c:if>
					<c:if test="${empty del.balance}">0</c:if>
				</td>
				<td colspan="6" >${del.details}</td>
				<c:if test="${empty reqpm.isShow }">
					<td>
						<c:if test="${del.state_finance eq 1 }">
							<a class="def" href="javascript:void(0)" onclick="showDetailDel({booking_id:'${del.id}'})">查看</a>
						</c:if>
						<c:if test="${canUpdate and del.state_finance ne 1  and optMap['CWGL_JSDSH_EDIT']}">
							<a class="def" href="javascript:void(0)" onclick="newWindow('修改下接社订单','<%=path%>/booking/delivery.htm?gid=${reqpm.groupId }&bid=${del.id}')">修改</a>
							<c:if test="${empty del.totalCash || del.totalCash.compareTo(0) eq 0}">
								<a class="def" href="javascript:void(0)" onclick="agencyDelete(this, ${del.id })">删除</a>
							</c:if>
						</c:if>
					</td>
					<c:if test="${canUpdate && optMap['CWGL_JSDSH_AUDIT']}">
					<td>
						<input type="checkbox" name="audit_id" value="${del.id}" 
							${not empty del.audit_time?'checked':''}
							<c:if test="${not empty del.total_cash and del.total_cash ne '0.0000'}">
								disabled="disabled"
							</c:if>
						/>审核
					</td>
					</c:if>
				</c:if>
			</tr>
			<c:set var="sum_total" value="${sum_total+del.total }" />
			<c:set var="sum_cash" value="${sum_cash+del.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+del.balance }" />
		</c:forEach>
		<tr>
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
				<c:if test="${canUpdate}">
				<td></td>
				</c:if>
			</c:if>
		</tr>
	</tbody>
</table>
<div id="popDetailTableDiv" style="display: none"></div>
<script type="text/javascript">

	function showDetailDel(o) {
		var data = {};
		data.bookingId = o.booking_id;
		data.sl = "fin.selectDeliveryDetailList";
		data.rp = "finance/audit/income-delivery-listViewDetail";
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
	
	function agencyDelete(obj,id){
		$.post("<%=path%>/booking/agencyDelele.do",{id:id},function(data){
			if(data.success){
				window.location.reload();
				$.info('删除成功！');
			}else{
				$.info(data.msg);
			}
		},"json");
	}
</script>
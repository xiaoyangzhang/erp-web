<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<c:set var="l1" value="成本"></c:set>
<c:set var="l2" value="已付"></c:set>
<c:set var="l3" value="未付"></c:set>
<c:if test="${reqpm.feeType eq 'otherin'}">
<c:set var="l1" value="金额"></c:set>
<c:set var="l2" value="已收"></c:set>
<c:set var="l3" value="未收"></c:set>
</c:if>

<c:set var="canUpdate" value="${reqpm.groupState ne 4 and reqpm.groupState ne 3}" />

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="15%" />
	<col width="6%" />
	<col width="4%" />
	<col width="4%" />
	<col width="4%" />
	<col width="4%" />
	<col width="5%" />
	<col width="5%" />
	<c:if test="${empty reqpm.isShow }">
		<c:if test="${reqpm.supType ne 3 and reqpm.supType ne 120 and reqpm.supType ne 121 }">
			<c:set var="colspanValue" value="5" />
			<col width="6%" />
			<col width="6%" />
			<col width="6%" />
			<col width="6%" />
			<col width="6%" />
		</c:if>
		<c:if test="${reqpm.supType eq 3}">
			<c:set var="colspanValue" value="6" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
		</c:if>
		<c:if test="${reqpm.supType eq 120 or reqpm.supType eq 121 }">
			<c:set var="colspanValue" value="3" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
		</c:if>
		<col width="10%" />
		<c:if test="${canUpdate}">
			<col width="5%" />
			<col width="5%" />
		</c:if>
		<c:if test="${!canUpdate}">
			<col width="10%" />
		</c:if>
	</c:if>
	<c:if test="${not empty reqpm.isShow }">
		<c:if test="${reqpm.supType ne 3 and reqpm.supType ne 120 and reqpm.supType ne 121 }">
			<c:set var="colspanValue" value="5" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
		</c:if>
		<c:if test="${reqpm.supType eq 3}">
			<c:set var="colspanValue" value="6" />
			<col width="6.6%" />
			<col width="6.6%" />
			<col width="6.6%" />
			<col width="6.6%" />
			<col width="6.6%" />
			<col width="6.6%" />
		</c:if>
		<c:if test="${reqpm.supType eq 120 or reqpm.supType eq 121 }">
			<c:set var="colspanValue" value="3" />
			<col width="13.3%" />
			<col width="13.3%" />
			<col width="13.3%" />
		</c:if>
		<col width="10%" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>商家<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>${l1 }<i class="w_table_split"></i></th>
			<th>${l2 }<i class="w_table_split"></i></th>
			<th>${l3 }<i class="w_table_split"></i></th>
			<th>方式<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>报账金额<i class="w_table_split"></i></th>
			<c:if test="${reqpm.supType ne 3 and reqpm.supType ne 4 and reqpm.supType ne 120 and reqpm.supType ne 121 }">
				<th>日期<i class="w_table_split"></i></th>
				<th>项目<i class="w_table_split"></i></th>
				<th>价格<i class="w_table_split"></i></th>
				<th>数量<i class="w_table_split"></i></th>
				<th>免去数<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 3 }">
				<th>日期<i class="w_table_split"></i></th>
				<th>项目<i class="w_table_split"></i></th>
				<th>价格<i class="w_table_split"></i></th>
				<th>数量<i class="w_table_split"></i></th>
				<th>免去数<i class="w_table_split"></i></th>
				<th>摘要<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 4 }">
				<th>车型<i class="w_table_split"></i></th>
				<th>座位数<i class="w_table_split"></i></th>
				<th>车牌号<i class="w_table_split"></i></th>
				<th>司机<i class="w_table_split"></i></th>
				<th>联系方式<i class="w_table_split"></i></th>
			</c:if>
			<c:if test="${reqpm.supType eq 120 or reqpm.supType eq 121}">
				<th>项目<i class="w_table_split"></i></th>
				<th>价格<i class="w_table_split"></i></th>
				<th>数量<i class="w_table_split"></i></th>
			</c:if>
			<th>备注<i class="w_table_split"></i></th>
			<c:if test="${empty reqpm.isShow }">
				<th>操作<i class="w_table_split"></i></th>
				<c:if test="${canUpdate}">
				<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
				</c:if>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${list}" var="sup" varStatus="status">
			<tr>
				<td class="serialnum">${status.index+1}</td>
				<td>${sup.supplier_name}</td>
				<td>${sup.booking_date}</td>
				<td>
					<c:if test="${not empty sup.total}">
						<fmt:formatNumber value="${sup.total }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty sup.total}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty sup.total_cash}">
						<fmt:formatNumber value="${sup.total_cash }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty sup.total_cash}">0</c:if>
				</td>
				<td>
					<c:if test="${not empty sup.balance}">
						<fmt:formatNumber value="${sup.balance }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty sup.balance}">0</c:if>
				</td>
				<td>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] eq true}">
						<c:if test="${empty reqpm.isShow }">
							<select name="cashType" id="cashType">
							<c:forEach items="${cashTypes }" var="type">
								<option <c:if test="${sup.cash_type eq type.value }">selected</c:if>  >${type.value }</option>
							</c:forEach>
							</select>
						</c:if>
						<c:if test="${not empty reqpm.isShow }">${sup.cash_type}</c:if>
					</c:if>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] ne true}">
						${sup.cash_type}
					</c:if>
				</td>
				<td>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] eq true}">
						<c:if test="${empty reqpm.isShow }">
							<c:set var="disabled" value="" />
							<c:if test="${sup.pay_status eq 1 }">
								<c:set var="disabled" value="disabled='disabled'" />
							</c:if>
							<select name="bookingId" style="width:95%;" ${disabled } >
								<option value=""></option>
								<c:forEach items="${bookingGuides}" var="booking">
									<option value="${booking.id}" 
										<c:if test="${booking.id eq sup.booking_id }">selected="selected"</c:if> 
									>${booking.guideName}</option>
								</c:forEach>
							</select>
						</c:if>
						<c:if test="${not empty reqpm.isShow }">
							<c:forEach items="${bookingGuides}" var="booking">
								<c:if test="${booking.id eq sup.booking_id }">${booking.guideName}</c:if> 
							</c:forEach>
						</c:if>
					</c:if>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] ne true}">
						<select name="bookingId" style="width:95%;" disabled='disabled' >
							<option value=""></option>
							<c:forEach items="${bookingGuides}" var="booking">
								<option value="${booking.id}" 
									<c:if test="${booking.id eq sup.booking_id }">selected="selected"</c:if> 
								>${booking.guideName}</option>
							</c:forEach>
						</select>
					</c:if>
				</td>
				<td>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] eq true}">
						<c:if test="${empty reqpm.isShow }">
							<input name="financeTotal" value="<fmt:formatNumber value="${sup.finance_total}" pattern="#.##"/>" 
							${disabled } type="text" style="width:85%;height:25px"/>
						</c:if>
						<c:if test="${not empty reqpm.isShow }"><fmt:formatNumber value="${sup.finance_total}" pattern="#.##"/></c:if>
					</c:if>
					<c:if test="${optMap['CWGL_JSDSH_EDIT'] ne true}">
						<fmt:formatNumber value="${sup.finance_total}" pattern="#.##"/>
					</c:if>
				</td>
				<td colspan="${colspanValue }" >${sup.details}</td>
				<td>${sup.remark}</td>
				<c:if test="${empty reqpm.isShow }">
					<td>
						<c:if test="${sup.state_finance eq 1 }">
							<a class="def" href="javascript:void(0)" onclick="showDetailSup({order_id:'${sup.id}',supplier_type:'${sup.supplier_type }'})">查看</a>
						</c:if>
						<c:if test="${canUpdate and sup.state_finance ne 1 and optMap['CWGL_JSDSH_EDIT']}">
							<a class="def" href="javascript:void(0)" onclick="editSupplier(${sup.id}, ${reqpm.groupId}, ${reqpm.supType})">修改</a>
							<c:if test="${empty sup.totalCash || sup.totalCash.compareTo(0) eq 0}">
								<a class="def" href="javascript:void(0)" onclick="delSupplier(${sup.id})">删除</a>
							</c:if>
						</c:if>
					</td>
					<c:if test="${canUpdate && optMap['CWGL_JSDSH_AUDIT']}">
					<td>
						<input type="hidden" name="groupId" value="${sup.group_id }" />
						<input type="hidden" name="supplierType" value="${sup.supplier_type }" />
						<input type="checkbox" name="audit_id" value="${sup.id}" 
							${sup.state_finance eq 1 ? 'checked':''}
							<c:if test="${(not empty sup.total_cash and sup.total_cash ne '0.0000') or sup.pay_status eq 1 }">
								disabled="disabled"
							</c:if>
						/>审核
					</td>
					</c:if>
				</c:if>
			</tr>
			<c:set var="sum_total" value="${sum_total+sup.total }" />
			<c:set var="sum_cash" value="${sum_cash+sup.total_cash }" />
			<c:set var="sum_balance" value="${sum_balance+sup.balance }" />
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
			<c:forEach begin="1" end="${colspanValue }" >
			<td></td>
			</c:forEach> 
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
<form id="delSupplierForm"></form>
<div id="popDetailTableDiv" style="display: none"></div>
<script type="text/javascript">

	function showDetailSup(o) {
		
		var data = {};
		data.orderId = o.order_id;
		data.supplierType = o.supplier_type;
		data.payDirect = 0;
		data.sl = "fin.selectPayOrderDetailList";
		data.rp = "finance/record/pay-detail-list-table";
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
	
	//给新增按钮添加链接
	function editSupplier(orderId, groupId, supType){
		
		var title = "";
		var addUrl = "";
	 	// 餐厅
	    if(supType == 2){
	    	title = "修改餐饮订单";
			addUrl = "<%=path%>/booking/toAddEat?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 酒店
	    else if(supType == 3){
	    	title = "修改酒店订单";
	    	addUrl = "<%=path%>/booking/toAddHotel?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 车队
	    else if(supType == 4){
	    	title = "修改车辆订单";
	    	addUrl = "<%=path%>/booking/toAddCar?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 景区
	    else if(supType == 5){
	    	title = "修改门票订单";
	    	addUrl = "<%=path%>/booking/toAddSight?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 娱乐
	    else if(supType == 7){
	    	title = "修改娱乐订单";
			addUrl = "<%=path%>/booking/toAddFun?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 导游
	    else if(supType == 8){
	    	title = "安排导游";
	    }
	 	// 机票
	    else if(supType == 9){
	    	title = "修改机票订单";
	    	addUrl = "<%=path%>/booking/toAddAirTicket?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 火车票
	    else if(supType == 10){
	    	title = "修改火车票订单";
	    	addUrl = "<%=path%>/booking/toAddTrainTicket?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 高尔夫
	    else if(supType == 11){
	    	title = "修改高尔夫订单";
	    	addUrl = "<%=path%>/booking/toAddGolf?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 保险
	    else if(supType == 15){
	    	title = "修改保险订单";
	    	addUrl = "<%=path%>/booking/toAddInsurance?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 其它支出
	    else if(supType == 121){
	    	title = "修改支出";
	    	addUrl = "<%=path%>/booking/editOutcome.htm?groupId="+ groupId +"&bookingId="+ orderId;
	    }
	 	// 其它收入
	    else if(supType == 120){
	    	title = "修改收入";
	    	addUrl = "<%=path%>/booking/editIncome.htm?groupId="+ groupId +"&bookingId="+ orderId;
	    }
		newWindow(title, addUrl);
	}
	
	
	function delSupplier(id){
		
		$.confirm('你确定要删除该订单吗？', function(){
			var options={
					url:"<%=path%>/booking/delBookingSupplier.do",
					type:"post",
					dataType:"json",
					async:false,
					data:{
						bookingId:id
					},
					success:function(data){
						if(data.success){
							$.success("删除成功",function(){
								window.location.reload();
							});
						}
						else{
							$.error(data.msg);
						}
					},
					error:function(){
						$.error("服务器忙，请稍后再试.....");
					}
				};
				$("#delSupplierForm").ajaxSubmit(options);
		});
	}
</script>

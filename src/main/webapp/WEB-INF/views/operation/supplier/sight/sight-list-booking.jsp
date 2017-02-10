<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../../../../include/path.jsp" %>

<div class="in_tab mb-30">
	<p class="in_tab_title"><b>门票订单</b></p>
	<dl class="p_paragraph_content">
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="10%" />
			<col width="8%" />
			<col width="15%" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
			<col width="" />
			<col width="6%" />
			<thead>
			<tr>
				<!-- <th>订单号</th> -->
				<th>下单时间</th>
				<th>预订员</th>
				<th>景区</th>
				<th>结算方式</th>
				<th>状态</th>
				<th>金额</th>
				<th>订单明细</th>
				<th>操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${bookingInfo.bookingList  }" var="booking">
				<tr>
						<%-- <td>${booking.bookingNo }</td> --%>
					<td><fmt:formatDate value="${booking.bookingDate }"
										pattern="yyyy-MM-dd" /></td>
					<td>${booking.userName }</td>
					<td style="text-align: left">${booking.supplierName }</td>
					<td>${booking.cashType }</td>
					<td class="state"><c:choose>
						<c:when test="${booking.stateFinance==1 }">财务已确认</c:when>
						<c:otherwise>
							<c:if test="${booking.stateBooking==0 }">景区未确认</c:if>
							<c:if test="${booking.stateBooking==1 }">景区已确认</c:if>
							<c:if test="${booking.stateBooking==2 }">变更</c:if>
						</c:otherwise>
					</c:choose></td>
					<td><c:choose>
						<c:when test="${booking.total eq null  }">0</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${booking.total }" pattern="#.##"
											  type="currency" />
						</c:otherwise>
					</c:choose></td>
					<td><c:if
							test="${booking.detailList!=null and fn:length(booking.detailList)>0 }">
						<table class="in_table">
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<c:forEach var="detail" items="${booking.detailList }">
								<tr>
									<td><fmt:formatDate value="${detail.itemDate }"
														pattern="yyyy-MM-dd" /></td>
									<td>${detail.type1Name }</td>
									<td><fmt:formatNumber value="${detail.itemPrice }"
														  pattern="#.##" type="currency" />* <c:choose>
										<c:when
												test="${detail.itemNumMinus ne null and detail.itemNumMinus ne 0 }">
											(<fmt:formatNumber value="${detail.itemNum }"
															   pattern="#.##" type="currency" />
											-<fmt:formatNumber value="${detail.itemNumMinus }"
															   pattern="#.##" type="currency" />
											)
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${detail.itemNum }"
															  pattern="#.##" type="currency" />
										</c:otherwise>
									</c:choose></td>
									<td><fmt:formatNumber value="${detail.itemTotal }"
														  pattern="#.##" type="currency" /></td>
								</tr>
							</c:forEach>
						</table>
					</c:if></td>
					<td>
						<div class="tab-operate">
							<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
							<div class="btn-hide" id="asd">
								<a class="def" href="javascript:void(0)"
								   onclick="newWindow('查看门票订单','<%=ctx %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId }&isShow=${isShow }')">查看</a>
								<c:if
										test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0 }">
									<a class="def" href="javascript:void(0)"
									   onclick="confirmState(this,${booking.id })">确认</a>
								</c:if> <a class="def" href="javascript:void(0)"
										   onclick="printOrder(${booking.id})">打印</a> <c:if
									test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) }">
								<a class="def" href="javascript:void(0)"
								   onclick="newWindow('修改门票订单','<%=ctx %>/booking/toAddSight?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId }&isShow=${isShow }')">修改</a>
							</c:if> <c:if test="${optMap['EDIT'] && booking.canDelete==true}">
								<a class="def" href="javascript:void(0)"
								   onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
							</c:if>
							</div>
						</div>
					</td>
				</tr>
				<c:set var="sum_price" value="${sum_price+booking.total}" />
			</c:forEach>
			</tbody>
			<tfoot>
			<tr>
				<td colspan="5" style="text-align: right">合计</td>
				<td><fmt:formatNumber value="${sum_price }" pattern="#.##"
									  type="currency" /></td>
				<td colspan="2"></td>
			</tr>
			</tfoot>
		</table>
	</dl>
</div>
<script type="text/javascript">
	function del(obj,id,type){
		var r=window.confirm("是否删除该订单？");
		if(r){
			$.ajax({
				url:"delBookingSupplier.do",
				type:"post",
				dataType:"json",
				async:false,
				data:{
					bookingId:id

				},
				success:function(data){
					if(data.success){
						$.success("删除成功",function(){
							//		$(obj).parent().parent().remove();
							queryList($("input[name='page']").val(),$("input[name='pageSize']").val());
						});

					}
					else{
						$.error(data.msg);
					}
				},
				error:function(){
					$.error("服务器忙，请稍后再试");
				}
			})
		}
	}
	function confirmState(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
			if(data.success){
				$(obj).hide();
				$(obj).parent().prev(".state").html("景区已确认");
				$.info('确认成功！');
			}else{
				$.info(data.msg);
			}
		},"json");
	}
	function printOrder(id){
		location.href="download.htm?bookingId="+id ; //供应商确认订单

	}
</script>
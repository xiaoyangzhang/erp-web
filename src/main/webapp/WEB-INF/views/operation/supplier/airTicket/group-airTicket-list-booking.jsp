<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

 <%@ include file="/WEB-INF/include/top.jsp" %>
<div class="p_container">
	<p class="p_paragraph_title" style="margin: 0;">
		<b>需求订单</b>
	</p>
	<dl class="p_paragraph_content">
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="20%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="15%" />
			<col width="5%" />
			<col width="10%" />
			<thead>
				<tr>

					<th rowspan="1">客户名称</th>
					<th rowspan="1">日期</th>
					<th rowspan="1">出发地</th>
					<th rowspan="1">目的地</th>
					<th rowspan="1">班次</th>
					<th rowspan="1">接站牌</th>
					<th rowspan="1">数量</th>
					<th rowspan="1">备注</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${bookingInfo.requirementInfos }" var="info">
					<tr>

						<td style="text-align: left">${info.nameFull }</td>
						<td>${info.requireDate }</td>
						<td>${info.cityDeparture }</td>
						<td>${info.cityArrival }</td>
						<td>${info.classNo }</td>
						<td>${info.receiveMode }</td>
						<td>${info.countRequire }</td>
						<td>${info.remark }</td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
	</dl>
	<p class="p_paragraph_title" style="margin: 0;">
		<b>飞机票安排</b>
		<c:if test="${optMap['YDAP_AIR'] and groupCanEdit }">
			<a class="button button-primary button-small"
				href="javascript:void(0)"
				onclick="newWindow('新增机票订单','<%=ctx %>/booking/toAddAirTicket?groupId=${groupId }')">新增</a>&nbsp;&nbsp;&nbsp;</c:if>
		<a class="button button-primary button-small"
			href="javascript:void(0)" onclick="refresh()">刷新</a>
	</p>
	<dl class="p_paragraph_content">
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="8%" />
			<thead>
				<tr>
					<th>订单号</th>
					<th>下单时间</th>
					<th>预订员</th>
					<th>商家名称</th>
					<th>导游</th>
					<th>结算方式</th>
					<th>金额</th>
					<th>已付</th>
					<th>未付</th>
					<!-- <th>备注</th> -->
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${bookingInfo.bookingList  }" var="booking">
					<tr>
						<td>${booking.bookingNo }</td>
						<td><fmt:formatDate value="${booking.bookingDate }"
								pattern="yyyy-MM-dd" /></td>
						<td>${booking.userName }</td>
						<td style="text-align: left">${booking.supplierName }</td>
						<td><c:if test="${booking.guideInfo!=null }">
				                  ${fn:replace(booking.guideInfo,',','</br>') }
				                  	 
				                  	</c:if></td>
						<td>${booking.cashType }</td>
						<td><c:choose>
								<c:when test="${ booking.total eq null}">0</c:when>
								<c:otherwise>
									<fmt:formatNumber value="${booking.total}" pattern="#.##"
										type="currency" />
								</c:otherwise>
							</c:choose></td>
						<td><c:choose>
								<c:when test="${ booking.totalCash eq null}">0</c:when>
								<c:otherwise>
									<fmt:formatNumber value="${ booking.totalCash   }"
										pattern="#.##" type="currency" />
								</c:otherwise>
							</c:choose></td>
						<td><fmt:formatNumber
								value="${booking.total-booking.totalCash }" pattern="#.##"
								type="currency" /></td>
						<%-- <td>${booking.remark }</td> --%>
						<td>
							<div class="tab-operate">
								<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
								<div class="btn-hide" id="asd">	
								<a class="def" href="javascript:void(0)"
									onclick="newWindow('查看机票订单','<%=staticPath %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}')">查看</a>
								<c:if
									test="${optMap['YDAP_AIR'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0 }">
									<a class="def" href="javascript:void(0)"
										onclick="confirm(this,${booking.id })">确认</a>
								</c:if> 
								<a class="def" href="javascript:void(0)"
									onclick="printOrder(${booking.id})">打印</a> <c:if
									test="${optMap['YDAP_AIR'] && (booking.stateFinance==null || booking.stateFinance==0 ) }">
								<a class="def" href="javascript:void(0)"
										onclick="newWindow('修改机票订单','<%=staticPath %>/booking/toAddAirTicket?groupId=${booking.groupId }&bookingId=${booking.id}&orderId=${booking.orderId}')">修改</a>
								</c:if> 
								<c:if test="${optMap['YDAP_AIR'] && booking.canDelete==true}">
									<a class="def" href="javascript:void(0)"
										onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
								</c:if>
								</div>
							</div>
						</td>
					</tr>
					<c:set var="sum_price" value="${sum_price+booking.total}" />
					<c:set var="sum_totalCash"
						value="${sum_totalCash+booking.totalCash}" />
					<c:set var="sum_noPay"
						value="${sum_noPay+booking.total-booking.totalCash}" />
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6" style="text-align: left">合计</td>
					<td><fmt:formatNumber value="${sum_price }" pattern="#.##"
							type="currency" /></td>
					<td><fmt:formatNumber value="${sum_totalCash }" pattern="#.##"
							type="currency" /></td>
					<td><fmt:formatNumber value="${sum_noPay }" pattern="#.##"
							type="currency" /></td>
					<td></td>
				</tr>
			</tfoot>
		</table>
	</dl>
</div>
<script type="text/javascript">
	function del(obj,id,type){
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
					$.successR("删除成功",function(){
						//$(obj).parent().parent().remove();
						location.reload();
					});
				}
				else{
					$.errorR(data.msg);
				}
			},
			error:function(){
				$.errorR("服务器忙，请稍后再试");
			}
		})
	}
	function printOrder(id){
		location.href="download.htm?bookingId="+id; //供应商确认订单
		
	}
	function confirm(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
	   		if(data.success){
	   			$(obj).hide();
	   			$(obj).parent().prev(".state").html("机票已确认");
	   			$.infoR('确认成功！');	   			
	   		}else{
	   			$.infoR(data.msg);
	   		}
	  },"json");
	}
	
	function refresh(){
		window.location.href=window.location.href;
	}
</script>
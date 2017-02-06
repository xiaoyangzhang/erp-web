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
			<col width="20%" />
			<col width="20%" />
			<col width="10%" />
			<col width="10%" />
			<col width="30%" />
			<thead>
				<tr>
					<th>序号<i class="w_table_split"></i></th>
					<th>日期<i class="w_table_split"></i></th>
					<th>型号<i class="w_table_split"></i></th>
					<th>座位数<i class="w_table_split"></i></th>
					<th>车辆年限<i class="w_table_split"></i></th>
					<th>备注<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${bookingInfo.requirementInfos }" var="info"
					varStatus="v">
					<tr>
						<td width="10%">${v.index+1}</td>
						<td width="15%">${info.requireDate }</td>
						<td width="10%"><c:forEach items="${ftcList}" var="v1">
								<c:if test="${v1.id==info.modelNum}">${v1.value}</c:if>
							</c:forEach></td>
						<td width="10%">${info.countSeat }</td>
						<td width="15%">${info.ageLimit}</td>
						<td width="22%" style="text-align: left; line-height: 15px;">${info.remark }</td>

					</tr>
				</c:forEach>
			</tbody>
		</table>
		<p class="p_paragraph_title" style="margin: 0;">
			<b>车辆安排</b>
			<c:if test="${optMap['YDAP_CAR'] and groupCanEdit }">
				<a class="button button-primary button-small"
					href="javascript:void(0)"
					onclick="newWindow('新增车辆订单','<%=ctx %>/booking/toAddCar?groupId=${groupId }&isShow=${isShow }')">新增</a>&nbsp;&nbsp;&nbsp;</c:if>
			<a class="button button-primary button-small"
				href="javascript:void(0)" onclick="refresh()">刷新</a>
			 <a class="button button-primary button-small" target="_blank" href="<%=ctx %>/booking/toCarPreview.htm?groupId=${groupId }" >打印</a> 
			
		</p>
		<dl class="p_paragraph_content">
			<table cellspacing="0" cellpadding="0" class="w_table">
				<col width="" />
				<col width="7%" />
				<col width="7%" />
				<col width="7%" />
				<col width="7%" />
				<col width="5%" />
				<col width="5%" />
				<col width="7%" />
				<col width="5%" />
				<col width="7%" />
				<col width="7%" />
				<col width="7%" />
				<col width="8%" />
				<thead>
					<tr>
						<th>车队</th>
						<th>导游</th>
						<th>用车日期</th>
						<th>预订员</th>
						<th>车型</th>
						<th>座位数</th>
						<th>结算方式</th>
						<th>车牌号</th>
						<th>司机</th>
						<th>联系方式</th>
						<th>状态</th>
						<th>金额</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${bookingInfo.bookingList  }" var="booking">
						<tr>
							<td style="text-align: left">${booking.supplierName }</td>
							<td ><c:if test="${booking.guideInfo!=null }">
				                  ${fn:replace(booking.guideInfo,',','</br>') }
				                  	 
				                  	</c:if></td>
							<td><fmt:formatDate value="${booking.itemDate }"
									pattern="yyyy-MM-dd" />~ <fmt:formatDate
									value="${booking.itemDateTo }" pattern="yyyy-MM-dd" /></td>
							<td>${booking.userName }</td>
							<td>${booking.type1Name }</td>
							<td>${booking.type2Name }</td>
							<td>${booking.cashType }</td>
							<td>${booking.carLisence }</td>
							<td>${booking.driverName }</td>
							<td>${booking.driverTel }</td>

							<td class="state"><c:choose>
									<c:when test="${booking.stateFinance==1 }">财务已确认</c:when>
									<c:otherwise>
										<c:if test="${booking.stateBooking==0 }">车队未确认</c:if>
										<c:if test="${booking.stateBooking==1 }">车队已确认</c:if>
										<c:if test="${booking.stateBooking==2 }">变更</c:if>
									</c:otherwise>
								</c:choose></td>
							<td><fmt:formatNumber value="${booking.itemTotal }"
									type="number" pattern="#.##" /></td>
							<td>
								<div class="tab-operate">
								<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
								<div class="btn-hide" id="asd">	
									<a class="def" href="javascript:void(0)"
									onclick="newWindow('查看车辆订单','<%=staticPath %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}')">查看</a>
									<c:if
										test="${optMap['YDAP_CAR'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0 }">
										<a class="def" href="javascript:void(0)"
											onclick="confirm(this,${booking.id })">确认</a>
									</c:if> <%-- <a class="def" href="javascript:void(0)"
									onclick="printOrder(${booking.id})">打印</a> --%>
									<a class="button button-primary button-small" href="javascript:void(0)" id="preview" onclick="toPreview(${booking.id})">打印</a>
									 <c:if
										test="${optMap['YDAP_CAR'] && (booking.stateFinance==null || booking.stateFinance==0 ) }">
										<a class="def" href="javascript:void(0)"
											onclick="newWindow('修改车辆订单','<%=staticPath %>/booking/toAddCar?groupId=${booking.groupId }&bookingId=${booking.id}&isShow=${isShow }')">修改</a>
									</c:if> <c:if test="${optMap['YDAP_CAR'] && booking.canDelete==true}">
										<a class="def" href="javascript:void(0)"
											onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
									</c:if>
								</div>
								</div>
							</td>
						</tr>
						<c:set var="sum_price" value="${sum_price+booking.itemTotal }" />
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="11" style="text-align: left">合计</td>
						<td><fmt:formatNumber value="${sum_price }" type="number"
								pattern="#.##" /></td>
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
				$.errorR("服务器忙，请稍后再试.....");
			}
		})
		
	}
	function confirm(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
	   		if(data.success){
	   			$(obj).hide();
	   			$(obj).parent().prev(".state").html("车队已确认");
	   			$.infoR('确认成功！');	   			
	   		}else{
	   			$.infoR(data.msg);
	   		}
	  },"json");
	}
	function printOrder(id){
		location.href="download.htm?bookingId="+id ; //供应商确认订单
		
	}
	function toPreview(bookingId){
		window.open("../booking/bookingDetailPreview.htm?bookingId="+bookingId);
		
	}
	function refresh(){
		window.location.href=window.location.href;
	}
</script>
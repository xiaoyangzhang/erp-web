<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/include/path.jsp"%>
<div class="in_tab mb-30">
	<p class="in_tab_title"><b>地接单</b></p>
	<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
		<col width="12%" /><col width="6%" /><col width="8%" /><col width="10%" />
		<col width="8%" /><col width="8%" /><col width="6%" /><col width="6%" />
		<col width="6%" /><col width="" /><col width="6%" />
		<tr>
			<th>地接社</th>
			<th>预订员</th>
			<th>到达日期</th>
			<th>联系方式</th>
			<th>人数</th>
			<th>状态</th>
			<th>金额</th>
			<th>已付</th>
			<th>未付</th>
			<th>价格明细(单价*次数*人数)</th>
			<th>操作</th>
		</tr>
		<c:forEach items="${list}" var="info" varStatus="status">
			<tr>
				<td>${info.supplierName}</td>
				<td>${info.userName }</td>
				<td><fmt:formatDate value="${info.dateArrival }" pattern="yyyy-MM-dd"/></td>
				<td>${info.contact }<c:if test="${info.contactMobile ne null }">/${info.contactMobile }</c:if></td>
				<td>${info.personAdult }大${info.personChild }小${info.personGuide }陪</td>
				<td class="state">
					<c:choose>
						<c:when test="${info.stateFinance==1 }">财务已确认</c:when>
						<c:otherwise>
							<c:if test="${info.stateBooking==0 }">地接社未确认</c:if>
							<c:if test="${info.stateBooking==1 }">地接社已确认</c:if>
							<c:if test="${info.stateBooking==2 }">变更</c:if>
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:choose>
						<c:when test="${ info.total eq null}">0</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${info.total}" pattern="#.##" type="currency"/>
						</c:otherwise>
					</c:choose>

				</td>
				<td>
					<c:choose>

						<c:when test="${ info.totalCash eq null}">0</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${info.totalCash}" pattern="#.##" type="currency"/>

						</c:otherwise>
					</c:choose>

				</td>
				<td><fmt:formatNumber value="${info.total-info.totalCash}" pattern="#.##" type="currency"/></td>
				<td>
					<c:if test="${info.priceList!=null and fn:length(info.priceList)>0 }">
						<table class="in_table">
							<col width="30%" /><col width="40%" /><col width="30%" />
							<c:forEach var="price" items="${info.priceList }">
								<tr>
									<td>${price.itemName }</td>
									<td>
										<fmt:formatNumber value="${price.unitPrice }" pattern="#.##" type="currency"/>*
										<fmt:formatNumber value="${price.numTimes }" pattern="#.##" type="currency"/>*
										<fmt:formatNumber value="${price.numPerson }" pattern="#.##" type="currency"/>
									</td>
									<td><fmt:formatNumber value="${price.totalPrice }" pattern="#.##" type="currency"/></td>
								</tr>
							</c:forEach>
						</table>
					</c:if>
				</td>

				<td>
					<div class="tab-operate">
						<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
						<div class="btn-hide" id="asd">
							<a class="def" href="javascript:void(0)" onclick="newWindow('查看下接社订单','<%=staticPath %>/booking/viewDelivery.htm?gid=${info.groupId }&bid=${info.id}')">查看</a>
							<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) && info.stateBooking==0  }">
								<a class="def" href="javascript:void(0)" onclick="angencyConfirm(this,${info.id })">确认</a>
							</c:if>
							<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 )}">
								<a class="def" href="javascript:void(0)" onclick="newWindow('修改下接社订单','<%=staticPath %>/booking/delivery.htm?gid=${info.groupId }&bid=${info.id}')">修改</a>
							</c:if>
							<a class="def" href="javascript:void(0)"  onclick="toPreview(${info.id})">打印</a>

							<c:if test="${deliverBroker ne null }">
								<a class="def" href="javascript:void(0)" onclick="toPreview(${info.id},2)">打印（业务2集团）</a>
								<a class="def" href="javascript:void(0)" onclick="toPreview(${info.id},3)">打印（集团2地接）</a>
							</c:if>
							<c:if test="${optMap['EDIT'] && info.canDelete==true}">
								<a class="def" href="javascript:void(0)" onclick="agencyDelete(this,${info.id })">删除</a>
							</c:if>
						</div>
					</div>
				</td>
			</tr>
			<c:set var="sum_price" value="${sum_price+info.total}" />
			<c:set var="sum_totalCash" value="${sum_totalCash+info.totalCash}" />
			<c:set var="sum_noPay" value="${sum_noPay+info.total-info.totalCash}" />
		</c:forEach>
		<tbody>
		<tr>
			<td colspan="6" style="text-align: right">合计</td>
			<td><fmt:formatNumber value="${sum_price }" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_totalCash }" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_noPay }" pattern="#.##" type="currency"/></td>
			<td colspan="2"></td>
		</tr>
		</tbody>
	</table>
</div>
<script type="text/javascript">
	function angencyConfirm(obj,id){
		$.post("agencyConfirm.do",{id:id},function(data){
			if(data.success){
				$(obj).hide();
				$(obj).parent().prev(".state").html("地接社已确认");
				$.info('确认成功！');
			}else{
				$.info(data.msg);
			}
		},"json");
	}
	function agencyDelete(obj,id){
		var r=window.confirm("是否删除该订单？");
		if(r){
			$.post("agencyDelele.do",{id:id},function(data){
				if(data.success){
					//$(obj).closest("tr").remove();
					queryList($("#searchPage").val(),$("#searchPageSize").val());
					$.info('删除成功！');
				}else{
					$.info(data.msg);
				}
			},"json");
		}
	}
	function toPreview(bookingId,type){
		if(!type){type=1;}
		window.open("../booking/deliveryDetailPreview.htm?bookingId="+bookingId+"&type="+type+"&preview=1");

	}
	function printOrder(bookingId,type){
		if(!type){type=1;}
		location.href="deliveryExport.do?bookingId="+bookingId+"&type="+type ; //供应商确认订单

	}
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 <%@ include file="/WEB-INF/include/top.jsp" %>
<div class="p_container">
	<p class="p_paragraph_title" style="margin: 0;">
		<b>其他收入</b>
		<c:if test="${optMap['YDAP_OTHERIN'] and groupCanEdit }">
			<a class="button button-primary button-small"
				href="javascript:void(0)"
				onclick="newWindow('新增保险订单','<%=ctx %>/booking/editIncome.htm?groupId=${groupId }')">新增</a>&nbsp;&nbsp;&nbsp;</c:if>
		<a class="button button-primary button-small"
			href="javascript:void(0)" onclick="refresh()">刷新</a>
	</p>
	<dl class="p_paragraph_content">
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="8%" />
			<thead>
				<tr>

					<th>商家名称</th>
					<th>导游</th>
					<th>日期</th>
					<th>项目</th>
					<th>预订员</th>
					<th>价格</th>
					<th>数量</th>
					<th>结算方式</th>
					<th>状态</th>
					<th>金额</th>

					<!-- <th>备注</th> -->
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
								pattern="yyyy-MM-dd" /></td>
						<td>${booking.type1Name }</td>
						<td>${booking.userName }</td>
						<td><fmt:formatNumber value="${booking.itemPrice }"
								pattern="#.##" type="currency"></fmt:formatNumber></td>
						<td>${booking.itemNum }</td>
						<td>${booking.cashType }</td>
						<td class="state"><c:choose>
								<c:when test="${booking.stateFinance==1 }">财务已确认</c:when>
								<c:otherwise>
									<c:if test="${booking.stateBooking==0 }">商家未确认</c:if>
									<c:if test="${booking.stateBooking==1 }">商家已确认</c:if>
									<c:if test="${booking.stateBooking==2 }">变更</c:if>
								</c:otherwise>
							</c:choose></td>
						<td><fmt:formatNumber value="${booking.itemTotal }"
								pattern="#.##" type="currency"></fmt:formatNumber></td>

						<%-- <td>${booking.remark }</td> --%>


						<td>
							<div class="tab-operate">
								<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
								<div class="btn-hide" id="asd">	
								<a class="mr-10 blue" href="javascript:void(0)"
								onclick="newWindow('查看收入','<%=staticPath %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId }') ">查看</a>
								<c:if
									test="${optMap['YDAP_OTHERIN'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0}">
									<a class="def" href="javascript:void(0)"
										onclick="confirm(this,${booking.id })">确认</a>
								</c:if> <a class="mr-10 blue" href="javascript:void(0)"
								onclick="printOrder(${booking.id})">打印</a> <c:if
									test="${optMap['YDAP_OTHERIN'] && (booking.stateFinance==null || booking.stateFinance==0 ) }">
									<a class="def" href="javascript:void(0)"
										onclick="newWindow('修改收入','<%=staticPath %>/booking/editIncome.htm?groupId=${booking.groupId }&bookingId=${booking.id}')">修改</a>
								</c:if> <c:if test="${optMap['YDAP_OTHERIN'] && booking.canDelete==true}">
									<a class="def" href="javascript:void(0)"
										onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
								</c:if>
								</div>
							</div>
						</td>
					</tr>
					<c:set var="sum_price" value="${sum_price+booking.itemTotal}" />

				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="9" style="text-align: left">合计</td>
					<td><fmt:formatNumber value="${sum_price }" pattern="#.##"
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
	function confirm(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
	   		if(data.success){
	   			$(obj).hide();
	   			$(obj).parent().prev(".state").html("商家已确认");
	   			$.infoR('确认成功！');
	   		}else{
	   			$.infoR(data.msg);
	   		}
	  },"json");
	}
	function printOrder(id){
		location.href="download.htm?bookingId="+id ; //供应商确认订单
		
	}
	
	function refresh(){
		window.location.href=window.location.href;
	}
</script>
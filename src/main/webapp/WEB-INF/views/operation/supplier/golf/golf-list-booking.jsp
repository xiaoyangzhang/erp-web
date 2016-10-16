<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%@ include file="../../../../include/path.jsp" %>

          	<div class="in_tab mb-30">
          		
          		<p class="in_tab_title"><b>订单</b></p>
          		<form id="bookingGolf" action="">
          		<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
          			<col width="20%" /><col width="10%" /><col width="10%" /><col width="20%" /><col width="8%" />
 					<col width="8%" /><col width="8%" /><col width="" />
          			<tr>
          				<th>订单号</th>
          				<th>下单时间</th>
          				<th>预订员</th>
          				<th>地点</th>
          				<th>结算方式</th>
          				<th>状态</th>
          				<th>金额</th>
          				<th>操作</th>
          				
          			</tr>
          			<c:forEach items="${bookingInfo.bookingList  }" var="booking">
          			<tr>
          				<td>${booking.bookingNo }</td>
          				<td><fmt:formatDate value="${booking.bookingDate }"
														pattern="yyyy-MM-dd" /></td>
          				<td>${booking.userName }</td>
          				<td style="text-align: left"> ${booking.supplierName }</td>
          				<td>${booking.cashType }</td>
          				<td class="state"><c:choose>
						<c:when test="${booking.stateFinance==1 }">财务已确认</c:when>
						<c:otherwise>
							<c:if test="${booking.stateBooking==0 }">高尔夫未确认</c:if>
							<c:if test="${booking.stateBooking==1 }">高尔夫已确认</c:if>
							<c:if test="${booking.stateBooking==2 }">变更</c:if>
						</c:otherwise>
					</c:choose></td>
          				<td>
          					 <c:choose>
          						<c:when test="${booking.total eq null  }">0</c:when> 
          						<c:otherwise><fmt:formatNumber value="${booking.total }" pattern="#.##" type="currency"/></c:otherwise>
          					 </c:choose> 
          				</td>
          				<td>
							<a class="def" href="javascript:void(0)" onclick="newWindow('查看高尔夫订单','<%=staticPath %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}')">查看</a>
          				<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0}">
						<a class="def" href="javascript:void(0)" onclick="confirm(this,${booking.id })">确认</a>
						</c:if>
						
		         			<a class="def" href="javascript:void(0)" onclick="printOrder(${booking.id})">打印</a>
							
							<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) }">
		         			<a class="def" href="javascript:void(0)" onclick="newWindow('修改高尔夫订单','<%=staticPath %>/booking/toAddGolf?groupId=${booking.groupId }&bookingId=${booking.id}')">修改</a>
							</c:if>
		         		<c:if test="${optMap['EDIT'] && booking.canDelete==true}">
			         		<a class="def" href="javascript:void(0)" onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
		         		</c:if>
          					
       						</td>
          			</tr>
          			<c:set var="sum_price" value="${sum_price+booking.total}" />
          			</c:forEach>
          			<tbody>
          				<tr>
          					<td colspan="6" style="text-align: left">合计</td>
          					<td><fmt:formatNumber value="${sum_price }" pattern="#.##" type="currency"/></td>
          					<td></td>
          				</tr>
          			</tbody>
          		</table>
          		</form>
          	</div>  	
<script type="text/javascript">
	function del(obj,id,type){
		var options={
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
						//	$(obj).parent().parent().remove();
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
		};
		$("#bookingGolf").ajaxSubmit(options);
		
	}
	function confirm(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
	   		if(data.success){
	   			$(obj).hide();
	   			$(obj).parent().prev(".state").html("高尔夫已确认");
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
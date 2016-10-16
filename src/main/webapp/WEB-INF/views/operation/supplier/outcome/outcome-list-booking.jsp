<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%@ include file="/WEB-INF/include/path.jsp" %>

          	<div class="in_tab mb-30">          		
          		<p class="in_tab_title"><b>其他支出单</b></p>
          		<form id="outcome" action="">
          		<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
          			<col width="" /><col width="10%" /><col width="10%" /><col width="10%" /><col width="10%" />
 					<col width="10%" /><col width="10%" /><col width="10%" /><col width="10%" /><col width="8%" />
 					
          			<tr>
          				
          				
          				
          				<th>商家名称</th>
          				<th>日期</th>
          				<th>项目</th>
          				<th>预订员</th>
          				<th>单价</th>
          				<th>数量</th>
          				<th>结算方式</th>
          				<th>状态</th>
          				<th>金额</th>
          				
          				<!-- <th>备注</th> -->
          				<th>操作</th>
          			</tr>
          			<c:forEach items="${bookingInfo.bookingList  }" var="booking">
          			<tr>
          				
          				<td style="text-align: left">${booking.supplierName }</td>
          				<td><fmt:formatDate value="${booking.itemDate }" pattern="yyyy-MM-dd"/></td>
          				<td>${booking.type1Name }</td>
          				<td>${booking.userName }</td>
          				<td><fmt:formatNumber value="${booking.itemPrice }" pattern="#.##" type="currency"/></td>
          				<td><fmt:formatNumber value="${booking.itemNum }" pattern="#.##" type="currency"/></td>
          				<td>${booking.cashType }</td>
          				<td class="state"><c:choose>
						<c:when test="${booking.stateFinance==1 }">财务已确认</c:when>
						<c:otherwise>
							<c:if test="${booking.stateBooking==0 }">商家未确认</c:if>
							<c:if test="${booking.stateBooking==1 }">商家已确认</c:if>
							<c:if test="${booking.stateBooking==2 }">变更</c:if>
						</c:otherwise>
					</c:choose>
						</td>
          				
          				<td><fmt:formatNumber value="${booking.itemTotal  }" pattern="#.##" type="currency"/></td>
          				
          				<%-- <td>${booking.remark }</td> --%>
          				
          				<td>
          					<div class="tab-operate">
								<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
								<div class="btn-hide" id="asd">	
		         			<a class="def" href="javascript:void(0)" onclick="newWindow('查看支出','<%=staticPath %>/booking/viewSupplier.do?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId }') ">查看</a>
          					<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 ) && booking.stateBooking==0}">
								<a class="def" href="javascript:void(0)" onclick="confirmState(this,${booking.id })">确认</a>
							</c:if>
          					
		         			<a class="def" href="javascript:void(0)" onclick="printOrder(${booking.id})">打印</a>
          					<c:if test="${optMap['EDIT'] && (booking.stateFinance==null || booking.stateFinance==0 )}">
			         			<a class="def" href="javascript:void(0)" onclick="newWindow('修改支出','<%=staticPath %>/booking/editOutcome.htm?groupId=${booking.groupId }&bookingId=${booking.id}')">修改</a>
							</c:if>
			         		<c:if test="${optMap['EDIT'] && booking.canDelete==true}">
				         		<a class="def" href="javascript:void(0)" onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a>
			         		</c:if>
								</div>
							</div>          					
       						</td>
          			</tr>
          			<c:set var="sum_price" value="${sum_price+booking.itemTotal}" />
          			
          			</c:forEach>
          			<tbody>
          				<tr>
          					<td colspan="8" style="text-align: left">合计</td>
          					<td><fmt:formatNumber value="${sum_price }" pattern="#.##" type="currency"/></td>
          					
          					<td></td>
          				</tr>
          			</tbody>
          		</table>
          		</form>
          	</div>  	
     <script type="text/javascript">
	function del(obj,id,type){
		var r=window.confirm("是否删除该订单？");
		if(r){
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
					$.error("服务器忙，请稍后再试.....");
				}
		};
		$("#outcome").ajaxSubmit(options);
		}
	}
	function confirmState(obj,id){
		$.post("stateConfirm.do",{id:id},function(data){
	   		if(data.success){
	   			$(obj).hide();
	   			$(obj).parent().prev(".state").html("商家已确认");
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
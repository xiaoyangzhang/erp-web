<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../../../include/path.jsp" %>

          	<div class="in_tab mb-30">
          		<p class="in_tab_title"><b>购物单</b></p>
          		<table class="in_tab_body" border="1" cellspacing="0" cellpadding="0">
          			<col width="5%" /><col width="10%" /><col width="10%" /><col width="8%" /><col width="28%" />
 					<col width="10%" /><col width="8%" /><col width="5%" /><col width="8%" />
          			<tr>
          				<th>序号</th>
          				<th>订单号</th>
          				<th>订单时间</th>
          				<th>预订员</th>
          				<th>购物店</th>
          				<th>进店日期</th>
          				<th>导游</th>
          				<th>人数</th>
          				<!-- <th>预计总消费</th>
          				<th>实际总消费</th>
          				<th>完成率</th> -->
          				<th>购物金额</th>
          				<th>操作</th>
          			</tr>
          			 <c:forEach items="${shopList}" var="shop" varStatus="status">
	          			<tr>
	          				<td>${status.count }</td>
	          				<td>${shop.bookingNo }</td>
	          				<td><fmt:formatDate value="${shop.bookingDate }" pattern="yyyy-MM-dd"/></td>
	          				<td>${shop.userName }</td>
	          				<td>${shop.supplierName }</td>
	          				<td>${shop.shopDate }</td>
	          				<td>${shop.guideName }</td>
	          				<td>${shop.personNum }</td>
	          				<%-- <td><fmt:formatNumber type="number"  value="${shop.personNum*shop.personBuyAvg }" pattern="0.00#" /></td>
	          				 <td><fmt:formatNumber type="number"  value="${shop.totalFace }" pattern="0.00#" /></td>
	          				<c:if test="${shop.personNum*shop.personBuyAvg=='0.0000'}">
	          				<td><fmt:formatNumber type="number" value="0" pattern="0.00#" />%</td>
	          				</c:if>
	          				<c:if test="${shop.personNum*shop.personBuyAvg!='0.0000'}">
	          				<td><fmt:formatNumber type="number" value="${(shop.totalFace/(shop.personNum*shop.personBuyAvg))*100 }" pattern="0.00#" />%</td> 
	          				</c:if>
	          				<td> --%>
	          				<td><fmt:formatNumber type="number"  value="${shop.totalMoney }" pattern="0.00#" /></td>
	          				<td>
	          				<%-- <c:if test="${optMap['RESULT'] }"><a class="def" href=""></a> --%>
	          				<a class="def" href="javascript:void(0)" onclick="newWindow('修改购物信息','<%=staticPath %>/bookingGuestShop/toFactShop.htm?id=${shop.id }&groupId=${groupId}')">编辑</a>
	          				<%-- </c:if> --%>
	          				
<%-- 	          				<a class="def" href="javascript:void(0)" onclick="newWindow('查看客人购物信息','<%=staticPath %>/bookingGuestShop/factShop.htm?id=${shop.id }&groupId=${groupId}')">查看</a>
 --%>	          				<c:if test="${shop.stateFinance ne 1 }">
							<a class="def" href="javascript:void(0)" onclick="del(${shop.id})">删除</a>
							</c:if>
	          				</td>
	          				
	          			</tr>
          			</c:forEach>
          			<tr>
          				<td colspan="8">合计：</td>
          			
          				<td><fmt:formatNumber type="number"  value="${count }" pattern="0.00#" /></td>
          				<td></td>
          			</tr>
          		</table>
          	</div>  		
          	<script type="text/javascript">
function del(bookingId){
	$.ajax({
		url:"<%=ctx %>/bookingGuestShop/delBookingShop.do",
		type:"post",
		dataType:"json",
		async:false,
		data:{
			bookingId:bookingId
		},
		success:function(data){
			if(data.success){
				$.success("删除成功",function(){
					//$(obj).parent().parent().remove();
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
</script>


		
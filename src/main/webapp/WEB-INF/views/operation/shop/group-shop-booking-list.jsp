<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/include/top.jsp" %>
<div class="p_container">
	<p class="p_paragraph_title" style="margin: 0;">
		<b>购物店安排</b>
		<c:if test="${optMap['YDAP_SHOP'] and groupCanEdit }">
			<a class="button button-primary button-small"
				href="javascript:void(0)"
				onclick="newWindow('新增购物店','<%=ctx %>/bookingShop/toBookingShopView.htm?groupId=${groupId }&type=1')">新增</a>&nbsp;&nbsp;&nbsp;</c:if>
		<a class="button button-primary button-small"
			href="javascript:void(0)" onclick="refresh()">刷新</a>
	</p>
	<dl class="p_paragraph_content">
		<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="5%" />
			<col width="10%" />
			<col width="10%" />
			<col width="8%" />
			<col width="10%" />
			<col width="10%" />
			<col width="8%" />
			<col width="5%" />
			<col width="8%" />
			<col width="8%" />
			<col width="8%" />
			<thead>
				<tr>
					<th>序号</th>
					<th>订单号</th>
					<th>订单时间</th>
					<th>预订员</th>
					<th>购物店</th>
					<th>进店日期</th>
					<th>导游</th>
					<th>人数</th>
					<th>预计总消费</th>
					<th>实际总消费</th>
					<th>完成率</th>
					<!-- 	<th>操作</th> -->
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${shopList}" var="shop" varStatus="status">
					<tr>
						<td>${status.count }</td>
						<td>${shop.bookingNo }</td>
						<td><fmt:formatDate value="${shop.bookingDate }"
								pattern="yyyy-MM-dd" /></td>
						<td>${shop.userName }</td>
						<td>${shop.supplierName }</td>
						<td>${shop.shopDate }</td>
						<td>${shop.guideName }</td>
						<td>${shop.personNum }</td>
						<td><fmt:formatNumber type="number"
								value="${shop.personNum*shop.personBuyAvg }" pattern="0.00#" /></td>
						<td><fmt:formatNumber type="number"
								value="${shop.totalFace }" pattern="0.00#" /></td>
						<c:if test="${shop.personNum*shop.personBuyAvg=='0.0000'}">
							<td><fmt:formatNumber type="number" value="0"
									pattern="0.00#" />%</td>
						</c:if>
						<c:if test="${shop.personNum*shop.personBuyAvg!='0.0000'}">
							<td><fmt:formatNumber type="number"
									value="${(shop.totalFace/(shop.personNum*shop.personBuyAvg))*100 }"
									pattern="0.00#" />%</td>
						</c:if>
						<%-- 	<td>
	          				<c:if test="${optMap['RESULT'] }"><a class="def" href=""></a>
	          				<a class="def" href="javascript:void(0)" onclick="newWindow('实际消费','<%=staticPath %>/bookingShop/toFactShop.htm?id=${shop.id }&groupId=${groupId}')">实际消费</a>
	          				</c:if>
	          				
	          				<a class="def" href="javascript:void(0)" onclick="newWindow('查看消费','<%=staticPath %>/bookingShop/factShop.htm?id=${shop.id }&groupId=${groupId}')">查看</a>
	          				</td>
	          				 --%>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="9">合计：</td>
					<td><fmt:formatNumber value="${count }" pattern="0.00"
							type="number" /></td>
					<td></td>
				</tr>
			</tfoot>
		</table>
	</dl>
</div>
<script type="text/javascript">
function refresh(){
	window.location.href=window.location.href;
}
</script>

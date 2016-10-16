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
          				<th>商品</th>
          				<th>数量</th>
          				<th>价格</th>
          				<th>金额</th>
          				<th>返款方式</th>
          				<th>返款金额</th>
          				
          			</tr>
          			 <c:forEach items="${shopDetail}" var="shopDetail" varStatus="status">
	          			<tr>
	          				<td>${shopDetail.goodsName }</td>
	          				<td>${shopDetail.buyNum }</td>
	          				<td><fmt:formatNumber type="number"  value="${shopDetail.buyPrice }" pattern="0.00#" /></td>
	          				<td><fmt:formatNumber type="number"  value="${shopDetail.buyNum*buyPrice }" pattern="0.00#" /></td>
	          				<td><c:if test="${shopDetail.repayType eq 1 }">按销售金额返款</c:if><c:if test="${shopDetail.repayType eq 2 }">按销售数量返款</c:if></td>
	          				<td><fmt:formatNumber type="number"  value="${shopDetail.buyTotal }" pattern="0.00#" /></td>
	          			</tr>
          			</c:forEach>
          			
          		</table>
          	</div>  		


		
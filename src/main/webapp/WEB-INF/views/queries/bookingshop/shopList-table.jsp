<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="5%" />
	<col width="7%" />
	
	<col width="20%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>购物店<i class="w_table_split"></i></th>
			<th>进店人数<i class="w_table_split"></i></th>
			<th>总额<i class="w_table_split"></i></th>
			
			<th>购物项目<i class="w_table_split"></i></th>
			<th>社佣比例<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>返佣金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td  style="text-align: left;">${item.supplier_name}</td>
				<td  >${item.sum_person}</td>
				<td ><fmt:formatNumber value="${item.sum_money}" pattern="#.##" type="currency"/></td>
				
				<td colspan="4">
					<c:if test="${not empty item.bookingShopDetailList}">
					<table cellspacing="0" cellpadding="0" class="w_table" style="border-top:0px;">
						<col width="20%" />
						<col width="7%" />
						<col width="7%" />
						<col width="7%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.bookingShopDetailList}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.bookingShopDetailList) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"border-bottom:0px;\"" />
								</c:if>
							<tr>
								<td>${bill.goods_name}</td>
								<td ${borderCss } ><fmt:formatNumber value="${bill.sum_repay_total/bill.sum_buy_total*100}" pattern="#.####" type="currency"/>%</td>
								<td ${borderCss } ><fmt:formatNumber value="${bill.sum_buy_total}" pattern="#.##" type="currency"/></td>
								<td ${borderCss } ><fmt:formatNumber value="${bill.sum_repay_total}" pattern="#.##" type="currency"/></td>
							<tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
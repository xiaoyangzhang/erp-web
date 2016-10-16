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
	<col width="15%" />
	<col width="5%" />
	<col width="8%" />
	
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	<col width="8%" />
	
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>购物店<i class="w_table_split"></i></th>
			<th>进店总人数<i class="w_table_split"></i></th>
			<th>总额<i class="w_table_split"></i></th>
			<th>购物项目<i class="w_table_split"></i></th>
			<th>返款比例<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>返款<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.supplier_name}</td>
				<td><fmt:formatNumber value="${item.total_person}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${item.total_face}" pattern="#.##" type="currency"/></td>
				<c:set var="sum_total_person" value="${sum_total_person+item.total_person }" />
				<c:set var="sum_total_face" value="${sum_total_face+item.total_face }" />
				<td colspan="4">
					<c:if test="${not empty item.bookingShopDetailList}">
					<table class="in_table">
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<col width="25%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.bookingShopDetailList}" var="detail" varStatus="status">
							<tr>
								<c:set value="${ fn:split(detail.repay_val, ',') }" var="str1" />
								<td>${detail.goods_name}</td>
								<td>
								<c:forEach items="${ str1 }" var="s">
									<fmt:formatNumber value="${ s }" pattern="#.####" type="currency"/>%
									<br />
								</c:forEach>
								</td>
								<%-- <td>
								<c:if test="${empty detail.buy_total or detail.buy_total eq 0}">0</c:if>
									<c:if test="${not empty detail.buy_total and (detail.buy_total >0 or detail.buy_total <0)}">
										<fmt:formatNumber value="${detail.repay_total*100/detail.buy_total}" pattern="#.####" type="currency"/>% 
									</c:if>
								</td> --%>
								<td><fmt:formatNumber value="${detail.buy_total}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${detail.repay_total}" pattern="#.##" type="currency"/></td>
							</tr>
 							<c:set var="sum_buy_total" value="${sum_buy_total+detail.buy_total }" />
 							<c:set var="sum_repay_total" value="${sum_repay_total+detail.repay_total }" />
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="2">合计：</td>
			<td>${sum_total_person}</td>
			<td><fmt:formatNumber value="${sum_total_face}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_buy_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_repay_total}" pattern="#.##" type="currency"/></td>
		</tr>
		<%-- <tr>
			<td colspan="2">总合计：</td>
			<td>${all_total_person}</td>
			<td><fmt:formatNumber value="${all_total_face}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${all_buy_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${all_repay_total}" pattern="#.##" type="currency"/></td>
		</tr> --%>
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
<script type="text/javascript">
	$(function(){
		var docHeight = $(window).height()-240;		
		var minHeight=498;
		var tHeight=docHeight+"px";
		if(docHeight>minHeight){
			tHeight=minHeight+"px";
		}
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})
</script>
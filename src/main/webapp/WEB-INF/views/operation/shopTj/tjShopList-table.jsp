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
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="5%" />
	<col width="5%" />
	<col width="15%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>公司<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>订单<i class="w_table_split"></i></th>
			
			<th>导游<i class="w_table_split"></i></th>
			<th>导游电话<i class="w_table_split"></i></th>
			<th>司机<i class="w_table_split"></i></th>
			<th>导管<i class="w_table_split"></i></th>
			
			
			<th>店名<i class="w_table_split"></i></th>
			<th>进店日期<i class="w_table_split"></i></th>
			<th>进店人数<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td>${item.company}</td>
				<td>${item.group_code}</td>
				<td>【${item.product_brand_name}】${item.product_name}</td>
				<td>${item.operator_name}</td>
				<td>${item.total_adult}大${item.total_child}小${item.total_guide}陪</td>
				<td>${item.orders}</td>
				
				<td colspan="7">
					<c:if test="${not empty item.guideTj}">
					<table class="in_table">
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.guideTj}" var="detail" varStatus="status">
							<tr>
								<td>${detail.guide_name}</td>
								<td>${detail.guide_mobile}</td>
								<td>${detail.driver_name}
									<c:if test="${!empty detail.driver_tel}" >
										(${detail.driver_tel})
									</c:if>
									${detail.car_lisence}
								</td>
								<td>${detail.user_name}</td>
								
								<td colspan="3">
									<c:if test="${not empty detail.shop}">
									<table class="in_table">
										<col width="33%" />
										<col width="33%" />
										<col width="33%" />
										<thead></thead>
										<tbody>
											<c:forEach items="${detail.shop}" var="shop" varStatus="status">
											<tr>
												<td>${shop.supplierName}</td>
												<td>${shop.shopDate}</td>
												<td>${shop.personNum}</td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
									</c:if>
								</td>
								
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
				
				
			</tr>
		</c:forEach>
		<%-- <tr>
			<td colspan="2">本页合计：</td>
			<td>${sum_total_person}</td>
			<td><fmt:formatNumber value="${sum_total_face}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_buy_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_repay_total}" pattern="#.##" type="currency"/></td>
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
		//110 为底部分页条以及padding等的高度
		var searchHeight = $(".p_container").height()+110;
		var docHeight = $(window).height()-searchHeight;		
		var tHeight=docHeight+"px";
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})
</script>
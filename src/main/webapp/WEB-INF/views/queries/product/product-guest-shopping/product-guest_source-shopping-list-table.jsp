<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 <%@ include file="/WEB-INF/include/path.jsp" %>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="5%" />
	<col width="15%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>产品品牌<i class="w_table_split"></i></th>
			<th>省份<i class="w_table_split"></i></th>
			<th>总人数<i class="w_table_split"></i></th>
			<th>购物总额<i class="w_table_split"></i></th>
			<th>总人均<i class="w_table_split"></i></th>
			<th>市<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>人均</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="product" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left">${product['product_brand_name']}</td>
				<td colspan="8"><c:if test="${product['provinces']!=null }">
						<table class="in_table">
							<col width="12.5%" />
							<col width="12.5%" />
							<col width="12.5%" />
							<col width="12.5%" />
							<col width="50%" />
							<c:forEach var="pitem" items="${product['provinces'] }">
								<tr>
									<td>${pitem.provinceName }</td>
									<td>${pitem.adultSum }</td>
									<td><fmt:formatNumber value="${pitem.totalSum }" pattern="#.##" type="currency"/></td>
									<td><c:if test="${pitem.adultSum ne null and pitem.adultSum>0 }"><fmt:formatNumber value="${pitem.totalSum/pitem.adultSum }" pattern="#.##" type="currency"/></c:if></td>
									<td colspan="4"><c:if test="${pitem.citys!=null }">
										<table class="in_table">
											<col width="10%" />
											<col width="10%" />
											<col width="10%" />
											<col width="10%" />
												<c:forEach var="citem" items="${pitem.citys }">
													<tr>
														<td>${citem['city_name'] }</td>
														<td>${citem['adult'] }</td>
														<td><fmt:formatNumber value="${citem['total'] }" pattern="#.##" type="currency"/></td>
														<td><c:if test="${citem['adult'] ne null and citem['adult']>0  }"><fmt:formatNumber value="${citem['total']/citem['adult'] }" pattern="#.##" type="currency"/></c:if></td>
													</tr>
												</c:forEach>
											</table>
										</c:if></td>
								</tr>
								<c:set var="sum_adult" value="${sum_adult+pitem.adultSum }" />
								<c:set var="sum_total" value="${sum_total+pitem.totalSum }" />
							</c:forEach>
						</table>
				</c:if></td>
			</tr>
			
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			<td colspan="3"></td>
			<td>${sum_adult }</td>
			<td><fmt:formatNumber value="${sum_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total/sum_adult}" pattern="#.##" type="currency"/></td>
			<td colspan="4"></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>


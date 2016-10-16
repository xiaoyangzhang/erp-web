<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<%
	String path = request.getContextPath();
%>
<div class="productlist mt-25">
 <c:forEach items="${page.result}" var="productSales" varStatus="status">
				<div class="pro">
					<c:if test="${productSales.path==null}">
					<img src="<%=path %>/assets/img/default_product_cover.jpg"/>
					</c:if>
					<c:if test="${productSales.path!=null}">
					<img src="${config.images200Url }${cf:thumbnail(productSales.path,'200x200')}"/>
					</c:if>
					<div class="jieshao">
						<a href="javascript:goOrder(${productSales.id });" class="button button-rounded button-green button-small">预定</a>
						<a href="<%=path %>/productInfo/productInfoPreview.htm?productId=${productSales.id }&preview=1" target="_blank" class="button button-rounded button-green button-small" style="margin-right:10px;">导出</a>
						<h2 class="ml-10">【${productSales.brandName }】<a href="javascript:void(0);" onclick="newWindow('散客预定-新订单','<%=path%>/productSales/info.htm?id=${productSales.id}')" ><span>${productSales.nameCity }</span></a></h2>
						<p class="ml-20 mb-10">
							<%-- <span class="mr-30">ID:${productSales.code }</span> --%>
							<span class="mr-30">天数：${productSales.travelDays }天</span>
							<%-- <span>目的地：${productSales.destProvinceName }/${productSales.destCityName }</span> --%>
							<span>计调：${productSales.operatorName }</span>
							
						</p>
						<%-- <p class="ml-20 mb-20">
							<span class="mr-30">最近发团：${productSales.groupDates }</span>
							<span class="grey"><a href="<%=path%>/productSales/detail.htm?id=${productSales.id}" class="blue">更多团期</a>（具体价格已发团日期为准）</span>
						</p> --%>
						<p class="ml-20  mb-10">
							<span>路线说明：</span>
							<span class="grey">${productSales.guestNote }</span>
						</p>
					</div>
				</div>
			</c:forEach>	
		
				
			</div>
			
			<div class="page">
				
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
			</div>		
		</div>
		
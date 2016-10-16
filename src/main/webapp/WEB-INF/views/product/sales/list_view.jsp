<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
						<input type='hidden' name='productId'  value="${productSales.id }"/>
						<a href="javascript:goOrder(${productSales.id });" class="button button-rounded button-green button-small">预定</a>
						<a href="<%=path %>/productInfo/productInfoPreview.htm?productId=${productSales.id }&preview=1" target="_blank" class="button button-rounded button-green button-small" style="margin-right:10px;">导出</a>
						<h2 class="ml-10">【${productSales.brandName }】<a href="javascript:void(0);" onclick="newWindow('散客预定-新订单','<%=path%>/productSales/detail.htm?id=${productSales.id}')" ><span>${productSales.nameCity }</span></a></h2>
						<p class="ml-20 mb-10">
							<span class="mr-30">天数：${productSales.travelDays }天</span>
							<span class="mr-30">计调：${productSales.operatorName }</span>
							<span class="mr-30">产品编码:${productSales.code }</span>
							<%-- <span>目的地：${productSales.destProvinceName }/${productSales.destCityName }</span> --%>
						</p>
						<p class="ml-20 mb-20">
							<%-- <span class="mr-30">最近发团：${productSales.groupDates }</span> --%>
							<!-- <span class="mr-30">更改日志：<a href="" class="blue">查看</a></span> -->
							<span class="mr-30">价格：大<span id='min_audlt_${productSales.id }'>0</span>元起，小<span id='min_child_${productSales.id }'>0</span>元起</span>
							<%-- <span class="grey"><a href="<%=path%>/productSales/detail.htm?id=${productSales.id}" class="blue">更多团期</a>（具体价格已发团日期为准）</span> --%>
						</p>
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
<script type="text/javascript">
$(function(){
	var array = [];
	$("input[name='productId']").each(function(){
		array.push($(this).val());
	})
	$.post("minPrice.do",{list:JSON.stringify(array)},function(data){
		if(data && data.length>0){
			for(var i=0;i<data.length;i++){
				var item = data[i];
				$("#min_audlt_"+item.productId).html(item.adultPrice);
				$("#min_child_"+item.productId).html(item.childPrice);
			}
		}
	},'json');
})
</script>		
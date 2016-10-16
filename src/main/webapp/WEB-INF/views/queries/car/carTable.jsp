<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String staticPath = request.getContextPath();
%>
<table class="w_table" id="carTable">
<colgroup>
		<col width="5%" />
		<col width="10%" />
		<col width="10%" />
		<col width="5%" />
		<col width="10%" />
		<col width="5%" />
		<col width="5%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="7%" />
		<col width="7%" />
		<col width="6%" />
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调 <i class="w_table_split"></i></th>
			<th>车型<i class="w_table_split"></i></th>
			<th>座位数<i class="w_table_split"></i></th>
			<th>用车日期<i class="w_table_split"></i></th>
			<th>车牌号<i class="w_table_split"></i></th>
			<th>司机<i class="w_table_split"></i></th>
			<th>车价<i class="w_table_split"></i></th>
			<th>计调价<i class="w_table_split"></i></th>
			<th>差价<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	<input type="hidden"  id="searchPage" />
			<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
			
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left">
				<c:choose>
                  		<c:when test="${v.group_mode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.group_id}&operType=0')">${v.group_code}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.group_id}&operType=0')">${v.group_code}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td style="text-align: left;">【${v.product_brand_name }】${v.product_name }</td>
				<td>${v.total_adult}大${v.total_child}小${v.total_guide}陪</td>
				<td>${v.operator_name }</td>
				<td>${v.type1_name }</td>
				<td>${v.type2_name }</td>
				<td>${v.item_date }</td>
				<td>${v.car_lisence }</td>
				<td><c:choose><c:when test="${v.driver_id !=null }">
					<a onclick="newWindow('司机详情','<%=staticPath %>/supplier/driver/driverDetail.htm?id=${v.driver_id }')" 
					href="javascript:void(0)">${v.driver_name }</a></c:when>
					<c:otherwise>${v.driver_name }</c:otherwise>
					</c:choose>
				</td>
				<td><fmt:formatNumber value="${v.item_price}" type="currency" pattern="#.##"/></td>
				<td>
					<font color="blue">
						<span class="price" onclick="changePrice(this,${v.id})">
						<c:if test="${v.operate_price == null }">0</c:if>
						<c:if test="${v.operate_price != null }">
							<fmt:formatNumber value="${v.operate_price}" type="currency" pattern="#.##"/>
						</c:if>
					</span>
					</font>
				</td>
				<td id="ttd"><fmt:formatNumber value="${v.item_price-v.operate_price}" type="currency" pattern="#.##"/></td>
			</tr>
			<c:set var="sum_item_price" value="${sum_item_price+v.item_price }" />
			<c:set var="sum_operate_price" value="${sum_operate_price+v.operate_price}" />
			<c:set var="sum_ttd" value="${sum_ttd+v.item_price-v.operate_price}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			<td colspan="10" >合计：</td>
		    <td><fmt:formatNumber value="${sum_item_price}" type="currency" pattern="#.##"/></td>
         	<td><fmt:formatNumber value="${sum_operate_price}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_ttd}" type="currency" pattern="#.##"/></td>
		</tr>
		<tr>
			
			<td colspan="10" >总计：</td>
		    <td><fmt:formatNumber value="${sum.item_price}" type="currency" pattern="#.##"/></td>
         	<td><fmt:formatNumber value="${sum.operate_price}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum.item_price-sum.operate_price}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
	
</script>
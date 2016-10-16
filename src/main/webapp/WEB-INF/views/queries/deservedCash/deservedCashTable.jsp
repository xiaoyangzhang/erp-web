<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	String staticPath = request.getContextPath();
%>

<table class="w_table" id="deservedCashTable">
<colgroup>
		<col width="3%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="5%" />
		<%-- <col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="8%" />
		<col width="5%" />
		<col width="8%" />
		<col width="8%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" /> --%>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调 <i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>客人/性别/年龄/证件号/客源地<i class="w_table_split"></i></th>
			<!-- <th>客人<i class="w_table_split"></i></th>
			<th>性别<i class="w_table_split"></i></th>
			<th>年龄<i class="w_table_split"></i></th>
			<th>证件号<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th> -->
			<th>接机<i class="w_table_split"></i></th>
			<th>送机<i class="w_table_split"></i></th>
			<th>价格<i class="w_table_split"></i></th>
			<!-- <th>类别<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th> -->
			<th>合计<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
	
			<input type="hidden"  id="searchPageSize" value="${pageBean.pageSize }"/>
			
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td style="text-align: left;">
				<c:choose>
                  		<c:when test="${v.groupMode > 0}">
                  		
                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a> </c:when>
                  		<c:otherwise>
				 <a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${v.groupId}&operType=0')">${v.groupCode}</a>
                  		
                  		</c:otherwise>
                  	</c:choose>
				</td>
				<td style="text-align: left;">【${v.productBrandName }】${v.productName }</td>
				<td style="text-align: left;">${v.supplierName }</td>
				<td>${v.saleOperatorName }</td>
				<td>${v.numAdult}大${v.numChild}小${v.numGuide}陪</td>
				<td>${v.operatorName }</td>
				<td>${v.receiveMode }</td>
				<td style="text-align: left;">
				<c:if test="${v.guestInfo!=null }">
				                  ${fn:replace(v.guestInfo,',','</br>') }
				                  	 
				                  	</c:if></td>
				
				<td style="text-align: left;"><c:if test="${v.pickUpInfo!=null }">
				                  ${fn:replace(v.pickUpInfo,',','</br>') }
				                  	 
				                  	</c:if></td>
				<td style="text-align: left;"><c:if test="${v.transferInfo!=null }">
				                  ${fn:replace(v.transferInfo,',','</br>') }
				                  	 
				                  	</c:if></td>
				<td style="text-align: left;"><c:if test="${v.priceInfo !=null }">
				                  ${fn:replace(v.priceInfo ,',','</br>') }
				                  	 
				                  	</c:if></td>
				<td ><fmt:formatNumber value="${v.totalSum}" type="currency" pattern="#.##"/></td>
			</tr>
			<c:set var="sumTotalPrice" value="${sumTotalPrice+v.totalSum}" />
			<c:set var="totalAdult" value="${totalAdult+v.numAdult}" />
			<c:set var="totalChild" value="${totalChild+v.numChild}" />
			<c:set var="totalGuide" value="${totalGuide+v.numGuide}" />
		</c:forEach>
	</tbody>
	<tbody>
		<tr>
			
			<td colspan="5" >合计：</td>
			<td>${ totalAdult}大${totalChild}小${totalGuide }陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		   <td><fmt:formatNumber value="${ sumTotalPrice}" type="currency" pattern="#.##"/></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			
			<td colspan="5" >总计：</td>
			<td>${ sum.totalAdult}大${sum.totalChild}小${sum.totalGuide }陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		   <td><fmt:formatNumber value="${ sum.totalSum}" type="currency" pattern="#.##"/></td>
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
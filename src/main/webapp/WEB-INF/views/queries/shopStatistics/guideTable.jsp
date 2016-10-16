<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table cellspacing="0" cellpadding="0" class="w_table" id="payTable">
	<colgroup>
		<col width="3%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
	</colgroup>
	<thead>
		<tr>
			<th id="index" >序号<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>团数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>进店数<i class="w_table_split"></i></th>
			<th>计划购物金额<i class="w_table_split"></i></th>
			<th>实际购物金额<i class="w_table_split"></i></th>
			<th>差额<i class="w_table_split"></i></th>
			<th>完成率<i class="w_table_split"></i></th>
			<th>人均购物(/成人数)<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
			<th>其他佣金<i class="w_table_split"></i></th>
			<th>购物利润<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="v" varStatus="vs">
			<tr>
				<td>${vs.count}</td>
				<td>${v.guide_name }</td>
				<td><fmt:formatNumber value="${v.group_num }" type="currency" pattern="#.##"/></td>
				<td>${v.total_adult}+${v.total_child}+${v.total_guide}</td>
				<td><fmt:formatNumber value="${v.jds }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.planSales }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.factSales }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.factSales-v.planSales }" type="currency" pattern="#.##"/></td>
				<td><c:if test="${v.planSales!='0.0000' and v.factSales!='0.0000'}">
						<fmt:formatNumber value="${v.factSales/v.planSales }" type="percent" />
					</c:if>
				</td>
				<td>
				<c:choose>
			<c:when test="${v.total_adult ne 0 and v.factSales  ne 0.0000 }">
			<fmt:formatNumber type="number"  value="${v.factSales /v.total_adult}" pattern="#.##" /></c:when>
			<c:otherwise><fmt:formatNumber type="number" value="0" pattern="#.##" /></c:otherwise>
			</c:choose>
				</td>
				<td><fmt:formatNumber value="${v.payReturn }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.total_commission }" type="currency" pattern="#.##"/></td>
				<td><fmt:formatNumber value="${v.payReturn-v.total_commission }" type="currency" pattern="#.##"/></td>
			</tr>
				<c:set var="countGroup" value="${countGroup+v.group_num}" />				
				<c:set var="countShop" value="${countShop+v.jds }" />
				<c:set var="planSales" value="${planSales+v.planSales }" />
				<c:set var="factSales" value="${factSales+v.factSales }" />
				<c:set var="fp" value="${fp+v.factSales-v.planSales }" />
				<c:set var="payReturn" value="${payReturn+v.payReturn }" />
				<c:set var="totalCommission" value="${totalCommission+v.total_commission }" />
				<c:set var="totalAdult" value="${totalAdult+v.total_adult }" />
				<c:set var="totalChild" value="${totalChild+v.total_child }" />
				<c:set var="totalGuide" value="${totalGuide+v.total_guide }" />
		</c:forEach>
	</tbody>
		<tr>
			
			<td colspan="2" style="text-align: right">合计：</td>
			<td><fmt:formatNumber value="${countGroup }" type="currency" pattern="#.##"/></td>
			<td>${totalAdult }+${totalChild }+${totalGuide }</td>
			<td><fmt:formatNumber value="${countShop }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${planSales }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${factSales }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${fp }" type="currency" pattern="#.##"/></td>
			<td></td>
			<td><c:choose>
				<c:when test="${totalAdult ne 0 and factSales  ne 0.0000 }">
				<fmt:formatNumber type="number"  value="${factSales /totalAdult}" pattern="#.##" /></c:when>
				<c:otherwise><fmt:formatNumber type="number" value="0" pattern="#.##" /></c:otherwise>
				</c:choose>
			</td>
			<td><fmt:formatNumber value="${payReturn }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${totalCommission }" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${payReturn-totalCommission }" type="currency" pattern="#.##"/></td>
		</tr>
</table>
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

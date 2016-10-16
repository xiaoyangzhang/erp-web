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
	<col width="6%" />
	<col width="6%" />
	<col width="5%" />
	<col width="3%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	
	<col width="5%" />
	<col width="5%" />
	
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>客源等级<i class="w_table_split"></i></th>
			<th>团期<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>成人|儿童<i class="w_table_split"></i></th>
			
			<th>购物店<i class="w_table_split"></i></th>
			<th>进店人数<i class="w_table_split"></i></th>
			<th>进店日期<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>导管<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>人均购物<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
			
			<th>其他佣金<i class="w_table_split"></i></th>
			<th>购物利润<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.group_id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看散客团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.group_id}&operType=0')">${item.group_code}</a>
	              </c:if>
               </td>
               <td>【${item.product_brand_name}】${item.product_name}</td>
               <td>${item.province_name}</td>
				<td>${item.source_type_name}</td>
				<td>${item.date_start}</td>
				<td>${item.operator_name }</td>
				<td>${item.total_adult }大${item.total_child}小</td>
				
				<c:set var="sum_group_total_fact" value="0" />
				<c:set var="sum_group_person_buy_avg" value="0" />
				<c:set var="sum_group_total_repay" value="0" />
				<c:set var="sum_group_total_person_num" value="0" />
				<c:set var="total_person" value="${item.total_adult+item.total_child}" />
				<c:set var="sum_person" value="${sum_person+total_person}" />
				
				<td colspan="8">
					<c:if test="${not empty item.shops}">
					<table  class="in_table" >
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.shops}" var="detail" varStatus="status">
							<tr>
								<td>${detail.shop_supplier_name}</td>
								<td>${detail.person_num}</td>
								<td>${detail.shop_date}</td>
								<td>${detail.guide_name}</td>
								<td>${detail.guide_manage_name}</td>
								<td><fmt:formatNumber value="${detail.total_fact}" pattern="#.##" type="currency"/></td>
								<%-- <td><fmt:formatNumber value="${detail.total_fact/detail.person_num}" pattern="#.##" type="currency"/></td> --%>
								<td>
									<c:if test="${empty detail.person_num or detail.person_num eq 0}">0</c:if>
									<c:if test="${not empty detail.person_num and (detail.person_num >0 or detail.person_num <0)}">
										<fmt:formatNumber value="${detail.total_fact/detail.person_num}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								<td><fmt:formatNumber value="${detail.total_repay}" pattern="#.##" type="currency"/></td>
								
								<c:set var="sum_group_total_fact" value="${sum_group_total_fact + detail.total_fact}" />
 								<c:set var="sum_group_person_buy_avg" value="${sum_group_person_buy_avg + detail.person_buy_avg}" />
 								<c:set var="sum_group_total_repay" value="${sum_group_total_repay + detail.total_repay}" />
 								<c:set var="sum_group_total_person_num" value="${sum_group_total_person_num + detail.person_num}" />
								
								<c:set var="sum_person_num" value="${sum_person_num + detail.person_num}" />
								<c:set var="sum_total_fact" value="${sum_total_fact + detail.total_fact}" />
 								<c:set var="sum_person_buy_avg" value="${sum_person_buy_avg + detail.person_buy_avg}" />
 								<c:set var="sum_total_repay" value="${sum_total_repay + detail.total_repay}" />
							</tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
				
				<td>
					<a href="javascript:void();" onclick="showCommission(${item.group_id})">
						<fmt:formatNumber value="${item.total_comm }" pattern="#.##" type="currency"/>
					<a>
				</td>
				<td><fmt:formatNumber value="${item.shop_profit }" pattern="#.##" type="currency"/></td>
				
				<c:set var="sum_total_comm" value="${sum_total_comm + item.total_comm}" />
 				<c:set var="sum_shop_profit" value="${sum_shop_profit + item.shop_profit}" />
			</tr>
			<tr>
				<td colspan="13">合计：</td>
				<td><fmt:formatNumber value="${sum_group_total_fact}" pattern="#.##" type="currency"/></td>
				<td>
				<c:if test="${item.total_adult eq 0 }">${sum_group_person_buy_avg}</c:if>
					<c:if test="${item.total_adult ne 0 }">
						<fmt:formatNumber value="${sum_group_total_fact/item.total_adult}" pattern="#.##" type="currency"/>
					</c:if>
				</td>
				<td><fmt:formatNumber value="${sum_group_total_repay}" pattern="#.##" type="currency"/></td>
				<td></td>
				<td></td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="13">本页合计：</td>
			<td><fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/></td>
			<td>
				 <c:if test="${sum_person_num eq 0}">
					<fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/>
				</c:if>
				<c:if test="${sum_person_num ne 0}">
					<fmt:formatNumber value="${sum_total_fact/sum_person}" pattern="#.##" type="currency"/>
				</c:if> 
			</td>
			<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_total_comm}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_shop_profit}" pattern="#.##" type="currency"/></td>
		</tr>
		
		<tr>
			<td colspan="13">总合计：</td>
			<td><fmt:formatNumber value="${totalCommMap.all_total_fact}" pattern="#.##" type="currency"/></td>
			<td><%-- <fmt:formatNumber value="${totalMap.all_person_buy_avg}" pattern="#.##" type="currency"/> --%></td>
			<td><fmt:formatNumber value="${totalCommMap.all_total_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_comm}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${totalMap.all_total_repay-totalMap.all_total_comm}" pattern="#.##" type="currency"/></td>
		</tr>
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
		var searchHeight = $(".p_container_sub").height()+110;
		var docHeight = $(window).height()-searchHeight;		
		var tHeight=docHeight+"px";
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})
</script>
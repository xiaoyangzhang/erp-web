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
	<col width="8%" />
	<col width="15%" />
	<col width="5%" />
	<col width="4%" />
	<col width="8%" />
	<col width="3%" />
	<%-- <col width="7%" /> --%>
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	
	<col width="5%" />
	<col width="5%" />
	<c:if test="${reqpm.isShow ne true }">
	<col width="5%" />
	</c:if>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>购物店<i class="w_table_split"></i></th>
			<th>进店人数<i class="w_table_split"></i></th>
			
			<th>购物项目<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>购物合计<i class="w_table_split"></i></th>
			
			
			<th>社佣比例<i class="w_table_split"></i></th>
			<th>社佣金额<i class="w_table_split"></i></th>
			<th>社佣合计<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<c:if test="${reqpm.isShow ne true }">
			<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
			</c:if>
			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看散客团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a>
	              </c:if>
              </td>
				<td style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td ><fmt:formatDate value="${item.date_start}" pattern="yyyy-MM-dd" /></td>
				<td  style="text-align: left;">${item.operator_name}</td>
				<td  style="text-align: left;">${item.supplier_name}</td>
				<td >	${item.person_num eq null?0:item.person_num}
				</td>
				<td colspan="2">
					<table class="in_table">
						<col width="50%" />
						<col width="50%" />
						<thead></thead>
						<tbody>
					<c:if test="${not empty item.bookingShopVerifyDetailList}">
							<c:forEach items="${item.bookingShopVerifyDetailList}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.bookingShopVerifyDetailList) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"\"" /> <!-- border-bottom:0px; -->
								</c:if>
							<tr>
								<td>${bill.goods_name}</td>
								<td ${borderCss } ><fmt:formatNumber value="${bill.sum_buy_total}" pattern="#.##" type="currency"/></td>
							</tr>
							<c:set var="sum_cash" value="${sum_cash+bill.sum_buy_total }" />
							<c:set var="sum_shop_total" value="${sum_shop_total+bill.sum_buy_total}" />
							</c:forEach>
					</c:if>
						</tbody>
					</table>
				</td>
				<td ><fmt:formatNumber value="${sum_cash}" pattern="#.##" type="currency"/></td>
				<c:set var="sum_cash" value="0" />
				
				<td colspan="2">
					<c:if test="${not empty item.bookingShopVerifyDetailList}">
					<table class="in_table">
						<col width="50%" />
						<col width="50%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.bookingShopVerifyDetailList}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.bookingShopVerifyDetailList) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"\"" /> <!-- border-bottom:0px; -->
								</c:if>
							<tr>
								<td ${borderCss2 } >
									<fmt:formatNumber value="${bill.repay_val}" pattern="#.####" type="currency"/>% 
								</td>
								<td ${borderCss } ><fmt:formatNumber value="${bill.sum_repay_total}" pattern="#.##" type="currency"/></td>
							</tr>
							<c:set var="sum_cash2" value="${sum_cash2+bill.sum_repay_total }" />
							<c:set var="sum_repay" value="${sum_repay+bill.sum_repay_total}" />
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
				<td  ><fmt:formatNumber value="${sum_cash2}" pattern="#.##" type="currency"/></td>
				<c:set var="sum_cash2" value="0" />
				<td>
				<c:forEach items="${supplierGuides}" var="sGuide">
					<c:if test="${item.guide_id eq sGuide.id}">
						${sGuide.name}
					</c:if>
				</c:forEach>
				</td>
				<td>
					<%-- <c:if test="${item.state_seal ne 1 }"> --%>
						<c:if test="${item.state_finance != 1 }">未审核</c:if>
						<c:if test="${item.state_finance == 1 }">已审核</c:if>
					<%-- </c:if>
					<c:if test="${item.state_seal eq 1 }">
						已封存
					</c:if> --%>
				</td>
				<c:if test="${reqpm.isShow ne true }">
				<td>
					<c:if test="${item.group_state ne 0 }">	
						<input type="checkbox" name="audit_id" value="${item.id}" groupId="${item.groupId}" ${not empty item.audit_time?'checked':''} />
					</c:if>
				</td>
				</c:if>
			</tr>
			<c:set var="sum_person_num" value="${sum_person_num+item.person_num }" />
		</c:forEach>
		<tr>
			<td colspan="6">合计：</td>
			<td>${sum_person_num}</td>
			<td></td>
			<td><fmt:formatNumber value="${sum_shop_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_shop_total}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_repay}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${sum_repay}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td></td>
			<c:if test="${reqpm.isShow ne true }">
			<td></td>
			</c:if>
		</tr>
		<tr>
			<td colspan="6">总合计：</td>
			<td>${map.total_person}</td>
			<td></td>
			<td><fmt:formatNumber value="${map.buy_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${map.buy_total}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td><fmt:formatNumber value="${map.repay_total}" pattern="#.##" type="currency"/></td>
			<td><fmt:formatNumber value="${map.repay_total}" pattern="#.##" type="currency"/></td>
			<td></td>
			<td></td>
			<c:if test="${reqpm.isShow ne true }">
			<td></td>
			</c:if>
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
		var searchHeight = $(".p_container").height()+110;
		var docHeight = $(window).height()-searchHeight;		
		var tHeight=docHeight+"px";
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})
</script>
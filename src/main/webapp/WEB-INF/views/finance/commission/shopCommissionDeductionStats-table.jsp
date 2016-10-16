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
	<col width="5%" />
	<col width="16%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="15%" />
	<col width="14%" />
	
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<col width="5%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>带团人数<i class="w_table_split"></i></th>
			<th>银行账号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			
			<th>项目<i class="w_table_split"></i></th>
			<th>类型<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
			<th>已付款<i class="w_table_split"></i></th>
			<th>未付款<i class="w_table_split"></i></th>
			
			<th>状态<i class="w_table_split"></i></th>
			<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td >
					<c:if test="${item.group.groupMode <= 0}">
	              		<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a> 
	              	</c:if>
	              	<c:if test="${item.group.groupMode > 0}">
	              		<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.groupCode}</a>
	              	</c:if>
				</td>
				<td>${item.group.operatorName}</td>
				<td>${item.guideName}</td>
				<td>${item.personNum}</td>
				<td>${item.bankAccount}</td>
				<td>【${item.group.productBrandName}】${item.group.productName}</td>
				
				<td colspan="7">
					<table class="in_table" >
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<col width="14%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.comms}" var="comm" >
							<tr>
								<td>
									<c:forEach items="${dicInfoList}" var="dicInfo" >
										<c:if test="${dicInfo.code eq comm.commissionType }">${dicInfo.value}</c:if>
									</c:forEach>
								</td>
								<td>
									<c:if test="${comm.total > 0 }">发放</c:if>
									<c:if test="${comm.total <= 0 }">扣除</c:if>
								</td>
								<td>
									<c:set var="total" value="${fn:replace(comm.total,'-', '')}" />
									<fmt:formatNumber value="${total }" pattern="#.##"/>
								</td>
								<td>
									<c:set var="totalCash" value="${fn:replace(comm.totalCash,'-', '')}" />
									<fmt:formatNumber value="${totalCash }" pattern="#.##"/>
								</td>
								<td>
									<fmt:formatNumber value="${total - totalCash }" pattern="#.##"/>
								</td>
								<td>
									<c:if test="${comm.stateSeal eq 0 }">
										<c:if test="${comm.stateFinance == 0 }">未审核</c:if>
										<c:if test="${comm.stateFinance == 1 }">已审核</c:if>
									</c:if>
									<c:if test="${comm.stateSeal eq 1 }">
										已封存
									</c:if>
								</td>
								<td>
									<c:if test="${comm.stateSeal ne 1 and comm.total.compareTo(comm.totalCash) ne 0}">
										<input type="checkbox" name="audit_id" groupId="${item.groupId}" value="${comm.id}" ${comm.stateFinance eq 1 ?'checked':''} />
									</c:if> 
								</td>							
							</tr>
							<c:set var="sum_total" value="${sum_total + comm.total }" />
							<c:set var="sum_total_cash" value="${sum_total_cash + comm.totalCash}" />
							</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="9">合计:</td>
			<td><fmt:formatNumber value="${sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_total-sum_total_cash }" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="9">总合计:</td>
			<td><fmt:formatNumber value="${sums.sum_total }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sums.sum_total_cash }" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sums.sum_total-sums.sum_total_cash }" pattern="#.##"/></td>
			<td></td>
			<td></td>
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
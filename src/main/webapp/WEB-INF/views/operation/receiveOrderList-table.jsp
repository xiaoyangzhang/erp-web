<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
 <%@ include file="/WEB-INF/include/path.jsp" %>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="10%" />
	<col width="12%" />
	<col width="5%" />
	<col width="5%" />
	<col width="7%" />
	<col width="5%" />
	<col width="5%" />
	
	<col width="4%" />
	<col width="3%" />
	<col width="10%" />

	<col width="5%" />
	<col width="4%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>申请人<i class="w_table_split"></i></th>
			<th>申请时间<i class="w_table_split"></i></th>
			
			<th>单据类型<i class="w_table_split"></i></th>
			<th>数量<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			
			<th>状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr id="${item.id}">
				<td>${status.index+1}</td>
				<td  style="text-align: left;">
					<c:if test="${item.group_mode<1}">
					<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a></td>
	              </c:if>
	              <c:if test="${item.group_mode>0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id }&operType=0')">${item.group_code}</a></td>
	              </c:if>
				</td>
				<td  style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td >${item.operator_name}</td>
				<td >${item.person_count}</td>
				<td >${item.guide_name }</td>
				<td >${item.applicant }</td>
				<td style="text-align: left;"><fmt:formatDate value="${item.appli_time}" pattern="yyyy-MM-dd" /></td>
				<td colspan="3">
					<c:if test="${not empty item.financeBillDetailList}">
					<table class="in_table">
						<col width="23%" />
						<col width="20%" />
						<col width="57%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.financeBillDetailList}" var="bill" varStatus="status">
								<c:if test="${fn:length(item.financeBillDetailList) == status.index + 1}">
									<c:set var="borderCss"  value="style=\"border-bottom:0px;\"" />
								</c:if>
							<tr>
								<td ${borderCss } >
									<c:forEach items="${billTypeList}" var="dicBill">
										<c:if test="${dicBill.code eq bill.bill_type}">
											${dicBill.value}
										</c:if>
									</c:forEach>
								</td>
								<td ${borderCss } >${bill.num }</td>
								<td ${borderCss } >${bill.remark }</td>
							<tr>
							</c:forEach>
						</tbody>
					</table>
					</c:if>
				</td>
				<c:if test="${null==item.appli_state}">
					<td >未申请</td>
				</c:if>
				<c:if test="${'APPLIED'==item.appli_state}">
					<td >已申请</td>
				</c:if>
				<c:if test="${'RECEIVED'==item.appli_state}">
					<td >已领单</td>
				</c:if>
				<c:if test="${'VERIFIED'==item.appli_state}">
					<td >已销单</td>
				</c:if>
				<td >
					<div class="tab-operate">
						<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
						<div class="btn-hide">	
						<c:if test="${empty item.appli_state}">
							<a class="def" href="javascript:void(0)" onclick="applyOrUpdate('${item.id}','${item.guide_id}', '${item.guide_name }', 'APPLIED', true)">申请</a>
						</c:if>
	                    <c:if test="${'APPLIED'==item.appli_state}">
							<a class="def" href="javascript:void(0)" onclick="showView('${item.group_code}','${item.id}','${item.guide_id}', '${item.guide_name }', false)">查看</a>
		                    <a class="def" href="javascript:void(0)" onclick="applyOrUpdate('${item.id}','${item.guide_id}', '${item.guide_name }', 'UPDATE', false)">修改</a> 
		                  	<a class="def" href="javascript:void(0)" onclick="deleteBill('${item.id}','${item.guide_id}')">删除</a>
						</c:if>
						<c:if test="${'RECEIVED'==item.appli_state}">
							<%-- <a class="def" href="javascript:void(0)" onclick="delReceived('${item.group_id}','${item.guide_id}')">取消领单</a> --%>
							<a class="def" href="javascript:void(0)" onclick="showView('${item.group_code}','${item.id}','${item.guide_id}', '${item.guide_name }')">查看</a>
						</c:if>
						<c:if test="${'VERIFIED'==item.appli_state}">
							<a class="def" href="javascript:void(0)" onclick="showView('${item.group_code}','${item.id}','${item.guide_id}', '${item.guide_name }')">查看</a>
						</c:if>
						</div>
					</div>
				</td>
			</tr>
		</c:forEach>
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
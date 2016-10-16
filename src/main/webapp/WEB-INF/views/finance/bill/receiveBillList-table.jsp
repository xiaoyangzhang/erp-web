<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="10%" />
	<col width="15%" />
	<col width="5%" />
	<col width="5%" />
	<col width="7%" />
	<col width="5%" />
	<col width="5%" />
	
	<col width="4%" />
	<col width="3%" />
	<col width="10%" />

	<col width="5%" />
	<col width="8%" />
	
	<thead>
		<tr>
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
		<c:forEach items="${pageBean.result}" var="item" >
			<c:if test="${empty item.financeBillDetailList}">
				<tr id="${item.id}">
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
	              </c:if>
              </td>
				<td  style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td >${item.operator_name}</td>
				<td >${item.person_count}</td>
				<td >${item.guide_name }</td>
				<td >${item.applicant }</td>
				<td style="text-align: left;"><fmt:formatDate value="${item.appli_time}" pattern="yyyy-MM-dd" />
				</td>
				<td></td>
				<td></td>
				<td></td>
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
                    <c:if test="${'APPLIED'==item.appli_state}">
						<a class="button button-rounded button-tinier" 
<%-- 	                        onclick="distribute('${item.id }','${item.guide_id }','${item.group_code }','${item.guide_name }','${item.applicant }','${item.appli_time}')">派单11</a> --%>
						
	                        onclick="newWindow('领单管理-派单', '<%=staticPath%>/finance/diatributeBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }')">派单</a>
	                    <a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
					<c:if test="${'RECEIVED'==item.appli_state}">
						<a class="button button-rounded button-tinier" onclick="delReceived('${item.group_id}','${item.guide_id}')">取消领单</a>
						<a class="button button-rounded button-tinier" 
	                        onclick="newWindow('领单管理-销单', '<%=staticPath%>/finance/verifyBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }')">销单</a>
						<a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
					<c:if test="${'VERIFIED'==item.appli_state}">
						<a class="button button-rounded button-tinier" 
	                    	onclick="delVerify('${item.order_id }','${item.guide_id }','${item.group_code }');">取消销单</a>
						<a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
				</td>
			</tr>
			</c:if>
			<c:forEach items="${item.financeBillDetailList}" var="bill" varStatus="status">
			<tr id="${item.id}">
				<c:if test="${status.index==0}">
				<td  rowspan="${item.financeBillNum}" style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
	              </c:if>
              	</td>
				<td rowspan="${item.financeBillNum}" style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
				<td rowspan="${item.financeBillNum}">${item.operator_name}</td>
				<td rowspan="${item.financeBillNum}">${item.person_count}</td>
				<td rowspan="${item.financeBillNum}">${item.guide_name }</td>
				<td rowspan="${item.financeBillNum}">${item.applicant }</td>
				<td rowspan="${item.financeBillNum}" style="text-align: left;"><fmt:formatDate value="${item.appli_time}" pattern="yyyy-MM-dd" />
				</td>
				</c:if>
				<td>
					<c:forEach items="${billTypeList}" var="dicBill">
						<c:if test="${dicBill.code eq bill.bill_type}">
							${dicBill.value}
						</c:if>
					</c:forEach>
				</td>
				<td>${bill.num }</td>
				<td>${bill.remark }</td>
				<c:if test="${status.index==0}">
				<c:if test="${'APPLIED'==item.appli_state}">
					<td rowspan="${item.financeBillNum}">已申请</td>
				</c:if>
				<c:if test="${'RECEIVED'==item.appli_state}">
					<td rowspan="${item.financeBillNum}">已领单</td>
				</c:if>
				<c:if test="${'VERIFIED'==item.appli_state}">
					<td rowspan="${item.financeBillNum}">已销单</td>
				</c:if>
				<td rowspan="${item.financeBillNum}">
					<c:if test="${'APPLIED'==item.appli_state}">
						<a class="button button-rounded button-tinier" 
	                        onclick="newWindow('领单管理-派单', '<%=staticPath%>/finance/diatributeBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }')">派单</a>
	                    <a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
					<c:if test="${'RECEIVED'==item.appli_state}">
						<a class="button button-rounded button-tinier" onclick="delReceived('${item.group_id}','${item.guide_id}')">取消领单</a>
						<a class="button button-rounded button-tinier" 
	                        onclick="newWindow('领单管理-销单', '<%=staticPath%>/finance/verifyBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }')">销单</a>
	                    <a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
					<c:if test="${'VERIFIED'==item.appli_state}">
						<a class="button button-rounded button-tinier" 
	                    	onclick="delVerify('${item.order_id }','${item.guide_id }','${item.group_code }');">取消销单</a>
						<a class="button button-rounded button-tinier" 
	                    	onclick="newWindow('领单管理-查看', '<%=staticPath%>/finance/checkBill.htm?id=${item.id }&guideId=${item.guide_id }&groupCode=${item.group_code }&appliState=${item.appli_state }')">查看</a> 
					</c:if>
					
				</td>
				</c:if>
			</tr>
			</c:forEach>
		</c:forEach>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
 		</dd>
        </dl>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
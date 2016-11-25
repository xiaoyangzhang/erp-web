<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
	String staticPath = request.getContextPath();
%>

<table class="w_table" id="deservedCashTable">
	<%-- <colgroup>
		<col width="13%" />
		<col width="10%" />
		<col width="93px" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="5%" />
	</colgroup> --%>
	<thead>
		<tr>
			<th style="width: 110px;">机构<i class="w_table_split"></i></th>
			<th style="width: 100px;">部门<i class="w_table_split"></i></th>

			<th style="width: 89px;">销售<i class="w_table_split"></i></th>
			<!-- <th style="width: 76px;">计调<i class="w_table_split"></i></th>

			<th style="width: 178px;">团号<i class="w_table_split"></i></th>
			<th style="width: 74px;">类别<i class="w_table_split"></i></th> -->
			<th style="width: 129px;">品牌<i class="w_table_split"></i></th>
			<th style="width: 198px;">产品<i class="w_table_split"></i></th>

			<th style="width: 71px;">人数<i class="w_table_split"></i></th>
			<th style="width: 74px;">团款<i class="w_table_split"></i></th>
			<th style="width: 75px;">已收<i class="w_table_split"></i></th>
			<!-- <th style="width: 87px;">操作<i class="w_table_split"></i></th> -->
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${secLevelOrgList}" var="org" varStatus="orgVs">
		
			<tr>
				<td style="width: 110px;" rowspan="${org.bizId+2}">${org.name }</td>
				<c:forEach items="${orgDepMap[org.orgId]}" var="dept"
					varStatus="deptVs">
					<tr>
						<td style="width: 80px;">${dept.name }
						【<a href="javascript:void(0);" class="def"
							onclick="paymentDetail('${dept.orgId}','${dept.name}')">明细</a>】</td>
						<td colspan="9">
							<table style="width: 100%;">
								<c:set var="sumNumAdult" value="0" />
        						<c:set var="sumNumChild" value="0" />
        						<c:set var="sumTotal" value="0" />
        						<c:set var="sumTotalCash" value="0" />
								<c:forEach items="${empMap[dept.orgId]}" var="emp"
									varStatus="empVs">
									<tr>
										<td style="width: 123px;">${emp.name }</td>
										<td><table style="width: 100%;">
												<c:if test="${empty orderMap[emp.employeeId]}">
													<tr>
														<td style="width: 179px;"></td>
														<td style="width: 276px;"></td>
														<td style="width: 99px;"></td>
														<td style="width: 103px;"></td>
														<td style="width: 103px;"></td>
													</tr>
												</c:if>
												<c:forEach items="${orderMap[emp.employeeId]}" var="order"
													varStatus="orderVs">
													<tr>
														<%-- <td style="width: 75px;text-align: left;">${order.operatorName }</td> --%>
														<%-- <td style="width: 178px;text-align: left;">${order.groupCode }</td> --%>
														
														<%-- <td style="width: 74px;">
															<c:choose>
																<c:when test="${order.sourceTypes ne null}">
																	${order.sourceTypes =='0'?"自有":"采购"}
																</c:when>
																<c:otherwise>
																	${order.sourceTypes }
																</c:otherwise>
															</c:choose>
														</td> --%>
														<td style="width: 179px;text-align: left;">${order.productBrandName }</td>
														<td style="width: 276px;text-align: left;">${order.productName }</td>
														<td style="width: 99px;">${order.numAdult }+${order.numChild }</td>
														<td style="width: 103px;"><fmt:formatNumber
																value="${order.total eq null?0:order.total}"
																pattern="#.##" type="number" /></td>
														<td style="width: 103px;"><fmt:formatNumber
																value="${order.totalCash eq null?0:order.totalCash}"
																pattern="#.##" type="number" /></td>
														
																
													</tr>
													<c:set var="sumNumAdult" value="${sumNumAdult+order.numAdult}" />
        											<c:set var="sumNumChild" value="${sumNumChild+order.numChild}" />
        											<c:set var="sumTotal" value="${sumTotal+order.total}" />
        											<c:set var="sumTotalCash" value="${sumTotalCash+order.totalCash}" />
												</c:forEach>
											</table></td>
									</tr>
								</c:forEach>
								<tr>
									<td style="width: 122px;">小计</td>
									<td>
										<table style="width: 100%;">
											<tr>
												<!-- <td style="width: 84px;"></td>
												<td style="width: 197px;"></td>-->
												<td style="width: 179px;"></td>
												<td style="width: 276px;"></td>
												
												 <td style="width: 99px;">${sumNumAdult}+${sumNumChild}</td>
												<td style="width: 103px;"><fmt:formatNumber
																value="${sumTotal eq null?0:sumTotal}"
																pattern="#.##" type="number" /></td>
												<td style="width: 103px;"><fmt:formatNumber
																value="${sumTotalCash eq null?0:sumTotalCash}"
																pattern="#.##" type="number" /></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<c:set var="countNumAdult" value="${countNumAdult+sumNumAdult}" />
					<c:set var="countNumChild" value="${countNumChild+sumNumChild}" />
					<c:set var="countTotal" value="${countTotal+sumTotal}" />
					<c:set var="countTotalCash" value="${countTotalCash+sumTotalCash}" />
				</c:forEach>
			</tr>
			<tr>
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				
				<td>${countNumAdult }+${countNumChild }</td>
				<td>${countTotal }</td>
				<td>${countTotalCash }</td>
				
			</tr>
		</c:forEach>
	</tbody>
</table>
<%-- <script type="text/javascript">
/* 明细*/
function paymentOrderDetail(pid) {
	alert(pid);
	newWindow('应收款明细','<%=staticPath%>/query/paymentDetailList')
} 
</script> --%>

<script type="text/javascript">
function paymentDetail(orgId,deptName){
	var url = '<%=staticPath%>/query/paymentDetailList.htm?dateType=' + $("#dateType").val();
		if ($("#startTime").val() != '') {
			url += '&startTime=' + $("#startTime").val();
		}
		if ($("#endTime").val() != '') {
			url += '&endTime=' + $("#endTime").val();
		}
		if ($("#productName").val() != '') {
			url += '&productName=' + $("#productName").val();
		}
		url += '&orgNames=' + deptName;
		url += '&orgIds=' + orgId;
		if ($("#supplierName").val() != '') {
			url += '&supplierName=' + $("#supplierName").val();
		}
		newWindow('应收款明细', url);
	}
</script>

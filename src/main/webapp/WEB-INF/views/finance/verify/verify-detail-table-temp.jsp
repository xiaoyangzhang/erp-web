<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table id="detailOrderTable" cellspacing="0" cellpadding="0" class="w_table">
	<c:if test="${reqpm.supplierType eq 1 }">
		<col width="3%" />
		<col width="14%" />
	
		<col width="11%" />
		<col width="7%" />
		<col width="3%" />
		
		<col width="10%" />
		<col width="3%" />
		<col width="15%" />
		<col width="3%" />
		<col width="3%" />
		<col width="3%" />
		<col width="5%" />
		<col width="5%" />
		<col width="10%" />
		<col width="5%" />
	</c:if>
	<c:if test="${reqpm.supplierType eq 16}">
		<col width="3%" />
		<col width="14%" />
		
		<col width="13%" />
		<col width="3%" />
		
		<col width="6%" />
		<col width="3%" />
		<col width="15%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="13%" />
		<col width="5%" />
	</c:if>
	<c:if test="${reqpm.supplierType ne 1 && reqpm.supplierType ne 16}">
		<col width="3%" />
		<col width="16%" />
		
		<col width="10%" />
		
		<col width="10%" />
		<col width="3%" />
		<col width="15%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="5%" />
		<col width="13%" />
		<col width="5%" />
	</c:if>
	<thead>
<!-- 		<th>序号<i class="w_table_split"></i></th> -->
<!-- 		<th>产品<i class="w_table_split"></i></th> -->
		
<%-- 		<c:if test="${reqpm.supplierType eq 1 }"> --%>
<!-- 			<th>团号<i class="w_table_split"></i></th> -->
<!-- 			<th>接站牌<i class="w_table_split"></i></th> -->
<!-- 			<th>人数<i class="w_table_split"></i></th> -->
<%-- 		</c:if> --%>
<%-- 		<c:if test="${reqpm.supplierType eq 16 }"> --%>
<!-- 			<th>人数<i class="w_table_split"></i></th> -->
<%-- 		</c:if> --%>
<%-- 		<c:if test="${reqpm.supplierType ne 1 &&  reqpm.supplierType ne 16}"> --%>
<!-- 			<th>团号<i class="w_table_split"></i></th> -->
<%-- 		</c:if> --%>
		
<!-- 		<th>日期<i class="w_table_split"></i></th> -->
<!-- 		<th>计调<i class="w_table_split"></i></th> -->
<!-- 		<th>明细<i class="w_table_split"></i></th> -->
<!-- 		<th>金额<i class="w_table_split"></i></th> -->
<!-- 		<th>已结算<i class="w_table_split"></i></th> -->
<!-- 		<th>未结算<i class="w_table_split"></i></th> -->
<!-- 		<th>调账<i class="w_table_split"></i></th> -->
<!-- 		<th>备注<i class="w_table_split"></i></th> -->
<!-- 		<th>操作<i class="w_table_split"></i></th> -->
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>
					<label name="serialnum">${status.index+1}</label>
					<input type="hidden" name="orderId" value="${item.id}" />
				</td>
				
				<c:if test="${reqpm.supplierType eq 1 }">
					<td style="text-align: left;">
		              <c:if test="${item.group_mode <= 0}">
		              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
		              </c:if>
		              <c:if test="${item.group_mode > 0}">
		              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
		              </c:if>
	             	</td>
	             	<td>【${item.product_brand_name}】${item.product_name}</td>
					<td >${item.receive_mode}</td>
					<td >${item.person_count}</td>
				</c:if>
				<c:if test="${reqpm.supplierType eq 16 }">
					<td style="text-align: left;">
		              <c:if test="${item.group_mode <= 0}">
		              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
		              </c:if>
		              <c:if test="${item.group_mode > 0}">
		              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
		              </c:if>
	             	</td>
	             	<td>【${item.product_brand_name}】${item.product_name}</td>
					<td >${item.person_count}</td>
				</c:if>
				<c:if test="${reqpm.supplierType ne 1 &&  reqpm.supplierType ne 16}">
					<td style="text-align: left;">
		              <c:if test="${item.group_mode <= 0}">
		              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
		              </c:if>
		              <c:if test="${item.group_mode > 0}">
		              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
		              </c:if>
	             	</td>
	             	<td>【${item.product_brand_name}】${item.product_name}</td>
				</c:if>
				
				<td>
					<c:if test="${reqpm.supplierType eq 1 }">
						<fmt:formatDate value="${item.date_start}" pattern="yyyy-MM-dd" />/
						<fmt:formatDate value="${item.date_end}" pattern="yyyy-MM-dd" />
					</c:if>
					<c:if test="${reqpm.supplierType ne 1 }">
						<fmt:formatDate value="${item.booking_date}" pattern="yyyy-MM-dd" />
					</c:if>
				</td>
				
				<td>${item.operator_name}</td>
				<td>${item.details}</td>
				<td>
					<input type="hidden" name="total" value="${item.total }" />
					<fmt:formatNumber value="${item.total}" pattern="#.##"/>
				</td>
				<td>
					<input type="hidden" name="totalCash" value="${item.total_cash }" />
					<fmt:formatNumber value="${item.total_cash }" pattern="#.##"/>
				</td>
				<td>
					<input type="hidden" name="totalNot" value="${item.total_not }" />
					<fmt:formatNumber value="${item.total_not}" pattern="#.##"/>
				</td>
				<td>
					<input type="text" name="totalAdjust" style="width:85%;height:96%;text-align:center;" value="0" onchange="sumAdjust()" />
				</td>
				<td>
					<label name="totalFact" ><fmt:formatNumber value="${item.total}" pattern="#.##"/></label>
				</td>
				<td>
					<textarea style="width:96%;height:96%;" name="remark" ></textarea>
				</td>
				<td>
					<a class="def" href="javascript:void(0)" onclick="removeDetail(${item.id})">删除</a>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
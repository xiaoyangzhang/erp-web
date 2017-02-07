<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<table class="w_table" style="margin-left: 0px">
	<colgroup> 
		<col width="4%"/>
		<col width="7%"/>
		<col width="6%"/>
		<col />
		<col width="8%"/>
		<col width="9%"/>
		<col width="6%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>客户<i class="w_table_split"></i></th>
			<th>客人信息<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>收入<i class="w_table_split"></i></th>
			<th>其它收入<i class="w_table_split"></i></th>
			<th>预算<i class="w_table_split"></i></th>
			<th>毛利<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${groupList}" var="gl" varStatus="v">
       		<tr>
              <td>${v.count}</td>
              
              <td style="text-align: left;">
	              <c:if test="${gl.orderType <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.tourGroup.groupCode}</a> 
	              </c:if>
	              <c:if test="${gl.orderType > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看散客团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.tourGroup.groupCode}</a>
	              </c:if>
               </td>
              <td><fmt:formatDate value="${gl.tourGroup.dateStart}" pattern="yyyy-MM-dd"/></td>
              <td style="text-align: left">【${gl.productBrandName}】${gl.productName}</td>
              <td style="text-align: left">${gl.supplierName}</td>
              <td style="text-align: left;">${gl.receiveMode}</td>
              <td>${gl.provinceName}${gl.cityName}</td>
              <td>${gl.numAdult}大${gl.numChild}小${gl.numGuide}陪</td>
              <td>${gl.saleOperatorName}</td>
              <td>${gl.operatorName}</td>
              <td>
              	<fmt:formatNumber value="${gl.income}" type="currency" pattern="#.##"/>
              </td>
               <td>
              	<fmt:formatNumber value="${gl.qdtotal}" type="currency" pattern="#.##"/>
              </td> 
              <td>
              	<font color="blue">
					<c:if test="${optMap['EDIT'] }">
							<span style="cursor:pointer" class="price" onclick="changePrice(this,${gl.id})">
								<fmt:formatNumber value="${gl.budget}" type="currency" pattern="#.##"/>	
							</span>
					</c:if>
				</font>
				<c:if test="${!optMap['EDIT'] }">
					<fmt:formatNumber value="${gl.budget}" type="currency" pattern="#.##"/>	
				</c:if>
              </td>
              
              <td>
              	<fmt:formatNumber value="${gl.income-gl.budget}" type="currency" pattern="#.##"/>	
              </td>
              
              <td>
              		<c:if test="${gl.tourGroup.groupState==0 }">未确认</c:if>
	                <c:if test="${gl.tourGroup.groupState==1 }">已确认</c:if>
					<c:if test="${gl.tourGroup.groupState==2}">废弃</c:if>
					<c:if test="${gl.tourGroup.groupState==3}">封存</c:if>
			  </td>
			  <td>
					<c:if test="${gl.tourGroup.groupCode != null}"><a class="def"  onclick="window.open('<%=staticPath%>/finance/auditGroupListPrint.htm?groupId=${gl.tourGroup.id}&isShow=true','结算单打印')" 
					href="javascript:void(0)" >打印</a></c:if>
				</td>
         	</tr>
         	<c:set var="sum_adult" value="${sum_adult+gl.numAdult}" />
			<c:set var="sum_child" value="${sum_child+gl.numChild}" />
			<c:set var="sum_guide" value="${sum_guide+gl.numGuide}" />
			<c:set var="sum_income" value="${sum_income+gl.income}" />
			<c:set var="sum_qdtotal" value="${sum_qdtotal+gl.qdtotal}" />
			<c:set var="sum_budget" value="${sum_budget+gl.budget}" />
       	</c:forEach>
	</tbody>
	<tfoot>
			<tr class="footer1">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">合计：</td>
			<td>${sum_adult}大${sum_child}小${sum_guide}陪</td>
		    <td></td>
         	<td></td>
			<td><fmt:formatNumber value="${sum_income}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_qdtotal }" type="currency" pattern="#.##"/></td>
			<td id="curTotal"><fmt:formatNumber value="${sum_budget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${sum_income-sum_budget}" type="currency" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
		<tr class="footer2">
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="1" style="text-align: right">总合计：</td>
			<td>${staticInfo.numAdult}大${staticInfo.numChild}小${staticInfo.numGuide}陪</td>
		    <td></td>
         	<td></td>
			<td><fmt:formatNumber value="${groupOrder.totalIncome}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${groupOrder.totalQdtotal}" type="currency" pattern="#.##"/></td>
			<td id="total"><fmt:formatNumber value="${groupOrder.totalBudget}" type="currency" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${groupOrder.totalIncome-groupOrder.totalBudget}" type="currency" pattern="#.##"/></td>
			<td></td>
			<td></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

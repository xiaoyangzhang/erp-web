<%@page import="org.aspectj.lang.JoinPoint.StaticPart"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">
$(function(){
	$('#resultTable').mergeCell({
	    // 目前只有cols这么一个配置项, 用数组表示列的索引,从0开始 
	    // 然后根据指定列来处理(合并)相同内容单元格 
	    cols: [1,2,3,4,5]
	});
});
</script>
<table class="w_table" id="resultTable">
	<colgroup>
		<col width="3%"/>
		<col width="10%"/>
		<col width="10%"/>
		<col width="13%"/>
		<col width="7%"/>
		<col width="7%"/>
		<col width="5%"/>
		<col width="20%"/>
		<col width="6%"/>
		<col width="6%"/>
		<col width="6%"/>
		<col width="6%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>团期<i class="w_table_split"></i></th>
			<th>地接社<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>描述<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${prices}" var="p" varStatus="v">
          <tr>
          	<td>${v.count}</td>
          	<td style="text-align: left"><c:choose>
                  		<c:when test="${p.groupMode < 1}">
                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${p.groupId}&operType=0')">${p.groupCode}</a></td>
                  		</c:when>
                  		<c:otherwise>
				 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${p.groupId }&operType=0')">${p.groupCode}</a></td> 
                  		</c:otherwise>
                  	</c:choose><input type="hidden" value="${p.bookingId}" /></td>
          	<td style="text-align: left"><fmt:formatDate value="${p.dateStart}" pattern="MM/dd"/> ~<fmt:formatDate value="${p.dateEnd}" pattern="MM/dd"/> <input type="hidden" value="${p.bookingId}" /></td>
          	<td style="text-align: left">${p.supplierName}<input type="hidden" value="${p.bookingId}" /></td>
          	<td>${p.personAdult}大${p.personChild}小${p.personGuide}陪<input type="hidden" value="${p.bookingId}" /></td>
          	<td>${p.operatorName}<input type="hidden" value="${p.bookingId}" /></td>
			<td >${p.itemName}</td>
			<td style="text-align: left">${p.remark}</td>
			<td ><fmt:formatNumber value="${p.unitPrice}" type="number" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${p.numTimes}" type="number" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${p.numPerson}" type="number" pattern="#.##"/></td>
			<td ><fmt:formatNumber value="${p.totalPrice}" type="number" pattern="#.##"/></td>
          </tr>
          <c:set var="sum_adult" value="${sum_adult+p.personAdult}" />
          <c:set var="sum_child" value="${sum_child+p.personChild}" />
          <c:set var="sum_guide" value="${sum_guide+p.personGuide}" />
          <c:set var="sum_totalPrice" value="${sum_totalPrice+p.totalPrice}" />
        </c:forEach>  
	</tbody>
	<tbody>
		<tr>
			<td colspan="10" >本页合计：</td>
			<td>${sum_adult }大${ sum_child}小${ sum_guide}陪</td>
			<td><fmt:formatNumber value="${sum_totalPrice}" type="number" pattern="#.##"/></td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="10" >总合计：</td>
			<td>${sum.personAdult }大${sum.personChild }小${sum.personGuide }陪</td>
			<td><fmt:formatNumber value="${sum.totals}" type="number" pattern="#.##"/></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>



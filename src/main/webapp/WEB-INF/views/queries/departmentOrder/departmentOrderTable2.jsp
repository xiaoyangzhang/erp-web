<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<%
	String staticPath = request.getContextPath();
%>

<table class="w_table" id="deservedCashTable">
	<colgroup>
		<col width="13%" />
		<col width="10%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<col width="7%" />
		<%-- <col width="5%" /> --%>

	</colgroup>
	<thead>
		<tr>
			<th rowspan="2">机构<i class="w_table_split"></i></th>
			<th rowspan="2">部门<i class="w_table_split"></i></th>
			<th colspan="7">本周人数<i class="w_table_split"></i></th>
			<th colspan="4">周合计<i class="w_table_split"></i></th>
			<!-- <th rowspan="2">明细<i class="w_table_split"></i></th> -->
		</tr>
		<tr>
			<th>${ dateList[0]}<i class="w_table_split"></i></th>
			<th>${dateList[1]}<i class="w_table_split"></i></th>
			<th>${ dateList[2]}<i class="w_table_split"></i></th>
			<th>${ dateList[3]}<i class="w_table_split"></i></th>
			<th>${ dateList[4]}<i class="w_table_split"></i></th>
			<th>${dateList[5]}<i class="w_table_split"></i></th>
			<th>${ dateList[6]}<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>确认订单<i class="w_table_split"></i></th>
			<th>预留订单<i class="w_table_split"></i></th>
			<th>成单率<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:set var="totalAdult1" value="0" />
		<c:set var="totalAdult2" value="0" />
		<c:set var="totalAdult3" value="0" />
		<c:set var="totalAdult4" value="0" />
		<c:set var="totalAdult5" value="0" />
		<c:set var="totalAdult6" value="0" />
		<c:set var="totalAdult7" value="0" />
		<c:set var="totalChild1" value="0" />
		<c:set var="totalChild2" value="0" />
		<c:set var="totalChild3" value="0" />
		<c:set var="totalChild4" value="0" />
		<c:set var="totalChild5" value="0" />
		<c:set var="totalChild6" value="0" />
		<c:set var="totalChild7" value="0" />
		<c:set var="totalType1" value="0" />
		<c:set var="totalType2" value="0" />
		<c:forEach items="${secLevelOrgList}" var="org" varStatus="orgVs">
			<tr>
				<td rowspan="${fn:length(orgDepMap[org.orgId])+1 }">${org.name }</td>
				
				<c:forEach items="${orgDepMap[org.orgId]}" var="dept"
					varStatus="deptVs">
					
					<c:choose>
						<c:when test="${deptVs.index==0}">
							<td>${dept.name}&nbsp;<a href="javascript:void(0);"
								class="def"
								onclick="paymentDetail('${dept.orgId}','${dept.name}')">明细</a></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day1NumAdult ne null }">${orgOrderMap[dept.orgId].day1NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day1NumChild ne null }">+${orgOrderMap[dept.orgId].day1NumChild}</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day2NumAdult ne null }">${orgOrderMap[dept.orgId].day2NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day2NumChild ne null }">+${orgOrderMap[dept.orgId].day2NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day3NumAdult ne null }">${orgOrderMap[dept.orgId].day3NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day3NumChild ne null }">+${orgOrderMap[dept.orgId].day3NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day4NumAdult ne null }">${orgOrderMap[dept.orgId].day4NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day4NumChild ne null }">+${orgOrderMap[dept.orgId].day4NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day5NumAdult ne null }">${orgOrderMap[dept.orgId].day5NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day5NumChild ne null }">+${orgOrderMap[dept.orgId].day5NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day6NumAdult ne null }">${orgOrderMap[dept.orgId].day6NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day6NumChild ne null }">+${orgOrderMap[dept.orgId].day6NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].day7NumAdult ne null }">${orgOrderMap[dept.orgId].day7NumAdult }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].day7NumChild ne null }">+${orgOrderMap[dept.orgId].day7NumChild }</c:if></td>
							<td><c:if
									test="${orgOrderMap[dept.orgId].numAdultTotal ne null }">${orgOrderMap[dept.orgId].numAdultTotal }</c:if>
								<c:if test="${orgOrderMap[dept.orgId].numChildTotal ne null }">+${orgOrderMap[dept.orgId].numChildTotal}</c:if></td>
							<td>${orgOrderMap[dept.orgId].affirmOrderCount }</td>
							<td>${orgOrderMap[dept.orgId].reserveOrderCount }</td>
							<td><c:if test="${orgOrderMap[dept.orgId].rate ne null}">
									<fmt:formatNumber value="${orgOrderMap[dept.orgId].rate*100 }"
										pattern="#.##" type="number" />%</c:if></td>
							<!-- <td></td> -->
			</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<td>${dept.name }&nbsp;<a href="javascript:void(0);"
						class="def"
						onclick="paymentDetail('${dept.orgId}','${dept.name}')">明细</a></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day1NumAdult ne null }">${orgOrderMap[dept.orgId].day1NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day1NumChild ne null }">+${orgOrderMap[dept.orgId].day1NumChild}</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day2NumAdult ne null }">${orgOrderMap[dept.orgId].day2NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day2NumChild ne null }">+${orgOrderMap[dept.orgId].day2NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day3NumAdult ne null }">${orgOrderMap[dept.orgId].day3NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day3NumChild ne null }">+${orgOrderMap[dept.orgId].day3NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day4NumAdult ne null }">${orgOrderMap[dept.orgId].day4NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day4NumChild ne null }">+${orgOrderMap[dept.orgId].day4NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day5NumAdult ne null }">${orgOrderMap[dept.orgId].day5NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day5NumChild ne null }">+${orgOrderMap[dept.orgId].day5NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day6NumAdult ne null }">${orgOrderMap[dept.orgId].day6NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day6NumChild ne null }">+${orgOrderMap[dept.orgId].day6NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].day7NumAdult ne null }">${orgOrderMap[dept.orgId].day7NumAdult }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].day7NumChild ne null }">+${orgOrderMap[dept.orgId].day7NumChild }</c:if></td>
					<td><c:if
							test="${orgOrderMap[dept.orgId].numAdultTotal ne null }">${orgOrderMap[dept.orgId].numAdultTotal }</c:if>
						<c:if test="${orgOrderMap[dept.orgId].numChildTotal ne null }">+${orgOrderMap[dept.orgId].numChildTotal}</c:if></td>
					<td>${orgOrderMap[dept.orgId].affirmOrderCount }</td>
					<td>${orgOrderMap[dept.orgId].reserveOrderCount }</td>
					<td><c:if test="${orgOrderMap[dept.orgId].rate ne null}">
							<fmt:formatNumber value="${orgOrderMap[dept.orgId].rate*100 }"
								pattern="#.##" type="number" />%</c:if></td>
					<!-- <td></td> -->
				</tr>
			</c:otherwise>
			</c:choose>
		</c:forEach>
		<tr>
			<td style="font-weight: bold;">合计</td>
			<td>${adult1 }+${child1 }</td>
			<td>${adult2 }+${child2 }</td>
			<td>${adult3 }+${child3 }</td>
			<td>${adult4 }+${child4 }</td>
			<td>${adult5 }+${child5 }</td>
			<td>${adult6 }+${child6 }</td>
			<td>${adult7 }+${child7 }</td>
			<td>${adult1+adult2+adult3+adult4+adult5+adult6+adult7 }+${child1+child2+child3+child4+child5+child6+child7 }</td>
			<td>${type1 }</td>
			<td>${type2 }</td>
			<td><c:if test="${type1+type2 > 0}">
					<fmt:formatNumber value="${(type1/(type1+type2))*100 }"
						pattern="#.##" type="number" />%</c:if></td>
			<!-- <td></td> -->
		</tr>
		<c:set var="totalAdult1" value="${totalAdult1+adult1 }" />
		<c:set var="totalAdult2" value="${totalAdult2+adult2 }" />
		<c:set var="totalAdult3" value="${totalAdult3+adult3 }" />
		<c:set var="totalAdult4" value="${totalAdult4+adult4 }" />
		<c:set var="totalAdult5" value="${totalAdult5+adult5 }" />
		<c:set var="totalAdult6" value="${totalAdult6+adult6 }" />
		<c:set var="totalAdult7" value="${totalAdult7+adult7 }" />
		<c:set var="totalChild1" value="${totalChild1+child1 }" />
		<c:set var="totalChild2" value="${totalChild2+child2 }" />
		<c:set var="totalChild3" value="${totalChild3+child3 }" />
		<c:set var="totalChild4" value="${totalChild4+child4 }" />
		<c:set var="totalChild5" value="${totalChild5+child5 }" />
		<c:set var="totalChild6" value="${totalChild6+child6 }" />
		<c:set var="totalChild7" value="${totalChild7+child7 }" />
		<c:set var="totalType1" value="${totalType1+type1 }" />
		<c:set var="totalType2" value="${totalType2+type2 }" />
		</c:forEach>
		<tr>
			<td></td>
			<td style="font-weight: bold;">总计</td>
			<td>${totalAdult1 }+${totalChild1 }</td>
			<td>${totalAdult2 }+${totalChild2 }</td>
			<td>${totalAdult3 }+${totalChild3 }</td>
			<td>${totalAdult4 }+${totalChild4 }</td>
			<td>${totalAdult5 }+${totalChild5 }</td>
			<td>${totalAdult6 }+${totalChild6 }</td>
			<td>${totalAdult7 }+${totalChild7 }</td>
			<td>${totalAdult1+totalAdult2+totalAdult3+totalAdult4+totalAdult5+totalAdult6+totalAdult7 }+${totalChild1+totalChild2+totalChild3+totalChild4+totalChild5+totalChild6+totalChild7 }</td>
			<td>${totalType1 }</td>
			<td>${totalType2 }</td>
			<td><c:if test="${totalType1+totalType2>0 }">
					<fmt:formatNumber
						value="${(totalType1/(totalType1+totalType2))*100 }"
						pattern="#.##" type="number" />%</c:if></td>
			<!-- <td></td> -->
		</tr>
	</tbody>
</table>
<script type="text/javascript">
function paymentDetail(orgId,deptName){
	var url = '<%=staticPath%>/query/paymentDetailList.htm?dateType='
				+ $("#dateType").val();
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
		/* if($("#operatorName").val()!='' ){
			url+='&userNames='+$("#operatorName").val() ;
		}
		if($("#operatorIds").val()!=''){
			url+='&saleOperatorIds='+$("#operatorIds").val() ;
		} */
		newWindow('应收款明细', url);
	}
</script>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 <%@ include file="../../include/path.jsp" %>

			<table cellspacing="0" cellpadding="0" class="w_table">
				
				<thead>
					<tr>
						<th style="width: 3%;">序号<i class="w_table_split"></i></th>
						<th style="width: 9%;">团号<i class="w_table_split"></i></th>
						<th style="width: 3%;">发团<i class="w_table_split"></i></th>
						<th style="width: 3%;">散团<i class="w_table_split"></i></th>
						<th style="width: 6%;">人数<i class="w_table_split"></i></th>
						<th style="width: 5%;">计调员<i class="w_table_split"></i></th>
						<th style="width: 4%;">状态<i class="w_table_split"></i></th>
						<th style="width: 6%;">接站牌<i class="w_table_split"></i></th>
						<th style="width: 10%;">产品<i class="w_table_split"></i></th>
							<th style="width: 3%;">门<i class="w_table_split"></i></th>
							<th style="width: 3%;">房<i class="w_table_split"></i></th>
							<th style="width: 3%;">餐<i class="w_table_split"></i></th>
							<th style="width: 3%;">车<i class="w_table_split"></i></th>
							<th style="width: 4%;">地接<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${pageBean.result}" var="groupInfo"
						varStatus="status">
						<tr>
							<td>${status.index+1}</td>
							<td style="text-align: left">
								<c:choose>
									<c:when test="${groupInfo.groupMode < 1}">
			                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td>
			                  		</c:when>
			                  		<c:otherwise>
							 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId }&operType=0')">${groupInfo.groupCode}</a></td> 
			                  		</c:otherwise>
								</c:choose>
							</td>
							<td>
								<fmt:formatDate value="${groupInfo.dateStart}" pattern="MM-dd" />
							</td>
							<td>
								<fmt:formatDate value="${groupInfo.dateEnd}" pattern="MM-dd" />
							</td>
							<td>${groupInfo.totalAdult}+${groupInfo.totalChild}+${groupInfo.totalGuide}</td>
							<td>${groupInfo.operatorName}</td>
							<td>${groupInfo.groupStatus}</td>
							<td>${groupInfo.receiveMode}</td>
							<td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
							<!--  -->
								<td>
									<a href="javascript:void(0)" class="db" onclick="showSightBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.sightCnt>0 }">√</c:if>
										<c:if test="${groupInfo.sightCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showHotelBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.hotelCnt>0 }">√</c:if>
										<c:if test="${groupInfo.hotelCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showEatBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.eatCnt>0 }">√</c:if>
										<c:if test="${groupInfo.eatCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showCarBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.carCnt>0 }">√</c:if>
										<c:if test="${groupInfo.carCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" onclick="showNewDeliveryBooking('${groupInfo.groupId}')"> 
										<c:if test="${groupInfo.deliveryCnt>0 }">√</c:if> 
										<c:if test="${groupInfo.deliveryCnt==0 }">×</c:if>
									</a>
								</td>
							<!--  -->
							
						<c:set var="adultCount" value="${adultCount+groupInfo.totalAdult }"/>
						<c:set var="childCount" value="${childCount+groupInfo.totalChild }"/>
						<c:set var="guideCount" value="${guideCount+groupInfo.totalGuide }"/>
						</tr>
					</c:forEach>
				</tbody>
				<tbody>
					<tr>
						<td colspan="4">本页合计：</td>
						<td>${adultCount }+${ childCount}+${ guideCount}</td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
				</tbody>
				<tbody>
					<tr>
						<td colspan="4">总计：</td>
						<td>${sum.adultCount }+${ sum.childCount}+${sum.guideCount}</td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
						<td ></td>
					</tr>
				</tbody>
			</table>
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${pageBean.page }" name="p" />
				<jsp:param value="${pageBean.totalPage }" name="tp" />
				<jsp:param value="${pageBean.pageSize }" name="ps" />
				<jsp:param value="${pageBean.totalCount }" name="tn" />
			</jsp:include>
<script type="text/javascript">

</script>


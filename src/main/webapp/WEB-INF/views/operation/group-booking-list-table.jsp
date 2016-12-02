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
						<th style="width: 5%;">状态<i class="w_table_split"></i></th>
						<th style="width: 6%;">接站牌<i class="w_table_split"></i></th>
						<th style="width: 10%;">产品<i class="w_table_split"></i></th>
						<!-- ${gbMap_SIGHT }-${optMap['YDAP_SIGHT'] } -->
						<c:if test="${optMap['YDAP_SIGHT'] }">
							<th style="width: 3%;">门<i class="w_table_split"></i></th>
						
						</c:if>
							<th style="width: 3%;">房<i class="w_table_split"></i></th>
					
							<th style="width: 3%;">餐<i class="w_table_split"></i></th>
					
							<th style="width: 3%;">车<i class="w_table_split"></i></th>
						
							<th style="width: 3%;">飞<i class="w_table_split"></i></th>
							
							<th style="width: 3%;">火<i class="w_table_split"></i></th>
							<th style="width: 3%;">险<i class="w_table_split"></i></th>
							<th style="width: 3%;">店<i class="w_table_split"></i></th>
						
							<th style="width: 6%;">导游<i class="w_table_split"></i></th>
							<th style="width: 3%;">其他收入<i class="w_table_split"></i></th>
							<th style="width: 3%;">其他支出<i class="w_table_split"></i></th>
							<th style="width: 8%;">地接</th>
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
							<td>
								<c:if test="${groupInfo.totalBaby==0 }">
									${groupInfo.totalAdult}+${groupInfo.totalChild}+${groupInfo.totalGuide}
								</c:if>
								<c:if test="${groupInfo.totalBaby!=0 }">${groupInfo.totalAdult}+${groupInfo.totalChild}<span style="color: red;">(${groupInfo.totalBaby })</span>+${groupInfo.totalGuide}</c:if>
							</td>
							<td>${groupInfo.operatorName}</td>
							<td>${groupInfo.groupStatus}</td>
							<td>${groupInfo.receiveMode}</td>
							<td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
							<!--  -->
							<c:if test="${optMap['YDAP_SIGHT'] }">
								<td>
									<a href="javascript:void(0)" class="db" onclick="showSightBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.sightCnt>0 }">√</c:if>
										<c:if test="${groupInfo.sightCnt==0 }">×</c:if>
									</a>
								</td>
								</c:if>
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
							<!--  -->
								<td>
									<a href="javascript:void(0)" class="db" onclick="showAirBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.airCnt>0 }">√</c:if>
										<c:if test="${groupInfo.airCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showTrainBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.trainCnt>0 }">√</c:if>
										<c:if test="${groupInfo.trainCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showInsuranceBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.insuranceCnt>0 }">√</c:if>
										<c:if test="${groupInfo.insuranceCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showShopBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.shopCnt>0 }">√</c:if>
										<c:if test="${groupInfo.shopCnt==0 }">×</c:if>
									</a>
								</td>
							<!--  -->
								<td>
									<c:choose>
										<c:when test="${optMap['YDAP_GUIDE'] }">
											<a href="javascript:void(0)"
												onclick="newWindow('安排导游','<%=ctx %>/bookingGuide/guideDetailListView.htm?groupId=${groupInfo.groupId}')">
										</c:when>
										<c:otherwise>
											<a href="javascript:void(0)"
												onclick="newWindow('安排导游','<%=ctx %>/bookingGuide/toGuideDetailListView.htm?groupId=${groupInfo.groupId}')">
										</c:otherwise>
									</c:choose> 
										<c:if test="${groupInfo.guideNames!=null }">
							                ${fn:replace(groupInfo.guideNames,',','</br>') }
							            </c:if> 
						            	<c:if test="${groupInfo.guideNames==null }">×</c:if> 
						            </a>
						        </td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showIncomeBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.inCnt>0 }">√</c:if>
										<c:if test="${groupInfo.inCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" class="db" onclick="showOutcomeBooking('${groupInfo.groupId}')">
										<c:if test="${groupInfo.outCnt>0 }">√</c:if>
										<c:if test="${groupInfo.outCnt==0 }">×</c:if>
									</a>
								</td>
								<td>
									<a href="javascript:void(0)" onclick="showDeliveryBooking('${groupInfo.groupId}')"> 
										<c:if test="${groupInfo.deliveryNames!=null }">
							                  		${fn:replace(groupInfo.deliveryNames,',','</br>') }
							            </c:if> 
							            <c:if test="${groupInfo.deliveryNames==null }">×</c:if>
									</a>
								</td>
							
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
						<td style="width: 5%;"></td>
						<td style="width: 5%;"></td>
						<td style="width: 6%;"></td>
						<td style="width: 10%;"></td>
						
						<c:if test="${gbMap_SIGHT }">
							<td style="width: 3%;"></td>
						
						</c:if>
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
						
							<td style="width: 6%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 8%;"></td>
					</tr>
				</tbody>
				<tbody>
					<tr>
						<td colspan="4">总计：</td>
						<td>${sum.adultCount }+${ sum.childCount}+${sum.guideCount}</td>
						<td style="width: 5%;"></td>
						<td style="width: 5%;"></td>
						<td style="width: 6%;"></td>
						<td style="width: 10%;"></td>
						
						<c:if test="${gbMap_SIGHT }">
							<td style="width: 3%;"></td>
						
						</c:if>
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
						
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
						
							<td style="width: 6%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 3%;"></td>
							<td style="width: 8%;"></td>
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


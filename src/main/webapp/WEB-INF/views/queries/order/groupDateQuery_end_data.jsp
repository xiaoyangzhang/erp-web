<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">团号<i class="w_table_split"></i></th>
			<th style="width: 10%">发团<i class="w_table_split"></i></th>
			<th style="width: 10%">散团<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th style="width: 10%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 10%">导游<i class="w_table_split"></i></th>
			<th style="width: 10%">团状态<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="tourGroup" varStatus="v">
			<tr>
				<td>${v.count}</td>
				<td style="text-align: left;">
					<c:if test="${tourGroup.groupMode<=0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','fitGroup/toFitGroupInfo.htm?groupId=${tourGroup.id}&operType=0')">${tourGroup.groupCode}</a> 
	               </c:if>
	               <c:if test="${tourGroup.groupMode>0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${tourGroup.id}&operType=0')">${tourGroup.groupCode}</a>
	               </c:if>
				<td><fmt:formatDate value="${tourGroup.dateStart}" pattern="yyyy-MM-dd"/></td>
				<td><fmt:formatDate value="${tourGroup.dateEnd}" pattern="yyyy-MM-dd"/></td>
				<td style="text-align: left;">【${tourGroup.productBrandName}】${tourGroup.productName}</td>
				<td>${tourGroup.totalAdult}大${tourGroup.totalChild}小${tourGroup.totalGuide}陪</td>
				<td>${tourGroup.operatorName}</td>
				<td>
					<c:forEach items="${tourGroup.guideList}" var="guide">
						<a href="javascript:void(0);" onclick="newWindow('导游详情','supplier/guideDetail.htm?id=${guide.guideId}')"> 
							${guide.guideName}&nbsp;
						</a>
					</c:forEach> 
				</td>
				<td>
					<c:if test="${tourGroup.groupState==0 }">未确认</c:if> 
					<c:if test="${tourGroup.groupState==1 }">已确认</c:if> 
					<c:if test="${tourGroup.groupState==1 and nowDate-tourGroup.dateStart.time < 0}">(待出团)</c:if>
					<c:if test="${tourGroup.groupState==1 and  !empty tourGroup.dateEnd and nowDate-tourGroup.dateEnd.time > 0}">(已离开)</c:if>
					<c:if test="${tourGroup.groupState==1 and !empty tourGroup.dateEnd and nowDate-tourGroup.dateStart.time > 0 and nowDate-tourGroup.dateEnd.time < 0 }">(行程中)</c:if>
					<c:if test="${tourGroup.groupState==2 }">已废弃</c:if>
					<c:if test="${tourGroup.groupState==3 }"><span style="color:blue">已审核</span></c:if>
					<c:if test="${tourGroup.groupState==4 }"><span style="color: #ee33ee">已封存</span></c:if>
				</td>
			</tr>
				<c:set var="pageTotalAdult" value="${pageTotalAdult+tourGroup.totalAdult }"/>
				<c:set var="pageTotalChild" value="${pageTotalChild+tourGroup.totalChild }"/>
				<c:set var="pageTotalGuide" value="${pageTotalGuide+tourGroup.totalGuide }"/>
		</c:forEach>
			<tr>
				<td colspan="5" style="text-align: right">本页合计:</td>
				<td>${pageTotalAdult}大${pageTotalChild}小${pageTotalGuide }陪</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="5" style="text-align: right">总合计:</td>
				<td>${tg.totalAdult}大${tg.totalChild}小${tg.totalGuide }陪</td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
		<jsp:param value="${page.page }" name="p" />
		<jsp:param value="${page.totalPage }" name="tp" />
		<jsp:param value="${page.pageSize }" name="ps" />
		<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

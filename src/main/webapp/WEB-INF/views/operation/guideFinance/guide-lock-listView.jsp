<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../../../include/path.jsp" %>


<table cellspacing="0" cellpadding="0" class="w_table" > 
		             	<col width="4%" />
		             	<col width="10%" />
		             	<col width="20%" />
		             	<col width="10%" />
		             	<col width="8%" />
		             	<col width="8%" />
		             	<col width="8%" />
		             	<col width="5%" />
		             	<col width="5%" />
		             	<col width="5%" />
		             	<col width="10%" />
			             <thead>
			             	<tr>
			             		<th>序号<i class="w_table_split"></i></th>
			             		<th>团号<i class="w_table_split"></i></th>
			             		<th>产品名称<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>
			             		<th>计调<i class="w_table_split"></i></th>
			             		<th>导游<i class="w_table_split"></i></th>
			             		<th>报账总额<i class="w_table_split"></i></th>
			             		<th>团状态<i class="w_table_split"></i></th>
			             		<th>报账状态<i class="w_table_split"></i></th>
			             		<th>状态<i class="w_table_split"></i></th>
			             		<th>操作</th>
			             	</tr>
			             </thead>
			             <tbody> 
			              	 <c:forEach items="${page.result}" var="groupInfo" varStatus="status">			       
			              	  <tr> 
			                  	  <td class="serialnum">
<%-- 				                  		<div class="serialnum_btn" groupId="${groupInfo.groupId}"></div> --%>
				                  		${status.index+1}
				                  </td>
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
				                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
				                  <td>${groupInfo.adultCount}大${groupInfo.childCount}小${groupInfo.guideCount}陪</td> 
				                  <td>${groupInfo.operatorName}</td>
				                  <td>${groupInfo.guideName}</td> 
				                  <td><fmt:formatNumber value="${groupInfo.total}" pattern="#.##"/></td>
				                  <td>${groupInfo.groupStatus}</td>
				                  <td>
										<c:if test="${groupInfo.stateBooking eq 0}">未报账</c:if>
										<c:if test="${groupInfo.stateBooking eq 1}">计调处理中</c:if>
										<c:if test="${groupInfo.stateBooking eq 2}">财务处理中</c:if>
										<c:if test="${groupInfo.stateBooking eq 3}">已报账</c:if>
								  </td>
								    <td><c:if test="${groupInfo.stateLock eq 0}">未锁</c:if>	
								    		<c:if test="${groupInfo.stateLock eq 1}">已锁</c:if>
								    </td>
								    
				                  <td>
				                  <c:if test="${optMap_LOCK}"><c:if test="${groupInfo.stateLock eq 0}"> <a href="javascript:void(0);" onclick="changeStateLock(${groupInfo.groupId})" class="def">锁定</a></c:if></c:if>
				                   <c:if test="${optMap_UNLOCK}"><c:if test="${groupInfo.stateLock eq 1}"><a href="javascript:void(0);" onclick="changeStateUnlock(${groupInfo.groupId})" class="def">解锁</a></c:if></c:if>
				                  </td>
				               </tr>
			              </c:forEach>
			             </tbody>
	          		 </table>
          		
 <jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

<script type="text/javascript">

function changeStateLock(groupId){
	$.ajax({
        type: "post",
        url : "../bookingGuideFinance/changeStateLock.do",
        dataType:"json",
        data:{"groupId":groupId},		
        success: function () {
    	
    		searchBtn();
		},
		error: function () {

			searchBtn();
		}
	});
};

function changeStateUnlock(groupId){
	$.ajax({
        type: "post",
        url : "../bookingGuideFinance/changeStateUnlock.do",
        dataType:"json",
        data:{"groupId":groupId},
        success: function () {
    
    		searchBtn();
		},
		error: function () {
	
			searchBtn();
		}
	});
	
};
</script>
		
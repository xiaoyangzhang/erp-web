<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/top.jsp"%>
    <table cellspacing="0" cellpadding="0" class="w_table" > 
	<col width="5%" /><col width="10%" /><col width="8%" /><col width="5%" /><col width="" />
	<col width="15%" /><col width="5%" /><col width="5%" /><col width="8%" /><col width="5%" />
	<col width="5%" />
          <thead>
          	<tr>
          		<th>序号<i class="w_table_split"></i></th>
          		<th>团号<i class="w_table_split"></i></th>
          		<th>出团日期<i class="w_table_split"></i></th>
          		<th>团类别<i class="w_table_split"></i></th>
          		<th>产品名称<i class="w_table_split"></i></th>
          		<th>组团社<i class="w_table_split"></i></th>
          		<th>人数<i class="w_table_split"></i></th>
          		<th>计调名称<i class="w_table_split"></i></th>
          		<th>状态<i class="w_table_split"></i></th>
          		<th>评分<i class="w_table_split"></i></th>
          		<th>操作<i class="w_table_split"></i></th>           		
          	</tr>
          </thead>
          <tbody> 
          	<c:forEach items="${pageBean.result}" var="groupInfo" varStatus="status">
             <tr> 
	              <td class="serialnum">
	                ${status.count }	                	
	              </td>
	              <td style="text-align: left">
	              <c:choose>
                  		<c:when test="${groupInfo.groupMode eq 0}">
						 <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/groupOrder/toFitEdit.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td> 
                  		</c:when>
                  		<c:otherwise>
		                  <a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/tourGroup/toAddTourGroupOrder.htm?orderId=${groupInfo.orderId }&state=4')">${groupInfo.groupCode}</a></td> 
                  		</c:otherwise>
                  	</c:choose>
	              </td> 
                  <td><fmt:formatDate value="${groupInfo.dateStart}" pattern="yyyy-MM-dd"/> </td> 
                  <td><c:if test="${groupInfo.groupMode == 0}">散客</c:if><c:if test="${groupInfo.groupMode > 0}">团队</c:if></td>
                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
                  <td style="text-align: left"><c:if test="${groupInfo.groupMode == 0}">散客团</c:if><c:if test="${groupInfo.groupMode > 0}">${groupInfo.supplierName}</c:if></td> 
                  <td>${groupInfo.totalAdult+groupInfo.totalChild+groupInfo.totalGuide}</td> 
                  <td>${groupInfo.operatorName}</td>
                  <td>
                  	<c:if test="${groupInfo.groupState==0 }">未确认</c:if>
	                <c:if test="${groupInfo.groupState==1 }">已确认</c:if>
					<c:if test="${groupInfo.groupState==1 and nowDate-groupInfo.dateStart.time < 0}">(待出团)</c:if>
					<c:if test="${groupInfo.groupState==1 and  !empty groupInfo.dateEnd and nowDate-groupInfo.dateEnd.time > 0}">(已离开)</c:if>
					<c:if test="${groupInfo.groupState==1 and  !empty groupInfo.dateEnd and nowDate-groupInfo.dateStart.time > 0 and nowDate-gl.tourGroup.dateEnd.time < 0 }">(行程中)</c:if>
					<c:if test="${groupInfo.groupState==2}">废弃</c:if>
					<c:if test="${groupInfo.groupState==3}">封存</c:if>
                  </td>
                  <td>${groupInfo.score }</td>                  
                  <td><a href="#">查看</a></td>
             </tr>
          </c:forEach>
   	</tbody>
</table>
<div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
		
</script>

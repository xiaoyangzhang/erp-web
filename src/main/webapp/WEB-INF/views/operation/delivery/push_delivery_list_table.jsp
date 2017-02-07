<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/path.jsp"%>
    <table cellspacing="0" cellpadding="0" class="w_table" > 
	<col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
    <col width=""/>
          <thead>
          	<tr>
          		<th>序号<i class="w_table_split"></i></th>
          		<th>团号<i class="w_table_split"></i></th>
          		<th>出发日期<i class="w_table_split"></i></th>
          		<th>类别<i class="w_table_split"></i></th>
          		<th>产品名称<i class="w_table_split"></i></th>
          		<th>组团社<i class="w_table_split"></i></th>
          		<th>地接社<i class="w_table_split"></i></th>
          		<th>人数<i class="w_table_split"></i></th>
          		<th>状态<i class="w_table_split"></i></th>       		
          		<th>操作&nbsp;&nbsp;<input id="opCheckAll" type="checkbox" onclick="opCheckAll(this);"/>
            		<a class="button button-rounded button-tinier" href="javascript:void(0)" onclick="push();">推送</a></th>
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
						  <c:when test="${groupInfo.groupMode < 1}">
						  <a class="def" href="javascript:void(0)"
						     onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td>
						  </c:when>
						  <c:otherwise>
						  <a class="def" href="javascript:void(0)"
						     onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId }&operType=0')">${groupInfo.groupCode}</a></td>
						  </c:otherwise>
					</c:choose>
				  </td>
                  <td><fmt:formatDate value="${groupInfo.dateStart}" pattern="yyyy-MM-dd"/> </td> 
                  <td><c:if test='${groupInfo.groupMode < 1}'>散客</c:if><c:if test='${groupInfo.groupMode > 0}'>团队</c:if></td>
                  <td style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
                  <td style="text-align: left">${groupInfo.supplierName}</td>
                  <td style="text-align: left">${groupInfo.bookSupplierName}</td>
                  <td>${groupInfo.adultCount}大${groupInfo.childCount}小${groupInfo.guideCount}陪</td>                   
                  <td>
                      <c:if test="${groupInfo.pushStatus == 0}">未推送</c:if>
                      <c:if test="${groupInfo.pushStatus == 1}"><font color="red">已推送</font></c:if>
                  </td>
                  <td>
                      <input name="checkList" type="checkbox" varGroupId="${groupInfo.groupId}"
                       varBookingId="${groupInfo.bookingId}" varAppKey="${groupInfo.driverName}"/>
                  </td>
             </tr>
             <c:set var="sum_adult" value="${sum_adult+groupInfo.adultCount }" />
             <c:set var="sum_child" value="${sum_child+groupInfo.childCount }" />
             <c:set var="sum_guide" value="${sum_guide+groupInfo.guideCount }" />
             <c:set var="sum_order_cnt" value="${sum_order_cnt+groupInfo.count }" />
             <c:set var="sum_price" value="${sum_price+groupInfo.price }" />
          </c:forEach>
          <tr>
          	<td colspan="7" style="text-align:right;">合计：</td>
          	<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
          	<td></td>
          	<td></td>
          </tr>
   	</tbody>
</table>
<div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
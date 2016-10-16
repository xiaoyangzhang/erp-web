<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
 <%@ include file="../../include/path.jsp" %>

 <dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" >
                     <table cellspacing="0" cellpadding="0" class="w_table" > 
		             	<col width="5%" /><col width="10%" /><col width="15%" /><col width="10%" /><col width="10%" />
		             	<col width="5%" /><col width="10%" /><col width="10%" /><col width="35%" />
			             <thead>
			             	<tr>
			             		<th >序号<i class="w_table_split"></i></th>
			             		<th>团号<i class="w_table_split"></i></th>
			             		<th>产品名称<i class="w_table_split"></i></th>
			             		<th>日期<i class="w_table_split"></i></th>
			             		<th>计调员<i class="w_table_split"></i></th>
			             		<th>人数<i class="w_table_split"></i></th>
			             		<th>状态<i class="w_table_split"></i></th>
			             		<th >类型<i class="w_table_split"></i></th>
			             		<th >安排情况<i class="w_table_split"></i></th>
			             	</tr>
			             	
			             	
			             </thead>
			             <tbody> 
			              <c:forEach items="${pageBean.result}" var="groupInfo" varStatus="status">
			              	  <tr> 
			                  	  <td rowspan="7">${status.index+1}</td>
				                  <td style="text-align: left" rowspan="7">
				                  	<c:choose>
				                  		<c:when test="${groupInfo.groupMode < 1}">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','<%=ctx %>/fitGroup/toFitGroupInfo.htm?groupId=${groupInfo.groupId}&operType=0')">${groupInfo.groupCode}</a></td>
				                  		</c:when>
				                  		<c:otherwise>
								 			<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=ctx %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${groupInfo.groupId }&operType=0')">${groupInfo.groupCode}</a></td> 
				                  		</c:otherwise>
				                  	</c:choose>
				                  </td>
				                  	<td rowspan="7" style="text-align: left">【${groupInfo.productBrandName}】${groupInfo.productName}</td>
				                  <td rowspan="7"><fmt:formatDate value="${groupInfo.dateStart}" pattern="yyyy-MM-dd"/> </td> 
				                  <td rowspan="7">${groupInfo.operatorName}</td>
				                  <td rowspan="7">${groupInfo.adultCount}大${groupInfo.childCount}小${groupInfo.guideCount}陪</td> 

				                  <td rowspan="7"> ${groupInfo.groupStatus}</td>
				                  </tr>
				                  
				                  <tr><td>导游</td><td style="text-align: left">
				                  	<c:if test="${groupInfo.guideNameArr!=null }">
				                  		<c:forEach items="${groupInfo.guideNameArr}" var="guide" varStatus="st">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看导游信息','<%=ctx %>/bookingGuide/toGuideDetailListView.htm?groupId=${groupInfo.groupId}')">${guide }</a><br/> 
				                  		</c:forEach>
				                  	</c:if>
				                </td></tr>
			                  <tr><td>酒店</td><td style="text-align: left">
			                  		<c:if test="${groupInfo.hotelNameArr!=null }">
				                  		<c:forEach items="${groupInfo.hotelNameArr}" var="hotel" varStatus="st">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看酒店信息','<%=ctx %>/booking/viewSupplier.do?groupId=${groupInfo.groupId}&bookingId=${groupInfo.hotelIdArr[st.index] }')">${hotel }</a><br/>  
				                  		</c:forEach>
				                  	</c:if>
				                  </td></tr>
				                  <tr><td>餐厅</td><td style="text-align: left">
				                 	<c:if test="${groupInfo.eatNameArr!=null }">
				                  		<c:forEach items="${groupInfo.eatNameArr}" var="eat" varStatus="st">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看餐厅信息','<%=ctx %>/booking/viewSupplier.do?groupId=${groupInfo.groupId}&bookingId=${groupInfo.eatIdArr[st.index] }')">${eat }</a><br/> 
				                  		</c:forEach>
				                  	</c:if>				                 
				                 </td></tr>
				                  <tr><td>门票</td><td style="text-align: left">
				                  	<c:if test="${groupInfo.sightNameArr!=null }">
				                  		<c:forEach items="${groupInfo.sightNameArr}" var="sight" varStatus="st">
				                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看景区门票信息','<%=ctx %>/booking/viewSupplier.do?groupId=${groupInfo.groupId}&bookingId=${groupInfo.sightIdArr[st.index] }')">${sight }</a><br/> 
				                  		</c:forEach>
				                  	</c:if>
				                  </td></tr>
				                  <tr><td>车辆</td><td style="text-align: left">
				                  		<c:if test="${groupInfo.carNameArr!=null }">
					                  		<c:forEach items="${groupInfo.carNameArr}" var="car" varStatus="st">
					                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看订车信息','<%=ctx %>/booking/viewSupplier.do?groupId=${groupInfo.groupId}&bookingId=${groupInfo.carIdArr[st.index] }')">${car }</a><br/> 
					                  		</c:forEach>
					                  	</c:if>				                  		
				                  </td></tr>
				                  <tr><td>下接社</td><td style="text-align: left">
				                  	<c:if test="${groupInfo.deliveryNameArr!=null }">
					                  		<c:forEach items="${groupInfo.deliveryNameArr}" var="de" varStatus="st">
					                  			<a class="def" href="javascript:void(0)" onclick="newWindow('查看下接社信息','<%=ctx %>/booking/viewDelivery.htm?gid=${groupInfo.groupId}&bid=${groupInfo.deliveryIdArr[st.index] }')">${de }</a><br/> 
					                  		</c:forEach>
					                  	</c:if>				                  	
				                  </td></tr>
			              </c:forEach>
			             </tbody>
	          		 </table>
	          		 <jsp:include page="/WEB-INF/include/page.jsp">
						<jsp:param value="${pageBean.page }" name="p"/>
						<jsp:param value="${pageBean.totalPage }" name="tp" />
						<jsp:param value="${pageBean.pageSize }" name="ps" />
						<jsp:param value="${pageBean.totalCount }" name="tn" />
					</jsp:include>
    			 </div>
				 <div class="clear"></div>
	    		</dd>
            </dl>

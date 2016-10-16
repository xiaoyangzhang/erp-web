<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:600px;" > 
		             <thead>
		             	<tr>
		             		<th width="10%">订单号<i class="w_table_split"></i></th>
		             		<th width="10%">出发日期<i class="w_table_split"></i></th>
		             		<th width="5%">申请状态<i class="w_table_split"></i></th>
		             		<th width="5%">类别<i class="w_table_split"></i></th>
		             		<th width="35%">产品名称<i class="w_table_split"></i></th>
		             		<th width="10%">组团社<i class="w_table_split"></i></th>
		             		<th width="10%">接站牌<i class="w_table_split"></i></th>
		             		<th width="5%">人数<i class="w_table_split"></i></th>
		             		<th >操作</th>
		             	</tr>
		             </thead>
		             <tbody>
		             <c:forEach items="${pageBean.result}" var="o" varStatus="v">
			               <tr id="${o.id }">
			               <td>${o.orderNo} </td>
			               <td>${o.departureDate} </td>
			               <td>${orderRequestStatus[o.id]}</td>
			               <td>${groupModes[o.id]}</td>
			               <td style="text-align: left;">【${o.productBrandName}】${o.productName}</td>
			               <td>${o.supplierName}</td>
			               <td>${o.receiveMode}</td>
			               <td>${o.numAdult}大${o.numChild}小${o.numGuide}陪</td>
			               <% /* <td>
	              				<c:if test="${gl.tourGroup.groupState==0 }">未确认</c:if>
		                		<c:if test="${gl.tourGroup.groupState==1 }">已确认</c:if>
								<c:if test="${gl.tourGroup.groupState==1 and nowDate-gl.tourGroup.dateStart.time < 0}">(待出团)</c:if>
								<c:if test="${gl.tourGroup.groupState==1 and  !empty gl.tourGroup.dateEnd and nowDate-gl.tourGroup.dateEnd.time > 0}">(已离开)</c:if>
								<c:if test="${gl.tourGroup.groupState==1 and  !empty gl.tourGroup.dateEnd and nowDate-gl.tourGroup.dateStart.time > 0 and nowDate-gl.tourGroup.dateEnd.time < 0 }">(行程中)</c:if>
								<c:if test="${gl.tourGroup.groupState==2}">废弃</c:if>
								<c:if test="${gl.tourGroup.groupState==3}">封存</c:if>
			  			   </td> */ %> 
			               <td><a class="button button-rounded button-primary button-small" href="javascript:selectGroupOrder(${o.id })">选择</a> 
			                  </td>
			               </tr>
		              </c:forEach>
		             </tbody>
	          		</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
	<jsp:param value="groupQueryList" name="fnQuery"/>
	<jsp:param value="groupPagination" name="divId"/>
</jsp:include>

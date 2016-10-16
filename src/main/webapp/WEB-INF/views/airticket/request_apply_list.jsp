<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<% String path = request.getContextPath(); %>
<table cellspacing="0" cellpadding="0" class="w_table LgTable" style="min-width:1100px;" > 
		             <thead>
		             	<tr>
		             		<th width="80">订单号<i class="w_table_split"></i></th>
		             		<th width="80">出发日期<i class="w_table_split"></i></th>
		             		<th width="50">申请状态<i class="w_table_split"></i></th>
		             		<th width="200">产品名称<i class="w_table_split"></i></th>
		             		<th width="120">组团社<i class="w_table_split"></i></th>
		             		<th width="80">接站牌<i class="w_table_split"></i></th>
		             		<th width="60">人数<i class="w_table_split"></i></th>
		             		<th width="60">销售<i class="w_table_split"></i></th>
		             		<th width="120">申请航线<i class="w_table_split"></i></th>
		             		<th width="50">总票数<i class="w_table_split"></i></th>
		             		<th width="50">申请票数<i class="w_table_split"></i></th>
		             		<th width="50">剩余<i class="w_table_split"></i></th>
		             		<th width="80">最晚出票时间<i class="w_table_split"></i></th>
		             		<th width="80">操作备注<i class="w_table_split"></i></th>
		             		<th width="80">当前状态<i class="w_table_split"></i></th>
		             		<th width="80">操作</th>
		             	</tr>
		             </thead>
		             <tbody>
		             <c:forEach items="${pageBean.result}" var="o" varStatus="v">
		             <c:set var="rows" value="1"/>
		             <c:if test="${boMap[o.id]!=null && fn:length(boMap[o.id])>1}">
		             <c:set var="rows" value="${fn:length(boMap[o.id])}"/>
		             </c:if>
			               <tr id="${o.id }">
			               <td rowspan="${rows}">${o.orderNo} </td>
			               <td rowspan="${rows}">${o.departureDate} </td>
			               <td rowspan="${rows}">${orderRequestStatus[o.id]}</td>
			               <td rowspan="${rows}" style="text-align: left;">【${o.productBrandName}】${o.productName}</td>
			               <td rowspan="${rows}">${o.supplierName}</td>
			               <td rowspan="${rows}">${o.receiveMode}</td>
			               <td rowspan="${rows}">${o.numAdult}大${o.numChild}小${o.numGuide}陪</td>
			               <td rowspan="${rows}">${o.saleOperatorName}</td>
			               <c:if test="${boMap[o.id]==null}"><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
			               <td><a class="button button-tinier" href="javascript:newWindow('机票申请${o.orderNo }', '<%=path%>/airticket/request/applyEdit.htm?orderId=${o.id }')">申请</a></td>
			               </c:if>
			               <c:if test="${boMap[o.id]!=null}">
			               <c:forEach items="${boMap[o.id]}" var="bo" varStatus="v">
			                 <c:if test="v.index>0"><tr></c:if>
			               <td><a class="lineName" href="javascript:void();" title="${bo.resourceBo.legToolTip}">${bo.po.resource.lineName}</a></td>
			               <td>${bo.po.resource.totalNumber}</td>
			               <td>${bo.po.guestNumber}</td>
			               <td>${bo.po.resource.availableNumber}</td>
			               <td><fmt:formatDate value="${bo.po.resource.endIssueTime}" pattern="yyyy-MM-dd HH:mm"/></td>
			               <td>${bo.po.remark}</td>
			               <td>${bo.status}</td>
			               <td>
			               <a class="button button-tinier" href="javascript:newWindow('机票申请${o.orderNo }', '<%=path%>/airticket/request/applyEdit.htm?orderId=${o.id }')">新申请</a>
			               <a class="button button-tinier" href="javascript:newWindow('查看机票申请${o.orderNo }', '<%=path%>/airticket/request/view.htm?id=${bo.id }')">查看明细</a>
			                ${bo.operations}
			               </td></tr>
			               <c:set var="sum_totalNumber" value="${sum_totalNumber+bo.po.resource.totalNumber }"/>
			               <c:set var="sum_guestNumber" value="${sum_guestNumber+bo.po.guestNumber }"/>
			               <c:set var="sum_availableNumber" value="${sum_availableNumber+bo.po.resource.availableNumber}"/>
			               </c:forEach>
			               </c:if>
			               <c:set var="sum_adult" value="${sum_adult+o.numAdult }"/>
			               <c:set var="sum_child" value="${sum_child+o.numChild }"/>
			               <c:set var="sum_guide" value="${sum_guide+o.numGuide }"/>
		              </c:forEach>
		             </tbody>
		             <tbody>
		             	<tr>
		             		<td colspan="6">合计：</td>
		             		<td>${sum_adult }大${sum_child }小${sum_guide }陪</td>
		             		<td></td>
		             		<td></td>
		             		<td>${sum_totalNumber }</td>
		             		<td>${ sum_guestNumber}</td>
		             		<td>${sum_availableNumber }</td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             	</tr>
		             </tbody>
		             <tbody>
		             	<tr>
		             		<td colspan="6">总计：</td>
		             		<td>${sumPerson.totalAdult }大${sumPerson.totalChild }小${sumPerson.totalGuide }陪</td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             		<td></td>
		             	</tr>
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
<script>
$(".lineName").tooltip({content:function(){return $(this).attr('title');}});
fixHeader();
</script>
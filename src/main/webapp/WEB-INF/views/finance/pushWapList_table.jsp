<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String staticPath = request.getContextPath();
%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="11%" />
	<col width="24%" />
	<col width="8%" />
	<col width="6%" />
	<col width="11%" />
	<col width="9%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<col width="6%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>团状态<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>收入<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr 
				<c:if test="${item.group_state eq 3 }">
					style="color:blue;" 
				</c:if>
				<c:if test="${item.group_state eq 4 }">
					style="color:#ee33ee;" 
				</c:if>
			>
				<td class="serialnum">
					<div class="serialnum_btn" groupId="${item.id}"></div> ${status.index+1}
				</td>
				<td style="text-align: left;">
	              <c:if test="${item.group_mode <= 0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a> 
	              </c:if>
	              <c:if test="${item.group_mode > 0}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">${item.group_code}</a>
	              </c:if>
             	</td>
				<td style="text-align: left;">【${item.product_brand_name}】${item.product_name} </td>
				<td>
					<c:if test="${not empty item.total_adult}">${item.total_adult}大</c:if><c:if test="${not empty item.total_child}">${item.total_child}小</c:if><c:if test="${not empty item.total_guide}">${item.total_guide}陪</c:if>
				</td>
				<td>${item.operator_name}</td>
				<c:forEach items="${guideMap}" var="m">
					<c:if test="${m.key==item.id }">
						<td >${m.value }<sub><font color="gray" >${item.userName }</font></sub></td>
					</c:if>
				</c:forEach>
				<td style="text-align: left;"><fmt:formatDate value="${item.date_start}" pattern="MM-dd" />/
					<fmt:formatDate value="${item.date_end}" pattern="MM-dd" />
				</td>
				<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
				<td>
					<c:if test="${item.group_state==0 }">未确认</c:if>
					<c:if test="${item.group_state==1 }">已确认</c:if>
					<c:if test="${item.group_state==1 and nowDate-item.date_start.time < 0}">(待出团)</c:if>
					<c:if test="${item.group_state==1 and  !empty item.date_end and nowDate-item.date_end.time > 0}">(已离开)</c:if>
					<c:if test="${item.group_state==1 and  !empty item.date_end and nowDate-item.date_start.time > 0 and nowDate-item.date_end.time < 0 }">(行程中)</c:if>
					<c:if test="${item.group_state==2}">废弃</c:if>
					<c:if test="${item.group_state==3}">已审核</c:if>
					<c:if test="${item.group_state==4}">封存</c:if>
				</td>
				<td <c:if test="${item.wap_type==0}">style="color:red"</c:if>><c:if test="${item.wap_type==0}">未推送</c:if><c:if test="${item.wap_type==1}">已推送</c:if></td>
				<td>
					<c:if test="${not empty item.total_income}">
						<fmt:formatNumber value="${item.total_income }" pattern="#.##"/>
					</c:if>
					<c:if test="${empty item.total_income}">0</c:if>
				</td>
				<td>
					<a href="javascript:void(0);" onclick="pushInfo(${item.id})"  class="def">同步App</a>
				</td>
			</tr>
			<c:set var="sum_total_income" value="${sum_total_income+item.total_income }" />
			
			<c:set var="sum_total_adult" value="${sum_total_adult+item.total_adult }" />
			<c:set var="sum_total_child" value="${sum_total_child+item.total_child }" />
			<c:set var="sum_total_guide" value="${sum_total_guide+item.total_guide }" />
		</c:forEach>
		</tbody>
		<tfoot>
		<tr class="footer1">
			<td colspan="3">合计:</td>
			<td>${sum_total_adult }大${sum_total_child }小${sum_total_guide }陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_total_income }" pattern="#.##"/></td>
			<td></td>
		</tr>
		</tfoot>		
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
<script type="text/javascript">
function pushInfo(groupId){
	layer.open({
		type : 2,
		title : '同步到APP',
		shadeClose : true,
		shade : 0.5,
		area : [ '1000px', '550px' ],
		content : '../tourGroup/getPushInfo.htm?groupId='+groupId 
	});
}
</script>
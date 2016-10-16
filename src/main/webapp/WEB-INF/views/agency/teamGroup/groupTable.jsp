<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width:3%">序号<i class="w_table_split"></i></th>
			<th style="width:10%">团号<i class="w_table_split"></i></th>
			<th style="width:6%">发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th style="width:4%">天数<i class="w_table_split"></i></th>
			<th style="width:15%">组团社<i class="w_table_split"></i></th>
			<th style="width:8%">客源地<i class="w_table_split"></i></th>
			<th style="width:5%">联系人<i class="w_table_split"></i></th>
			<th style="width:7%">人数<i class="w_table_split"></i></th>
			<th style="width:5%">销售<i class="w_table_split"></i></th>
			<th style="width:5%">操作<i class="w_table_split"></i></th>
			<th style="width:8%">状态<i class="w_table_split"></i></th>
			<th style="width:5%">操作</th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${groupList}" var="gl" varStatus="v">
       		<tr title="创建时间:${gl.tourGroup.createTimeStr},最后修改人:${gl.tourGroup.updateName },最后修改时间:${gl.tourGroup.updateTimeStr}">
              <td>${v.count}</td>
              <td style="text-align: left;"><a href="javascript:void(0);" class="def" onclick="newWindow('查看团订单','teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.tourGroup.id}&operType=0')">${gl.tourGroup.groupCode}</a></td>
              <td><fmt:formatDate value="${gl.tourGroup.dateStart}" pattern="yyyy-MM-dd"/></td>
              <td style="text-align: left;">【${gl.productBrandName}】${gl.productName}</td>
              <td>${gl.tourGroup.daynum}</td>
              <td style="text-align: left;">${gl.supplierName}</td>
              <td>${gl.provinceName}${gl.cityName}</td>
              <td>${gl.contactName}</td>
              <td>${gl.tourGroup.totalAdult}大${gl.tourGroup.totalChild}小${gl.tourGroup.totalGuide}陪</td>
              <td>${gl.saleOperatorName}</td>
              <td>${gl.operatorName}</td>
              <td>
              		<c:if test="${gl.tourGroup.groupState==0}">未确认</c:if>
	                <c:if test="${gl.tourGroup.groupState==1}"><span class="log_action insert">已确认</span></c:if>
					<c:if test="${gl.tourGroup.groupState==2}"><span class="log_action delete">已废弃</span></c:if>
					<c:if test="${gl.tourGroup.groupState==3}"><span class="log_action update">已审核</span></c:if>
					<c:if test="${gl.tourGroup.groupState==4}"><span class="log_action fuchsia">已封存</span></c:if>
					<c:if test="${gl.orderLockState==0}"><span class="ico_unlock"></span></c:if>
		            <c:if test="${gl.orderLockState==1}"><span class="ico_lock"></span></c:if>
			  </td>
              <td>
              	<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						 <a href="javascript:void(0);" onclick="newWindow('查看团队信息','agencyTeam/toEditTeamGroupInfo.htm?groupId=${gl.tourGroup.id}&operType=0')"  class="def" >查看</a>
						 <a href="javascript:void(0);" onclick="printOrderAgency(${gl.id},${gl.tourGroup.groupState},${gl.tourGroup.id})" class="def">打印</a>
						 <!-- and optMap['EDIT']   -->
						<c:if test="${gl.tourGroup.groupState!=3 and gl.tourGroup.groupState!=4 and gl.orderLockState==0}">
	              				<a href="javascript:void(0);" onclick="newWindow('编辑团订单','agencyTeam/toEditTeamGroupInfo.htm?groupId=${gl.tourGroup.id}&operType=1&isSales=${reqpm.isSales}')" class="def">编辑</a>
	              				<a href="javascript:void(0);" onclick="changeGroupState(${gl.groupId},${gl.tourGroup.groupState})" class="def">状态</a>
              			</c:if>
              			
              			<c:if test="${gl.tourGroup.groupState!=3 and gl.tourGroup.groupState!=4 and reqpm.isSales}">
									<a href="javascript:void(0);" class="def" onclick="lockOrUnLock(${gl.id},${gl.orderLockState})"><c:if test="${gl.orderLockState==0 }">锁单</c:if><c:if test="${gl.orderLockState==1 }">取消锁单</c:if></a>
						</c:if>
              			
              			<c:if test="${gl.tourGroup.groupState==2}">
	              				<a href="javascript:void(0);" onclick="deleteGroupOrderById(${gl.id},${gl.groupId})" class="def">删除</a>
	              		</c:if>
		              	<c:if test="${gl.tourGroup.groupState==1}">
		              	<a href="javascript:void(0);" onclick="pushInfo(${gl.tourGroup.id})" class="def">同步App</a>
		              	</c:if>
		              	<c:if test="${gl.tourGroup.groupState!=2}">
	              	 	<a href="javascript:void(0);" onclick="newWindow('复制为新团','tourGroup/toCopyTourGroup.htm?orderId=${gl.id}&groupId=${gl.groupId}')" class="def">复制</a> 
						 </c:if>
						 <c:if test="${gl.tourGroup.groupState==4}">
	              	 	<a href="javascript:void(0);" onclick="newWindow('变更团','tourGroup/toChangeGroup.htm?groupId=${gl.groupId}')" class="def">变更</a> 
						 </c:if>
						 
					</div>
				</div>
              	
              </td>
         	</tr>
       	</c:forEach>
       		<tr class="footer">
					<td colspan="8" style="text-align: right">本页合计：</td>
					<td>${pageTotalAudit }大 ${pageTotalChild }小 ${pageTotalGuide } 陪 </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr class="footer">
					<td colspan="8" style="text-align: right">总合计：</td>
					<td>${totalAudit }大 ${totalChild }小 ${totalGuide }陪 </td>
					<td></td>
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
function lockOrUnLock(orderId,orderState){
	$.confirm("确认变更吗？", function() {
		$.ajax({
			url : "../groupOrder/updateOrderLockState.do",
			type : "post",
			async : false,
			data : {
				"orderId" : orderId,
				"orderLockState":orderState
			},
			dataType : "json",
			success : function(data) {
				if (data.sucess) {
					$.success('变更成功',function(){
						window.location=window.location;
					});
				}else{
					$.warn(data.msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				window.location = window.location;
			}
		});
	}, function() {
		$.info('取消变更');
	});
	
}

</script>
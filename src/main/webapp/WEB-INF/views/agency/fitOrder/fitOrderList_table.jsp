<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style type="text/css">


.time-item strong {

	background:#C71C60;

	color:#fff;

	line-height:20px;

	font-size:15px;

	font-family:Arial;

	padding:0 2px;

	margin-right:2px;

	border-radius:1px;

	box-shadow:1px 1px 1px rgba(0,0,0,0.2);

}




</style>
<script type="text/javascript">



function timer(intDiff,index){

	
	
	var a  = window.setInterval(function(){

	var 

		hour=0,

		minute=0,

		second=0;//时间默认值		

	if(intDiff > 0){

		

		hour = Math.floor(intDiff / (60 * 60)) - (0 * 24);

		minute = Math.floor(intDiff / 60) - (0 * 24 * 60) - (hour * 60);

		second = Math.floor(intDiff) - (0 * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60);

	}

	if (minute <= 9) minute = '0' + minute;

	if (second <= 9) second = '0' + second;


	$('#'+index+'_hour_show').html('<s id="h"></s>'+hour+'时');

	$('#'+index+'_minute_show').html('<s></s>'+minute+'分');

	$('#'+index+'_second_show').html('<s></s>'+second+'秒');

	intDiff--;
	
// 	if(intDiff==0){
// 		searchBtn();
// 	}
	
	}, 1000);
	
	return index+"_"+a ;

} 


</script>
<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width:2%"><input type="checkbox" id="ckAll"></th>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">出发日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th style="width: 8%">客户<i class="w_table_split"></i></th>
			<th style="width: 5%">客人<i class="w_table_split"></i></th>
			<th style="width: 5%">客源地<i class="w_table_split"></i></th>
			<th style="width: 5%">联系人<i class="w_table_split"></i></th>
			<th style="width: 5%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="width: 5%">已收<i class="w_table_split"></i></th>
			<th style="width: 5%">余额<i class="w_table_split"></i></th>
			<th style="width: 5%">标签<i class="w_table_split"></i></th>
			<th style="width: 8%">状态<i class="w_table_split"></i></th>
			<th style="width: 5%">销售<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 5%">操作</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
			<tr title="创建时间:${groupOrder.createTimeStr}==${isSales}==${groupOrder.type}">
				<td><input type="checkbox" name="chkFitOrder" value="${groupOrder.id }"  <c:if test="${!empty groupOrder.groupId or groupOrder.type==0}"> disabled="disabled"  </c:if>/></td>
				<td>${v.count}</td>
				<td style="text-align: left;"><a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','fitGroup/toFitGroupInfo.htm?groupId=${groupOrder.groupId}&operType=0')">${groupOrder.tourGroup.groupCode}</a></td>
				<td>${groupOrder.departureDate}</td>
				<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
				<td style="text-align: left;">${groupOrder.supplierName}</td>
				<td>${groupOrder.receiveMode}</td>
				<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
				<td>${groupOrder.contactName}</td>
				<td>${groupOrder.numAdult }大${groupOrder.numChild}小</td>
				<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${groupOrder.totalCash}" type="currency" pattern="#.##" /></td>
				<td><fmt:formatNumber value="${groupOrder.total-groupOrder.totalCash}" type="currency" pattern="#.##" /></td>
				<td>${groupOrder.guestSourceName}<c:if test="${!empty groupOrder.guestSourceName and !empty groupOrder.sourceTypeName}">/</c:if>${groupOrder.sourceTypeName}</td>
				<td>
					<c:if test="${groupOrder.stateFinance!=1}">
						<c:if test="${groupOrder.type==0}">预留
							<script type="text/javascript">
								 timer((${groupOrder.createTime}+${groupOrder.quartzTime}*60*60*1000-new Date().getTime())/1000,${v.count});
							</script>
							<div class="time-item">
								<strong id="${v.count}_hour_show">0时</strong>
								<strong id="${v.count}_minute_show">0分</strong>
								<strong id="${v.count}_second_show">0秒</strong>
							</div>
						</c:if><c:if test="${groupOrder.type==1}">确认</c:if>/
						<c:if test="${groupOrder.orderLockState==0}">未锁</c:if><c:if test="${groupOrder.orderLockState==1}"><span style="color:blue">已锁</c:if>
					</c:if>
					<c:if test="${groupOrder.stateFinance==1}"><span style="color:blue">已审核</c:if>
				</td>
				<td>${groupOrder.saleOperatorName}</td>
				<td>${groupOrder.operatorName}</td>
				<td>
				    <div class="tab-operate">
						 <a href="####" class="btn-show">操作<span class="caret"></span></a>
						 <div class="btn-hide" id="asd">
						   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','agencyFit/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=0&isSales=${isSales }')">查看</a>
								<c:if test="${groupOrder.stateFinance!=1 && optMap['EDIT'] }">
									<c:if test="${groupOrder.orderLockState==0 }">
										<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','agencyFit/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=1&isSales=${isSales}')">编辑</a>
									</c:if>
									<c:if test="${!isSales}">
									<a href="javascript:void(0);" class="def" onclick="lockOrUnLock(${groupOrder.id},${groupOrder.orderLockState})"><c:if test="${groupOrder.orderLockState==0 }">锁单</c:if><c:if test="${groupOrder.orderLockState==1 }">取消锁单</c:if></a>
									</c:if>
								<c:if test="${empty groupOrder.groupId }">
									<c:if test="${groupOrder.orderLockState==0 }">
										<a href="javascript:void(0);" class="def" onclick="delGroupOrder(${groupOrder.id})">删除</a>
									</c:if>
									<c:if test="${!isSales and groupOrder.type==1}">
									<a href="javascript:void(0);" class="def" onclick="insertGroup(${groupOrder.id})" >加入团</a>
									</c:if>
								</c:if>
								<c:if test="${groupOrder.type==0 and isSales }">
									<a href="javascript:void(0);" class="def" onclick="changeType(${groupOrder.id},1)" >更改状态</a>
								</c:if>
							</c:if> 
								<a href="javascript:void(0);" onclick="printOrder(${groupOrder.id},<c:if test="${empty groupOrder.groupId }">0</c:if><c:if test="${!empty groupOrder.groupId }">${groupOrder.groupId }</c:if>)" class="def">打印</a></td>
						  </div>
					</div>
				</tr>
				<c:set var="pageTotalAdult" value="${pageTotalAdult+groupOrder.numAdult }"/>
				<c:set var="pageTotalChild" value="${pageTotalChild+groupOrder.numChild }"/>
				<c:set var="pageTotal" value="${pageTotal+groupOrder.total }"/>
				
		</c:forEach>
			<tr>
				<td colspan="9" style="text-align: right">本页合计:</td>
				<td>${pageTotalAdult}大${pageTotalChild}小</td>
				<td><fmt:formatNumber value="${pageTotal}" type="currency" pattern="#.##" /></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="9" style="text-align: right">总合计:</td>
				<td>${totalOrder.numAdult}大${totalOrder.numChild}小</td>
				<td><fmt:formatNumber value="${totalOrder.total}" type="currency" pattern="#.##" /></td>
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
		<jsp:param value="${page.page }" name="p" />
		<jsp:param value="${page.totalPage }" name="tp" />
		<jsp:param value="${page.pageSize }" name="ps" />
		<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<c:if test="${!isSales}">
<div class="Footer">
				<dl class="p_paragraph_content">
					<dd>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="toMergeGroup()">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="insertGroupByList()">加入团</a>
					</dd>
				</dl>
</div>
</c:if>
<div id="exportWord"
	style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="" id="saleOrder" target="_blank"
			class="button button-primary button-small">确认单</a>
	</div>
	<div style="margin-top: 10px">
			<a href="" target="_blank" id="krmd" class="button button-primary button-small">客人名单</a>
	</div>
	<div style="margin-top: 10px">
			<a href="" target="_blank" id="cttz" class="button button-primary button-small">出团通知书</a>
	</div>

	
</div>

<script type="text/javascript">
function printOrder(orderId,groupId){
	$("#krmd").css("display","");
	$("#cttz").css("display","");
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1+"&agency="+1) ; //确认单
	if(groupId== 0){
		$("#krmd").css("display","none");
		$("#cttz").css("display","none");
	}else{
	 	$("#krmd").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
	 	$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}

	
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '210px' ],
		content : $('#exportWord')
	});
};
function changeType(id,type){
	$.confirm("是否确认把预留订单转为确认订单？", function() {
		$.getJSON("../agencyFit/changeType.do?id=" + id+"&type="+type, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					searchBtn();
				});
			}else {
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消更改');
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
						searchBtn();
					});
				}else{
					$.warn(data.msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				searchBtn();
			}
		});
	}, function() {
		$.info('取消变更');
	});
	
}

</script>
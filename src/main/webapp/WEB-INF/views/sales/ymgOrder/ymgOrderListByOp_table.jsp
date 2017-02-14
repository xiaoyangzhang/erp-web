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
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width:2%"><input type="checkbox" id="ckAll"></th>
			<th style="width:3%">序号<i class="w_table_split"></i></th>
			<th style="width:8%">团号<i class="w_table_split"></i></th>
			<th style="width:6%">出发日期<i class="w_table_split"></i></th>
			<th style="">产品名称<i class="w_table_split"></i></th>
			<th style="width:14%">平台来源<i class="w_table_split"></i></th>
			<th style="width:12%">客人<i class="w_table_split"></i></th>
			<th style="width:5%">人数<i class="w_table_split"></i></th>
			<th style="width:3%">金额<i class="w_table_split"></i></th>
			<th style="width:8%">订单类别<i class="w_table_split"></i></th>
			<th style="width:4%">业务<i class="w_table_split"></i></th>
			<th style="width:5%">流程<i class="w_table_split"></i></th>
			<th style="width:4%">团状态<i class="w_table_split"></i></th>
			<th style="width:4%">销售员<i class="w_table_split"></i></th>
			<th style="width:4%">计调员<i class="w_table_split"></i></th>
			<th style="width:4%">操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody> 
       	<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
       		 <tr title="创建时间:${groupOrder.createTimeStr}" 
       		style="color:<c:if test="${gl.stateFinance eq 1 and gl.tourGroup.groupState ne 4}">blue</c:if><c:if test="${gl.tourGroup.groupState eq 4}">#ee33ee</c:if><c:if test="${groupOrder.stateFinance eq 1}">blue</c:if>;" >
       		<%--   <td><input type="checkbox" name="chkGroupOrder" value="${groupOrder.id }"  <c:if test="${!empty groupOrder.groupId}">disabled="disabled"  </c:if>/></td> --%>
       		<td><input type="checkbox" name="chkFitOrder" value="${groupOrder.id }" vars="${groupOrder.orderLockState}"  <c:if test="${groupOrder.groupId != null or groupOrder.orderLockState ne 2}">disabled="disabled"  </c:if>/>
				</td>
              <td>${v.count}</td>
              <td style="text-align: left;"><a href="javascript:void(0);" class="def" onclick="lookGroup(${groupOrder.tourGroup.id})">${groupOrder.tourGroup.groupCode}</a></td>
              <td>${groupOrder.departureDate }</td>
              <td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
              <td style="text-align: left;">${groupOrder.supplierName}-${groupOrder.contactName} </td>
              <td style="text-align: left;">${groupOrder.receiveMode}</td>
               <!-- 旺旺号 -->
              <td>${groupOrder.numAdult }+${groupOrder.numChild}+${groupOrder.numGuide} </td>
              <td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
              <td>
						<c:if test="${groupOrder.type==0}">预留
							<script type="text/javascript">
								 timer((${groupOrder.createTime}+${groupOrder.quartzTime}*60*60*1000-new Date().getTime())/1000,${v.count});
							</script>
							<div class="time-item">
								<strong id="${v.count}_hour_show">0时</strong>
								<strong id="${v.count}_minute_show">0分</strong>
								<strong id="${v.count}_second_show">0秒</strong>
							</div>
						</c:if><c:if test="${groupOrder.type==1}">确认</c:if>
				</td>
              <td><c:forEach items="${typeList}" var="v" varStatus="vs">
					<c:if test='${groupOrder.orderMode==v.id}'>${v.value}</c:if> 
							</c:forEach> </td>
			<td>
              	<c:if test="${groupOrder.orderLockState == 0}"><span style="color:">未提交</span></c:if>
              				<c:if test="${groupOrder.orderLockState == 1}"><span style="color:red">接收中</span></c:if>
              				<c:if test="${groupOrder.orderLockState == 2}"><span style="color:blue">已接收</span></c:if>
              </td>
              <td><c:if test="${groupOrder.groupId ==null }"><span style="color:red">待并团</span></c:if>
             		 <c:if test="${groupOrder.groupId !=null }">
              		<c:if test="${groupOrder.groupState==0 }">未确认</c:if>
	                <c:if test="${groupOrder.groupState==1 }"><span class="log_action insert">已确认</span></c:if>
					<c:if test="${groupOrder.groupState==2}"><span class="log_action delete">已废弃</span></c:if>
					<c:if test="${groupOrder.groupState==3}"><span class="log_action update">已审核</span></c:if>
					<c:if test="${groupOrder.groupState==4}"><span class="log_action fuchsia">已封存</span></c:if></c:if>
              </td>	

              <td>${groupOrder.saleOperatorName}</td>
			  <td>${groupOrder.operatorName}</td>
              <td>
              	<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
					 <c:if test="${groupOrder.stateFinance eq 1 or groupOrder.orderLockState eq 0}">
								  <a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','ymg/toEditYMGOrder.htm?id=${groupOrder.id}&see=0')">查看</a>
							  </c:if>
						  <c:if test="${groupOrder.orderLockState ne 0}">
							  
		              	  	  <!-- '1是锁单状态，0是解锁状态，默认0',\\'财务状态(0未审核、1已审核)' -->
		              	      <c:if test="${groupOrder.stateFinance ne 1 and groupOrder.orderLockState ne 3}">
		              	  			<a href="javascript:void(0);" onclick="newWindow('编辑订单','ymg/toEditYMGOrder.htm?id=${groupOrder.id}&see=2')" class="def">编辑</a>
			              	  	  <c:if test="${CHANGE_PRICE}">
			              	  			<a href="javascript:void(0);" onclick="changePrice(${groupOrder.id})" class="def">改价格</a>
			              	      </c:if>
				              	  <c:if test="${groupOrder.groupId !=null }"> 
				              	  		<a href="javascript:void(0);" onclick="changeGroupState(${groupOrder.groupId},${groupOrder.groupState})" class="def">状态</a>
				              	  </c:if>
		              	  	 </c:if>
		              	  	 <c:if test="${empty groupOrder.groupId && groupOrder.orderLockState eq 2}">
							  	<a href="javascript:void(0);" onclick="insertGroupOnly(${groupOrder.id})" class="def">加入团</a>
							  </c:if>
						  <c:if test="${groupOrder.orderLockState == 1}">
		              	  	<a href="javascript:void(0);" onclick="changeorderLockStateByOp(${groupOrder.id})" class="def">确认接收</a>
						  </c:if>
						  <c:if test="${groupOrder.orderLockState == 2 and groupOrder.stateFinance ne 1}">
							<a href="javascript:void(0);" onclick="goBackOrderLockStateByOp(${groupOrder.id})" class="def">退回</a>
						  </c:if>
						</c:if>
						<c:if test="${groupOrder.type==0}">
									<a href="javascript:void(0);" class="def" onclick="changeType(${groupOrder.id},1)" >更改状态</a>
								</c:if>
						<a href="javascript:void(0);" class="def" onclick="printOrder(${groupOrder.id})" >打印</a>
						<a href="javascript:void(0)" class="def" onclick="goLogStock(${groupOrder.id})" >操作日志</a>
					</div>
				</div>
              </td>
         	</tr>
       	</c:forEach>
       	</tbody>
       	<tfoot>
       			<tr class="footer1">
					<td colspan="7" style="text-align: right">本页合计:</td>
					<td>${pageTotalAudit }+ ${pageTotalChild }+${pageTotalGuide }  </td>
					<td><fmt:formatNumber value="${pageTotal}" type="currency" pattern="#.##" /></td>
					<td colspan="7"></td>
				</tr>
				<tr  class="footer2">
					<td colspan="7" style="text-align: right">总合计:</td>
					<td>${totalAudit }+ ${totalChild }+ ${totalGuide }</td>
					<td><fmt:formatNumber value="${total}" type="currency" pattern="#.##" /></td>
					<td colspan="7"></td>
				</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<div class="Footer">
				<dl class="p_paragraph_content">
					<dd>
					<%-- <c:if test="${orderLockSwitch eq 1 && groupOrder.orderLockState eq 1}"> --%>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="toMergeGroup(${orderLockSwitch})">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="insertGroupByList(${orderLockSwitch})">加入团</a>
					<%-- </c:if> --%>
					</dd>
				</dl>
</div>
<!-- <div class="Footer">
				<dl class="p_paragraph_content">
					<dd>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="toMergeGroup()">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="insertGroupByList()">加入团</a>
					</dd>
				</dl>
</div> -->
<div id="exportWord"
	style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="" id="saleOrder" target="_blank"
			class="button button-primary button-small">确认单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" id="saleCharge" target="_blank"
			class="button button-primary button-small">结算单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" id="saleOrderNoRoute" target="_blank"
			class="button button-primary button-small">确认单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleChargeNoRoute"
			class="button button-primary button-small">结算单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContract"
			class="button button-primary button-small">境内旅游合同</a>
	</div>
	<%-- <div style="margin-top: 10px">
		<a href="" target="_blank" id="saleInsurance"
			class="button button-primary button-small">旅游综合保障计划投保书 ${groupOrder.groupId}</a>
	</div> --%>
</div>
<script type="text/javascript">
function printOrder(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	$("#saleTravelContract").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+6) ;
/* 	$("#saleInsurance").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+7) ; */
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '310px' ],
		content : $('#exportWord')
	});
};

$("#ckAll").live("click",function(){
	 $("input[name='chkFitOrder']:enabled").prop("checked", this.checked);
});
$("input[name='chkFitOrder']").live("click",function() {
   var $subs = $("input[name='chkFitOrder']");
   $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
});

function changeorderLockStateByOp(orderId){
	$.confirm("是否确认接收？",  function(){
		$.getJSON("../taobao/changeorderLockStateByOp.do?orderId=" + orderId, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					layer.close(stateIndex);
					refershPage();
				});
			}
		});
	}, function(){
	$.info('操作取消！');
	})
}

function goBackOrderLockStateByOp(orderId){
	$.confirm("是否确认退回？",  function(){
		$.getJSON("../taobao/goBackOrderLockStateByOp.do?orderId=" + orderId, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					layer.close(stateIndex);
					refershPage();
				});
			}
		});
	}, function(){
	$.info('操作取消！');
	})
}

function changePrice(orderId){
	layer.open({
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '800px', '400px' ],
		content : '../taobao/changePrice.do?orderId=' + orderId,
	});
}

function timer(intDiff,index){
	var a  = window.setInterval(function(){
		var hour=0,minute=0,second=0;		
	
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
	}, 1000);
	
	return index+"_"+a ;
} 

var stateIndex;
function changeGroupState(groupId,state){
	if(state==0){
		$.getJSON("../budgetItem/getTotalBudgetByOrderId.do?id=" + groupId ,function(data) {
			if (data.success) {
				$("#modalgroupId").val(groupId);
				$("#modalGroupState").val(state);
				optionState(state);
				layer.open({
					type : 1,
					title : '修改状态',
					shadeClose : true,
					shade : 0.5,
			        area : ['350px','210px'],
					content : $('#stateModal')
				});
			}else{
				$.warn(data.msg);
			}
		});
	}else{
		$("#modalgroupId").val(groupId);
		$("#modalGroupState").val(state);
		optionState(state);
		stateIndex=layer.open({
			type : 1,
			title : '修改状态',
			shadeClose : true,
			shade : 0.5,
	        area : ['350px','210px'],
			content : $('#stateModal')
		});
	}
};

function optionState(state){
	var sltState = document.getElementById("modalGroupState");
	
	while (sltState.firstChild) {
		sltState.removeChild(sltState.firstChild); 
	}
	if(state==0){
		var option1 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);	
	}else if(state==1){
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);
	}else if(state==2){
		var option1 = new Option("未确认", "0");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option2);
	}
}

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
</script>
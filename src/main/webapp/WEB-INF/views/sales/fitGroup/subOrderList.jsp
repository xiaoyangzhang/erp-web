<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<style>
.w_table>tbody>tr:nth-child(odd){background-color:#fff;}
</style>
<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 15%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 15%">组团社<i class="w_table_split"></i></th>
			<th style="width: 5%">接站牌<i class="w_table_split"></i></th>
			<th style="width: 5%">客源地<i class="w_table_split"></i></th>
			<th style="width: 5%">联系人<i class="w_table_split"></i></th>
			<th style="width: 5%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="width: 5%">销售<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 5%">输单员<i class="w_table_split"></i></th>
			<th style="width: 5%">操作</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${orders}" var="groupOrder" varStatus="v">
			<tr title="创建时间:${groupOrder.createTimeStr}">
				<td>${v.count}</td>
				<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
				<td style="text-align: left;">${groupOrder.supplierName}</td>
				<td>${groupOrder.receiveMode}</td>
				<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
				<td>${groupOrder.contactName}</td>
				<td>${groupOrder.numAdult }大${groupOrder.numChild}小</td>
				<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
				<td>${groupOrder.saleOperatorName}</td>
				<td>${groupOrder.operatorName}</td>
				<td>${groupOrder.creatorName}</td>
				<td>
			   		<div class="tab-operate">
						 <a href="####" class="btn-show">操作<span class="caret"></span></a>
						 <div class="btn-hide" id="asd">
							<c:if test="${groupOrder.orderType==0}"> 
							 	<c:if test="${empty groupOrder.priceId }">
						   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=0')">查看</a>
						   		</c:if>
						   		<c:if test="${!empty groupOrder.priceId }">
						   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','groupOrder/toLookGroupOrder.htm?id=${groupOrder.id}')">查看</a>
						   		</c:if>
						 	</c:if>	
						 	
						 
						 		
							<c:if test="${groupOrder.stateFinance!=1}">
									<c:if test="${groupOrder.orderType==0}"> 
										<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=1')">编辑</a>
										<%-- <c:if test="${empty groupOrder.priceId }">
										</c:if>
										<c:if test="${!empty groupOrder.priceId }">
										<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${groupOrder.id}')">编辑</a>
										</c:if> --%>
									
									</c:if>
									
									<c:if test="${groupOrder.orderType==-1}">  
								 		<a href="javascript:void(0);" onclick="newWindow('编辑订单','specialGroup/toEditSpecialGroup.htm?id=${groupOrder.id}')" class="def">编辑</a>
								 	</c:if>	
									<a href="javascript:void(0);" class="def" onclick="delGroupOrder(${groupOrder.id})">删除</a>
							</c:if> 
								<a href="javascript:void(0);" onclick="printOrder1(${groupOrder.id})" class="def">打印</a></td>
						  </div>
					</div>
				</tr>
			</c:forEach>
		</tbody>
</table>
<div id="exportWord1"
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
</div>
<script type="text/javascript">
function printOrder1(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '210px' ],
		content : $('#exportWord1')
	});
};

function delGroupOrder(id) {
	$.confirm("确认删除吗？", function() {
		$.getJSON("../fitGroup/delFitOrder.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					searchBtn();
				});
			}else {
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});

}


</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团订单列表</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">
	function delGroupOrder(id){
		$.confirm("确认删除吗？", function() {
			$.getJSON("delFitOrder.do?id=" + id, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						window.location = window.location;
					});
				}
			});
		}, function() {
			$.info('取消删除');
		})

		
	}
	/**
	 * 打印订单信息
	 * @param orderId
	 */
	function printOrder(orderId){
		/* $("#saleOrder").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+1) ; //销售订单
		$("#saleCharge").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+2) ; //销售价格
		$("#saleOrderNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleChargeNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+5) ; //结算单-无行程 */
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
			content : $('#exportWord')
		});
	};

function openMergeAddGroup(id) {
		layer.open({
			type : 2,
			title : '选择订单',
			shadeClose : true,
			shade : 0.5,
			area : [ '70%', '80%' ],
			content:'toSecImpNotGroupList.htm?page=1&reqType=0&gid='+id
		});
	}

</script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../groupOrder/toFitEdit.htm?groupId=${tourGroup.id}&operType=${operType}">散客团信息</a></li>
			<li><a
				href="../groupRoute/toGroupRoute.htm?groupId=${tourGroup.id}&operType=${operType}">行程列表</a></li>
			<li><a
				href="../groupOrder/toFitOrderList.htm?groupId=${tourGroup.id}&operType=${operType}"
				class="selected">订单列表</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${tourGroup.id}&operType=${operType}">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>
	</div>
	<div class="p_container_sub">
		<p class="p_paragraph_title">
			<b>订单列表</b>
		</p>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="15%">组团社<i class="w_table_split"></i></th>
								<th width="5%">联系人<i class="w_table_split"></i></th>
								<th width="10%">接站牌<i class="w_table_split"></i></th>
								<th width="5%">人数<i class="w_table_split"></i></th>
								<th width="7%">客源地<i class="w_table_split"></i></th>
								<th width="7%">出团<i class="w_table_split"></i></th>
								<th width="7%">散团<i class="w_table_split"></i></th>
								<th width="20%">产品名称<i class="w_table_split"></i></th>
								<th width="5%">销售<i class="w_table_split"></i></th>
								<th width="5%">计调<i class="w_table_split"></i></th>
								<th width="5%">金额<i class="w_table_split"></i></th>
								<th width="10%">操作<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<c:forEach items="${groupOrderList}" var="groupOrder"
							varStatus="index">
							<tr>
								<td>${groupOrder.supplierName}</td>
								<td>${groupOrder.contactName}</td>
								<td>${groupOrder.receiveMode}</td>
								<td>${groupOrder.numAdult}大${groupOrder.numChild }小</td>
								<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
								<td>${groupOrder.departureDate}</td>
								<td>${groupOrder.fitDate}</td>
								<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName }</td>
								<td>${groupOrder.saleOperatorName}</td>
								<td>${groupOrder.operatorName}</td>
								<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
								<td><a href="javascript:void(0)" class="def"
									onclick="newWindow('查看订单','groupOrder/toLookGroupOrder.htm?id=${groupOrder.id}')">查看</a>&nbsp;&nbsp;&nbsp;&nbsp;
									<c:if test="${tourGroup.groupState!=3 and operType==1}"><a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${groupOrder.id}')">编辑</a></c:if>
									<a href="javascript:void(0);"onclick="printOrder(${groupOrder.id})" class="def">打印</a> 
									<c:if test="${tourGroup.groupState!=3 and operType==1}">
									<a href="javascript:void(0);"onclick="delGroupOrder(${groupOrder.id})" class="def">删除</a></td>
								</c:if>
							</tr>
							<c:set var="totalAdult" value="${totalAdult+groupOrder.numAdult }"/>
							<c:set var="totalChild" value="${totalChild+groupOrder.numChild }"/>
							<c:set var="totalMoney" value="${totalMoney+groupOrder.total }"/>	
						</c:forEach>
						<tr>
							<td colspan="3" style="text-align: right">合计：</td>
							<td>${totalAdult}大 ${totalChild }小</td>
							<td colspan="6" style="text-align: right">合计：</td>
							<td><fmt:formatNumber value="${totalMoney}" type="currency" pattern="#.##" /></td>
							<td></td>
						</tr>
					</table>
				</div>
				<div class="clear"></div>
			</dd>
			<c:if test="${tourGroup.groupState!=3 and operType==1}">
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="button" class="button button-primary button-small"
							onclick="openMergeAddGroup(${tourGroup.id});">新增订单</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
		</dl>
		<div style="margin-left:15%">
				<a href="../tourGroup/toSKConfirmPreview.htm?groupId=${tourGroup.id}" target="_blank" id="skqrd" class="button button-primary button-small">散客团确认单</a>
				<a href="previewFitTransfer.htm?groupId=${tourGroup.id}" target="_blank" id="skjd" class="button button-primary button-small">散客计调单</a>
				<a href="../bookingGuide/previewGuideRoute.htm?id=${tourGroup.id}&num=3" target="_blank" id="skdyd" class="button button-primary button-small">导游单行程单</a>
				<a href="previewFitGuide.htm?groupId=${tourGroup.id}" target="_blank" id="skdydwxc" class="button button-primary button-small">散客导游单</a>
				<a href="previewGuestWithoutTrans.htm?groupId=${tourGroup.id}" target="_blank" id="krmd" class="button button-primary button-small">客人名单</a>
				<a href="previewGuestWithTrans.htm?groupId=${tourGroup.id}" target="_blank" id="krmdjs" class="button button-primary button-small">客人名单-接送</a>
				<a href="download.htm?groupId=${tourGroup.id}&num=3" id="ykyjfkd" class="button button-primary button-small">游客反馈意见单</a>
				<a href="../bookingGuide/previewGuideRoute.htm?id=${tourGroup.id}&num=3" id="skgwmxd" class="button button-primary button-small">散客购物明细单</a>
			</div>
</body>
<div id="exportWord"
	style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleOrder" class="button button-primary button-small">确认单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleCharge" class="button button-primary button-small">结算单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleOrderNoRoute" class="button button-primary button-small">确认单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleChargeNoRoute" class="button button-primary button-small">结算单-无行程</a>
	</div>
</div>
</html>
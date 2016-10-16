<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团编辑</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript" src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<link href="<%=ctx%>/assets/css/product/product_rote.css" rel="stylesheet" />
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/sales_route.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/newFitGroup.js"></script>
<script type="text/javascript">
		var path = '<%=ctx%>';
		var startDate=${fitGroupInfoVO.tourGroup.dateStart.time};
		var img200Url = '${config.images200Url}';
		$(function(){
		    $(".l_textarea").autoTextarea({minHeight:50});
		    $(".l_textarea_mark").autoTextarea({minHeight:40});
		});
</script>
<style type="text/css">
.searchTab {
	width: 100%;
}

.searchTab tr td {
	height: 25px;
	padding: 5px;
}

.searchTab tr td:nth-child(odd) {
	min-width: 90px;
	text-align: right;
}

.searchTab tr td:nth-child(even) {
	min-width: 200px;
}
</style>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../fitGroup/toFitGroupInfo.htm?groupId=${fitGroupInfoVO.tourGroup.id}&operType=${operType}"
				class="selected">散客团信息</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${fitGroupInfoVO.tourGroup.id}&operType=${operType}">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>

		<div class="p_container_sub">
			<form id="saveFitGroupInfoForm">
				<p class="p_paragraph_title">
					<b>基本信息</b>
				</p>
				<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tr>
						<td>
							    团号：
							 <input type="hidden" name="tourGroup.id" value="${fitGroupInfoVO.tourGroup.id}">
						     <input type="hidden" name="tourGroup.groupCode" value="${fitGroupInfoVO.tourGroup.groupCode}">
						</td>
						<td>
							${fitGroupInfoVO.tourGroup.groupCode }
						</td>
						<%-- <td>
							  团标识:
						</td>
						<td>
							<input type="text" class="IptText300" name="tourGroup.groupCodeMark" value="${fitGroupInfoVO.tourGroup.groupCodeMark}" placeholder="团标识" />
						</td> --%>
					</tr>
					<tr>
						<td>
							    操作计调：
						</td>
						<td>
							<input type="text"  class="IptText300" id="operatorName" name="tourGroup.operatorName" value="${fitGroupInfoVO.tourGroup.operatorName}"  readonly="readonly"/>
							<input type="hidden" class="IptText300" id="operatorId" name="tourGroup.operatorId" value="${fitGroupInfoVO.tourGroup.operatorId}" />
							<c:if test="${operType==1}"><a href="javascript:void(0)"onclick="selectUser()">变更</a></c:if>
						</td>
						<td>出发日期:</td>
						<td>
							<fmt:formatDate value="${fitGroupInfoVO.tourGroup.dateStart }" pattern="yyyy-MM-dd" />
						</td>
					</tr>
					<tr>
						<td>产品品牌:</td>
						<td>
							<input type="hidden" name="tourGroup.productBrandName" value="${fitGroupInfoVO.tourGroup.productBrandName }" />
							<select name="tourGroup.prudctBrandId">
								<c:forEach items="${ppList}" var="pp">
									<option value="${pp.id}"
										<c:if test="${pp.id== fitGroupInfoVO.tourGroup.prudctBrandId}"> selected="selected" </c:if>>${pp.value}</option>
								</c:forEach>
							</select>	
						</td>
						<td>
							    天数：
						</td>
						<td>
							${fitGroupInfoVO.tourGroup.daynum}
						</td>
					</tr>
					<tr>
						<td>
							  <i class="red">* </i>  产品名称：
						</td>
						<td>
							<input type="text" style="width: 500px;" name="tourGroup.productName" value="${fitGroupInfoVO.tourGroup.productName }" />
						</td>
						<td></td>
						<td></td>
					</tr>
				</table>
				<p class="p_paragraph_title">
					<b>行程列表</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="10%">天数<i class="w_table_split"></i></th>
										<th width="15%">交通<i class="w_table_split"></i></th>
										<th width="45%">行程描述<i class="w_table_split"></i></th>
										<th width="10%">用餐住宿<i class="w_table_split"></i></th>
										<th width="10%">商家列表<i class="w_table_split"></i></th>
										<th width="10%">图片集<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody class="day_content">

								</tbody>
							</table>
							<c:if test="${operType==1}">
							<div>
								<button type="button"
									class="proAdd_btn button button-action button-small">增加</button>
							</div>
							</c:if>

						</div>
					</dd>
					<div class="clear"></div>
					<dd>
						<div class="dd_left">服务标准</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.serviceStandard"
								placeholder="服务标准">${fitGroupInfoVO.tourGroup.serviceStandard}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">温馨提示</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.warmNotice"
								placeholder="温馨提示">${fitGroupInfoVO.tourGroup.warmNotice}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">备注信息</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.remark"
								placeholder="备注">${fitGroupInfoVO.tourGroup.remark }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">内部备注</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.remarkInternal"
								placeholder="内部备注">${fitGroupInfoVO.tourGroup.remarkInternal }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				
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
										<th width="3%"><input type="checkbox" id="chkAll" /></th>
										<th width="3%">序号</th>
										<th width="15%">组团社<i class="w_table_split"></i></th>
										<th width="5%">联系人<i class="w_table_split"></i></th>
										<th width="10%">接站牌<i class="w_table_split"></i></th>
										<th width="5%">人数<i class="w_table_split"></i></th>
										<th width="7%">客源地<i class="w_table_split"></i></th>
										<th width="7%">出团<i class="w_table_split"></i></th>
										<th width="20%">产品名称<i class="w_table_split"></i></th>
										<th width="5%">销售<i class="w_table_split"></i></th>
										<th width="5%">计调<i class="w_table_split"></i></th>
										<th width="5%">金额<i class="w_table_split"></i></th>
										<th width="10%">操作<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<c:forEach items="${fitGroupInfoVO.groupOrderList}" var="groupOrder"
									varStatus="index">
									<tr>	
										<td><input type="checkbox" name="chkFitOrder" value="${groupOrder.id }" <c:if test="${groupOrder.stateFinance==1 }">disabled="disabled"</c:if>></td>
										<td>${index.count }</td>
										<td>${groupOrder.supplierName}</td>
										<td>${groupOrder.contactName}</td>
										<td>${groupOrder.receiveMode}</td>
										<td>${groupOrder.numAdult}大${groupOrder.numChild }小</td>
										<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
										<td>${groupOrder.departureDate}</td>
										<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName }</td>
										<td>${groupOrder.saleOperatorName}</td>
										<td>${groupOrder.operatorName}</td>
										<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
										<td>
										
											<c:if test="${empty groupOrder.priceId }">
														<c:if test="${groupOrder.orderType==0 }">
															<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=0')">查看</a>
														</c:if>
														<c:if test="${groupOrder.orderType==-1 }">
															<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','specialGroup/toEditSpecialGroup.htm?id=${groupOrder.id}&operType=0')">查看</a>
														</c:if>
									   	
									   		</c:if>
									   		<c:if test="${!empty groupOrder.priceId }">
									   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','groupOrder/toLookGroupOrder.htm?id=${groupOrder.id}')">查看</a>
									   		</c:if>
										
											<a href="javascript:void(0);" class="def" onclick="printOrder(${groupOrder.id})" >打印</a>
											<c:if test="${operType==1}">
												<c:if test="${fitGroupInfoVO.tourGroup.groupState!=3 and fitGroupInfoVO.tourGroup.groupState!=4}">
													<c:if test="${empty groupOrder.priceId and groupOrder.stateFinance!=1 }">
													
														<c:if test="${groupOrder.orderType==0 }">
														<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=1')">编辑</a>
														</c:if>
														<c:if test="${groupOrder.orderType==-1 }">
														<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','specialGroup/toEditSpecialGroup.htm?id=${groupOrder.id}')">编辑</a>
														</c:if>
													
													</c:if>
													<c:if test="${!empty groupOrder.priceId and groupOrder.stateFinance!=1}">
													<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${groupOrder.id}')">编辑</a>
													</c:if>
													
											    </c:if>
										  	</c:if>
										</td>
										
									</tr>
									<c:set var="totalAdult" value="${totalAdult+groupOrder.numAdult }"/>
									<c:set var="totalChild" value="${totalChild+groupOrder.numChild }"/>
									<c:set var="totalMoney" value="${totalMoney+groupOrder.total }"/>	
								</c:forEach>
								<tr>
									<td colspan="5" style="text-align: right">合计：</td>
									<td>${totalAdult}大 ${totalChild }小</td>
									<td colspan="5" style="text-align: right">合计：</td>
									<td><fmt:formatNumber value="${totalMoney}" type="currency" pattern="#.##" /></td>
									<td>
										<c:if test="${operType==1}">
											<a href="javascript:void(0);"onclick="delManyGroupOrder(${groupOrder.id})" class="button button-primary button-small">批量删除</a>
										</c:if>
									</td>
									
								</tr>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<!--  已审核+已封存不能对订单操作-->
				
					
					<div class="Footer" style="position:fixed;bottom:0px; right:0px; background-color: rgba(58,128,128,0.7);width: 100%;padding-bottom:0px;margin-bottom:0px;text-align: center;">
						<c:if test="${operType==1}">
							<button type="submit" class="button button-primary button-small">保存</button>
						</c:if>
						<button type="button" class="button button-primary button-small" onclick="printInfo()">打印</button>
					</div>
				
		</form>
		</div>
	</div>
	  <%@ include file="../template/groupRouteTemplate.jsp"%>
	  <script type="text/javascript">
	  	$(function(){
	  		$("#chkAll").click(function(){
	  			 $("input[name='chkFitOrder']:enabled").prop("checked", this.checked);
	  		 });
	  		 $("input[name='chkFitOrder']").click(function() {
	  		    var $subs = $("input[name='chkFitOrder']");
	  		    $("#chkAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
	  		 });
	  	});
	  	
	  	function delManyGroupOrder(){
	  		var chk_value = [];
	  		$("input[name='chkFitOrder']:checked").each(function() {
	  			chk_value.push($(this).val());
	  		});

	  		if (chk_value.length == 0) {
	  			$.error('请先选择散客订单再进行删除操作');
	  			return;
	  		}
	  		
	  		$.confirm("确认删除吗？成功后将会刷新页面！", function() {
				$.getJSON("../fitGroup/delFitOrderMany.do?ids=" + chk_value, function(data) {
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
	  
	  </script>
</body>
</html>
<div style="display: none; text-align: center; margin-top: 10px" id="exportInfo">
	<div style="margin-top: 10px">
		<a href="../tourGroup/toSKConfirmPreview.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="skqrd" class="button button-primary button-small">散客团确认单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../groupOrder/previewFitTransfer.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="skjd" class="button button-primary button-small">散客计调单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../bookingGuide/previewGuideRoute.htm?id=${fitGroupInfoVO.tourGroup.id}&num=3" target="_blank" id="skdyd" class="button button-primary button-small">导游单行程单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../groupOrder/previewFitGuide.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="skdydwxc" class="button button-primary button-small">散客导游单</a>
	</div>	
	<div style="margin-top: 10px">
		<a href="../groupOrder/previewGuestWithoutTrans.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="krmd" class="button button-primary button-small">客人名单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../groupOrder/previewGuestWithTrans.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="krmdjs" class="button button-primary button-small">客人名单-接送</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../groupOrder/download.htm?groupId=${fitGroupInfoVO.tourGroup.id}&num=3" id="ykyjfkd" class="button button-primary button-small">游客反馈意见单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="../groupOrder/toShoppingDetailPreview.htm?groupId=${fitGroupInfoVO.tourGroup.id}" target="_blank" id="skgwmxd" class="button button-primary button-small">散客购物明细单</a>
	</div>
</div>

<div id="exportWord" style="display: none; text-align: center; margin-top: 10px">
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
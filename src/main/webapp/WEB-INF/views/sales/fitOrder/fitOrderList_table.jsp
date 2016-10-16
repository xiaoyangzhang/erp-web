<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table cellspacing="0" cellpadding="0" class="w_table">
	<thead>
		<tr>
			<th style="width:2%"><input type="checkbox" id="ckAll"></th>
			<th style="width: 3%">序号<i class="w_table_split"></i></th>
			<th style="width: 10%">团号<i class="w_table_split"></i></th>
			<th style="width: 5%">出发日期<i class="w_table_split"></i></th>
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
		<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
			<tr title="创建时间:${groupOrder.createTimeStr}">
				<td><input type="checkbox" name="chkFitOrder" value="${groupOrder.id }" vars="${groupOrder.orderLockState}"  <c:if test="${!empty groupOrder.groupId}">disabled="disabled"  </c:if>/>
				</td>
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
				<td>${groupOrder.saleOperatorName}</td>
				<td>${groupOrder.operatorName}</td>
				<td>${groupOrder.creatorName}</td>
				<td>
				    <div class="tab-operate">
						 <a href="####" class="btn-show">操作<span class="caret"></span></a>
						 <div class="btn-hide" id="asd">
						 	<c:if test="${empty groupOrder.priceId }">
						   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=0')">查看</a>
						   		</c:if>
						   		<c:if test="${!empty groupOrder.priceId }">
						   		<a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','groupOrder/toLookGroupOrder.htm?id=${groupOrder.id}')">查看</a>
						   		</c:if>
								<c:if test="${groupOrder.stateFinance!=1 && optMap['EDIT'] }">
									<c:if test="${groupOrder.orderLockState eq 0}">
										<c:if test="${empty groupOrder.priceId }">
										<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','fitOrder/toEditFirOrder.htm?orderId=${groupOrder.id}&operType=1')">编辑</a>
										</c:if>
										<c:if test="${!empty groupOrder.priceId }">
										<a href="javascript:void(0);" class="def" onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${groupOrder.id}')">编辑</a>
										</c:if>
									</c:if>
								<c:if test="${empty groupOrder.groupId }">
									<c:if test="${groupOrder.orderLockState eq 0}">
										<a href="javascript:void(0);" class="def" onclick="delGroupOrder(${groupOrder.id})">删除</a>
									</c:if>
									<c:if test="${orderLockSwitch eq 1 && groupOrder.orderLockState eq 1}">
										<a href="javascript:void(0);" class="def" onclick="insertGroup(${groupOrder.id})" >加入团</a>
									</c:if>
								</c:if>
							</c:if> 
							<a href="javascript:void(0);" onclick="printOrder(${groupOrder.id})" class="def">打印</a>
							<c:if test="${groupOrder.orderLockState eq 1}">
								<a href="javascript:void(0);" onclick="editTrainOrAirTicket(${groupOrder.id})" class="def">编辑接送信息</a>
								<a href="javascript:void(0);" onclick="editGuestInfo(${groupOrder.id})" class="def">编辑客人名单</a>
							</c:if>
						  </div>
					</div>
				</td>
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
			</tr>
			<tr>
				<td colspan="9" style="text-align: right">总合计:</td>
				<td>${totalOrder.numAdult}大${totalOrder.numChild}小</td>
				<td><fmt:formatNumber value="${totalOrder.total}" type="currency" pattern="#.##" /></td>
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
		<a href="" target="_blank" id="ykyjfkd" class="button button-primary button-small">游客反馈意见单</a>
	</div>
</div>
<div id="editTrainOrAriTicket"></div>
<div id="editGuestInfo"></div>
<script type="text/javascript">
function printOrder(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	$("#ykyjfkd").attr("href","../groupOrder/toIndividualOrderGuestTickling.htm?orderId="+orderId) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '250px' ],
		content : $('#exportWord')
	});
};

function editTrainOrAirTicket(orderId){
	
	$("#editTrainOrAriTicket").load("toEditTransportInfo.htm?orderId="+ orderId +"&operType=1");
	
	layer.open({
		type : 1,
		title : '编辑接送信息',
		closeBtn : false,
		area : [ '1000px', '500px' ],
		shadeClose : false,
		content : $("#editTrainOrAriTicket"),
		btn : ['确定','取消' ],
		yes : function(index) {
			saveTransportInfo();
			layer.close(index);
		}
	});
}

function editGuestInfo(orderId){
	
	$("#editGuestInfo").load("toEditGuestInfo.htm?orderId="+ orderId +"&operType=1");
	
	layer.open({
		type : 1,
		title : '编辑接送信息',
		closeBtn : false,
		area : [ '1150px', '500px' ],
		shadeClose : false,
		content : $("#editGuestInfo"),
		btn : ['确定','取消' ],
		yes : function(index) {
			saveGuestInfo();
			layer.close(index);
		}
	});
}



</script>
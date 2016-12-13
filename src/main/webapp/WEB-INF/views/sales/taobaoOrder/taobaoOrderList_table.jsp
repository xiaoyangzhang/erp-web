<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<!-- <th style="width:2%"><input type="checkbox" id="ckAll"></th> -->
			<th style="width:3%">序号<i class="w_table_split"></i></th>
			<th style="width:8%">团号<i class="w_table_split"></i></th>
			<th style="width:6%">出发日期<i class="w_table_split"></i></th>
			<th style="">产品名称<i class="w_table_split"></i></th>
			<th style="width:10%">平台来源<i class="w_table_split"></i></th>
			<th style="width:12%">客人<i class="w_table_split"></i></th>
			<th style="width:12%">旺旺号<i class="w_table_split"></i></th>
			<th style="width:5%">人数<i class="w_table_split"></i></th>
			<th style="width:3%">金额<i class="w_table_split"></i></th>
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
       	<%-- 	<td><input type="checkbox" name="chkFitOrder" value="${groupOrder.id }" vars="${groupOrder.orderLockState}"  <c:if test="${!empty groupOrder.groupId}">disabled="disabled"  </c:if>/>
				</td> --%>
              <td>${v.count}</td>
              <td style="text-align: left;"><a href="javascript:void(0);" class="def" onclick="lookGroup(${groupOrder.tourGroup.id})">${groupOrder.tourGroup.groupCode}</a></td>
              <td style="color:<c:if test="${groupOrder.departureDate < today}">red</c:if>;">${groupOrder.departureDate }</td>
              <td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
              <td style="text-align: left;">${groupOrder.supplierName}-${groupOrder.contactName} </td>
              <td style="text-align: left;">${groupOrder.receiveMode}</td>
              <!-- 旺旺号 -->
              <td style="text-align: left;">${groupOrder.buyerNick}</td>
              <td>${groupOrder.numAdult }+${groupOrder.numChild}+${groupOrder.numGuide} </td>
              <td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
              <td><c:forEach items="${typeList}" var="v" varStatus="vs">
					<c:if test='${groupOrder.orderMode==v.id}'>${v.value}</c:if> 
							</c:forEach> </td>
				<td><c:if test="${groupOrder.orderLockState == 0}"><span style="color:">未提交</span></c:if>
              				<c:if test="${groupOrder.orderLockState == 1}"><span style="color:red">接收中</span></c:if>
              				<c:if test="${groupOrder.orderLockState == 2 || groupOrder.orderLockState == 3 }"><span style="color:blue">已接收</span></c:if>
              </td>
              <td><c:if test="${groupOrder.groupId ==null }"><span style="color:red">待并团</span></c:if>
             		<c:if test="${groupOrder.groupId !=null }">
	              		<c:if test="${groupOrder.groupState==0 }">未确认</c:if>
		                <c:if test="${groupOrder.groupState==1 }"><span class="log_action insert">已确认</span></c:if>
						<c:if test="${groupOrder.groupState==2}"><span class="log_action delete">已废弃</span></c:if>
						<c:if test="${groupOrder.groupState==3}"><span class="log_action update">已审核</span></c:if>
						<c:if test="${groupOrder.groupState==4}"><span class="log_action fuchsia">已封存</span></c:if>
					</c:if>
              </td>	

              <td>${groupOrder.saleOperatorName}</td>
			  <td>${groupOrder.operatorName}</td>
              <td>
              	<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						  <%-- <a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','taobao/toEditTaobaoOrder.htm?id=${groupOrder.id}&see=0')">查看</a> --%>
		              	  <!-- '1是锁单状态，0是解锁状态，默认0',\\'财务状态(0未审核、1已审核)' -->
		              	  <c:if test="${groupOrder.stateFinance eq 1 or groupOrder.orderLockState eq 2 or groupOrder.orderLockState eq 3}">
								  <a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','taobao/toEditTaobaoOrder.htm?id=${groupOrder.id}&see=0')">查看</a>
							  </c:if>
		              	  <c:if test="${groupOrder.orderLockState ne 2 and groupOrder.orderLockState ne 3 and groupOrder.stateFinance ne 1}">
			              	  <a href="javascript:void(0);" onclick="newWindow('编辑订单','taobao/toEditTaobaoOrder.htm?id=${groupOrder.id}&see=1')" class="def">编辑</a>
			              	  <c:if test="${groupOrder.groupId !=null }"> 
			              	  		<a href="javascript:void(0);" onclick="changeGroupState(${groupOrder.groupId},${groupOrder.groupState})" class="def">状态</a>
			              	  </c:if>
			              	  
		              	  </c:if>
		                  <a href="javascript:void(0);" class="def" onclick="printOrder(${groupOrder.id})" >打印</a>
		                  <c:if test="${groupOrder.orderLockState ne 3 and groupOrder.orderLockState ne 2 and groupOrder.stateFinance ne 1 and groupOrder.totalCash=='0.0000' and (groupOrder.groupState!=3 and groupOrder.groupState!=4)}">
			              	  <a href="javascript:void(0);" onclick="delGroup(${groupOrder.id })" class="def">删除</a>
		              	  </c:if>
		              	  <c:if test="${groupOrder.orderLockState == 0}">
		              	  <a href="javascript:void(0);" onclick="changeorderLockState(${groupOrder.id})" class="def">提交给计调</a>
						</c:if>
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
					<td colspan="6"></td>
				</tr>
				<tr  class="footer2">
					<td colspan="7" style="text-align: right">总合计:</td>
					<td>${totalAudit }+ ${totalChild }+ ${totalGuide }</td>
					<td><fmt:formatNumber value="${total}" type="currency" pattern="#.##" /></td>
					<td colspan="6"></td>
				</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

<%-- <div class="Footer">
				<dl class="p_paragraph_content">
					<dd>
					<c:if test="${orderLockSwitch eq 1 && groupOrder.orderLockState eq 1}">
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="toMergeGroup(${orderLockSwitch})">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="insertGroupByList(${orderLockSwitch})">加入团</a>
					</c:if>
					</dd>
				</dl>
</div>
 --%>
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
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractAY"
			class="button button-primary button-small">境内旅游合同(爱游)</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractJY"
			class="button button-primary button-small">境内旅游合同(景怡)</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractYM"
			class="button button-primary button-small">境内旅游合同(怡美)</a>
	</div>
</div>
<script type="text/javascript">
function printOrder(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	$("#saleTravelContract").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+6) ;
	$("#saleTravelContractAY").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+9) ;
	$("#saleTravelContractJY").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+10) ;
	$("#saleTravelContractYM").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+11) ;
	//$("#saleInsurance").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+7) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '310px' ],
		content : $('#exportWord')
	});
};

function changeorderLockState(orderId){
	$.confirm("是否确认提交给计调？",  function(){
		$.getJSON("../taobao/changeOrderLockState.do?orderId=" + orderId, function(data) {
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
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width:2%"><input type="checkbox" id="ckAll"></th>
			<th style="width:3%">序号<i class="w_table_split"></i></th>
			<th style="width:10%">团号<i class="w_table_split"></i></th>
			<th style="width:5%">出发日期<i class="w_table_split"></i></th>
			<th style="width: 15%">产品名称<i class="w_table_split"></i></th>
			<th style="width: 15%">组团社<i class="w_table_split"></i></th>
			<th style="width: 4%">联系人<i class="w_table_split"></i></th>
			<th style="width: 6%">接站牌<i class="w_table_split"></i></th>
			<th style="width: 5%">客源地<i class="w_table_split"></i></th>
			<th style="width: 5%">人数<i class="w_table_split"></i></th>
			<th style="width: 5%">金额<i class="w_table_split"></i></th>
			<th style="width: 5%">销售<i class="w_table_split"></i></th>
			<th style="width: 5%">计调<i class="w_table_split"></i></th>
			<th style="width: 5%">输单<i class="w_table_split"></i></th>
			<th style="width: 5%">状态<i class="w_table_split"></i></th>
			<th style="width: 5%">操作</th>
		</tr>
	</thead>
	<tbody> 
       	<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
       		 <tr title="创建时间:${groupOrder.createTimeStr}"  style="color: <c:if test="${groupOrder.groupState eq 4}">#ee33ee</c:if>
       		 		<c:if test="${groupOrder.stateFinance eq 1 and groupOrder.groupState ne 4}">blue</c:if>" >
       		  <td><input type="checkbox" name="chkGroupOrder" value="${groupOrder.id }"  <c:if test="${!empty groupOrder.groupId}">disabled="disabled"  </c:if>/></td>
              <td>${v.count}</td>
              <td style="text-align: left;"><a href="javascript:void(0);" class="def" onclick="lookGroup(${groupOrder.tourGroup.id})">${groupOrder.tourGroup.groupCode}</a></td>
              <td>${groupOrder.departureDate }</td>
              <td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
              <td style="text-align: left;">${groupOrder.supplierName}-${groupOrder.contactName} </td>
              <td >${groupOrder.contactName} </td>
              <td style="text-align: left;">${groupOrder.receiveMode}</td>
              <td>${groupOrder.provinceName}${groupOrder.cityName}</td>
              <td>${groupOrder.numAdult }+${groupOrder.numChild}+${groupOrder.numGuide} </td>
              <td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##" /></td>
              <td>${groupOrder.saleOperatorName}</td>
			  <td>${groupOrder.operatorName}</td>
			  <td>${groupOrder.creatorName}</td>
			  <td>
					<c:if test="${groupOrder.groupState!=4}">
						<c:if test="${groupOrder.stateFinance==1}"><span class="log_action insert" title="已审核">审</span></c:if>
						<c:if test="${groupOrder.stateFinance!=1}"><span class="log_action normal" title="未审核">未</span></c:if>
					</c:if>
					<c:if test="${groupOrder.groupState==4}"><span class="log_action fuchsia" title="已封存">封</span></c:if>
					<c:if test="${groupOrder.orderLockState==0}"><span class="ico_unlock" title="未锁单"></span></c:if>
					<c:if test="${groupOrder.orderLockState==1}"><span class="ico_lock" title="已锁单"></span></c:if>
				</td>
              <td>
              	<div class="tab-operate">
					<a href="####" class="btn-show">操作<span class="caret"></span></a>
					<div class="btn-hide" id="asd">
						  <a href="javascript:void(0);" class="def" onclick="newWindow('查看订单','specialGroup/toEditSpecialGroup.htm?id=${groupOrder.id}&operType=0')">查看</a>
						  <c:if test="${empty groupOrder.groupId }"><a href="javascript:void(0);" onclick="insertGroupOnly(${groupOrder.id})" class="def">加入团</a></c:if>
		              	  <!-- '1是锁单状态，0是解锁状态，默认0',\\'财务状态(0未审核、1已审核)' -->
		              	  <c:if test="${groupOrder.orderLockState eq 0 and groupOrder.stateFinance ne 1}">
			              	  <a href="javascript:void(0);" onclick="editGroup(${groupOrder.id})" class="def">编辑</a>
		              	  </c:if>
		                  <a href="javascript:void(0);" class="def" onclick="printOrder(${groupOrder.id})" >打印</a>
		                  <c:if test="${groupOrder.orderLockState eq 0 and groupOrder.stateFinance ne 1}">
			              	  <c:if test="${empty groupOrder.groupId }"><a href="javascript:void(0);" onclick="delGroup(${groupOrder.id })" class="def">删除</a></c:if>
		              	  </c:if>
					</div>
				</div>
              </td>
         	</tr>
       	</c:forEach>
       	</tbody>
       	<tfoot>
       			<tr class="footer1">
					<td colspan="9" style="text-align: right">本页合计:</td>
					<td>${pageTotalAudit }+ ${pageTotalChild }+${pageTotalGuide }  </td>
					<td><fmt:formatNumber value="${pageTotal}" type="currency" pattern="#.##" /></td>
					<td colspan="5"></td>
				</tr>
				<tr class="footer2">
					<td colspan="9" style="text-align: right">总合计:</td>
					<td>${totalAudit }+ ${totalChild }+ ${totalGuide }</td>
					<td><fmt:formatNumber value="${total}" type="currency" pattern="#.##" /></td>
					<td colspan="5"></td>
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
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="toMergeGroup()">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="insertGroupByList()">加入团</a>
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
</div>
<script type="text/javascript">
function printOrder(orderId){
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

</script>
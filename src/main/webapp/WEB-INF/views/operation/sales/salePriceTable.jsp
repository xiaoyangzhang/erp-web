<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
$(function(){
	$('#resultTable').mergeCell({
	    // 目前只有cols这么一个配置项, 用数组表示列的索引,从0开始 
	    // 然后根据指定列来处理(合并)相同内容单元格 
	    cols: [1,2,3,4,5,6,7]
	});
	var idArr = new Array();
	var adultSum=0;
	var childSum=0;
	var guideSum=0;
	$("#resultTable").find("td[name='idxcol']").each(function(){
		if($.inArray($(this).attr("oid"),idArr)==-1){
			idArr.push($(this).attr("oid"));
			adultSum+= parseInt($(this).attr("adult"));
			childSum+= parseInt($(this).attr("child"));
			guideSum+= parseInt($(this).attr("guide"));
		}
	})
	
	$("#numtotal").html(adultSum+"+"+childSum+"+"+guideSum);
});
</script>
<table class="w_table" id="resultTable">
	<colgroup>
		<col width="3%"/>
		<col width="10%"/>
		<col width="5%"/>
		<col width="17%"/>
		<col width="10%"/>
		<col width="7%"/>
		<col width="7%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="11%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
	</colgroup>
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>出团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>销售员<i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th>单价<i class="w_table_split"></i></th>
			<th>次数<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>金额<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${prices}" var="p" varStatus="v">
          <tr>
          	<td name="idxcol" oid="${p.orderId}" adult="${p.numAdult}" child="${p.numChild}" guide="${p.numGuide}">${v.count}</td>
          	<td style="text-align: left">${p.groupCode}<input type="hidden" value="${p.orderId}" /></td>
          	<td style="text-align: left"><fmt:formatDate value="${p.dateStart}" pattern="yyyy-MM-dd"/><input type="hidden" value="${p.orderId}" /></td>
          	<td style="text-align: left">【${p.productBrandName}】${p.productName}<input type="hidden" value="${p.orderId}" /></td>
          	<td style="text-align: left">${p.supplierName}<input type="hidden" value="${p.orderId}" /></td>
          	<td>${p.receiveMode}<input type="hidden" value="${p.orderId}" /></td>
          	<td>${p.numAdult}大${p.numChild}小${p.numGuide}陪<input type="hidden" value="${p.orderId}" /></td>
          	<td>${p.saleOperatorName}<input type="hidden" value="${p.orderId}" /></td>
			<td >${p.itemName}</td>
			<td style="text-align: left">${p.remark}</td>
			<td><fmt:formatNumber value="${p.unitPrice}" type="number" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${p.numTimes}" type="number" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${p.numPerson}" type="number" pattern="#.##"/></td>
			<td><fmt:formatNumber value="${p.totalPrice}" type="number" pattern="#.##"/></td>
          </tr>
          <c:set var="sum_adult" value="${sum_adult+p.numAdult}" />
          <c:set var="sum_child" value="${sum_child+p.numChild}" />
          <c:set var="sum_guide" value="${sum_guide+p.numGuide}" />
          <c:set var="sum_totalPrice" value="${sum_totalPrice+p.totalPrice}" />
        </c:forEach>  
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6" style="text-align:right">本页合计：</td>
			<td id="numtotal">0+0+0</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td><fmt:formatNumber value="${sum_totalPrice}" type="number" pattern="#.##"/></td>
		</tr>
		<tr>
			<td colspan="13" style="text-align:right">总合计：</td>
			<td><fmt:formatNumber value="${totals}" type="number" pattern="#.##"/></td>
		</tr>
	</tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>



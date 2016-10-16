<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">

$(function(){
	
	
	$("#ckAll").click(function() {
	    $("input[name='chkGroupOrder']").prop("checked", this.checked);
	  });
	  
	  $("input[name='chkGroupOrder']").click(function() {
	    var $subs = $("input[name='chkGroupOrder']");
	    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
	  });
	
})
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#groupPage").val(page);
	$("#pageSize").val(pageSize);
	$("#toSecImpNotGroupListForm").submit();
}

function addGroupOrder(gid) {

	var chk_value = [];
	$("input[name='chkGroupOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行添加操作');
		return;
	}
	
	ids = chk_value;
	$.getJSON("secMergeGroup.htm?groupId="+gid+"&ids="+ids, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				window.parent.location = window.parent.location;
			});
			
		} else {
			$.error(data.msg);
		}
	});

}





</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form action="toSecImpNotGroupList.htm" method="post"
					id="toSecImpNotGroupListForm">
					<input type="hidden" name="gid"
						value="${groupId}">
					<input type="hidden" name="page" id="groupPage"
						value="${groupOrder.page}"> <input type="hidden"
						name="pageSize" id="pageSize" value="${groupOrder.pageSize}">
						<input type="hidden" name="dateType" value="1">
					<ul>
						<li class="text">产品品牌</li>
						<li><select name="productBrandId"><option value="-1"
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}"
										<c:if test="${groupOrder.productBrandId==pp.id }"> selected="selected" </c:if>>${pp.value }</option>
								</c:forEach>
						</select></li>
						<li class="text">产品名称</li>
						<li><input name="productName" type="text"
							value="${groupOrder.productName}" /></li>
						<li class="text">接站牌</li>
						<li><input name="receiveMode" type="text"
							value="${groupOrder.receiveMode}" /></li>
						<li class="text">出团日期</li>
						<li><input name="departureDate" type="text"
							value="${groupOrder.departureDate }" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />~<input
							name="endTime" value="${groupOrder.endTime}" type="text"
							class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="clear" />
						<li class="text"></li>
						<li><button type="submit"
								class="button button-primary button-small">查询</button>
							<button type="reset"
								class="button button-primary button-small">重置</button>
							<button type="button"
								class="button button-primary button-small"
								onclick="addGroupOrder(${groupId})">确定</button></li>
					</ul>
				</form>
			</div>

		</div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<thead>
				<tr>
					<th style="width:4%"><i class="w_table_split"></i><input type="checkbox" id="ckAll"></th>
					<th style="width:4%">序号<i class="w_table_split"></i></th>
					<!-- <th>订单号<i class="w_table_split"></i></th> -->
					<th style="width:16%">产品名称<i class="w_table_split"></i></th>
					<th style="width:20%">组团社<i class="w_table_split"></i></th>
					<th style="width:8%">接站牌<i class="w_table_split"></i></th>
					<th style="width:8%">客源地<i class="w_table_split"></i></th>
					<th style="width:5%">销售<i class="w_table_split"></i></th>
					<th style="width:5%">计调<i class="w_table_split"></i></th>
					<th style="width:5%">人数<i class="w_table_split"></i></th>
					<th style="width:6%">金额<i class="w_table_split"></i></th>
					<th style="width:5%">创建人<i class="w_table_split"></i></th>
					<th style="width:7%">出团时间<i class="w_table_split"></i></th>
					<th style="width:7%">联系人<i class="w_table_split"></i></th>
				
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
					<tr>
						<td><input type="checkbox" name="chkGroupOrder"
							value="${groupOrder.id}"></td>
						<td>${v.count}</td>
						<%-- <td>${groupOrder.orderNo}</td> --%>
						<td style="text-align: left">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
						<td style="text-align: left">${groupOrder.supplierName}</td>
						<td>${groupOrder.receiveMode}</td>
						<td>${groupOrder.provinceName}${groupOrder.cityName}</td>
						<td>${groupOrder.saleOperatorName}</td>
						<td>${groupOrder.operatorName}</td>
						<td>${groupOrder.numAdult }大  ${groupOrder.numChild}小</td>
						<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##"/></td>
						<td>${groupOrder.creatorName}</td>
						<td>${groupOrder.departureDate}</td>
						<td>${groupOrder.contactName}</td>
						
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<jsp:include page="/WEB-INF/include/page.jsp">
			<jsp:param value="${page.page }" name="p" />
			<jsp:param value="${page.totalPage }" name="tp" />
			<jsp:param value="${page.pageSize }" name="ps" />
			<jsp:param value="${page.totalCount }" name="tn" />
		</jsp:include>


	</div>
</body>
</html>
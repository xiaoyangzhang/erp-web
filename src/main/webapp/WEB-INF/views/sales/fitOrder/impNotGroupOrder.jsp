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
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#groupPage").val(page);
	$("#pageSize").val(pageSize);
	$("#toImpNotGroupListForm").submit();
}

function mergeGroup(ids) {

	var chk_value = [];
	$("#chkGroupOrder:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行并团操作');
		return;
	}
	
	ids = chk_value+","+ids;
	$.getJSON("../fitOrder/judgeMergeGroup.htm?ids="+ids, function(data) {
		if (data.success) {
			window.parent.location = '../fitOrder/toMergeGroup.htm?ids=' + ids;
		} else {
			$.error(data.msg);
		}
	});

}

function reset() {
	$("#toImpNotGroupListForm").clearForm();
}



</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<div class="searchRow">
				<form action="toImpNotGroupList.htm" method="post"
					id="toImpNotGroupListForm">
					<input type="hidden" name="idLists" value="${idLists}"> <input
						type="hidden" name="page" id="groupPage"
						value="${groupOrder.page}"> <input type="hidden"
						name="pageSize" id="pageSize" value="${groupOrder.pageSize}">
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
							<button type="reset" onclick="reset()"
								class="button button-primary button-small">重置</button>
							<button type="button"
								class="button button-primary button-small" onclick="mergeGroup('${idLists}')">确定</button>

						</li>
					</ul>
				</form>
			</div>

		</div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<thead>
				<tr>
					<th><i class="w_table_split"></i></th>
					<th>订单号<i class="w_table_split"></i></th>
					<th>产品名称<i class="w_table_split"></i></th>
					<th>计调<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
					<th>金额<i class="w_table_split"></i></th>
					<th>创建人<i class="w_table_split"></i></th>
					<th>出团时间<i class="w_table_split"></i></th>
					<th>组团社<i class="w_table_split"></i></th>
					<th>联系人<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.result}" var="groupOrder">
					<tr>
						<td><input type="checkbox" id="chkGroupOrder"
							value="${groupOrder.id}"></td>
						<td>${groupOrder.orderNo}</td>
						<td>【${groupOrder.productBrandName}】${groupOrder.productName}</td>
						<td>${groupOrder.operatorName}</td>
						<td>${groupOrder.numAdult }大  ${groupOrder.numChild}小</td>
						<td><fmt:formatNumber value="${groupOrder.total}" type="currency" pattern="#.##"/></td>
						<td>${groupOrder.creatorName}</td>
						<td>${groupOrder.departureDate}</td>
						<td>${groupOrder.supplierName}</td>
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
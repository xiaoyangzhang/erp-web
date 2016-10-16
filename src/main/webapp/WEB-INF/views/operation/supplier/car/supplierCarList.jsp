<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../../include/top.jsp"%>
<style type="text/css">
	.Wdate{width:95px;}
</style>

</head>
<body>
	<div class="p_container">
		<form id="searchSupplierCarForm" action="toSupplierCarList.htm" method="post">
			<input type="hidden" name="page" value="${supplierCar.page}"
				id="searchPage" /> <input type="hidden" name="pageSize"
				value="${supplierCar.pageSize}" id="searchPageSize" /> 
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text" style="width: 76px;">购车日期:</li>
						<li><input type="text" name="buyStart" class="Wdate" style="width:80px;"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
							value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCar.buyStart}'/>" />~<input
							type="text" name="buyEnd" class="Wdate"  style="width:80px;"
							value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCar.buyEnd}'/>"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text" style="width: 76px;">座位数:</li>
						<li><input type="text" name="seatStart" style="width:50px;"
							value="${supplierCar.seatStart}"/>~<input  style="width:50px;"
							type="text" name="seatEnd"
							value="${supplierCar.seatEnd}" />
						</li>
						<li class="text" style="width: 76px;">车牌号:</li>
						<li>
							<input type="text"  style="width:80px;" name="carLisenseNo" value="${supplierCar.carLisenseNo }" class="input-small" />
						</li>
						
						<li class="text" style="width: 76px;">车型:</li>
						<li>
							<select name="typeId">
								<option value="0">全部</option>
								<c:forEach items="${carType}" var="type">
									<option value="${type.id }"
										<c:if test="${type.id==supplierCar.typeId }">selected="selected"</c:if>>${type.value}</option>
								</c:forEach>
							</select> 
							
						</li>
						<li class="text"></li>
						<li>
							<button
								class="button button-primary button-small"
								onclick="searchBtn();">搜索</button>
							
						</li>
						<li class="clear" />
					</ul>
				</div>
			</div>
			
		</form>
		<table class="w_table" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="5%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="15%">
							<col width="10%">
					    </colgroup>
			<thead>
				<tr>
					<th>选择</th>
					<th>序号<i class="w_table_split"></i></th>
					<th>车型<i class="w_table_split"></i></th>
					<th>车牌号<i class="w_table_split"></i></th>
					<th>座位数<i class="w_table_split"></i></th>
					<th>品牌型号<i class="w_table_split"></i></th>
					<th>保险<i class="w_table_split"></i></th>
					<th>购车日期<i class="w_table_split"></i></th>
					<th>年审日期<i class="w_table_split"></i></th>
					<th>照片<i class="w_table_split"></i></th>
					
				</tr>
			</thead>
			<c:forEach items="${voList}" var="vo"
				varStatus="status">
				<tr>
					<td><input type="radio" name="subBox" <c:if test="${vo.supplierCar.state!=1 }">disabled</c:if> sid="${vo.supplierCar.id}"  carLisenseNo="${vo.supplierCar.carLisenseNo }"  seatNum="${vo.supplierCar.seatNum }"/></td>
					<td>${status.count}</td>
					<td>${vo.supplierCar.typeName }</td>
					<td >${vo.supplierCar.carLisenseNo }</td>
					<td >${vo.supplierCar.seatNum }</td>
					<td style="text-align: left">${vo.supplierCar.brand }${vo.supplierCar.mode }</td>
					<td style="text-align: left">${vo.supplierCar.insurance }</td>
					<td><fmt:formatDate value="${vo.supplierCar.buyDate }" pattern="yyyy-MM-dd"/></td>
					<td><fmt:formatDate value="${vo.supplierCar.examDate }" pattern="yyyy-MM-dd"/></td>
					<td>
						<c:forEach items="${vo.imgList }" var="img">
							<span class="ulImg" style="width:50px;height:50px;">
							<img src="${config.imgServerUrl}${img.imgPath}" />
							</span>
						</c:forEach>
						
					</td>
					<td>
						
					</td>
				</tr>

			</c:forEach>
		</table>
		<jsp:include page="/WEB-INF/include/page.jsp">
			<jsp:param value="${page.page }" name="p" />
			<jsp:param value="${page.totalPage }" name="tp" />
			<jsp:param value="${page.pageSize }" name="ps" />
			<jsp:param value="${page.totalCount }" name="tn" />
		</jsp:include>
	</div>

</body>
<script type="text/javascript">
/**
 * 分页查询
 */
function queryList(page, pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPage").val(page);
	$("#searchPageSize").val(pageSize);
	var $form = $("#searchSupplierCarForm");
	$form.submit();
}
function searchBtn() {
	$("#searchPage").val(1);
	var $form = $("#searchSupplierCarForm");
	$form.submit();

}
function getSelectedCarLisence(){
	var $check = $("input[name='subBox']:checked");
	if($check.length==0){	
		return null;
	}
	return {carLisenseNo:$check.attr("carLisenseNo"),seatNum:$check.attr("seatNum")};
}
</script>
</html>
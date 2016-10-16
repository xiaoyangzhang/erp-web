<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
	.Wdate{width:95px;}
</style>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplierCar.js"></script>
	<script type="text/javascript">
	/* $(function() {
		function setData(){
			var curDate=new Date();
			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
			 $("#buyStart").val(startTime);
			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
		     var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
		     $("#buyEnd").val(endTime);			
		}
		setData();
	//queryList();
	
	 
}); */
	</script>
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
						<%-- <li class="text" style="width: 76px;">购车日期:</li>
						<li><input type="text" name="buyStart" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
							value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCar.buyStart}'/>" />~<input
							type="text" name="buyEnd" class="Wdate"
							value="<fmt:formatDate pattern='yyyy-MM-dd' value='${supplierCar.buyEnd}'/>"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li> --%>
						<li class="text" style="width: 76px;">座位数:</li>
						<li><input type="text" name="seatStart" 
							value="${supplierCar.seatStart}"/>~<input
							type="text" name="seatEnd"
							value="${supplierCar.seatEnd}" />
						</li>
						<li class="text" style="width: 76px;">车牌号:</li>
						<li>
							<input type="text" name="carLisenseNo" value="${supplierCar.carLisenseNo }" class="input-small" />
						</li>
						
						<li class="text" style="width: 76px;">车型:</li>
						<li>
							<select name="typeId" style="width:100px;text-align: right;">
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
							<c:if test="${optMap['EDIT'] }"> 
								<a class="button button-primary button-small"  onclick="newWindow('新增车辆档案','supplierCar/toAddSupplierCar.htm')" href="javascript:void(0)" >新增</a>
								<input type="button" class="button button-primary button-small" onclick="toImpSupplierCar()" value="导入" />
							</c:if>
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
					<th>序号<i class="w_table_split"></i></th>
					<th>车型<i class="w_table_split"></i></th>
					<th>车牌号<i class="w_table_split"></i></th>
					<th>座位数<i class="w_table_split"></i></th>
					<th>品牌型号<i class="w_table_split"></i></th>
					<th>保险<i class="w_table_split"></i></th>
					<th>购车日期<i class="w_table_split"></i></th>
					<th>年审日期<i class="w_table_split"></i></th>
					<th>照片<i class="w_table_split"></i></th>
					<th>操作<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<c:forEach items="${voList}" var="vo"
				varStatus="status">
				<tr>
					<td>${status.count}</td>
					<td>${vo.supplierCar.typeName }</td>
					<td>${vo.supplierCar.carLisenseNo }</td>
					<td>${vo.supplierCar.seatNum }</td>
					<td style="text-align: left">${vo.supplierCar.brand }${vo.supplierCar.mode }</td>
					<td style="text-align: left">${vo.supplierCar.insurance }</td>
					<td><fmt:formatDate value="${vo.supplierCar.buyDate }" pattern="yyyy-MM-dd"/></td>
					<td><fmt:formatDate value="${vo.supplierCar.examDate }" pattern="yyyy-MM-dd"/></td>
					<td>
						<c:forEach items="${vo.imgList }" var="img">
							<span class="ulImg">
							<img src="${config.imgServerUrl}${cf:thumbnail(img.imgPath,'200x200')}" />
							</span>
						</c:forEach>
						
					</td>
					<td>
						<c:if test="${optMap['EDIT'] }"> 
							<a class="def" onclick="newWindow('修改车辆档案','supplierCar/toEditSupplierCar.htm?id=${vo.supplierCar.id}')" href="javascript:void(0)">修改</a>
                            <a href="javascript:void(0);" class="def" onclick="delPrivateCar(${vo.supplierCar.id})">删除</a>
						</c:if>
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
</html>
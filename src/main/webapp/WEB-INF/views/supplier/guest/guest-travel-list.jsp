<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
.label-list {
	margin-bottom: 30px;
}

.label-list ul {
	margin-left: 10px;
	overflow: hidden;
}

.label-list ul li {
	float: left;
	position: relative;
	width: 170px;
	height: 80px;
	margin: 10px 0 10px 20px;
	border: 1px solid #ddd;
}

.label-list ul li .label-name {
	width: 120px;
	margin: 10px 0 10px 15px;
	font-size: 16px;
	font-weight: 700;
}

.label-list ul li .label-num {
	margin: 0 0 10px 15px;
}

.label-list ul li .label-del {
	position: absolute;
	top: 5px;
	right: 5px;
}
</style>
</head>
<body>
	<div class="p_container" >	
		    <div class="p_container_sub">
		    	<p class="p_paragraph_title"><b>旅游记录</b></p>
	             <div class="pl-10 pr-10" >
					<table cellspacing="0" cellpadding="0" class="w_table">
						<col width="3%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<thead>
							<tr>
								<th>序号<i class="w_table_split"></i></th>
								<th>日期<i class="w_table_split"></i></th>
								<th>团号<i class="w_table_split"></i></th>
								<th>产品<i class="w_table_split"></i></th>
								<th>天数<i class="w_table_split"></i></th>
								<th>人数<i class="w_table_split"></i></th>
								<th>金额<i class="w_table_split"></i></th>
								<th>计调<i class="w_table_split"></i></th>
								<th>操作<i class="w_table_split"></i></th>
								
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${groups}" var="item" varStatus="status">
								<tr>
									<td>${status.index+1}</td>
									<td ><fmt:formatDate value="${item.dateStart}" pattern="yyyy/MM/dd" /></td>
									<td >${item.groupCode}</td>
									<td style="text-align: left;" >【${item.productBrandName}】${item.productName}</td>
									<td >${item.daynum}</td>
									<td >${item.totalAdult+item.totalChild+item.totalGuide}</td>
									<td ><fmt:formatNumber value="${item.totalIncome }" pattern="#.##"/></td>
									<td >${item.operatorName}</td>
									<td>
						              <c:if test="${item.groupMode <= 0}">
						              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.id}&operType=0')">查看详细</a> 
						              </c:if>
						              <c:if test="${item.groupMode > 0}">
						              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.id}&operType=0')">查看详细</a>
						              </c:if>
					                </td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					 </div>
	        </div>

	    </div>
</body>
<script type="text/javascript"
	src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function addLabel(){
	var name = $("#labelName").val();
	$.post("addLabel.do", {"name": name}, function(data){
		data = $.parseJSON(data);
		if(data.success == true){
			$.success(data.msg);
			$("#labelName").val("");
			location.reload();
		}else{
			$.error(data.msg);
		}
	}); 
}

function deleteLabel(id){
	$.post("deleteLabel.do", {"id": id}, function(data){
		data = $.parseJSON(data);
		if(data.success == true){
			$.success(data.msg);
			location.reload();
		}else{
			$.error(data.msg);
		}
	}); 
}

</script>
</html>
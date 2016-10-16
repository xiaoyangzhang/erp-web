<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团列表</title>
<%@ include file="../../../include/top.jsp"%>
</head>
<script type="text/javascript">
function getCode(){
	return $("input[name='items']:checked").val();
}

</script>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form action="getInsertFitGroupList.htm" method="post"
					id="toInsertFitGroupListForm">
					<input type="hidden" name="page" id="groupPage" value="${tourGroup.page}"> 
					<input type="hidden" name="pageSize" id="groupPageSize" value="${tourGroup.pageSize}">
					<input type="hidden" name="groupMode" value="${tourGroup.groupMode}">	
					<dd class="inl-bl">
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input name="startTime" type="text" id="startTime" value='<fmt:formatDate value="${tourGroup.startTime }" pattern="yyyy-MM-dd"/>' class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							~
							<input name="endTime" id="endTime" value='<fmt:formatDate value="${tourGroup.endTime}" pattern="yyyy-MM-dd"/>' type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input name="groupCode" type="text" value="${tourGroup.groupCode}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productName" type="text" value="${tourGroup.productName}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>	
				</form>
				</dl>
			<dl class="p_paragraph_content">
			<table cellspacing="0" cellpadding="0" class="w_table">
				<thead>
					<tr>
						<th style="width:3%"></th>
						<th style="width:10%">序号<i class="w_table_split"></i></th>
						<th style="width:15%">团号<i class="w_table_split"></i></th>
						<th style="width:10%">发团<i class="w_table_split"></i></th>
						<th style="width:10%">散团<i class="w_table_split"></i></th>
						<th style="width:27%">产品线路<i class="w_table_split"></i></th>
						<th style="width:10%">计调<i class="w_table_split"></i></th>
						<th style="width:10%">人数<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.result}" var="tourGroup" varStatus="index">
						<tr>
							<td><input type="radio"   value="${tourGroup.groupCode}" name="items" onclick="getCode()"></td>
							<td>${index.count}</td>
							<td style="text-align:left"><a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath %>/groupOrder/toFitEdit.htm?groupId=${tourGroup.id}&operType=0')">${tourGroup.groupCode}</a></td>
							<td><fmt:formatDate value="${tourGroup.dateStart}" pattern="MM-dd" /></td>
							<td><fmt:formatDate value="${tourGroup.dateEnd}" pattern="MM-dd" /></td>
							<td style="text-align:left">【${tourGroup.productBrandName}】${tourGroup.productName}</td>
							<td>${tourGroup.operatorName}</td>
							<td>${tourGroup.totalAdult}大${tourGroup.totalChild }小</td>
					</c:forEach>
				</tbody>
			</table>
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${page.page }" name="p" />
				<jsp:param value="${page.totalPage }" name="tp" />
				<jsp:param value="${page.pageSize }" name="ps" />
				<jsp:param value="${page.totalCount }" name="tn" />
			</jsp:include>
			</dl>
		</div>
	</div>
	<script type="text/javascript">
	function searchBtn() {
		var pageSize=$("#groupPageSize").val();
		queryList(1,pageSize);
	}
	
	function queryList(page,pageSize) {
				if (!page || page < 1) {
					page = 1;
				}
				$("#groupPage").val(page);
				$("#groupPageSize").val(pageSize);
				$("#toInsertFitGroupListForm").submit();
			}
	</script>
	
</body>
</html>
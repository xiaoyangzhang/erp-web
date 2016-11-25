<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%  String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>机票资源列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
  	<script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
    <style>
		.searchRow li.text {margin-right:3px;}
		.searchRow li.seperator{width:20px;}
		 .searchRow li input{width:90px;}
	 </style>
 <script>
function refreshPage(){
	var vars = $.getUrlVars();
	window.location.href = "${thisPage}" + $.makeUrlFromVars(vars);
}
 function queryList(p, ps){ // pagination: p=page number; ps= page size
	var vars = $.getUrlVars();
 	vars["p"] = p;
 	vars["ps"] = ps;
 	window.location.href = "${thisPage}" + $.makeUrlFromVars(vars);
 }
 function searchBtn(){
	 var vars = [];
	 var resource_number = $("input[name='resource_number']").val();
	 var date_from = $("input[name='date_from']").val();
	 var date_to = $("input[name='date_to']").val();
	 var endIssueDateFrom = $("input[name='endIssueDateFrom']").val();
	 var endIssueDateTo = $("input[name='endIssueDateTo']").val();
	 var dep_city = $("input[name='dep_city']").val();
	 var line_name = $("input[name='line_name']").val();
	 var airCode = $("input[name='airCode']").val();
	 var type = $("select[name='type']").val();
	 if (resource_number){vars["resource_number"]=resource_number;}
	 // 三种选择：dep_date_from, start_date_from,  end_issue_date_from
	 if (date_from){
		 vars["date_type"]=$("#filterDateType").val();
		 vars["date_from"]=date_from;
	 }
	 if (date_to){
		 vars["date_type"]=$("#filterDateType").val();
		 vars["date_to"]=date_to;
	 }
	 if (endIssueDateFrom){vars["endIssueDateFrom"]=endIssueDateFrom;}
	 if (endIssueDateTo){vars["endIssueDateTo"]=endIssueDateTo;}
	 if (dep_city){vars["dep_city"]=dep_city;}
	 if (line_name){vars["line_name"]=line_name;}
	 if (airCode){vars["airCode"]=airCode;}
	 if (type){vars['type']=type;}
	 window.location.href = "${thisPage}" + $.makeUrlFromVars(vars);
 }
 function deleteResource(id){
	 if (!confirm("确认删除此条机票资源么？")){
		 return false;
	 }
 	 YM.post("delete.do",{"id":id}, function(){
		 $.success("删除成功");
		 window.setTimeout(function(){
			 refreshPage();
		 }, 1000);
	 });
 }
 $(function(){
	 $("#filterDateType").val("${page.parameter.dateType }");
	 //出发城市
	 $("input[name=line_name]").val("${page.parameter.lineName}");
	 $("select[name='type']").val("${page.parameter.type}");
	 //$("input[name=dep_city]").autocomplete(cityComplete);
	 $("input[name='line_name']").autocomplete(lineTemplateComplete);
	 $("input[name='line_name']").click(function(){$(this).trigger(eKeyDown);});
	 fixHeader();
 });
 </script>
</head>
<body>
  <div class="p_container" >
  <!-- 过滤栏   START -->
    <div class="p_container_sub" >
	<div class="searchRow">
		<form id="searchResourceForm">
			<ul>
				<li style="width:110px;">
					<select id="filterDateType" style="width:105px;"><option value="start">行程开始日期:</option>
					<option value="dep">航班日期:</option></select></li>
				<li><input name="date_from" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.depDateFrom }"/>—
					<input name="date_to" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.depDateTo }"/>
				</li><li class="seperator"></li>
				<li class="text">采购单号：</li>
				<li><input name="resource_number" type="text" value="${page.parameter.resourceNumber }"/></li>
				<li class="seperator">
				<li class="text">航线名称：</li>
				<li><input name="line_name" type="text" class="filterAutoComplete" value=""/></li><li class="seperator">
				<li class="text">出发地：</li>
				<li><input name="dep_city" type="text" value="${page.parameter.depCity }"/></li><li class="seperator">
				<li class="text" style="width:100px;">最晚出票日期：</li>
				<li><input name="endIssueDateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateFrom }"/>—
					<input name="endIssueDateTo" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateTo }"/><li class="seperator">
				<li class="text">航班号：</li>
				<li><input name="airCode" type="text" value="${page.parameter.airCode }"/></li>
				<li class="text" style="width:100px;">资源类型：</li>
				<li><select name="type"><option value="">全部</option><option value="AIR">机票</option><option value="TRAIN">火车票</option></select><li class="seperator">

				<li style="margin-left:20px;">
					<a href="javascript:searchBtn();" class="button button-primary button-small">查询</a>
					<c:if test="${!queryOnly}">
					<a onclick="newWindow('新增机票资源', '<%=path%>/airticket/resource/add.htm')"
				   		class="button button-green button-small">新增</a>
					<!-- <a onclick="importExcel()"
				   		class="button button-green button-small">导入</a> -->
					<a onclick="newWindow('导入机票资源', '<%=path%>/airticket/resource/batchAdd.htm')"
				   		class="button button-green button-small">导入</a>
				   	</c:if>
				</li>
				<li class="clear"></li>
			</ul>
		</form>
	</div>
  	</div><!-- 过滤栏  END  -->

<!-- 列表 START -->
<div id="resourceDiv">  
<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:980px;" > 
		             <thead>
		             	<tr>
		             		<th width="80">采购单号<i class="w_table_split"></i></th>
		             		<th width="90">行程开始日期<i class="w_table_split"></i></th>
		             		<th width="150">航线<i class="w_table_split"></i></th>
		             		<th width="90">航班日期<i class="w_table_split"></i></th>
		             		<th width="60">航班号<i class="w_table_split"></i></th>
		             		<th width="100">出发到达<i class="w_table_split"></i></th>
		             		<th width="100">航班时刻<i class="w_table_split"></i></th>
		             		<th width="70">票数<i class="w_table_split"></i></th>
		             		<th width="70">已申请<i class="w_table_split"></i></th>
		             		<th width="70">剩余<i class="w_table_split"></i></th>
		             		<th width="70">单价<i class="w_table_split"></i></th>
		             		<th width="80">最晚出票<i class="w_table_split"></i></th>
		             		<th width="80">备注<i class="w_table_split"></i></th>
		             		<th width="150">操作</th>
		             	</tr>
		             </thead>
		             <tbody>
		             <c:forEach items="${result}" var="resourceInfo" varStatus="status">
			               <tr id="${resourceInfo.id }"> 
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.resourceNumber }</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.startDate }</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.po.lineName }</td>
			                  	<td><fmt:formatDate value="${resourceInfo.legList[0].depDate}" pattern="yyyy-MM-dd" /></td>
			                  	<td>${resourceInfo.legList[0].airCode}</td>
			                  	<td>${resourceInfo.legList[0].depCity}-${resourceInfo.legList[0].arrCity}</td>
			                  	<td><fmt:formatDate value="${resourceInfo.legList[0].depTime}" pattern="HH:mm"/>-<fmt:formatDate value="${resourceInfo.legList[0].arrTime}" pattern="HH:mm"/></td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.po.totalNumber}</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.po.appliedNumber }</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.po.availableNumber }</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.price }</td>
			                  <td rowspan="${resourceInfo.legSize}">${resourceInfo.endIssueTime}</td>
			                  <td rowspan="${resourceInfo.legSize}"><pre>${resourceInfo.comment}</pre></td>
			                  <td rowspan="${resourceInfo.legSize}">
			                    <a class="button button-rounded button-tinier" 
			                        href="javascript:newWindow('机票资源${resourceInfo.resourceNumber }','<%=path%>/airticket/request/ticketList.htm?id=${resourceInfo.id }')">查看</a>
			                    <c:if test="${!queryOnly}">
			                    <a class="button button-rounded button-tinier" 
			                    	href="javascript:newWindow('编辑机票资源${resourceInfo.resourceNumber }', '<%=path%>/airticket/resource/edit.htm?id=${resourceInfo.id }')">编辑</a> 
			                  	<a class="button button-rounded button-tinier" href="javascript:deleteResource(${resourceInfo.id })">删除</a>
			                  	</c:if>
			                  </td>
			               </tr>
							<c:forEach items="${resourceInfo.legList}" var="leg" varStatus="li"><c:if test="${li.index>0}">
							<tr><td><fmt:formatDate value="${resourceInfo.legList[li.index].depDate}" pattern="yyyy-MM-dd" /></td>
			                  	<td>${resourceInfo.legList[li.index].airCode}</td>
			                  	<td>${resourceInfo.legList[li.index].depCity}-${resourceInfo.legList[li.index].arrCity}</td>
			                  	<td><fmt:formatDate value="${resourceInfo.legList[li.index].depTime}" pattern="HH:mm"/>-<fmt:formatDate value="${resourceInfo.legList[li.index].arrTime}" pattern="HH:mm"/></td></tr>
							</c:if></c:forEach>
		              </c:forEach>
		              <tr><td colspan="7" style="text-align:right;">合计:</td><td>${count.total}</td><td>${count.applied}</td><td>${count.total-count.applied}</td>
		              	<td colspan="4"></td>
		              </tr>
		             </tbody>
	          		</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
</div>  
<!-- 列表 END -->
  
  </div>
  <div id="importDiv" style="display:none;">
  	<input type="file" class="IptText60" id="filePath">浏览
  </div>
</body>
</html>
  
  
  


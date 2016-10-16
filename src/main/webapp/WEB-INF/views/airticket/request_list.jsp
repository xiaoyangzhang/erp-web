<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%	String path = request.getContextPath();%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>机票申请列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    <script src="<%=staticPath %>/assets/js/web-js/sales/airTicketResource.js"></script>
    <script src="<%=staticPath %>/assets/js/jquery-ui/jquery.tooltip.js"></script>
     <style>
		 .searchRow .text { }
		 .searchRow .seperator{width:20px;}
		 .searchRow input{width:90px;}
		 .w_table tbody tr td{padding:3px 1px 3px 1px;}
		 .air_ticket_leg {width:100%; min-width:248px;}
		 .air_ticket_leg td {padding:0 3px 0 3px;}
		 .opLog {background:#DCDCDC; color:black; text-decoration:none;}
	 </style>
<script>
function refreshPage(){
	var vars = $.getUrlVars();
	window.location.href = "${arrange}list.htm" + $.makeUrlFromVars(vars);
}
function queryList(p, ps){
	var vars = $.getUrlVars();
 	vars["p"] = p;
 	vars["ps"] = ps;
 	window.location.href = "${arrange}list.htm" + $.makeUrlFromVars(vars);
}
function searchBtn(){
	var vars = [];
	var dateFrom = $("input[name='dateFrom']").val();
	var dateTo = $("input[name='dateTo']").val();
	var orderNo = $("input[name='orderNo']").val();
	var productName = $("input[name='productName']").val();
	var lineName = $("input[name='lineName']").val();
	var contactName = $("input[name='contactName']").val();
	var receiveMode = $("input[name='receiveMode']").val();
	var depCity = $("input[name='depCity']").val();
	var issueStatus = $("select[name='issueStatus']").val();
	var endIssueDateFrom = $("input[name='endIssueDateFrom']").val();
	var endIssueDateTo = $("input[name='endIssueDateTo']").val();
	var type = $("select[name='type']").val();
	if (dateFrom){vars["dateFrom"]=dateFrom;}
	if (dateTo){vars["dateTo"]=dateTo;}
	if (dateFrom || dateTo){vars['dateType']=$("select[name='dateType']").val();}
	if (orderNo){vars["orderNo"]=orderNo;}
	if (productName){vars["productName"]=productName;}
	if (lineName){vars["lineName"]=lineName;}
	if (contactName){vars["contactName"]=contactName;}
	if (receiveMode){vars["receiveMode"]=receiveMode;}
	if (depCity){vars['depCity']=depCity;}
	if (issueStatus){vars['issueStatus']=issueStatus;}
	if (endIssueDateFrom){vars['endIssueDateFrom']=endIssueDateFrom;}
	if (endIssueDateTo){vars['endIssueDateTo']=endIssueDateTo;}
	if (type){vars['type']=type;}
	window.location.href = "${arrange}list.htm" + $.makeUrlFromVars(vars);
}
function doAction(action, id){
	layer.open({
		type : 1,
		title : '确认执行',
		closeBtn : false,
		area : [ '400px', '190px' ],
		shadeClose : false,
		content : $('#action_confirm'),
		btn : [ '确认', '取消' ],
		yes : function(index) {
			comment=$("#action_confirm textarea[name='comment']").val();
			layer.close(index);
			
			YM.post(action,{"id":id, "comment":comment}, function(){
				$.success("执行成功");
				window.setTimeout(function(){
				  refreshPage();
				}, 1000);
			});
		},
		cancel : function(index) {
			layer.close(index);
		}
	});
}

function toEdit(id, groupCode){
	newWindow("机票申请"+groupCode, "<%=path%>/airticket/request/edit.htm?id="+id);
}
function toConfirm(id, groupCode){
	newWindow("核对机票申请"+groupCode, "<%=path%>/airticket/request/view.htm?confirm=1&id="+id);
}
function toPickUp(id, groupCode){
	newWindow("接送机安排"+groupCode, "<%=path%>/airticket/request/pickUpGuest.htm?id="+id);
}
$(function(){
	 $("input[name='lineName']").val("${page.parameter.lineName}");
	 $("input[name='lineName']").click(function(){$(this).trigger(eKeyDown);});
	 $("input[name='lineName']").autocomplete(lineTemplateComplete);
	 $("select[name='dateType']").val("${page.parameter.dateType}");
	 $("select[name='issueStatus']").val("${page.parameter.issueStatus}");
	 $(".opLog").tooltip();
	 fixHeader();
})
</script>
</head>
<body>
<div id="action_confirm" style="display:none; padding:5px 5px 5px 5px;">
<p style="line-height:20px;">添加说明：（选填）</p>
<textarea name="comment" rows="5" cols="60"></textarea>
</div>
  <div class="p_container"  style="min-width:1000px;" >
  
  <!-- 过滤栏   START -->
    <div class="p_container_sub" >
	<div class="searchRow">
		<form id="searchRequestForm" class="searchRow">
		<dl>
			<dd class="inl-bl">
			<div class="dd_left" style="width:110px;"><select name="dateType" style="width:105px;"><option value="start">行程开始日期</option>
				<option value="order">订单出发日期</option><option value="dep">航班日期</option></select></div>
			<div class="dd_right">
				<input name="dateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${page.parameter.dateFrom }"/>
				—<input name="dateTo" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${page.parameter.dateTo }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">订单号：</div>
			<div class="dd_right"><input name="orderNo" type="text" value="${page.parameter.orderNo }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">产品：</div>
			<div class="dd_right"><input name="productName" type="text" value="${page.parameter.productName }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">航线：</div>
			<div class="dd_right"><input class="filterAutoComplete" name="lineName" type="text" value=""/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">出发地：</div>
			<div class="dd_right"><input name="depCity" type="text" value="${page.parameter.depCity }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">接站牌：</div>
			<div class="dd_right"><input name="receiveMode" type="text" value="${page.parameter.receiveMode }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">出票状态：</div>
			<div class="dd_right"><select name="issueStatus"><!-- <option></option><option value="N">未出票</option><option value="Y">已出票</option> -->
				<option></option><option value="ARRANGING">待安排</option>
				<option value="CONFIRMING">待确认</option>
				<option value="REJECTED">退回</option>
				<option value="ISSUING">待出票</option>
				<option value="ISSUED">已出票</option>
			</select></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			
			<div class="dd_left">最晚出票日期：</div>
			<div class="dd_right">
			<input name="endIssueDateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateFrom }"/>—
					<input name="endIssueDateTo" type="text"  class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
					value="${page.parameter.endIssueDateTo }"/>
			</div>
			<div class="dd_left">资源类型：</div>
			<div class="dd_right">	
				<select name="type">
					<option value="">全部</option>
					<c:if test="${empty reqpm.type}">
						<option value="AIR">机票</option>
						<option value="TRAIN">火车票</option>	
					</c:if>
					
					<c:if test="${reqpm.type eq 'AIR'}">
						<option value="AIR" selected="selected">机票</option>
						<option value="TRAIN">火车票</option>
					</c:if>
					
					<c:if test="${reqpm.type eq 'TRAIN'}">
						<option value="AIR" >机票</option>
						<option value="TRAIN" selected="selected">火车票</option>
					</c:if>
				</select>
			</div>

			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_right" style="margin-left:10px;"><a href="javascript:searchBtn();" class="button button-primary button-small">查询</a>
				<c:if test="${isArrange==false}">
				<a href="javascript:newWindow('新增机票申请', '<%=path%>/airticket/request/add.htm')" 
					class="button button-green button-small">新增</a>
				</c:if>
			</div></dd>
		</dl>
		</form>
	</div>
  	</div><!-- 过滤栏  END  -->

<!-- 列表 START -->
<div id="resourceDiv">  
<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:600px;" > 
        <thead>
        	<tr>
        		<!-- <th width="80">订单号<i class="w_table_split"></i></th> -->
        		<th width="80">订单出发日期<i class="w_table_split"></i></th>
        		<th width="150">产品名称<i class="w_table_split"></i></th>
        		<th width="80">组团社<i class="w_table_split"></i></th>
        		<th width="80">接站牌<i class="w_table_split"></i></th>
        		<th width="80">行程开始日期<i class="w_table_split"></i></th>
        		<th width="80">航线<i class="w_table_split"></i></th>
        		<th width="90">航班日期<i class="w_table_split"></i></th>
		        <th width="60">航班号<i class="w_table_split"></i></th>
		        <th width="100">出发到达<i class="w_table_split"></i></th>
		        <th width="100">航班时刻<i class="w_table_split"></i></th>
        		<th width="45">总票数<i class="w_table_split"></i></th>
        		<th width="45">申请票数<i class="w_table_split"></i></th>
        		<th width="45">剩余<i class="w_table_split"></i></th>
        		<th width="80">最晚出票时间<i class="w_table_split"></i></th>
        		<th width="60">销售<i class="w_table_split"></i></th>
        		<th width="80">操作记录<i class="w_table_split"></i></th>
        		<th width="60">操作备注<i class="w_table_split"></i></th>
        		<th width="80">当前状态<i class="w_table_split"></i></th>
        		<th width="100">操作</th>
        	</tr>
        </thead>
        <tbody>
        <c:forEach items="${resultBo }" var="bo" varStatus="status">
           <tr id="${bo.id }">
          <%--  <td>${bo.groupOrder.orderNo }</td> --%>
           <td rowspan="${bo.resourceBo.legSize}">${bo.groupOrder.departureDate }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.product }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.supplier }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.groupOrder.receiveMode }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.resourceBo.startDate }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.resourceBo.po.lineName }</td>
           <td><fmt:formatDate value="${bo.resourceBo.legList[0].depDate }" pattern="yyyy-MM-dd"/></td>
           <td>${bo.resourceBo.legList[0].airCode }</td>
           <td>${bo.resourceBo.legList[0].depCity}-${bo.resourceBo.legList[0].arrCity}</td>
           <td><fmt:formatDate value="${bo.resourceBo.legList[0].depTime}" pattern="HH:mm"/>-<fmt:formatDate value="${bo.resourceBo.legList[0].arrTime}" pattern="HH:mm"/></td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.resourceBo.po.totalNumber }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.guestNumber }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.resourceBo.po.availableNumber }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.resourceBo.endIssueTime }</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.groupOrder.saleOperatorName}</td>
           <td rowspan="${bo.resourceBo.legSize}"><a class='opLog' href="javascript:void(0);" title="${bo.comment}">${bo.operatorName }<br/>${bo.updateTime}</a></td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.po.remark}</td>
           <td rowspan="${bo.resourceBo.legSize}">${bo.status }</td>
           <td rowspan="${bo.resourceBo.legSize}"><a class="button button-tinier" href="javascript:newWindow('查看机票申请${bo.groupOrder.orderNo }', '<%=path%>/airticket/request/${arrange }view.htm?id=${bo.id }')">查看明细</a>
           ${bo.operations }</td>
           </tr>
           <c:forEach items="${bo.resourceBo.legList}" var="leg" varStatus="li"><c:if test="${li.index>0}">
			<tr><td><fmt:formatDate value="${leg.depDate}" pattern="yyyy-MM-dd" /></td>
                 	<td>${leg.airCode}</td>
                 	<td>${leg.depCity}-${leg.arrCity}</td>
                 	<td><fmt:formatDate value="${leg.depTime}" pattern="HH:mm"/>-<fmt:formatDate value="${leg.arrTime}" pattern="HH:mm"/></td></tr>
			</c:if></c:forEach>
         </c:forEach>
         <tr><td colspan="10" style="text-align:right;">合计：</td><td>${count.total}</td><td>${count.applied}</td><td>${count.available}</td><td colspan="6"></td></tr>
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
</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%  String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>单团利润统计表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
  	<script type="text/javascript" src="<%=staticPath %>/assets/js/largetab.js"></script>
    <style>
		 .searchRow input{width:90px;}
		 
		 table .order-lb1{display:inline-block;width:210px;text-align:left;}
		 table .order-lb2{display:inline-block;width:40px;}
		 table .order-lb3{display:inline-block;width:40px;}
		 table .order-lb4{display:inline-block;width:60px;}
		 table .order-lb5{display:inline-block;width:30px;}
	 </style>
 <script>
 function queryList(p, ps){ // pagination: p=page number; ps= page size 由分页组件 [go]调用
	var vars = $.getUrlVars();
 	vars["p"] = p;
 	vars["ps"] = ps;
 	
 	window.location.href = "list.htm" + $.makeUrlFromVars(vars);
 }
 function searchBtn(){
	var vars = [];
	var dateFrom = $("input[name='dateFrom']").val();
	if(!dateFrom){
		dateFrom = "-1";
	}
	var dateTo = $("input[name='dateTo']").val();
	if(!dateTo){
		dateTo = "-1";
	}
	var groupCode = $("input[name='groupCode']").val();
	var orderSupplier = $("input[name='orderSupplier']").val();
	var operatorId = $("input[name='operatorId']").val();
	var groupMode = $("select[name='groupMode']").val();
	var groupState = $("select[name='groupState']").val();
	var productName = $("input[name='productName']").val();
	var orgIds = $("input[name='orgIds']").val();
	var orgNames = $("input[name='orgNames']").val();
	var saleOperatorIds = $("input[name='saleOperatorIds']").val();
	var saleOperatorName = $("input[name='saleOperatorName']").val();
	var saleType = $("select[name='saleType']").val();
	
	if (dateFrom){vars["dateFrom"]=dateFrom;}
	if (dateTo){vars["dateTo"]=dateTo;}
	if (groupCode){vars["groupCode"]=groupCode;}
	if (orderSupplier){vars["orderSupplier"]=orderSupplier;}
	if (operatorId){vars["operatorId"]=operatorId;}
	if (groupMode!==""){vars["groupMode"]=groupMode;}
	if (groupState!==""){vars["groupState"]=groupState;}
	if (productName){vars["productName"]=productName;}
	if (orgIds){vars["orgIds"]=orgIds;}
	if (orgNames){vars["orgNames"]=orgNames;}
	if (saleOperatorIds){vars["saleOperatorIds"]=saleOperatorIds;}
	if (saleOperatorName){vars["saleOperatorName"]=saleOperatorName;}
	if (saleType){vars["saleType"]=saleType;}
	
	vars["p"] = 1;
	if (!vars["ps"]) vars["ps"] = 15;
	var urlVars = $.getUrlVars();
	
	if (urlVars["ps"]){vars["ps"]=urlVars["ps"];}
	
	window.location.href = "list.htm" + $.makeUrlFromVars(vars);
}
$(function(){
	$("select[name='groupMode']").val("${page.parameter.groupMode}");
	$("select[name='groupState']").val("${page.parameter.groupState}");
	$("select[name='saleType']").val("${page.parameter.saleType}");
	
	$("#saleType").change(function(){
		var s = $(this).children('option:selected').val();
		if(s == 1){
			$("#groupMode").val("");
		}
		if(s == 0){
			$("#groupMode").val(1);
		}
	})
});
function archive(type){
	if (type=='All'){
		if (!confirm("确定要执行全归档？这要花几分钟的时间")){return;}
		var openUrl = "<%=path%>/tjGroup/archiveAllGroupProfit.do";//弹出窗口的url
	}else {
		var openUrl = "<%=path%>/tjGroup/archiveIncrementalGroupProfit.do";//弹出窗口的url
	}
	var iWidth=400; //弹出窗口的宽度;
	var iHeight=200; //弹出窗口的高度;
	var iTop = (window.screen.availHeight-30-iHeight)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-iWidth)/2; //获得窗口的水平位置;
	window.open (openUrl,'归档','height='+ iHeight +',width='+ iWidth +',top='+ iTop +',left='+ iLeft +',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}
function goToGroupStatistics(groupId, groupCode){
	newWindow('团信息'+groupCode, '<%=path%>/finance/auditGroupListPrint.htm?groupId='+groupId+'&isShow=true');
}

 </script>
</head>
<body>
  <div class="p_container" >
  <!-- 过滤栏   START -->
    <div class="p_container_sub" >
	<div class="searchRow">
		<form id="searchRequestForm" class="searchRow">
		<dl>
			<dd class="inl-bl">
			<div class="dd_left" style="width:60px;">出团日期</div>
			<div class="dd_right">
				<input name="dateFrom" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${page.parameter.dateFrom }"/>
				—<input name="dateTo" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${page.parameter.dateTo }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">团号：</div>
			<div class="dd_right"><input name="groupCode" type="text" value="${page.parameter.groupCode }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">组团社：</div>
			<div class="dd_right"><input name="orderSupplier" type="text" value="${page.parameter.orderSupplier }"/></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
    			<div class="dd_right">
    				部门:
    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${page.parameter.orgNames }" readonly="readonly"  onclick="showOrg()"/>
					<input name="orgIds" id="orgIds" stag="orgIds"  type="hidden" value="${page.parameter.orgIds }"/>	    				
    			</div>
    			<div class="dd_right">
    				<select id="saleType" name="saleType">
	    					<option value="1">计调：</option>
	    					<option value="0">销售：</option>
	    				</select>
    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="${page.parameter.saleOperatorName }" readonly="readonly" onclick="showUser()"/>
					<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${page.parameter.saleOperatorIds }"/>	    				
    			</div>
    		</dd>
			<dd class="inl-bl">
			<div class="dd_left">类型：</div>
			<div class="dd_right"><select name="groupMode" id="groupMode"><option value="">全部</option><option value='0'>散客</option><option value="1">团队</option></select></div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">状态：</div>
			<div class="dd_right">
				<select name="groupState">
					<option value="">全部</option>
					<option value='0'>未审核</option>
					<option value="1">已审核</option>
				</select>
			</div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_left">产品：</div>
			<div class="dd_right">
			<input name="productName" type="text" value="${page.parameter.productName }"/>
			</div>
			<div class="clear"></div></dd>
			<dd class="inl-bl">
			<div class="dd_right" style="margin-left:10px;">
				<a href="javascript:searchBtn();" class="button button-primary button-small">查询</a>
				<a href="javascript:print();" class="button button-primary button-small">打印</a>
				<!-- <a href="javascript:archive('All');" class="button button-primary button-small button-green">全归档</a> -->
				<a href="javascript:archive('Incremental');" class="button button-primary button-small button-green">归档</a>
			</div></dd>
		</dl>
		<dl class="p_paragraph_content" style="margin-top:0px;margin-bottom:0px;text-align:right;">
    		<dd>最新归档时间：${recordEndTime }</dd>
    	</dl>
		</form>
	</div>
  	</div><!-- 过滤栏  END  -->

<!-- 列表 START -->
 <div class="pl-10 pr-10" >  
<table cellspacing="0" cellpadding="0" class="w_table LgTable" style="width:3350px;">
<thead>
	<tr>
		<th width="50" rowspan="2">序号</th>
		<th colspan="7">团信息</th>
		<th colspan="3">收入</th>
		<th colspan="9">支出</th>
		<th colspan="4">合计</th>
	</tr>
	<tr>
		<th style="width:50px;">团号</th>
		<th style="width:100px;">团期</th>
		<th style="width:150px;">人数</th>
		<th style="width:400px;">产品线路</th>
		<th style="width:430px;">组团社</th>
		<th style="width:200px;">地接社</th>
		<th style="width:100px;">计调</th>
		<th style="width:120px;">团费</th>
		<th style="width:120px;">其他收入</th>
		<th style="width:120px;">购物收入</th>
		<th style="width:120px;">地接</th>
		<th style="width:120px;">房费</th>
		<th style="width:120px;">餐费</th>
		<th style="width:120px;">车费</th>
		<th style="width:120px;">门票</th>
		<th style="width:120px;">机票</th>
		<th style="width:120px;">火车票</th>
		<th style="width:120px;">保险</th>
		<th style="width:120px;">其他支出</th>
		<th style="width:120px;">总收入</th>
		<th style="width:120px;">总成本</th>
		<th style="width:120px;">毛利</th>
		<th style="width:120px;">人均毛利</th>
	</tr>
</thead>
<tbody>
<c:forEach items="${page.result }" var="tj" varStatus="status">
<tr>
	<td>${status.index+1}</td>
	<td><a href="javascript:goToGroupStatistics(${tj.groupId},'${tj.groupCode}');">${tj.groupCode }</a></td>
	<td><fmt:formatDate value="${tj.dateStart }" pattern="MM-dd"/>/<fmt:formatDate value="${tj.dateEnd }" pattern="MM-dd"/></td>
	<td>${tj.totalAdult}大${tj.totalChild}小${tj.totalGuide}陪</td>
	<td>【${tj.productBrandName}】${tj.productName}</td>
	<td style="text-align:left;">${tj.orderDetails }</td>
	<td>${tj.deliveryNames }</td>
	<td>${tj.operatorName }</td>
	<td><fmt:formatNumber value="${tj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.totalProfit}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${tj.profitPerGuest}" pattern="#.##" type="currency"/></td>
</tr>
</c:forEach>
<tr>
	<td colspan="3">本页合计：</td>
	<td colspan="5" style="text-align:left">${pageTotalTj.totalAdult}大${pageTotalTj.totalChild}小${pageTotalTj.totalGuide}陪</td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${pageTotalTj.totalProfit}" pattern="#.##" type="currency"/></td>
	<%-- <td><fmt:formatNumber value="${pageTotalTj.profitPerGuest}" pattern="#.##" type="currency"/></td> --%>
	<td>
	<c:set var="totalPerson"   value="${pageTotalTj.totalAdult+pageTotalTj.totalChild+pageTotalTj.totalGuide}"/>
	<c:if test="${totalPerson > 0}">
	<fmt:formatNumber value="${pageTotalTj.totalProfit /totalPerson}" pattern="#.##" type="currency"/>
	</c:if>

	</td>
</tr>

<tr>
	<td colspan="3">合计：</td>
	<td colspan="5" style="text-align:left">${totalTj.totalAdult}大${totalTj.totalChild}小${totalTj.totalGuide}陪</td>
	<td><fmt:formatNumber value="${totalTj.incomeOrder}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.incomeOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.incomeShop}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseTravelagency}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseHotel}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseRestaurant}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseFleet}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseScenicspot}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseAirticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseTrainticket}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseInsurance}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.expenseOther}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalIncome}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalExpense}" pattern="#.##" type="currency"/></td>
	<td><fmt:formatNumber value="${totalTj.totalProfit}" pattern="#.##" type="currency"/></td>
	<%-- <td><fmt:formatNumber value="${totalTj.profitPerGuest}" pattern="#.##" type="currency"/></td> --%>
	<td>
	<c:set var="tPerson"   value="${totalTj.totalAdult+totalTj.totalChild+totalTj.totalGuide}"/>
	<c:if test="${tPerson > 0 }">
	<fmt:formatNumber value="${totalTj.totalProfit / tPerson}" pattern="#.##" type="currency"/>
	</c:if>
	
	</td>
</tr>
</tbody>
</table>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</div> 
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }"  name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>
<!-- 列表 END -->
  
  </div>
  <div id="importDiv" style="display:none;">
  	<input type="file" class="IptText60" id="filePath">浏览
  </div>
</body>
<script type="text/javascript">
	/*$(function(){
		var docHeight = $(window).height()-240;		
		var minHeight=498;
		var tHeight=docHeight+"px";
		if(docHeight>minHeight){
			tHeight=minHeight+"px";
		}
		$("table.w_table").freezeHeader({ highlightrow: true,'height': tHeight });		
	})*/
	$(function(){
		var $tabw = $(".LgTable").width();
		if($tabw <= $(".p_container_sub").width()){
			$(".LgTable").removeClass("LgTable").css("width","100%");
		}else{
			var dh = $(window).height()-$(".w_table").offset().top-70;
			FixTable("LgTable", 1, "auto", dh);
		}
	})

</script>
<script type="text/javascript">

function print(){
	window.open ("<%=staticPath%>/tjGroup/toGroupProfitPrint.htm?"+ $("#searchRequestForm").serialize());
}

</script>
</html>
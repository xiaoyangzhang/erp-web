<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%  String path = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>单团利润统计</title>
	<%@ include file="../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style media="print" type="text/css">
			.print{display: none;}
	</style>
	<style type="text/css">
		.print{position: relative;top: 0; height: 35px;overflow: hidden; background: #E7EFF1;}
		.print-btngroup{margin-top: 5px;text-align: center;}
		.print-btngroup a{display: inline-block; width: 80px;height: 25px;border: 1px solid #E7EFF1;border-radius: 4px;background: #68CEE7; line-height: 25px;color: #FFFFFF;}	    	
		.print-btngroup a:hover{background: #75D2E8;}
		.print-btngroup a:active{background: #5DB4CA;}
		.print-word{padding: 30px;}	    	
		.print-logo{overflow: hidden;}
		.print-logo img{width: 40px;}
		.print-logo .gc-name{margin-left: 45px;font-size: 22px;font-weight: 700;color: #333;}
		.print-logo .gc-msg{margin-left: 45px;color: #666;}
		.print-word .print-name{text-align: center;color: #333;font-size: 20px;font-weight: 700;}	    	
		.print-gmsg .w_table tr td:nth-child(odd){background: #F5F5F5;}
		.print-gmsg .w_table tr td:nth-child(even){background: #FFF;}
		.print-other{background: #ddd;}
		
		table .order-lb1{display:inline-block;width:220px;text-align:left;}
		table .order-lb2{display:inline-block;width:50px;}
		table .order-lb3{display:inline-block;width:50px;}
		table .order-lb4{display:inline-block;width:50px;}
	</style>
</head>
<body>
	<div class="print">
		<div class="print-btngroup">
    		<a href="javascript:void(0);" id="export" onclick="exportExcel()">导出Excel</a>
    		<a href="javascript:void(0);" onclick="window.close();">关闭页面</a>
    	</div>
	</div>
	<div class="print-word">
		<div align="center">
				<img src="${imgPath}"/>
			</div>
		<form id="queryForm">
			<input name="dateStart_Search" type="hidden" value="${reqpm.dateStart_Search }"/>
			<input name="dateEnd_Search" type="hidden" value="${reqpm.dateEnd_Search }"/>
			<input name="groupCode" type="hidden" value="${reqpm.groupCode }"/>
			<input name="receiveMode" type="hidden" value="${reqpm.receiveMode }"/>
			<input name="productName" type="hidden" value="${reqpm.productName }"/>
			<input name="orgNames" type="hidden" value="${reqpm.orgNames }"/>
			<input name="state" type="hidden" value="${reqpm.state }"/>
			<input name="saleOperatorName" type="hidden" value="${reqpm.saleOperatorName }"/>
			<input name="saleOperatorIds" type="hidden" value="${reqpm.saleOperatorIds }"/>
			<input name="groupMode" type="hidden" value="${reqpm.groupMode }"/>
			<input name="groupStatus" type="hidden" value="${reqpm.groupStatus }"/>
	  	</form>
		
		<p class="print-name mt-20">单团利润统计表</p>  	
	  	<div class="print-tab mt-20" style="overflow-x:scroll;">
	  		<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:3350px;" > 
				<thead>
					<tr>
						<th width="50" rowspan="2">序号<i class="w_table_split"></i></th>
						<th colspan="7">团信息</th>
						<th colspan="3">收入</th>
						<th colspan="9">支出</th>
						<th colspan="4">合计</th>
					</tr>
					<tr>
						<th style="width:120px;">团号</th>
						<th style="width:100px;">团期</th>
						<th style="width:100px;">人数</th>
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
					<td>${tj.groupCode }</td>
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
					<td colspan="3">合计：</td>
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
					<td><fmt:formatNumber value="${pageTotalTj.profitPerGuest}" pattern="#.##" type="currency"/></td>
				</tr>
				</tbody>
			</table>
	  	</div>
	  	<p class="mt-10">${printMsg }</p>
	</div>
</body>
<script type="text/javascript">

function exportExcel(){
	var param=location.href;
	var num=param.indexOf("?"); 
	   param=param.substr(num+1);
	$("#export").attr("href",'<%=staticPath%>/tjGroup/getGroupProfitExcl.do?'+param); 
}

</script>
</html>
  
  
  


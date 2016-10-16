<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>购物店统计表</title>
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
			<input type="hidden" name="dateType"  	value="${reqpm.dateType }" /> 
			<input type="hidden" name="startTime"  	value="${reqpm.startTime }" /> 
  			<input type="hidden" name="endTime" 	value="${reqpm.endTime }" />
   			<input type="hidden" name="shopSupplierName" value="${reqpm.shopSupplierName }" />
   			<input type="hidden" name="orgNames" value="${reqpm.orgNames }" />
   			<input type="hidden" name="orgIds" value="${reqpm.orgIds }" />
   			<input type="hidden" name="saleOperatorName" value="${reqpm.saleOperatorName }" />
   			<input type="hidden" name="saleOperatorIds" value="${reqpm.saleOperatorIds }" />
   			<input type="hidden" name="operateCompanyId" value="${reqpm.operateCompanyId }" />
   			
	  	</form>
		
		<p class="print-name mt-20">购物店统计表</p>
		<div class="print-tab mt-20">
			<table cellspacing="0" cellpadding="0" class="w_table">
				<col width="3%" />
				<col width="15%" />
				<col width="10%" />
				<col width="5%" />
				<col width="5%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<th>购物店<i class="w_table_split"></i></th>
						<th>人数<i class="w_table_split"></i></th>
						<th>购物金额<i class="w_table_split"></i></th>
						<th>人均购物<i class="w_table_split"></i></th>
						<th>购物返款<i class="w_table_split"></i></th>
						<th>应收合计<i class="w_table_split"></i></th>
						<th>已收<i class="w_table_split"></i></th>
						<th>欠收<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${pageBean.result}" var="item" varStatus="status">
						<tr>
							<td>${status.index+1}</td>
							<td>${item.shop_supplier_name}</td>
							<td>${item.person_num }</td>
							<td><fmt:formatNumber value="${item.total_fact }" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.person_buy_avg}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.total_repay }" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.total_repay }" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.total_cash }" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.total_repay - item.total_cash }" pattern="#.##" type="currency"/></td>
							
							<c:set var="sum_person_num" value="${sum_person_num + item.person_num}" />
							<c:set var="sum_total_fact" value="${sum_total_fact + item.total_fact}" />
							<c:set var="sum_person_buy_avg" value="${sum_person_buy_avg + item.person_buy_avg}" />
							<c:set var="sum_total_repay" value="${sum_total_repay + item.total_repay}" />
							<c:set var="sum_total_cash" value="${sum_total_cash + item.total_cash}" />
						</tr>
					</c:forEach>
					<tr>
						<td colspan="2">合计：</td>
						<td>${sum_person_num}</td>
						<td><fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/></td>
						<td>
							<c:if test="${sum_person_num eq 0}">
								<fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/>
							</c:if>
							<c:if test="${sum_person_num ne 0}">
								<fmt:formatNumber value="${sum_total_fact/sum_person_num}" pattern="#.##" type="currency"/>
							</c:if>
						</td>
						<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
						<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
						<td><fmt:formatNumber value="${sum_total_cash}" pattern="#.##" type="currency"/></td>
						<td><fmt:formatNumber value="${sum_total_repay - sum_total_cash}" pattern="#.##" type="currency"/></td>
					</tr>
				</tbody>
			</table>
		 </div>
		 <p class="mt-10">${printMsg }</p>
	</div>
</body>
<script type="text/javascript">

function exportExcel(){
	$("#export").attr("href", "<%=staticPath%>/tj/exportShopListExcel.do?"+ $("#queryForm").serialize()) ; 
}

</script>
</html>
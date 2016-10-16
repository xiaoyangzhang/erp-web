<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>单团购物统计表</title>
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
			<input type="hidden" name="dateType" 	value="${reqpm.dateType }" />
			<input type="hidden" name="startTime" value="${reqpm.startTime }" />
			<input type="hidden" name="endTime" 	value="${reqpm.endTime }" />
			<input type="hidden" name="groupCode" value="${reqpm.groupCode }" />
			<input type="hidden" name="supplierName" 	value="${reqpm.supplierName }" />
			<input type="hidden" name="operator_name" value="${reqpm.operator_name }" />
			<input type="hidden" name="operator_id" value="${reqpm.operator_id }" /> 
			<input type="hidden" name="groupMode" value="${reqpm.groupMode }" />
			<input type="hidden" name="productName" value="${reqpm.productName }" />
	  	</form>
		
		<p class="print-name mt-20">单团购物统计表</p>
		<div class="print-tab mt-20">
			<table cellspacing="0" cellpadding="0" class="w_table">
			<col width="3%" />
			<col width="6%" />
			<col width="6%" />
			<col width="5%" />
			<col width="3%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			
			<col width="6%" />
			<col width="6%" />
			<col width="6%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
			
			<col width="5%" />
			<col width="5%" />
			<col width="5%" />
				
				<thead>
					<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>客源等级<i class="w_table_split"></i></th>
			<th>团期<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>成人|儿童<i class="w_table_split"></i></th>
			
			<th>购物店<i class="w_table_split"></i></th>
			<th>进店人数<i class="w_table_split"></i></th>
			<th>进店日期<i class="w_table_split"></i></th>
			<th>导游<i class="w_table_split"></i></th>
			<th>导管<i class="w_table_split"></i></th>
			<th>购物金额<i class="w_table_split"></i></th>
			<th>人均购物<i class="w_table_split"></i></th>
			<th>返款金额<i class="w_table_split"></i></th>
			
			<th>购物金额总计<i class="w_table_split"></i></th>
			<th>其他佣金<i class="w_table_split"></i></th>
			<th>购物利润<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;">${item.group_code}</td>
               <td>【${item.product_brand_name}】${item.product_name}</td>
               <td>${item.province_name}</td>
				<td>${item.source_type_name}</td>
				<td>${item.date_start}</td>
				<td>${item.operator_name }</td>
				<td>${item.total_adult }大${item.total_child}小</td>
				
				<c:set var="sum_group_total_fact" value="0" />
				<c:set var="sum_group_person_buy_avg" value="0" />
				<c:set var="sum_group_total_repay" value="0" />
				<c:set var="sum_group_total_person_num" value="0" />
				
				<td colspan="8">
					<c:if test="${not empty item.shops}">
					<table  class="in_table" >
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<col width="12.5%" />
						<thead></thead>
						<tbody>
							<c:forEach items="${item.shops}" var="detail" varStatus="status">
							<tr>
								<td>${detail.shop_supplier_name}</td>
								<td>${detail.person_num}</td>
								<td>${detail.shop_date}</td>
								<td>${detail.guide_name}</td>
								<td>${detail.guide_manage_name}</td>
								<td><fmt:formatNumber value="${detail.total_fact}" pattern="#.##" type="currency"/></td>
								<%-- <td><fmt:formatNumber value="${detail.total_fact/detail.person_num}" pattern="#.##" type="currency"/></td> --%>
								<td>
									<c:if test="${empty detail.person_num or detail.person_num eq 0}">0</c:if>
									<c:if test="${not empty detail.person_num and (detail.person_num >0 or detail.person_num <0)}">
										<fmt:formatNumber value="${detail.total_fact/detail.person_num}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								<td><fmt:formatNumber value="${detail.total_repay}" pattern="#.##" type="currency"/></td>
								<c:set var="sum_group_total_fact" value="${sum_group_total_fact + detail.total_fact}" />
 								<c:set var="sum_group_person_buy_avg" value="${sum_group_person_buy_avg + detail.person_buy_avg}" />
 								<c:set var="sum_group_total_repay" value="${sum_group_total_repay + detail.total_repay}" />
 								<c:set var="sum_group_total_person_num" value="${sum_group_total_person_num + detail.person_num}" />
								
								<c:set var="sum_person_num" value="${sum_person_num + detail.person_num}" />
								<c:set var="sum_total_fact" value="${sum_total_fact + detail.total_fact}" />
 								<c:set var="sum_person_buy_avg" value="${sum_person_buy_avg + detail.person_buy_avg}" />
 								<c:set var="sum_total_repay" value="${sum_total_repay + detail.total_repay}" />
 								
							</tr>
							</c:forEach>
						</tbody>
								</table>
								</c:if>
							</td>
							
							<td><fmt:formatNumber value="${sum_group_total_fact }" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${item.total_comm }" pattern="#.##" type="currency"/></td>
						
							<td><fmt:formatNumber value="${item.shop_profit }" pattern="#.##" type="currency"/></td>
							
								<c:set var="sum_total_comm" value="${sum_total_comm + item.total_comm}" />
 				<c:set var="sum_shop_profit" value="${sum_shop_profit + item.shop_profit}" />
						</tr>
					</c:forEach>
					<tr>
						<td colspan="13>合计：</td>
						<td><fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/></td>
						<td>
							<%-- <c:if test="${sum_person_num eq 0}">
								<fmt:formatNumber value="${sum_total_fact}" pattern="#.##" type="currency"/>
							</c:if>
							<c:if test="${sum_person_num ne 0}">
								<fmt:formatNumber value="${sum_total_fact/sum_person_num}" pattern="#.##" type="currency"/>
							</c:if> --%>
						</td>
						<td><fmt:formatNumber value="${sum_total_repay}" pattern="#.##" type="currency"/></td>
						<td><fmt:formatNumber value="${sum_total_comm}" pattern="#.##" type="currency"/></td>
						<td></td>
						<td><fmt:formatNumber value="${sum_shop_profit}" pattern="#.##" type="currency"/></td>
					</tr>
				</tbody>
			</table>
		</div>
		<p class="mt-10">${printMsg }</p>
	</div>
</body>
<script type="text/javascript">

function exportExcel(){
	$("#export").attr("href", "<%=staticPath%>/tj/exportGroupShopListExcel.do?"+ $("#queryForm").serialize()) ; 
}

</script>
</html>
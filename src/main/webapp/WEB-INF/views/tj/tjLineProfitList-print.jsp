<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style media="print" type="text/css">
			.print{display: none;}
	</style>
	<style type="text/css">
		.w_table thead tr td{height:30px; text-align: center;font-weight:700; border: 1px solid #a3c1e9;background:#f4f5f6;}
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
		<input type="hidden" value="${reqpm.productBrandName }" id="productBrandName">
		<input type="hidden" value="${reqpm.startTime }" id="startTime">
		<input type="hidden" value="${reqpm.endTime }" id="endTime">
		<input type="hidden" value="${reqpm.companyId }" id="companyId">
		<input type="hidden" value="${reqpm.type }" id="type">
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
			
			<p class="print-name mt-20">线路利润统计表</p>
			<div class="print-tab mt-20">
				<table cellspacing="0" cellpadding="0" class="w_table" >
					<col width="3%" />
					<col width="10%" />
					<col width="8%" />
					<col width="5%" />
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					<thead>
						<tr>
							<td rowspan="2">序号<i class="w_table_split"></i></td>
							<td rowspan="2">品牌名称<i class="w_table_split"></i></td>
							<td rowspan="2">收客人数<i class="w_table_split"></i></td>
							<td rowspan="2">收客占比<i class="w_table_split"></i></td>
							
							<td colspan="4">收入<i class="w_table_split"></i></td>
							<td colspan="3">成本<i class="w_table_split"></i></td>
							
							<td rowspan="2">毛利<i class="w_table_split"></i></td>
							<td rowspan="2">人均毛利<i class="w_table_split"></i></td>
							<td rowspan="2">总购物<i class="w_table_split"></i></td>
							<td rowspan="2">人均购物<i class="w_table_split"></i></td>
						</tr>
						<tr>
							<td >团款收入<i class="w_table_split"></i></td>
							<td >人均团款<i class="w_table_split"></i></td>
							<td >其他收入<i class="w_table_split"></i></td>
							<td >购物收入<i class="w_table_split"></i></td>
							
							<td >总成本<i class="w_table_split"></i></td>
							<td >人均成本<i class="w_table_split"></i></td>
							<td >购物成本<i class="w_table_split"></i></td>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageBean.result}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td>${item.product_brand_name}</td>
								<td>${item.total_adult}大${item.total_child}小${item.total_guide}陪</td>
								<td>
								<c:if test="${empty all_sum_person or all_sum_person eq 0}">0</c:if>
								
								<c:if test="${not empty all_sum_person and (all_sum_person >0 or all_sum_person <0)}">
									<fmt:formatNumber value="${item.sum_person*100/all_sum_person}" pattern="#.####" type="currency"/>% 
								</c:if>
								</td>
								<!--团款收入 -->
								<td><fmt:formatNumber value="${item.income_order}" pattern="#.##" type="currency"/></td>
								
								<td>
									<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
									<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
										<fmt:formatNumber value="${item.income_order/item.total_adult}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								
								<td><fmt:formatNumber value="${item.income_other}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.shop_repay}" pattern="#.##" type="currency"/></td>
								<!--单团成本 -->
								<td><fmt:formatNumber value="${item.total_cost}" pattern="#.##" type="currency"/></td>
								<td>
									<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
									<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
										<fmt:formatNumber value="${item.total_cost/item.total_adult}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								<td><fmt:formatNumber value="${item.shop_commission}" pattern="#.##" type="currency"/></td>
								<!--毛利 -->
								<td><fmt:formatNumber value="${item.total_profit}" pattern="#.##" type="currency"/></td>
								<td >
									<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
									<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
										<fmt:formatNumber value="${item.total_profit/item.total_adult}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								<td><fmt:formatNumber value="${item.shop_sales}" pattern="#.##" type="currency"/></td>
								<td>
									<c:if test="${empty item.total_adult or item.total_adult eq 0}">0</c:if>
									<c:if test="${not empty item.total_adult and (item.total_adult >0 or item.total_adult <0)}">
										<fmt:formatNumber value="${item.shop_sales/item.total_adult}" pattern="#.##" type="currency"/>
									</c:if>
								</td>
								
								<c:set var="sum_total_adult" value="${sum_total_adult+item.total_adult }" />
								<c:set var="sum_total_child" value="${sum_total_child+item.total_child }" />
								<c:set var="sum_total_guide" value="${sum_total_guide+item.total_guide }" />
								<c:set var="sum_income_order" value="${sum_income_order+item.income_order }" />
								<c:set var="sum_income_other" value="${sum_income_other+item.income_other }" />
								<c:set var="sum_shop_repay" value="${sum_shop_repay+item.shop_repay }" />
								<c:set var="sum_total_profit" value="${sum_total_profit+item.total_profit }" />
								<c:set var="sum_total_cost" value="${sum_total_cost+item.total_cost }" />
								<c:set var="sum_shop_commission" value="${sum_shop_commission+item.shop_commission }" />
								<c:set var="sum_shop_sales" value="${sum_shop_sales+item.shop_sales }" />
								
							</tr>
						</c:forEach>
						<tr>
							<td colspan="2">合计：</td>
							<td>${sum_total_adult}大${sum_total_child}小${sum_total_guide}陪</td>
							<td></td>
							<td><fmt:formatNumber value="${sum_income_order}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_income_other}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_shop_repay}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_total_cost}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_shop_commission}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_total_profit}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_shop_sales}" pattern="#.##" type="currency"/></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<p class="mt-10">${printMsg }</p>
			
		</div>
	</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 15;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/tj/selectShopProjectList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList();
}

$(function() {
	queryList();
});


function exportExcel(){
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var productBrandName=$('#productBrandName').val();
	var companyId=$('#companyId').val();
	var type=$('#type').val();
	$("#export").attr("href",'<%=staticPath%>/tjGroup/getLineProfitExcl.do?startTime='+startTime+'&endTime='+endTime+'&productBrandName='+productBrandName+'&companyId='+companyId+'&type='+type+'') ; 
}

</script>
</html>

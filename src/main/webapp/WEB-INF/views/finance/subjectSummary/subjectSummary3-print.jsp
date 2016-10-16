<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style type="text/css">
		.w_table thead tr td{height:30px; text-align: center;font-weight:700; border: 1px solid #a3c1e9;background:#f4f5f6;}
	</style> 
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
	<form id="queryFormSub">
		<input type="hidden" value="${reqpm.dateType }" id="dateType" name="dateType">
		<input type="hidden" value="${reqpm.startTime }" id="startTime" name="startTime">
		<input type="hidden" value="${reqpm.endTime }" id="endTime" name="endTime">
		<input type="hidden" value="${reqpm.saleOperatorIds }" id="saleOperatorIds" name="saleOperatorIds">
		<input type="hidden" value="${reqpm.orgIds }" id="orgIds" name="orgIds">
		<input type="hidden" value="${reqpm.sjType }" id="sjType" name="sjType">
		<input type="hidden" value="${reqpm.supplierName }" id="supplierName" name="supplierName">
	</form>
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
			
			<p class="print-name mt-20">购物项目统计表</p>
			<div class="print-tab mt-20">
				<table cellspacing="0" cellpadding="0" class="w_table">
					<col width="3%" />
					<col width="12%" />
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<%-- <col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" /> --%>
					
					<thead>
						<!-- <tr>
							<td rowspan="2">序号<i class="w_table_split"></i></td>
							<td rowspan="2">商家名称<i class="w_table_split"></i></td>
							
							<td colspan="4">应付<i class="w_table_split"></i></td>
							<td colspan="4">已付<i class="w_table_split"></i></td>
							<td colspan="4">欠付<i class="w_table_split"></i></td>
						</tr> -->
						<tr>
							<td >序号<i class="w_table_split"></i></td>
							<td >商家名称<i class="w_table_split"></i></td>
							<td >导游现收<i class="w_table_split"></i></td>
							<td >公司现收<i class="w_table_split"></i></td>
							<td >其它<i class="w_table_split"></i></td>
							<td >合计<i class="w_table_split"></i></td>
							
							<!-- <td >导游现付<i class="w_table_split"></i></td>
							<td >公司现付<i class="w_table_split"></i></td>
							<td >签单月结<i class="w_table_split"></i></td>
							<td >其它<i class="w_table_split"></i></td>
							
							<td >导游现付<i class="w_table_split"></i></td>
							<td >公司现付<i class="w_table_split"></i></td>
							<td >签单月结<i class="w_table_split"></i></td>
							<td >其它<i class="w_table_split"></i></td> -->
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageBean.result}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td>${item.supplier_name}</td>
								<td><fmt:formatNumber value="${item.dy_total}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.gs_total}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.qt_total}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.dy_total+item.gs_total+item.qt_total}" pattern="#.##" type="currency"/></td>
								
								<%-- <td><fmt:formatNumber value="${item.dy_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.gs_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.qd_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.qt_total_cash}" pattern="#.##" type="currency"/></td>
								
								<td><fmt:formatNumber value="${item.dy_total-item.dy_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.gs_total-item.gs_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.qd_total-item.qd_total_cash}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.qt_total-item.qt_total_cash}" pattern="#.##" type="currency"/></td> --%>
								
							</tr>
							<c:set var="sum_dy_total" value="${sum_dy_total+item.dy_total }" />
							<c:set var="sum_gs_total" value="${sum_gs_total+item.gs_total }" />
							<c:set var="sum_qt_total" value="${sum_qt_total+item.qt_total }" />
							<%-- <c:set var="sum_dy_total_cash" value="${sum_dy_total_cash+item.dy_total_cash }" />
							<c:set var="sum_gs_total_cash" value="${sum_gs_total_cash+item.gs_total_cash }" />
							<c:set var="sum_qd_total_cash" value="${sum_qd_total_cash+item.qd_total_cash }" />
							<c:set var="sum_qt_total_cash" value="${sum_qt_total_cash+item.qt_total_cash }" /> --%>
						</c:forEach>
						<tr>
							<td colspan="2">合计：</td>
							<td><fmt:formatNumber value="${sum_dy_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_gs_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_qt_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_dy_total+sum_gs_total+sum_qt_total}" pattern="#.##" type="currency"/></td>
							<%-- <td><fmt:formatNumber value="${sum_dy_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_gs_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_qd_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_qt_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_dy_total-sum_dy_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_gs_total-sum_gs_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_qd_total-sum_qd_total_cash}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_qt_total-sum_qt_total_cash}" pattern="#.##" type="currency"/></td> --%>
						</tr>
					</tbody>
				</table>
			</div>
			<p class="mt-10">${printMsg }</p>
			
		</div>
	</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
function exportExcel(){
	$("#export").attr("href","<%=staticPath%>/finance/sumjectSummaryExcl3.do?"+ $("#queryFormSub").serialize()) ;
}

</script>
</html>

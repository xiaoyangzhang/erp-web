<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../../include/top.jsp"%>
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
		<input type="hidden" value="${reqpm.dateType }" id="dateType">
		<input type="hidden" value="${reqpm.startTime }" id="startTime">
		<input type="hidden" value="${reqpm.endTime }" id="endTime">
		<input type="hidden" value="${reqpm.groupCode }" id="groupCode">
		<input type="hidden" value="${reqpm.groupMode }" id="groupMode">
		<input type="hidden" value="${reqpm.productName }" id="productName">
		<input type="hidden" value="${reqpm.saleOperatorIds }" id="saleOperatorIds">
		<input type="hidden" value="${reqpm.orgIds }" id="orgIds">
		<input type="hidden" value="${reqpm.page }" id="page">
		<input type="hidden" value="${reqpm.pageSize }" id="pageSize">
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
			
			<p class="print-name mt-20">进店统计表</p>
			<div class="print-tab mt-20">
				<table cellspacing="0" cellpadding="0" class="w_table">
					<col width="3%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="5%" />
					<col width="5%" />
					<col width="15%" />
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					<thead>
						<tr>
							<th>序号<i class="w_table_split"></i></th>
							<th>公司<i class="w_table_split"></i></th>
							<th>团号<i class="w_table_split"></i></th>
							<th>产品名称<i class="w_table_split"></i></th>
							<th>计调<i class="w_table_split"></i></th>
							<th>人数<i class="w_table_split"></i></th>
							<th>订单<i class="w_table_split"></i></th>
							
							<th>导游<i class="w_table_split"></i></th>
							<th>导游电话<i class="w_table_split"></i></th>
							<th>司机<i class="w_table_split"></i></th>
							<th>导管<i class="w_table_split"></i></th>
							
							
							<th>店名<i class="w_table_split"></i></th>
							<th>进店日期<i class="w_table_split"></i></th>
							<th>进店人数<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageBean.result}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td>${item.company}</td>
								<td>${item.group_code}</td>
								<td>【${item.product_brand_name}】${item.product_name}</td>
								<td>${item.operator_name}</td>
								<td>${item.total_adult}大${item.total_child}小${item.total_guide}陪</td>
								<td>${item.orders}</td>
								
								<td colspan="7">
									<c:if test="${not empty item.guideTj}">
									<table class="in_table">
										<col width="14%" />
										<col width="14%" />
										<col width="14%" />
										<col width="14%" />
										<col width="14%" />
										<col width="14%" />
										<col width="14%" />
										<thead></thead>
										<tbody>
											<c:forEach items="${item.guideTj}" var="detail" varStatus="status">
											<tr>
												<td>${detail.guide_name}</td>
												<td>${detail.guide_mobile}</td>
												<td>${detail.driver_name}
													<c:if test="${!empty detail.driver_tel}" >
														(${detail.driver_tel})
													</c:if>
													${detail.car_lisence}
												</td>
												<td>${detail.user_name}</td>
												
												<td colspan="3">
													<c:if test="${not empty detail.shop}">
													<table class="in_table">
														<col width="33%" />
														<col width="33%" />
														<col width="33%" />
														<thead></thead>
														<tbody>
															<c:forEach items="${detail.shop}" var="shop" varStatus="status">
															<tr>
																<td>${shop.supplierName}</td>
																<td>${shop.shopDate}</td>
																<td>${shop.personNum}</td>
															</tr>
															</c:forEach>
														</tbody>
													</table>
													</c:if>
												</td>
												
											</tr>
											</c:forEach>
										</tbody>
									</table>
									</c:if>
								</td>
								
								
							</tr>
						</c:forEach>
						<%-- <tr>
							<td colspan="2">本页合计：</td>
							<td>${sum_total_person}</td>
							<td><fmt:formatNumber value="${sum_total_face}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_buy_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_repay_total}" pattern="#.##" type="currency"/></td>
						</tr> --%>
					</tbody>
				</table>
			</div>
			<p class="mt-10">${printMsg }</p>
			
		</div>
	</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function exportExcel(){
	var dateType=$('#dateType').val();
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var productName=$('#productName').val();
	var groupCode=$('#groupCode').val();
	var groupMode=$('#groupMode').val();
	var orgIds=$('#orgIds').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var page=$('#page').val();
	var pageSize=$('#pageSize').val();
 	$("#export").attr("href",'<%=staticPath%>/bookingShop/shopTJExcl.do?dateType='+dateType+'&startTime='+startTime+'&endTime='+endTime+'&groupMode='+groupMode+'&pageSize='+pageSize+'&page='+page+'&groupCode='+groupCode+'&saleOperatorIds='+saleOperatorIds+'&orgIds='+orgIds+'&productName='+productName+'') ; 

}

</script>
</html>

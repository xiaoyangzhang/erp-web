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
		<input type="hidden" value="${reqpm.dateType }" id="dateType">
		<input type="hidden" value="${reqpm.startTime }" id="startTime">
		<input type="hidden" value="${reqpm.endTime }" id="endTime">
		<input type="hidden" value="${reqpm.shopStore }" id="shopStore">
		<input type="hidden" value="${reqpm.shopItem }" id="shopItem">
		<input type="hidden" value="${reqpm.productName }" id="productName">
		<input type="hidden" value="${reqpm.groupCode }" id="groupCode">
		<input type="hidden" value="${reqpm.saleOperatorIds }" id="saleOperatorIds">
		<input type="hidden" value="${reqpm.orgIds }" id="orgIds">
		<input type="hidden" value="${reqpm.productName }" id="productName">
		<input type="hidden" value="${reqpm.saleType}" id="saleType" />
		<input type="hidden" value="${reqpm.groupMode}" id="groupMode" /> 
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
					<colgroup>
						<col width="3%" />
						<col width="15%" />
						<col width="5%" />
						<col width="8%" />
						
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<th>序号</th>
							<th>购物店</th>
							<th>进店总人数</th>
							<th>总额</th>
							
							<th>购物项目</th>
							<th>返款比例</th>
							<th>购物金额</th>
							<th>返款</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageBean.result}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td>${item.supplier_name}</td>
								<td><fmt:formatNumber value="${item.total_person}" pattern="#.##" type="currency"/></td>
								<td><fmt:formatNumber value="${item.total_face}" pattern="#.##" type="currency"/></td>
								<c:set var="sum_total_person" value="${sum_total_person+item.total_person }" />
								<c:set var="sum_total_face" value="${sum_total_face+item.total_face }" />
								<td colspan="4">
									<c:if test="${not empty item.bookingShopDetailList}">
									<table cellspacing="0" cellpadding="0" class="w_table" style="border-top:0px;">
										<col width="25%" />
										<col width="25%" />
										<col width="25%" />
										<col width="25%" />
										<thead></thead>
										<tbody>
											<c:forEach items="${item.bookingShopDetailList}" var="detail" varStatus="status">
												<tr>
													<c:set value="${ fn:split(detail.repay_val, ',') }" var="str1" />
													<td>${detail.goods_name}</td>
													<td>
													<c:forEach items="${ str1 }" var="s">
														<fmt:formatNumber value="${ s }" pattern="#.####" type="currency"/>%
														<br />
													</c:forEach>
													</td>
													<%-- <td>
													<c:if test="${empty detail.buy_total or detail.buy_total eq 0}">0</c:if>
														<c:if test="${not empty detail.buy_total and (detail.buy_total >0 or detail.buy_total <0)}">
															<fmt:formatNumber value="${detail.repay_total*100/detail.buy_total}" pattern="#.####" type="currency"/>% 
														</c:if>
													</td> --%>
													<td><fmt:formatNumber value="${detail.buy_total}" pattern="#.##" type="currency"/></td>
													<td><fmt:formatNumber value="${detail.repay_total}" pattern="#.##" type="currency"/></td>
												</tr>
					 							<c:set var="sum_buy_total" value="${sum_buy_total+detail.buy_total }" />
					 							<c:set var="sum_repay_total" value="${sum_repay_total+detail.repay_total }" />
											</c:forEach>
										</tbody>
									</table>
									</c:if>
								</td>
							</tr>
						</c:forEach>
						<tr>
							<td colspan="2">合计：</td>
							<td>${sum_total_person}</td>
							<td><fmt:formatNumber value="${sum_total_face}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_buy_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_repay_total}" pattern="#.##" type="currency"/></td>
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
	var dateType=$('#dateType').val();
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var shopStore=$('#shopStore').val();
	var shopItem=$('#shopItem').val();
	var productName=$('#productName').val();
	var groupCode=$('#groupCode').val();
	var orgIds=$('#orgIds').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var productName=$('#productName').val();
	var saleType = $('#saleType').val();
	var groupMode = $('#groupMode').val();
	$("#export").attr("href",'<%=staticPath%>/tj/getProjects.do?dateType='+dateType+'&startTime='+startTime+'&endTime='+endTime+'&shopStore='+shopStore+'&shopItem='+shopItem+'&productName='+productName+'&groupCode='+groupCode+'&saleOperatorIds='+saleOperatorIds+'&orgIds='+orgIds+'&productName='+productName+'&saleType='+saleType+'&groupMode='+groupMode) ; 

}

</script>
</html>

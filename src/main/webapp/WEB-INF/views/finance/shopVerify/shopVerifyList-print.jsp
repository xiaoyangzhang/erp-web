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
		<input type="hidden" value="${reqpm.shopStore }" id="shopStore">
		<input type="hidden" value="${reqpm.shopItem }" id="shopItem">
		<input type="hidden" value="${reqpm.productName }" id="productName">
		<input type="hidden" value="${reqpm.groupCode }" id="groupCode">
		<input type="hidden" value="${reqpm.saleOperatorIds }" id="saleOperatorIds">
		<input type="hidden" value="${reqpm.orgIds }" id="orgIds">
		<input type="hidden" value="${reqpm.productName }" id="productName">
		<div class="print">
			<div class="print-btngroup">
			
	    		<a href="javascript:void(0);" id="export" onclick="opPrint();" >打印</a>
	    		<a href="javascript:void(0);" onclick="window.close();">关闭页面</a>
	    	</div>
		</div>
		<div class="print-word">
			<%-- <div align="center">
				<img src="${imgPath}"/>
			</div> --%>
			
			<p class="print-name mt-20">购物审核</p>
			<div class="print-tab mt-20">
				<table cellspacing="0" cellpadding="0" class="w_table">
					<col width="3%" />
					<col width="8%" />
					<col width="15%" />
					<col width="5%" />
					<col width="4%" />
					<col width="8%" />
					<col width="3%" />
					<%-- <col width="7%" /> --%>
					
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
					
					<col width="5%" />
					<col width="5%" />
					<col width="5%" />
					
					<col width="5%" />
					<col width="5%" />
					<thead>
						<tr>
							<th>序号<i class="w_table_split"></i></th>
							<th>团号<i class="w_table_split"></i></th>
							<th>产品名称<i class="w_table_split"></i></th>
							<th>发团日期<i class="w_table_split"></i></th>
							<th>计调<i class="w_table_split"></i></th>
							<th>购物店<i class="w_table_split"></i></th>
							<th>进店人数<i class="w_table_split"></i></th>
							
							<th>购物项目<i class="w_table_split"></i></th>
							<th>购物金额<i class="w_table_split"></i></th>
							<th>购物合计<i class="w_table_split"></i></th>
							
							
							<th>社佣比例<i class="w_table_split"></i></th>
							<th>社佣金额<i class="w_table_split"></i></th>
							<th>社佣合计<i class="w_table_split"></i></th>
							<th>导游<i class="w_table_split"></i></th>
							<th>状态<i class="w_table_split"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageBean.result}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td style="text-align: left;">
					              <c:if test="${item.group_mode <= 0}">
					              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看定制团信息','<%=staticPath %>/fitGroup/toFitGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a> 
					              </c:if>
					              <c:if test="${item.group_mode > 0}">
					              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看散客团信息','<%=staticPath %>/teamGroup/toEditTeamGroupInfo.htm?groupId=${item.groupId}&operType=0')">${item.group_code}</a>
					              </c:if>
				              </td>
								<td style="text-align: left;">【${item.product_brand_name}】${item.product_name}</td>
								<td ><fmt:formatDate value="${item.date_start}" pattern="yyyy-MM-dd" /></td>
								<td  style="text-align: left;">${item.operator_name}</td>
								<td  style="text-align: left;">${item.supplier_name}</td>
								<td >	${item.person_num eq null?0:item.person_num}
								</td>
								<td colspan="2">
									<table class="in_table">
										<col width="50%" />
										<col width="50%" />
										<thead></thead>
										<tbody>
									<c:if test="${not empty item.bookingShopVerifyDetailList}">
											<c:forEach items="${item.bookingShopVerifyDetailList}" var="bill" varStatus="status">
												<c:if test="${fn:length(item.bookingShopVerifyDetailList) == status.index + 1}">
													<c:set var="borderCss"  value="style=\"\"" /> <!-- border-bottom:0px; -->
												</c:if>
											<tr>
												<td>${bill.goods_name}</td>
												<td ${borderCss } ><fmt:formatNumber value="${bill.sum_buy_total}" pattern="#.##" type="currency"/></td>
											</tr>
											<c:set var="sum_cash" value="${sum_cash+bill.sum_buy_total }" />
											<c:set var="sum_shop_total" value="${sum_shop_total+bill.sum_buy_total}" />
											</c:forEach>
									</c:if>
										</tbody>
									</table>
								</td>
								<td ><fmt:formatNumber value="${sum_cash}" pattern="#.##" type="currency"/></td>
								<c:set var="sum_cash" value="0" />
								
								<td colspan="2">
									<c:if test="${not empty item.bookingShopVerifyDetailList}">
									<table class="in_table">
										<col width="50%" />
										<col width="50%" />
										<thead></thead>
										<tbody>
											<c:forEach items="${item.bookingShopVerifyDetailList}" var="bill" varStatus="status">
												<c:if test="${fn:length(item.bookingShopVerifyDetailList) == status.index + 1}">
													<c:set var="borderCss"  value="style=\"\"" /> <!-- border-bottom:0px; -->
												</c:if>
											<tr>
												<td ${borderCss2 } >
													<fmt:formatNumber value="${bill.repay_val}" pattern="#.####" type="currency"/>% 
												</td>
												<td ${borderCss } ><fmt:formatNumber value="${bill.sum_repay_total}" pattern="#.##" type="currency"/></td>
											</tr>
											<c:set var="sum_cash2" value="${sum_cash2+bill.sum_repay_total }" />
											<c:set var="sum_repay" value="${sum_repay+bill.sum_repay_total}" />
											</c:forEach>
										</tbody>
									</table>
									</c:if>
								</td>
								<td  ><fmt:formatNumber value="${sum_cash2}" pattern="#.##" type="currency"/></td>
								<c:set var="sum_cash2" value="0" />
								<td>
								<c:forEach items="${supplierGuides}" var="sGuide">
									<c:if test="${item.guide_id eq sGuide.id}">
										${sGuide.name}
									</c:if>
								</c:forEach>
								</td>
								<td>
									<%-- <c:if test="${item.state_seal ne 1 }"> --%>
										<c:if test="${item.state_finance != 1 }">未审核</c:if>
										<c:if test="${item.state_finance == 1 }">已审核</c:if>
									<%-- </c:if>
									<c:if test="${item.state_seal eq 1 }">
										已封存
									</c:if> --%>
								</td>
							</tr>
							<c:set var="sum_person_num" value="${sum_person_num+item.person_num }" />
						</c:forEach>
						<tr>
							<td colspan="6">合计：</td>
							<td>${sum_person_num}</td>
							<td></td>
							<td><fmt:formatNumber value="${sum_shop_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_shop_total}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td><fmt:formatNumber value="${sum_repay}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${sum_repay}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="6">总合计：</td>
							<td>${map.total_person}</td>
							<td></td>
							<td><fmt:formatNumber value="${map.buy_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${map.buy_total}" pattern="#.##" type="currency"/></td>
							<td></td>
							<td><fmt:formatNumber value="${map.repay_total}" pattern="#.##" type="currency"/></td>
							<td><fmt:formatNumber value="${map.repay_total}" pattern="#.##" type="currency"/></td>
							<td></td>
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
function opPrint() {
    window.print();
}

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
	$("#export").attr("href",'<%=staticPath%>/tj/getProjects.do?dateType='+dateType+'&startTime='+startTime+'&endTime='+endTime+'&shopStore='+shopStore+'&shopItem='+shopItem+'&productName='+productName+'&groupCode='+groupCode+'&saleOperatorIds='+saleOperatorIds+'&orgIds='+orgIds+'&productName='+productName+'') ; 

}

</script>
</html>

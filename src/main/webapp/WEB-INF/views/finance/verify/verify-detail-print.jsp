<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>对账单</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
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
	<div class="p_container">
	<div class="print-word">
		<div align="center">
				<img src="${imgPath}"/>
		</div>
	</div>
	<input type="hidden" name="supplierType" id="supplierType"  value="${verify.supplierType}" />
	<div class="p_container_sub">
		<div class="searchRow">
			<ul>
				<c:if test="${verify.supplierType eq 1 }">
					<li class="text">组团社:</li>
				</c:if>
				<c:if test="${verify.supplierType eq 16 }">
					<li class="text">地接社:</li>
				</c:if>
				<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
					<li class="text">商家:</li>
				</c:if>
				<li class="text" style="width:200px;text-align:left;">${verify.supplierName}</li>
				<li class="text">账期:</li>
				<li class="text" style="width:400px;text-align:left;">
					<fmt:formatDate pattern='yyyy/MM/dd' value='${verify.dateStart}' />
					~
					<fmt:formatDate pattern='yyyy/MM/dd' value='${verify.dateEnd}' />
				</li>
			</ul>
		</div>
	</div>
	<div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<c:if test="${verify.supplierType eq 1 }">
				<col width="3%" />
				<col width="14%" />
			
				<col width="11%" />
				<col width="7%" />
				<col width="3%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="3%" />
				<col width="3%" />
				<col width="3%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="10%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="15%" />
				</c:if>
			</c:if>
			<c:if test="${verify.supplierType eq 16}">
				<col width="3%" />
				<col width="14%" />
				
				<col width="13%" />
				<col width="3%" />
				
				<col width="6%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="13%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="18%" />
				</c:if>
			</c:if>
			<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
				<col width="3%" />
				<col width="16%" />
				
				<col width="10%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="13%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="18%" />
				</c:if>
			</c:if>
			<thead>
				<th>序号<i class="w_table_split"></i></th>
				<th>产品<i class="w_table_split"></i></th>
				
				<c:if test="${verify.supplierType eq 1 }">
					<th>团号<i class="w_table_split"></i></th>
					<th>接站牌<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
				</c:if>
				<c:if test="${verify.supplierType eq 16 }">
					<th>团号<i class="w_table_split"></i></th>
					<th>人数<i class="w_table_split"></i></th>
				</c:if>
				<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
					<th>团号<i class="w_table_split"></i></th>
				</c:if>
				
				<th>日期<i class="w_table_split"></i></th>
				<th>计调<i class="w_table_split"></i></th>
				<th>明细<i class="w_table_split"></i></th>
				<th>金额<i class="w_table_split"></i></th>
				<th>已结算<i class="w_table_split"></i></th>
				<th>未结算<i class="w_table_split"></i></th>
				<th>调账<i class="w_table_split"></i></th>
				<th>实付<i class="w_table_split"></i></th>
				<th>备注<i class="w_table_split"></i></th>
				<c:if test="${empty reqpm.isShow}">
					<th>操作<i class="w_table_split"></i></th>
				</c:if>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<div id="tableDiv"></div>
	<div>
		<table cellspacing="0" cellpadding="0" class="w_table">
			<c:if test="${verify.supplierType eq 1 }">
				<col width="3%" />
				<col width="14%" />
			
				<col width="11%" />
				<col width="7%" />
				<col width="3%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="3%" />
				<col width="3%" />
				<col width="3%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="10%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="15%" />
				</c:if>
			</c:if>
			<c:if test="${verify.supplierType eq 16}">
				<col width="3%" />
				<col width="14%" />
				
				<col width="13%" />
				<col width="3%" />
				
				<col width="6%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="13%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="18%" />
				</c:if>
			</c:if>
			<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
				<col width="3%" />
				<col width="16%" />
				
				<col width="10%" />
				
				<col width="10%" />
				<col width="3%" />
				<col width="15%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<c:if test="${empty reqpm.isShow}">
					<col width="10%" />
					<col width="5%" />
				</c:if>
				<c:if test="${not empty reqpm.isShow}">
					<col width="15%" />
				</c:if>
			</c:if>
			<thead>
			</thead>
			<tbody>
				<tr>
					<td></td>
					<td></td>
					
					<c:if test="${verify.supplierType eq 1 }">
						<td></td>
						<td></td>
						<td></td>
					</c:if>
					<c:if test="${verify.supplierType eq 16 }">
						<td></td>
						<td></td>
					</c:if>
					<c:if test="${verify.supplierType ne 1 &&  verify.supplierType ne 16}">
						<td></td>
					</c:if>
					
					<td></td>
					<td></td>
					<td colspan="1" style="text-align: center;">合计：</td>
				    <td id="totalPrice"><fmt:formatNumber value="${total_price}" type="currency" pattern="#.##"/></td>
		         	<td id="totalCash"><fmt:formatNumber value="${total_cash}" type="currency" pattern="#.##"/></td>
					<td id="totalNot"><fmt:formatNumber value="${total_not}" type="currency" pattern="#.##"/></td>
					<td id="totalAdjust"><fmt:formatNumber value="${total_adjust}" type="currency" pattern="#.##"/></td>
					<td></td>
					<td></td>
					<c:if test="${empty reqpm.isShow}">
						<td></td>
					</c:if>
				</tr>
			</tbody>
		</table>
	</div>
</div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

	function loadJoinedTableExist(){
		
		var data = {};
		data.verifyId = ${verify.id};
		data.isShow = true;
		$("#tableDiv").load("queyrVerifyDetail.do", data, callback);
	}
	
	function callback(){
		$("input[name='totalAdjust']").each(function(){
			var tr_parent = $(this).parent().parent();
			$(this).parent().html($(this).val());
			var remark = tr_parent.find("textarea")[0];
			$(remark).parent().html($(remark).val());
		});
	}
	
	(function(){
		loadJoinedTableExist();
	})();

</script>
</html>
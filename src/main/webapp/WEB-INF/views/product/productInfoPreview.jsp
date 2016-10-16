<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>打印页</title>
<%@ include file="../../include/top.jsp"%>
<style media="print" type="text/css">
.NoPrint {
	display: none;
}
body {font-size:10pt !important;}
div{ font-size:10pt !important; } 
</style>

<link href="<%=ctx%>/assets/css/preview/preview.css" rel="stylesheet"
	type="text/css" />
	
</head>
<body>
	<div class="print NoPrint">
		<div class="print-btngroup">
			<input id="btnPrint" type="button" value="打印" onclick="opPrint()" />
			<input type="button" value="导出word" onclick="exportWord(${productId})" /> <input
				id="btnClose" type="button" value="关闭" onclick="window.close();" />
		</div>
	</div>
	<div align="center">
		<img src="${imgPath }" />
		<h6 style="font-size: 30px;font-weight: bold;" align="center">行程单</h6>
		<br/><br/>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
			<tbody >
				<tr>
					<th width="10%">产品编号</th>
					<td  width="30%">${map0.product_code }</td>
					<th width="10%">旅游天数</th>
					<td width="30%">${map0.day_num }</td>
					
				</tr>
				<tr>
					<th width="10%">产品</th>
					
					<td colspan="3" >【${params1.product_brand }】${params1.product_name }</td>
					
				</tr>
				
				<tr>
					<th width="10%">产品特色</th>
					<td colspan="5">${map0.product_feature }</td>
				</tr>
				<tr>
					<th width="10%">参考酒店</th>
					<td colspan="5">${map0.item_other }</td>
					
				</tr>
			</tbody>	
		</table>
						
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<thead>
					<th >日期<i class="w_table_split"></i></th>
			<th >行程<i class="w_table_split"></i></th>
			<th >餐<i class="w_table_split"></i></th>
			
			<th >住宿<i class="w_table_split"></i></th>
				</thead>
				<tbody>
				<c:forEach items="${ routeList}" var="route">
					<tr>
						<td width="5%" align="center" rowspan="2">${route.date }</td>
						<td width="75%" style="font-weight: bold;">${route.route_short }</td>
						<td width="10%" rowspan="2">${route.meal }</td>
						<td width="10%" align="center" rowspan="2"> ${route.hotel }</td>
					</tr>
					<tr>
						<td width="75%">${route.route_desp }</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		<table style="width: 100%; border-collapse: collapse; margin: 0px"
			border="1">
				<tbody>
				<c:if test="${!empty map2.item_include  }">
					<tr height="90px">
						<th width="10%">包含项目</th>
						<td>${map2.item_include }</td>
						
					</tr>
					</c:if>
					<c:if test="${!empty map2.item_exclude  }">
					<tr height="90px">
						<th width="10%">不含项目</th>
						<td>${map2.item_exclude }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.child_plan  }">
					<tr height="90px">
						<th width="10%">儿童安排</th>
						<td>${map2.child_plan }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.shopping_plan  }">
					<tr height="90px">
						<th width="10%">购物安排</th>
						<td>${map2.shopping_plan }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.item_charge  }">
					<tr height="90px">
						<th width="10%">自费项目</th>
						<td>${map2.item_charge }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.item_free  }">
					<tr height="90px">
						<th width="10%">赠送项目</th>
						<td>${map2.item_free }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.eat_note  }">
					<tr height="90px">
						<th width="10%">用餐说明</th>
						<td>${map2.eat_note }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.car_note  }">
					<tr height="90px">
						<th width="10%">用车说明</th>
						<td>${map2.car_note }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.guide_note  }">
					<tr height="90px">
						<th width="10%">导游说明</th>
						<td>${map2.guide_note }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.insurance_note  }">
					<tr height="90px">
						<th width="10%" >保险说明</th>
						<td>${map2.insurance_note }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.sight_note  }">
					<tr height="90px">
						<th width="10%">门票说明</th>
						<td>${map2.sight_note }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.refund_rule  }">
					<tr height="90px">
						<th width="10%">退改规则</th>
						<td>${map2.refund_rule }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.appoint_rule  }">
					<tr height="90px">
						<th width="10%">预约规则</th>
						<td>${map2.appoint_rule }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.passort  }">
					<tr height="90px">
						<th width="10%">签证信息</th>
						<td>${map2.passort }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.attention  }">
					<tr height="90px">
						<th width="10%">注意事项</th>
						<td>${map2.attention }</td>
						
					</tr></c:if>
					<c:if test="${!empty map2.warm_tip  }">
					<tr height="90px">
						<th width="10%">温馨提示</th>
						<td>${map2.warm_tip }</td>
						
					</tr></c:if>
					<tr height="90px">
						<th width="10%"></th>
						<td style="font-weight: bold;">本人已认真阅读过此行程内容及行程内的旅游项目表，认可此行程表并同意作为合同附件！<br/>
							客人联系电话：____________、人数：_______、合同编号：__________<br/>
							客人签字确认：___________、日期：_________</td>
						
					</tr>
					
				</tbody>
			</table><br/>
		<table style="width: 100%;">
			<tr>
				<td>打印时间：${params1.printTime}
						</td>
			</tr>
		</table>
	</div>

</body>
</html>
<script type="text/javascript">
	function opPrint() {
		window.print();
	}
	function exportWord(productId){
		location.href="download.htm?productId="+productId ; //供应商确认订单
		
	}
</script>
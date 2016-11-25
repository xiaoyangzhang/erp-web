<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>店铺销售统计</title>
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form action="toFitGroupList.htm" method="post"
					id="toFitGroupListForm">
						
						
					<dd class="inl-bl">
						<div class="dd_left">	
						<select name="dateType" id="dateType">
								<option value="1" <c:if test="${dateType=='1' }" >selected="selected"</c:if>>下单时间</option>
								<option value="2" <c:if test="${dateType=='2' }" >selected="selected"</c:if>>付款时间</option>
							</select>
							</div>
						<div class="dd_right grey">
							<input name="startMin" id="startMin" type="text" value="${start_min}" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
							~
							<input name="startMax" id="startMax" type="text" value="${start_max}" style="width:140px;"
							       class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
						</div>
						<div class="clear"></div>
					</dd>
					
					<dd class="inl-bl">
						<div class="dd_left">店铺</div>
						<div class="dd_right grey">
							<select name="myStoreId" id="myStoreId">
								<c:if test="${optMap_AY}"><option value="AY"<c:if test="${myStoreId=='AY' }" >selected="selected"</c:if>>爱游</option></c:if>
								<c:if test="${optMap_YM}"><option value="YM"<c:if test="${myStoreId=='YM' }" >selected="selected"</c:if>>怡美</option></c:if>
								<c:if test="${optMap_JY}"><option value="JY"<c:if test="${myStoreId=='JY' }" >selected="selected"</c:if>>景怡</option></c:if>
								<c:if test="${optMap_TX}"><option value="TX"<c:if test="${myStoreId=='TX' }" >selected="selected"</c:if>>天翔</option></c:if>
								<c:if test="${optMap_OUTSIDE}"><option value="OUTSIDE"<c:if test="${myStoreId=='OUTSIDE' }" >selected="selected"</c:if>>出境店</option></c:if>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
						<%-- 	<li><select id="authClient" name="authClient"> 
								<c:if test="${optMap_AY}"><option value="AY">爱游</option></c:if>
								<c:if test="${optMap_YM}"><option value="YM">怡美</option></c:if>
								<c:if test="${optMap_JY}"><option value="JY">景怡</option></c:if>
								<c:if test="${optMap_TX}"><option value="TX">天翔</option></c:if>
								<c:if test="${optMap_OUTSIDE}"><option value="OUTSIDE">出境店</option></c:if>
							</select></li> --%>
							
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>	
				</form>
				</dl>
			<dl class="p_paragraph_content">
			<table cellspacing="0" cellpadding="0" class="w_table">
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
								
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
								
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
								<col width="6%" />
								<col width="7%" />
				<thead>
					<tr>
						<th colspan="5">合计<i class="w_table_split"></i></th>
						<th colspan="5">正常<i class="w_table_split"></i></th>
						<th colspan="5">特殊<i class="w_table_split"></i></th>
					</tr>
						<tr>
						<th>订单数<i class="w_table_split"></i></th>
						<th>买家数量<i class="w_table_split"></i></th>
						<th>已付款<i class="w_table_split"></i></th>
						<th>应付款<i class="w_table_split"></i></th>
						<th>余款<i class="w_table_split"></i></th>
						
						<th>订单数<i class="w_table_split"></i></th>
						<th>买家数量<i class="w_table_split"></i></th>
						<th>已付款<i class="w_table_split"></i></th>
						<th>应付款<i class="w_table_split"></i></th>
						<th>余款<i class="w_table_split"></i></th>
						
						<th>订单数<i class="w_table_split"></i></th>
						<th>买家数量<i class="w_table_split"></i></th>
						<th>已付款<i class="w_table_split"></i></th>
							<th>应付款<i class="w_table_split"></i></th>
						<th>余款<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody>
						<tr>
							<td>${trade.orders}</td>
							<td>${trade.buyers}</td>
							<td><fmt:formatNumber value="${trade.totalFee}" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${trade.payment}" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${trade.payment-trade.totalFee}" pattern="#.##"/></td>
							
							<td>${tradeNoBrush.orders}</td>
							<td>${tradeNoBrush.buyers}</td>
							<td><fmt:formatNumber value="${tradeNoBrush.totalFee}" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${tradeNoBrush.payment}" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${tradeNoBrush.payment-tradeNoBrush.totalFee}" pattern="#.##"/></td>
							
							<td>${tradeBrush.orders}</td>
							<td>${tradeBrush.buyers}</td>
							<td><fmt:formatNumber value="${tradeBrush.totalFee}" pattern="#.##"/></td>
								<td><fmt:formatNumber value="${tradeBrush.payment}" pattern="#.##"/></td>
							<td><fmt:formatNumber value="${tradeBrush.payment-tradeBrush.totalFee}" pattern="#.##"/></td>
						</tr>
				</tbody>
			</table>
			</dl>
		</div>
	</div>
	<script type="text/javascript">
	function searchBtn() {
		var startMin=$("input[name='startMin']").val(),
		startMax=$("input[name='startMax']").val(),
		myStoreId=$('#myStoreId option:selected') .val();
		dateType=$('#dateType option:selected') .val();
		window.location = "<%=ctx%>/taobao/shopSalesStatistics.htm?startMin="+startMin+ "&startMax=" + startMax+ "&myStoreId=" + myStoreId+ "&dateType=" + dateType;
	}

	</script>
</body>
</html>
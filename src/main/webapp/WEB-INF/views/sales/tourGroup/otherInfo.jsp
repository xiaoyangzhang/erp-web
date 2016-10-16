<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="x-ua-compatible" content="IE=7" />
    <title>其他信息</title>
    <%@ include file="../../../include/top.jsp"%>
    <link href="<%=ctx%>/assets/js/web-js/sales/region_dlg.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/budgetItem.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/costItem.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/seatInCoach.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/guest.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/otherInfo.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/card/region-card-data.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/cities.js" ></script>
	<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/jquery.autocomplete.js"></script>
	<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/changeAddShow.js"></script>
	<script type="text/javascript">
	 $(function(){
		 
		 $("#unifiedSaveForm").validate(
					{
						errorPlacement : function(error, element) { // 指定错误信息位置

							if (element.is(':radio') || element.is(':checkbox')
									|| element.is(':input')) { // 如果是radio或checkbox
								var eid = element.attr('name'); // 获取元素的name属性
								error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
							} else {
								error.insertAfter(element);
							}
						},
						submitHandler : function(form) {
							var options = {
								url : 'unifiedSaveOtherInfo.do',
								type : "post",
								dataType : "json",
								success : function(data) {
									if (data.success) {
										$.success('操作成功',function(){
											window.location = window.location;
										});
										
									} else {
										$.warn(data.msg, {
											icon : 5
										});

									}
								},
								error : function(XMLHttpRequest, textStatus,
										errorThrown) {
									$.warn('服务忙，请稍后再试', {
										icon : 5
									});
								}
							}
							$(form).ajaxSubmit(options);
						},
						invalidHandler : function(form, validator) { // 不通过回调
							return false;
						}

					});
		 
	 })
	
	</script>
</head>
	<body>
	<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
		<div class="p_container">
			<ul class="w_tab">
				<li><a href="javascript:void(0);" onclick="toGroupOrder()">订单详情</a></li>
				<li><a href="javascript:void(0);" onclick="toGetRouteList()">行程列表</a></li>
				<li><a href="javascript:void(0);" onclick="toOtherInfo()" class="selected">其他信息</a></li>
				<li><a href="javascript:void(0);" onclick="togroupRequirement()">计调需求</a></li>
				<li class="clear"></li>
			</ul>
			<div class="p_container_sub">
				<dl class="p_paragraph_content">
					<input type="hidden" id="groupId" value="${groupId}"/>
					<input type="hidden" id="orderId" value="${orderId}"/>
					<input type="hidden" id="stateFinance" name="" value="${stateFinance}" />
					<input type="hidden" id="state" name="" value="${state}" />
					<c:import url="budgetItem/editBudgetItem.jsp"/>
					<c:import url="costItem/editCostItem.jsp"/>
					<c:import url="seatInCoach/editSeatInCoach.jsp"/> 
					<c:import url="guest/editGuest.jsp"/>
					<form id="unifiedSaveForm">
					<!-- 收入 -->
					<%-- <c:import url="budgetItem/addBudgetItem.jsp"/>--%>
				
					<c:import url="budgetItem/budgetItem.jsp"/> 
					<!-- 成本 -->
					<c:import url="costItem/costItem.jsp"/>
					<%-- <c:import url="costItem/addCostItem.jsp"/>--%>
				
					<!-- 接送信息 -->
					<c:import url="seatInCoach/seatInCoach.jsp"/>
					<%-- <c:import url="seatInCoach/addSeatInCoach.jsp"/>--%>
										<!-- 添加客人 -->
					<c:import url="guest/guest.jsp"/>
<%-- 					<c:import url="guest/addGuest.jsp"/> --%>
					<div style="text-align: center;">
									<button type="submit" class="button button-primary button-small">保存</button>
					</div>
					</form>

					
				</dl>
			</div>
		</div>
	</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="../../../include/top.jsp"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>行程</title>
<link href="<%=ctx%>/assets/css/product/product_rote.css"
	rel="stylesheet" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../groupOrder/toFitEdit.htm?groupId=${tourGroup.id}">散客团信息</a></li>
			<li><a
				href="../groupRoute/toGroupRoute.htm?groupId=${tourGroup.id}" class="selected">行程列表</a></li>
			<li><a
				href="../groupOrder/toFitOrderList.htm?groupId=${tourGroup.id}">订单列表</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${tourGroup.id}">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>
		<div class="p_container_sub">
			<form id="routeForm" method="post">
				<input type="text" name="groupId" value="${tourGroup.id}" />
				<p class="p_paragraph_title">
					<b>行程明细</b>
				</p>
				<div>
					<div class="dd_left">
						线路产品
					</div>
					<div class="dd_right">
						${tourGroup.productBrandName }--${tourGroup.productName }
					</div>
					<div class="clear"></div>
				</div>
				<div>
					<div class="dd_left">
						<i class="red">* </i>天数
					</div>
					<div class="dd_right">
						<input id="daysCount" type="text" class="IptText60" disabled />
					</div>
					<div class="clear"></div>
				</div>
                <div class="pl-20 pr-20 pt-10 pb-30">
                        <input type="hidden" name="productId" value="${productId}"/>
                        <table border="1" cellspacing="0" cellpadding="0" class="w_table">
                            <col width="5%"/>
                            <col width="10%"/>
                            <col width="" style="text-align: left;"/>
                            <col width="10%"/>
                            <col width="15%"/>
                            <col width="15%"/>
                            <thead>
                            <th>天数</th>
                            <th>交通</th>
                            <th>行程描述</th>
                            <th>用餐住宿</th>
                            <th>商家列表</th>
                            <th>图片集</th>
                            </thead>
                            <tbody class="day_content">

                            </tbody>
                        </table>
                        <div class="rote_btn mt-20">
                            <button type="button" class="proAdd_btn button button-action button-small">增加</button>
                        </div>
                        <div class="con_btn">
                            <button class="con_btn1" type="submit">保存</button>
                        </div>
                </div>
			</form>
		</div>
	</div>
    <%@ include file="../template/groupRouteTemplate.jsp"%>
	<script type="text/javascript">
		var path = '<%=path%>';
		var startDate = ${tourGroup.dateStart.time};
	</script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/sales/sales_route.js"></script>
	<script type="text/javascript"
		src="<%=ctx%>/assets/js/web-js/sales/groutRouteAdd.js"></script>
</body>
</html>
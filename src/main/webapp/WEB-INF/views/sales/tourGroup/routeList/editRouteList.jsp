<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="../../../../include/top.jsp"%>
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
<%--<script type="text/javascript" src="<%=ctx%>/assets/js/way.min.js"></script>--%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toGroupOrder()">订单详情</a></li>
			<li><a href="javascript:void(0);" onclick="toGetRouteList()"
				class="selected">行程列表</a></li>
			<li><a href="javascript:void(0);" onclick="toOtherInfo()">其他信息</a></li>
			<li><a href="javascript:void(0);" onclick="togroupRequirement()">计调需求</a></li>
			<li class="clear"></li>
		</ul>
	<div class="p_container_sub">
		<dl class="p_paragraph_content">
			<div style="margin-top: 30px; margin-left: 18px">
				<c:if test="${stateFinance!=1}">
					<button
						class="button button-primary button-small"
						onclick="importRoute(${tourGroup.id})">导入行程</button>
				</c:if>
				<%-- <c:if test="${stateFinance==1}">
					<button disabled="disabled"
						class="button button-primary button-small"
						onclick="importRoute(${tourGroup.id})">导入行程</button>
				</c:if> --%>
			</div>
			<div class="p_container">
		
				<div class="p_container_sub">
					<input type="hidden" id="productId" />
					<form id="routeForm" method="post">
						<input type="hidden" name="tourGroup.id" id="groupId" value="${tourGroup.id}" />
						<input type="hidden" name="orderId" id="orderId" value="${orderId}" />
						<input type="hidden" id="stateFinance" name="" value="${stateFinance}" />
						<input type="hidden" id="state" name="" value="${state}" />
						<p class="p_paragraph_title">
							<b>行程明细</b>
						</p>
						<div>
							<div class="dd_left" style="margin-left:190px;">
								<i class="red">* </i>产品线路
							</div>
							<div class="dd_right">
								<input type="text" name="tourGroup.productBrandName"
									value="${tourGroup.productBrandName }" class="IptText100"/>~<input type="text"
									name="tourGroup.productName" class="IptText300" value="${tourGroup.productName }" />
							</div>
							<div class="clear"></div>
						</div>
						<div class="content1">
							<div id="divTab" class="position_relative">
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
                                    </div>
								<p class="p_paragraph_title">
										<b>备注信息</b>
									</p>
								<dd>
									<div class="dd_left" style="margin-left: 125px;">服务标准</div>
									<textarea class="w_textarea" name="tourGroup.serviceStandard"	class="control-row4 input-large">${tourGroup.serviceStandard}</textarea>
								</dd>
								<dd>
									<div class="dd_left" style="margin-left: 125px;">备注信息</div>
									<textarea class="w_textarea" name="tourGroup.remark"
										class="control-row4 input-large">${tourGroup.remark}</textarea>
								</dd>
								<dd>
									<div class="dd_left" style="margin-left: 125px;">温馨提示</div>
									<textarea class="w_textarea" name="tourGroup.warmNotice"
										class="control-row4 input-large">${tourGroup.warmNotice }</textarea>
								</dd>
								<div class="con_btn">
									<c:if test="${stateFinance!=1}">
										<button class="con_btn1" type="submit">保存</button>
									</c:if>
									<%-- <c:if test="${stateFinance==1}">
										<button class="button button-primary button-small" disabled="disabled">保存</button>
									</c:if> --%>
									<%--<button class = "con_btn2">新增一天</button>--%>
								</div>
		
							</div>
						</div>
		
					</form>
				</div>
			</div>
		</dl>
	</div>
</div>
    <%@ include file="../../template/groupRouteTemplate.jsp"%>

	<script type="text/javascript">
    	var path = '<%=path%>';
		var groupId = '${tourGroup.id}';
		var img200Url = '${config.images200Url}';
		var startDate = ${tourGroup.dateStart.time};
	</script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/sales/sales_route.js"></script>
	<script type="text/javascript"
		src="<%=ctx%>/assets/js/web-js/sales/editRouteList.js"></script>
	<script type="text/javascript"
		src="<%=ctx%>/assets/js/web-js/sales/tourRouteImp.js"></script>
<script type="text/javascript">
function showGuideList(obj){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $(obj).trigger(e);
	}
$(function() {
	$(".bldd").each(function(){
		$(this).autocomplete({
			  source: function( request, response ) {
				  var name=encodeURIComponent(request.term);
				  $.ajax({
					  type : "get",
					  url : "<%=staticPath %>/route/getNameList.do",
					  data : {
						  name : name
					  },
					  dataType : "json",
					  success : function(data){
						  if(data && data.success == 'true'){
							  response($.map(data.result,function(v){
								  return {
									  label : v.name,
									  value : v.name
								  }
							  }));
						  }
					  },
					  error : function(data,msg){
					  }
				  });
			  },
			  focus: function(event, ui) {
				    $(".adress_input_box li.result").removeClass("selected");
				    $("#ui-active-menuitem")
				        .closest("li")
				        .addClass("selected");
				},
			  minLength : 0,
			  autoFocus : true,
			  delay : 300
		});
	});
});
</script>
</body>
</html>
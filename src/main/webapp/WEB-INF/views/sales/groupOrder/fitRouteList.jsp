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
<%--<script type="text/javascript" src="<%=ctx%>/assets/js/way.min.js"></script>--%>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../groupOrder/toFitEdit.htm?groupId=${tourGroup.id}&operType=${operType}">散客团信息</a></li>
			<li><a
				href="../groupRoute/toGroupRoute.htm?groupId=${tourGroup.id}&operType=${operType}"
				class="selected">行程列表</a></li>
			<li><a
				href="../groupOrder/toFitOrderList.htm?groupId=${tourGroup.id}&operType=${operType}">订单列表</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${tourGroup.id}&operType=${operType}">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>
		<div class="p_container_sub">
			<form id="routeForm" method="post">
				<input type="hidden" name="tourGroup.id" value="${tourGroup.id}" />

				<p class="p_paragraph_title">
					<b>行程明细</b>
				</p>
				<div>
					<div class="dd_left" style="margin-left: 188px;">
						<i class="red">* </i>产品线路
					</div>
					<div class="dd_right">
						<input type="text" name="tourGroup.productBrandName"
							placeholder="品牌" value="${tourGroup.productBrandName }"
							class="IptText100" />~<input type="text"
							name="tourGroup.productName" placeholder="名称"
							value="${tourGroup.productName }" class="IptText300" />
					</div>
					<div class="clear"></div>
				</div>
				<div class="content1">
					<div id="divTab" class="position_relative">
                            <div class="pl-20 pr-20 pt-10 pb-30">
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

							<div class="dd_left" style="margin-left: 170px;">服务标准</div>
							<div class="dd_right">
								<textarea name="tourGroup.serviceStandard" class="w_textarea">${tourGroup.serviceStandard}</textarea>
							</div>
							<div class="clear"></div>
						</div>
						<div>
							<div class="dd_left" style="margin-left: 170px;">备注</div>
							<div class="dd_right">
								<textarea name="tourGroup.remark" class="w_textarea">${tourGroup.remark}</textarea>
							</div>
							<div class="clear"></div>
						</div>
						<div>
							<div class="dd_left" style="margin-left: 170px;">内部备注</div>
							<div class="dd_right">
								<textarea name="tourGroup.remarkInternal" class="w_textarea">${tourGroup.remarkInternal}</textarea>
							</div>
							<div class="clear"></div>
						</div>
						<div>
							<div class="dd_left" style="margin-left: 170px;">温馨提示</div>
							<div class="dd_right">
								<textarea name="tourGroup.warmNotice" class="w_textarea">${tourGroup.warmNotice}</textarea>
							</div>
							<div class="clear"></div>
						</div>

						<c:if test="${tourGroup.groupState!=3 and operType==1 }">
							<div class="con_btn">
								<button class="con_btn1" type="submit">保存</button>
								<%--<button class = "con_btn2">新增一天</button>--%>
							</div>
						</c:if>
					</div>
                    </form>
				</div>
		</div>
    <%@ include file="../template/groupRouteTemplate.jsp"%>

	<script type="text/javascript">
    	var path = '<%=path%>';
		var groupId = '${tourGroup.id}';
		var img200Url = '${config.images200Url}';
		var startDate = ${tourGroup.dateStart.time};
	</script>
	<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/sales/sales_route.js"></script>
	<script type="text/javascript"
		src="<%=ctx%>/assets/js/web-js/sales/groutRouteEdit.js"></script>
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
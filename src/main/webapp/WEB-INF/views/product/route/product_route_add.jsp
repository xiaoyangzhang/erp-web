<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../../include/top.jsp" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>行程</title>
    <link href="<%=ctx%>/assets/css/product/product_rote.css" rel="stylesheet"/>
    <script type="text/javascript" src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
    <style type="text/css">
    .t_area{

overflow-y:visible
} 
</style>
</head>
<body>
<div class="p_container">
    <ul class="w_tab">
        <li><a href="<%=ctx %>/productInfo/edit.htm?productId=${productId}">基本信息</a></li>
        <li><a href="<%=ctx %>/productInfo/route/view.htm?productId=${productId}" class="selected">行程列表</a></li>
        <li><a href="<%=ctx %>/productInfo/tag/view.htm?productId=${productId}">标签属性</a></li>
        <li><a href="<%=ctx %>/productInfo/remark/view.htm?productId=${productId}">备注信息</a></li>
        <%--<li><a href="<%=ctx %>/productInfo/price/list.htm?productId=${productId }">价格设置</a></li>--%>
        <li class="clear"></li>
    </ul>
    <div class="p_container_sub">

        <p class="p_paragraph_title"><b>行程明细</b></p>

        <div class="pl-20 pr-20 pt-10 pb-30">
            <form id="routeForm" onsubmit="return false;" method="post">
                <input type="hidden" name="productId" value="${productId}"/>
                <table border="1" cellspacing="0" cellpadding="0" class="w_table">
                    <col width="5%"/>
                    <col width="10%"/>
                    <col width="" style="text-align: left;"/>
                    <col width="8%"/>
                    <col width="10%"/>
                    <col width="8%"/>
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
                <p class="p_paragraph_title">
						<b>备注信息</b>
					</p>
					<dd>
						<div>
						<div  style="margin-left: 25px;">服务标准</div>
						<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.serveLevel"
							class="control-row4 input-large"></textarea>
							<div class="clear"></div>
						</div>
					</dd>
					<dd>
						<div>
						<div style="margin-left: 25px;">备注信息</div>
						<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.remarkInfo"
							class="control-row4 input-large"></textarea>
						<div>
					</dd>
					<dd>
						<div>
						<div style="margin-left: 25px;">温馨提示</div>
						<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.warmTip"
							class="control-row4 input-large"></textarea>
						<div>
					</dd>
                <div class="con_btn">
                    <button class="con_btn1" type="submit">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="productRouteTemplate.jsp"%>
<script type="text/javascript">
    var path = '<%=path%>';
</script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_route.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_route_add.js"></script>
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
					  type : "post",
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
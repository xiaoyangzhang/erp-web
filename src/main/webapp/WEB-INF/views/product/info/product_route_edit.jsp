<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="<%=ctx%>/assets/css/product/product_rote.css" rel="stylesheet"/>
<p class="p_paragraph_title"><b>行程明细</b></p>
<div class="pl-20 pr-20 pt-10 pb-30">
        <input type="hidden" name="productId" value="${productId}"/>
        <input type="hidden" name="productRemark.id" value="${productRemark.id}"/>
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
</div>
<div class="clear"></div>
<p class="p_paragraph_title"><b>备注信息</b></p>
<dl class="p_paragraph_content">
<dd>
 		<div class="dd_left">服务标准</div> 
 		<div class="dd_right"> 
 			<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.serveLevel" class="control-row4 input-large">${ productRemark.serveLevel}</textarea>
 		</div>
		<div class="clear"></div>
</dd>
<dd>
	<div class="dd_left">备注信息</div>
	<div class="dd_right">
		<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.remarkInfo" class="control-row4 input-large">${productRemark.remarkInfo }</textarea>
	</div>
	<div class="clear"></div>
</dd>
<dd>
	<div class="dd_left">温馨提示</div>
	<div class="dd_right"> 
			<textarea style="margin-left: 25px;" class="w_textarea t_area" name="productRemark.warmTip" class="control-row4 input-large">${ productRemark.warmTip}</textarea>
	</div>
	<div class="clear"></div>
</dd>
</dl>


<%@ include file="../route/productRouteTemplate.jsp"%>
<script type="text/javascript">
    var path = '<%=path%>';
    var productId = '${productId}';
    var img200Url = '${config.images200Url}';
</script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_route.js"></script>
<script type="text/javascript" src="<%=ctx %>/assets/js/web-js/product/product_route_edit.js"></script>
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
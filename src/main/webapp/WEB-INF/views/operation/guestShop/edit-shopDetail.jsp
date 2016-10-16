<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	 <div class="p_container" >
	  

	    <div class="p_container_sub" id="tab1">
	    	<form id="saveShopDetailForm">
	    	<p class="p_paragraph_title"><b>添加明细</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">商品：</div> 
	    			<div class="dd_right">
	    					<input type="hidden" name="bookingId" value="${shopDetail.bookingId }">
	    					<input type="hidden" name="id" value="${shopDetail.id }">
	    					<input type="hidden" name="goodsName" id = "goodsName">
	    					<select name="goodsId" id="goodsId">
	    						<option value="">请选择</option>
							<c:forEach items="${dic}" var="d">
								<option value="${d.id}" <c:if test="${shopDetail.goodsId eq d.id }">selected</c:if> >${d.value}</option>
							</c:forEach>
						</select>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">金额：</div> 
	    			<div class="dd_right">
	    				<input  type="text" id="buyTotal" name="buyTotal"  value="<fmt:formatNumber value="${shopDetail.buyTotal }" pattern="0.00" type="number"/>" class="IptText300">
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>

	    	
            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            <button  type="submit" class="button button-primary button-small">保存</button>
            <a href="toFactShop.htm?id=${shopDetail.bookingId }&groupId=${groupId}" class="button button-primary button-small">返回</a>
            </div>
            </div>    
            </form>	
          
			
	    </div>
     
        
    </div>
</body>



<script type="text/javascript">

$(function(){
	$("#goodsId").change(function(){
		$("#goodsName").val(($("#goodsId  option:selected").text()));
	});
	/*提交**/
	$("#saveShopDetailForm").validate(
			{
				rules:{
					
					'buyTotal' : {
						required : true,
						isDouble:true
					}
				},
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
						url : "saveShopDetail.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							
							if (data.success) {
								$.success('操作成功',function(){
									window.location.href="toFactShop.htm?id=${shopDetail.bookingId }&groupId=${groupId}";
								});
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	

});



</script>

</html>

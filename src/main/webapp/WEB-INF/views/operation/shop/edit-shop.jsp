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
	    	<form id="saveShopForm">
	    	<p class="p_paragraph_title"><b>分配购物店</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">购物店：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="id" value="${shop.id }"/>
	    				<input type="hidden" name="groupId"" value="${groupId }"/>
	    				<input type="hidden" name="personNum" value="${tourGroup.totalAdult }"/>
	    				<input  type="hidden" id="supplierId" name="supplierId"  value="${shop.supplierId }" class="IptText300">
	    				<input type="text" <c:if test="${isEdit != 'edit'}">readonly="readonly"</c:if>  id="supplierName" name="supplierName"  value="${shop.supplierName }" class="IptText300">
	    				<c:if test="${isEdit == 'edit'}"><a href="javascript:void(0);" onclick="selectSupplier()">请选择</a> </c:if>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
                <dd>
	    			<div class="dd_left">进店日期：</div> 
	    			<div class="dd_right">
	    			<input type="text" readonly="readonly" name="shopDate" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${shop.shopDate }" />
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<!-- <input type="text" id="guideMobile" name="guide.guideMobile" value="" class="IptText300"> -->
	    					<select name="guideId">
	    						<option value="">请选择</option>
							<c:forEach items="${guides}" var="g">
									<option value="${g.guideId}"  <c:if test="${g.guideId eq shop.guideId }">selected="selected"</c:if>>${g.guideName}</option>
							</c:forEach>
						</select>
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>

	    	
            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            <c:if test="${groupCanEdit }"><button  type="submit" class="button button-primary button-small">保存</button></c:if>
             <a href="javascript:history.go(-1);" class="button button-primary button-small">返回</a>
            </div>
            </div>    
            </form>	
          
			
	    </div>
     
        
    </div>
</body>



<script type="text/javascript">

$(function(){
	/*提交**/
	$("#saveShopForm").validate(
			{
				rules:{
					'supplierName' : {
						required : true
					},
					'shopDate':{
						required : true
					}/* ,
					'guideId':{
						required : true
					} */
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
						url : "saveShop${source}.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							
							if (data.success) {
								$.success('操作成功',function(){
									window.location.href="to${source}BookingShopView.htm?groupId=${groupId }&type=1";
								});
							} else {
								$.error(data.msg);

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error('服务忙，请稍后再试');
						}
					};
					
					jQuery.ajax({
						url : "../tourGroup/validatorSupplier.htm",
						type : "post",
						async : false,
						data : {
							"supplierId" : $("#supplierId").val(),
							"supplierName":$("#supplierName").val()
						},
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$(form).ajaxSubmit(options);
							}else{
								$.warn(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus, errorThrown) {
							$.error(textStatus);
							window.location = window.location;
						}
					});
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
});
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择购物店',
		content : '<%=path%>/component/supplierList.htm?type=single&supplierType=6',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择购物店");
				return false;
			}
			for(var i=0;i<arr.length;i++){
//				console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
				$("#supplierId").val(arr[i].id);
				$("#supplierName").val(arr[i].name);
			}
	    }
	});
}

</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath%>/tourGroup/getSupplier?supplierType=6", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
        
    } 
</script>
</html>

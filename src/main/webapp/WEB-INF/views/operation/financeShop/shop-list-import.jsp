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
<title></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>

<script type="text/javascript" src="<%=ctx %>/assets/js/utils/float-calculate.js"></script>
</head>
<body>
 <div class="p_container" >
      <div id="tabContainer">
	    <div class="p_container_sub" id="list_search">
			<form id="importExcl" action="" method="post" enctype="multipart/form-data">
				<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left">购物店：</div> 
		    			<div class="dd_right">
		    				<input type="hidden" name="id" value="${shop.id }"/>
		    				<input type="hidden" name="groupId" value="${groupId }"/>
		    				<input  type="hidden" id="supplierId" name="supplierId"  value="${shop.supplierId }" class="IptText300">
		    				<input  type="text" id="supplierName" name="supplierName"  value="${shop.supplierName }" class="IptText300">
		    				<c:if test="${view ne 1 }">
		    				<a href="javascript:void(0);" onclick="selectSupplier()" class="button button-primary button-small">请选择</a></c:if>
		    			</div>
						<div class="clear"></div>
		    		</dd> 
	    		</dl>
	    		
	    		<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left">Excel文件：</div> 
		    			<div class="dd_right">
	    					<input type="file" name="file" id="file" value="浏览"/>
		    				<input type="submit" name="submit" class="button button-primary button-small" value="提交" >
		    			</div>
						<div class="clear"></div>
		    		</dd> 
	    		</dl>
	    		
	    		<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left">日志：</div> 
		    			<div class="dd_right" >
 		    				<textarea rows="20" cols="130" id="rizhi"> 
 		    				
 		    				
 		    				</textarea> 
		    			</div>
						<div class="clear"></div>
		    		</dd> 
	    		</dl>
				
			</form>
	    	
        </div>
        
        
      </div><!--#tabContainer结束-->
    </div>
       
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript">
//if($("#supplierId").val()){
//	selectItems();
//}
var priceData = new Array();
var actualRepays=new Array();
	
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择购物店',
		content : '<%=ctx%>/component/supplierList.htm?type=single&supplierType=6',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择购物店");
				return false;
			}
				$("#supplierId").val(arr[0].id);
				$("#supplierName").val(arr[0].name);
				selectItems();
		
	    }
	});
}
function selectItems(){
	var goodsObj=$("select[name='goodsId']");
	if(goodsObj!=null&&goodsObj.length>0){
	goodsObj.empty();
	goodsObj.each(function(){
		$(this).append("<option value='' selected>请选择</option>")
	})
	
	
	}
	$.ajax({
        type: "post",
        cache: false,
        url: "<%=ctx%>/booking/selectItems.htm",
        data: {
       	 supplierId:$("#supplierId").val()
        },
        dataType: 'json',
        async: false,
        success: function (data) {
       	 for (var i = 0; i < data.length; i++) {
       		 var item = data[i];
       		 
       		 goodsObj.append('<option value="'+item.id+'" >'+item.itemName+'</option>');
}
	 
}
}); 
}

$(function() {
	$("#importExcl").validate({
		rules:{
			'supplierName':{
				required : true
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
				url : "importExcel.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if(data.success){
						console.log(data.guestString);
						data.guestString = data.guestString.replace(/\"/g, "");
						data.guestString = data.guestString.replace(/\\r\\n/g, "\n");
						console.log(data.guestString);
						$("#rizhi").val(data.guestString);
					}else{
						$.warn(data.msg);
					}
				},
				error : function(data) {
					$.warn(data.msg);
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
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
     $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=6", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
    	selectItems();
    }  
</script>
</html>

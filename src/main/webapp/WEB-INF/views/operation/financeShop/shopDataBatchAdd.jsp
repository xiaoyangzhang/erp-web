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
<script type="text/javascript">
function selectShop(){
	layer.openSupplierLayer({
		title : '选择购物店',
		content : '<%=path%>/component/supplierList.htm?supplierType=6',
		callback: function(arr){
			if(arr.length==0){ $.warn("请选择购物店 "); return false;}
			$("input[name='supplierName']").val(arr[0].name);
			$("input[name='supplierId']").val(arr[0].id);
	    }
	});
}
function importExcel(){
	if (!$("#file").val()) {
		$.warn("请选择要导入的文件");
		return false;
	}
	var options={
		url:"saveShopData.do",
		type:"post",
		dataType:"json",
		success:function(data){
			if(data.success){
				$.success("导入成功");
				window.setTimeout(function(){
					refreshWindow("导入购物店数据", "<%=path%>/bookingFinanceShop/batchAdd.htm");
				}, 1000);
			}
		},
		error:function(data,msg){
			$.error("服务器忙，请稍后再试");
		}
	};
	$("#saveShopDataForm").ajaxSubmit(options);
}
</script>
<style type="text/css">
    .t_area{

overflow-y:visible
} 
</style>
</head>
<body>
<div class="p_container" >
<form id="saveShopDataForm" method="post" enctype="multipart/form-data" target="upframe">
<div class="p_container_sub" id="tab1">
	<p class="p_paragraph_title"><b>批量录入购物店信息</b></p>
	<dl class="p_paragraph_content">

	<dd id="ddShopSupplier">
	<div class="dd_left"><i class="red">* </i>购物店：</div> 
	<div class="dd_right">
		<input type="text" name="supplierName" value="" class="IptText300"  />
		<input type="hidden" name="supplierId" value="" />
		<input type="button" class="button button-primary button-small" value="选择" onclick="selectShop()" id="shop"/>
	</div>
	<div class="clear"></div>
	</dd>
	<dd id="ddFilePath">
	<div class="dd_left"><i class="red">* </i>excel文件：</div> 
	<div class="dd_right">
		 <input type='text' name='filepath' id='filepath' class="IptText300">

	 <input type='file' name='file' id='file'   onchange="document.getElementById('filepath').value=this.value;"> 
	
	</div>
	<div class="clear"></div>
	</dd>
	</dd>
	<dd >
	<div class="dd_left">导入日志：</div> 
	<div class="dd_right">
		<textarea class="t_area" name="logInfo" id="logInfo"></textarea>
	</div>
	<div class="clear"></div>
	</dd>
	</dl>
	<iframe  id="upframe" name="upframe" src="" style="display:none;"></iframe>
	 <button style="margin-left:15px;" type="submit" onclick="importExcel()"  class="button button-primary button-small" >开始导入</button>
	<a href="javascript:closeWindow()" class="button button-small">关闭</a> 
</div>
</form>	
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
<link href="<%=staticPath%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=staticPath%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
   <%--  $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=3", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
        
    }  --%>
</script>
</body>
</html>
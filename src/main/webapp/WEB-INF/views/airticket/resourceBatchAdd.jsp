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

<%@ include file="../../include/top.jsp"%>
<script type="text/javascript">
function selectAir(){
	
	var supplierType = $("input[type='radio']:checked").val() == "AIR" ? 9 : 10;
	layer.openSupplierLayer({
		title : '选择机票',
		content : '<%=path%>/component/supplierList.htm?supplierType='+ supplierType,
		callback: function(arr){
			if(arr.length==0){ $.warn("请选择商家 "); return false;}
			$("input[name='ticketSupplier']").val(arr[0].name);
			$("input[name='ticketSupplierId']").val(arr[0].id);
	    }
	});
}
function importExcel(){
	if (!$("#file").val()) {
		$.warn("请选择要导入的文件");
		return false;
	}
	var options={
		url:"saveAirTicketResourceForm",
		type:"post",
		dataType:"json",
		success:function(data){
			if(data.success){
				$.success("导入成功");
				window.setTimeout(function(){
					refreshWindow("导入机票资源", "<%=path%>/airticket/resource/batchAdd.htm");
				}, 1000);
			}
		},
		error:function(data,msg){
			$.error("服务器忙，请稍后再试");
		}
	};
	$("#saveAirTicketResourceForm").ajaxSubmit(options);
}
</script>
</head>
<body>
<div class="p_container" >
<form id="saveAirTicketResourceForm" method="post" enctype="multipart/form-data" target="upframe">
<div class="p_container_sub" id="tab1">
	<p class="p_paragraph_title"><b>批量输入机票信息</b></p>
	<dl class="p_paragraph_content">

	<dd>
		<div class="dd_left">资源类型</div> 
	    <div class="dd_right"><input type="radio" id="rb_type_air" name="type" value="AIR" checked="checked"/><label for="rb_type_air">机票</label> &nbsp;&nbsp;&nbsp;&nbsp;
	    		<input type="radio" id="rb_type_train" name="type" value="TRAIN"/><label for="rb_type_train">火车票</label></div>
		<div class="clear"></div>
	</dd> 
	<dd id="ddTicketSupplier">
	<div class="dd_left"><i class="red">* </i>机票供应商</div> 
	<div class="dd_right">
		<input type="text" name="ticketSupplier" value="${resource.po.ticketSupplier }" class="IptText300" readOnly="readonly" />
		<input type="hidden" name="ticketSupplierId" value="${resource.ticketSupplierId }" />
		<input type="button" class="button button-primary button-small" value="选择" onclick="selectAir()" id="air"/>
	</div>
	<div class="clear"></div>
	</dd>
	<dd id="ddFilePath">
	<div class="dd_left"><i class="red">* </i>文件</div> 
	<div class="dd_right">
		 <input type='text' name='filepath' id='filepath' class="IptText300">

	 <input type='file' name='file' id='file'   onchange="document.getElementById('filepath').value=this.value;"> 
	 <!-- <input type='file' name='file' id='file'  > -->
	
	</div>
	<div class="clear"></div>
	</dd>
	</dl>
	<iframe  id="upframe" name="upframe" src="" style="display:none;"></iframe>
	 <button style="margin-left:15px;" type="submit" onclick="importExcel()"  class="button button-primary button-small" >导入</button>
	<a href="javascript:closeWindow()" class="button button-small">关闭</a> 
</div>
</form>	
</div>
<!-- TODO: 各旅行社小部门的配额设置 -->
<!-- TODO: 显示已经被预定的数量 -->
</body>
</html>
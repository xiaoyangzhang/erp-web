<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增签证信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<%
String path = request.getContextPath();
%>
<link href="<%=ctx%>/assets/css/product/product_rote.css"
	rel="stylesheet" />
<style type="text/css">


.searchTab {
	width: 100%;
}

.searchTab tr td {
	height: 25px;
	padding: 6px;
}

.searchTab tr td:nth-child(odd) {
	min-width: 80px;
	text-align: right;
}

.searchTab tr td:nth-child(even) {
	min-width: 100px;
}

</style>
</head>
<body class="blank_body_bg">
<div class="p_container">
		<div class="p_container_sub" id="tab1">
	<form id="SpecialGroupOrderForm">
	<input type="hidden" name="orderMode" id="orderMode" value="${orderMode }">
	<input type="hidden" name="orderId" id="orderId" value="${orderId }">
		<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup
			<tr>
				<td>物流公司:</td>
				<td>
					<input name="physicalCompany" id="physicalCompany" value="${orderBean.companyName }" type="text"> 
				</td>
				
				<td>快递单号:</td>
				<td>
					<input name="expressOrderNo" id="expressOrderNo"  value="${orderBean.expressOrderNo }" type="text"> 
				</td>
			</tr>
			<tr>
				<td>拍下日期:</td>
				<td>
					<input  name="patTime" id="patTime"  type="text"  class="Wdate" value="${orderBean.patTime }"
						onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 143px;"/>
				</td>
				
				<td>收件日期:</td>
				<td>
					<input name="receiptTime" id="receiptTime"  type="text"  value="${orderBean.receiptTime }" 
						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 143px;"/>
				</td>
			</tr>
			<tr>
				<td>送签日期:</td>
				<td>
					<input name="sendSignTime" id="sendSignTime"  type="text" value="${orderBean.sendSignTime }"  
						class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 143px;"/>
				</td>
				
				<td>发件日期:</td>
				<td>
					<input name="sendTime" id="sendTime"  type="text"  class="Wdate" value="${orderBean.sendTime }" 
						onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width: 143px;"/>
				</td>
			</tr>
		</table>
		
	</form></div></div>
	<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
			<button type="button" onclick="saveVisaInfo()" class="button button-primary button-small">保存</button>
			<button type="button" onclick="closeVisa()" class="button button-primary button-small">取消</button>
		</div>
</body>
<script type="text/javascript">
/* 保存 */
function saveVisaInfo(){
	var orderMode = $("#orderMode").val();
	var orderId = $("#orderId").val();
	var physicalCompany = $("#physicalCompany").val();
	var expressOrderNo = $("#expressOrderNo").val();
	var patTime = $("#patTime").val();
	var receiptTime = $("#receiptTime").val();
	var sendSignTime = $("#sendSignTime").val();
	var sendTime = $("#sendTime").val();
	
	var countStr = physicalCompany+"@"+expressOrderNo+"@"+
		patTime+"@"+receiptTime+"@"+
		sendSignTime+"@"+sendTime;
	//alert("countStr="+countStr);
	
	$.ajax({
		url:"<%=path%>/taobao/saveVisaInfo.do",
		type:"post",
		dataType:"json",
		async:false,
		data:{orderId:orderId,orderMode:orderMode,countStr:countStr},
		success:function(data){
			if(data.success){
				$.success('添加成功！', function(){
					var index = parent.layer.getFrameIndex(window.name);
					parent.layer.close(index);
					
				});
			}
			else{
				$.error("保存失败！");
			}
		},
		error:function(){
			$.errorR("服务器忙，请稍后再试");
		}
	})	
	
	
}

/* 取消 */
function closeVisa(){
	var index = parent.layer.getFrameIndex(window.name);
	parent.layer.close(index);
}
</script>
</html>

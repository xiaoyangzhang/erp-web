<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../include/top.jsp"%>
<%
	String path = ctx;
%>
<style type="text/css">
	#span_id{
		color: red;
	}
</style>
</head>
<body class="blank_body_bg">
<form id="saveResourceForm" style="margin-left: 10px;">
	 <div class="p_container blank_page_bg"  >
	    	<dl class="p_paragraph_content">
				<input type="hidden" name="orderId"value="${go.id}" />
				<input type="hidden" name="supplierId"value="${go.supplierId}" />
				<input type="hidden" name="supplierName"value="${go.supplierName}" />
				<p class="bill_head">
					<b>订单金额：<span id="span_id"><fmt:formatNumber value="${go.total}" pattern="#.##"/></span>
						已收：<span id="span_id"><fmt:formatNumber value="${go.totalCash}" pattern="#.##"/></span>
						尾款：<span id="span_id"><fmt:formatNumber value="${go.total-go.totalCash}" pattern="#.##"/></span>
					</b>					
				</p>
	    		<dd>
	    			<div class="dd_left">收款类型:</div>
					<div class="dd_right">
						<select id="payType" name="payType" style="width: 150px;">
							<option value="定金">定金</option>
							<option value="尾款">尾款</option>
						</select>
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">金额:</div>
					<div class="dd_right">
						<input type="text" name="cash" value="${0}">
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    
	    		<dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    				<textarea id="remark" class="w_textarea" style="width:220px !important;" 
	    					name="remark"></textarea>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
            </dl>

            <div class="Footer">
	            <dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left"></div> 
		    			<div class="dd_right">
	            			<button  type="submit" class="button button-primary button-small">确定</button>
						</div>
					</dd>
				</dl>
		 	</div>
		</div>
	</form>
</body>
<script type="text/javascript">
var index = parent.layer.getFrameIndex(window.name);
var path = '<%=path%>';
$("#saveResourceForm").validate({
	submitHandler : function(form) {
				var options = {
					url : " makeCollections.do",
					type : "post",
					dataType : "json",
				       success: function (data) {
			        		parent.reloadPage();
						},
						error: function () {
							alert("收款失败");
						}
				};
				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
</script>
</html>

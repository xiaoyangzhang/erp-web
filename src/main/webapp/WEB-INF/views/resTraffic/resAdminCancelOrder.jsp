<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>取消订单</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
#textarea_id{
margin:3% 3%;
}
</style>
</head>
<body>
	<dl class="p_paragraph_content">
		<form id="saveResProductForm" style="text-align: center;">
			<input type="hidden" name="id" value="${orderId }" id="order_id" />
			<dd class="inl-bl">
				<div class="dd_right" id="text_id">
					<label>请选择你取消订单的原因：</label>
				</div>
				<div class="clear"></div>
				<div class="dd_right"  id="textarea_id">
					<label><select name="cause" id="cause_id">
							<option value="0">信息填写错误</option>
							<option value="1">下错单</option>
							<option value="2">客户取消了行程</option>
							<option value="3">其他原因</option>
					</select></label>
				</div>
				<div class="clear"></div>
				<div class="dd_right" id="textarea_id">
					<label>
						<textarea class="l_textarea_mark" name="remark" rows="10" cols="50"
							placeholder="备注信息"></textarea></label>
				</div>
		</form>
	</dl>
	<div class="pl-10 pr-10"
		style="padding-bottom: 1%; text-align: center;">
		<button type="button" onclick="cancelOrderOK()"
			class="button button-primary button-small">确定</button>

		<button type="button" onclick="closeWindow()"
			class="button button-primary button-small">取消</button>

	</div>
</body>
<script type="text/javascript">
	function cancelOrderOK(){
		var cause = $("#cause_id").val();
		var remark = $(".l_textarea_mark").val();
		var order_id = $("#order_id").val();
		//alert("cause="+cause+",remark="+remark);
		var causeRemark = "【"+cause+","+remark+"】";
		$.ajax({
			type : "post",
			url : "<%=path%>/resOrder/toUpdateAdminExtResState.do",
			data:{id:order_id,causeRemark:causeRemark},
			dataType : "json",
			success : function(data) {
				if (data && data.success == '1') {
					//刷新页面
					parent.reloadPage();
				}
			},
			error : function() {
				alert('系统异常，请与管理员联系');
			}
		});
	}
</script>

</html>
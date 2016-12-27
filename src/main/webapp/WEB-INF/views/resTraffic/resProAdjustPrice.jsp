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
<title>调整产品价格</title>
<%@ include file="../../include/top.jsp"%>
</head>
<body>
	<!-- <dl class="p_paragraph_content" style="margin: 2% 2% 2% 1%;">
		<label>批量调整</label>
	</dl>
	<hr> -->
	<dl class="p_paragraph_content">
		<form id="saveResProductForm" style="text-align: center;">
			<input type="hidden" name="id" value="${setId }" id="setId"/>
			<input type="hidden" name="resourceId" value="${resId }" id="resourceId"/>
			<dd class="inl-bl">
				<div class="dd_right" id="wrap">
					<label class="radio" ><input id="adjust_id" type="radio" name="adjustId" value="0" checked>调整成本价 </label>&nbsp;&nbsp;&nbsp;
					<label class="radio" ><input id="adjust_id" type="radio" name="adjustId" value="1">调整零售价 </label>&nbsp;&nbsp;&nbsp;
					<label class="radio" ><input id="adjust_id" type="radio" name="adjustId" value="2" />调整同行返款 </label>&nbsp;&nbsp;&nbsp;
					<label class="radio" ><input id="adjust_id" type="radio" name="adjustId" value="3" />调整代理返款</label>
				</div>
				<div class="clear"></div>
				<div class="dd_right" id="adjust_uprodown">
					<label class="radio" ><input id="adjust" type="radio" name="adjustUpOrDown" value="0" checked />统一上调 </label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="radio" ><input id="adjust" type="radio" name="adjustUpOrDown" value="1" />统一下调</label>
				</div>
				<div class="clear"></div>
				<div class="dd_right">
					<label>调整金额：<input id="adjust_price" type="text" name="AdjustPrice" value="" /></label>
				</div>
				<div class="clear"></div>
		</form>
	</dl>
	<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
					<button type="button" onclick="updatePrice()" class="button button-primary button-small">确定</button>
					<button type="button" onclick="closePop()" class="button button-primary button-small">取消</button>
			</div>
</body>
<script type="text/javascript">
	function updatePrice(){
		var val_adjust_id = $('#wrap input[name="adjustId"]:checked ').val();
		var val_adjust_uprodown = $('#adjust_uprodown input[name="adjustUpOrDown"]:checked ').val();
		var var_price = $("#adjust_price").val();
		var var_set_id = $("#setId").val();
		if( var_price.length == 0 || isNaN(var_price)) {
		    $.error("请输入数值类型的金额");
		    return false;
		}
		$.ajax({
			type : "post",
			url : "<%=path%>/resTraffic/toUpdateProductPrice.do",
			data:{id:var_set_id,suggest_price_id:val_adjust_id,adjust_uprodown_num:val_adjust_uprodown,price:var_price, resId:${resId }},
			dataType : "json",
			success : function(data) {
				$.success('操作成功',function(){
					layer.closeAll();
					parent.location.reload();
				});
			},
			error : function() {
				alert('系统异常，请与管理员联系');
			}
		});
		
	}
	function closePop(){
		var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
		parent.layer.close(index);
	}
	
</script>

</html>
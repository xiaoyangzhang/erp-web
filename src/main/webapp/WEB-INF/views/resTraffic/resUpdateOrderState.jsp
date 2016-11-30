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
<title>订单状态修改</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
	#la_state{
		font-weight: bold;
	}
</style>
</head>
<body>
	<dl class="p_paragraph_content">
		<form id="saveResProductForm" style="text-align: center;">
			<!-- 订单id -->
			<input type="hidden" name="id" value="${id }" id="orders_id"/>
			<dd class="inl-bl">
				<div class="dd_right" id="wrap">
					<label id="la_state">修改状态：</label>
					<c:choose>
						<c:when test="${extResPrepay > totalCash &&  extResState=='0'}">
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
						</c:when>
						<c:when test="${extResPrepay > totalCash &&  extResState=='2'}">
							<label class="radio" ><input id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
						</c:when>
						<c:when test="${extResPrepay > totalCash &&  extResState=='3'}">
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
						</c:when>
						
						<c:when test="${extResPrepay <= totalCash &&  extResState=='0'}">
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
							
						</c:when>
						<c:when test="${extResPrepay <= totalCash && extResState=='2'}">
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
						</c:when>
						<c:when test="${extResPrepay <= totalCash &&  extResState=='3'}">
							<label class="radio" ><input  id="extResState_id" type="radio" name="extResState" value="0">待确认 </label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="1">已确认</label>&nbsp;&nbsp;&nbsp;
							<label class="radio" ><input  disabled="disabled" id="extResState_id" type="radio" name="extResState" value="2">取消订单</label>&nbsp;&nbsp;&nbsp;
						</c:when>
						<c:otherwise>
							<span>该订单已确认！</span>
						</c:otherwise>
					</c:choose>
					
				</div>
				<div class="clear"></div>
			</dd>
		</form>
	</dl>
	<div class="pl-10 pr-10" style="padding-bottom: 1%; text-align: center;">
		<c:choose>
			<c:when test="${extResState=='1'}">
				<button type="button" disabled="disabled" onclick="updateState()" class="button button-primary button-small">确定</button>
				<button type="button" onclick="closePop()" class="button button-primary button-small">取消</button>
			</c:when>
			<c:otherwise>
				<button type="button" onclick="updateState()" class="button button-primary button-small">确定</button>
				<button type="button" onclick="closePop()" class="button button-primary button-small">取消</button>
			</c:otherwise>
		</c:choose>
	</div>
</body>
<script type="text/javascript">
	function updateState(){
		var val_extResState_id = $('#wrap input[name="extResState"]:checked ').val();
		var var_order_id = $("#orders_id").val();
		$.ajax({
			type : "post",
			url : "<%=path%>/resOrder/toUpdateExtResState.do",
			data:{id:var_order_id,extResState:val_extResState_id},
			dataType : "json",
			success : function(data) {
				parent.reloadPage();
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
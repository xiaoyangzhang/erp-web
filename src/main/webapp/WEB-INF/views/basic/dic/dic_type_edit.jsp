<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html>
<html>
<head>
    <title></title>
	<%@ include file="../../../include/top.jsp"%>   
</head>
<body>
<div class="p_container_sub">
	<p class="p_paragraph_title"><b>编辑字典类型</b></p>
	<form action="submitDicType.do" method="post" class="definewidth m20" >
	<input type="hidden" name="id" value="${type.id}" />
	<dl class="p_paragraph_content">
		<dd>
			<div class="dd_left">字典类型</div> 		
			<div class="dd_right">
				${parentType.value } <input type="hidden" name="pid" value="${type.pid }"/>
           	</div>
			<div class="clear"></div>						
		</dd>
		<dd>
			<div class="dd_left"><i class="red">* </i>类型编码</div> 		
			<div class="dd_right">
				<input type="text" name="code" class="IptText300" placeholder="编码" value="${type.code }"/>
			</div>
			<div class="clear"></div>						
		</dd>
		<dd>
				<div class="dd_left"><i class="red">* </i>类型值</div> 		
				<div class="dd_right">
					<input type="text" name="value" class="IptText300" placeholder="值" value="${type.value }"/>
				</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"><i class="red">* </i>排序</div> 		
				<div class="dd_right">
					<input type="text" name="orderId" class="IptText300" placeholder="排序" value="${type.orderId }"/>
				</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"></div> 		
				<div class="dd_right">
					<button type="submit" class="button button-primary button-small" type="button" id="btnSave">保存</button> &nbsp;&nbsp;
					<button type="button" class="button button-primary button-small" name="backid" id="backid">返回列表</button>
				</div>
				<div class="clear"></div>						
			</dd>
		</dl>
		</form>
		</div>
<script>
    $(function () {
		$('#backid').click(function(){
			window.location.href="dicTypeList.htm?pid=${type.pid }";
		 });	
		
    });
</script>
</body>
</html>
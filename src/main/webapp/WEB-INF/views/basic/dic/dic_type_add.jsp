<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta charset="UTF-8">
    <%@ include file="../../../include/top.jsp"%> 
</head>
<body>
<div class="p_container_sub">
		<p class="p_paragraph_title"><b>新增字典类型</b></p>
		<form action="submitDicType.do" method="post">
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">父类型</div> 		
				<div class="dd_right">
					${parentType.value }<input type="hidden" name="pid" value="${parentType.id }"/>
            	</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"><i class="red">* </i>类型编码</div> 		
				<div class="dd_right">
					<input type="text" name="code" class="IptText300" placeholder="编码"/>
				</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"><i class="red">* </i>类型值</div> 		
				<div class="dd_right">
					<input type="text" name="value" class="IptText300" placeholder="值"/>
				</div>
				<div class="clear"></div>						
			</dd>
			<dd>
				<div class="dd_left"><i class="red">* </i>排序</div> 		
				<div class="dd_right">
					<input type="text" name="orderId" class="IptText300" placeholder="排序"/>
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
		</form>	

    </div>

</body>
</html>
<script>
    $(function () {
		$('#backid').click(function(){
			window.location.href="dicTypeList.htm?pid=${parentType.id }";
		 });
    });
</script>
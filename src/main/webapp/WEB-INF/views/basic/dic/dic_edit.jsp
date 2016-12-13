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
	<form action="submitDic.do" method="post" >
	<p class="p_paragraph_title"><b>编辑字典信息</b></p>
	<input type="hidden" name="id" value="${dic.id}" />
	<input type="hidden" name="bizId" value="${dic.bizId}" />
	<dl class="p_paragraph_content">
		<dd>
			<div class="dd_left">字典类型</div> 		
			<div class="dd_right">
				${type.value }<input type="hidden" name="typeId" value="${type.id }"/>
           		<input type="hidden" name="typeCode" value="${type.code }"/>
           	</div>
			<div class="clear"></div>						
		</dd>
		<dd>
			<div class="dd_left">字典code</div> 		
			<div class="dd_right">
				<input type="text" name="code" value='${dic.code }'  class="IptText300"/>
           	</div>
			<div class="clear"></div>						
		</dd>
		<dd>
			<div class="dd_left">字典value</div> 		
			<div class="dd_right">
				<input type="text" name="value" value='${dic.value }'  class="IptText300"/>
           	</div>
			<div class="clear"></div>						
		</dd>
		<dd>
			<div class="dd_left">排序</div> 		
			<div class="dd_right">
				<input type="text" name="orderId" value="${dic.orderId }"  class="IptText300"/>
           	</div>
			<div class="clear"></div>						
		</dd>
		<dd>
			<div class="dd_left"></div> 		
			<div class="dd_right">
				<c:if test="${share==0 }">
					<button type="submit" class="button button-primary button-small" type="button" id="btnSave">保存</button> &nbsp;&nbsp;
				</c:if>
				<button type="button" class="button button-primary button-small" name="backid" id="backid">返回列表</button>				
           	</div>
			<div class="clear"></div>						
		</dd>
	</dl>
	</form>
</div>
</body>
</html>
<script>
    $(function () {
		$('#backid').click(function(){
			window.location.href="dicList.htm?type=${type.id}"
		 });	
		
    });
</script>
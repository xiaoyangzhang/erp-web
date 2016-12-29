<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>更改团号</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<%
	String path = ctx;
%>


</head>
<body class="blank_body_bg">
	 <div class="p_container blank_page_bg"  >
	    	<form id="saveResourceForm">
	    	<dl class="p_paragraph_content">
				<input type="hidden" name="id"value="${groupId}" />
				<input type="hidden" name="GroupCodeSort" value="${GroupCodeSort}" >
	    		<dd>
	    			<div class="dd_left">原团号：</div> 
	    			<div class="dd_right">${oldGroupCode}</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left">新团号：</div> 
	    			<div class="dd_right"><input type="text" name="GroupCode" value="${newGroupCode}" readonly="readonly" style="width:150px"></div>
					<div class="clear"></div>
	    		</dd> 
	    		
			</dl>
			
            <div class="Footer">
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"></div> 
	    			<div class="dd_right">
            			<button  type="submit" class="button button-primary button-small">保存</button>
					</div>
				</dd>
			</dl>
		 	</div>
            </form>		
            </div>

</body>

<script type="text/javascript">
var path = '<%=path%>';

$("#saveResourceForm").validate({
	submitHandler : function(form) {
				var options = {
					url : "saveNewGroupCode.do",
					type : "post",
					dataType : "json",
					success : function(data) {

						if (data.success) {
								var index = parent.layer.getFrameIndex(window.name);
								parent.searchBtn(); 
								parent.layer.msg("更改成功",{time:1000});
								parent.layer.close(index);
						} else {
							$.error(data.msg);
						}
					},
					error : function(XMLHttpRequest, textStatus,
									 errorThrown) {
						$.error('服务器忙，稍后再试');
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

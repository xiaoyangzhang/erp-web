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


</head>
<body class="blank_body_bg">
	 <div class="p_container blank_page_bg"  >
	    	<form id="saveForm">
	    	<dl class="p_paragraph_content">
				<input type="hidden" name="taobaoProductId"value="${tp.id}" />
				<input type="hidden" name="SkusId"value="${tps.id}" />
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>自编码：</div> 
	    			<div class="dd_right">
	    			<input type="text" name="outerId" value="${tp.outerId}" class="IptText300"></div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>产品名称：</div> 
	    			<div class="dd_right">
	    			<input type="text" name="title" value="${tp.title}" class="IptText300"></div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>套餐名称：</div> 
	    			<div class="dd_right">
	    			<input type="text" name="pidName" value="${tps.pidName}" class="IptText300"></div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">*</i>店铺：</div> 
	    			<div class="dd_right">
                    <select id="myStoreId" name="myStoreId">
                    		<option value="AY" <c:if test="${tp.myStoreId=='AY'}">selected </c:if>>爱游</option>
                            <option value="YM"<c:if test="${tp.myStoreId=='YM'}">selected </c:if>>怡美</option>
                            <option value="JY"<c:if test="${tp.myStoreId=='JY'}">selected </c:if>>景怡</option>
                            <option value="TX"<c:if test="${tp.myStoreId=='TX'}">selected </c:if>>天翔</option>
                            <option value="OUTSIDE"<c:if test="${tp.myStoreId=='OUTSIDE'}">selected </c:if>>出境店</option>
                    </select>
							</div>
					<div class="clear"></div>
	    		</dd> 
	    		
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
            

</body>

<script type="text/javascript">
var path = '<%=path%>';
$("#saveForm").validate({
	rules : {
		'outerId' : {
			required : true,
		},
		'title' : {
			required : true,
		},
		'pidName' : {
			required : true,
		},
		'myStoreId' : {
			required : true,
		}
	},
	submitHandler : function(form) {
				var options = {
					url : "saveTaobaoSku.do",
					type : "post",
					dataType : "json",
					success : function(data) {

						if (data.success) {
							$.success('操作成功', function(){
								parent.reloadPage();
							});
							//$.success("操作成功", function(){
							//	window.location = path + '/productInfo/list.htm?state=1';
							//});
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

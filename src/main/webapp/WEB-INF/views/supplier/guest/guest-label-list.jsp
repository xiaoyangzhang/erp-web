<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增标签</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
.label-list {
	margin-bottom: 30px;
}

.label-list ul {
	margin-left: 10px;
	overflow: hidden;
}

.label-list ul li {
	float: left;
	position: relative;
	width: 170px;
	height: 80px;
	margin: 10px 0 10px 20px;
	border: 1px solid #ddd;
}

.label-list ul li .label-name {
	width: 120px;
	margin: 10px 0 10px 15px;
	font-size: 16px;
	font-weight: 700;
}

.label-list ul li .label-num {
	margin: 0 0 10px 15px;
}

.label-list ul li .label-del {
	position: absolute;
	top: 5px;
	right: 5px;
}
</style>
<script type="text/javascript">
	/* $(function () {
		$(".label-list").on("click",".label-del",function () {
			$(this).closest("li").remove();
		});
		$(".label-add-btn").click(function () {
			var $iptVal = $.trim($(".label-add-name").val());
			var $liHtml = "<li><p class='label-name'>" + $iptVal + "</p><p class='label-num'>客人数：10</p><a href='javascript:;' class='label-del'>删除</a></li>"
			if ($iptVal == '') {
				alert("请输入标签名");
			}else{
				var flag = false;
				$(".label-name").each(function(item, index){
					if($.trim($(this).text())==$iptVal) {
						flag = true;
						return false;
					}
				});
				if (flag) {
					alert("该标签已存在！");
				} else{
					$(".label-list ul").append($liHtml);
				}	
			}	
		})
	}) */
</script>
</head>
<body>
	<div class="p_container" >	
		    <div class="p_container_sub">
		    	<p class="p_paragraph_title"><b>新增标签</b></p>
		    	<dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left">标签名称：</div>
		    			<div class="">
		    				<input type="text" id="labelName" class="label-add-name w-100"/>
		    				<a href="javascript:void(0);" class="label-add-btn button button-primary button-rounded button-tiny" onclick="addLabel();">确定</a>
		    			</div>
		    		</dd>
		    	</dl>
		    	<p class="p_paragraph_title"><b>已有标签</b></p>
	            <div class="label-list">
	           	 	<c:forEach items="${supplierGuestLabels}" var="supplierGuest" varStatus="status">
			    		<ul>
			    			<c:forEach items="${supplierGuest}" var="sup" varStatus="status">
				    			<li>
				    				<input type="hidden" value="${sup.id }" />
				    				<p class="label-name">${sup.name }</p>
				    				<p class="label-num">${sup.num }</p>
				    				<a href="javascript:void(0);" class="label-del" onclick="deleteLabel(${sup.id})">删除</a>
				    			</li>
			    			</c:forEach>
			    		</ul>
		    		</c:forEach>
		            <a href="javascript:;" onclick="closeWindow()" class="button button-primary button-small ml-30">返回</a>
	            </div>
	        </div>

	    </div>
</body>
<script type="text/javascript"
	src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function addLabel(){
	var name = $("#labelName").val();
	$.post("addLabel.do", {"name": name}, function(data){
		data = $.parseJSON(data);
		if(data.success == true){
			$.success(data.msg);
			$("#labelName").val("");
			location.reload();
		}else{
			$.error(data.msg);
		}
	}); 
}

function deleteLabel(id){
	$.post("deleteLabel.do", {"id": id}, function(data){
		data = $.parseJSON(data);
		if(data.success == true){
			$.success(data.msg);
			location.reload();
		}else{
			$.error(data.msg);
		}
	}); 
}

</script>
</html>
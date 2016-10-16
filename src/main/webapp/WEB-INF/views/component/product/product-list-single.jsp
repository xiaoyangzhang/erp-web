<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择产品</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath %>/assets/css/component/supplier-select.css" rel="stylesheet" type="text/css">
<SCRIPT type="text/javascript">
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPage").val(page);
	$("#searchPageSize").val(pageSize);
	var options = {
		url:"productList.do",
    	type:"post",
    	dataType:"html",
    	data:{
    		id:${productId}
    	},
    	success:function(data){
    		$("#productDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}	
    };
    $("#searchProductForm").ajaxSubmit(options);	
}
function searchBtn() {	
	queryList();
}
$(function(){
	queryList();
})
function chkSupplier(obj){
	var id = $(obj).attr("sid");
	var brandName = $(obj).attr("sbrand");
	var productName = $(obj).attr("sproduct");
	$(".w_table").find("input[type='checkbox'][sid!='"+id+"']").removeAttr("checked");
	if($(obj).is(':checked')){
		if( $("#ulSel li[sid='"+id+"']").size()==0 ){
			$("#ulSel").empty();
			$("#ulSel").append("<li sid='"+id+"' sbrand='"+brandName+"' sproduct='"+productName+"'>"
					+"【"+brandName+"】"+productName+"<span class='pop_check_del'></span></li>");	
			bindEvent();	
		}		
	}else{
		liRemove(id);
	}
}

function bindEvent(){
	$("#ulSel").find(".pop_check_del").each(function(){
		$(this).unbind("click").bind("click",function(){
			var sid = $(this).parent().attr("sid");
			//删除li
			$(this).parent().remove();
			//table中checkbox取消选中
			chkboxRemove(sid);
		})
	})	
}

function chkboxRemove(id){
	$(".w_table").find("input[type='checkbox'][sid='"+id+"']").removeAttr("checked");
}

function liRemove(id){
	$("#ulSel").find("li[sid='"+id+"']").remove();
}

function getChkedSupplier(){
	var productArr =new Array();
	$("#ulSel").find("li").each(function(){
		var id = $(this).attr("sid");
		productArr.push({id:id});
	})
	return productArr;
}
</SCRIPT>
</head>
<body>	
	<div class="p_container" >		
		<div id="divCenter" class="component_div" >
			<form id="searchProductForm">
				<input type="hidden" name="page" value="${pageNum }" id="searchPage" />
				<input type="hidden" name="pageSize" value="" id="searchPageSize" />
							
				<div class="p_container_sub" >
			    	<div class="searchRow">
		                <ul>         
		                    <li class="text">产品名称</li><li>	                    	
		                    <li><select class="select160" name="brandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName"/>	</li>
							<li><button type="button" class="button button-primary button-small"
									onclick="searchBtn();">搜索</button></li>	                    
		                    <li class="clear"/>
		                </ul>
			    	</div>
		        </div>
			</form>
			<div id="productDiv">
			</div>
		</div>

		
		<div id="divRight" class="component_right">
		
			<h2>已选择：</h2>
			<div class="clear"></div>
			<ul id="ulSel">
			
			</ul>
		</div>
	</div>
</body>
</html>
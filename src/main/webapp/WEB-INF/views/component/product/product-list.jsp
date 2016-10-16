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
	/* if (!pageSize || pageSize < 1) {
		pageSize = 15;
	} */
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
	if($(obj).is(':checked')){
		if( $("#ulSel li[sid='"+id+"']").size()==0 ){
			$("#ulSel").append("<li sid='"+id+"' sbrand='"+brandName+"' sproduct='"+productName+"'>"
					+"【"+brandName+"】"+productName+"<span class='pop_check_del'></span></li>");	
			bindEvent();	
		}		
	}else{
		liRemove(id);
	}
	chkAllIsSelected();
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
	if($("input[type='checkbox'][name='chk'][sid='"+id+"']").size()>0){
		$("#chkall").removeAttr("checked");
	}
}

function liRemove(id){
	$("#ulSel").find("li[sid='"+id+"']").remove();
}

function chkAllIsSelected(){
	if($("input[type='checkbox'][name='chk']:checked").size()==$("input[type='checkbox'][name='chk']").size()){
		$("#chkall").attr("checked",true);
	}else{
		$("#chkall").removeAttr("checked");
	}
}

function getChkedSupplier(){
	var productArr =new Array();
	$("#ulSel").find("li").each(function(){
		var id = $(this).attr("sid");
		productArr.push({id:id});
	})
	return productArr;
} 

function chkAll(obj){
	//选中
	if($(obj).is(':checked')){
		$("input[type='checkbox'][name='chk']").each(function(){
			$(this).attr("checked",true);
			var id = $(this).attr("sid");
			var brandName = $(this).attr("sbrand");
			var productName = $(this).attr("sproduct");	
			if($("#ulSel li[sid='"+id+"']").size()==0){
				$("#ulSel").append("<li sid='"+id+"' sbrand='"+brandName+"' sproduct='"+productName+"'>"
						+"【"+brandName+"】"+productName+"<span class='pop_check_del'></span></li>");
				bindEvent();
			}
		})		
	}else{
		$("input[type='checkbox'][name='chk']").each(function(){
			$(this).removeAttr("checked");
			var id=$(this).attr("sid");
			liRemove(id);		
		})
	}
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
		                	<!-- <li class="text">产品编号</li><li>	                    	
		                    <li><input type="text" name="code"/></li> -->
		                    <!--  <li class="text">目的地</li>
		                   	<li>
		                    	<select name="provinceId" id="provinceCode" class="input-small">
									<option value="">请选择省</option>
									<c:forEach items="${allProvince}" var="province">
										<option value="${province.id }">${province.name }</option>
									</c:forEach>
								</select> 
								<select name="cityId" id="cityCode" class="input-small">
									<option value="">请选择市</option>
								</select> 
								<select name="areaId" id="areaCode" class="input-small">
									<option value="">请选择区县</option>
								</select>
							</li>       -->             
		                    <li class="text">产品名称</li><li>	                    	
		                    <li><select class="select160" name="brandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName"/>	</li>
		                    <!-- <li class="text">线路类型</li><li>	                    	
		                    <li>
		                    <select name="type">
								<option value="">全部</option>
								<option value="1">国内长线</option>
								<option value="2">周边短线</option>
								<option value="3">出境线路</option>
							</select>
		                    </li> -->
							<li><button type="button" class="button button-primary button-small"
									onclick="searchBtn();">搜索</button></li>	                    
		                    <li class="clear"/>
		                </ul>
			    	</div>
		        </div>
			</form>
			<div id="productDiv">
				<%-- <jsp:include page="product-list-table.jsp"></jsp:include>		 --%>		
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
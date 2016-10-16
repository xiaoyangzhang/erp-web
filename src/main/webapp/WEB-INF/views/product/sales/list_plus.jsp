<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>产品销售列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/sales/sale_customer.css"/>
</head>
<body>
<div class="container mb-50">

			<div class="brandsearch mt-25">
				<p class="">品牌检索</p>
				<div class="brand mt-10 mb-5">
					<div class="plist">
						<ul>
						<c:forEach items="${brandList}" var="brand" >
							<li class="brandLi" brand-id="${brand.id }">${brand.value }</li>
						</c:forEach>
						</ul>
						<p class="more fr mt-5 mr-10"><a href="javascript:void(0)" class="blue pr-20 zhankai"><b>更多品牌</b></a></p>
					</div>
					
				</div>
			</div>
			
			<div class="routesearch mt-25">
			<form id="searchProductForm">
				<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value=""/>
				<input type="hidden" id="brandId" name="brandId"  value=""/>
				<span>名称检索: </span><input type="text" id="name" name="name" value="" placeholder="请填写关键字" class="w-300"/>
				<!-- <span class="ml-30">团期: </span><input type="text" id="groupDate" name="groupDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> -->
<!-- 				<span class="ml-30">价格: </span><input type="text" name="bprice" id="bprice" value="" class="w-80"/>~<input type="text" name="eprice" id="eprice" value="" class="w-80" /> -->
				<a href="#" onclick="searchBtn();" class="button button-primary button-small">搜索</a>
<!-- 				<a href="#" onclick="reset()" class="button button-primary button-small">重置</a> -->
			</form>
			</div>
			
			<div id="productSalesDiv"></div>
</body>
<script type="text/javascript">
$(document).ready(function(){

	var lileng = $(".plist ul li").length;
	if(lileng>19){
		$(".more").css("display","block");
	$(".plist ul li:gt(19)").hide();
    $(".more").click(function(){
            if($(".plist p a").text()=="更多品牌"){
                    $(".plist p a").text("收起品牌");
                   
                    $(".plist ul li:gt(19)").stop().slideDown(500);
            }else{
                    $(".plist p a").text("更多品牌");
                    $(".plist p a").removeClass("shouqi");
                    $(".plist ul li:gt(19)").stop().slideUp(500);
                    }
    	});
	}else{
		 $(".more").css("display","none");
	}
	
	$('.brandLi').on('click', function(){
		$(".plist ul li").css("background","#FFFFFF");
		$("#brandId").val($(this).attr("brand-id"));
		$(this).css("background","#A5DE37");
		queryList();
		
	});
	 queryList();
});

 function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
/* 	pageSize = $("#pageSize").val(); */
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"saleListView.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#productSalesDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchProductForm").ajaxSubmit(options);	
}
 function reset() {
		$("#brandId").val("");
		$("#name").val("");
		$("#groupDate").val("");
		$("#bprice").val("");
		$("#eprice").val("");
		$(".plist ul li").css("background","#FFFFFF");
		
	}
 
function goOrder(pid){
	showInfo("产品预定","1050px","420px","groupDate.htm?productId="+pid);
}

function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5, 		
 		area : [width,height],
 		content : url
 	});
 }

function searchBtn() {
	var page = $("#page").val();
	var pageSize = $("#searchPageSize").val();
	queryList(page,pageSize);
}
</script>
</html>

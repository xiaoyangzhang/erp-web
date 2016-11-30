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
			
			<!-- 标签属性 start -->
		<div class="brandsearch mt-25">
		<!-- <p class="">标签属性</p>	 -->
        <form id="product_sale_tag" class="form-horizontal" onsubmit="return false;" action="" method="post">
            <div class="w_biaoqianBox">
                <table id="table_tag_id" cellspacing="0" cellpadding="0" class="w_tableLabel">
                    <col width="140px"/>
                    <tbody>
                    <tr>
                        <td><b>线路主题</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${lineThemeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>线路等级</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${lineLevelList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>参团方式</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${attendMethodList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>酒店星级</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${hotelLevelList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> /><label
                                            for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>天数</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${daysPeriodList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>价格区间</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${priceRangeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>出境目的地</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${exitDestinationList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <td><b>国内目的地</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${domesticDestinationList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><b>类别</b></td>
                        <td>
                            <div class="w_lableBox">
                                <c:forEach items="${typeList}" var="element">

                                <span>
                                    <input type="hidden" name="tagType" value="${element.typeCode}"/>
                                    <label><input id="c_${element.id}" name="tagId" type="checkbox"
                                                  value="${element.id}"
                                                  <c:if test="${element.selected}">checked</c:if> />
                                        <label for="c_${element.id}">${element.value}</label></label>
                                </span>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2">
                    		<p class="tagMmore fr mt-5 mr-10"><a href="javascript:void(0)" class="blue pr-20 zhankai"><b>更多标签</b></a></p>
                    	</td>
                    </tr>
                    </tbody>
                    
                </table>
            </div>
        </form>
        </div>
			<!--  标签属性 end -->
			
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
	
	var tablLength=$("#table_tag_id tr").length-1;
	//alert(tablLength);
	if(tablLength>2){
		$.each($("#table_tag_id tr"), function(i){   
			if(i > 2 && i<=8){    
			      this.style.display = 'none';  
			   }  
		});
		$(".tagMmore").click(function(){
			if($("#table_tag_id tr td p a").text()=="收起标签"){
				$("#table_tag_id tr td p a").text("更多标签");
				$.each($("#table_tag_id tr"), function(i){   
					if(i > 2 && i<=8){    
					      this.style.display = 'none';  
					   }  
				});
			}else{
				$("#table_tag_id tr td p a").text("收起标签");
				$.each($("#table_tag_id tr"), function(i){   
					if(i > 2 && i<=8){    
						$("#table_tag_id tr").removeAttr("style");
					}  
				});
			}
		})
	}
	
	queryList();
});

 function queryList(page,pageSize,dataAttr) {
	if (!page || page < 1) {
		page = 1;
	}
/* 	pageSize = $("#pageSize").val(); */
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"productSalesList.do",
    	type:"post",
    	data: {productTagVo: JSON.stringify({productTags: dataAttr})},
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
 
 
function searchBtn() {
	var tagForm = $('#product_sale_tag');
	var checks = tagForm.find('input:checkbox:checked');
	var dataAttr = [];
	checks.each(function (e) {
         var select = this.value;
         var span = $(this).parent().children('label').text();
         var type = $(this).parent().prev().val();
         dataAttr.push({"tagType": type, "tagId": select, "tagName": span});
     });
	
	var page = $("#page").val();
	var pageSize = $("#searchPageSize").val();
	queryList(page,pageSize,dataAttr);
}

function goOrder(pid){
	showInfo("产品预定","1050px","540px","priceDate.htm?productId="+pid);
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
</script>
</html>

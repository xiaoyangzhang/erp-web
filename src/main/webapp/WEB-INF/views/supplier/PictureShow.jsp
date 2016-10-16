<%@page import="com.yihg.supplier.constants.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>图片展示</title>
<%@ include file="../../include/top.jsp"%>

<link rel="stylesheet" type="text/css"
	href="<%=ctx%>/assets/css/supplier/supplier.css" />
<link rel="stylesheet" type="text/css"
	href="<%=ctx%>/assets/css/pop.css" />
<link rel="stylesheet" type="text/css"
	href="<%=ctx%>/assets/css/component/img-select.css" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/json2.js"></script>

</head>
<body>
	<input type="hidden" value="${imgTypeId }" id="imgTypeId" />
	<div class="p_container">
		<div id="tabContainer">
			<ul class="w_tab">
				<li><a
					href="toEditSupplier.htm?id=${supplierId}&operType=${operType}">基本信息</a></li>
				<li><a
					href="toBusinessInfo.htm?supplierId=${supplierId}&operType=${operType}">结算信息</a></li>
				<li><a href="toContactManList.htm?id=${supplierId}"
					&operType=${operType}>联系人</a></li>
				<li><a
					href="toFolderList.htm?id=${supplierId}&supplierType=${supplierType}&operType=${operType}"
					class="selected">图片</a></li>
				<!-- <li><a href="javascript:void(0)" class="selected">供应商类型</a></li> -->
				

				<li class="clear"></li>
			</ul>
			<!--图片展示 -->
			<div class="p_container_sub" id="pic_show">
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left grey ">图片要求:</div>
						<div class="dd_right">
							<p class="grey">
								1、请提供gif 或 jpg 或 png 格式的图片
							</p>
							<c:if test="${operType==1 }">
								<a href="javascript:void(0)"
									class="mt-20 button button-primary button-rounded button-small"
									onclick="selectAttachment()">选择文件</a>
							</c:if>
							<a href="javascript:void(0)"
								class="mt-20 button button-rounded button-small"
								onclick="javascript:location.href='toFolderList.htm?supplierType=${supplierType}&id=${supplierId}&operType=${operType}'">返回</a>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>

				<p class="p_paragraph_title">
					<b id="typeName">${supplierImgType.typeName }</b>
					<%-- <input type="hidden" name="typeName"  value="${supplierImgType.typeName }" /> --%>
				</p>
				<dl class="p_paragraph_content">
					<dd>

						<c:forEach items="${imgList }" var="img">
							<div class="dd_right ml-30">
								<div class="img_list">
								<c:if test="${img.imgPath ne null}">
									<img src="${config.imgServerUrl }${img.imgPath }" />
									<p class="img_name pop_imgName">${img.imgName }</p>
									<i class="icon_del" onclick="imgDelete('${img.id}')"></i>
									</c:if>
								</div>
							</div>
						</c:forEach>


						<div class="clear"></div>
					</dd>
				</dl>
			</div>

		</div>
		<!--#tabContainer结束-->
	</div>
	
	<script type="text/javascript">
		layer.photos({
	        photos: '.img_list',
	        shade :0.5,
	        area: ['600px', '400px'],
		    closeBtn: 2,
		    shadeClose :true
	    });
    </script>
	<script type="text/javascript">
var imgHover=function  () {
	$(".img_list .icon_del").hide();
	$(".img_list").unbind("hover").hover(function(){
		$(this).find(".icon_del").show();
	},function(){
		$(this).find(".icon_del").hide();
	});			
}
imgHover();
/* var imgDelete=function () {
	$(".img_list .icon_del").unbind("click").click(function  () {
		//$(this).parent().remove();
		//var id=$("#pic").val();
		//delPicture(id);
		
	})
}
imgDelete(); */
function imgDelete(id){
	//var id=$("#pic").val();
	delPicture(id);
}
function delPicture(id){
	$.ajax({
		url:"delPicture.do",
		dataType:"json",
		type:"post",
		data:{
			id:id
		},
		success:function(data){
			if(data.success){
				$.success("删除成功",function(){
					window.location.href=window.location.href;
				});
				
			}
			else{
				$.error("删除失败");
			}
		},
		error:function(){
			$.error("服务器忙，请稍后再试");
		}
	})
}
	
$(function () {
	$("#tabContainer").idTabs();
   // img_upload_handle();
})
    
   function selectAttachment(){
	if($("img").attr("src")&&$("#typeName").text() == "logo"){
		 $.warn("LOGO只能上传一次");
		 return false;
	}
	   layer.openImgSelectLayer({
		   callback: function(arr){
			   if ($("#typeName").text() == "logo"
					   && arr.length > 1) {
				   $.warn("LOGO只能选择一张图片");
				   return false;
				  // selectAttachment();
			   }
			   var imgArr = [];
			   var objId = $("#imgTypeId").val();
			   for (var i = 0; i < arr.length; i++) {
				   //console.log("name:"+arr[i].name+",path:"+arr[i].path+",thumb:"+arr[i].thumb);
				   imgArr.push({
					   objId: objId,
					   imgName: arr[i].name,
					   imgPath: arr[i].path
				   });
			   }
			   $.ajax({
						   type: 'POST',
						   cache: false,
						   url: 'saveImg.do',
						   dataType: 'json',
						   data: {
							   imgs: JSON.stringify(imgArr)
						   },
						   success: function (data) {
							   if (data.success == true) {
								   $.success("操作成功", function () {
									  var html2= $("#imgLogo").html();
									  $(".img_list").html(html2);
											   window.location.href = window.location.href;
										   });
							   } else {
								   $.error("操作失败" + data.msg);
							   }
						   },
						   error: function (data, msg) {
							   $.error("操作失败" + msg);
						   }
					   });
		   }
	   });

   }
	</script>
</body>
</html>
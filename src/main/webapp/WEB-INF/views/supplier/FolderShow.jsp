<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>供应商类型</title>
<%@ include file="../../include/top.jsp"%>

<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=staticPath%>/assets/css/supplier/supplier.css" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="toEditSupplier.htm?id=${id}&operType=${operType}">基本信息</a></li>
			<li><a href="toBusinessInfo.htm?supplierId=${id}&operType=${operType}">结算信息</a></li>
			<li><a href="toContactManList.htm?id=${id}&operType=${operType}">联系人</a></li>
			<li><a
				href="toFolderList.htm?id=${id}&supplierType=${supplierType}&operType=${operType}"
				class="selected">图片</a></li>
			<!-- <li><a href="javascript:void(0)" class="selected">供应商类型</a></li> -->
			

			<li class="clear"></li>
		</ul>

		<div class="p_container_sub" id="pic_show">
			<p class="p_paragraph_title">
				<b>业务图片</b>
			</p>
			<dl class="p_paragraph_content">
				<dd>
					<c:forEach items="${bussList }" var="buss">
						<div class="dd_right ml-30">
							<div class="rest_album " style="cursor: pointer;">
								<a href="toPictureList.htm?id=${buss.id }&supplierType=${supplierType}&supplierId=${id}&operType=${operType}">
									<div class="album_cover"></div>
									<div class="album_intro">
										<span class="album_name"> ${buss.typeName } </span> <span
											class="album_num">共${buss.count }张</span>

										<div class="clear"></div>
									</div> <i class=""></i>
								</a>
							</div>
						</div>
					</c:forEach>
					<div class="clear"></div>
				</dd>
			</dl>
			<c:if test="${fn:length(huanList)!=0 }">
				<p class="p_paragraph_title">
					<b>环境图片</b>
				</p>
			</c:if>
			<dl class="p_paragraph_content">
				<dd>
					<c:forEach items="${huanList }" var="huan">
						<div class="dd_right ml-30 mb-10">
							<div class="rest_album " style="cursor: pointer;">
								<a href="toPictureList.htm?id=${huan.id }&supplierType=${supplierType}&supplierId=${id}&operType=${operType}"/>
									<div class="album_cover"></div>
									<div class="album_intro">
										<span class="album_name"> ${huan.typeName } </span> <span
											class="album_num">共${huan.count }张</span>

										<div class="clear"></div>
									</div> <i class=""></i>
								</a>
							</div>
						</div>

					</c:forEach>

					<div class="clear"></div>
				</dd>
			</dl>
		</div>
	</div>

</body>
<script type="text/javascript">
	function img_upload_handle() {
		/* var imgHover=function  () {
			$(".rest_album .icon_del").hide();
			$(".rest_album").unbind("hover").hover(function(){
				$(this).find(".icon_del").show();
			},function(){
				$(this).find(".icon_del").hide();
			});			
		} */
		//imgHover();
		/* var imgDelete = function(){
			$(".rest_album .icon_del").unbind("click").click(function(){
				$(this).parent().remove();
			});
		} */
		//imgDelete();
		$(".rest_album .newalbum")
				.unbind("click")
				.click(
						function uploadImg_add() {
							$.warn("此处应弹出选择图片对话框！");
							$(this)
									.parent()
									.before(
											'<div class="rest_album "><div class="album_cover"></div><div class="album_intro"><span class="album_name">未定义</span><span class="album_num">共0张</span><div class="clear"></div></div><i class="icon_del"></i></div>');
							imgHover();
							imgDelete();
						});
	}

	$(function() {
		$("#tabContainer").idTabs();
		img_upload_handle();
	})
</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>根据地址查询经纬度</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="../../include/top.jsp"%>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.3"></script>
<style type="text/css">
.txt {
	width: 80px;
}
</style>

</head>
<body>

	<div style="margin: auto;">
		<table>
			<tr>
				<td>经度</td>
				<td><input id="text1" class="txt" runat="server" type="text"
					value="${lon }" /></td>
				<td>经度</td>
				<td><input id="text2" class="txt" runat="server" type="text"
					value="${lat }" /></td>
				<td>地址</td>
				<td colspan="3"><input id="text_" type="text"
					value="${address }" style="width: 150px;" /><input type="button"
					value="查询" onclick="searchByStationName();" /><input id="OKbtn"
					type="button" value="确定" /></td>
			</tr>
		</table>

		<div id="resArea" style="position: relative; text-align: center;">
			<div id="overTip"
				style="position: absolute; left: 0; top: 0; z-index: 99; display: none; background: #ffc; border: 1px solid #676767; font-family: arial, helvetica, sans-serif; font-size: 12px; padding: 4px;">
			</div>
			<div id="container"
				style="position: absolute; width: 600px; height: 450px; left: 17px; border: 1px solid red; overflow: hidden;">
			</div>
		</div>


	</div>



</body>
<script type="text/javascript">
	var map = new BMap.Map("container");

	if ($("#text1").val() == '' || $("#text2").val() == '') {
		map.centerAndZoom('云南', 11);
	} else {
		var point = new BMap.Point(parseFloat($("#text1").val()), parseFloat($(
				"#text2").val()));
		map.centerAndZoom(point, 15);
		var marker = new BMap.Marker(point);
		map.addOverlay(marker);
	}
	map.enableDragging(); //启用地图拖拽事件，默认启用(可不写)
	map.enableScrollWheelZoom(); //启用地图滚轮放大缩小
	map.enableDoubleClickZoom(); //启用鼠标双击放大，默认启用(可不写)
	map.enableKeyboard(); //启用键盘上下左右键移动地图
	map.addControl(new BMap.NavigationControl()); //添加默认缩放平移控件
	map.addControl(new BMap.OverviewMapControl()); //添加默认缩略地图控件
	map.addControl(new BMap.OverviewMapControl({
		isOpen : true,
		anchor : BMAP_ANCHOR_BOTTOM_RIGHT
	})); //右下角，打开

	var center = map.getCenter();

	map.addEventListener("dragend", function() {
		center = map.getCenter();

	});
	map.addEventListener("click", function(e) {
		//标注对象并添加到地图   
		if (marker != null) {
			map.removeOverlay(marker);
		}
		marker = new BMap.Marker(e.point);
		map.addOverlay(marker);
		document.getElementById("text1").value = e.point.lng;
		document.getElementById("text2").value = e.point.lat;
	});

	map.addEventListener('mousemove', function(e) {
		$("#overTip").css("display", "");
		var nx = e.offsetX;
		var ny = e.offsetY;
		$('#overTip').html(e.point.lng + ',' + e.point.lat).css({
			'left' : nx + 8,
			'top' : ny + 8
		});
	});

	var localSearch = new BMap.LocalSearch(map);
	localSearch.enableAutoViewport(); //允许自动调节窗体大小
	function searchByStationName() {
		map.clearOverlays(); //清空原来的标注
		var keyword = document.getElementById("text_").value;
		localSearch.setSearchCompleteCallback(function(searchResult) {
			var poi = searchResult.getPoi(0);

			map.centerAndZoom(poi.point, 16);

			document.getElementById("text1").value = poi.point.lng;
			document.getElementById("text2").value = poi.point.lat;

			var marker = new BMap.Marker(new BMap.Point(poi.point.lng,
					poi.point.lat)); // 创建标注，为要查询的地方对应的经纬度
			map.addOverlay(marker);
			var content = document.getElementById("text_").value
					+ "<br/><br/>经度：" + poi.point.lng + "<br/>纬度："
					+ poi.point.lat;
			var infoWindow = new BMap.InfoWindow("<p style='font-size:14px;'>"
					+ content + "</p>");
			marker.addEventListener("click", function() {
				this.openInfoWindow(infoWindow);
			});
			// marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
		});
		localSearch.search(keyword);
	}

	// 编写自定义函数，创建标注   
	function addMarker(point) {
		// 创建图标对象   
		var myIcon = new BMap.Icon("http://api.map.baidu.com/img/markers.png",
				new BMap.Size(23, 25), {
					// 指定定位位置。   
					// 当标注显示在地图上时，其所指向的地理位置距离图标左上   
					// 角各偏移10像素和25像素。您可以看到在本例中该位置即是   
					// 图标中央下端的尖角位置。   
					offset : new BMap.Size(10, 25),
					// 设置图片偏移。   
					// 当您需要从一幅较大的图片中截取某部分作为标注图标时，您   
					// 需要指定大图的偏移位置，此做法与css sprites技术类似。   
					imageOffset : new BMap.Size(0, 0 - 1 * 25)
				// 设置图片偏移   
				});

		// 创建
		//标注对象并添加到地图   
		marker = new BMap.Marker(point);
		map.centerAndZoom(point, 15);
		// 		map.addOverlay(marker);

		//移除标注

	}

	if ($("#text1").val() == '' || $("#text2").val() == '') {
		searchByStationName();
	}
	$(document).ready(

			function() {
				$("#btn").click(
						function() {
							//var point = new BMap.Point(parseFloat($("#text1").val()) + 0.0065, parseFloat($("#text2").val()) + 0.0065);
							var point = new BMap.Point(parseFloat($("#text1")
									.val()), parseFloat($("#text2").val()));
							addMarker(point);
						});
			});

	//给父页面传值

	$('#OKbtn').on('click', function() {
		window.opener.$("input[name='positionLon']").val($("#text1").val());
		window.opener.$("input[name='positionLat']").val($("#text2").val());
		window.close();
	});
</script>
</html>

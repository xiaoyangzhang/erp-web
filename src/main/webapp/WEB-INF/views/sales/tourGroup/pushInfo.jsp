<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>推送信息</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
.td_journey .trafficFont .jingdian .td_food {
	text-align: left;
}
</style>
</head>
<body>
	<p class="p_paragraph_title">
		<b>行程信息</b>
	</p>
	<dl class="p_paragraph_content">
		<dd>

			<div class="dd_left">
				<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
			</div>
			<div class="dd_right" style="width: 80%">
				<table border="" cellspacing="0" cellpadding="0" class="w_table">
					<col width="10%" />
					<col width="45%" />
					<col width="25%" />
					<col width="20%" />
					<thead>
						<th>天数</th>
						<th>行程</th>
						<th>餐饮</th>
						<th>酒店</th>
					</thead>
					<c:forEach items="${routeList }" var="route" varStatus="st">
						<tr style="text-align: left;">
							<td><fmt:formatDate value="${route.groupRoute.groupDate }" pattern="yyyy-MM-dd"/></td>
							<td>
								<p style="text-align: left; margin-left: 8px;">
									交通：
									<c:forEach items="${route.groupRouteTrafficList }"
										var="traffic">
										<span class="blue"><b>${traffic.cityDeparture }</b></span>
										<c:choose>
											<c:when test="${traffic.typeId == 1}">
												<img src="<%=staticPath%>/assets/img/plane.png" class="img_traffic" />
											</c:when>
											<c:when test="${traffic.typeId == 2}">
												<img src="<%=staticPath%>/assets/img/train.png" class="img_traffic" />
											</c:when>
											<c:when test="${traffic.typeId == 3}">
												<img src="<%=staticPath%>/assets/img/bus.png" class="img_traffic" />
											</c:when>
											<c:when test="${traffic.typeId == 4}">
												<img src="<%=staticPath%>/assets/img/ship.png" class="img_traffic" />
											</c:when>
										</c:choose>
										<span class="grey">(${traffic.miles}km,${traffic.duration}h)</span>
										<span class="blue"><b>${traffic.cityArrival }</b></span>
									</c:forEach>
								</p>
								<p style="text-align: left; margin-left: 8px;">
									详情：<span class="grey">${route.groupRoute.routeDesp}</span>
								</p>
							</td>
							<td style="text-align: left; margin-left: 8px;">
								<p style="text-align: left; margin-left: 8px;">
									<span><b class="mr-5">早餐</b></span>
									${route.groupRoute.breakfast}
								</p>

								<p style="text-align: left; margin-left: 8px;">
									<span><b class="mr-5">午餐</b></span> ${route.groupRoute.lunch}
								</p>

								<p style="text-align: left; margin-left: 8px;">
									<span><b class="mr-5">晚餐</b></span> ${route.groupRoute.supper}
								</p>
							</td>
							<td>${route.groupRoute.hotelName}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</dd>
		<dd class="clear"></dd>
	</dl>


	<p class="p_paragraph_title">
		<b>客人信息</b>&nbsp;&nbsp;&nbsp;&nbsp;${tourGroup.totalAdult }大 ${tourGroup.totalChild }小 ${tourGroup.totalGuide }全陪
	</p>
	<dl class="p_paragraph_content">
		<dd>
			<div class="dd_left">
				<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
			</div>
			<div class="dd_right" style="width: 80%">
				<table border="" cellspacing="0" cellpadding="0" class="w_table">
					<col width="5%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="5%" />
					<col width="20%" />
					<col width="15%" />
					<col width="20%" />
					<thead>
						<th>序号</th>
						<th>姓名</th>
						<th>性别</th>
						<th>年龄</th>
						<th>类型</th>
						<th>证件号</th>
						<th>手机号</th>
						<th>籍贯</th>
					</thead>
					<c:forEach items="${guestList }" var="guest" varStatus="index">
						<tr>
							<td>${index.count}</td>
							<td>${guest.name }</td>
							<td><c:if test="${guest.gender==0 }">女</c:if> <c:if
									test="${guest.gender==1 }">男</c:if></td>
							<td>${guest.age }</td>
							<td><c:if test="${guest.type==1 }">成人</c:if> <c:if
									test="${guest.type==2 }">儿童</c:if> <c:if
									test="${guest.type==3 }">全陪</c:if></td>
							<td>${guest.certificateNum }</td>
							<td>${guest.mobile }</td>
							<td>${guest.nativePlace }</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</dd>
		<dd class="clear"></dd>
	</dl>
	<p class="p_paragraph_title">
		<b>导游司机</b>
	</p>
	<dl class="p_paragraph_content">
		<dd>
			<div class="dd_left">
				<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
			</div>
			<div class="dd_right" style="width: 80%">
				<table border="" cellspacing="0" cellpadding="0" class="w_table">
					<input type="hidden" value="${guide.id}" id="guideId" />
					<col width="5%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<thead>
						<th>类别</th>
						<th>姓名</th>
						<th>联系方式</th>
						<th>结对司机</th>
					</thead>
					<c:forEach items="${guidesList}" var="guides">
						<tr>
							<td>导游</td>
							<td>${guides.guideName }</td>
							<td>${guides.guideMobile }</td>
							<td>
								<select name ="driver" id="driver">
			    					<option value="">请选择</option>
			    					<c:forEach items="${driverList}" var="driver">	    						
			    						<option value="${driver.id}" <c:if test="${supplierDetail.id==driver.id }">selected="selected"</c:if> >
			    							${driver.driverName}
			    						</option>
			    					</c:forEach>
			    				</select>
							</td>
						</tr>
					</c:forEach>
					
				</table>
			</div>
		</dd>
		<dd class="clear"></dd>
	</dl>
	<p class="p_paragraph_title">
		<b>购物店</b>
	</p>
	<dl class="p_paragraph_content">
		<dd>
			<div class="dd_left">
				<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
			</div>
			<div class="dd_right" style="width: 80%">
				<table border="" cellspacing="0" cellpadding="0" class="w_table">
					<col width="5%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<thead>
						<th>类别</th>
						<th>店名</th>
						<th>进店时间</th>
						<th>导游</th>
					</thead>
					<c:forEach items="${bookingShops }" var="v">
						<tr>
							<td>购物店</td>
							<td>${v.supplierName }</td>
							<td>${v.shopDate }</td>
							<td>
								<input type="hidden" name="bookingShopId" value="${v.id}"/>
								<select name ="selGuide" id="selGuide">
			    					<option value="">请选择</option>
			    					<c:forEach items="${guides}" var="guide">	    						
			    						<option value="${guide.guideId}" <c:if test="${v.guideId==guide.guideId}">selected="selected"</c:if> >
			    							${guide.guideName}
			    						</option>
			    					</c:forEach>
			    				</select>
							</td>
						</tr>
					</c:forEach>
						
				</table>
			</div>
		</dd>
		<dd class="clear"></dd>
	</dl>
	<div class="Footer">
					<dl class="p_paragraph_content">
						
							<div style="text-align: center;">
								<button type="button" class="button button-primary button-small" onclick="pushInfoWap(${groupId})" >同步信息到APP</button>
							</div>
					</dl>
	</div>
</body>
</html>

<script type="text/javascript">
	var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
	function pushInfo(groupId) {
		$.getJSON("../tourGroup/pushInfo.do?groupId=" + groupId, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					parent.layer.close(index);
				});
			} else {
				$.error(data.msg);
			}

		});
	}

	function pushInfoWap(groupId) {
		$.getJSON("../tourGroup/pushWap.do?groupId=" + groupId, function(data) {
			if (data.result == "success") {
				$.success('推送操作成功',function(){
					parent.layer.close(index);
				});
			} else {
				$.error(data.msg);
			}

		});
	}

	
	$(function() {
		$("#selGuide").bind("change",function(){
			var guideId = $(this).find("#selGuide option:selected").val();
			var shopId = $(this).prev().val();
			var guideName =$(this).find("#selGuide option:selected").text();
			jQuery.ajax({
				url : "../tourGroup/updateShop.do",
				type : "post",
				async : false,
				data : {
					"guideId" : guideId,
					"shopId":shopId,
					"guideName":guideName
				},
				dataType : "json",
				success : function(data) {
					$.success('操作成功');
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
				}
			});
		});
		$("#driver").bind("change",function(){
			var driverId = $("#driver option:selected").val();
			var groupId = ${groupId} ;
			var guideId = $("#guideId".val()) ;
			<%--var guideId = ${guide.id} ;--%>
			jQuery.ajax({
				url : "../tourGroup/updateGuide.do",
				type : "post",
				async : false,
				data : {
					"driverId" : driverId,
					"groupId":groupId,
					"guideId":guideId
				},
				dataType : "json",
				success : function(data) {
					$.success('操作成功');
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
				}
			});
		}) ;



	});
</script>
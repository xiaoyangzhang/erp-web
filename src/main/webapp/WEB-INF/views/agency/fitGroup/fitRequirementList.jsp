<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计调需求汇总</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/motorcade.js"></script>
	
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/guide.js"></script>
	
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/restaurant.js"></script>


</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../fitGroup/toFitGroupInfo.htm?groupId=${tourGroup.id}&operType=${operType}">散客团信息</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${tourGroup.id}&operType=${operType}"
				class="selected">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>
	</div>
	<div class="p_container_sub">
		<p class="p_paragraph_title">
			<b>酒店</b>
		</p>
		<dl class="p_paragraph_content">

			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
<!-- 								<th width="15%">日期<i class="w_table_split"></i></th> -->
<!-- 								<th width="15%">区域<i class="w_table_split"></i></th> -->
								<th width="10%">接站方式<i class="w_table_split"></i></th>
								<th width="10%">星级<i class="w_table_split"></i></th>
								<th width="10%">单人间<i class="w_table_split"></i></th>
								<th width="10%">三人间<i class="w_table_split"></i></th>
								<th width="10%">标准间<i class="w_table_split"></i></th>
								<th width="10%">陪房<i class="w_table_split"></i></th>
								<th width="10%">加床<i class="w_table_split"></i></th>
								<th width="20%">备注<i class="w_table_split"></i></th>

							</tr>
						</thead>
						<c:forEach items="${hotelList }" var="hotel" varStatus="index">
							<tr>
								<td>${index.count }</td>
<%-- 								<td>${hotel.requireDate }</td> --%>
<%-- 								<td>${hotel.area}</td> --%>
								<td>${hotel.receiveMode}</td>
								<td>${hotel.hotelLevelName}</td>
								<td>${hotel.countSingleRoom}</td>
								<td>${hotel.countTripleRoom}</td>
								<td>${hotel.countDoubleRoom}</td>
								<td>${hotel.peiFang}</td>
								<td>${hotel.extraBed}</td>
								<td style="text-align: left;">${hotel.remark}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<p class="p_paragraph_title">
			<b>机票</b>
		</p>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
								<th width="15%">日期<i class="w_table_split"></i></th>
								<th width="15%">班次<i class="w_table_split"></i></th>
								<th width="15%">出发城市<i class="w_table_split"></i></th>
								<th width="15%">到达城市<i class="w_table_split"></i></th>
								<th width="10%">数量<i class="w_table_split"></i></th>
								<th width="20%">备注<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<c:forEach items="${airList }" var="airticketagent"
							varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td>${airticketagent.requireDate }</td>
								<td>${airticketagent.classNo}</td>
								<td>${airticketagent.cityDeparture}</td>
								<td>${airticketagent.cityArrival}</td>
								<td>${airticketagent.countRequire}</td>
								<td style="text-align: left;">${airticketagent.remark}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<p class="p_paragraph_title">
			<b>火车票</b>
		</p>
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table"
						id="personTable">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
								<th width="15%">日期<i class="w_table_split"></i></th>
								<th width="15%">车次<i class="w_table_split"></i></th>
								<th width="15%">出发地<i class="w_table_split"></i></th>
								<th width="15%">目的地<i class="w_table_split"></i></th>
								<th width="10%">数量<i class="w_table_split"></i></th>
								<th width="20%">摘要<i class="w_table_split"></i></th>
							</tr>
						</thead>
						<c:forEach items="${trainList }" var="trainticketagent"
							varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td>${trainticketagent.requireDate }</td>
								<td>${trainticketagent.classNo}</td>
								<td>${trainticketagent.cityDeparture}</td>
								<td>${trainticketagent.cityArrival}</td>
								<td>${trainticketagent.countRequire}</td>
								<td>${trainticketagent.remark}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>


		<p class="p_paragraph_title">
			<b>车队</b>
		</p>
		<dl class="p_paragraph_content">
		<c:if test="${tourGroup.groupState!=3 and operType==1}">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<button type="button" class="button button-primary button-small"
						onclick="newMotorcade()">新增</button>
				</div>
				<div class="clear"></div>
			</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
								<th width="15%">日期<i class="w_table_split"></i></th>
								<th width="15%">型号<i class="w_table_split"></i></th>
								<th width="15%">座位数<i class="w_table_split"></i></th>
								<th width="15%">车辆年限<i class="w_table_split"></i></th>
								<th width="20%">备注<i class="w_table_split"></i></th>
								<c:if test="${tourGroup.groupState!=3 and operType==1}"><th width="10%">操作</th></c:if>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${fleetList}" var="fleet" varStatus="v">
								<tr>
									<td>${v.count}</td>
									<td>${fleet.requireDate}-${fleet.requireDateTo}</td>
									<td>${fleet.modelNum}</td>
									<td>${fleet.countSeat}</td>
									<td>${fleet.ageLimit}</td>
									<td style="text-align: left;">${fleet.remark}</td>
									<c:if test="${tourGroup.groupState!=3 and operType==1}"><td><a href="javascript:void(0);"
										onclick="toEditMotorcade(${fleet.id})" class="def">修改</a>&nbsp;&nbsp; <a
										href="javascript:void(0);"
										onclick="deleteMotorcadeById(this,${fleet.id})" class="def">删除</a></td></c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>


		<p class="p_paragraph_title">
			<b>导游</b>
		</p>
		<dl class="p_paragraph_content">
		<c:if test="${tourGroup.groupState!=3 and operType==1}">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<button type="button" class="button button-primary button-small"
						onclick="newGuide()">新增</button>
				</div>
				<div class="clear"></div>
			</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
								<th width="15%">语种<i class="w_table_split"></i></th>
								<th width="15%">性别<i class="w_table_split"></i></th>
								<th width="15%">年限<i class="w_table_split"></i></th>
								<th width="30%">备注<i class="w_table_split"></i></th>
								<c:if test="${tourGroup.groupState!=3 and operType==1}"><th width="15%">操作</th></c:if>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${guideList}" var="gl" varStatus="v">
								<tr>
									<td>${v.count}</td>
									<td>${gl.language}</td>
									<td><c:if test="${gl.gender==1}">男</c:if> <c:if
									test="${gl.gender==0}">女</c:if><c:if
									test="${gl.gender==2}">不限</c:if></td>
									<td>${gl.ageLimit}</td>
									<td style="text-align: left;">${gl.remark}</td>
									<c:if test="${tourGroup.groupState!=3 and operType==1}"><td><a href="javascript:void(0);"
										onclick="toEditGuide(${gl.id})" class="def">修改</a>&nbsp;&nbsp; <a
										href="javascript:void(0);" onclick="deleteGuideById(this,${gl.id})" class="def">删除</a>
									</td></c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>
		<p class="p_paragraph_title">
			<b>餐厅</b>
		</p>
		<dl class="p_paragraph_content">
		<c:if test="${tourGroup.groupState!=3 and operType==1}">
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<button type="button" class="button button-primary button-small"
						onclick="newRestaurant()">新增</button>
				</div>
				<div class="clear"></div>
			</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
					<table cellspacing="0" cellpadding="0" class="w_table">
						<thead>
							<tr>
								<th width="10%">序号<i class="w_table_split"></i></th>
								<th width="15%">日期<i class="w_table_split"></i></th>
								<th width="15%">区域<i class="w_table_split"></i></th>
								<th width="15%">人数<i class="w_table_split"></i></th>
								<th width="30%">备注<i class="w_table_split"></i></th>
								<c:if test="${tourGroup.groupState!=3 and operType==1}"><th width="15%">操作</th></c:if>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${restaurantList}" var="rl" varStatus="v">
								<tr>
									<td>${v.count}</td>
									<td>${rl.requireDate}</td>
									<td>${rl.area}</td>
									<td>${rl.countRequire}</td>
									<td>${rl.remark}</td>
									<c:if test="${tourGroup.groupState!=3 and operType==1}"><td><a href="javascript:void(0);"
										onclick="toEditRestaurant(${rl.id})" class="def">修改</a>&nbsp;&nbsp; <a
										href="javascript:void(0);"
										onclick="deleteRestaurantById(this,${rl.id})" class="def">删除</a></td></c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="clear"></div>
			</dd>

		</dl>
	</div>
	<jsp:include page="fitRequirementInclude.jsp" />
</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>其他信息</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx%>/assets/js/web-js/sales/region_dlg.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/requirement.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/cities.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/jquery.autocomplete.js"></script>
<script type="text/javascript">
	function toRequirement() {
			window.location = "../teamGroup/toRequirement.htm?orderId=${orderId}&operType=${operType}";
	}

	function toTeamGroupInfo() {
			window.location = "../teamGroup/toEditTeamGroupInfo.htm?groupId=${groupId}&operType=${operType}";
	}
	$(function(){
		$("#teamGroupRequireMentForm").validate({
			errorPlacement : function(error, element) {
				if (element.is(':radio') || element.is(':checkbox')
						|| element.is(':input')) {
					error.appendTo(element.parent()); 
				} else {
					error.insertAfter(element);
				}
			},
			submitHandler : function(form) {
				
				
				var options = {
					url : "saveRequireMent.do",
					type : "post",
					dataType : "json",
					success : function(data) {
						if (data.success) {
							$.success('操作成功',function(){
							window.location=window.location;
							});
						} else {
							$.error(data.msg);
						
						}
					},
					error : function(XMLHttpRequest, textStatus,
							errorThrown) {
						$.warn('服务忙，请稍后再试', {
							icon : 5
						});
					}
				};
				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
		
		
	})
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/sales/template/requirementTemplate.jsp"%>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toTeamGroupInfo()">团队信息</a></li>
			<li><a href="javascript:void(0);" onclick="toRequirement()"
				class="selected">计调需求</a></li>
			<li class="clear"></li>
		</ul>
		<div class="p_container_sub">
			<form id="teamGroupRequireMentForm">
				<input type="hidden" name="tourGroup.id" value="${groupId }"/>
				<input type="hidden" name="groupOrder.id" value="${orderId }"/>
				<p class="p_paragraph_title">
					<b>酒店信息</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="3%">序号<i class="w_table_split"></i></th>
										<th width="10%">日期<i class="w_table_split"></i></th>
										<th width="10%">区域<i class="w_table_split"></i></th>
										<th width="10%">星级<i class="w_table_split"></i></th>
										<th width="10%">单人间<i class="w_table_split"></i></th>
										<th width="10%">标间<i class="w_table_split"></i></th>
										<th width="10%">三人间<i class="w_table_split"></i></th>
										<th width="10%">陪房<i class="w_table_split"></i></th>
										<th width="10%">加床<i class="w_table_split"></i></th>
										<th>备注<i class="w_table_split"></i></th>
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;" onclick="addHotel('newHotelData');" class="def">增加</a></th></c:if>
									</tr>
								</thead>
								<tbody id="newHotelData">
									<c:forEach items="${hotelList }" var="hotelInfo" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="hotelGroupRequirementList[${index.index}].id" value="${hotelInfo.id }"/>
										</td>
										<td>
											<input type="text" name="hotelGroupRequirementList[${index.index}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${hotelInfo.requireDate }"/>
										</td>
										<td>
											<input type="text" name="hotelGroupRequirementList[${index.index}].area" value="${hotelInfo.area }"/>
										</td>
										<td>
											 <select name="hotelGroupRequirementList[${index.index}].hotelLevel">
												<c:forEach items="${jdxjList}" var="jdxj">
													<option value="${jdxj.id }"
														<c:if test="${jdxj.id==hotelInfo.hotelLevel }"> selected="selected" </c:if>>${jdxj.value }</option>
												</c:forEach>
										</select></td>
										<td><input name="hotelGroupRequirementList[${index.index}].countSingleRoom" type="text"
											style="width: 100px;"
											value="${(empty hotelInfo.countSingleRoom)?0:hotelInfo.countSingleRoom }" />
										</td>
										<td><input name="hotelGroupRequirementList[${index.index}].countDoubleRoom" type="text"
											style="width: 100px;"
											value="${(empty hotelInfo.countDoubleRoom)?0:hotelInfo.countDoubleRoom }" />
										</td>
										<td><input name="hotelGroupRequirementList[${index.index}].countTripleRoom" type="text"
											style="width: 100px;"
											value="${(empty hotelInfo.countTripleRoom)?0:hotelInfo.countTripleRoom }" />
										</td>
										<td><input name="hotelGroupRequirementList[${index.index}].peiFang" type="text"
											style="width: 100px;"
											value="${ (empty hotelInfo.peiFang)?0:hotelInfo.peiFang }" />
										</td>
										<td><input name="hotelGroupRequirementList[${index.index}].extraBed" type="text"
											style="width: 100px;"
											value="${ (empty hotelInfo.extraBed)?0:hotelInfo.extraBed}" />
										</td>
										<td>
											<input type="text"  name="hotelGroupRequirementList[${index.index}].remark" value="${hotelInfo.remark}"/>
										</td>
										<c:if test="${operType==1}">
										<td>
											<a href="javascript:void(0);" onclick="delHotelTable(this)" class="def">删除</a>
										</td>
										</c:if>
									</tr>
									</c:forEach>

								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<p class="p_paragraph_title">
					<b>车队信息</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="3%">序号<i class="w_table_split"></i></th>
										<th width="20%">日期<i class="w_table_split"></i></th>
										<th width="10%">型号<i class="w_table_split"></i></th>
										<th width="10%">座位数<i class="w_table_split"></i></th>
										<th width="10%">车辆年限<i class="w_table_split"></i></th>
										<th>备注<i class="w_table_split"></i></th>
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;" onclick="addFleet('newFleetData');" class="def">增加</a></th></c:if>
									</tr>
									<tbody id="newFleetData">
										<c:forEach items="${fleetList }" var="fleetInfo" varStatus="index">
											<tr>
											<td>
												${index.count }
												<input type="hidden" name="fleetGroupRequirementList[${index.index}].id" value="${fleetInfo.id }"/>
											</td>
											<td>
												<input type="text" name="fleetGroupRequirementList[${index.index}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${fleetInfo.requireDate }"/>
												~<input type="text" name="fleetGroupRequirementList[${index.index}].requireDateTo" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${fleetInfo.requireDateTo }"/>
											</td>
											<td>
												 <select name="fleetGroupRequirementList[${index.index}].modelNum">
													<c:forEach items="${ftcList}" var="ftc">
														<option value="${ftc.id }" <c:if test="${ftc.id==fleetInfo.modelNum }"> selected="selected" </c:if>>${ftc.value }</option>
													</c:forEach>
												</select>
											</td>
											<td>
												<input type="text" name="fleetGroupRequirementList[${index.index}].countSeat"  value="${fleetInfo.countSeat }" />
											</td>
											<td>
												<input type="text" name="fleetGroupRequirementList[${index.index}].ageLimit"  value="${fleetInfo.ageLimit }" />
											</td>
											<td>
												<input type="text"  name="fleetGroupRequirementList[${index.index}].remark" style="width: 80%"  value="${fleetInfo.remark}"/>
											</td>
											<c:if test="${operType==1}">
											<td>
												<a href="javascript:void(0);" onclick="delFleetTable(this)" class="def">删除</a>
											</td>
											</c:if>
											</tr>
										</c:forEach>
									</tbody>
								 </thead>
							 </table>
						 </div>
						 <div class="clear"></div>
					</dd>
				</dl>
				<p class="p_paragraph_title">
					<b>导游信息</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="3%">序号<i class="w_table_split"></i></th>
										<th width="10%">语种<i class="w_table_split"></i></th>
										<th width="10%">性别<i class="w_table_split"></i></th>
										<th width="10%">年限<i class="w_table_split"></i></th>
										<th>备注<i class="w_table_split"></i></th>
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;" onclick="addGuide('newGuideData');" class="def">增加</a></th></c:if>
									</tr>
									<tbody id="newGuideData">
										<c:forEach items="${guideList }" var="guideInfo" varStatus="index">
										<tr>
											<td>
												${index.count }
												<input type="hidden" name="guideGroupRequirementList[${index.index}].id" value="${guideInfo.id }"/>
											</td>
											<td>
												<input type="text" name="guideGroupRequirementList[${index.index}].language"  value="${guideInfo.language }"/>
											</td>
											<td>
												<select name="guideGroupRequirementList[${index.index}].gende">
													<option value="2" <c:if test="${guideInfo.gender==2 }"> selected="selected"</c:if>>不限</option>
													<option value="0" <c:if test="${guideInfo.gender==0 }"> selected="selected"</c:if>>男</option>
													<option value="1" <c:if test="${guideInfo.gender==1 }"> selected="selected"</c:if>>女</option>
												</select>
											</td>
											<td>
												<input type="text" name="guideGroupRequirementList[${index.index}].ageLimit"  value="${guideInfo.ageLimit }" />
											</td>
											<td>
												<input type="text"  name="guideGroupRequirementList[${index.index}].remark" style="width: 80%" value="${guideInfo.remark}"/>
											</td>
											<c:if test="${operType==1}">
											<td>
												<a href="javascript:void(0);" onclick="delGuideTable(this)" class="def">删除</a>
											</td>
											</c:if>
											</tr>
										</c:forEach>
									</tbody>
								 </thead>
							 </table>
						 </div>
						 <div class="clear"></div>
					</dd>
				</dl>
				<p class="p_paragraph_title">
					<b>餐厅信息</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="3%">序号<i class="w_table_split"></i></th>
					             		<th width="10%">日期<i class="w_table_split"></i></th>
					             		<th width="10%">区域<i class="w_table_split"></i></th>
					             		<th width="10%">人数<i class="w_table_split"></i></th>
					             		<th>备注<i class="w_table_split"></i></th>
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;" onclick="addRestaurant('newRestaurantData');" class="def">增加</a></th></c:if>
									</tr>
									<tbody id="newRestaurantData">
										<c:forEach items="${restaurantList }" var="restaurantInfo" varStatus="index">
										<tr>
											<td>
												${index.count }
												<input type="hidden" name="restaurantGroupRequirementList[${index.index}].id" value="${restaurantInfo.id }"/>
											</td>
											<td>
												<input type="text" name="restaurantGroupRequirementList[${index.index}].requireDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${restaurantInfo.requireDate }"/>
											</td>
											<td>
												<input type="text" name="restaurantGroupRequirementList[${index.index}].area" value="${restaurantInfo.area }"/>
											</td>
											
											<td>
												<input type="text" name="restaurantGroupRequirementList[${index.index}].countRequire" value="${restaurantInfo.countRequire }" />
											</td>
											<td>
												<input type="text"  name="restaurantGroupRequirementList[${index.index}].remark" style="width: 80%" value="${restaurantInfo.remark}"/>
											</td>
											<c:if test="${operType==1}">
											<td>
												<a href="javascript:void(0);" onclick="delRestaurantTable(this)" class="def">删除</a>
											</td>
											</c:if>
											</tr>
										</c:forEach>
									</tbody>
								 </thead>
							 </table>
						 </div>
						 <div class="clear"></div>
					</dd>
				</dl>
				<c:if test="${operType==1}">
				<div class="Footer" style="position:fixed;bottom:0px; right:0px; background-color: rgba(58,128,128,0.7);width: 100%;padding-bottom: 4px;text-align: center;">
						<button type="submit" class="button button-primary button-small">保存</button>
				</div>
				</c:if>
			</form>
		</div>
</body>
</html>
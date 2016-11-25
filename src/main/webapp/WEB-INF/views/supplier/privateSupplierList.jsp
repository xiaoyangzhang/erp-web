<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../include/top.jsp"%>
<style type="text/css">
.Wdate {
	width: 95px;
}
</style>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/supplier.js"></script>

</head>
<body>
	<div class="p_container">

		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="searchSupplierForm" action="toSuplierList.htm"
					method="post">
					<input type="hidden" name="page" value="${supplierInfo.page}"
						id="searchPage" /> <input type="hidden" name="pageSize"
						value="${supplierInfo.pageSize}" id="searchPageSize" /> <input
						type="hidden" name="supplierType"
						value="${supplierInfo.supplierType }" />
					<dd class="inl-bl">
						<div class="dd_left">名称:</div>
						<div class="dd_right grey">
							<input type="text" name="nameFull"
								value="${supplierInfo.nameFull }" class="input-small" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">法人:</div>
						<div class="dd_right grey">
							<input type="text" name="lawPerson" id="lawPerson"
								value="${supplierInfo.lawPerson }" class="input-small" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">状态:</div>
						<div class="dd_right grey">
							<select name="state" style="width: 100px; text-align: right;">
								<option value="0"
									<c:if test="${supplierInfo.state==0}"> selected="selected" </c:if>>全部</option>
								<option value="1"
									<c:if test="${supplierInfo.state==1}"> selected="selected" </c:if>>正常</option>
								<option value="2"
									<c:if test="${supplierInfo.state==2}"> selected="selected" </c:if>>审核中</option>
								<option value="4"
									<c:if test="${supplierInfo.state==4}"> selected="selected" </c:if>>未通过</option>
								<option value="3"
									<c:if test="${supplierInfo.state==3}"> selected="selected" </c:if>>停用</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">区域:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择省</option>
								<c:forEach items="${allProvince}" var="province">
									<option value="${province.id }"
										<c:if test="${province.id==supplierInfo.provinceId }">selected="selected"</c:if>>${province.name }</option>
								</c:forEach>
							</select> <select name="cityId" id="cityCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择市</option>
								<c:forEach items="${cityList }" var="city">
									<option value="${city.id }"
										<c:if test="${city.id==supplierInfo.cityId }">selected="selected"</c:if>>${city.name }</option>
								</c:forEach>
							</select> <select name="areaId" id="areaCode"
								style="width: 100px; text-align: right;">
								<option value="">请选择区县</option>
								<c:forEach items="${areaList }" var="area">
									<option value="${area.id }"
										<c:if test="${area.id==supplierInfo.areaId }">selected="selected"</c:if>>${area.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">类别:</div>
						<div class="dd_right grey">
							<select name="level" style="width: 100px; text-align: right;">
								<option value="0"
									<c:if test="${supplierInfo.level==0 }"> selected="selected" </c:if>>全部</option>
								<c:if test="${supplierInfo.supplierType==1}">
									<c:forEach items="${travelagencylevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
								<c:if test="${supplierInfo.supplierType==2}">
									<c:forEach items="${restaurantlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==3}">
									<c:forEach items="${levelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>


								<c:if test="${supplierInfo.supplierType==4}">
									<c:forEach items="${fleetlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>


								<c:if test="${supplierInfo.supplierType==5}">
									<c:forEach items="${scenicspotlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==6}">
									<c:forEach items="${shoppinglevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==7}">
									<c:forEach items="${entertainmentlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==8}">
									<c:forEach items="${guidelevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==9}">
									<c:forEach items="${airticketagentlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
								<c:if test="${supplierInfo.supplierType==10}">
									<c:forEach items="${trainticketagentlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
								<c:if test="${supplierInfo.supplierType==11}">
									<c:forEach items="${golflevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
								<c:if test="${supplierInfo.supplierType==12}">
									<c:forEach items="${otherlevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>

								<c:if test="${supplierInfo.supplierType==15}">
									<c:forEach items="${insuranclevelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
								<c:if test="${supplierInfo.supplierType==16}">
									<c:forEach items="${localtravelList}" var="level">
										<option value="${level.id }"
											<c:if test="${supplierInfo.level==level.id }"> selected="selected" </c:if>>${level.value }</option>
									</c:forEach>
								</c:if>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();"
								class="button button-primary button-small">搜索</button>
							<c:if test="${optMap['EDIT'] }">
								<a class="button button-primary button-small"
									onclick="newWindow('新增<c:if test="${supplierInfo.supplierType==1 }">组团社</c:if><c:if test="${supplierInfo.supplierType==2 }">餐厅</c:if><c:if test="${supplierInfo.supplierType==3 }">酒店</c:if><c:if test="${supplierInfo.supplierType==4 }">车队</c:if><c:if test="${supplierInfo.supplierType==5 }">景区</c:if><c:if test="${supplierInfo.supplierType==6 }">购物</c:if><c:if test="${supplierInfo.supplierType==7 }">娱乐</c:if><c:if test="${supplierInfo.supplierType==8 }">导游</c:if><c:if test="${supplierInfo.supplierType==9 }">机票代理</c:if><c:if test="${supplierInfo.supplierType==10 }">火车票代理</c:if><c:if test="${supplierInfo.supplierType==11 }">高尔夫</c:if><c:if test="${supplierInfo.supplierType==12 }">其他</c:if><c:if test="${supplierInfo.supplierType==15 }">保险</c:if><c:if test="${supplierInfo.supplierType==16 }">地接社</c:if>', '<%=ctx%>/supplier/toAddSupplier.htm?supplierType=${supplierInfo.supplierType}')"
									href="javascript:void(0)">新增</a>
								<input type="button" class="button button-primary button-small"
									onclick="toImpSupplier(${supplierInfo.supplierType})"
									value="导入" />
							</c:if>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">
			<table class="w_table" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="4%">
					
					<col width="15%">
					<col width="5%">
					<col width="6%">
					<col width="20%">
					<col width="14%">
					<col width="5%">
					<col width="5%">
					<col width="5%">
					<col width="16%">
				</colgroup>
				<thead>
					<tr>
						<th>序号<i class="w_table_split"></i></th>
						<!-- <th>录入日期<i class="w_table_split"></i></th> -->
						<th>名称<i class="w_table_split"></i></th>
						<th>类别<i class="w_table_split"></i></th>
						<th>法人<i class="w_table_split"></i></th>
						<th>地址<i class="w_table_split"></i></th>
						<th>备注<i class="w_table_split"></i></th>
						<th>联系人<i class="w_table_split"></i></th>
						<th>状态<i class="w_table_split"></i></th>
						<th>协议<i class="w_table_split"></i></th>
						<th>操作<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<c:forEach items="${page.result}" var="supplierInfo"
					varStatus="status">
					<tr >
						<td>${status.count}</td>
						<%-- <td><fmt:formatDate pattern='yyyy/MM/dd'
								value='${supplierInfo.createTime}' /></td> --%>

						<td style="text-align: left;">${supplierInfo.nameFull}</td>
						<td><c:if test="${supplierInfo.supplierType==1}">
								<c:forEach items="${travelagencylevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==2}">
								<c:forEach items="${restaurantlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==3}">
								<c:forEach items="${levelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==4}">
								<c:forEach items="${fleetlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==5}">
								<c:forEach items="${scenicspotlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==6}">
								<c:forEach items="${shoppinglevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==7}">
								<c:forEach items="${entertainmentlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==8}">
								<c:forEach items="${guidelevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==9}">
								<c:forEach items="${airticketagentlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==10}">
								<c:forEach items="${trainticketagentlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==11}">
								<c:forEach items="${golflevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==12}">
								<c:forEach items="${otherlevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==15}">
								<c:forEach items="${insuranclevelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if> <c:if test="${supplierInfo.supplierType==16}">
								<c:forEach items="${localtravelList}" var="level">
									<c:if test="${supplierInfo.level==level.id }">${level.value }</c:if>
								</c:forEach>
							</c:if></td>
						<td>${supplierInfo.lawPerson }</td>

						<td style="text-align: left;">${supplierInfo.provinceName }${supplierInfo.cityName }${supplierInfo.areaName }${supplierInfo.townName }${supplierInfo.address }</td>
						<td style="text-align: left;">${supplierInfo.introBrief }</td>						
						<td><a href="javascript:void(0);" onclick="getJsonData(${supplierInfo.id});">${supplierInfo.manNum }人</a></td>
						<td><c:if test="${supplierInfo.state==1 }">
								<span style="color: green">正常</span>
							</c:if> <c:if test="${supplierInfo.state==2 }">审核中</c:if> <c:if
								test="${supplierInfo.state==3 }">
								<span style="color: red">已停用</span>
							</c:if></td>
							<td >
						${supplierInfo.contractState}
						
						</td>
						<td><a class="def" onclick="newWindow('<c:if test="${supplierInfo.supplierType==1 }">组团社</c:if>
						<c:if test="${supplierInfo.supplierType==2 }">餐厅</c:if><c:if test="${supplierInfo.supplierType==3 }">酒店</c:if>
						<c:if test="${supplierInfo.supplierType==4 }">车队</c:if><c:if test="${supplierInfo.supplierType==5 }">景区</c:if>
						<c:if test="${supplierInfo.supplierType==6 }">购物</c:if><c:if test="${supplierInfo.supplierType==7 }">娱乐</c:if>
						<c:if test="${supplierInfo.supplierType==8 }">导游</c:if><c:if test="${supplierInfo.supplierType==9 }">机票代理</c:if>
						<c:if test="${supplierInfo.supplierType==10 }">火车票代理</c:if><c:if test="${supplierInfo.supplierType==11 }">高尔夫</c:if>
						<c:if test="${supplierInfo.supplierType==12 }">其他</c:if><c:if test="${supplierInfo.supplierType==15 }">保险</c:if>详情', '<%=ctx%>/supplier/toEditSupplier.htm?id=${supplierInfo.id}&operType=0')"
							href="javascript:void(0)">查看</a> 
							<c:if test="${optMap['EDIT'] }">
								<a class="def" onclick="newWindow('修改<c:if test="${supplierInfo.supplierType==1 }">组团社</c:if><c:if test="${supplierInfo.supplierType==2 }">餐厅</c:if><c:if test="${supplierInfo.supplierType==3 }">酒店</c:if><c:if test="${supplierInfo.supplierType==4 }">车队</c:if><c:if test="${supplierInfo.supplierType==5 }">景区</c:if><c:if test="${supplierInfo.supplierType==6 }">购物</c:if><c:if test="${supplierInfo.supplierType==7 }">娱乐</c:if><c:if test="${supplierInfo.supplierType==8 }">导游</c:if><c:if test="${supplierInfo.supplierType==9 }">机票代理</c:if><c:if test="${supplierInfo.supplierType==10 }">火车票代理</c:if><c:if test="${supplierInfo.supplierType==11 }">高尔夫</c:if><c:if test="${supplierInfo.supplierType==12 }">其他</c:if><c:if test="${supplierInfo.supplierType==15 }">保险</c:if>', '<%=ctx%>/supplier/toEditSupplier.htm?id=${supplierInfo.id}&operType=1')" href="javascript:void(0)">修改</a>
								<c:choose>
									<c:when test="${supplierInfo.supplierType ==4 }">
										<a class="def" onclick="newWindow('协议车队 ', '<%=ctx%>/contract/fleet-list.htm?supplierId=${supplierInfo.id}')" href="javascript:void(0)">协议</a>
									</c:when>
									<c:otherwise>
										<a class="def" onclick="newWindow('协议<c:if test="${supplierInfo.supplierType==1 }">组团社</c:if><c:if test="${supplierInfo.supplierType==2 }">餐厅</c:if><c:if test="${supplierInfo.supplierType==3 }">酒店</c:if><c:if test="${supplierInfo.supplierType==5 }">景区</c:if><c:if test="${supplierInfo.supplierType==6 }">购物</c:if><c:if test="${supplierInfo.supplierType==7 }">娱乐</c:if><c:if test="${supplierInfo.supplierType==8 }">导游</c:if><c:if test="${supplierInfo.supplierType==9 }">机票代理</c:if><c:if test="${supplierInfo.supplierType==10 }">火车票代理</c:if><c:if test="${supplierInfo.supplierType==11 }">高尔夫</c:if><c:if test="${supplierInfo.supplierType==12 }">其他</c:if><c:if test="${supplierInfo.supplierType==15 }">保险</c:if>', '<%=ctx%>/contract/${supplierInfo.id}/${flag }/view-list.htm')" href="javascript:void(0)">协议</a>
									</c:otherwise>
								</c:choose>
								<a href="javascript:void(0);" class="def" onclick="delSupplier(${supplierInfo.id})">删除</a>
								<a href="javascript:void(0);" class="def" title="更新业务订单商家名称与当前一致" onclick="upSupplier(${supplierInfo.id},${supplierInfo.supplierType},'${supplierInfo.nameFull}')">更新</a>
								<c:if test="${supplierInfo.state==1}">
									<a href="javascript:void(0);" class="def" onclick="changeState(${supplierInfo.id},3)">停用</a>
								</c:if>
								<c:if test="${supplierInfo.state==3}">
									<a href="javascript:void(0);" class="def" onclick="changeState(${supplierInfo.id},1)">启用</a>
								</c:if>
							</c:if></td>
					</tr>

				</c:forEach>
			</table>
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${page.page }" name="p" />
				<jsp:param value="${page.totalPage }" name="tp" />
				<jsp:param value="${page.pageSize }" name="ps" />
				<jsp:param value="${page.totalCount }" name="tn" />
			</jsp:include>
			</dl>

		</div>
	</div>


	<!-- 查看联系人弹出层开始 -->
	<div id="lookModal" style="display: none">
		<div class="p_container">
			<table class="w_table">
				<colgroup>
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="15%">
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th>姓名<i class="w_table_split"></i></th>
						<th>称谓<i class="w_table_split"></i></th>
						<th>性别<i class="w_table_split"></i></th>
						<th>部门<i class="w_table_split"></i></th>
						<th>职位<i class="w_table_split"></i></th>
						<th>手机<i class="w_table_split"></i></th>
						<th>座机<i class="w_table_split"></i></th>
						<th>传真<i class="w_table_split"></i></th>
					</tr>
				</thead>
				<tbody id='tbody'>
				</tbody>
			</table>
		</div>
	</div>
	<!-- 查看联系人弹出层结束 -->

</body>
</html>
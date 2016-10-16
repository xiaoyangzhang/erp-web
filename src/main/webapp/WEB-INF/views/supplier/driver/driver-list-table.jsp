 <%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>
<%@ include file="/WEB-INF/include/path.jsp"%>

<div class="guide_list">
	<c:if test="${not empty reqpm.bizId2}">
	<div style="padding-left: 16px;">
		<input type="checkbox" onchange="checkAll(this)"/>全选
	</div>
	</c:if>
	<c:forEach items="${pageBean.result}" var="driver" varStatus="status">
		<div class="guide_detail">
			<c:if test="${not empty reqpm.bizId2}">
				<input type="checkbox" name="chk_did" value="${driver.id}"/>
			</c:if>
			<div class="guide_butt">
				<c:if test="${empty reqpm.bizId2}">
					<a href="javascript:void(0)" onclick="newWindow('修改司机','<%=staticPath %>/supplier/driver/editDriver.htm?id=${driver.id }')" class="button button-rounded button-tiny">修改</a>
					<button href="javascript:void(0)" onclick="cancelJoinDriver(${driver.id })" class="button button-rounded button-tiny">取消关联</button>
				</c:if>
				<c:if test="${empty reqpm.bizId&&empty reqpm.bizId2}">
				<c:if test="${optMap['SUPPLIER_DRIVER_PROFILE_EDIT'] }">
					<a href="javascript:void(0)" onclick="newWindow('修改司机','<%=staticPath %>/supplier/driver/editDriver.htm?id=${driver.id }')" class="button button-rounded button-tiny">修改</a>
					<button href="javascript:void(0)" onclick="del(${driver.id })" class="button button-rounded button-tiny">删除</button>
				</c:if>
				</c:if>
			</div>
			<c:if test="${empty driver.photo}">
				<img class="guide_portrait" src="<%=staticPath %>/assets/css/supplier/img/linshi.png" />
			</c:if>
			<c:if test="${not empty driver.photo}">
				<img class="guide_portrait" src="${images_source_200}/${cf:thumbnail(driver.photo,'200x200')}" />
			</c:if>
			<div class="guide_info">
				<div class="mb-10">
					<div class="guide_name fl">
						<a onclick="newWindow('司机详情','<%=staticPath %>/supplier/driver/driverDetail.htm?id=${driver.id }')" href="javascript:void(0)">
						<b>${driver.name }${staticPath }</b>
						</a>
					</div>
					<div class="guide_tags">
						<ul>
							<li><c:if test="${driver.gender==0 }">男</c:if><c:if test="${driver.gender==1 }">女</c:if></li>
						</ul>
					</div>
					<div class="clear"></div>
				</div>
				
				<div class="guide_msg mt-10">
					<p class="w-250">民族：
						<c:if test="${driver.nationality!=null }">${driver.nationalityName }</c:if>
						<c:if test="${driver.nationality==null }">无</c:if>
					</p>
					<p class="w-250">电话：${driver.mobile}</p>
					<br />
					<p class="w-250">籍贯：${driver.nativePlace }</p>
					<p class="w-250">生日：<fmt:formatDate pattern='yyyy-MM-dd' value='${driver.birthDate }'/></p>
					<br />
					<p class="w-400">住址：${driver.provinceName }${driver.cityName }${driver.areaName }${driver.townName }${driver.addr }</p>
					<br />
					<p class="w-250">身份证号：${driver.idCardNo }</p>
					<p class="w-250">驾驶证号：${driver.licenseNo }</p>
				</div>

			</div>
			<div class="clear"></div>
		</div>
	</c:forEach>
</div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
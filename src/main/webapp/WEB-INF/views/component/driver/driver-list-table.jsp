<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib uri="http://yihg.com/custom-taglib" prefix="cf" %>

<div class="guide_list">
	<c:forEach items="${pageBean.result}" var="driver" varStatus="status">
		<div class="guide_detail">
			<div class="subBox">
	        		<input type="radio" name="subBox" drivername="${driver.name }" mobile="${driver.mobile }" driverId="${driver.id}"/>
        	</div>
			<div class="guide_butt">				
			</div>
			<img class="guide_portrait" src="${images_source_200}/${cf:thumbnail(driver.photo,'200x200') }" />
			<div class="guide_info">
				<div class="mb-10">
					<div class="guide_name fl">
						<b>${driver.name }</b>
					</div>
					<div class="clear"></div>
				</div>
				<div class="guide_tags">
					<ul>
						<li><c:if test="${driver.gender==0 }">男</c:if><c:if test="${driver.gender==1 }">女</c:if></li>
					</ul>
					<div class="clear"></div>
				</div>
				<div class="guide_msg mt-10">
					<p class="w-100">民族：
						<c:if test="${driver.nationality!=null }">${driver.nationalityName }</c:if>
						<c:if test="${driver.nationality==null }">无</c:if>
					</p>
					<p class="w-200">电话：${driver.mobile}</p>
					<p class="w-200">生日：<fmt:formatDate pattern='yyyy-MM-dd' value='${driver.birthDate }'/></p>
					<br />
					<p class="w-100">籍贯：${driver.nativePlace }</p>
					<p class="w-200">地址：${driver.provinceName }${driver.cityName }${driver.areaName }${driver.townName }${driver.addr }</p>
					<br />
					<p class="w-200">身份证号：${driver.idCardNo }</p>
					<p class="w-200">驾驶证号：${driver.licenseNo }</p>
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
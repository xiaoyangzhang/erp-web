<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:forEach items="${pb.result}" var="data">
	<c:if test="${data.type == 1}">
		<div class="item ui-widget-content ui-selectee"
			onclick="selectNode(this);" imageId="${data.imgId}">
			<div class="image">
				<div class="base-msg">
					<div class="img-name">${fn:escapeXml(data.imgName)}</div>
				</div>
				<div class="out">图片</div>
				<div class="out photosDemo" ondblclick="openImageSpace();">
					<img style="width: 120px; height: 70px;"
						alt="${fn:escapeXml(data.imgName)}"
						layer-src="${images_source}${fn:escapeXml(data.filePath)}"
						src="${images_200}${fn:escapeXml(data.filePath)}">
				</div>
				<div class="out"><fmt:formatDate value="${data.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate></div>
			</div>
		</div>
	</c:if>
</c:forEach>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
 <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
 <%
 String path = request.getContextPath();
 request.setAttribute("path",path);
 %>
	<c:forEach items="${list}" var="data">
		<span class="pop_imgBox">
			<img title="${fn:escapeXml(data.imgName)}"								 
				<c:choose>
					<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.doc') }">
						src="<%=path %>/assets/imgspace/images/thumbnail-word.jpg"
					</c:when>
					<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.pdf') }">
						src="<%=path %>/assets/imgspace/images/thumbnail-pdf.png"											
					</c:when>
					<c:when test="${fn:endsWith(fn:toLowerCase(data.imgName), '.xls') }">
						src="<%=path %>/assets/imgspace/images/thumbnail-excel.png"
					</c:when>
					<c:otherwise>																	
						src="${images_200}${fn:escapeXml(data.filePath)}"
					</c:otherwise>
				</c:choose>
			/>
			<b class="pop_imgName">${fn:escapeXml(data.imgName)}</b>
			<i  alt="${fn:escapeXml(data.imgName)}" path="${fn:escapeXml(data.filePath)}" class="pop_imgDelete"></i>
		</span>
	</c:forEach>	
	<div class="clear"></div>
<script type="text/javascript">
$(".pop_uploadBox .pop_imgBox .pop_imgDelete").hide();
$(".pop_uploadBox .pop_imgBox").toggle(function(){	
    $(this).find(".pop_imgDelete").show().attr("lang",'on').attr("thumb",$(this).find("img").attr("src"));
},function(){
	$(this).find(".pop_imgDelete").hide().removeAttr('lang').removeAttr("thumb");
});
</script>

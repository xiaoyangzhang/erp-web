<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<div class="guide_list">
	<c:forEach items="${pageBean.result}" var="guide" varStatus="status">
		<div class="guide_detail">
			<c:if test="${status.index == 0}">
				<div class="">
	       			<input type="checkbox" name="checkAll" id="checkAll" value="" />全选
	       		</div> 
			</c:if>
       		
       		<div class="subBox">
	        		<input type="checkbox" name="subBox" id="" value="" guideId="${guide.id}"/>
        	</div>
			
			<img class="guide_portrait" src="<c:if test="${empty guide.photo}"><%=staticPath%>/assets/css/supplier/img/linshi.png</c:if> <c:if test="${!empty guide.photo}"> ${images_source}${guide.photo}</c:if>" />
			
			<div class="guide_info">
				<div class="mb-10">
					<div class="guide_name fl">
						<b>${guide.name }</b>
					</div>
					<div class="fl mt-5">
						<img class="star fl" src="../assets/css/supplier/img/star.png" />
						<span class="rank ml-5"><b>${guide.starLevelName }导游</b></span>
						<p class="">
							<!-- <b>北京强捻导游管理有限公司</b> -->
						</p>
					</div>
					<div class="clear"></div>
				</div>
				<div class="guide_tags">
					<ul>
						<li><c:if test="${guide.gender==0 }">男</c:if><c:if test="${guide.gender==1 }">女</c:if></li>
						<li>适合${guide.personZoneName }</li>
						<li>适合${guide.personArea }</li>
						<li><c:if test="${guide.level!=null }">${guide.levelName }</c:if>导游</li>
						<li>${guide.language }</li>
						<li><c:if test="${guide.isFullTime==1 }">专职</c:if><c:if test="${guide.isFullTime==2 }">兼职</c:if></li>
						<!-- <li>四年经验</li> -->
					</ul>
					<div class="clear"></div>
				</div>
				<div class="guide_msg mt-5">
					<p class="w-100">民族：
						<c:if test="${guide.nationality!=-1 }">${guide.nationalityName }</c:if>
						<c:if test="${guide.nationality==-1 }">无</c:if>
					</p>
					<p class="w-200">电话：${guide.mobile}</p>
					<p class="w-200">生日：<fmt:formatDate pattern='yyyy-MM-dd' value='${guide.birthDate }'/></p>
					<br />
					<p class="w-100">籍贯：${guide.nativePlace }</p>
					<p class="w-200">初次领证：<fmt:formatDate pattern='yyyy-MM-dd' value='${guide.licenseDate }'/></p>
					<p class="w-200">地址：${guide.provinceName }${guide.cityName }${guide.areaName }${guide.townName }${guide.addr }</p>
					<br />
					<p class="w-200">身份证号：${guide.idCardNo }</p>
					<p class="w-200">导游证号：${guide.licenseNo}</p>
					<p class="w-200">资格证号：${guide.licenseNoQuality }</p>
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

<script type="text/javascript">
//全选按钮
    $(function() {
       $("#checkAll").click(function() {
            $('input[name="subBox"]').attr("checked",this.checked); 
        });
        var $subBox = $("input[name='subBox']");
        $subBox.click(function(){
            $("#checkAll").attr("checked",$subBox.length == $("input[name='subBox']:checked").length ? true : false);
        });
    });
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改导游</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
	.text {width:300px;min-height:10px;}
</style>
</head>
<body>
	<div class="p_container">
		<form class="form-horizontal" id="guideForm">
			<input type="hidden" name="id" value="${guide.id }"/>
			<input type="hidden" name="state" value="0" value="${guide.state }"/>
			<p class="p_paragraph_title"><b>导游基本信息:</b></p>
			<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">姓名：</div> 
	    			<div class="dd_right text">${guide.name }</div>
	    			<div class="dd_left">性别：</div> 
	    			<div class="dd_right text" >
    					<c:if test="${guide.gender==0 }">男</c:if>
    					<c:if test="${guide.gender==1 }">女</c:if>
					</div>
					<div class="clear"></div>
	    		</dd> 		
	    		<dd>
	    			<div class="dd_left">民族：</div> 
	    			<div class="dd_right text">
	    				<c:forEach var="mz" items="${mzList}">
							<c:if test="${mz.id == guide.nationality }">${mz.value }</c:if>
	    				</c:forEach>
					</div>
					<div class="dd_left">籍贯：</div> 
	    			<div class="dd_right text">${guide.nativePlace }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">手机：</div> 
	    			<div class="dd_right text">${guide.mobile }</div>
					<div class="dd_left">身份证号：</div> 
	    			<div class="dd_right text">${guide.idCardNo }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">导游证号：</div> 
	    			<div class="dd_right text">${guide.licenseNo }</div>
					<div class="dd_left">开户行：</div> 
	    			<div class="dd_right text">${guide.bankName }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">银行账号：</div> 
	    			<div class="dd_right text">${guide.bankAccount }</div>
					<div class="dd_left">资格证号：</div> 
	    			<div class="dd_right text">${guide.licenseNoQuality }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">初次领证日期：</div> 
	    			<div class="dd_right text"><fmt:formatDate pattern='yyyy-MM-dd' value='${guide.licenseDate }'/></div>
					<div class="dd_left">等级：</div> 
	    			<div class="dd_right text">
    					<c:forEach var="dj" items="${djList}">
    						<c:if test="${dj.id == guide.level }">${dj.value }</c:if>	    						
    					</c:forEach>
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">星级评定：</div> 
	    			<div class="dd_right text">
    					<c:forEach var="xjpd" items="${xjpdList}">
    						<c:if test="${xjpd.id == guide.starLevel }">${xjpd.value }</c:if>    							    						
    					</c:forEach>
					</div>
					<div class="dd_left">导游语种：</div> 
	    			<div class="dd_right text">${guide.language }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">适合带团人数：</div> 
	    			<div class="dd_right text">
    					<c:forEach var="rs" items="${shdtrsList}">
    						<c:if test="${guide.personZoneId!=null && rs.id == guide.personZoneId }">${rs.value }</c:if>	    						
    					</c:forEach>
					</div>
					<div class="dd_left">适合带团区域：</div> 
	    			<div class="dd_right text">${guide.personArea }</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
	    			<div class="dd_left">住址：</div> 
	    			<div class="dd_right text" style="width:500px;">
	    				<c:if test="${not empty guide.provinceName}">
	    					${guide.provinceName}（省/市）
	    				</c:if>
	    				<c:if test="${not empty guide.cityName}">
	    					${guide.cityName}（市）
	    				</c:if>
	    				<c:if test="${not empty guide.areaName}">
	    					${guide.areaName}（县/区）
	    				</c:if>
	    				<c:if test="${not empty guide.townName}">
	    					${guide.townName}（县/区）
	    				</c:if>
	    				${guide.addr }
					</div>
					<div class="clear"></div>
	    		<dd>
	    			<div class="dd_left">头像：</div> 
	    			<div class="dd_right">
	    				<span class="ulImg">	    	
	    					<c:choose>  
							   <c:when test="${empty guide.photo}">  
							   		<img src="<%=staticPath %>/assets/img/uploadImg.png" alt="" />
							   </c:when>  
							     
							   <c:otherwise> 
							   		<img src="${images_source}/${guide.photo}" alt="" />
							   </c:otherwise>  
							</c:choose>  				
	    				</span>
					</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>
		</form>
	</div>	
</body>
</html>
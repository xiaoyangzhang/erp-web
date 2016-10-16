<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>利润查询</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/profit.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
	<script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#tourGroupStartTime").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#tourGroupEndTime").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form method="post" id="form">
				<!-- bizId的作用主要用来区分是地接版还是组团版 根据这里跳转到不同的table方法 -->
					<input type="hidden" name="bizId" id="bizId" value="${bizId}"/>
					<input type="hidden" name="page" id="page" />
					<input type="hidden" name="pageSize" id="pageSize" />
					<dd class="inl-bl">
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input type="text" id="tourGroupStartTime" name="tourGroup.startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.startTime}" pattern="yyyy-MM-dd"/>'/> 
							—
							<input type="text" id="tourGroupEndTime" name="tourGroup.endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value='<fmt:formatDate value="${groupOrder.tourGroup.endTime}" pattern="yyyy-MM-dd"/>'/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input type="text" name="tourGroup.groupCode" id="tourGroupGroupCode" value="${groupOrder.tourGroup.groupCode}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品:</div>
						<div class="dd_right grey">
							<input type="text" name="tourGroup.productName" id="tourGroupProductName" value="${groupOrder.tourGroup.productName}"/>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客源地:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }" <c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
							</select>
							<select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
								<option value="${city.id }">${city.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						
						<div class="dd_right">
						部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						</div> 
						<div class="dd_left">
							<select id="select" name="select" style="width:80px;text-align: right;">
								<option value="0">计调</option>
								<option value="1">销售</option>
							</select>
						</div>   		
						<div class="dd_right">
						
							<input type="text" name="tourGroup.operatorName" stag="userNames" id="operatorName" value="${groupOrder.saleOperatorName}" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds"  type="hidden" value="${groupOrder.saleOperatorIds}"/> 
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();" class="button button-primary button-small" style="margin-left: 35px;">查询</button> 
						</div>
						<div class="clear"></div>
					</dd>
				</form>
		</dl>
		<dl class="p_paragraph_content">
		<div id="content"></div>
		</dl>
		</div>
	</div>
</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>导游列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
    <script type="text/javascript">
     $(function() {
    	 var vars={
 	   			 dateFrom : $.currentMonthFirstDay(),
 	   		 	dateTo : $.currentMonthLastDay()
 	   		 	};
 		$("#startTime").val(vars.dateFrom);
 		$("#endTime").val(vars.dateTo );	
 		
 		
 	
 	 
 });
     </script>

     
</head>
<body>
    <div class="p_container" >
      <div id="tabContainer">

	    <div class="p_container_sub" id="list_search">
	    	<form id="searchBookingGuideForm">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left"><select name="dateType"><option value="0">团日期</option><option value="1">进店日期</option></select></div>
	    			<div class="dd_right grey">
	    			<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value="${page.pageSize }"/>
						<input type="text" name="startTime" id="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"  /> —
	    				<input type="text" name="endTime" id="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"  />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode"  class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="guideName"  class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导管:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="userName"  class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
					<div class="dd_left">购物店:</div>
					<div class="dd_right grey">
						<input type="text" name="shopName" class="w-200" />
					</div>

				</dd>
				<dd class="inl-bl">
					<div class="dd_left">组团社:</div>
					<div class="dd_right grey">
						<input type="text" name="supplierName" class="w-200" />
					</div>

				</dd>
				<dd class="inl-bl">
					<div class="dd_left">产品:</div>
					<div class="dd_right grey">
						<input type="text" name="productName" class="w-200" />
					</div>

				</dd>
				<dd class="inl-bl">
					<div class="dd_left">客源地:</div>
					<div class="dd_right grey">
						<select name="provinceId" id="provinceCode">
									<option value="">请选择省</option>
									<c:forEach items="${allProvince }" var="province">
										<option value="${province.id }" <c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
									</c:forEach>
							</select>
							<select name="cityId" id="cityCode">
									<option value="">请选择市</option>
									<c:forEach items="${allCity }" var="city">
									<option value="${city.id }">${city.name }</option>
									</c:forEach>
							</select>
					</div>

				</dd>
				<dd class="inl-bl">
					<div class="dd_left">客源地类别:</div>
					<div class="dd_right grey">
						<select name="sourceTypeId" id="sourceTypeCode">
							<option value="">请选择</option>
							<c:forEach items="${sourceTypeList }" var="source">
								<option value="${source.id }">${source.value}</option>
							</c:forEach>
						</select>
					</div>

				</dd>
				<dd class="inl-bl">
					<div class="dd_right">
	    				部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" />	    				
	    			</div>
	    			<div class="dd_right">
	    				计调:
	    				<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" />	    				
	    			</div>
				</dd>
				<dd class="inl-bl">
					<div class="dd_left">团类型:</div>
					<div class="dd_right grey">
						<select name="groupMode">
							<option value="">请选择</option>
							<option value="0">散客</option>
							<option value="1">团队</option>
						</select>
					</div>
				</dd>
				<dd class="inl-bl">
					<div class="dd_left">录入状态:</div>
					<div class="dd_right grey">
						<select name="shoppingDataState">
							
							<option value="1">已录入</option>
							<option value="0">未录入</option>
						</select>
					</div>
				</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
	    			</div> 
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	
            <dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" id="bookingGuideDiv" >
                     
    			 </div>
				 <div class="clear"></div>
	    		</dd>
            </dl>
        </div>
        
        
      </div><!--#tabContainer结束-->
    </div>
<script type="text/javascript">
$(document).ready(function () {
	queryList();
});
    
    
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"guestShopList.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#bookingGuideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchBookingGuideForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList(null,$("#searchPageSize").val());
}


</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</body>
</html>

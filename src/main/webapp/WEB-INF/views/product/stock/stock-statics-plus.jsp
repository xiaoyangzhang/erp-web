<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>产品列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="/WEB-INF/include/top.jsp" %>
     <style>
		 .searchRow li.text {
			 width: 80px;
			 text-align: right;
			 margin-right: 10px;
		 }
	 </style>
	 
</head>
<body>
  <div class="p_container" >
      <div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="searchProductForm">
					<input type="hidden" id="searchPage" name="page" value=""/>
					<input type="hidden" id="searchPageSize" name="pageSize" value="5"/>
					<dd class="inl-bl">
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input type="text" id="groupDate" name="groupDate" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,onpicked:function(){changeMaxDate();}})" value="${groupDate }" />
							 —
	    					<input type="text" id="toGroupDate" readOnly name="toGroupDate" value="${toGroupDate }" />

						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<select class="select160" name="brandId">
								<option value="">选择品牌</option>
								<c:forEach items="${brandList}" var="brand">
									<option value="${brand.id }">${brand.value }</option>
								</c:forEach>
							</select>
							<input type="text" name="productName"/>
						</div>
						<div class="clear"></div>
				</dd>
				<dd class="inl-bl">
						<div class="dd_right">
						<button type="button" onclick="searchBtn();" class="button button-primary button-small">查询</button>	
						</div>
						<div class="clear"></div>
				</dd>
				</form>
				</dl>
				<dl class="p_paragraph_content">
		
			<div style="padding-left:20px; padding-right:20px;">
				<button type="button" style="float:left;" onclick="dateGo(-6);" class="button button-primary button-small">前7天</button>
				<button type="button" style="float:right;" onclick="dateGo(6);" class="button button-primary button-small">后7天</button>
			</div>
			<div class="clear"></div>
			</dl>
			<dl class="p_paragraph_content">
	    	<div id="productDiv">
			</div>
			</dl>
        </div>
    </div>
    
  
</body>
<script type="text/javascript">
$(document).ready(function(){
	queryList();
});

function queryList(page,pageSize) {
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"<%=path%>/product/price/stockStatics.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#productDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchProductForm").ajaxSubmit(options);	
}
function searchBtn() {
	var pageSize=$("#searchPageSize").val();
	queryList(1,pageSize);
}

function changeMaxDate(){
	var dateStr =  $("#groupDate").val();	
	var date = new Date(dateStr.replace(/-/g,"/"));
	var maxDate = new Date(date.valueOf() + 6*24*60*60*1000);
	var year = maxDate.getFullYear();
	var month = maxDate.getMonth()+1;
	var day = maxDate.getDate();
	var maxDateStr = year+"-";
	if(month<10){maxDateStr+="0"+month+"-"}
	else{maxDateStr+= month+"-"};
	if(day<10){maxDateStr+="0"+day+""}
	else{maxDateStr += day+"";}
	$("#toGroupDate").val(maxDateStr);
}

function changeMinDate(){
	var dateStr =  $("#toGroupDate").val();	
	var date = new Date(dateStr.replace(/-/g,"/"));
	var minDate = new Date(date.valueOf() - 6*24*60*60*1000);
	
	var year = minDate.getFullYear();
	var month = minDate.getMonth()+1;
	var day = minDate.getDate();
	var minDateStr = year+"-";
	if(month<10){minDateStr+="0"+month+"-"}
	else{minDateStr+= month+"-"};
	if(day<10){minDateStr+="0"+day+""}
	else{minDateStr += day+"";}
	
	$("#groupDate").val(minDateStr);
}

function dateGo(day){
	//修改开始日期
	var dateStr =  $("#groupDate").val();	
	var date = new Date(dateStr.replace(/-/g,"/"));
	var curDate = new Date(date.valueOf() + day*24*60*60*1000);
	var year = curDate.getFullYear();
	var month = curDate.getMonth()+1;
	var day = curDate.getDate();
	var curDateStr = year+"-";
	if(month<10){curDateStr+="0"+month+"-"}
	else{curDateStr+= month+"-"};
	if(day<10){curDateStr+="0"+day+""}
	else{curDateStr += day+"";}
	$("#groupDate").val(curDateStr);
	//修改结束日期
	dateStr =  $("#groupDate").val();	
	date = new Date(dateStr.replace(/-/g,"/"));
	var maxDate = new Date(date.valueOf() + 6*24*60*60*1000);
	var year = maxDate.getFullYear();
	var month = maxDate.getMonth()+1;
	var day = maxDate.getDate();
	var maxDateStr = year+"-";
	if(month<10){maxDateStr+="0"+month+"-"}
	else{maxDateStr+= month+"-"};
	if(day<10){maxDateStr+="0"+day+""}
	else{maxDateStr += day+"";}
	$("#toGroupDate").val(maxDateStr);
	
	queryList();
}

</script>
</html>

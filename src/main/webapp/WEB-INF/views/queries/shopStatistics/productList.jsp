<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>购物统计</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery.freezeheader.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/views/shopStatistics.js"></script>
	<script type="text/javascript">
     $(function() {
    	 var vars={
 	   			 dateFrom : $.currentMonthFirstDay(),
 	   		 	dateTo : $.currentMonthLastDay()
 	   		 	};
 		$("#startTime").val(vars.dateFrom);
 		$("#endTime").val(vars.dateTo );	
 		
 	 
 });
 	function searchBtn() {
		queryList(null,$("#NumberPageSize").val());
	}
 	
 	function queryList(page,pagesize) {	
 	    if (!page || page < 1) {
 	    	page = 1;
 	    }
 	    
 	    $("#page").val(page);
 	    $("#pageSize").val(pagesize);
 	    
 	    var options = {
 			url:"../common/queryListPage.htm",
 	    	type:"post",
 	    	dataType:"html",
 	    	success:function(data){
 	    		$("#tableDiv").html(data);
 	    	},
 	    	error:function(XMLHttpRequest, textStatus, errorThrown){
 	    		$.error("服务忙，请稍后再试");
 	    	}
 	    };
 	    $("#form").ajaxSubmit(options);	
 	    
 	}
     </script>
</head>
<body>
	<div class="p_container">
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="shop.selectProductListPage" />
			<input type="hidden" name="rp" value="queries/shopStatistics/productTable" />
			<div class="p_container_sub" >
			<div class="searchRow">
<!-- 				<ul style="margin-left: 25px;"> -->
<!-- 					<li class="text">统计方式:</li> -->
<!-- 					<li> -->
<!-- 						<input type="radio" id="guide" />导游 -->
<!-- 						<input type="radio" id="guideManage" />导管 -->
<!-- 						<input type="radio" id="shop"  />购物店 -->
<!-- 						<input type="radio" checked="checked" id="product"  />产品 -->
<!-- 						<input type="radio" id="supplier" />组团社(仅团队) -->
<!-- 					</li> -->
<!-- 					<li class="clear"/> -->
<!-- 				</ul> -->
				<ul style="margin-left: 25px;">
					<li class="text">日期类型:</li>
					<li>
					<select id="selectDate" name="selectDate">
							<option value="0">出团日期</option>
							<option value="1">进店日期</option>
							
						</select>
					<input id="startTime" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${first}" />
						~<input id="endTime" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${last}" />
					</li>
					<li class="text">导游:</li>
					<li><input id="guideName" name="guideName" type="text"/></li>
					<li class="text">导管</li>
					<li><input id="guideManageName" name="guideManageName" type="text"/></li>
					<li class="text">购物店</li>
					<li><input id="shopName" name="shopName" type="text"/></li>
					<li class="text">产品品牌</li>
					<li>
						<select name="productBrandId" id="productBrandId"><option value="-1"
								selected="selected">全部</option>
							<c:forEach items="${pp}" var="pp">
								<option value="${pp.id}">${pp.value }</option>
							</c:forEach>
						</select>
					</li>
					<li class="text">产品名称</li>
					<li><input id="productName" name="productName" type="text"/></li>
				</ul>
				<ul style="margin-left: 25px;">
					<li class="text">团类型</li>
					<li>
						<select id="groupMode" name="groupMode" class="w-100bi">
							<option value="">全部</option>
							<option value="0">散客</option>
							<option value="1">团队</option>
						</select>
					</li>
					<li class="text">人均购物:</li>
					<li>
					<input id="min" name="min" type="text"/>
						~<input id="max" name="max" type="text"/>
					</li>
					<li style="margin-left: 125px;">
						<a  href="javascript:void(0);" id="btnQuery" onclick="searchBtn()" class="button button-primary button-rounded button-small">查询</a>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
</body>
</html>
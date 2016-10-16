<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
	<script type="text/javascript" src="<%=staticPath %>/assets/js/chart/highcharts.js"></script>
	
	<script type="text/javascript">
	
	$(function() {
		
	queryList();
	
	 
});
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/receivePersonCountList.do",
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
	function searchBtn(){
		queryList(null,$("#pageSize").val());
	}
	</script>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</head>
<body>
	<div class="p_container">
		
		<form id="form" method="post">
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">年限</li>
					<li>
						<a class="button button-tinier button-plus" onclick="yearControl(0)">－</a>
						<input readonly="readonly" id="yearLimit"  name="yearLimit" value="${yearLimit}" type="text"  
							style="width:50px;text-align:center;margin-left:-2px;margin-right: -2px;"/>
						<a class="button button-tinier button-plus"  onclick="yearControl(1)">＋</a>
					</li>
				<li class="text">产品:</li>
					<li><input id="productBrandName"  name="productBrandName" type="text" style="width: 200px" placeholder="输入产品名称或品牌"/></li>
					<li class="text">组团社:</li>
					<li><input id="supplierName"  name="supplierName" type="text" style="width: 200px" /></li>
					<li class="text">部门:</li>
					
						<li>
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	
						</li>
						<li class="text">计调:</li>
					<li>	<select name="operType">
								<option value="0">操作计调</option>
								<option value="1">销售计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/>
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value=""/>
						
						
					</li>
				<li class="clear" />
					<li>
						
					 	<input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询">
					 </li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	
</body>
	<script type="text/javascript">
	function yearControl(num){
		if(num==0){
			$("#yearLimit").val(Number($("#yearLimit").val())-1);
		}
		if(num==1){
			$("#yearLimit").val(Number($("#yearLimit").val())+1);
		}
	}
	</script>
</html>
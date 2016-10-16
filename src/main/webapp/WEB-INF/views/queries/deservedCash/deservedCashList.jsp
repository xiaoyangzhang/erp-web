<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应收款项目查询信息</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=staticPath%>/assets/js/web-js/sales/regional.js"></script>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
	
</head>
<body>
	<div class="p_container">
		
		<form id="form" method="post">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" value="${pageBean.pageSize }" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期</li>
						<li><select id="dateType" name="dateType">
							<option value="0">出团日期</option>
							<option value="1">输单日期</option>
						</select>
					<input id="startTime" name="startTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
					~<input id="endTime" name="endTime" type="text" style="width: 120px" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
					</li>
					<li class="text">团号：</li>
					<li><input id="groupCode"  name="groupCode" type="text"/></li>
					<li class="text">产品名称：</li>
					<li><input id="productName"  name="productName" type="text"/></li>
					<li class="text">组团社</li>
					<li><input id="supplierName"  name="supplierName" style="width: 200px" type="text"/></li>
					
					<li class="text">接站牌</li>
					<li><input id="receiveMode"  name="receiveMode" style="width: 200px" type="text"/></li>
					<li class="text">客源地</li>
					<li>
		                    	<select name="provinceId" id="provinceCode" class="input-small">
									<option value="">请选择省</option>
									<c:forEach items="${allProvince}" var="province">
										<option value="${province.id }">${province.name }</option>
									</c:forEach>
								</select> 
								<select name="cityId" id="cityCode" class="input-small">
									
								</select> 
								
							</li> 
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
					<li class="text">团类型</li>
					<li><select id="groupMode" name="groupMode" style="width:100px;text-align: right;">
							<option value="" >全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select></li>
					<li class="clear" />
					<li class="text">团款项目</li>
					<li><select id="itemId" name="itemId" style="width:100px;text-align: right;">
							<option value=""></option>
							<c:forEach items="${lysfxmList }" var="item">
							
							<option value="${item.id }">${item.value }</option>
							</c:forEach>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<button id="btnQuery" type="button"  class="button button-primary button-small">查询</button>
					</li>
					<li class="clear" />
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="tableDiv"></div>
	<script type="text/javascript">
	function queryList(page,pagesize) {	
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);
		
		var options = {
				url:"../query/deservedCash.do",
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
	$("#btnQuery").click(function(){
		 queryList(1,$("#pageSize").val());
	})
	$(function(){
		
			$("#provinceCode").change(
					function() {
						var text = $("#provinceCode").find("option:selected").text();
						if(text!='请选择省'){
							$("#pValue").html(text);
						}
						
						$("#cValue").html("");
						
						$("#cityCode").html("<option value=''>请选择市</option>");
						if($("#provinceCode").val()!=''){
						$.getJSON("../basic/getRegion.do?id="
								+ $("#provinceCode").val(), function(data) {
							data = eval(data);
							var s = "<option value=''>请选择市</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>" + item.name
										+ "</option>";
							});
							$("#cityCode").html(s);

						});
						}

					});
			//setData();
			var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
		 	$("#startTime").val(vars.dateFrom);
		 	 $("#endTime").val(vars.dateTo );	
			queryList();
		})
		
		
	</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ include file="../../../include/top.jsp"%>
</head>
	<body>
	    	<dl class="">
	    		<form id="queryForm" style="padding:5px;">
		    		协议名称：<select name="contractId" onchange="queryList()">
		    			<c:forEach var="contract" items="${page.result}" varStatus="status">
		    				<option value="${contract.id }">
		    					${contract.contractName }
		    				</option>
		    			</c:forEach>
		    		</select>
	    		</form>
	    		<dd id="priceTable" style="padding:5px;">
                	
	    		</dd>
	    	</dl>	
   
	</body>
	<script type="text/javascript">
	$(document).ready(function () {
		queryList();
	});  
	    
	function queryList() {		
		var options = {
			url:"deliveryContractPrice.do",
	    	type:"post",
	    	dataType:"html",
	    	success:function(data){
	    		$("#priceTable").html(data);
	    	},
	    	error:function(XMLHttpRequest, textStatus, errorThrown){
	    		$.error("服务忙，请稍后再试");
	    	}
	    };
	    $("#queryForm").ajaxSubmit(options);	
	}
	
	function getItems(){
		var itemArr = new Array();
		$("input[name='chkitem']:checked").each(function(){
			var item={itemName:$(this).attr("itemName"),unitPrice:$(this).attr("unitPrice")};
			itemArr.push(item);
		})
		return itemArr;
	}
	</script>
</html>

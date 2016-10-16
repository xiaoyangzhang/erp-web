<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择供应商</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath %>/assets/css/component/supplier-select.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function queryList() {
	var options = {
		url:"productSupplierList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#supplierDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}	
    };
    $("#searchSupplierForm").ajaxSubmit(options);	
}

$(function(){
	queryList();
})

function searchBtn() {	
	queryList();
}

function chkSupplier(obj){
	var psid=$(obj).attr("psid");
	var id = $(obj).attr("sid");
	var name = $(obj).attr("sname");	
	if($(obj).is(':checked')){
		<c:if test="${condition.single==1}">
		$(".w_table").find("input[type='checkbox'][sid!='"+id+"']").prop("checked", false);
		$("#ulSel").empty();
		</c:if>
		if( $("#ulSel li[sid='"+id+"']").size()==0 ){
			$("#ulSel").append("<li psid='"+psid+"' sid='"+id+"' sname='"+name+"'>"
					+name+"<span class='pop_check_del'></span></li>");	
			bindEvent();	
		}		
	}else{
		liRemove(id);
	}
	chkAllIsSelected();
}

function bindEvent(){
	$("#ulSel").find(".pop_check_del").each(function(){
		$(this).unbind("click").bind("click",function(){
			var sid = $(this).parent().attr("sid");
			//删除li
			$(this).parent().remove();
			//table中checkbox取消选中
			chkboxRemove(sid);
		})
	})	
}

function chkboxRemove(id){
	$(".w_table").find("input[type='checkbox'][sid='"+id+"']").removeAttr("checked");
	if($("input[type='checkbox'][name='chk'][sid='"+id+"']").size()>0){
		$("#chkall").removeAttr("checked");
	}
}

function liRemove(id){
	$("#ulSel").find("li[sid='"+id+"']").remove();
}

function chkAllIsSelected(){
	if($("input[type='checkbox'][name='chk']:checked").size()==$("input[type='checkbox'][name='chk']").size()){
		$("#chkall").attr("checked",true);
	}else{
		$("#chkall").removeAttr("checked");
	}
}

function getChkedSupplier(){
	var supplierArr =new Array();
	$("#ulSel").find("li").each(function(){
		var psid = $(this).attr("psid");
		var sid = $(this).attr("sid");
		var sname = $(this).attr("sname");		
		supplierArr.push({psid:psid,id:sid,name:sname});
	})
	return supplierArr;
} 

function chkAll(obj){
	//选中
	if($(obj).is(':checked')){
		$("input[type='checkbox'][name='chk']").each(function(){
			$(this).attr("checked",true);
			var sid = $(this).attr("sid");
			var psid = $(this).attr("psid");
			var sname = $(this).attr("sname");
			if($("#ulSel li[sid='"+id+"']").size()==0){
				$("#ulSel").append("<li psid='"+psid+"' sid='"+sid+"' sname='"+sname+"'>"
						+sname+"<span class='pop_check_del'></span></li>");
				bindEvent();
			}
		})		
	}else{
		$("input[type='checkbox'][name='chk']").each(function(){
			$(this).removeAttr("checked");
			var id=$(this).attr("sid");
			liRemove(id);		
		})
	}
}

</script>
</head>
<body>	
	<div class="p_container" >		
		<div id="divCenter" class="component_div" style="width:500px;height:380px;" >
			<form id="searchSupplierForm">
				<input type="hidden" name="single" value="${condition.single}" id="type" />
				<input type="hidden" name="productId" value="${condition.productId}" id="productId" />
				<input type="hidden" name="outSupplierId" value="${condition.outSupplierId}" id="outSupplierId" />
				<div class="p_container_sub" >
			    	<div class="searchRow">
		                <ul>            
		                    <li>区域：<input type="text" name="city"/>  
		                    <li>名称：<input type="text" name="supplierName"/></li>
							<li><button type="button" class="button button-primary button-small"
									onclick="searchBtn();">搜索</button></li>	                    
		                    <li class="clear"/>
		                </ul>
			    	</div>
		        </div>
			</form>
			<div id="supplierDiv">
			</div>
		</div>
		
		<div style="float: left;margin-left:5px;width: 250px;height: 100%;">
			<h2>已选择：</h2>
			<div class="clear"></div>
			<div id="divRight" class="component_right" style="width:240px;height:380px;overflow-y:auto;">
				<ul id="ulSel">
				
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
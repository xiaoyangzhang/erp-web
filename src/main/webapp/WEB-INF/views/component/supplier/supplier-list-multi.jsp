<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>选择供应商</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=ctx %>/assets/css/component/supplier-select.css" rel="stylesheet" type="text/css">
<SCRIPT type="text/javascript">
$(function(){
	$("#provinceCode").change(
			function() {
//				$("#cityCode").html("<option value=''>请选择市</option>");
//				$("#areaCode").html("<option value=''>请选择区县</option>");
//				$.getJSON("../basic/getRegion.do?id="
//						+ $("#provinceCode").val(), function(data) {
//					data = eval(data);
//					var s = "<option value=''>请选择市</option>";
//					$.each(data, function(i, item) {
//						s += "<option value='" + item.id + "'>" + item.name
//								+ "</option>";
//					});
//					$("#cityCode").html(s);
//
//				});
				var s = "<option value=''>请选择市</option>";
				var val = this.options[this.selectedIndex].value;
				if(val !== ''){
					$.getJSON("../basic/getRegion.do?id="
							+ val, function(data) {
						data = eval(data);
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
									+ "</option>";
						});
						$("#cityCode").html(s);
					});
				}else{
					$("#cityCode").html(s);
				}
                $("#areaCode").html("<option value=''>请选择区县</option>");
		});
	$("#cityCode").change(
			function() {
//				$("#areaCode").html("<option value=''>请选择区县</option>");
//				$.getJSON("../basic/getRegion.do?id=" + $("#cityCode").val(),
//						function(data) {
//							data = eval(data);
//							var s = "<option value=''>请选择区县</option>";
//							$.each(data, function(i, item) {
//								s += "<option value='" + item.id + "'>"
//										+ item.name + "</option>";
//							});
//							$("#areaCode").html(s);
//
//						});
                var s = "<option value=''>请选择区县</option>";
                var val = this.options[this.selectedIndex].value;
                if(val !== ''){
                    $.getJSON("../basic/getRegion.do?id="
                            + val, function(data) {
                        data = eval(data);
                        $.each(data, function(i, item) {
                            s += "<option value='" + item.id + "'>" + item.name
                                    + "</option>";
                        });
                        $("#areaCode").html(s);
                    });
                }else{
                    $("#areaCode").html(s);
                }
			});
	
})

function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	if (!pageSize || pageSize < 1) {
		pageSize = 15;
	}
	$("#searchPage").val(page);
	$("#searchPageSize").val(pageSize);
	var options = {
		url:"supplierList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#supplierDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.layerMsg("服务忙，请稍后再试",{icon:1,time:1000});
    	}	
    };
    $("#searchSupplierForm").ajaxSubmit(options);	
}
function searchBtn() {	
	queryList();
}

function chkSupplier(obj){
	var id = $(obj).attr("sid");
	var name = $(obj).attr("sname");
	var type = $(obj).attr("stype");
	var typename = $(obj).attr("stypename");
	var province = $(obj).attr("province");
	var city = $(obj).attr("city");
	var area = $(obj).attr("area");
	var town = $(obj).attr("town");	
	if($(obj).is(':checked')){
		if( $("#ulSel li[sid='"+id+"']").size()==0 ){
			$("#ulSel").append("<li sid='"+id+"' sname='"+name+"' stype='"+type+"' stypename='"+typename+"' province='"+province+"' city='"+city+"' area='"+area+"' town='"+town+"'>"
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
	debugger
	$(".w_table").find("input[type='checkbox'][sid='"+id+"']").removeAttr("checked");
	if($("input[type='checkbox'][name='chk'][sid='"+id+"']").size()>0){
		$("#chkall").removeAttr("checked");
	}
}

function liRemove(id){
	$("#ulSel").find("li[sid='"+id+"']").remove();
}

function chkAllIsSelected(){
	if($("input[type='checkbox'][name='chk'][state='1']:checked").size()==$("input[type='checkbox'][name='chk'][state='1']").size()){
		$("#chkall").attr("checked",true);
	}else{
		$("#chkall").removeAttr("checked");
	}
}

function getChkedSupplier(){
	var supplierArr =new Array();
	$("#ulSel").find("li").each(function(){
		var id = $(this).attr("sid");
		var name = $(this).attr("sname");
		var type = $(this).attr("stype");
		var typename = $(this).attr("stypename");
		var province = $(this).attr("province");
		var city = $(this).attr("city");
		var area = $(this).attr("area");
		var town = $(this).attr("town");	
		supplierArr.push({id:id,name:name,type:type,typename:typename,province:province,city:city,area:area,town:town});
	})
	return supplierArr;
} 

function chkAll(obj){
	//选中
	if($(obj).is(':checked')){
		$("input[type='checkbox'][name='chk'][state='1']").each(function(){
			$(this).attr("checked",true);
			var id = $(this).attr("sid");
			var name = $(this).attr("sname");
			var type = $(this).attr("stype");
			var typename = $(this).attr("stypename");
			var province = $(this).attr("province");
			var city = $(this).attr("city");
			var area = $(this).attr("area");
			var town = $(this).attr("town");
			if($("#ulSel li[sid='"+id+"']").size()==0){
				$("#ulSel").append("<li sid='"+id+"' sname='"+name+"' stype='"+type+"' stypename='"+typename+"' province='"+province+"' city='"+city+"' area='"+area+"' town='"+town+"'>"
						+name+"<span class='pop_check_del'></span></li>");
				bindEvent();
			}
		})		
	}else{
		$("input[type='checkbox'][name='chk'][state='1']").each(function(){
			$(this).removeAttr("checked");
			var id=$(this).attr("sid");
			liRemove(id);		
		})
	}
}

</SCRIPT>
</head>
<body>	
	<div class="p_container" >		
		<div id="divCenter" class="component_div" >
			<form id="searchSupplierForm">
				<input type="hidden" name="page" value="${supplierInfo.page}" id="searchPage" />
				<input type="hidden" name="pageSize" value="${supplierInfo.pageSize}" id="searchPageSize" />
				<c:if test="${supplierInfo.supplierType!=null }">
					<input type="hidden" name="supplierType" value="${supplierInfo.supplierType }" />
				</c:if>
				<c:if test="${supplierInfo.stypes!=null }">
					<input type="hidden" name="stypes" value="${supplierInfo.stypes }" />
				</c:if>
				<input type="hidden" name="type" id="type" value="${type }"  />				
				<div class="p_container_sub" >
			    	<div class="searchRow">
		                <ul>
		                	<c:if test="${supplierInfo.supplierType==null }">
		                	<li>
		                		<select name="supplierType">
		                			<option value="">请选择</option>
		                			<c:forEach items="${typeMap }" var="type">
		                				<option value="${type.key }">${type.value }</option>
		                			</c:forEach>
		                		</select>
		                	</li>
		                	</c:if>
		                    <li>
		                    	<select name="provinceId" id="provinceCode" class="input-small">
									<option value="">请选择省</option>
									<c:forEach items="${allProvince}" var="province">
										<option value="${province.id }">${province.name }</option>
									</c:forEach>
								</select> 
								<select name="cityId" id="cityCode" class="input-small">
									<option value="">请选择市</option>
								</select> 
								<select name="areaId" id="areaCode" class="input-small">
									<option value="">请选择区县</option>
								</select>
							</li>                   
		                    <li class="text">名称</li><li>	                    	
		                    <li><input type="text" name="nameFull"/></li>
							<li><button type="button" class="button button-primary button-small"
									onclick="searchBtn();">搜索</button></li>	                    
		                    <li class="clear"/>
		                </ul>
			    	</div>
		        </div>
			</form>
			<div id="supplierDiv">
				<jsp:include page="supplier-list-table-multi.jsp"></jsp:include>				
			</div>
		</div>

		
		<div id="divRight" class="component_right">
		
			<h2>已选择：</h2>
			<div class="clear"></div>
			<ul id="ulSel">
			
			</ul>
		</div>
	</div>
</body>
</html>
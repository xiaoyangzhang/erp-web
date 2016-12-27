<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath %>/assets/css/supplier/supplier.css" rel="stylesheet" />
</head>
<body>	
	<div class="p_container">
		<form id="queryForm">
		
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />		
			<input type="hidden" name="sl" value="com.yimayhd.erpresource.dal.dao.SupplierDriverMapper.queryDriverListPage" />
			<input type="hidden" name="rp" value="supplier/driver/driver-list-table"  />		
			<input type="hidden" name="svc" value="commonSupplierFacade"  />
			<input type="hidden" name="bizId" value="${bizId}"  />
			<input type="hidden" name="bizId2" value="${reqpm.bizId2}"  />
			
			<div class="p_container_sub" >
		    	<div class="searchRow">
	                <ul>
	                    <li class="text">名字 </li>
	                    <li><input type="text" name="name" class="IptText300" /></li>
						<li class="text">住址</li><li>
	                    	<select name="provinceId" id="provinceId" class="input-small">
								<option value="">请选择省</option>	
								<c:forEach items="${allProvince}" var="province">
									<option value="${province.id }">${province.name }</option>
								</c:forEach>						
							</select> 
							<select name="cityId" id="cityId" class="input-small">
								<option value="">请选择市</option>
							</select>
	                    </li>
	                    <li class="text">专兼职</li>
	                    <li><select name="isFullTime">
	                    		<option value="">请选择</option>
								<option value="1">专职</option>
								<option value="2">兼职</option>
							</select>
						</li>
						<li class="clear"/>
					</ul>
					<ul>
						<li class="text">身份证号</li>
						<li><input type="text" name="idCardNo" class="IptText300" /></li>
	                    <li class="text">驾驶证号</li>
						<li><input type="text" name="licenseNo" class="IptText300" /></li>
	                    <li class="text"></li>
	                    <li>
		                	<input type="button" id="btnQuery" onclick="queryList()" class="button button-primary button-small" value="搜索">
		                	<c:if test="${empty reqpm.bizId2}">
		                		<input type="button" id="btnJoin" onclick="showDrivers()" class="button button-primary button-small" value="关联司机">
		                		<a class="button button-primary button-small" href="javascript:void(0)" onclick="newWindow('新增司机','<%=staticPath %>/supplier/driver/editDriver.htm')">新增</a>
	                		</c:if>
						</li>
	                    <li class="clear"/>
	                </ul>	                
		    	</div>
	        </div>
		</form>		
	</div>
	<div id="driverDiv"></div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function del(id){
	YM.post("deleteDriver.do",{id:id},function(data){
		$.success("删除成功");
		queryList();
	});
}

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 10;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"<%=ctx%>/common/queryListPage.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#driverDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

//取消关联
function cancelJoinDriver(driverId) {
	var pm = {};
	pm.driverId = driverId;
	YM.post("cancelJoinDriver.do",pm,queryList);
}

//关联司机
function showDrivers(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择司机',
		closeBtn : false,
		area : [ '1080px', '500px' ],
		shadeClose : false,
		content : 'driverList.htm?bizId2=${bizId}',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){

			var arr = win.getChecked(); 
			if(arr.length>0){
				var pm = {};
				pm.ids = arr.join();
				YM.post("joinDriver.do",pm,queryList);
			}
			layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

function getChecked(){
	var arr = [];
	$("input[name='chk_did']:checked").each(function(i,o){
		arr.push(o.value);
	});
	return arr;
}

function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[type='checkbox']").attr('checked', 'checked');
	} else {
		$("input[type='checkbox']").removeAttr("checked");
	}
}

$(function(){
	var region = new Region('<%=ctx%>',"provinceId","cityId");
	region.init();
	queryList();
});

</script>
</html>
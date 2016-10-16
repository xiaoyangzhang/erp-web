<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../../../include/top.jsp"%>
<link href="<%=staticPath %>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
</head>
<body>	
	<div class="p_container" >
		<form id="queryForm">
			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />		
			
			<div class="p_container_sub" >
		    	<div class="searchRow">
	                <ul>
	                    <li class="text">名字</li>
	                    <li><input type="text" name="name" class="IptText300" /></li>
						<li class="text">区域</li><li>
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
	                    <li class="text">导游证号</li>
						<li><input type="text" name="licenseNo" class="IptText300" /></li>
	                    <li class="text"></li>
	                    <li>
		                	<input type="button" id="btnQuery" class="button button-primary button-small" value="搜索">							
							<input type="button" class="button button-primary button-small"								
								onclick="imp()" value="导入" />	                    
		                	<input type="button" id="btnAdd" onclick="newWindow('新增导游','<%=staticPath %>/supplier/addGuide.htm?')" class="button button-primary button-small" value="新增">							
	                    </li>
	                    <li class="clear"/>
	                </ul>	                
		    	</div>
	        </div>
		</form>		
	</div>
		<div id="guideDiv">
			<jsp:include page="supplier-guide-list-table.jsp"></jsp:include>
		</div>
</body>
<script type="text/javascript" src="<%=staticPath %>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
$("#btnQuery").on("click",function(){
	queryList(1,10);
});

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
		url:"myGuideList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#guideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}	  
    }
    $("#queryForm").ajaxSubmit(options);	
}



function imp(){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择导游',
		closeBtn : false,
		area : [ '1080px', '620px' ],
		shadeClose : false,
		
		content : 'impGuideList.htm',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
			
		},
		yes: function(index){
			//orgArr返回的是org对象的数组
			var arr = win.getGuideList(); 
			if(arr.length==0){
				$.warn("请选择导游");
				return false;
			}
			
			var ids="";
			for(var i=0;i<arr.length;i++){
				//console.log("name:"+arr[i].name+",path:"+arr[i].path+",thumb:"+arr[i].thumb);
				ids+=arr[i].guideId+",";
			}
			if(ids){
				ids = ids.substr(0,ids.length-1);
			}
			impGuide(ids);
			
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
var region = new Region('<%=ctx%>',"provinceId","cityId");
region.init();
function impGuide(ids){
	$.ajax({
		type: 'POST',
        url: 'impGuides.do',
        dataType: 'json',		        
        data: {guideIds:ids},
        success: function(data) {
            if (data.success == true) {
               	window.location.href=window.location.href;
            }else{
				$.error("操作失败"+data.msg);
			}
        },
        error: function(data,msg) {
            $.error("操作失败"+msg);
        }
	});	
}


</script>
</html>
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
	                    <li class="text">姓名</li>
	                    <li><input type="text" name="name"  /></li>
						<li class="text">等级</li>
						<li>
							<select name="level">
								<option value="">全部</option>
								<c:forEach items="${djList }" var="dj">
									<option value="${dj.id }">${dj.value }</option>
								</c:forEach>
							</select>
						</li>
	                    <li class="text">手机号</li>
						<li><input type="text" name="mobile" /></li>
	                    <li class="text"></li>
	                    <li>
		                	<input type="button" id="btnQuery" class="button button-primary button-small" value="搜索">							
							<input type="button" class="button button-primary button-small"								
								onclick="imp()" value="导入" />
							<c:if test="${optMap['EXPORT'] }">
							<input type="button" class="button button-primary button-small"								
								onclick="exp()" value="导出Excel" /></c:if>	  	                    
		                	<input type="button" id="btnAdd" onclick="newWindow('新增导游','<%=staticPath %>/supplier/addGuide.htm?')" class="button button-primary button-small" value="新增">							
	                    </li>
	                    <li class="clear"/>
	                </ul>	                
		    	</div>
	        </div>
		</form>		
	</div>
		<div id="guideDiv">
			<jsp:include page="guideArchivesList-table.jsp"></jsp:include>
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
		url:"guideArchivesList.do",
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

function exp(){
	$("#queryForm").attr("action","expGuide.do");
	$("#queryForm").submit();
}

function imp(){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择导游',
		closeBtn : false,
		area : [ '900px', '620px' ],
		shadeClose : false,
		
		content : 'impGuideArchivesList.htm',
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
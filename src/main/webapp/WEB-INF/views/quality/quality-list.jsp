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
    <title>下接社列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="/WEB-INF/include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript">
     $(function() {
 		function setData(){
 			var curDate=new Date();
 			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#groupDateStart").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#groupDateEnd").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 });
     </script>
</head>
<body>
    <div class="p_container" >
      <div id="tabContainer">    
	    <div class="p_container_sub" id="list_search">
	    	<dl class="p_paragraph_content">
	    		<form id="queryForm">
	    		<input type="hidden" id="searchPage" name="page"  value="1"/>
	    		<input type="hidden" id="searchPageSize" name="pageSize"  value=""/>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团日期:</div>
	    			<div class="dd_right grey">						
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode" id="" value="" class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">产品名称:</div>
	    			<div class="dd_right">
		    			<select class="select160" name="productBrandId">
							<option value="">选择品牌</option>
							<c:forEach items="${brandList}" var="brand">
								<option value="${brand.id }">${brand.value }</option>
							</c:forEach>
						</select>
						<input type="text" name="productName"/>
					</div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">计调员:</div>
	    			<div class="dd_right">
	    				<input type="text" name="operatorName" id="operatorName" value="" readonly="readonly"/>
						<input name="operatorIds" id="operatorIds" value="" type="hidden"/> 
	    				<a href="javascript:void(0);" onclick="selectUserMuti()" > 请选择</a>
						<a href="javascript:void(0);" onclick="multiReset()" >重置</a>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团类型:</div>
	    			<div class="dd_right grey">
	    				<select class="select160" name="groupMode">
							<option value="">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
						</select>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		</form>
	    	</dl>
	    	
            <dl class="p_paragraph_content">
	    		<dd>
	    			<div class="pl-10 pr-10" id="tableDiv">
    			 		
    			 	</div>
	    		</dd>
            </dl>
        </div>
      </div><!--#tabContainer结束-->
    </div>
<script type="text/javascript">
$(document).ready(function () {
	queryList();
});  
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"qualityList.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn() {
	queryList();
}

/**
 * 页面选择部分调用函数(多选)
 */
function selectUserMuti(num){
	var width = window.screen.width ;
	var height = window.screen.height ;
	var wh = (width/1920*650).toFixed(0) ;
	var hh = (height/1080*500).toFixed(0) ;
	wh = wh+"px" ;
	hh = hh+"px" ;
	var lh = (width/1920*400).toFixed(0) ;
	var th = (height/1080*100).toFixed(0) ;
	lh = lh+"px" ;
	th = th+"px" ;
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		offset : [th,lh],
		area : [wh,hh],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList();   
			
			$("#operatorIds").val("");
			$("#operatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#operatorName").val($("#operatorName").val()+userArr[i].name);
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id);
				}else{
					$("#operatorName").val($("#operatorName").val()+userArr[i].name+",");
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id+",");
				}
			}
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 重置查询条件
 */
function multiReset(){
	$("#operatorName").val("");
	$("#operatorIds").val("");
	
}

</script>
</body>
</html>

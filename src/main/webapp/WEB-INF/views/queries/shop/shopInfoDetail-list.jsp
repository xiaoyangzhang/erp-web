<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>团购物明细</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../../include/top.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=ctx %>/assets/css/operate/operate.css"/>
    <script type="text/javascript" src="<%=ctx %>/assets/js/jquery.idTabs.min.js"></script>
    <script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
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
	   <ul class="w_tab">
	    <li><!-- <a href="toGuideList.htm"  >购物统计</a></li>
				<li><a href="shopSelectList.htm" >购物查询</a></li> -->
				<li><a href="shopInfoDetailList.htm" class="selected">团购物明细</a></li>
	    		<li class="clear"></li>
	    </ul>

	  <div class="p_container_sub" id="list_search">
	    	<form id="searchShopInfoDetailForm">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">日期类型:</div>
	    			<div class="dd_right grey">
	    			<select id="selectDate" name="selectDate">
							
							
							<option value="1">进店日期</option>
							<option value="0">出团日期</option>
							
						</select>
	    			<input type="hidden" id="searchPage" name="page"  value=""/><input type="hidden" id="searchPageSize" name="pageSize"  value=""/>
						<input type="text" id="groupDateStart" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="groupDateEnd" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团号:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="groupCode" id="" value="" class="w-200" style="width: 120px"/>
	    			</div>
	    			
	    		</dd>
	    			<dd class="inl-bl">
	    			<div class="dd_left">购物店:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="supplierName" id="" value="" class="w-200"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导游:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="guideName" id="guideName" value="" class="w-200" style="width: 180px"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">导管:</div>
	    			<div class="dd_right grey">
	    				<input type="text" name="userName"  value="" class="w-200" style="width: 180px"/>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">计调员:</div>
	    			<div class="dd_right">
	    				<input type="text" name="operatorName" id="saleOperatorName" value="" readonly="readonly" style="width: 120px"/>
						<input name="saleOperatorIds" id="saleOperatorIds" value="" type="hidden" value=""/> 
	    				<a href="javascript:void(0);" onclick="selectUserMuti()" >请选择</a>
						<a href="javascript:void(0);" onclick="multiReset()" >重置</a>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">团类型:</div>
	    			<div class="dd_right">
	    				<select id="groupMode" name="groupMode">
							<option value="" selected="selected">全部</option>
							<option value="1">团队</option>
							<option value="0">散客</option>
					</select>
	    			</div>
	    			
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">客源地:</div>
	    			<div class="dd_right">
	    				<select name="provinceId" id="provinceCode">
									<option value="-1">请选择省</option>
									<c:forEach items="${allProvince }" var="province">
										<option value="${province.id }" <c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
									</c:forEach>
								</select>
								<select name="cityId" id="cityCode">
									<option value="-1">请选择市</option>
									<c:forEach items="${allCity }" var="city">
									<option value="${city.id }" <c:if test="${groupOrder.cityId==city.id  }"> selected="selected" </c:if>>${city.name }</option>
									</c:forEach>
								</select>
	    			</div>
	    			
	    		</dd>
	    			
	    		<dd class="inl-bl">
	    			<div class="dd_right">
	    				<button type="button" onclick="searchBtn();" class="button button-primary button-small">搜索</button>
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		
	    	</dl>
	    	</form>
	    	
            <dl class="p_paragraph_content">
	    		<dd>
    			 <div class="pl-10 pr-10" id="bookingGuideDiv" >
                     
    			 </div>
				 <div class="clear"></div>
	    		</dd>
            </dl>
        </div>
        
        
      </div><!--#tabContainer结束-->
    </div>
<script type="text/javascript">
$(document).ready(function () {
	queryList();
	$("#tabContainer").idTabs();

	 
});
    
    
    
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPageSize").val(pageSize);
	$("#searchPage").val(page);
	var options = {
		url:"shopInfoDetailList.do",
    	type:"post",
    	dataType:"html",
    	
    	success:function(data){
    		$("#bookingGuideDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#searchShopInfoDetailForm").ajaxSubmit(options);	
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
			
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
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
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
	
}

</script>
</body>
</html>

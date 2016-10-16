<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<%@ include file="../../../include/top.jsp"%>
	<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />  
	<style type="text/css">
		.label-list{margin-bottom: 30px;}
		.label-list ul{margin-left: 10px;overflow: hidden;}
		.label-list ul li{float: left;position: relative; width: 170px;height: 80px;margin: 10px 0 10px 20px;border: 1px solid #ddd;}
		.label-list ul li .label-name{width: 120px; margin: 10px 0 10px 15px; font-size: 16px;font-weight: 700;}
		.label-list ul li .label-num{margin: 0 0 10px 15px;}
		.label-list ul li .label-del{position: absolute;top: 5px;right: 5px;}
		
		.label-search{margin: 0px; border: 1px solid #E7EFF1;}
		.label-search .search-head{margin: 10px;overflow: hidden;}
		.label-search .search-con{height: 57px;overflow: hidden;}
		.label-search .search-con ul{margin-left: 10px;overflow: hidden;}
		.label-search .search-con ul li{float: left;position: relative; width: 160px;height: 40px;margin: 5px 0 10px 10px;border: 1px solid #ddd;}
		.label-search .search-con ul li .label-name{width: 120px; margin: 10px 0 10px 15px; font-size: 16px;font-weight: 700;}
		.label-search .search-con ul li .label-icon{display: none; position: absolute;top: 10px;right: 5px;}
		.label-search .search-con ul li .label-sel{display: block;}
	</style>
	<script type="text/javascript">
	$(function() {
		function setData(){
			 $("input[name='startTime']").val($.currentMonthFirstDay());
		     $("input[name='endTime']").val($.currentMonthLastDay());
		}
		setData();
	})
	</script>
</head>
<body>
    <div class="p_container" >
    <form id="queryForm">
			
			<input type="hidden" name="page" id="page" value="1"/>
			<input type="hidden" name="pageSize" id="pageSize" value="10"/>
			<input type="hidden" name="" id="labelLength" value="${length }"/>
			<!-- <input type="hidden" name="sl" value="fin.selectSettleListPage" />
			<input type="hidden" name="rp" value="finance/settle-list-table" /> -->
	    <div class="p_container_sub">
	    	<dl class="p_paragraph_content">
	    		<dd class="inl-bl">
	    			<div class="dd_left">创建日期：</div>
	    			<div class="dd_right">
	    				<input type="text" id="startMin" name="startTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" /> —
	    				<input type="text" id="startMax" name="endTime" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" />
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">姓名：</div>
	    			<div class="dd_right">
	    				<input type="text" name="name" id="name" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>
	    		<dd class="inl-bl">
	    			<div class="dd_left">电话：</div>
	    			<div class="dd_right">
	    				<input type="text" name="mobile" id="mobile" value="" class="w-100"/>
	    			</div>	
	    			<div class="clear"></div>
	    		</dd>	
	    		<dd class="inl-bl">
	    			<div class="dd_left">
						<button type="button" onclick="searchBtn();" class="button button-primary button-rounded button-small">搜索</button>	 
	    			</div>
	    			<div class="dd_left">
						<button type="button" onclick="newWindow('新增客人','<%=staticPath %>/supplierGuest/addGuest.htm?')" class="button button-primary button-rounded button-small">新增</button>	 
	    			</div>
	    			<div class="dd_left">
	    				<button type="button" onclick="newWindow('标签管理','<%=path%>/supplierGuest/guestLabelList.htm')" class="button button-primary button-rounded button-small">标签库</button>	 
	    			</div>
	    			<div class="clear"></div>
	    		</dd>
	    		<div class="clear"></div>	    		
	    	</dl>
	    </div>
	     <div class="label-search">
	            	<div class="search-head">
	            		<span >已选择：<span id="alChoose"></span></span>
	            		<span class="fr">
	            			<!-- 标签搜索：
	            			<input type="text" name="" class="w-200"/>
	            			<a href="javascript:;" class="def">搜索</a>&nbsp; -->
	            			<a href="javascript:;" class="def btn-showall">显示全部</a>
	            		</span>
	            	</div>
	            	<div class="search-con">
		            	<c:forEach items="${supplierGuestLabels}" var="supplierGuest" varStatus="status">
				    		<ul>
				    			<c:forEach items="${supplierGuest}" var="sup" varStatus="status">
				    				<li id="${sup.id }" onclick="choseLable(${sup.id });">
				    					<input type="hidden" id="label${sup.id }"  value="0"/>
				    					<input type="hidden" id="labelName${sup.id }"  value="${sup.name }"/>
					    				<p class="label-name" style="cursor:pointer;">${sup.name }</p>
					    				<img src="../assets/img/pop_imgDelte.png" class="label-icon"/>
					    			</li>
				    			</c:forEach>
				    		</ul>
			    		</c:forEach>
	            		
	            	</div>
	            </div>
	        
		    </div>
	  </form>
    </div>
    <div id="tableDiv"></div>
    <%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>             
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function queryList(page,pagesize,ids) {	
    if (!page || page < 1) {
    	page = 1;
    }
    if (!pagesize || pagesize < 1) {
    	pagesize = 15;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    var options = {
   		url:"<%=path%>/supplierGuest/guestList.do?chooseIds="+ids,
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#queryForm").ajaxSubmit(options);	
}

function searchBtn(ids) {
	queryList(null,null,ids);
}

$(function() {
	queryList();
});

function deleteGuest(id){
	$.confirm("确认删除吗？", function () {
		$.post("deleteGuest.do", {"id": id}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success(data.msg);
				location.reload();
			}else{
				$.error(data.msg);
			}
		}); 
	}, function () {

    });
	
}

function travelRecords(id){
	var url = [];
	url.push("<%=staticPath%>/supplierGuest/selectTravelRecords.do?idCard="+id);
	newWindow('查看旅游记录',url);
}

function choseLable(id){
	var val =$("#label"+id).val();
	if(val==0){
		$("#label"+id).val(1);
	}else{
		$("#label"+id).val(0);
	}
	var a =getApplyList();
	$("#alChoose").html(a[1]+" ");
	searchBtn(a[0]);
}

function getApplyList(){
	var date = [];
	var names = [];
	var notIds = [];
	$(".label-search .search-con ").each(function(){

		var obj = [];
		var ul = $(this).find("li");
		for(var i = 0; i < ul.length; i++){
			var item = ul[i];
			var id = $(item).attr("id");
			var value = $("#label"+id).val();
			if(value==1){
				notIds.push(id);	
				names.push($("#labelName"+id).val());
			}
		}
	});
	date[0] = notIds;
	date[1] = names;
	return date;
}

//标签选中、显示全部
$(function () {
	$(".search-con ul").on("click","li",function () {
		$(this).find(".label-icon").toggleClass("label-sel");
	})
	
	$(".btn-showall").click(function () {
		var uheight = $(".label-search .search-con ul").height();
		var sheight = $(".search-con").height();
		if ($(".btn-showall").text()=="显示全部") {
			$(".btn-showall").text("收起标签");
			var l = $("#labelLength").val();
			var h =uheight*l;
			$(".search-con").height(h);
		} else{
			$(".btn-showall").text("显示全部");
			$(".search-con").height(57);
		}					
	})
})
</script>
</html>

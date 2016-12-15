<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>结算单</title>
<%@ include file="../../include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=staticPath%>/assets/js/sys/yihg_erp_link_province.js"></script>
	<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js?v=1"></script>
<style>
        #exportTravelStatusDiv div{
            padding:8px 0px;
            text-align:center;
        }
        #exportTravelStatusDiv div:first-child{
            margin-top:15px;
        }
        #exportTravelStatusDiv div span{
            display:inline-block;
            padding:3px;
        }

        #exportTravelStatusDiv div select{
            width:33%;
			border:1px solid #999;
			 margin-left: 15px;
        }
    </style>
</head>
<body>
	<div class="p_container">
		<form id="exportTravelForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="sl" value="fin.selectSettleListPage" />
			<input type="hidden" name="rp" value="finance/settle-list-table" />
			<div class="p_container_sub" >
			<div class="searchRow">
				<ul>
					<li class="text">日期:</li>
					<li><input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						~<input name="start_max" id="startMax" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</li>
					<li class="text">团号:</li>
					<li><input name="group_code"  id="group_code" type="text"/></li>
					<li class="text">产品名称:</li>
					<li><input name="product_name" id="product_name" type="text"/></li>
											<li class="clear"/>
					
				<!-- </ul>
				<ul> -->
	    			<li class="text">部门:</li>
	    			<li><input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()"/></li>
						<input name="orgIds" id="orgIds" stag="orgIds" value="" type="hidden" value=""/>	    				
	    			<li class="text">计调:</li>
	    			<li><input type="text" name="saleOperatorName" id="saleOperatorName" stag="userNames" value="" readonly="readonly" onclick="showUser()"/></li>
						<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" type="hidden" value=""/>	    				
					<li class="text">导出状态:</li>
					<li><select name="travel_export_status" id="travel_export_status">
							<option value="" selected="selected">全部</option>
							<option value="1">已导出</option>
							<option value="0">未导出</option>
					</select></li>
					<li class="clear" />
					<li class="text"></li>
					<li>
						<input type="button" id="btnQuery" onclick="exportTravelSearchBtn()" class="button button-primary button-small" value="查询">
						<input type="reset" class="button button-primary button-small" value="重置">
						<input type="button" class="button button-primary button-small" value="导出" onclick="exportTravelXml();">
					</li>
				</ul>
			</div>
			</div>
		</form>
	</div>
	<div id="exportTravelTableDiv"></div>
	<div id="exportTravelStatusDiv" style="display:none;">
		<div>
		<span>帐号:</span>
		<select name="accountNum" id="accountNumSelect">
			
		</select>
		</div>
		<div>
		<span>计调:</span>
		<select name="accountPlanNum" id="accountPlanNumSelect">
			
		</select>
		</div>
		<div>
			<span>当前选中了</span><span id="selectedGroupSpan"></span><span>个团</span>
		</div>
	</div>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>  
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">
//var ExportedGroupIds = [<c:forEach items="${groupIds}" var="groupid">${groupid},</c:forEach> -1];

//选择要导出的团
var SelectedGroupMap = {};
//旅游帐号
var TravelCountMap = {};
//计调帐号
var TravelPlanCountMap = {};
function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"<%=staticPath%>/finance/exportTravelList_table.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#exportTravelTableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    }
    $("#exportTravelForm").ajaxSubmit(options);	
}

function exportTravelSearchBtn() {
	SelectedGroupMap = {};
	queryList(1, $("#pageSize").val());
}

//勾选要导出的团
function checkExportGroup(thisObj){
	var checkJqObj  = $(thisObj);
	var objVal = checkJqObj.val();
	SelectedGroupMap[objVal+""] = checkJqObj.attr("checked") ? 1 : 0;
}

//全选
function checkAllExportGroup(thisObj){
	var allCheckObj = $(thisObj);
	var checkStatus = allCheckObj.prop("checked");
	$("input.check-export-travel-status").each(function(index){
		var jqObj = $(this);
		var jqObjVal = jqObj.val();
		jqObj.prop("checked",checkStatus);
		SelectedGroupMap[jqObjVal+""] = checkStatus ? 1 : 0;
	});
}

//下载xml数据
function  downloadXmlData(groupIdsObj,accountNum,accountPlanNum){
	var form;
	if(!$("#xmlDownloadForm").length){
		form=$("<form id='xmlDownloadForm'>");//定义一个form表单
		form.attr("style","display:none");
		form.attr("target","");
		form.attr("method","post");
		form.attr("action","<%=staticPath%>/finance/exportSaleDataTravel.ftl");
		var input1=$("<input>");
		input1.attr("type","hidden");
		input1.attr("name","groupIds");
		$("body").append(form);//将表单放置在web中
		
		var input2 = $("<input>");
		input2.attr("type","hidden");
		input2.attr("name","accountNum");
		
		var input3 = $("<input>");
		input3.attr("type","hidden");
		input3.attr("name","accountNumName");
		
		var input4 = $("<input>");
		input4.attr("type","hidden");
		input4.attr("name","accountPlanNum");
		
		var input5 = $("<input>");
		input5.attr("type","hidden");
		input5.attr("name","accountPlanNumName");
		
		form.append(input1);
		form.append(input2);
		form.append(input3);
		form.append(input4);
		form.append(input5);
	}
	form = $("#xmlDownloadForm");
	form.find("input[name='groupIds'][type='hidden']").val(groupIdsObj.join(","));
	form.find("input[name='accountNum'][type='hidden']").val(accountNum);
	form.find("input[name='accountNumName'][type='hidden']").val(TravelCountMap[accountNum]);
	form.find("input[name='accountPlanNum'][type='hidden']").val(accountPlanNum);
	form.find("input[name='accountPlanNumName'][type='hidden']").val(TravelPlanCountMap[accountPlanNum]);
	form.submit();//表单提交 
}

//导出数字旅游平台需要的数据格式
function exportTravelXml(){
	var groupIds = [];
	for( key in SelectedGroupMap){
		if(SelectedGroupMap[key]){
			groupIds.push(key);
		}
	}
	if(!groupIds.length){
		layer.alert("请选择要导出的团");
		return;
	}
	
	
	
	
	$("#selectedGroupSpan").text(groupIds.length);
	
	layer.open({
            type:1,
            area: ['500px', '250px'],
            btn:["确定","取消"],
            yes:function(index,layero){
            	var accountNumSelectVal = $("#accountNumSelect").val();
            	if(!accountNumSelectVal){
            		layer.alert("请选择帐号");
            		return;
            	}
            	
            	var accountPlanNumSelectVal = $("#accountPlanNumSelect").val();
            	if(!accountPlanNumSelectVal){
            		layer.alert("请选择计调");
            		return;
            	}
            	
            	downloadXmlData(groupIds,accountNumSelectVal,accountPlanNumSelectVal);
                layer.close(index);
            },
            cancel:function(index,layero){
                layer.close(index);
            },
            content:$("#exportTravelStatusDiv")
        });
}




(function(){
	var vars={
  			 dateFrom : $.currentMonthFirstDay(),
  		 	dateTo : $.currentMonthLastDay()
  		 	};
  		 	$("#startMin").val(vars.dateFrom);
  		 	 $("#startMax").val(vars.dateTo );	
  		 	 
  		 	 
	queryList();
	$.ajax("<%=staticPath%>/basic/getDictInfoByTypeCode.do",{
		type:"post",
		dataType:"json",
		data:{"typeCode":"DATA_TRAVEL_ACCOUNT"},
		success:function(data){
			var firstLinkDataList = [];
			var firstLinkDataMap = {};
			$.each(data,function(index,data){
				var firstObj = JSON.parse(data["code"]);
				firstLinkDataList.push(firstObj);
				var arrayList = JSON.parse(data["value"]);
				firstLinkDataMap[firstObj["id"]+""] = arrayList;
				
				TravelCountMap[firstObj["id"]] = firstObj["name"];
				$.each(arrayList,function(index,obj){
					TravelPlanCountMap[obj["id"]] = obj["name"];
				});
			});
			//初始化联动
			linkProvinceSelect({
				firstDataList:firstLinkDataList,
				linkDataMap:firstLinkDataMap,
				proviceUrl:"",
				regionUrl:"",
				levelLinks:[
			                {"eleId":"accountNumSelect","defaultLabel":"请选择帐号"},
			                {"eleId":"accountPlanNumSelect","defaultLabel":"请选择计调"}
			                ]
			});
		},
		error:function(){
			$.error("获取数字旅游帐号信息失败");
		}
	});
})();
</script>
</html>
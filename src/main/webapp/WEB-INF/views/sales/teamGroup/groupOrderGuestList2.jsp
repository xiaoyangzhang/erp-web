<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>团客人名单列表</title>
<%@ include file="../../../include/top.jsp"%>
  <script type="text/javascript">
	
	$(function() {
		var vars={
   			 dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
		 $("input[name='startTime']").val(vars.dateFrom);
		 $("input[name='endTime']").val(vars.dateTo ); 
});
	</script>
</head>
<body>

<div class="p_container">
		<form id="groupOrderGuestForm"　method="post">
			<input type="hidden" name="page" id="page"　value="${pageBean.page }"/>
			<input type="hidden" name="pageSize" id="pageSize"　value="${pageBean.pageSize }"/>
			<input type="hidden" name="userRightType" id="userRightType" value="${userRightType}"/>
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text"> 日期:</li>
						<li >
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
								~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">客人信息:</li>
						<li >
							<input type="text" name="receiveMode" id="receiveMode" value=""/>
						</li>
						
						<li class="text"> 团号:</li>
						<li>
							<input type="text" name="groupCode" id="groupCode" value=""/>
						</li>
						<li class="text">平台来源:</li>
						<li>
							<input name="supplierName" id="supplierName" type="text"/> 
						</li>
					</ul>
					<ul>
						<li class="text" ">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames"readonly="readonly" onclick="showOrg()" style="width: 185px;"/>
							<input type="hidden" name="orgIds" id="orgIds" stag="orgIds"  />	
						</li>
							
						<li class="text" ">
							<select name="operType" id="operType" >
								<option value="1">客服</option>
								<option value="2">计调</option>
								<option value="3">输单员</option>
							</select>
						</li>
						<li>
							<input type="text" name="saleOperatorName" id="saleOperatorName"  stag="userNames" readonly="readonly"  onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
						<li class="text"> 产品类型:</li>
						<li >
							<input type="text" id="dicNames" readonly="readonly"  onclick="commonDicDlg()"/> 
							<input type="hidden" name="orderNo" id="dicIds"  />
						</li>
						<li class="text"> 产品套餐:</li>
						<li >
							<input type="text" name="remark" id="remark" value=""/>
						</li>
					</ul>
					<ul>
						<li class="text" >姓名:</li>
						<li >
							<input type="text" name="guestName" id="guestName" value=""  style="width: 185px;"/>
						</li>
						<li class="text">性别:</li>
						<li class="text" ">
							<select name="gender" id="gender"  style="width: 80px;">
								<option value="">全部</option>
								<option value="1">男</option>
								<option value="0">女</option>
							</select>
						</li>
						<li class="text" style="width: 140px;"> 年龄:</li>
						<li >
							<input type="text" name="ageFirst" id="ageFirst" value="" style="width: 60px;"/>
							~ 
							<input type="text" name="ageSecond" id="ageSecond" value="" style="width: 60px;"/>
						</li>
						<li class="text">籍贯:</li>
						<li >
							<input type="text" name="nativePlace" id="nativePlace" value=""/>
						</li>
						
						<li style="margin-left: 20px;">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<button type="button" onclick="toPickUpExcel()" class="button button-primary button-small">导出地接单</button>
							<button type="button" onclick="toInsuranceExcel()" class="button button-primary button-small">导出保险单 </button>
							<a href="javascript:void(0);" id="toGuestListExcelId" target="_blank" onclick="toGuestListExcel()" class="button button-primary button-small">导出到Excel</a>
						</li>
					</ul>
				</div>
			</div>
		</form>
		<div id="contentGroupOrderGuest"></div>
	</div>
</body>
<script type="text/javascript">
/**
 * 分页查询
 * @param page 
 * @param pageSize
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);
	$("#pageSize").val(pageSize);
	var options = {
		url:"toGroupOrderGuestListPage.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#contentGroupOrderGuest").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#groupOrderGuestForm").ajaxSubmit(options);	
}

$(function () {
	queryList();
});

function searchBtn() {
	queryList(1, $("#pageSize").val());
}
/* 导出地接单 */
function toPickUpExcel(){
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var receiveMode=$('#receiveMode').val();
	var groupCode=$('#groupCode').val();
	var supplierName=$('#supplierName').val();
	
	var orgIds=$('#orgIds').val();
	var orgNames=$('#orgNames').val();
	var operType=$('#operType').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var saleOperatorName=$('#saleOperatorName').val();
	
	var orderMode=$('#dicIds').val();
	var remark=$('#remark').val();
	var page=$('#page').val();
	var pageSize=$('#pageSize').val();
	var userRightType=$('#userRightType').val();
	
	var guestName=$('#guestName').val();
	var gender=$('#gender').val()
	var ageFirst=$('#ageFirst').val()
	var ageSecond=$('#ageSecond').val()
	var nativePlace=$('#nativePlace').val()
	
	window.location ='../taobao/toGroupOrderGuesExport.do?startTime='+startTime
		+"&endTime="+endTime
		+"&receiveMode="+receiveMode
		+"&groupCode="+groupCode
		+"&supplierName="+supplierName
		+"&orgIds="+orgIds
		+"&orgNames="+orgNames
		+"&operType="+operType
		+"&saleOperatorIds="+saleOperatorIds
		+"&saleOperatorName="+saleOperatorName
		+"&orderMode="+orderMode
		+"&remark="+remark
		+"&page="+page
		+"&pageSize="+pageSize
		+"&userRightType="+userRightType
		+"&guestName="+guestName
		+"&gender="+gender
		+"&ageFirst="+ageFirst
		+"&ageSecond="+ageSecond
		+"&nativePlace="+nativePlace;
}
/* 导出保险单 */
function toInsuranceExcel(){
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var receiveMode=$('#receiveMode').val();
	var groupCode=$('#groupCode').val();
	var supplierName=$('#supplierName').val();
	
	var orgIds=$('#orgIds').val();
	var orgNames=$('#orgNames').val();
	var operType=$('#operType').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var saleOperatorName=$('#saleOperatorName').val();
	
	var orderMode=$('#dicIds').val();
	var remark=$('#remark').val();
	var page=$('#page').val();
	var pageSize=$('#pageSize').val();
	var userRightType=$('#userRightType').val();
	
	var guestName=$('#guestName').val();
	var gender=$('#gender').val()
	var ageFirst=$('#ageFirst').val()
	var ageSecond=$('#ageSecond').val()
	var nativePlace=$('#nativePlace').val()
	
	window.location ='../taobao/downloadInsure.htm?startTime='+startTime
			+"&endTime="+endTime
			+"&receiveMode="+receiveMode
			+"&groupCode="+groupCode
			+"&supplierName="+supplierName
			+"&orgIds="+orgIds
			+"&orgNames="+orgNames
			+"&operType="+operType
			+"&saleOperatorIds="+saleOperatorIds
			+"&saleOperatorName="+saleOperatorName
			+"&orderMode="+orderMode
			+"&remark="+remark
			+"&page="+page
			+"&pageSize="+pageSize
			+"&userRightType="+userRightType
			+"&guestName="+guestName
			+"&gender="+gender
			+"&ageFirst="+ageFirst
			+"&ageSecond="+ageSecond
			+"&nativePlace="+nativePlace;
}

/* 导出到Excel */
function toGuestListExcel(){
	$("#toGuestListExcelId").attr("href","toSaleGuestListExcel.do?startTime="+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&receiveMode="+$("#receiveMode").val()
			+"&groupCode="+$("#groupCode").val()
			+"&orgIds="+$("#supplierName").val()
			+"&orgIds="+$("#orgIds").val()
			+"&orgNames="+$("#orgNames").val()
			+"&operType="+$("#operType").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&saleOperatorName="+$("#saleOperatorName").val()
			+"&orderMode="+$("#dicIds").val()
			+"&remark="+$("#remark").val()
			+"&page="+$("#page").val()
			+"&pageSize="+$("#pageSize").val()
			+"&userRightType="+$("#userRightType").val()
			+"&guestName="+$("#guestName").val()
			+"&gender="+$("#gender").val()
			+"&ageFirst="+$("#ageFirst").val()
			+"&ageSecond="+$("#ageSecond").val()
			+"&nativePlace="+$("#nativePlace").val());
}


function commonDicDlg() {
	$.dicItemDlg('SALES_TEAM_TYPE','dicNames','dicIds');
}
</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
</html>
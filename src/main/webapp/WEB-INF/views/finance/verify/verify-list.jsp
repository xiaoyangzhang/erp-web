<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>对账单</title>
<%@ include file="/WEB-INF/include/top.jsp"%>
<link href="<%=staticPath%>/assets/css/supplier/supplier.css" rel="stylesheet" />
<script type="text/javascript">
     $(function() {
 		
		function setData(){
			var curDate=new Date();
			var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
			 $("#startMin").val(startTime);
			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
		     $("#startMax").val(endTime);			
		}
		setData();
 	//queryList();
 	});
     </script>
</head>
<body>
	<div class="p_container">
		<ul id="verifyTabs" class="w_tab">
			<li><a href="verifyList.htm?supplierType=1"  <c:if test="${'1' == supplierType}"> class="selected"</c:if>>组团社</a></li>
			<li><a href="verifyList.htm?supplierType=16"  <c:if test="${'16' == supplierType}"> class="selected"</c:if>>地接社</a></li>
			<li><a href="verifyList.htm?supplierType=2"  <c:if test="${'2' == supplierType}"> class="selected"</c:if>>餐厅</a></li>
			<li><a href="verifyList.htm?supplierType=3" <c:if test="${'3' == supplierType}"> class="selected"</c:if>>酒店</a></li>
			<li><a href="verifyList.htm?supplierType=4" <c:if test="${'4' == supplierType}"> class="selected"</c:if>>车辆</a></li>
			<li><a href="verifyList.htm?supplierType=5" <c:if test="${'5' == supplierType}"> class="selected"</c:if>>门票</a></li>
			<li><a href="verifyList.htm?supplierType=7" <c:if test="${'7' == supplierType}"> class="selected"</c:if>>娱乐</a></li>
			<li><a href="verifyList.htm?supplierType=15" <c:if test="${'15' == supplierType}"> class="selected"</c:if>>保险</a></li>
			<li><a href="verifyList.htm?supplierType=9" <c:if test="${'9' == supplierType}"> class="selected"</c:if>>机票</a></li>
			<li><a href="verifyList.htm?supplierType=10" <c:if test="${'10' == supplierType}"> class="selected"</c:if>>火车票</a></li>
			<li><a href="verifyList.htm?supplierType=120" <c:if test="${'120' == supplierType}"> class="selected"</c:if>>其他收入</a></li>
			<li><a href="verifyList.htm?supplierType=121" <c:if test="${'121' == supplierType}"> class="selected"</c:if>>其他支出</a></li>
			<li class="clear"></li>
		</ul>

		<form id="queryForm">

			<input type="hidden" name="page" id="page" />
			<input type="hidden" name="pageSize" id="pageSize" />
			<input type="hidden" name="supplierType" id="supplierType"  value="${supplierType}" />
			<input type="hidden" name="sl" value="fin.selectVerifyListPage" />
			<input type="hidden" name="rp" value="finance/verify/verify-list-table" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li class="text">对账时间:</li>
						<li><input name="start_min" id="startMin" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~<input name="start_max" id="startMax" type="text" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></li>
						<li class="text">对账单号:</li>
						<li><input name="verify_code" type="text" /></li>
						<li class="text">状态:</li>
						<li><select name="status" class="w-100bi">
								<option value="">全部</option>
								<option value="1">已确认</option>
								<option value="0">未确认</option>
						</select></li>
						<li class="text"></li>
						<li class="text">对账员:</li>
						<li><input name="verify_name" type="text" /></li>
						<c:if test="${'1' == supplierType}">
							<li class="text">组团社:</li>
						</c:if>
						<c:if test="${'16' == supplierType}">
							<li class="text">地接社:</li>
						</c:if>
						<c:if test="${'1' != supplierType && '16' != supplierType}">
							<li class="text">商家名称:</li>
						</c:if>
						<li><input name="supplier_name" type="text" /></li>
						<li class="text"></li>
						<li><input type="button" id="btnQuery" onclick="searchBtn()" class="button button-primary button-small" value="查询"></li>
						<li style="margin-left:10px;"><input type="button"  onclick="addVerifyRecord()" class="button button-primary button-small" value="新增对账单"></li>
					</ul>
				</div>
			</div>
		</form>
	<div id="tableDiv"></div>
	<div id="addVerifyRecordDiv"></div>
</body>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

	function queryList(page, pagesize) {
		if (!page || page < 1) {
			page = 1;
		}
		$("#page").val(page);
		$("#pageSize").val(pagesize);

		var options = {
			url : "../common/queryListPage.htm",
			type : "post",
			dataType : "html",
			success : function(data) {
				$("#tableDiv").html(data);
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error("服务忙，请稍后再试");
			}
		}
		$("#queryForm").ajaxSubmit(options);
	}
	
	function searchBtn() {
		queryList(1, $("#pageSize").val());
	}
	
	$(function() {
		queryList();
		verifyTabName = getVerifyTabName();
	});
	
	function verifySub(id){
		var type=$('#supplierType').val();
		$.ajax({
			url:"../verify/changeStatus.do",
			data:"id="+id+"&supplierType="+type,
			type:"POST",
			success:function(msg){
			 	queryList();
			}
		})
	}
	
	function addVerifyRecord() {
		
		var data = {};
		data.supplierType = ${supplierType };
		$("#addVerifyRecordDiv").load("addVerifyRecord.htm", data);
		
		layer.open({
			type : 1,
			title : '新增对账单',
			closeBtn : false,
			area : [ '400px', '300px' ],
			shadeClose : false,
			content : $("#addVerifyRecordDiv"),
			btn : [ '确定', '取消' ],
			yes : function(index) {
				submitVerifyRecord(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}

	function verifyForm(){
		
		var inputArr = $("#addVerifyForm input");
		for(var i = 0; i < inputArr.length; i++){
			var item = inputArr[i];
			if($(item).val()){
				$(item).css("border-color", "#e7eff1");
			}else{
				$(item).css("border-color", "red");
				return false;
			}
		}
		return true;
	}

	function submitVerifyRecord(index, func){
		
		var verifyRet = verifyForm();
		if(!verifyRet){
			return;
		}
		
		var dataObj = {};
		var inputArr = $("#addVerifyForm input");
		$.each(inputArr, function(){
			var name = $(this).attr("name");
			dataObj[name] = $(this).val();
		});
		
		
		$.post("saveVerifyRecord.do", dataObj, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				layer.close(index);
				toVerifyDetail(data.verifyId);
			}else{
				layer.msg(data.msg, {icon: 5});
			}
		});
	}
	
	function deleteVerify(id){
		
		$.post("deleteVerify.do", {"id": id}, function(data){
			data = $.parseJSON(data);
			if(data.success == true){
				$.success(data.msg);
				location.reload();
			}else{
				$.error(data.msg);
			}
		});
	}
	
	function toVerifyDetail(verifyId){
		
		newWindow(verifyTabName, "<%=staticPath%>/verify/verifyDetail.htm?verifyId="+ verifyId);
	}
	
	function getVerifyTabName(){
		var tabName = "";
		var tabArr = $("#verifyTabs a");
		$.each(tabArr, function(){
			var liClass = $(this).attr("class");
			if(liClass == "selected"){
				tabName = $(this).html();
			}
		});
		return tabName;
	}
</script>
</html>
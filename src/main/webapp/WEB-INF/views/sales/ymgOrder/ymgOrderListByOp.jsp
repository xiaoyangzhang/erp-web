<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
  <script type="text/javascript">
	$(function() {
		var vars={
			dateFrom : $.currentMonthFirstDay(),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
		 $("input[name='startTime']").val(vars.dateFrom);
		 //$("input[name='endTime']").val(vars.dateTo ); 
});
</script>
<%-- <script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/taobaoOrderByOp.js"></script> --%>

<script type="text/javascript">
$(function(){
		  $("#ckAll").live("click",function(){
				 $("input[name='chkGroupOrder']:enabled").prop("checked", this.checked);
		  });
		  $("input[name='chkGroupOrder']").live("click",function() {
		    var $subs = $("input[name='chkGroupOrder']");
		    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
		  });
		
	});

function reloadPage(){
	$.success('操作成功',function(){
		layer.closeAll();
		queryList($("#searchPage").val(), $("#searchPageSize").val());
	});
}

</script>
<script type="text/javascript">
<!-- 回车事件 -->
document.onkeydown = function (e) { 
	var theEvent = window.event || e; 
	var code = theEvent.keyCode || theEvent.which; 
	if (code == 13) { 
	$("#order_btn_key").click(); 
	} 
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
	<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="specialGroupListForm">
					<input type="hidden" name="page" id="orderPage" value="${page.page }">
					<input type="hidden" name="pageSize" id="orderPageSize" value="${page.pageSize}">
					<input type="hidden" name="opType" id="opType" value="${opType}">
					<input type="hidden" name="byType" id="byType" value="2">
					<ul>
						<li class="text">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</li>
						<li>
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">团号:</li><li><input name="groupCode" id="groupCode" type="text" /> </li>
						<li class="text">客人:</li><li><input name="receiveMode" id="receiveMode" type="text" style="width: 184px;"/> </li>
						<li class="text">订单类别:</li><li> <select name="type" id="type">
							<option value=""></option>
							<option value="１">确认</option>
							<option value="0">预留</option>
						</select>
						</li>
						
					</ul>
					<ul>
						<li class="text">平台来源:</li><li><input name="supplierName" id="supplierName" type="text" style="width: 185px;"/> </li>
						<li class="text">游客姓名:</li><li><input name="guestName" id="guestName" type="text" /> </li>
						
						<li class="text">电话:</li><li><input name="mobile" id="mobile" type="text" style="width: 184px;"/> </li>
						
						<li class="text">业务:</li><li>
						<select name="orderMode" id="orderMode">
								<option value="">请选择</option>
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}">${v.value}</option>
							</c:forEach>		
							</select>
						</li>
					</ul>
					<ul>
					<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames"readonly="readonly" onclick="showOrg()" style="width: 185px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" type="hidden" />
						</li>
						<li class="text">
							<select name="operType" id="operType">
								<option value="1">销售</option>
								<option value="2">计调</option>
								<option value="3">输单</option>
							</select>:
						</li>
						<li>
							<input type="text" name="saleOperatorName" stag="userNames" readonly="readonly"  onclick="showUser()" /> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</li>
						<li class="text">产品:</li>
						<li>
							<select name="productBrandId" id="productBrandId"  style="width: 64px;"><option value=""
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select><input name="productName" id="productName" type="text" 　placeholder="请输入产品名称"  style="width: 121px;"/>
						</li>
						<li class="text">产品品牌:</li>
						<li><input name="productBrandName" id="productBrandName" type="text" /> </li>
						</ul>
						<ul>
						<li class="text">状态:</li><li> <select name="stateFinance" id="stateFinance">
								<option value="">审核状态</option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
							</select><select name="orderLockState" id="orderLockState">
								<option value="">流程状态</option>
								<option value="0">未提交</option>
								<option value="1">接收中</option>
								<option value="2">已接收</option>
							</select>
						</li>
						<li style="padding-left:10px">
							<button id="order_btn_key" type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<a href="javascript:void(0);" id="toTaoBaoOperatorExcelId" target="_blank" onclick="toTaoBaoOperatorExcel()" class="button button-primary button-small">导出到Excel</a>
							<a href="javascript:void(0);" id="toTaoBaoSummaryTableId" target="_blank" onclick="toTaoBaoSummaryTable()" class="button button-primary button-small">导出简表</a>
						</li>
						<li class="clear"></li>
					</ul>
				</form>
			</div>
		</div>
		<dl class="p_paragraph_content">
			<div id="content"></div>
		</dl>
	</div>
</body>
<div id="stateModal" style="display: none">
		<input type="hidden" name="id" id="modalgroupId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">状态:</div>
				<div class="dd_right">
					<select name="groupState" id="modalGroupState">
						<option value="0">未确认</option>
						<option value="1">已确认</option>
						<option value="2">废弃</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="button" class="button button-primary button-small" onclick="editOrderGroupInfo()">确定</button>
		</div>
	</div>


<script type="text/javascript">
function goLogStock(orderId) {
	showInfo("计调操作单日志","950px","550px","<%=staticPath%>/basic/singleList.htm?tableName=group_order&tableId=" + orderId);
}

function showInfo(title, width, height, url) {
	layer.open({
		type : 2,
		title : title,
		shadeClose : true,
		shade : 0.5,
		area : [width,height],
		content : url
	});
}

/**
 * 分页查询
 * @param page 
 * @param pageSize
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#orderPage").val(page);
	$("#orderPageSize").val(pageSize);
	var options = {
		/*url:"getSpecialGroupData.do",*/
		url:"ymgOrderListByOp_table.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.warn("服务忙，请稍后再试",{icon:1,time:1000});
    	}
    };
    $("#specialGroupListForm").ajaxSubmit(options);	
}

function searchBtn() {
	var pageSize=$("#orderPageSize").val();
	queryList(1,pageSize);
}
function refershPage(){
	var pageSize=$("#orderPageSize").val();
	var page=$("#orderPage").val();
	queryList(page, pageSize);
}

$(function(){
	queryList();
});
</script>
</html>
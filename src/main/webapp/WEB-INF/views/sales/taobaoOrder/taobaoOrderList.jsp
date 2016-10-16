<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
		 $("input[name='endTime']").val(vars.dateTo ); 
});
	</script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/taobaoOrderList.js"></script>

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

	
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form method="post" id="specialGroupListForm">
					<input type="hidden" name="page" id="orderPage" value="${page.page }">
					<input type="hidden" name="pageSize" id="orderPageSize" value="${page.pageSize}">
					
					<dd class="inl-bl">
						<div class="dd_left"style="width:100px;">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</div>
						<div class="dd_right ">
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						&nbsp; &nbsp; 团号：　<input name="groupCode" id="groupCode" type="text" />
						&nbsp; &nbsp; 客户:　<input name="supplierName" id="supplierName" type="text" />
						&nbsp; &nbsp; 客人： <input name="receiveMode" id="receiveMode" type="text" />
						&nbsp; &nbsp; 业务类型：<select name="GroupMode" id="GroupMode">
								<option value="">请选择</option>
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}"<c:if test='${vo.groupOrder.tourGroup.groupMode==v.id}'>selected='selected'</c:if> >${v.value}</option>
							</c:forEach>		
							</select>
						&nbsp; &nbsp; 审核状态: <select name="stateFinance" id="stateFinance">
								<option value="">全部</option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
							部门:
						</div>
						<div class="dd_right">
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames"readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" type="hidden" />	
						<select name="operType">
								<option value="1">销售计调</option>
								<option value="2">操作计调</option>
								<option value="3">输单员</option>
							</select>
							<input type="text" name="saleOperatorName" stag="userNames" readonly="readonly"  onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						&nbsp; &nbsp; 产品：<select name="productBrandId" id="productBrandId"><option value=""
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select>　<input name="productName" id="productName" type="text" 　placeholder="请输入产品名称"/>
						
							&nbsp; &nbsp; 客源地：<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }">${province.name}</option>
								</c:forEach>
							</select> 
							<select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
									<option value="${city.id }">${city.name }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					
					
					
					
					
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<button type="button" onclick="addNewSpecialGroup()" class="button button-primary button-small">新增订单</button>
						</div>
						<div class="clear"></div>
					</dd>
					
				</form>
			</dl>
			<dl class="p_paragraph_content">
		
					<div id="content"></div>
			</dl>
	    </div>
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
function  addNewSpecialGroup(){
	newWindow('新增订单','taobao/addNewTaobaoOrder.htm');
}
</script>
</html>
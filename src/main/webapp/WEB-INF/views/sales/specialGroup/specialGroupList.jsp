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
	src="<%=ctx%>/assets/js/web-js/sales/specialGroup.js"></script>

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
						<div class="dd_left">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</div>
						<div class="dd_right grey">
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">组团社:</div>
						<div class="dd_right grey">
							<input name="supplierName" id="supplierName" type="text" />
							
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input name="groupCode" id="groupCode" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品品牌:</div>
						<div class="dd_right grey">
							<select name="productBrandId" id="productBrandId"><option value=""
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productName" id="productName" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					
					<dd class="inl-bl">
						<div class="dd_left">接站牌:</div>
						<div class="dd_right grey">
							<input name="receiveMode" id="receiveMode" type="text" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客源地:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode">
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
						<div class="dd_left">客源地类型:</div>
						<div class="dd_right grey">
							<select name="sourceTypeName" id="sourceTypeName">
								<option value="-1">全部</option>
							<c:forEach items="${sourceTypeList }" var="typeName">
								<option value="${typeName.id }">${typeName.value }</option>
							</c:forEach>
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
						计调:
						<select name="operType">
								<option value="1">销售计调</option>
								<option value="2">操作计调</option>
								<option value="3">输单员</option>
							</select>
							<input type="text" name="saleOperatorName" stag="userNames" readonly="readonly"  onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">并团状态:</div>
						<div class="dd_right grey">
							<select name="state" id="state">
								<option value="">全部</option>
								<option value="1">已并团</option>
								<option value="2">未并团</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">锁单状态:</div>
						<div class="dd_right grey">
							<select name="orderLockState" id="orderLockState">
								<option value="">全部</option>
								<option value="0">未锁单</option>
								<option value="1">已锁单</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left"></div>
						<div class="dd_right">
							<button type="button" onclick="addNewSpecialGroup()" class="button button-primary button-small">新增订单</button>
							<a href="javascript:void(0)"
	            			class="button button-primary button-rounded button-small mr-20" onclick="toPreview()">打印预览</a>
						
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
<script type="text/javascript">
function  addNewSpecialGroup(){
	newWindow('新增一地散订单','specialGroup/toAddSpecialGroup.htm');
}
function toPreview(){
	window.open("<%=staticPath%>/specialGroup/specialGroupPreview.htm?dateType="+$("#dateType").val()+"&startTime="+$("#startTime").val()+
					"&endTime="+$("#endTime").val()+"&groupCode="+$("#groupCode").val()+"&productBrandId="+$("#productBrandId option:selected").val()+
					"&productName="+$("#productName").val()+"&state="+$("#state option:selected").val()+"&orderLockState="+$("#orderLockState option:selected").val()+
					"&supplierName="+$("#supplierName").val()+"&receiveMode="+$("#receiveMode").val()+"&provinceId="+$("#provinceCode option:selected").val()+"&cityId="+$("#cityCode option:selected").val()+
					"&orgIds="+$("#orgIds").val()+"&saleOperatorIds="+$("#saleOperatorIds").val()+"&page="+$("#orderPage").val()+
					"&pageSize="+$("#orderPageSize").val()+"&sourceTypeName="+$("#sourceTypeName option:selected").text());
}
</script>
</html>
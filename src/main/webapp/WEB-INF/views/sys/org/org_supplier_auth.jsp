<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<head>
<%@ include file="/WEB-INF/include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/sys/yihg_erp_link_province.js"></script>
</head>
<div class="p_container">
	<div id="divCenter" class="component_div">
		<form id="searchSupplierForm">
			<input type="hidden" name="page" value="1" id="searchPage" /> <input
				type="hidden" name="pageSize" value="15" id="searchPageSize" /> <input
				type="hidden" name="supplierType" value="1" id="searchSupplierType" />
			<input type="hidden" name="orgid" value="${requestParam.orgid}" />
			<div class="p_container_sub">
				<div class="searchRow">
					<ul>
						<li>请选择: <select id="provinceNameSelect" class="input-small"
							name="provinceId">
						</select> <select id="cityNameSelect" class="input-small" name="cityId">
						</select> <select id="areaNameSelect" class="input-small" name="areaId">
						</select>
						</li>
						<li class="text">名称</li>
						<li>
						<li><input type="text" name="nameFull" /></li>
						<li class="text">选择状态</li>
						<li><select name="authStatus" id="authStatus">
								<option value="0">--请选择--</option>
								<option value="1" selected>已授权</option>
								<option value="2">未授权</option>
						</select></li>
						<li><button type="button"
								class="button button-primary button-small"
								onclick="searchBtn();">搜索</button></li>
						<li class="clear" />
					</ul>
				</div>
			</div> 
		</form>
		<div id="orgSupplierAuthDiv"></div>
	</div>
</div>

<script type="text/javascript">

	//获取组织机构所拥有的所有权限
 	var ownSupplierIds =[<c:forEach items="${supplierIds}" var="supplierId">${supplierId},</c:forEach> -1];
	var noOwnSupplierIdsMap = {};
	//解析成Map判断选中状态
	var ownSupplierIdsMap = {};
	
	//组织机构特有的组团社权限
	var orgOwnSupplierIds = [<c:forEach items="${orgOwnSupplierIds}" var="ownSupplierId">${ownSupplierId},</c:forEach> -1];
	var orgOwnSupplierIdsMap = {};
	
	//最新的选择状态
	var orgLastAuthMap = {};
	
	if(ownSupplierIds && ownSupplierIds.length){
		var ownSupplierIdsIndex = 0;
		for(;ownSupplierIdsIndex < ownSupplierIds.length;ownSupplierIdsIndex++)
		{
			var ownSupplierId = ownSupplierIds[ownSupplierIdsIndex];
			ownSupplierIdsMap[ownSupplierId] = 1;
		}
	}
	
	if(orgOwnSupplierIds &&orgOwnSupplierIds.length)
	{
		var orgOwnSupplierIdsIndex = 0;
		for(;orgOwnSupplierIdsIndex < orgOwnSupplierIds.length;orgOwnSupplierIdsIndex++)
		{
			var orgOwnSupplierId = orgOwnSupplierIds[orgOwnSupplierIdsIndex];
			orgOwnSupplierIdsMap[orgOwnSupplierId] = 1;
		}
	}
	
	for(key in ownSupplierIdsMap){
		if(!orgOwnSupplierIdsMap[key]){
			noOwnSupplierIdsMap[key] = 1;
		}
	}
	
	//初始状态设置和orgOwnSupplierIdsMap一样 深度拷贝 创建出 一个 新对象 而不是 引用
	 $.extend(true,orgLastAuthMap,orgOwnSupplierIdsMap);
	
	
	
	//全选状态事件
	function checkAllSupplier(thisObj){
		var jqChkAllObj = $(thisObj);
		var checkStatus = jqChkAllObj.attr("checked");
		$(".single-org-supplier-auth").each(function(i){
			var singleChkObj = $(this);
			var singleChkObjVal = singleChkObj.val()+"";
			var singleChkStatus = singleChkObj.attr("checked");
			if(!noOwnSupplierIdsMap[singleChkObjVal]){
				if(checkStatus){
					if(!singleChkStatus){
						singleChkObj.attr("checked",true);
						orgLastAuthMap[singleChkObjVal]=1;
					}
				}else{
					if(singleChkStatus){
						singleChkObj.attr("checked",false);
						orgLastAuthMap[singleChkObjVal]=0;
					}
				}
			}
		})
	}
	
	//获取设置的权限
	var getOrgAuthSuppliers = function(){
		var newAuthsMap = {};
		var delAuths = [];
		var addAuths = [];
		for(supplierId in orgLastAuthMap)
		{
			if(!orgOwnSupplierIdsMap[supplierId] && orgLastAuthMap[supplierId]){
				//新增的组团社id
				addAuths.push(parseInt(supplierId));
			}
			if(orgOwnSupplierIdsMap[supplierId] && !orgLastAuthMap[supplierId]){
				//移除的组团社id
				delAuths.push(parseInt(supplierId));
			}
		}
		return {"delSupplierIds":delAuths,"addSupplierIds":addAuths};
	}
	//状态重置
	function dealAfterAjax(){
		var authSuppliersMap = getOrgAuthSuppliers();
		var delSupplierIds = authSuppliersMap["delSupplierIds"];
		var addSupplierIds = authSuppliersMap["addSupplierIds"];
		orgOwnSupplierIds = _.union(_.difference(orgOwnSupplierIds,delSupplierIds),addSupplierIds);
		orgOwnSupplierIdsMap = {};
		if(orgOwnSupplierIds &&orgOwnSupplierIds.length)
		{
			var orgOwnSupplierIdsIndex = 0;
			for(;orgOwnSupplierIdsIndex < orgOwnSupplierIds.length;orgOwnSupplierIdsIndex++)
			{
				var orgOwnSupplierId = orgOwnSupplierIds[orgOwnSupplierIdsIndex];
				orgOwnSupplierIdsMap[orgOwnSupplierId] = 1;
			}
		}
		orgLastAuthMap = {};
		$.extend(true,orgLastAuthMap,orgOwnSupplierIdsMap);
	}
	//单选状态事件
	function checkSingleSupplier(thisObj){
		var jqCheckObj = $(thisObj);
		var chkValue =  jqCheckObj.val()+"";
		var checkStatus = jqCheckObj.attr("checked");
		if(checkStatus){
			orgLastAuthMap[chkValue] = 1;
		}else{
			orgLastAuthMap[chkValue] = 0;
		}
	}
	//根据最新的选择判断最新的选中事件
	function checkLastCheckStatus(){
		$(".single-org-supplier-auth").each(function(i){
			var jqObj = $(this);
			var curSupplierId = jqObj.val()+"";
			if(noOwnSupplierIdsMap[curSupplierId] && !orgLastAuthMap[curSupplierId]){
				jqObj.attr("disabled",true);
				jqObj.attr("checked",true);
				return true;
			}
			
			if(orgLastAuthMap[curSupplierId]){
				jqObj.attr("checked",true);
			}else{
				jqObj.attr("checked",false);
			}
		});
	}
	//jiush
	function getTableTemplate(){
		var options = {
				url:"orgSupplierAuthTable.do",
		    	type:"post",
		    	dataType:"html",
		    	success:function(data){
		    		$("#orgSupplierAuthDiv").html(data);
		    		dealAfterAjax();
		    		checkLastCheckStatus();
		    	},
		    	error:function(XMLHttpRequest, textStatus, errorThrown){
		    		$.error("服务忙，请稍后再试");
		    	}
		    };
		    $("#searchSupplierForm").ajaxSubmit(options);
	}
	//分页页面调用的函数
	function queryList(page,pageSize){
		$("#searchPage").val(page || 1);
		$("#searchPageSize").val(pageSize || 15);
		getTableTemplate();
	}
	
	//点击按调用
	function searchBtn(){
		$("#searchPage").val(1);
		$("#searchPageSize").val(15);
		getTableTemplate();
	}
	
	//初始化运行
	(function(){
		//初始化联动
		linkProvinceSelect({
			levelLinks:[
		                {"eleId":"provinceNameSelect","defaultLabel":"请选择省"},
		                {"eleId":"cityNameSelect","defaultLabel":"请选择市"},
		                {"eleId":"areaNameSelect","defaultLabel":"请选择县"}
		                ]
		});
		searchBtn();	
	})();
</script>

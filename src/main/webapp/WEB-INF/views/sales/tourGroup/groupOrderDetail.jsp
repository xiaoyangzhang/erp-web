<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/groupOrder.js"></script>
	<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
<style type="text/css">
	.Wdate{width:300px ;}
</style>

</head>
<body>
	<div class="p_container"> 
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toGroupOrder()" class="selected">订单详情</a></li>
			<li><a href="javascript:void(0);" onclick="toGetRouteList()">行程列表</a></li>
			<li><a href="javascript:void(0);" onclick="toOtherInfo()">其他信息</a></li>
			<li><a href="javascript:void(0);" onclick="togroupRequirement()">计调需求</a></li>
			<li class="clear"></li>
		</ul>
		<div class="p_container_sub">
			<form id="groupOrderForm" method="post">
				<input type="hidden" name="id" id="orderId" value="${groupOrder.id}" />
				<input type="hidden" id="groupId" name="groupId" value="${tourGroup.id}" />
				<input type="hidden" id="stateFinance" name="" value="${stateFinance}" />
				<input type="hidden" id="state" name="" value="${state}" />
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">类别:</div>
						<select name="groupMode" class="select160"
							style="width: 310px; text-align: right">
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}" style="height: 23px; text-align: right"
									<c:if test='${tourGroup.groupMode==v.id}'>selected='selected'</c:if>>${v.value}</option>
							</c:forEach>
						</select>
					</dd>
					<dd>
						<div class="dd_left">团号:</div>
						<input name="" value="${tourGroup.groupCode}" class="IptText300"
							placeholder="系统自动产生" readonly="readonly" type="text">
					</dd>
					<dd>
						<div class="dd_left">团号标识:</div>
						<input name="groupCodeMark" value="${tourGroup.groupCodeMark}" class="IptText300"
							placeholder="团号标识"  type="text">
					</dd>
					<dd>
						<div class="dd_left">
							销售计调 :
						</div>
						<input name="saleOperatorName" id="saleOperatorName"
							value="${groupOrder.saleOperatorName}" placeholder="请选择"
							readonly="readonly" class="IptText300" type="text"> 
							<c:if test="${stateFinance!=1}">
								<a href="javascript:void(0);" onclick="selectUser(1)">请选择</a> 
							</c:if>
							<input
							type="hidden" name="saleOperatorId" id="saleOperatorId"
							value="${groupOrder.saleOperatorId}" />
					</dd>
					<dd>
						<div class="dd_left">
							操作计调:
						</div>
						<input name="operatorName" id="operatorName" placeholder="请选择"
							readonly="readonly" value="${groupOrder.operatorName}"
							class="IptText300" type="text"> 
							<c:if test="${stateFinance!=1}">
								<a href="javascript:void(0);" onclick="selectUser(2)">请选择</a>
							</c:if>
							<input
							type="hidden" name="operatorId" id="operatorId"
							value="${groupOrder.operatorId}">
					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>开始日期:
						</div>
						<input type="text" name="dateStart"
							value='<fmt:formatDate value="${tourGroup.dateStart}" pattern="yyyy-MM-dd"/>'
							class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					</dd>
					<dd>
						<div class="dd_left"><i class="red">*</i>接站牌内容:</div>
						<input type="text" name="receiveMode"
							value="${groupOrder.receiveMode}" id="receiveMode"
							class="IptText300" />
					</dd>
					<dd>
					<div class="dd_left">客源类别</div>
					
						<input type="hidden" name="sourceTypeName" class="IptText300"  id="sourceTypeName" value="${groupOrder.sourceTypeName }" />
						<select name="sourceTypeId" id="sourceTypeCode">
							<option value="-1">请选择</option>
							<c:forEach items="${sourceTypeList }" var="source">
								<option value="${source.id }" <c:if test="${groupOrder.sourceTypeId==source.id  }"> selected="selected" </c:if>>${source.value}</option>
							</c:forEach>
						</select>
				
				</dd>
				<dd>
					<div class="dd_left">客源地</div>
					
						<input type="hidden" name="provinceName" class="IptText300" id="provinceName" value="${ groupOrder.provinceName}"  />
						<input type="hidden" name="cityName" class="IptText300" id="cityName" value="${groupOrder.cityName }" />
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
					
				</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>组团社名称:
						</div>
						<input id="supplierName" name="supplierName" type="text" value="${groupOrder.supplierName}" style="width:300px;cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" />
						<c:if test="${stateFinance!=1}">
							<a href="javascript:void(0);" onclick="selectSupplier()">请选择</a>
						</c:if>
						<input id="supplierId" name="supplierId" type="hidden" value="${groupOrder.supplierId}"/>	
						<input id="supplierType" name="" type="hidden" value="1"/>	
					</dd>
					<dd>
						<div class="dd_left">组团社团号:</div>
						<input type="text" name="supplierCode"
							value="${groupOrder.supplierCode}" id="supplierCode"
							class="IptText300" />
					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>联系人:
						</div>
						<input type="text" autocomplete="off" name="contactName"
							value="${groupOrder.contactName}" id="contactName"
							placeholder="请选择" class="IptText300"/> 
							<c:if test="${stateFinance!=1}">
								<a href="javascript:void(0);" onclick="selectContact()"><span id="selA">请选择</span></a>
							</c:if>
					</dd>
					<dd>
						<div class="dd_left">
							手机号:
						</div>
						<input type="text" name="contactMobile"
							value="${groupOrder.contactMobile}" id="contactMobile"
							class="IptText300" />
					</dd>
					<dd>
						<div class="dd_left">
							座机号:
						</div>
						<input type="text" name="contactTel"
							value="${groupOrder.contactTel}" id="contactTel"
							class="IptText300" />
					</dd>
					<dd>
						<div class="dd_left">
							传真号:
						</div>
						<input type="text" name="contactFax"
							value="${groupOrder.contactFax}" id="contactFax"
							class="IptText300" />
					</dd>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>团人数:
						</div>
						<input style="width: 92px;" type="text" name="totalAdult" placeholder="成人数" value="${tourGroup.totalAdult }" id="totalAdult"/>
						<input style="width: 92px;" type="text" name="totalChild" placeholder="小孩数" value="${tourGroup.totalChild }<c:if test="${empty tourGroup.totalChild }">0</c:if>" id="totalChild"/>
						<input style="width: 92px;" type="text" name="totalGuide" placeholder="全陪数" value="${tourGroup.totalGuide }<c:if test="${empty tourGroup.totalGuide }">0</c:if>" id="totalGuide"/>
						(成人数~小孩数~全陪数)
					</dd>
					<dd>
						<div class="dd_left">内部备注 :</div>
						<textarea class="w_textarea" name="remarkInternal" value=""
							id="remarkInternal" >${groupOrder.remarkInternal}</textarea>
					</dd>
					<c:if test="${stateFinance!=1}">
						<div class="modal-footer" style="margin-left: 25%;">
							<button type="submit" class="button button-primary button-small">保存</button>
						</div>
					</c:if>
				</div> 
			</form> 
		</div> 
	</div>
</body>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
    
<script type="text/javascript">
	var supplierType = $("#supplierType").val() ;
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath%>/tourGroup/getSupplier?supplierType="+1, param, "supplierId", customerTicketCallback, 1);
       	JAutocompleteEx('#contactName', '<%=staticPath%>/tourGroup/getSupplierAndContact?supplierId', param, 'contactMobile', contactCallback, 0) ;
    });
    function customerTicketCallback(event, value) {
        
    }
	function contactCallback(event, value) {
		var val = value.split('@');
		$("#contactTel ").val(val[0]);
		$("#contactFax").val(val[1]);
    }
    </script>
</html>
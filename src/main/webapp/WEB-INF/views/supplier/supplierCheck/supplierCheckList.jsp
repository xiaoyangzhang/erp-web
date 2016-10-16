<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../../../include/top.jsp"%>
<style type="text/css">
.Wdate {
	width: 95px;
}
</style>
<script type="text/javascript">
	
	function queryList(page,pageSize){
		if (!page || page < 1) {
			page = 1;
		}
		$("#searchPage").val(page);
		$("#searchPageSize").val(pageSize);
		var $form = $("#supplierCheckForm");
		//var supplierType = $form.find("[name='supplierType']").val();
		//$form.attr('action', supplierMap[supplierType]);
		$form.submit();
	}
</script>

</head>
<body>
	<div class="p_container">

		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form id="supplierCheckForm" action="supplierCheckList.htm"
					method="post">
					<input type="hidden" name="page" value="${supplierInfo.page}"
						id="searchPage" /> <input type="hidden" name="pageSize"
						value="${supplierInfo.pageSize}" id="searchPageSize" /> 
					<dd class="inl-bl">
						<div class="dd_left">名称:</div>
						<div class="dd_right grey">
							<input type="text" name="nameFull"
								value="${supplierInfo.nameFull }" class="input-small" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">类别:</div>
						<div class="dd_right grey">
							<select id="type" name="supplierType">
		                    <option value="" <c:if test="${ page.parameter.supplierType eq null}">selected="selected"</c:if>>全部</option>
		                    <option value="1" <c:if test="${ page.parameter.supplierType eq 1}">selected="selected"</c:if>>组团社</option>
		                    <option value="2" <c:if test="${ page.parameter.supplierType eq 2}">selected="selected"</c:if>>餐厅</option>
		                    <option value="3" <c:if test="${ page.parameter.supplierType eq 3}">selected="selected"</c:if>>酒店</option>
		                    <option value="4" <c:if test="${ page.parameter.supplierType eq 4}">selected="selected"</c:if>>车队</option>
		                    <option value="5" <c:if test="${ page.parameter.supplierType eq 5}">selected="selected"</c:if>>景区</option>
		                    <option value="6" <c:if test="${ page.parameter.supplierType eq 6}">selected="selected"</c:if>>购物</option>
		                    <option value="9" <c:if test="${ page.parameter.supplierType eq 9}">selected="selected"</c:if>>机票</option>
		                    <option value="10" <c:if test="${ page.parameter.supplierType eq 10}">selected="selected"</c:if>>火车票</option>
		                    <option value="12" <c:if test="${ page.parameter.supplierType eq 12}">selected="selected"</c:if>>其他</option>
		                    <option value="15" <c:if test="${ page.parameter.supplierType eq 15}">selected="selected"</c:if>>保险</option>
		                    <option value="16" <c:if test="${ page.parameter.supplierType eq 16}">selected="selected"</c:if>>地接社</option>
		                    <option value="120" <c:if test="${ page.parameter.supplierType eq 120}">selected="selected"</c:if>>其他收入</option>
		                    <option value="121" <c:if test="${ page.parameter.supplierType eq 121}">selected="selected"</c:if>>其他支出</option>
		                  </select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn();"
								class="button button-primary button-small">查询</button>
							<%-- <c:if test="${optMap['EDIT'] }"> --%>
								<a class="button button-primary button-small" onclick="checkSuppliers()"
									href="javascript:void(0)">审核</a>
								
							<%-- </c:if> --%>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">
			<table class="w_table" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="5%">
					<col width="5%">
					<col width="5%">
					<col width="5%">
					<col width="15%">
					<col width="5%">
					<col width="15%">
					
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" onclick="checkAll(this)" />全选</th>
						<th>序号<i class="w_table_split"></i></th>
						<th>录入日期<i class="w_table_split"></i></th>
						<th>类型<i class="w_table_split"></i></th>
						<th>名称<i class="w_table_split"></i></th>
						<th>法人<i class="w_table_split"></i></th>
						<th>地址<i class="w_table_split"></i></th>
						
					</tr>
				</thead>
				<c:forEach items="${page.result}" var="supplierInfo"
					varStatus="status">
					<tr>
						<td><input type="checkbox"  name="audit_id" supplierId="${supplierInfo.id }" />
							
						</td>
						<td>${status.count}</td>
						<td><fmt:formatDate pattern='yyyy/MM/dd'
								value='${supplierInfo.createTime}' /></td>
						<td>
							<c:if test="${supplierInfo.supplierType==1}">组团社</c:if> 
							<c:if test="${supplierInfo.supplierType==2}">餐厅
							</c:if> <c:if test="${supplierInfo.supplierType==3}">酒店
								
							</c:if> <c:if test="${supplierInfo.supplierType==4}">车队
								
							</c:if> <c:if test="${supplierInfo.supplierType==5}">景区
								
							</c:if> <c:if test="${supplierInfo.supplierType==6}">购物
								
							</c:if> <c:if test="${supplierInfo.supplierType==9}">机票
								
							</c:if> <c:if test="${supplierInfo.supplierType==10}">火车票
								
							</c:if>  <c:if test="${supplierInfo.supplierType==12}">其他
								
							</c:if> <c:if test="${supplierInfo.supplierType==15}">保险
								
							</c:if> <c:if test="${supplierInfo.supplierType==16}">地接社
								
						
							</c:if> <c:if test="${supplierInfo.supplierType==120}">其他收入
								
							
							</c:if> <c:if test="${supplierInfo.supplierType==121}">其他支出
								
							</c:if>
						</td>
						<td style="text-align: left;">${supplierInfo.nameFull}</td>
						<td>${supplierInfo.lawPerson }</td>
						<td style="text-align: left;">${supplierInfo.provinceName }${supplierInfo.cityName }${supplierInfo.areaName }${supplierInfo.townName }${supplierInfo.address }</td>
						
					</tr>
				</c:forEach>
			</table>
			<jsp:include page="/WEB-INF/include/page.jsp">
				<jsp:param value="${page.page }" name="p" />
				<jsp:param value="${page.totalPage }" name="tp" />
				<jsp:param value="${page.pageSize }" name="ps" />
				<jsp:param value="${page.totalCount }" name="tn" />
			</jsp:include>
			</dl>

		</div>
	</div>
</body>
<script type="text/javascript">
function checkAll(ckbox) {
	if ($(ckbox).attr("checked")) {
		$("input[name='audit_id']").attr('checked', 'checked');
	} else {
		$("input[name='audit_id']").removeAttr("checked");
	}
}
function searchBtn(){
	queryList();
}
function checkSuppliers(){
	var checkedArr = [];
	//var unCheckedArr = [];
	$("input[name='audit_id']:checked").each(function(i, o) {
		var json = '{"id":'+ $(o).attr("supplierId")  +'}';
		//if ($(o).attr("checked")) {
			checkedArr.push(json);
		//} 
	});
	var pm={};
	 pm.checkedSupplierIds ='['+checkedArr.join()+']';
	//pm.unCheckedIds = '['+ unCheckedArr.join() +']';
	if(pm.checkedSupplierIds==null || pm.checkedSupplierIds==''){
		$.warn("请选择要审核的供应商");
		return false;
	}
	YM.post("<%=ctx%>/supplier/checkSupplier.do", pm, function(data) {
		$.success('操作成功');
		queryList();
	});
}
</script>
</html>
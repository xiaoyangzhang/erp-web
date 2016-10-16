<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>未并团列表</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/notGroupOrder.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/regional.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript">

	$(function(){
	
		
		$("#ckAll").click(function() {
		    $("input[name='chkGroupOrder']").prop("checked", this.checked);
		  });
		  
		  $("input[name='chkGroupOrder']").click(function() {
		    var $subs = $("input[name='chkGroupOrder']");
		    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
		  });
		
	})
    /*  $(function() {
 		function setData(){
 			var curDate=new Date();
 			 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
 			 $("#startTime").val(startTime);
 			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
 		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
 		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
 		     $("#endTime").val(endTime);			
 		}
 		setData();
 	//queryList();
 	
 	 
 }); */
	
	</script>
</head>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
<body>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form action="toNotGroupList.htm" method="post"
					id="toNotGroupListForm">
					<input type="hidden" name="page" id="groupPage"
						value="${groupOrder.page}"> <input type="hidden"
						name="pageSize" id="pageSize" value="${groupOrder.pageSize}">
					<dd class="inl-bl">
						<div class="dd_left">产品品牌:</div>
						<div class="dd_right grey">
							<select name="productBrandId"><option value="-1"
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}"
										<c:if test="${groupOrder.productBrandId==pp.id }"> selected="selected" </c:if>>${pp.value }</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productName" type="text"
								value="${groupOrder.productName}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">组团社名称:</div>
						<div class="dd_right grey">
							<input name="supplierName" type="text"
								value="${groupOrder.supplierName}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">接站牌:</div>
						<div class="dd_right grey">
							<input name="receiveMode" type="text"
								value="${groupOrder.receiveMode}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">
							<select name="dateType">
								<option value="1" <c:if test="${groupOrder.dateType==1 }">selected="selected"</c:if> >出团日期</option>
								<option value="2" <c:if test="${groupOrder.dateType==2 }">selected="selected"</c:if> >输单日期</option>
							</select>
						</div>
						<div class="dd_right grey">
							<input name="departureDate" type="text" id="startTime"
								value="${groupOrder.departureDate }" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /> ~ <input
								name="endTime" value="${groupOrder.endTime}" type="text"
								id="endTime" class="Wdate"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">客源地:</div>
						<div class="dd_right grey">
							<select name="provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }"
										<c:if test="${groupOrder.provinceId==province.id  }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
							</select> <select name="cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
									<option value="${city.id }"
										<c:if test="${groupOrder.cityId==city.id  }"> selected="selected" </c:if>>${city.name }</option>
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
						
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${groupOrder.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${groupOrder.orgIds }" type="hidden" value=""/>	
						计调:
						<select name="operType">
								<!-- 							<option value="-1">全部</option> -->
								<option value="1" <c:if test="${groupOrder.operType==1 }">selected="selected"</c:if>  >销售计调</option>
								<option value="2" <c:if test="${groupOrder.operType==2 }">selected="selected"</c:if>>操作计调</option>
							</select>
							<input type="text" name="saleOperatorName" id="saleOperatorName"
								value="${groupOrder.saleOperatorName}" stag="userNames" readonly="readonly"  onclick="showUser()"/> <input
								name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
								value="${groupOrder.saleOperatorIds}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_right">
							<button type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
						</div>
						<div class="clear"></div>
					</dd>
				</form>
			</dl>
			<dl class="p_paragraph_content">
				<table cellspacing="0" cellpadding="0" class="w_table">
					<thead>
						<tr>
							<th style="width: 3%"><input type="checkbox" id="ckAll"><i
								class="w_table_split"></i></th>
							<th style="width: 3%">序号<i class="w_table_split"></i></th>
							<th>产品名称<i class="w_table_split"></i></th>
							<th style="width: 5%">出发日期<i class="w_table_split"></i></th>
							<th style="width: 5%">散团日期<i class="w_table_split"></i></th>
							<th style="width: 15%">组团社<i class="w_table_split"></i></th>
							<th style="width: 5%">接站牌<i class="w_table_split"></i></th>
							<th style="width: 5%">客源地<i class="w_table_split"></i></th>
							<th style="width: 5%">联系人<i class="w_table_split"></i></th>
							<th style="width: 8%">人数<i class="w_table_split"></i></th>
							<th style="width: 5%">金额<i class="w_table_split"></i></th>
							<th style="width: 5%" title="财务审核状态">状态<i
								class="w_table_split"></i></th>
							<th style="width: 5%">销售<i class="w_table_split"></i></th>
							<th style="width: 5%">计调<i class="w_table_split"></i></th>
							<th style="width: 5%">输单员<i class="w_table_split"></i></th>
							<th style="width: 10%">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${page.result}" var="groupOrder" varStatus="v">
							<tr title="创建时间:${groupOrder.createTimeStr}">
								<td><input type="checkbox" name="chkGroupOrder"
									value="${groupOrder.id}"></td>
								<td>${v.count}</td>
								<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName}</td>
								<td>${groupOrder.departureDate}</td>
								<td>${groupOrder.fitDate}</td>
								<td style="text-align: left;">${groupOrder.supplierName}</td>
								<td>${groupOrder.receiveMode}</td>
								<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
								<td>${groupOrder.contactName}</td>
								<td>${groupOrder.numAdult }大${groupOrder.numChild}小</td>
								<td><fmt:formatNumber value="${groupOrder.total}"
										type="currency" pattern="#.##" /></td>
								<td><c:if test="${groupOrder.stateFinance==1}">已审核</c:if> <c:if
										test="${groupOrder.stateFinance!=1}">未审核</c:if></td>
								<td>${groupOrder.saleOperatorName}</td>
								<td>${groupOrder.operatorName}</td>
								<td>${groupOrder.creatorName}</td>

								<td><a href="javascript:void(0);" class="def"
									onclick="newWindow('查看订单','groupOrder/toLookGroupOrder.htm?id=${groupOrder.id}')">查看</a>
									<a href="javascript:void(0);"
									onclick="insertGroupByList(${groupOrder.id})" class="def">加入团</a> <c:if
										test="${optMap['EDIT'] && groupOrder.stateFinance!=1 }">
										<a href="javascript:void(0);" class="def"
											onclick="newWindow('编辑订单','groupOrder/toEditGroupOrder.htm?id=${groupOrder.id}')">
											编辑</a>
									</c:if> <c:if
										test="${optMap['EDIT'] && (groupOrder.stateFinance ==null || groupOrder.stateFinance==0) && (groupOrder.totalCash==null || groupOrder.totalCash=='0.0000' )}">
										<a href="javascript:void(0);"
											onclick="delGroupOrder(${groupOrder.id})" class="def">删除</a>
									</c:if> <a href="javascript:void(0);"
									onclick="printOrder(${groupOrder.id})" class="def">打印</a></td>
							</tr>
						</c:forEach>
						<tr>
							<td colspan="9" style="text-align: right">本页合计:</td>
							<td>${pageTotalAudit}大${pageTotalChild}小</td>
							<td><fmt:formatNumber value="${pageTotal}" type="currency"
									pattern="#.##" /></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="9" style="text-align: right">总合计:</td>
							<td>${totalAudit}大${totalChild}小</td>
							<td><fmt:formatNumber value="${total}" type="currency"
									pattern="#.##" /></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>

				<jsp:include page="/WEB-INF/include/page.jsp">
					<jsp:param value="${page.page }" name="p" />
					<jsp:param value="${page.totalPage }" name="tp" />
					<jsp:param value="${page.pageSize }" name="ps" />
					<jsp:param value="${page.totalCount }" name="tn" />
				</jsp:include>

			</dl>
			<div class="Footer">
				<dl class="p_paragraph_content">
					<dd>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="mergeGroup()">新增并团</a>
						<a href="javascript:void(0);"
							class="button button-primary button-small" onclick="beforeInsertGroup()">加入团</a>
					</dd>
				</dl>
			</div>

		</div>
	</div>

</body>
<div id="exportWord"
	style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleOrder"
			class="button button-primary button-small">确认单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleCharge"
			class="button button-primary button-small">结算单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleOrderNoRoute"
			class="button button-primary button-small">确认单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleChargeNoRoute"
			class="button button-primary button-small">结算单-无行程</a>
	</div>
</div>
</html>
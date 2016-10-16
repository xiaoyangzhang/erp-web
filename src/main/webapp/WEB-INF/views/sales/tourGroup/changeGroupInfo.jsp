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

function setStartDate(){
	var now=new Date();
	var year=now.getFullYear();
	var month=now.getMonth() + 1;
	var day=now.getDate();
	$("#dateStart").val(year+"-"+month+"-"+day);  
}

$(function(){
	$("#changeGroupForm").validate(
		{
			rules : {
				'dateStart' : {
					required : true
				}
			},
			errorPlacement : function(error, element) { // 指定错误信息位置

				if (element.is(':radio') || element.is(':checkbox')
						|| element.is(':input')) { // 如果是radio或checkbox
					var eid = element.attr('name'); // 获取元素的name属性
					error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
				} else {
					error.insertAfter(element);
				}
			},
			submitHandler : function(form) {
				var options = {
					url : 'changeGroup.do',
					type : "post",
					dataType : "json",
					success : function(data) {
						if (data.success) {
							$.success('操作成功',function(){
								if(data.mode>0){
								refreshWindow('编辑团订单','<%=ctx%>/teamGroup/toEditTeamGroupInfo.htm?groupId='+data.groupId+'&operType=1');
								}else{
								refreshWindow('编辑散客团','<%=ctx%>/fitGroup/toFitGroupInfo.htm?groupId='+data.groupId+'&operType=1');
								}
							});
							
						} else {
							$.warn(data.msg, {
								icon : 5
							});

						}
					},
					error : function(XMLHttpRequest, textStatus,
							errorThrown) {
						$.warn('服务忙，请稍后再试', {
							icon : 5
						});
					}
				}
				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}

		});
	
	setStartDate();
})
</script>
</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<form id="changeGroupForm" method="post">
				<input type="hidden" name="groupId" value="${groupId}" />
				<dl class="p_paragraph_content">
					<p class="p_paragraph_title">
						<b>变更团</b>
					</p>
					<dd>
						<div class="dd_left">
							<i class="red">*</i>选择日期:
						</div>
						<div class="dd_right">
							<input type="text" id="dateStart" name="dateStart" readonly="readonly" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">团号:</div>
						<div class="dd_right">
							${tourGroup.groupCode} <input type="hidden" name="groupCode"
								value="${tourGroup.groupCode}" /> <input type="hidden"
								name="groupCodeMark" value="${tourGroup.groupCodeMark}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">操作计调:</div>
						<div class="dd_right">${tourGroup.operatorName}</div>
						<div class="clear"></div>
					</dd>
					<c:if test="${tourGroup.groupMode>0}">
					<dd>
						<div class="dd_left">组团社:</div>
						<div class="dd_right">
							<c:forEach items="${orderList}" var="groupOrder"
								varStatus="index">
								<input type="hidden" name="supplierId" id="supplierId"  value="${groupOrder.supplierId }" />
								<input name="supplierName" id="supplierName" type="text" class="IptText300" value="${groupOrder.supplierName }" />
								<a href="javascript:void(0)" onclick="selectSupplier();">请选择</a>	
							</c:forEach>
						</div>
						<div class="clear"></div>
					</dd>
					</c:if>
				</dl>
				<dl class="p_paragraph_content">
					<p class="p_paragraph_title">
						<b>变更内容</b>
					</p>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="1" checked="checked"
								disabled="disabled" />行程列表
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">
							<input type="checkbox" name="info" value="2" checked="checked"
								disabled="disabled" />备注信息
						</div>
						<div class="clear"></div>
					</dd>
					<!-- 添加导游安排订单 -->
					<dd>
						<div class="dd_left" style="margin-left: 1.5%;">
							<input type="checkbox" name="info" value="3" />导游安排订单
						</div>
						<div class="clear"></div>
					</dd>
				</dl>
				<c:if test="${tourGroup.groupMode==0 or tourGroup.groupMode==-1}">
					<dl class="p_paragraph_content">
						<p class="p_paragraph_title">
							<b>变更订单</b>
						</p>
						<table cellspacing="0" cellpadding="0" class="w_table"
							id="personTable">
							<thead>
								<tr>
									<th width="5%"><input type="checkbox" id="chkAll" /></th>
									<th width="3%"></th>
									<th width="15%">组团社<i class="w_table_split"></i></th>
									<th width="5%">联系人<i class="w_table_split"></i></th>
									<th width="10%">接站牌<i class="w_table_split"></i></th>
									<th width="5%">人数<i class="w_table_split"></i></th>
									<th width="7%">客源地<i class="w_table_split"></i></th>
									<th width="7%">出团<i class="w_table_split"></i></th>
									<th width="20%">产品名称<i class="w_table_split"></i></th>
									<th width="5%">销售<i class="w_table_split"></i></th>
									<th width="5%">计调<i class="w_table_split"></i></th>
									<th width="5%">金额<i class="w_table_split"></i></th>
								</tr>
							</thead>
							<c:forEach items="${orderList}" var="groupOrder"
								varStatus="index">
								<tr>
									<td><input type="checkbox" id="chk" name="orderIds"
										value="${groupOrder.id }" /></td>
									<td>${index.count}</td>
									<td>${groupOrder.supplierName}</td>
									<td>${groupOrder.contactName}</td>
									<td>${groupOrder.receiveMode}</td>
									<td>${groupOrder.numAdult}大${groupOrder.numChild }小</td>
									<td>${groupOrder.provinceName }${groupOrder.cityName }</td>
									<td>${groupOrder.departureDate}</td>
									<td style="text-align: left;">【${groupOrder.productBrandName}】${groupOrder.productName }</td>
									<td>${groupOrder.saleOperatorName}</td>
									<td>${groupOrder.operatorName}</td>
									<td><fmt:formatNumber value="${groupOrder.total}"
											type="currency" pattern="#.##" /></td>
								</tr>
							</c:forEach>
						</table>
					</dl>
				</c:if>
				<c:if test="${tourGroup.groupMode>0 }">
					<input type="hidden" name="orderIds" value="" />
				</c:if>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
								<button type="submit" class="button button-primary button-small">确定</button>
								<a href="javascript:void(0)" onclick="closeWindow()"
									class="button button-primary button-small">取消</a>
							</div>
						</dd>
					</dl>
				</div>
			</form>

		</div>
		</form>
	</div>
	</div>
</body>
<script type="text/javascript">

/** * 选择组团社 */
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择组团社',
		content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选组团社");
				return false;
			}
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
	    }
	});
}

$(function(){
	$("#chkAll").click(function(){
		 $("input[name='orderIds']:enabled").prop("checked", this.checked);
	 });
	 $("input[name='orderIds']").click(function() {
	    var $subs = $("input[name='orderIds']");
	    $("#chkAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
	 });
});


</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>并团</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">
	function onSubmit(obj){
		$(obj).attr("disabled","disabled");
		var options = {
				url : "../agencyFit/mergeGroup.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							 var tabs = $(top.document).find('#sysMenuTab li').children('span');
						     tabs.each(function(){
						         if($(this).text() === '散客订单查询'){
						             var index = $(this).parent().attr('frmindex');
						             $(window.parent.document).contents().find("#mainFrame"+index)[0].contentWindow.searchBtn();
						         }
						     });
							closeWindow();
						});
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.error('服务忙，请稍后再试',function(){
						$(obj).removeAttr('disabled');
						
					});
				}
			};
 		$("#mergeGroupForm").ajaxSubmit(options);

	}
	
	
	function openMergeAddGroup(ids) {
		layer.open({
			type : 2,
			title : '选择订单',
			shadeClose : true,
			shade : 0.5,
			area : [ '70%', '80%' ],
			content : '../agencyFit/toImpNotGroupList.htm?idLists=' + ids
		});
	}
	
	</script>
</head>
<body>
	<div class="p_container_sub" id="tab1">
		<p class="p_paragraph_title">
			<b>选择客人进行分团</b>
		</p>
		<form id="mergeGroupForm" method="post">
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<table cellspacing="0" cellpadding="0" class="w_table"
							id="personTable">
							<thead>
								<tr>
									<th>序号<i class="w_table_split"></i></th>
									<th>团编号<i class="w_table_split"></i></th>
									<th>组团社<i class="w_table_split"></i></th>
									<th>人数<i class="w_table_split"></i></th>
									<th>姓名<i class="w_table_split"></i></th>
									<th>证件号<i class="w_table_split"></i></th>
									<th>年龄<i class="w_table_split"></i></th>
									<th>籍贯<i class="w_table_split"></i></th>
									<th>职业<i class="w_table_split"></i></th>
									<th>备注<i class="w_table_split"></i></th>
								</tr>
							</thead>
					
							<c:forEach items="${list }" var="groupOrder" varStatus="index">
								
								<c:forEach items="${groupOrder.groupOrderGuestList}" var="guest"
									varStatus="i">
									<tr>
										<c:if test="${i.count==1}">
											<td rowspan="${fn:length(groupOrder.groupOrderGuestList)}">${index.count}</td>
											<td rowspan="${fn:length(groupOrder.groupOrderGuestList)}">
												<input type="text"
												name="orderList[${index.index}].groupCode"
												id="orderList[${index.index}]GroupCode" /> <input
												type="hidden" value="${groupOrder.id}"
												name="orderList[${index.index}].id" />
											</td>
											<td rowspan="${fn:length(groupOrder.groupOrderGuestList)}">${groupOrder.supplierName}-${groupOrder.contactName}</td>
											<td rowspan="${fn:length(groupOrder.groupOrderGuestList)}">${groupOrder.numAdult }大${groupOrder.numChild}小</td>
										</c:if>
										<td>${guest.name }</td>
										<td>${guest.certificateNum }</td>
										<td>${guest.age }</td>
										<td>${guest.nativePlace }</td>
										<td>${guest.career }</td>
										<td>${guest.remark }</td>
									</tr>
								</c:forEach>
							</c:forEach>

						</table>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"></div>
					<div class="dd_right">
						<button type="button" class="button button-primary button-small"
							onclick="openMergeAddGroup('${ids}')">添加订单</button>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="button" onclick="onSubmit(this)" class="button button-primary button-small">按团号拆分成团</button>
				<button class="button button-primary button-small" onclick="closeWindow();">返回</button>
			</div>
		</form>
	</div>
</body>
</html>
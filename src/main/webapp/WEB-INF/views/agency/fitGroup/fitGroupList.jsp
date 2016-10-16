<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%	String path = request.getContextPath();%>
<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团列表(组团社)</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript">

function pushInfo(groupId){
	layer.open({
		type : 2,
		title : '同步到APP',
		shadeClose : true,
		shade : 0.5,
		area : [ '1000px', '550px' ],
		content : '../tourGroup/getPushInfo.htm?groupId='+groupId 
	});

}
function openMergeAddGroup(id,mode) {
	layer.open({
		type : 2,
		title : '选择订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '70%', '80%' ],
		content:ctx+'/agencyFitGroup/toSecImpNotGroupList.htm?orderType='+mode+'&reqType=0&gid='+id
	});
}
function editGroupComment(id){
	newWindow("出团备注", "<%=path%>/agencyFitGroup/toEditGroupComment.htm?groupId="+id);
}
/* $(function() {
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
<body>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
		<div class="p_container_sub pl-10 pr-10">
			<dl class="p_paragraph_content">
				<form action="toFitGroupList.htm" method="post"
					id="toFitGroupListForm">
					<input type="hidden" name="page" id="groupPage"
						value="${tourGroup.page}"> <input type="hidden"
						name="pageSize" id="groupPageSize" value="${tourGroup.pageSize}">
						
						
					<dd class="inl-bl">
						<div class="dd_left">出团日期:</div>
						<div class="dd_right grey">
							<input name="startTime" type="text" id="startTime" value='<fmt:formatDate value="${tourGroup.startTime }" pattern="yyyy-MM-dd"/>' class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
							~
							<input name="endTime" id="endTime" value='<fmt:formatDate value="${tourGroup.endTime}" pattern="yyyy-MM-dd"/>' type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团号:</div>
						<div class="dd_right grey">
							<input name="groupCode" type="text" value="${tourGroup.groupCode}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">产品名称:</div>
						<div class="dd_right grey">
							<input name="productName" type="text" value="${tourGroup.productName}" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团状态:</div>
						<div class="dd_right grey">
							<select name="groupState">
								<option value="-2" selected="selected">全部</option>
								<option value="0"
									<c:if test="${tourGroup.groupState==0 }"> selected="selected" </c:if>>未确认</option>
								<option value="1"
									<c:if test="${tourGroup.groupState==1 }"> selected="selected" </c:if>>已确认</option>
								<option value="2"
									<c:if test="${tourGroup.groupState==2 }"> selected="selected" </c:if>>已废弃</option>
								<option value="3"
									<c:if test="${tourGroup.groupState==3 }"> selected="selected" </c:if>>已审核</option>
								<option value="4"
									<c:if test="${tourGroup.groupState==4 }"> selected="selected" </c:if>>已封存</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left">团类型:</div>
						<div class="dd_right grey">
							<select name="groupMode">
								<option value="" selected="selected">全部</option>
								<option value="0"
									<c:if test="${tourGroup.groupMode==0 }"> selected="selected" </c:if>>散客</option>
								<option value="-1"
									<c:if test="${tourGroup.groupMode==-1 }"> selected="selected" </c:if>>一地散</option>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd class="inl-bl">
						<div class="dd_left"></div>
						<div class="dd_right">
						部门:
	    				<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="${tourGroup.orgNames }" readonly="readonly" onclick="showOrg()"/>
						<input name="orgIds" id="orgIds" stag="orgIds" value="${tourGroup.orgIds }" type="hidden" value=""/>	
						</div>    		
						<div class="dd_right">
						计调:
							<input type="text" name="operatorName" id="saleOperatorName"
								value="${tourGroup.operatorName}" stag="userNames" readonly="readonly"  onclick="showUser()"/> <input
								name="operatorIds" id="saleOperatorIds" stag="userIds" type="hidden"
								value="${tourGroup.operatorIds}" />
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
						<th style="width:3%">序号<i class="w_table_split"></i></th>
						<th style="width:20%">团号<i class="w_table_split"></i></th>
						<th style="width:8%">团类型<i class="w_table_split"></i></th>
						<th style="width:8%">日期<i class="w_table_split"></i></th>
						<th >产品名称<i class="w_table_split"></i></th>
						<th style="width:8%">导游<i class="w_table_split"></i></th>
						<th style="width:5%">订单数<i class="w_table_split"></i></th>
						<th style="width:4%">成人<i class="w_table_split"></i></th>
						<th style="width:4%">儿童<i class="w_table_split"></i></th>
						<th style="width:5%">计调<i class="w_table_split"></i></th>
						<th style="width:8%">团状态<i class="w_table_split"></i></th>
						<th style="width:5%">操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.result}" var="tourGroup" varStatus="index">
						<tr title="创建时间:${tourGroup.createTimeStr},最后修改人:${tourGroup.updateName },最后修改时间:${tourGroup.updateTimeStr}">
							<td>${index.count}</td>
							<td style="text-align:left"><a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','agencyFitGroup/toFitGroupInfo.htm?groupId=${tourGroup.id}&operType=0')">${tourGroup.groupCode}</a></td>
							<td><c:if test="${tourGroup.groupMode==0 }">散客</c:if><c:if test="${tourGroup.groupMode==-1 }">一地散</c:if></td>
							<td><fmt:formatDate value="${tourGroup.dateStart}"
									pattern="MM-dd" />/<fmt:formatDate
									value="${tourGroup.dateEnd}" pattern="MM-dd" /></td>
							<td style="text-align:left">【${tourGroup.productBrandName}】${tourGroup.productName}</td>
							<td><c:forEach items="${tourGroup.guideList}" var="guide">
							<a href="javascript:void(0);" onclick="newWindow('导游详情','supplier/guideDetail.htm?id=${guide.guideId}')"> 
							${guide.guideName}&nbsp;
							</a></c:forEach> </td>
							<td>${tourGroup.orderNum}</td>
							<td>${tourGroup.totalAdult}</td>
							<td>${tourGroup.totalChild}</td>
							<td>${tourGroup.operatorName}</td>
							<td>
								<c:if test="${gl.tourGroup.groupState==0}">未确认</c:if>
				                <c:if test="${gl.tourGroup.groupState==1}"><span class="log_action insert">已确认</span></c:if>
								<c:if test="${gl.tourGroup.groupState==2}"><span class="log_action delete">已废弃</span></c:if>
								<c:if test="${gl.tourGroup.groupState==3}"><span class="log_action update">已审核</span></c:if>
								<c:if test="${gl.tourGroup.groupState==4}"><span class="log_action fuchsia">已封存</span></c:if>

							</td>
							<td>
								 <div class="tab-operate">
									 <a href="####" class="btn-show">操作<span class="caret"></span></a>
									 <div class="btn-hide" id="asd">
									   		<a href="javascript:void(0)" class="def" onclick="newWindow('查看散客团','agencyFitGroup/toFitGroupInfo.htm?groupId=${tourGroup.id}&operType=0')">查看</a>
									   		<a href="javascript:void(0);" onclick="print(${tourGroup.id})" class="def">打印</a>
									   		<c:if test="${optMap['EDIT'] && tourGroup.groupState!=3 and tourGroup.groupState!=4}">
											<a href="javascript:void(0)"  class="def"  onclick="newWindow('编辑散客团','agencyFitGroup/toFitGroupInfo.htm?groupId=${tourGroup.id}&operType=1')">编辑</a>
											<a href="javascript:void(0);" onclick="openMergeAddGroup(${tourGroup.id},${tourGroup.groupMode })"  class="def">并团</a>
											<a href="javascript:void(0);" onclick="toChangeState(${tourGroup.id},${tourGroup.groupState })" class="def">状态</a>
											</c:if>
											<c:if test="${optMap['EDIT'] && tourGroup.groupState==2 }">
											<a href="javascript:void(0);" onclick="delGroup(${tourGroup.id},-1)"  class="def">删除</a>
											</c:if>
											<c:if test="${optMap['EDIT'] && tourGroup.groupState==1 }">
											<a href="javascript:void(0);" onclick="pushInfo(${tourGroup.id})"  class="def">同步App</a>
											<a href="javascript:void(0);" onclick="editGroupComment(${tourGroup.id})"  class="def">出团备注</a>
											</c:if>
											 <c:if test="${tourGroup.groupState==4}">
						              	 	<a href="javascript:void(0);" onclick="newWindow('变更团','tourGroup/toChangeGroup.htm?groupId=${tourGroup.id}')" class="def">变更</a> 
											 </c:if>
									 </div>
								</div>
							</td>
						</tr>
							<c:set var="totalAdult" value="${totalAdult+tourGroup.totalAdult }"/>
							<c:set var="totalChild" value="${totalChild+tourGroup.totalChild }"/>
					</c:forEach>
						<tr>
							<td colspan="7" style="text-align: right">本页合计：</td>
							<td>${totalAdult}</td>
							<td>${totalChild}</td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="7" style="text-align: right">总合计：</td>
							<td>${group.totalAdult}</td>
							<td>${group.totalChild }</td>
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
		</div>
	</div>
	<script type="text/javascript">
	function searchBtn() {
		var pageSize=$("#groupPageSize").val();
		queryList(1,pageSize);
	}
	
			function queryList(page,pageSize) {
				if (!page || page < 1) {
					page = 1;
				}
				$("#groupPage").val(page);
				$("#groupPageSize").val(pageSize);
				$("#toFitGroupListForm").submit();
			}
			function toChangeState(groupId,state){
				
					$("#modalgroupId").val(groupId);
					$("#modalGroupState").val(state);
					optionState(state);
				layer.open({
					type : 1,
					title : '修改状态',
					shadeClose : true,
					shade : 0.5,
					area : [ '300px', '200px' ],
					content : $('#stateModal')
				});
			}
			function optionState(state){
				var sltCity = document.getElementById("modalGroupState");
				while (sltCity.firstChild) {
				  sltCity.removeChild(sltCity.firstChild); //移除已有的节点
				}
				if(state==0){//未确认
					var option1 = new Option("已确认", "1");
					document.getElementById("modalGroupState").options.add(option1);
					var option2 = new Option("废弃", "2");
					document.getElementById("modalGroupState").options.add(option2);	
					
				}else if(state==1){//已确认
					var option1 = new Option("废弃", "2");
					document.getElementById("modalGroupState").options.add(option1);
				
				}else if(state==2){//废弃
					var option1 = new Option("未确认", "0");
					document.getElementById("modalGroupState").options.add(option1);
					var option2 = new Option("已确认", "1");
					document.getElementById("modalGroupState").options.add(option2);
				}
			}
			function delGroup(groupId,state){
				$.confirm("确认删除吗？", function() {
				$.getJSON("../fitGroup/delFitTour.do?groupId=" + groupId, function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							searchBtn();
						});
					}else{
						$.warn(data.msg);
					}
					
				});
				
				})

				
			}
			
	$(function(){
		$("#stateInfoForm").validate(
				{
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
							url : '../fitGroup/changeState.do',
							type : "post",
							dataType : "json",
							success : function(data) {
								if (data.success) {
									$.success('操作成功',function(){
										searchBtn();
									});
								} else {
									layer.alert(data.msg, {
										icon : 5
									});

								}
							},
							error : function(XMLHttpRequest, textStatus,
									errorThrown) {
								layer.alert('服务忙，请稍后再试', {
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
		
	})

/**
 * 订单打印
 */
function print(groupId){
// 	$("#skjd").attr("href","download.htm?groupId="+groupId+"&num="+1) ; //散客计调单
//  $("#skdydwxc").attr("href","download.htm?groupId="+groupId+"&num="+5) ; //散客导游单-无行程
//  $("#krmd").attr("href","download.htm?groupId="+groupId+"&num="+2) ; //客人名单
//  $("#krmdjs").attr("href","download.htm?groupId="+groupId+"&num="+6) ; //客人名单-接送
	$("#skqrd").attr("href","../tourGroup/toSKConfirmPreview.htm?groupId="+groupId) ; //散客确认单
	$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //散客确认单
	$("#skjsd").attr("href","../tourGroup/toSKChargePreview.htm?groupId="+groupId) ; //散客结算单
	$("#skjd").attr("href","../groupOrder/previewFitTransfer.htm?groupId="+groupId) ; //散客计调单
	$("#skdydwxc").attr("href","../groupOrder/previewFitGuide.htm?groupId="+groupId) ; //散客导游单
	$("#krmd").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
	$("#krmdjs").attr("href","../groupOrder/previewGuestWithTrans.htm?groupId="+groupId) ; //客人名单-接送
	
	//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num="+3) ; //游客反馈意见单
	$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
	//$("#skgwmxd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num="+4) ; //散客购物明细单
	$("#skgwmxd").attr("href","../groupOrder/toShoppingDetailPreview.htm?groupId="+groupId) ; 
	$("#skdyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //散客导游单

	layer.open({
		type : 1,
		title : '打印',
		shadeClose : true,
		shade : 0.5,
        area : ['350px','280px'],
		content : $('#exportWord')
	});
};
	</script>
	<!-- 改变状态 -->
	<div id="stateModal" style="display: none">
		<form class="definewidth m20" id="stateInfoForm">
			<input type="hidden" name="id" id="modalgroupId" />
			<dl class="p_paragraph_content">
				<dd>
					<div class="dd_left">状态:</div>
					<div class="dd_right">
						<select name="groupState" id="modalGroupState">
							<option value="0">未确认</option>
							<option value="1">已确认</option>
							<option value="2">废弃</option>
							<option value="3">封存</option>
						</select>
					</div>
					<div class="clear"></div>
				</dd>
			</dl>
			<div class="w_btnSaveBox" style="text-align: center;">
				<button type="submit" class="button button-primary button-small">确定</button>
			</div>
		</form>
	</div>
	<div id="exportWord" style="display: none;text-align: center;margin-top: 10px">
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="cttz" class="button button-primary button-small">出团通知</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skjd" class="button button-primary button-small">散客计调单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="skdyd" class="button button-primary button-small">导游单行程单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="krmd" class="button button-primary button-small">客人名单</a>
		</div>
	</div>
</body>
</html>
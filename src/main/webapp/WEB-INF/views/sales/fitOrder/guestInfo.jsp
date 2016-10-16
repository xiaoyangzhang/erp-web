<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑接送信息</title>
<script type="text/javascript" src="<%=path%>/assets/js/card/card.js"></script>
<script type="text/javascript" src="<%=path%>/assets/js/web-js/sales/individuaGroups.js"></script>
<script type="text/javascript" src="<%=path%>/assets/js/web-js/sales/changeAddShow.js"></script>
<style type="text/css">

</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
	<div class="p_container">
		<form id="guestInfoForm">
		
			<input type="hidden" name="groupOrder.id" value="${vo.groupOrder.id}" />
			<input style="width: 40px;" type="hidden" name="groupOrder.numAdult" placeholder="成人数" value="${(empty vo.groupOrder.numAdult)?0:vo.groupOrder.numAdult}" />
			<input style="width: 40px;" type="hidden" name="groupOrder.numChild" placeholder="小孩数" value="${(empty vo.groupOrder.numChild)?0:vo.groupOrder.numChild}" />
			<input style="width: 40px;" type="hidden" name="groupOrder.numGuide" placeholder="全陪数" value="0" />
							
			<div class="dd_right">
				<table cellspacing="0" cellpadding="0" class="w_table" style="width:1100px;">
					<thead>
						<tr>
							<th width="3%">序号<i class="w_table_split"></i></th>
							<th width="5%">姓名<i class="w_table_split"></i></th>
							<th width="8%">性别<i class="w_table_split"></i></th>
							<th width="5%">年龄<i class="w_table_split"></i></th>
							<th width="9%">籍贯<i class="w_table_split"></i></th>
							<th width="5%">职业<i class="w_table_split"></i></th>
							<th width="8%">类别<i class="w_table_split"></i></th>
							<th width="8%">证件类型<i class="w_table_split"></i></th>
							<th width="10%">证件号码<i class="w_table_split"></i></th>
							<th width="9%">手机号码<i class="w_table_split"></i></th>
							<th width="8%">是否单房<i class="w_table_split"></i></th>
							<th width="8%">是否领队<i class="w_table_split"></i></th>
							<th width="8%">备注<i class="w_table_split"></i></th>
							<th width="3%">
								<c:if test="${operType==1}">
									<a href="javascript:;" onclick="addGuest('newGuest');" class="def">增加</a>
								</c:if>
							</th>
						</tr>
					</thead>
					<tbody id="newGuestData">
						<c:forEach items="${vo.groupOrderGuestList}" var="guest"
							varStatus="index">
							<tr   <c:if test="${!guest.editType }"> title="该客人已订机票,姓名、身份证号码不可修改" </c:if>>
								<td>
									${index.count}
									<input type="hidden" name="groupOrderGuestList[${index.index}].id" value="${guest.id}" />
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].name" data-rule-required="true"
									value="${guest.name }" style="width: 50px" <c:if test="${!guest.editType }"> readonly="readonly" </c:if> />
								</td>
								<td>
									<input type="radio" name="groupOrderGuestList[${index.index}].gender" value="1"
									<c:if test="${guest.gender==1 }">checked="checked"</c:if> />男
									<input type="radio" name="groupOrderGuestList[${index.index}].gender" value="0"
									<c:if test="${guest.gender==0 }">checked="checked"</c:if> />女
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].age"
									value="${guest.age }" onblur="changeType(${index.index})"  style="width: 40px" />
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].nativePlace"
									value="${guest.nativePlace }" style="width: 80px" />
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].career"
									value="${guest.career }" style="width: 50px" /></td>
								<td>
									<select name="groupOrderGuestList[${index.index}].type" style="width: 60px">
										<option value="1"
											<c:if test="${guest.type==1 }">selected="selected"</c:if>>成人</option>
										<option value="2"
											<c:if test="${guest.type==2 }">selected="selected"</c:if>>儿童</option>
										<option value="3"
											<c:if test="${guest.type==3 }">selected="selected"</c:if>>全陪</option>
									</select>
								</td>
								<td>
									<select id="certificateTypeId" name="groupOrderGuestList[${index.index}].certificateTypeId"
									style="width: 60px" onchange="recCertifNum(${index.index})">
										<c:forEach items="${zjlxList}" var="v" varStatus="vs">
											<option id="it" value="${v.id}"
												<c:if test="${guest.certificateTypeId==v.id }">selected="selected"</c:if>>${v.value}</option>
										</c:forEach>
									</select>
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].certificateNum"
									class="certificateNum" value="${guest.certificateNum }" data-rule-required="true"
									onblur="recCertifNum(${index.index})" style="width: 120px" <c:if test="${!guest.editType }"> readonly="readonly" </c:if>/>
								</td>
								<td>
									<input type="text" name="groupOrderGuestList[${index.index}].mobile" value="${guest.mobile }" 
									style="width: 80px" />
								</td>
								<td>
									<input type="radio" name="groupOrderGuestList[${index.index}].isSingleRoom" value="1"
									<c:if test="${guest.isSingleRoom==1 }">checked="checked"</c:if>>是</input>
									<input type="radio" name="groupOrderGuestList[${index.index}].isSingleRoom" value="0"
									<c:if test="${guest.isSingleRoom==0 }">checked="checked"</c:if>>否</input>
								</td>
								<td><input type="radio" name="groupOrderGuestList[${index.index}].isLeader" value="1"
									<c:if test="${guest.isLeader==1 }">checked="checked"</c:if>>是</input>
									<input type="radio" name="groupOrderGuestList[${index.index}].isLeader" value="0"
									<c:if test="${guest.isLeader==0 }">checked="checked"</c:if>>否</input>
								</td>
								<td>
									<input style="width: 100px" type="text" name="groupOrderGuestList[${index.index}].remark"
									placeholder="备注" value="${guest.remark }" />
								</td>
								<c:if test="${operType==1}">
								<td>
									<c:if test="${guest.editType }">
										<a href="javascript:void(0);" onclick="delGuestTable(this,'newGuest')">删除</a>
									</c:if>
								</td>
								</c:if>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</form>
	</div>

	<script type="text/javascript">
	
	function recCertifNum(count){
		var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
		var typeName = $("select[name='groupOrderGuestList["+count+"].certificateTypeId'] option:selected").text();
		if(typeName=='身份证'){
			var guestCertificateNum = $("input[name='groupOrderGuestList["+count+"].certificateNum']").val();
			if(guestCertificateNum!=''){
				if (reg.test(guestCertificateNum) === true) {
					var data = $.parseIDCard(guestCertificateNum);
						if(data.tip==''){
						
							$("input[name='groupOrderGuestList["+count+"].age").val(data.age);
							if(data.age<12){
								$("select[name='groupOrderGuestList["+count+"].type").val("2");
							}else{
								$("select[name='groupOrderGuestList["+count+"].type").val("1");
							}
							$("input[name='groupOrderGuestList["+count+"].nativePlace").val(data.birthPlace);
							if(data.gender=='男'){
								$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
							}else{
								$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
							}
							$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
						}else{
							$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
							$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
						}
				}else{
					$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
					$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
				}
			}
		}else{
			$("input[name='groupOrderGuestList["+count+"].certificateNum").next().remove();
		}

	}
	function isAllowAddGuest(){
		var personNum=$("#allowNum").val();
		var numAdult =$("input[name='groupOrder.numAdult']").val();
		var numChild =$("input[name='groupOrder.numChild']").val();
		if((Number(numAdult)+Number(numChild))>personNum){
			$.warn("订单人数不允许大于库存人数！");
			$("input[name='groupOrder.numAdult']").val(0);
			$("input[name='groupOrder.numChild']").val(0);
			return ;
		}
		if($("#priceGroup").val()!=''){
		changePriceTable();
		}
		
	}

	
		function saveGuestInfo(){
			var options = {
				url : "saveGuestInfo.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功');
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试', {
						icon : 5
					});
				}
			};
			$("#guestInfoForm").ajaxSubmit(options);	
		}
	</script>
</body>
</html>

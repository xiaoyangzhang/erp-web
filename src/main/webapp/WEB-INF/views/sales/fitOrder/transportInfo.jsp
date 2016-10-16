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
<script type="text/javascript" src="<%=path%>/assets/js/web-js/sales/changeAddShow.js"></script>
<style type="text/css">

</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
	<div class="p_container">
		<form id="transportInfoForm">
		
			<input type="hidden" name="groupOrder.id" value="${vo.groupOrder.id}" />
			
			<div class="dd_right">
				<table cellspacing="0" cellpadding="0" class="w_table" style="width:950px;">
					<thead>
						<tr>
							<th width="5%">序号<i class="w_table_split"></i></th>
							<th width="10%">线路类型<i class="w_table_split"></i></th>
							<th width="10%">接送方式<i class="w_table_split"></i></th>
							<th width="10%">交通方式<i class="w_table_split"></i></th>
							<th width="10%">出发城市<i class="w_table_split"></i></th>
							<th width="10%">到达城市<i class="w_table_split"></i></th>
							<th width="10%">班次/车次<i class="w_table_split"></i></th>
							<th width="10%">出发日期<i class="w_table_split"></i></th>
							<th width="10%">出发时间<i class="w_table_split"></i></th>
							<th width="10%">备注<i class="w_table_split"></i></th>
							<th width="5%">
								<c:if test="${operType==1}">
									<a href="javascript:;" onclick="addTran('newTransport');" class="def">增加</a>
								</c:if>
							</th>
						</tr>
					</thead>
					<tbody id="newTransportData">
						<c:forEach items="${vo.groupOrderTransportList }" var="trans" varStatus="index">
							<tr>
								<td>
									${index.count} 
									<input type="hidden" name="groupOrderTransportList[${index.index}].id" value="${trans.id}">
								</td>
								<td>
									<select style="width: 100px" name="groupOrderTransportList[${index.index}].sourceType" >
										<option value="1"
											<c:if test="${trans.sourceType==1 }">selected="selected"</c:if>>省外交通
										</option>
										<option value="0"
											<c:if test="${trans.sourceType==0 }">selected="selected"</c:if>>省内交通
										</option>
									</select>
								</td>
								<td>
									<input type="radio" name="groupOrderTransportList[${index.index}].type" value="0"
										<c:if test="${trans.type==0 }">checked="checked"</c:if> 
									/>接
									<input type="radio" name="groupOrderTransportList[${index.index}].type" value="1"
										<c:if test="${trans.type==1 }">checked="checked"</c:if> 
									/>送
								</td>
								<td>
									<select style="width: 100px" name="groupOrderTransportList[${index.index}].method" id="transportMethod" >
										<c:forEach items="${jtfsList}" var="jtfs">
											<option value="${jtfs.id}"
												<c:if test="${trans.method==jtfs.id}">selected="selected"</c:if>>${jtfs.value }
											</option>
										</c:forEach>
									</select>
								</td>
								<td>
									<input style="width: 80px" type="text" name="groupOrderTransportList[${index.index}].departureCity"
									placeholder="出发城市" value="${trans.departureCity }" />
								</td>
								<td>
									<input style="width: 80px" type="text" name="groupOrderTransportList[${index.index}].arrivalCity"
									placeholder="到达城市" value="${trans.arrivalCity }" style="width:95%"/>
								</td>
								<td>
									<input style="width: 80px" type="text" name="groupOrderTransportList[${index.index}].classNo"
									placeholder="班次/车次" value="${trans.classNo }" style="width:95%"/>
								</td>
								<td>
									<input style="width: 100px" type="text" name="groupOrderTransportList[${index.index}].departureDate"
									class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width:95%"
									value="<fmt:formatDate value="${trans.departureDate}" pattern="yyyy-MM-dd" />" />
								</td>
								<td>
									<input style="width: 100px" type="text" name="groupOrderTransportList[${index.index}].departureTime"
									class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})" 
									value="${trans.departureTime }" style="width:95%" />
								</td>
								<td>
									<input type="text" name="groupOrderTransportList[${index.index}].destination"
									placeholder="备注" value="${trans.destination }" style="width:95%"/>
								</td>
								<c:if test="${operType==1}">
									<td>
										<a href="javascript:void(0);" onclick="delTranTable(this,'newTransport')" class="def">删除</a>
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
		
		function saveTransportInfo(){
			var options = {
				url : "saveTransportInfo.do",
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
			$("#transportInfoForm").ajaxSubmit(options);	
		}
	</script>
</body>
</html>

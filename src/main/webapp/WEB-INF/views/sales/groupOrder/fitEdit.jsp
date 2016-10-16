<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>散客团编辑</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/jquery.idTabs.min.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/fitGroup.js"></script>
</head>
<body>
	<div class="p_container">
		<ul class="w_tab">
			<li><a
				href="../groupOrder/toFitEdit.htm?groupId=${tourGroup.id}&operType=${operType}"
				class="selected">散客团信息</a></li>
			<li><a
				href="../groupRoute/toGroupRoute.htm?groupId=${tourGroup.id}&operType=${operType}">行程列表</a></li>
			<li><a
				href="../groupOrder/toFitOrderList.htm?groupId=${tourGroup.id}&operType=${operType}">订单列表</a></li>
			<li><a
				href="../groupRequirement/toRequirementList.htm?groupId=${tourGroup.id}&operType=${operType}">计调需求汇总</a></li>
			<li class="clear"></li>
		</ul>

		<div class="p_container_sub">
			<form id="saveOrderGroupInfoForm">
				<dl class="p_paragraph_content">

					<input type="hidden" name="id" value="${tourGroup.id}">
					<input type="hidden" name="groupCode" value="${tourGroup.groupCode}">
					<dd>
						<div class="dd_left">团号</div>
						<div class="dd_right">${tourGroup.groupCode }</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">团标识</div>
						<div class="dd_right"><input type="text" class="IptText300" name="groupCodeMark"
								value="${tourGroup.groupCodeMark}"  placeholder="团标识"/></div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">计调</div>
						<div class="dd_right">
							<input type="text" readOnly class="IptText300" id="operatorName" name="operatorName" value="${tourGroup.operatorName}"/>
							<input type="hidden" class="IptText300" id="operatorId" name="operatorId" value="${tourGroup.operatorId}"/>
							<c:if test="${tourGroup.groupState!=3 and operType==1}"><a href="javascript:void(0)"onclick="selectUser()">变更</a></c:if>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">出发日期</div>
						<div class="dd_right">
							<fmt:formatDate value="${tourGroup.dateStart }"
								pattern="yyyy-MM-dd" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">天数</div>
						<div class="dd_right">${tourGroup.daynum}</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">产品品牌</div>
						<div class="dd_right">
							<select name="prudctBrandId">
								<c:forEach items="${ppList}" var="pp">
									<option value="${pp.id}" <c:if test="${pp.id== tourGroup.prudctBrandId}"> selected="selected" </c:if> >${pp.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">产品名称</div>
						<div class="dd_right">
							<input type="text" class="IptText300" name="productName"
								value="${tourGroup.productName }" />
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">服务标准</div>
						<div class="dd_right">
							<textarea class="w_textarea IptText300" name="serviceStandard"
								placeholder="服务标准">${ tourGroup.serviceStandard}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">备注信息</div>
						<div class="dd_right">
							<textarea class="w_textarea IptText300" name="remark" rows="3"
								cols="3" placeholder="备注信息">${tourGroup.remark}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">内部备注</div>
						<div class="dd_right">
							<textarea class="w_textarea IptText300" name="remarkInternal"
								placeholder="内部备注">${tourGroup.remarkInternal }</textarea>
						</div>
						<div class="clear"></div>
					</dd>

				</dl>
			
				<c:if test="${tourGroup.groupState!=3 and operType==1}">
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
								<button type="submit" class="button button-primary button-small">保存</button>
							</div>
						</dd>
					</dl>
				</div>
				</c:if>
		</div>
		</form>
	</div>
	</div>
</body>
</html>
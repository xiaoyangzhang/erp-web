<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.p {
	font-family: "Arial Normal", "Arial";
	font-weight: 400;
	font-style: normal;
	font-size: 13px;
	cursor: pointer;
	color: #09F;
	text-align: left;
}
</style>
</head>
<body>
	<p class="p_paragraph_title">
		<b>客人名单</b>
	</p>
		<dl class="p_paragraph_content">
			<c:if test="${stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button type="button" class="button button-primary button-small"
							onclick="addGuest('newGuest');">添加客人信息</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
		
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
				<table cellspacing="0" cellpadding="0" class="w_table">
				<thead>
					<tr align="center">
						<th>序号<i class="w_table_split"></i></th>
						<th>姓名<i class="w_table_split"></i></th>
						<th>性别<i class="w_table_split"></i></th>
						<th>年龄<i class="w_table_split"></i></th>
						<th>籍贯<i class="w_table_split"></i></th>
						<th>职业<i class="w_table_split"></i></th>
						<th>类别<i class="w_table_split"></i></th>
						<th>证件类别<i class="w_table_split"></i></th>
						<th>证件号码<i class="w_table_split"></i></th>
						<th>手机号<i class="w_table_split"></i></th>
						<th>是否单房<i class="w_table_split"></i></th>
						<th>是否领队<i class="w_table_split"></i></th>
						<th>是否全陪<i class="w_table_split"></i></th>
						<th>备注<i class="w_table_split"></i></th>
						<th>操作<i class="w_table_split"></i></th>
					</tr>
				</thead>
				
					<c:forEach items="${groupOrderGuests}" var="gog" varStatus="v">
						<tr>
							<td width="4%">${v.index+1}</td>
							<td width="8%">
								<c:if test="${gog.historyNum>1}">
									${gog.name}
									<a class="button button-tinier button-plus" onclick="showHistory('${gog.certificateNum}',${gog.orderId})" style="color: red;">${gog.historyNum}</a>
								</c:if>
								<c:if test="${gog.historyNum<=1}">
									${gog.name}
								</c:if>
							</td>
							<td width="4%"><c:if test="${gog.gender==1}">男</c:if> <c:if
									test="${gog.gender==0}">女</c:if></td>
							<td width="4%">${gog.age}</td>
							<td width="7%">${gog.nativePlace}</td>
							<td width="5%">${gog.career}</td>
							<td width="4%"><c:if test="${gog.type==1}">成人</c:if> <c:if
									test="${gog.type==2}">儿童</c:if> <c:if test="${gog.type==3}">全陪</c:if>
							</td>
							<td width="8%"><c:forEach items="${zjlxList}" var="v">
									<c:if test="${v.id==gog.certificateTypeId }">${v.value }</c:if>
								</c:forEach></td>
							<td width="12%" class="certificateNum">${gog.certificateNum}</td>
							<td width="11%">${gog.mobile}</td>
							<td width="4%"><c:if test="${gog.isSingleRoom==1}">是</c:if> <c:if
									test="${gog.isSingleRoom==0}">否</c:if></td>
							<td width="4%">
								<c:if test="${gog.isLeader==1}">是</c:if> 
								<c:if test="${gog.isLeader==0}">否</c:if></td>
							<td width="4%">
								<c:if test="${gog.isGuide==1}">是</c:if> 
								<c:if test="${gog.isGuide==0}">否</c:if></td> 
							<td width="13%" style="text-align: left;line-height: 15px;">${gog.remark}</td>
							<td width="8%">
								<c:if test="${stateFinance!=1}">
									<a href="javascript:void(0);"onclick="toEditGuest(${gog.id})"  class="def">修改</a>&nbsp;&nbsp;
									<a href="javascript:void(0);"onclick="deleteGuestById(this,${gog.id},${gog.orderId})"  class="def">删除</a>
								</c:if>
								<c:if test="${stateFinance==1}">
									<a href="javascript:void(0);" class="def">修改</a>&nbsp;&nbsp;
									<a href="javascript:void(0);" class="def">删除</a>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				<tbody id="newGuestData">
				</tbody>
			</table>
			</div>
			<div class="clear"></div>
			
			<div style="margin-left: 6%">
				<input type="hidden" id="certificateNum" />
				<%-- <input type="hidden" id="cerNums" value="${cerNums}"/> --%>
				<c:if test="${stateFinance!=1}">
					<p class="p">批量录入</p>
				</c:if>
				</br>
				</br>
				<div id="bi" style="display: none;">
					<div>
						<textarea class="l_textarea" name="batchInputText" value=""
							id="batchInputText" placeholder="姓名,证件号码,手机号或者姓名,证件号码" style="width: 600px;height: 250px"></textarea>
					</div>
					<span>
						<i style="color: gray;"> 格式：姓名,证件号码,手机号或者姓名,证件号码</i>
					</span>
					<div style="margin-top: 20px;">
						<a href="javascript:void(0);" onclick="toSubmit('newGuest')"
							class="button button-primary button-small">保存</a>
						<span> <i class="red"> 按照上面格式填写后提交即可，回车换行添加多人信息 </i>
						</span>
					</div>
				</div>
			</div>
		</dd>
	</dl>
</body>
</html>

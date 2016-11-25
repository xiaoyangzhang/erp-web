<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<style type="text/css">
.pp {
	font-family: "Arial Normal", "Arial";
	font-weight: 400;
	font-style: normal;
	font-size: 13px;
	cursor: pointer;
	color: #09F;
	text-align: left;
}
.input-r{background-color:pink;color:red;border-color:green}
</style>
</head>
	<body>
		<p class="p_paragraph_title">
			<b>接送信息</b>
		</p>
		<dl class="p_paragraph_content">
			<c:if test="${stateFinance!=1}">
				<dd>
					<div class="dd_left">
						<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
					</div>
					<div class="dd_right" style="width: 80%">
						<button type="button" class="button button-primary button-small"
							onclick="addTran('newTransport');">添加接送信息</button>
					</div>
					<div class="clear"></div>
				</dd>
			</c:if>
			<dd>
				<div class="dd_left">
					<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
				</div>
				<div class="dd_right" style="width: 80%">
			
               		<table class="w_table" id="transportTable"> 
		        	<thead>
		            	<tr>
		             		<th style="width:5%">序号<i class="w_table_split"></i></th>
		             		<th style="width:10%">线路类型<i class="w_table_split"></i></th>
		             		<th style="width:7%">接送方式<i class="w_table_split"></i></th>
		             		<th style="width:7%">交通方式<i class="w_table_split"></i></th>
		             		<th style="width:7%">出发城市<i class="w_table_split"></i></th>
		             		<th style="width:7%">到达城市<i class="w_table_split"></i></th>
		             		<th style="width:7%">班次<i class="w_table_split"></i></th>
		             		<th style="width:15%">出发日期<i class="w_table_split"></i></th>
		             		<th style="width:15%">出发时间<i class="w_table_split"></i></th>
		             		<th style="width:13%">备注<i class="w_table_split"></i></th>
		             		<th style="width:5%">操作</th>
		             	</tr>
		             </thead>
		             	
		             <c:forEach items="${groupOrderTransports }" var="transport"
							varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td><c:if test="${transport.sourceType==0 }">省内交通</c:if> <c:if
										test="${transport.sourceType==1 }">省外交通</c:if></td>
								<td><c:if test="${transport.type==0 }">接</c:if> <c:if
										test="${transport.type==1 }">送</c:if></td>
								<td><c:forEach items="${jtfsList}" var="jtfs">
										<c:if test="${jtfs.id==transport.method }">${jtfs.value }</c:if>
									</c:forEach></td>
								<td>${transport.departureCity}</td>
								<td>${transport.arrivalCity}</td>
								<td>${transport.classNo}</td>
								<td><fmt:formatDate value="${transport.departureDate}" pattern="yyyy-MM-dd" /></td>
								<td>${transport.departureTime}</td>
								<td>${transport.destination}</td>
								<c:if test="${stateFinance!=1}">
			                  		<td>
			                  			<a href="javascript:void(0);" onclick="toEditSeatInCoach(${transport.id})" class="def">编辑</a>
			                  			<a href="javascript:void(0);" onclick="deleteSeatInCoachById(this,${transport.id})" class="def">删除</a>
			                  		</td>
			                  	</c:if>
							</tr>
						</c:forEach>
						<tbody id="newTransportData">
						</tbody>
          		 </table>
          	
   			</div>
   			<div class="clear"></div>
   			<div style="margin-left:6%">
			<c:if test="${stateFinance!=1}">
				<p class="pp">批量录入</p>
			</c:if>
			</br>
			</br>
			<div id="bbb" style="display: none;">
				<div>
					<textarea class="l_textarea" name="bit" value=""
						id="bit" placeholder="出发日期,出发时间,航班号,出发城市,到达城市" style="width: 600px;height: 250px"></textarea>
				</div>
				<span>
					<i style="color: gray;"> 格式：出发日期,出发时间,航班号,出发城市,到达城市</i>
				</span>
				<div style="margin-top: 20px;">
					<a href="javascript:void(0);" onclick="toSaveSeatInCoach('newTransport')"
						class="button button-primary button-small">保存</a>
					<span> <i class="red"> 按照上面格式填写后提交即可，回车换行添加多人信息 </i></span>
				</div>
			</div>
		</div>
		</dd>
		</dl>
		
	</body>

</html>

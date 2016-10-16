<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<p class="p_paragraph_title">
<a href="javascript:;" class="tab-show"><b>需求订单</b> <span class="caret"></span></a>
</p>
<dl class="p_paragraph_content dn">
	<dd>
		<div class="pl-20 pr-20 w-1100">
			<table class="w_table"  border="" cellspacing="0" cellpadding="0">
          			<col width="20%" /><col width="20%" /><col width="10%" /><col width="10%" /><col width="10%" />
 					<col width="10%" /><col width="10%" /><col width="20%" />
 					<tbody>
          			<tr style="background: #F4F5F6;">
          				
          				<td rowspan="2">客户名称</td>
          				<td rowspan="2">日期</td>
          				<td rowspan="2">出发地</td>
          				<td rowspan="2">目的地</td>
          				<td rowspan="2">车次</td>
          				<td colspan="3">数量</td>
          				<td rowspan="2">备注</td>
          			</tr>
          			
          			<c:forEach items="${bookingInfo.requirementInfos }" var="info">
          			<tr style="background: #F4F5F6;">
          				
          				<td>${info.nameFull }</td>
          				<td>${info.requireDate }</td>
          				<td>${info.cityDeparture }</td>
          				<td>${info.cityArrival }</td>
          				<td>${info.classNo }</td>
          				<td>${info.itemNum }</td>
          				<td>${info.itemBrief }</td>
          				
          			</tr>
          			</c:forEach>
          			</tbody>
          		</table>
		</div>
	</dd>
</dl>
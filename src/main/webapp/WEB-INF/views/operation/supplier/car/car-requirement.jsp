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
          			<col widtd="20%" /><col widtd="20%" /><col widtd="20%" />
 					<col widtd="10%" /><col widtd="20%" /><col widtd="20%" />
 					<tbody>
          			<tr>
		             		<td>序号</td>
		             		<td>日期</td>
		             		<td>型号</td>
		             		<td>座位数</td>
		             		<td>车辆年限</td>
		             		<td>备注</td>
		             		
		             	</tr>
          			<c:forEach items="${bookingInfo.requirementInfos }" var="info" varStatus="v">
		             		<tr>
			                  <td >${v.index+1}</td>
			                  <td >${info.requireDate }</td> 
			                  <td >
				                  <c:forEach items="${ftcList}" var="v1">
									  <c:if test="${v1.id==info.modelNum}">${v1.value}</c:if>
								  </c:forEach>
			                  </td>
			                  <td >${info.countSeat }</td>
			                  <td >${info.ageLimit}</td>
			                  <td >${info.remark }</td>
			                  
		               		</tr>
		             	</c:forEach>
          			
          			</tbody>
          		</table>
		</div>
	</dd>
</dl>
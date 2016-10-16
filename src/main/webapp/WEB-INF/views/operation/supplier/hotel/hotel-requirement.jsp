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
								<col width="20%" />
								<col width="15%" />
								<col width="10%" />
								<col width="10%" />
								<col width="5%" />
								<col width="5%" />
								<col width="5%" />
								<col width="5%" />
								<col width="5%" />
								<col width="5%" />
								<col width="5%" />
								<col width="30%" />
								
				<tbody>
					<tr style="background: #F4F5F6;">
						
						<td rowspan="2"><b>客户名称</b></td>
						<td rowspan="2"><b>日期</b></td>
						<td rowspan="2"><b>区域</b></td>
						<td rowspan="2"><b>星级</b></td>
						<td colspan="5"><b>数量</b></td>
						<td rowspan="2"><b>接站牌</b></td>
						<td rowspan="2"><b>备注</b></td>
					</tr>
					<tr style="background: #F4F5F6;">
						<td>单人间</td>
						<td>标准间</td>
						<td>三人间</td>
						<td>陪房</td>
						<td>加床</td>
					</tr>
					<c:forEach items="${bookingInfo.requirementInfos }" var="require">
						<tr>
		 					
	          				<td>${require.nameFull }</td>
	          				<td>${require.requireDate }</td>
	          				<td>${require.area }</td>
	          				<td><c:forEach items="${jdxjList}" var="v" varStatus="vs">
									<c:if test="${v.id==require.hotelLevel}">${v.value}</c:if>
							  </c:forEach></td>
	          				<td>${require.countSingleRoom }</td>
	          				<td>${require.countDoubleRoom }</td>
	          				<td>${require.countTripleRoom }</td>
	          				<td>${require.peiFang }</td>
	          				<td>${require.extraBed }</td>
	          				<td>${ require.receiveMode}</td>
	          				<td>${ require.remark}</td>
		 				</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</dd>
</dl>

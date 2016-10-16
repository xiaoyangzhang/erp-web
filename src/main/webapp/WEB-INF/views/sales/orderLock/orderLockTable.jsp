<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/top.jsp"%>
<table class="w_table" style="margin-left: 0px">
	<colgroup> 
		<col width="4%"/>
		<col width="2%"/>
		<col width="11%"/>
		<col width="8%"/>
		<col width="23%"/>
		<col width="12%"/>
		<col width="7%"/>
		<col width="7%"/>
		<col width="6%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
		<col width="5%"/>
	</colgroup>
	<thead>
		<tr>
			<th><input id="selectAll" oclick="selectAll()" type="checkbox" value="1" />全选<i class="w_table_split"></i></th>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>发团日期<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>接站牌<i class="w_table_split"></i></th>
			<th>联系人<i class="w_table_split"></i></th>
			<th>客源地<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${orders}" var="gl" varStatus="v">
       		<tr>
       		 <td><input name="selectOne" type="checkbox" id="${gl.orderLockState}" value="${gl.id}" /></td>
              <td>${v.count}</td>
              <td style="text-align: left;">
	              <c:if test="${gl.orderType<=0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看团信息','<%=staticPath%>/fitGroup/toFitGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.tourGroup.groupCode}</a> 
	              </c:if>
	              <c:if test="${gl.orderType==1}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=staticPath%>/teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.tourGroup.id}&operType=0')">${gl.tourGroup.groupCode}</a>
	              </c:if>
              </td>
              <td style="text-align: left;">${gl.departureDate}</td>
              <td style="text-align: left">【${gl.productBrandName}】${gl.productName}</td>
              <td style="text-align: left">${gl.supplierName}</td>
              <td>${gl.receiveMode}</td>
              <td>${gl.contactName}</td>
              <td>${gl.provinceName}${gl.cityName}</td>
              <td>${gl.numAdult}+${gl.numChild}+${gl.numGuide}</td>
              <td>${gl.saleOperatorName}</td>
              <td>${gl.operatorName}</td>
              <td>
             		<a href="javascript:void(0);" onclick="lockOrUnLock(${gl.id},this)">
             			<c:if test="${gl.orderLockState==1}">解锁</c:if>
             			<c:if test="${gl.orderLockState==0}">锁单</c:if>
             		</a>
             		<c:if test="${gl.orderType==0}">
	              		<a class="def" href="javascript:void(0)" onclick="newWindow('查看订单信息','<%=ctx%>/fitOrder/toEditFirOrder.htm?orderId=${gl.id}&operType=0')">查看</a> 
	             	</c:if>
		              <c:if test="${gl.orderType==1}">
		              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看团信息','<%=ctx%>/teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.groupId}&operType=0')">查看</a>
		              </c:if>
		             <c:if test="${gl.orderType==-1}">
	              		<a class="def" href="javascript:void(0)" onclick="newWindow('查看订单信息','<%=ctx%>/specialGroup/toEditSpecialGroup.htm?id=${gl.id}&operType=0')">查看</a> 
	             	</c:if>
			  </td>
         	</tr>
         	<c:set var="sum_adult" value="${sum_adult+gl.numAdult}" />
			<c:set var="sum_child" value="${sum_child+gl.numChild}" />
			<c:set var="sum_guide" value="${sum_guide+gl.numGuide}" />
       	</c:forEach>
	</tbody>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		   	<td style="text-align: right">本页合计：</td>
         	<td>${sum_adult}+${sum_child}+${sum_guide}</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		   	<td style="text-align: right">总合计：</td>
         	<td>${totalPb}</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>


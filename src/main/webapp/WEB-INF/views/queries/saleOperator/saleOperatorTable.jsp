<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/top.jsp"%>
<table class="w_table" style="margin-left: 0px;width: 100%">
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>产品名称<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>
			<th>联系人<i class="w_table_split"></i></th>
			<th>人数<i class="w_table_split"></i></th>
			<th>客人<i class="w_table_split"></i></th>
			<th>星级<i class="w_table_split"></i></th>
			<th>房量<i class="w_table_split"></i></th>
			<th>接机<i class="w_table_split"></i></th>
			<th>送机<i class="w_table_split"></i></th>
			<th>省内交通<i class="w_table_split"></i></th>
			<th>销售<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
		</tr>
	</thead>
	<tbody>
       	<c:forEach items="${page.getResult()}" var="gl" varStatus="vs">
       		<tr>
              <td width="2%">${vs.count}</td>
              <td style="text-align: left;" width="4%">
	              <c:if test="${gl.orderType==0}">
	              	<a class="def" href="javascript:void(0)" onclick="newWindow('查看散客团信息','fitGroup/toFitGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.groupCode}</a> 
	              </c:if>
	              <c:if test="${gl.orderType==1}">
	              	<a href="javascript:void(0);" class="def" onclick="newWindow('查看定制团信息','teamGroup/toEditTeamGroupInfo.htm?groupId=${gl.groupId}&operType=0')">${gl.groupCode}</a>
	              </c:if>
              </td>
              <td width="8%" style="text-align: left">【${gl.productBrandName}】${gl.productName}</td>
              <td width="8%" style="text-align: left;">${gl.supplierName}</td>
              <td width="3%">${gl.contactName}</td>
              <td width="3%">${gl.numAdult}+${gl.numChild}+${gl.numGuide}</td>
              <td width="22%" class="rich_text1" height="100%">
 
              	<table class="in_table" border="1">
             <c:choose>
             	<c:when test="${gl.guests.size() !=  0}"><c:forEach items="${gl.guests}" var="l">
              		<tr>
              		<td style="text-align: left" width="30%">${l.name}</td>
              		<td style="text-align: left" width="50%">${l.certificateNum}</td>
              		<td style="text-align: left;" width="20%">${l.mobile}</td>
              		</tr>
              		</c:forEach>
             		</c:when>
             	<c:otherwise>
             	<tr>
              		<td style="text-align: left" width="30%"> </td>
              		</tr>
             	</c:otherwise>
             </c:choose>
      
              	</table>
              </td>
              <td width="4%" class="hl">${gl.hotelLevels}</td>
              <td width="4%" style="text-align: left">${gl.hotelNums}</td>
              <td width="10%" class="rich_text" style="text-align: left">${gl.upAir}</td>
              <td width="10%" class="rich_text" style="text-align: left">${gl.offAir}</td>
              <td width="10%" class="rich_text" style="text-align: left">${gl.trans}</td>
              <td width="3%">${gl.saleOperatorName}</td>
              <td width="3%">${gl.operatorName}</td>
              <td width="6%" style="text-align: left">${gl.remark}</td>
              
         </tr>
         <c:set var="sum_adult" value="${ sum_adult+gl.numAdult}"/>
         <c:set var="sum_child" value="${ sum_child+gl.numChild}"/>
         <c:set var="sum_guide" value="${ sum_guide+gl.numGuide}"/>
       	</c:forEach>
	</tbody>
	<tfoot>
		<tr class="footer1">
			<td colspan="5">合计：</td>
			<td>${sum_adult }大${sum_child }小${ sum_guide}陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>

		</tr>
		<tr class="footer2">
			<td colspan="5">总计：</td>
			<td>${sumPerson.totalAdult }大${sumPerson.totalChild }小${ sumPerson.totalGuide}陪</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>

		</tr>
	<tfoot>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
</jsp:include>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%> 
<%
    String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
<dd>
 <div class="pl-10 pr-10" >
<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="3%" />
	<col width="8%" />
	<col width="5%" />
	<col width="5%" />
	
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	<col width="7%" />
	
	<col width="10%" />
	<thead>
		<tr>
			<th>序号<i class="w_table_split"></i></th>
			<th>团号<i class="w_table_split"></i></th>
			<th>日期<i class="w_table_split"></i></th>
			<th>计调<i class="w_table_split"></i></th>
			
			<th>团款<i class="w_table_split"></i></th>
			<th>地接费<i class="w_table_split"></i></th>
			<th>房费<i class="w_table_split"></i></th>
			<th>餐费<i class="w_table_split"></i></th>
			<th>车费<i class="w_table_split"></i></th>
			<th>门票<i class="w_table_split"></i></th>
			<th>保险<i class="w_table_split"></i></th>
			<th>机票<i class="w_table_split"></i></th>
			<th>火车<i class="w_table_split"></i></th>
			
			<th>操作<i class="w_table_split"></i></th>
			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="item" varStatus="status">
			<tr>
				<td>${status.index+1}</td>
				<td style="text-align: left;">
	             ${item.group_code}
              	</td>
              	<td style="text-align: left;">
	             ${item.date_start}
              	</td>
				<td  style="text-align: left;">${item.operator_name}</td>
				
				
				<%-- <td ><fmt:formatNumber value="" pattern="#.##" type="currency"/></td> --%>
				<td ><fmt:formatNumber value="${item.tk}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.djf}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.ff}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.cf}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.chef}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.menpiao}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.baoxian}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.jipiao}" pattern="#.##" type="currency"/></td>
				<td ><fmt:formatNumber value="${item.huoche}" pattern="#.##" type="currency"/></td>
				
				<td>
					<a href="javascript:void(0);" onclick="editInit(${item.id})">编辑</a>
					<a href="javascript:void(0);" onclick="deleteInit(${item.id})">删除</a>
				</td>
			</tr>
			 <c:set value="${item.tk+tk}" var="tk"/>
			 <c:set value="${item.djf+djf}" var="djf"/>
			 <c:set value="${item.ff+ff}" var="ff"/>
			 <c:set value="${item.cf+cf}" var="cf"/>
			 <c:set value="${item.chef+chef}" var="chef"/>
			 <c:set value="${item.menpiao+menpiao}" var="menpiao"/>
			 <c:set value="${item.baoxian+baoxian}" var="baoxian"/>
			 <c:set value="${item.jipiao+jipiao}" var="jipiao"/>
			 <c:set value="${item.huoche+huoche}" var="huoche"/>
			 
		</c:forEach>
			<tr>
				<td colspan="4">合计:</td>
				<td><fmt:formatNumber value="${tk}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${djf}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${ff}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${cf}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${chef}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${menpiao}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${baoxian}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${jipiao}" pattern="#.##" type="currency"/></td>
				<td><fmt:formatNumber value="${huoche}" pattern="#.##" type="currency"/></td>
				<td></td>
			</tr>
	</tbody>
</table>
 </div>
 <div class="clear"></div>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
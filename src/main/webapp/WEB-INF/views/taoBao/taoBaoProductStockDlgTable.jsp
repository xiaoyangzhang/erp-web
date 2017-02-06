<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table cellpadding="0" class="w_table" > 
    <thead>
    	<tr>
    		<th>选择<i class="w_table_split"></i></th>
    		<th>库存名<i class="w_table_split"></i></th>
    		<th>自编码<i class="w_table_split"></i></th>
    		<th>产品名称<i class="w_table_split"></i></th>
			<th>套餐名称<i class="w_table_split"></i></th>
    		<th>总库存<i class="w_table_split"></i></th>
    		<th>已售<i class="w_table_split"></i></th>
    		<th>余位<i class="w_table_split"></i></th>
    	</tr>
    </thead>
    <tbody>
    <c:forEach items="${pageBean.result}" var="res" varStatus="status">
       <tr id="${tbpResult.id }"> 
       	  <td width="5%"><input type="radio" name="stockDateId" value="${res['stock_id']}^${res['stockDateId']}^${res['stockBalance']}^${res['outer_id']}"></td>
          <td width="10%">${res['stock_name']}</td>
          <td width="20%" style="text-align:left;">${res['outer_id']}</td>
          <td style="text-align:left;">${res['title']}</td>
		   <td width="20%" style="text-align:left;">${res['pid_name']}</td>
          <td width="8%">${res['stock_count']}</td>
          <td width="8%">${res['sale_count']}</td>
          <td width="8%;font-weight:bold;">${res['stockBalance']}</td>
       </tr>
     </c:forEach>
    </tbody>
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<table cellspacing="0" cellpadding="0" class="w_table" style="min-width:600px;" > 
		             <thead>
		             	<tr>
		             		<th width="100">采购单号<i class="w_table_split"></i></th>
		             		<th width="100">行程开始日期<i class="w_table_split"></i></th>
		             		<th width="100">行程结束日期<i class="w_table_split"></i></th>
		             		<th width="150">航线<i class="w_table_split"></i></th>
		             		<th width="200">航段<i class="w_table_split"></i></th>
		             		<th width="50">票数<i class="w_table_split"></i></th>
		             		<th width="50">已申请<i class="w_table_split"></i></th>
		             		<th width="50">剩余<i class="w_table_split"></i></th>
		             		<th width="70">单价<i class="w_table_split"></i></th>
		             		<th width="80">最晚出票<i class="w_table_split"></i></th>
		             		<th width="80">备注<i class="w_table_split"></i></th>
		             		<th >操作</th>
		             	</tr>
		             </thead>
		             <tbody>
		             <c:forEach items="${result}" var="resourceInfo" varStatus="status">
			               <tr id="${resourceInfo.id }"> 
			                  <td>${resourceInfo.resourceNumber }</td>
			                  <td>${resourceInfo.startDate }</td>
			                  <td>${resourceInfo.endDate }</td>
			                  <td>${resourceInfo.po.lineName }</td>
			                  <td>${resourceInfo.legHtml }</td>
			                  <td>${resourceInfo.po.totalNumber }</td>
			                  <td>${resourceInfo.po.appliedNumber }</td>
			                  <td>${resourceInfo.po.availableNumber }</td>
			                  <td>${resourceInfo.price }</td>
			                  <td>${resourceInfo.endIssueTime}</td>
			                  <td><pre>${resourceInfo.comment}</pre></td>
			                  <td><a class="button button-rounded button-primary button-small" href="javascript:selectResource(${resourceInfo.id }, '${resourceInfo.resourceNumber }')">选择</a> 
			                  </td>
			               </tr>
		              </c:forEach>
		             </tbody>
	          		</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${page.page }" name="p" />
	<jsp:param value="${page.totalPage }" name="tp" />
	<jsp:param value="${page.pageSize }" name="ps" />
	<jsp:param value="${page.totalCount }" name="tn" />
	<jsp:param value="resourceQueryList" name="fnQuery"/>
	<jsp:param value="resourcePagination" name="divId"/>
</jsp:include>

  
  
  


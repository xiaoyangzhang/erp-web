<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
	<%
    String path = request.getContextPath();
%>
    <script type="text/javascript">
		function del(id) {
			if(confirm("确认删除该角色吗")){
				$.post(
				      'deleteRole',
				      {
				        roleId:id
				      },
				      function (data) //回传函数
				      {
				    	  queryList($("#page").val(), $("#pageSize").val());
				      }
			    );
			}
		}
	</script>
<table cellspacing="0" cellpadding="0" class="w_table" > 
		             <col width="5%" /><col width="15%" /><col width="15%" /><col width="15%" /><col width="5%" /><col width="15%" /><col width="10%" />
		             <thead>
		<tr>					
			<th>序号<i class="w_table_split"></i></th>
			<th>角色组<i class="w_table_split"></i></th>
			<th>名称<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>
			<th>状态<i class="w_table_split"></i></th>
			<th>创建时间<i class="w_table_split"></i></th>
			<th>操作<i class="w_table_split"></i></th>
		</tr>
	</thead>

	<tbody>
		<c:forEach var="role" items="${pageBean.result }" varStatus="status" >
			<tr>
				 <td>${status.count }</td> 
				<td>${role.groupName }</td>
				<td><a href="javascript:void(0)" onclick="newWindow('修改角色','<%=path %>/role/editRole?roleId=${role.roleId}')">${role.name }</a></td>
				<td>${role.comment }</td>
				<td>
					<c:choose>
						<c:when test="${role.status==1}">启用
						</c:when>
						<c:otherwise>禁用
						 </c:otherwise>
					</c:choose>
  				</td>
				<td>${fn:substring(role.createTime,0,19) }</td>
				<td>
					<c:if test="${userSession.optMap['roleEdit']}"><a href="javascript:void(0)" onclick="newWindow('修改角色','<%=path %>/role/editRole?roleId=${role.roleId}')"class="def">编辑</a>	</c:if>
					<a href="javascript:void(0)" class="def" onclick="del('${role.roleId }')">删除</a>
					<a href="javascript:void(0)" class="def" onclick="copyRole('${role.roleId }')">复制</a>
				</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<div class="row">
	<jsp:include page="/WEB-INF/include/page.jsp">
		<jsp:param value="${pageBean.page }" name="p"/>
		<jsp:param value="${pageBean.totalPage }" name="tp" />
		<jsp:param value="${pageBean.pageSize }" name="ps" />
		<jsp:param value="${pageBean.totalCount }" name="tn" />
	</jsp:include>
</div>


			
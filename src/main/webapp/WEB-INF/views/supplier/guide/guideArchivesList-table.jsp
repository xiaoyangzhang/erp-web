<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>
<script type="text/javascript">
	function del(id){
		
		$.confirm("确认删除关联吗？", function() {
			$.getJSON("delGuide.do?id=" + id, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
					window.location = window.location;
					});
				}

			});
		}, function() {
			$.info('取消删除');
		})

		
	}


</script>

	<table class="w_table" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="5%">
							<col width="10%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="15%">
							<col width="15%">
					    </colgroup>
			<thead>
				<tr>
					<th>序号<i class="w_table_split"></i></th>
					<th>等级<i class="w_table_split"></i></th>
					<th>星级<i class="w_table_split"></i></th>
					<th>姓名<i class="w_table_split"></i></th>
					<th>性别<i class="w_table_split"></i></th>
					<th>手机<i class="w_table_split"></i></th>
					<th>语种<i class="w_table_split"></i></th>
					<th>操作<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<c:forEach items="${pageBean.result}" var="guide" varStatus="status">
				<tr>
					<td>${status.count}</td>
					<td>${guide.levelName}</td>
					<td>${guide.starLevelName }</td>
					<td>
						<a onclick="newWindow('导游详情','<%=staticPath %>/supplier/guideDetail.htm?id=${guide.id }')" href="javascript:void(0);"> 
							${guide.name}
						</a>
					</td>
					<td><c:if test="${guide.gender==0 }">男</c:if><c:if test="${guide.gender==1 }">女</c:if></td>
					<td>${guide.mobile}</td>
					<td>${guide.language }</td>
					<td>
						<a href="javascript:void(0);" class="def" onclick="newWindow('修改导游','<%=staticPath %>/supplier/editGuide.htm?id=${guide.id }')" >修改</a>
						<a href="javascript:void(0);" class="def" onclick="del(${guide.id })">删除</button>
					</td>
					
				</tr>

			</c:forEach>
		</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>
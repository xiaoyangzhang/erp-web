<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../../include/path.jsp"%>








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
					<th><input type="checkbox" name="checkAll" id="checkAll" value="" /></th>
					<th>序号<i class="w_table_split"></i></th>
					<th>等级<i class="w_table_split"></i></th>
					<th>星级<i class="w_table_split"></i></th>
					<th>姓名<i class="w_table_split"></i></th>
					<th>性别<i class="w_table_split"></i></th>
					<th>手机<i class="w_table_split"></i></th>
					<th>语种<i class="w_table_split"></i></th>
				</tr>
			</thead>
			<c:forEach items="${pageBean.result}" var="guide" varStatus="status">
				<tr>
					<td><input type="checkbox" name="subBox" id="" value="" guideId="${guide.id}"/></td>
					<td>${status.count}</td>
					<td><c:if test="${guide.level!=-1}">${guide.levelName}</c:if></td>
					<td>${guide.starLevelName }</td>
					<td>${guide.name}</td>
					<td><c:if test="${guide.gender==0 }">男</c:if><c:if test="${guide.gender==1 }">女</c:if></td>
					<td>${guide.mobile}</td>
					<td>${guide.language }</td>
					
				</tr>

			</c:forEach>
		</table>


<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p" />
	<jsp:param value="${pageBean.totalPage }" name="tp" />
	<jsp:param value="${pageBean.pageSize }" name="ps" />
	<jsp:param value="${pageBean.totalCount }" name="tn" />
</jsp:include>

<script type="text/javascript">
//全选按钮
    $(function() {
       $("#checkAll").click(function() {
            $('input[name="subBox"]').attr("checked",this.checked); 
        });
        var $subBox = $("input[name='subBox']");
        $subBox.click(function(){
            $("#checkAll").attr("checked",$subBox.length == $("input[name='subBox']:checked").length ? true : false);
        });
    });
</script>
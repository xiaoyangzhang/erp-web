<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table class="w_table">
	<colgroup>
		<col width="8%">
		<col width="20%">
		<col width="">		
    </colgroup>
	<thead>
		<tr>	
			<th><c:if test="${single==0 }"><input type="checkbox" id="chkall" onclick="chkAll(this)" /></c:if><i class="w_table_split"></i></th>
			<th>区域<i class="w_table_split"></i></th>
			<th>名称<i class="w_table_split"></i></th>				
		</tr>
	</thead>
	<c:forEach items="${list}" var="supplierInfo" varStatus="status">
		<tr>
			<td><input type="checkbox" name="chk" psid="${supplierInfo.id }" sid="${supplierInfo.supplierId}" sname="${supplierInfo.supplierName}" province="${supplierInfo.province}" city="${supplierInfo.city}" onclick="chkSupplier(this)"/></td>
			<td>${supplierInfo.province}${supplierInfo.city}</td>
			<td>${supplierInfo.supplierName}</td>					
		</tr>
	</c:forEach>
</table>
<script type="text/javascript">
$(function(){
	fixHeader(20);
})
</script>
		
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<table cellspacing="0" cellpadding="0" class="w_table">
	<col width="10%" />
	<col width="20%" />
	<col width="20%" />
	<col width="" />
	<col />
	<thead>
		<tr>
			<th><input type="checkbox" name="chkall" class="chkall"><i class="w_table_split"></i></th>
			<th>项目<i class="w_table_split"></i></th>
			<th>协议价<i class="w_table_split"></i></th>
			<th>备注</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${priceList}" var="price" varStatus="v">
			<tr>
				<td><input type="checkbox" name="chkitem" class="chkitem" itemName="${price.itemTypeName }" unitPrice="<fmt:formatNumber value="${price.contractPrice}" pattern="#.##" type="currency"/>"/></td>
				<td>${price.itemTypeName }</td>
				<td><fmt:formatNumber value="${price.contractPrice}" pattern="#.##" type="currency"/></td>
				<td style="text-align: left">${price.note }</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<script type="text/javascript">
	$(function(){
		$("input[name='chkitem']").click(function(){
			var area = $(this).closest("table");
			$(area).find("input.chkall").attr("checked",$(area).find("input.chkitem").length == $(area).find("input.chkitem:checked").length ? true:false);
		})
				
		$("input[name='chkall']").unbind("click").bind("click",function(){
			var chked = $(this).is(':checked');
			$(this).closest("table").find("input.chkitem").each(function(){
				$(this).attr("checked",chked);
			})
		})
	})
</script>


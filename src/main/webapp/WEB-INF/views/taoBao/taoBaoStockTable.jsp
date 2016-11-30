<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String path = request.getContextPath();
%>
<table class="w_table" style="margin-left: 0px">
	<thead>
		<tr>
			<th style="width:5%">序号<i class="w_table_split"></i></th>
			<th style="width:40%">名称<i class="w_table_split"></i></th>
			<th style="width:10%">提前归零天数<i class="w_table_split"></i></th>
			<th style="width:10%">产品数<i class="w_table_split"></i></th>
			<th style="width:15%">备注<i class="w_table_split"></i></th>
			<th style="width:20%">操作</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${pageBean.result}" var="tbStock" varStatus="status">
			<tr>
				<td>${status.index+1 }</td>
				<td>${tbStock.stockName }</td>
				<td>${tbStock.clearDayReset }</td>
				<td>${tbStock.sumProductId }</td>
				<td>${tbStock.brief }</td>
				<td>
					<a href="javascript:void(0)" onclick="tbStockModifyBtn(${tbStock.id });">修改</a>
					<a href="javascript:void(0)" onclick="tbStockDeleteBtn(${tbStock.id });">删除</a>
					<a href="javascript:void(0)" onclick="tbStockProBindingBtn(${tbStock.id });">关联产品</a>
					<a href="javascript:void(0)" onclick="tbStockBtn(${tbStock.id });">库存</a>
				</td>
			</tr>
		</c:forEach>
	</tbody>
	<!-- <tfoot>
		<tr class="footer1">
 			<td style="text-align: right;">页合计</td>
            <td></td>   
            <td></td>   
            <td></td>
            <td></td>
            <td></td>		
		</tr>
		<tr class="footer2">
 			<td style="text-align: right">总合计</td>
            <td></td>   
            <td></td>   
            <td></td>
            <td></td>
            <td></td>		
		</tr>
	</tfoot> -->
</table>
<jsp:include page="/WEB-INF/include/page.jsp">
	<jsp:param value="${pageBean.page }" name="p"/>
	<jsp:param value="${pageBean.totalPage }" name="tp"/>
	<jsp:param value="${pageBean.pageSize }" name="ps"/>
	<jsp:param value="${pageBean.totalCount }" name="tn"/>
</jsp:include>

<script type="text/javascript">
/* 修改 */
function tbStockModifyBtn(obj){
	layer.open({
		type : 2,
		title : '修改淘宝库存',
		shadeClose : true,
		shade : 0.5,
		area: ['460px', '260px'],
		content: '<%=path%>/taobaoProect/toUpdatetbStockChange.htm?id='+obj
	});
}

/* 关联产品 */
function tbStockProBindingBtn(id){
	newWindow('关联产品','<%=path%>/taobaoProect/toStockProductBindingList.do?stockId='+id);
}

function tbStockBtn(id){
	newWindow('库存设置','<%=path%>/taobaoProect/kalendarStock.htm?stockId='+id);
}

function tbStockDeleteBtn(obj){
	$.confirm("确认删除吗？",function(){
		  $.post("deleteTaoBaoStock.do",{id:obj},function(data){
		   		if(data.success == '1'){
		   			$.success('删除成功！', function(){
		   				//刷新页面
						location.reload();
					});		
		   			
		   			
		   		}
		   		if(data.error == 'logError'){
		   			$.error("该条记录存在订单信息，不能删除！");
		   		}
		  },"json");
	},function(){
	  $.info('取消删除！');

	});
}

</script>














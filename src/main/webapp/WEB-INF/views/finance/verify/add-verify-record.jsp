<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String staticPath = request.getContextPath();
%>
<style type="">
	#addVerifyForm p{
		padding:10px;
	}
	#addVerifyForm label{
		display:inline-block;
		width:100px;
	}
	
	#addVerifyForm span{
		display:inline-block;
		width:200px;
	}
</style>
<div class="p_container">
	<form id="addVerifyForm">
		<p>
			<label >类型:</label>
			<span>
				
				<input id="supplierType" name="supplierType" type="hidden" value="${reqpm.supplierType }" />
				
				<c:if test="${reqpm.supplierType eq 1}">组团社</c:if>
				<c:if test="${reqpm.supplierType eq 16}">地接社</c:if>
				
				<c:if test="${reqpm.supplierType eq 2}">餐厅</c:if>
				<c:if test="${reqpm.supplierType eq 3}">酒店</c:if>
				<c:if test="${reqpm.supplierType eq 4}">车队</c:if>
				<c:if test="${reqpm.supplierType eq 5}">景区</c:if>
				<c:if test="${reqpm.supplierType eq 6}">购物</c:if>
				<c:if test="${reqpm.supplierType eq 7}">娱乐</c:if>
				<c:if test="${reqpm.supplierType eq 8}">导游</c:if>
				<c:if test="${reqpm.supplierType eq 9}">机票</c:if>
				<c:if test="${reqpm.supplierType eq 10}">火车票</c:if>
				<c:if test="${reqpm.supplierType eq 11}">高尔夫</c:if>
				<c:if test="${reqpm.supplierType eq 15}">保险</c:if>
				<c:if test="${reqpm.supplierType eq 120}">其他收入</c:if>
				<c:if test="${reqpm.supplierType eq 121}">其他支出</c:if>
			</span>
		</p>
		
		<p>
			<label>商家名称:</label>
			<span>
				<input id="supplierName" name="supplierName" type="text" onclick="showSupplierList();" class="w-100" 
					style="width:96%;cursor: pointer;background: #fff url('<%=staticPath %>/assets/images/xiala.png') no-repeat scroll right center;" />
			</span>
		</p>	
		
		<p>		
			<label>账期:</label>
			<span>
			<input style="width:41%;" name="startTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
			~
			<input style="width:41%;" name="endTime" type="text" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
			</span>
		</p>	
	</form>
</div>

<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/jquery-ui/jquery-ui-1.9.2.custom.min.js"></script>
<script type="text/javascript" src="<%=staticPath%>/assets/js/region/region.selection.js"></script>
<script type="text/javascript">

function showSupplierList(){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $('#supplierName').trigger(e);
}

(function(){
	var supplierType = $("#supplierType").val();
	$("#supplierName").autocomplete({
		source: function(request, response) {
			
			var supplierName = encodeURIComponent(request.term);
			$.ajax({
				type : "get",
				url : "<%=staticPath %>/verify/getSupplierNameList.do",
				data : {
					supplierType : supplierType,
					supplierName : supplierName
				},
				dataType : "json",
				success : function(data){
					if(data && data.success == 'true'){
						response($.map(data.result,function(v){
							return {
								label : v.name,
								value : v.name
						    }
						}));
					}
			  	},
			  	error : function(data,msg){
			  	}
			});
	},
	focus: function(event, ui) {
		$(".adress_input_box li.result").removeClass("selected");
		$("#ui-active-menuitem").closest("li").addClass("selected");
	},
	minLength : 0,
	autoFocus : true,
	delay : 300
	});
})();
</script>
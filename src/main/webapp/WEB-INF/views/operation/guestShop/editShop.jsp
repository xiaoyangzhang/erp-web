<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
<%
	String path = request.getContextPath();
%>

</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub">
	    
	    	<p class="p_paragraph_title"><b>购物录入：</b></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20">
	    			 <form class="definewidth m20" id="addDeploys">
	    				<table cellspacing="0" cellpadding="0" class="w_table w-1100 tab_guide">
	    					<col width="5%"/><col width="15%"/><col width="15%"/><col width="10%"/><col width="10%"/>
	    					<col width="20%"/>
	    					<thead>
	    						<th>序号<i class="w_table_split"></th>
								<th>组团社<i class="w_table_split"></i></th>					
								<th>接站牌<i class="w_table_split"></i></th>					
								<th>客源地<i class="w_table_split"></i></th>					
								<th>人数<i class="w_table_split"></i></th>
								<th>购物店/金额<i class="w_table_split"></i></th>
								<!-- <th>金额<i class="w_table_split"></i></th> -->
									
	    					</thead>
	    					<tbody id="deployTb">
		    					 <c:forEach items="${bookingGroups}" var="d" varStatus="status">
			    					<tr>
			    						<td rowspan="${rowspan eq 1?1:rowspan }">${status.count }</td>
			    						<td rowspan="${rowspan eq 1?1:rowspan }">${d.supplierName }</td>
			    						<td rowspan="${rowspan eq 1?1:rowspan }">${d.receiveMode }</td>
			    						<td rowspan="${rowspan eq 1?1:rowspan }">${d.provinceName }${d.cityName }</td>
			    						<td rowspan="${rowspan eq 1?1:rowspan }">${d.adultCount}大${d.childCount }小</td>
			    						<td>
			    							<c:if test="${d.deploys ne null and fn:length(d.deploys)>0 }">
			    								<table class="in_table">
			    									 <c:forEach items="${d.deploys}" var="bs" varStatus="st">	    					 			    					 
							    					 		<tr>
							    					 			<td>
							    					 				${bs.supplierName }
							    					 			</td>
								    					 		<td name="dataTd">
									    						 	<input type="hidden" name='bookingId' value="${bs.bookingId }" />
									    						 	<input type="hidden" name='id' value="${bs.id }" />
									    						  	<input type="hidden" name='orderId' value="${d.orderId }" /> 
									    							<input type='text'  name='buyTotal' value="<fmt:formatNumber value="${bs.butTotal eq null?'':bs.butTotal }" pattern="#.##" type="number"/>" />
									    						</td>
								    						</tr>
								    					<c:set var="sum_price" value="${sum_price+bs.butTotal}" />
						    					 	</c:forEach> 
			    								</table>
			    							</c:if>
			    						</td>
			    				</c:forEach>
		    				</tbody>
		    		<tfoot>
		    			<tr>
          					<td colspan="5" >合计</td>
          					
          					<td id="sumPrice"><fmt:formatNumber value="${sum_price }" pattern="#.##" type="currency"/></td>
          					
          				</tr>
		    		</tfoot>
	    				</table>
	    						<div class="Footer">
						 	<dl class="p_paragraph_content">
							<dd>
							<%-- <c:if test="${view ne 1 }"> --%>
						 <button  type="submit" class="button button-primary button-small">保存</button>
							<%--  </c:if> --%>
	    					<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
						</dd>
					</dl>
				</div>	
	    				</form>
	    			</div>
	    		</dd>
	    		
	    	</dl>
	    	
        </div>
       
    </div>

</body>
<script type="text/javascript" src="<%=path %>/assets/js/utils/float-calculate.js"></script>
<script type="text/javascript" src="<%=path %>/assets/js/json2.js"></script>

<script type="text/javascript">
function getShopDetails(){
	var shopDetails =new Array();
	var rowBuy;
	$("#deployTb tr td[name='dataTd']").each(function(){
		rowBuy = $(this).find("input[name='buyTotal']").val();
		if (rowBuy == '') rowBuy = 0;
		var shopDetail={
				bookingId:$(this).find("input[name='bookingId']").val(),
				id:$(this).find("input[name='id']").val(),
				orderId:$(this).find("input[name='orderId']").val(),
				buyTotal:rowBuy
				//repayTotal:$(this).find("input[name='repayTotal']").val(),
				//repayVal:$(this).find("input[name='repayVal']").val()
		};
		//console.log(shopDetail);
		if(shopDetail.orderId!=null){
			shopDetails.push(shopDetail);}
	})
	return shopDetails;
}
$(function(){
	//$("#input[name$='.buyTotal']").removeAttr("onchange").change(function(){
		
	bindEvent();
	
})
function bindEvent(){
	//计算总价				
	$("input[name$='buyTotal']").each(function(){
		$(this).removeAttr("onblur").blur(function(){
	$("#sumPrice").html(calcSumPrice());
	})			
	//return sum;
	})
function calcSumPrice(){
	var sum=0;
	//计算总价				
	$("input[name$='buyTotal']").each(function(){
		
		var totalPrice= $(this).val()=='' ? 0:$(this).val();
		sum = (new Number(sum)).add(new Number(isNaN(totalPrice) ? 0:totalPrice));
	})			
	return sum;
	//$("#sumPrice").val(sum);
	
}
}
bindEvent();

$(function(){
	//bindEvent();
	$("#addDeploys").validate(
			{
				rules:{
					
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					var shopDetails= getShopDetails();
					var options = {
						url : "saveDeploys.do",
						type : "post",
						dataType : "json",
						data:{
							shopDetails:JSON.stringify(shopDetails)
						},
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									location.reload();
								});
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error('服务忙，请稍后再试');
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	
	/* $("#shop").validate(
			{
				rules:{
					'personRepayPrice' : {
						required : true
					},
					'personNumFact' : {
						required : true
					}
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {

					var options = {
						url : "saveShop.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功');
								 
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					};
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			}); */
});

/* function del(id,groupId){	
	$.confirm("确认删除此数据吗？",function(){
			  $.post("delShopDetail.do",{id:id,groupId:groupId},function(data){
			   		if(data.success){
			   			$.info('删除成功！');
			   			$("#"+id).remove();
			   			
			   		}else{
			   			$.info(data.msg);
			   		}
			  },"json");
	},function(){
		  $.info('取消删除！');
		
	});

} */

</script>
</html>

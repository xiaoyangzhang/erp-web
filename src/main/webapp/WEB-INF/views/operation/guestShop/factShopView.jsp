<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>基本信息</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>


</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub">
	    <p class="p_paragraph_title"><b>预定信息：</b>
            <dl class="p_paragraph_content">
            	<table cellspacing="0" cellpadding="0" class="w_table w-1100 tab_guide">
	    					<col width="5%"/><col width="5%"/>
	    					<col width="5%"/><col width="5%"/>
	    					<col width="5%"/><col width="5%"/>
	    					<col width="5%"/><col width="5%"/>
	    					<col width="5%"/><col width="10%"/>
	    					
	    					<thead>
	    						
	    						<th>订单号<i class="w_table_split"></i></th>
	    						<th>订单时间<i class="w_table_split"></i></th>
	    						<th>预定员<i class="w_table_split"></i></th>
	    						<th>购物店<i class="w_table_split"></i></th>
	    						<th>进店日期<i class="w_table_split"></i></th>
	    						<th>导游<i class="w_table_split"></i></th>
	    						<th>人数<i class="w_table_split"></i></th>
	    						<th>预计人均消费金额<i class="w_table_split"></i></th>
	    						<th>备注<i class="w_table_split"></i></th>
	    					</thead>
	    					<tbody>
	    						<tr>
	    						
	    							<td>${shop.bookingNo }</td>
	    							<td><fmt:formatDate value="${shop.bookingDate }" pattern="yyyy-MM-dd"/></td>
	    							<td>${shop.userName }</td>
	    							<td>${shop.supplierName }</td>
	    							<td>${shop.shopDate }</td>
	    							<td>${shop.userName }</td>
	    							<td>${shop.personNum }</td>
	    							<td><fmt:formatNumber value="${shop.personBuyAvg }" pattern="#.##" type="number"/></td>
	    							<td>${shop.remark }</td>
	    						</tr>
	    					</tbody>
	    					</table>
            </dl>
	    	<%-- <p class="p_paragraph_title"><b>人员消费返款：</b></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20">
	    			<form id="shop">
	    				<table cellspacing="0" cellpadding="0" class="w_table w-500 tab_guide">
	    					<col width="5%"/><col width="15%"/><col width="20%"/><col width="10%"/><col width="10%"/>
	    					<thead>
	    						<th>成人人数<i class="w_table_split"></i></th>
	    						<th>人员返款单价<i class="w_table_split"></i></th>
	    						<th>人员返款合计<i class="w_table_split"></i></th>
								<th>操作</th>
	    					</thead>
	    					 
		    					<tr>
		    						<td>
		    							<input type="hidden" name="id" value="${id }">
		    							<input type="hidden" name="groupId" value="${shop.groupId }">  
		    							<input type="text" id="personNumFact" name="personNumFact"  value="${shop.personNumFact }">
		    							
		    						</td>
		    						<td>		    							
		    							<input type="text" id="personRepayPrice" name="personRepayPrice"  value="<fmt:formatNumber value="${shop.personRepayPrice }" pattern="0.00" type="number"/>">
		    						</td>
		    						<td>
		    							<input type="text" id="personRepayTotal" name="personRepayTotal" value="<fmt:formatNumber value="${shop.personRepayTotal }" pattern="0.00" type="number"/>" >
		    						</td>
		    						<td>
			    						<c:if test="${view ne 1 }">
			    							 <button  type="submit" class="button button-primary button-small">保存</button>
			    						</c:if>
		    						</td>
		    					
		    					</tr>
		    			
	    				</table>
	    				</form>
	    			</div>
	    		</dd>
	    		
	    	</dl>--%>
	    	
	    	
	    	<p class="p_paragraph_title"><b>客人购物录入：</b></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20">
	    			 <form class="definewidth m20" id="addDeploy">
	    				<table cellspacing="0" cellpadding="0" class="w_table w-1100 tab_guide">
	    					<col width="10%"/><col width="10%"/><col width="15%"/><col width="15%"/><col width="5%"/>
	    					<col width="20%"/>
	    					<thead>
	    						<th>序号<i class="w_table_split"></th>
	    						<th>订单号<i class="w_table_split"></i></th>
								<th>组团社<i class="w_table_split"></i></th>					
								<th>客人名单<i class="w_table_split"></i></th>					
								<th>人数<i class="w_table_split"></i></th>
								<th>购买金额<i class="w_table_split"></i></th>
								<th>备注<i class="w_table_split"></i></th>		
	    					</thead>
	    					<tbody>
	    					 <c:forEach items="${detailDeploys}" var="d" varStatus="status">
		    					<tr>
		    						<td>${status.count }</td>
		    						<td>${d.orderNo }</td>
		    						<td>${d.supplierName }</td>
		    						<td>${d.guestNames }</td>
		    						<td>${d.adultNum }大${d.childNum }小</td>
		    						<td>
		    						<input type="hidden" name='detail[${status.index }].orderId' value="${d.orderId }" />
		    						 <input type="hidden" name='detail[${status.index }].bookingId' value="${d.bookingId }" />
		    						<c:if test="${view ne 1 }"> <input type='text'  name='detail[${status.index }].buyTotal' value="<fmt:formatNumber value="${d.buyTotal eq null?0:d.buyTotal }" pattern="#.##" type="number"/>" /></td></c:if>
		    							<c:if test="${view eq 1 }"><fmt:formatNumber value="${d.buyTotal }" pattern="#.##" type="number"/>
		    						</c:if>
		    						<td>
		    						<c:if test="${view ne 1 }"><textarea  name='detail[${status.index }].remark' class='IptText300'>${d.remark }</textarea>
		    						</c:if>
		    						<c:if test="${view eq 1 }">${d.remark }
		    						</c:if>
		    						</td>
		    					</tr>
		    					<c:set var="sum_price" value="${sum_price+d.buyTotal}" />
		    					<%-- <c:set var="sum_people" value="${sum_people+d.guestSize}" /> --%>
		    				</c:forEach>
		    				</tbody>
		    		<tbody>
		    			<tr>
          					<td colspan="5" >合计</td>
          					<%-- <td>${ sum_people}</td> --%>
          					<td><fmt:formatNumber value="${sum_price }" pattern="#.##" type="currency"/></td>
          					<td></td>
          				</tr>
		    		</tbody>
	    				</table>
	    						<div class="Footer">
						 	<dl class="p_paragraph_content">
							<dd>
							<c:if test="${view ne 1 }">
						 <button  type="submit" class="button button-primary button-small">保存</button>
							 </c:if>
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
<script type="text/javascript">
var inputChange = function () {
	$("#personRepayPrice,#personNumFact").unbind("change").bind("change", function(){
		
		$("#personRepayTotal").val($("#personNumFact").val()*$("#personRepayPrice").val());
	});
}

inputChange();


function editDetailDeploy(orderId,bookingDetailId){
	$("#deployTDid").empty();
	 $.ajax({
         type: "post",
         cache: false,
         url: "editDetailDeploy.htm",
         data: {
        	 orderId: orderId,
        	 bookingDetailId : bookingDetailId
         },
         dataType: 'json',
         async: false,
         success: function (data) {
        	 for (var i = 0; i < data.length; i++) {
        		 var item = data[i];
        		  $("#deployTDid").append("<tr><td>"+item.orderNo+"</td><td>"+item.supplierName+"</td><td>"+item.guestNames+"</td><td>"+item.guestSize+"</td><td><input type='hidden' name='detail["+i+"].orderId' value="+(item.orderId)+" /><input type='hidden' name='detail["+i+"].bookingDetailId' value="+(item.bookingDetailId)+" /><input name='detail["+i+"].buyTotal' value='"+(item.buyTotal ?item.buyTotal : "") +"' style='width:50px' /></td><td><textarea  name='detail["+i+"].remark' class='IptText150'>"+(item.remark?item.remark : "")+"</textarea></td></tr>"); 
        	 }
        		 layer.open({
        		        type: 1,
        		        title :'消费分摊',
        		        area: [ '50%', '45%'],
        		        shadeClose: true, //点击遮罩关闭
        		        content: $('#deployDiv'),
        		        btn: ['确定', '取消'],
        		        yes: function(index){
        		        	$("#addDeploy").submit();     			         
        			    },cancel: function(index){
        			    	layer.close(index);
        			    }
        		    });
         }
     });

};



function detailDeploy(orderId,bookingDetailId){
	$("#deployTDid").empty();
	 $.ajax({
         type: "post",
         cache: false,
         url: "editDetailDeploy.htm",
         data: {
        	 orderId: orderId,
        	 bookingDetailId : bookingDetailId
         },
         dataType: 'json',
         async: false,
         success: function (data) {
        	 for (var i = 0; i < data.length; i++) {
        		 var item = data[i];
        		  $("#deployTDid").append("<tr><td>"+item.orderNo+"</td><td>"+item.supplierName+"</td><td>"+item.guestNames+"</td><td>"+item.guestSize+"</td><td><input type='hidden' name='detail["+i+"].orderId' value="+(item.orderId)+" /><input type='hidden' name='detail["+i+"].bookingDetailId' value="+(item.bookingDetailId)+" /><input class='IptText300' name='detail["+i+"].buyTotal' value='"+(item.buyTotal ?item.buyTotal : "") +"' /></td><td><textarea  name='detail["+i+"].remark' class='IptText150'>"+(item.remark?item.remark : "")+"</textarea></td></tr>"); 
        	 }
        		 layer.open({
        		        type: 1,
        		        title :'消费分摊',
        		        area: [ '50%', '45%'],
        		        shadeClose: true, //点击遮罩关闭
        		        content: $('#deployDiv'),
        		        btn: [ '取消'],
        		       cancel: function(index){
        			    	layer.close(index);
        			    }
        		    });
         }
     });

};

$(function(){
	
	$("#addDeploy").validate(
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
				
					var options = {
						url : "saveDeploy.do",
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功');
								 location.reload(); 
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
			});
	
	$("#shop").validate(
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
			});
});

function del(id,groupId){	
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

}

</script>
</html>

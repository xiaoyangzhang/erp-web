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
	    <p class="p_paragraph_title"><b>预定信息：</b>  <a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a></p>
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
	    							<td><fmt:formatNumber value="${shop.personBuyAvg }" pattern="0.00" type="number"/></td>
	    							<td>${shop.remark }</td>
	    						</tr>
	    					</tbody>
	    					</table>
            </dl>
	    	<p class="p_paragraph_title"><b>人员消费返款：</b></p>	    	
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
	    		
	    	</dl>
	    	
	    	
	    	<p class="p_paragraph_title"><b>实际消费返款：</b><c:if test="${view ne 1 }"><a href="toEditShopDetail.htm?bookingId=${id }&shopDate=${shop.shopDate}&supplierId=${shop.supplierId}&groupId = ${shop.groupId }" class="btn_guide_add button button-primary button-small">添加</a></c:if></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20">
	    				<table cellspacing="0" cellpadding="0" class="w_table w-1100 tab_guide">
	    					<col width="5%"/><col width="5%"/><col width="5%"/><col width="5%"/><col width="5%"/>
	    					<col width="5%"/><col width="15%"/><col width="20%"/><col width="10%"/><col width="10%"/>
	    					<thead>
	    						<th>序号<i class="w_table_split"></i></th>
	    						<th>商品<i class="w_table_split"></i></th>
	    						<th>正/特价<i class="w_table_split"></i></th>
								<th>数量<i class="w_table_split"></th>
								<th>价格<i class="w_table_split"></th>
								<th>金额<i class="w_table_split"></th>
								<th>消费返款金额<i class="w_table_split"></th>
								<th>返款模式<i class="w_table_split"></th>
								<th>消费分摊<i class="w_table_split"></th>
								<th>操作<i class="w_table_split"></th>
	    					</thead>
	    					<tbody>
	    					 <c:forEach items="${shopDetails}" var="d" varStatus="status">
		    					<tr id="${d.id }">
		    						<td>${status.count }</td>
		    						<td>${d.goodsName }</td>
		    						<td><c:if test="${d.goodsType eq 1 }">正价</c:if> <c:if test="${d.goodsType eq 2 }">特价</c:if>  </td>
		    						<td>${d.buyNum }</td>
		    						<td><fmt:formatNumber value="${d.buyPrice }" pattern="0.00" type="number"/></td>
		    						<td><fmt:formatNumber value="${d.buyTotal }" pattern="0.00" type="number"/></td>
		    						<td><fmt:formatNumber value="${d.repayTotal }" pattern="0.00" type="number"/></td>
		    						<td><c:if test="${d.repayType eq 1 }">按销售金额返款</c:if><c:if test="${d.repayType eq 2 }">按销售数量返款</c:if></td>
		    						<td>
		    							<c:if test="${optMap['RESULT'] }">
		    								<a class="blue" href="#" onclick="editDetailDeploy(${shop.groupId },${d.id})">录入</a>
		    							</c:if>
		    							<a class="blue" href="#" onclick="detailDeploy(${shop.groupId },${d.id})">查看</a>
		    						</td>
		    						<td>
			    						<c:if test="${view ne 1 }">
			    							<a class="def" href="toEditShopDetail.htm?id=${d.id }&shopDate=${shop.shopDate}&supplierId=${shop.supplierId}&groupId = ${shop.groupId }">修改</a>
			    							<a href="#" onclick="del(${d.id },${shop.groupId })" class="def">删除</a>
			    						</c:if>
		    						</td>
		    					</tr>
		    				</c:forEach>
		    				</tbody>
	    				</table>
	    			</div>
	    		</dd>
	    		
	    	</dl>
	    	
        </div>
       
    </div>
         
  <div id="deployDiv" style="display: none">
  <div class="p_container">
			<div class="p_container_sub">
  <form class="definewidth m20" id="addDeploy">
	<table class="w_table">
		
			<col width="12%">
			<col width="30%">
			<col width="23%">
			<col width="10%">
			<col width="10%">
			<col width="25%">
	   
	   
	<thead>
		<tr>	
			<th>订单号<i class="w_table_split"></i></th>
			<th>组团社<i class="w_table_split"></i></th>					
			<th>客人名单<i class="w_table_split"></i></th>					
			<th>人数<i class="w_table_split"></i></th>
			<th>购买金额<i class="w_table_split"></i></th>
			<th>备注<i class="w_table_split"></i></th>					
		</tr>
	</thead>
	<tbody id="deployTDid">
		
	
	</tbody>
		
	 
</table>
</form>
</div>
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
				 /*    var jsoninfo = $('#addDeploy').serializeObject();  
			       alert(jsoninfo); */
			     /*   alert("1"); */
					var options = {
						url : "saveDeploy.do",
						type : "post",
						dataType : "json",
						/* data: {deploy:JSON.stringify(jsoninfo)}, */
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

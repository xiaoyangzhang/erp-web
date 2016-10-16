<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
%>
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
	    <form id="saveShopForm" method="post" action="">
	    	<p class="p_paragraph_title"><b>分配购物店</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left">购物店：</div> 
	    			<div class="dd_right">
	    				<input type="hidden" name="id"" value="${shop.id }"/>
	    				<input type="hidden" name="groupId"" value="${groupId }"/>
	    				<input  type="hidden" id="supplierId" name="supplierId"  value="${shop.supplierId }" class="IptText300">
	    				<input onclick="selectSupplier()" type="text" id="supplierName" name="supplierName"  value="${shop.supplierName }" class="IptText300">
	    			</div>
					<div class="clear"></div>
	    		</dd> 
                <dd>
	    			<div class="dd_left">进店日期：</div> 
	    			<div class="dd_right">
	    			<input type="text" readonly="readonly" name="shopDate" id="shopDate" class="Wdate" class="IptText300" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="${shop.shopDate }" />
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<!-- <input type="text" id="guideMobile" name="guide.guideMobile" value="" class="IptText300"> -->
	    					<select name="guideId">
	    						<option value="">请选择</option>
							<c:forEach items="${guides}" var="g">
									<option value="${g.guideId}"  <c:if test="${g.guideId eq shop.guideId }">selected="selected"</c:if>>${g.guideName}</option>
							</c:forEach>
						</select>
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">预计人均消费：</div> 
	    			<div class="dd_right">
	    				<input type="text" id="personBuyAvg" name="personBuyAvg" value="<fmt:formatNumber value='${shop.personBuyAvg }' pattern='#.##' type='number'/>" class="IptText300">
	    					
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    					<textarea rows="5" cols="30" id="remark" name="remark">${shop.remark }</textarea>
	    					
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>
	    <%-- <p class="p_paragraph_title"><b>预定信息：</b>  <a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a></p>
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
            </dl> --%>
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
		    							<input type="text" id="personRepayPrice" name="personRepayPrice"  value="<fmt:formatNumber value="${shop.personRepayPrice }" pattern="#.##" type="number"/>">
		    						</td>
		    						<td>
		    							<input type="text" id="personRepayTotal" name="personRepayTotal" value="<fmt:formatNumber value="${shop.personRepayTotal }" pattern="#.##" type="number"/>" >
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
	    		
	    	</dl> --%>
	    	
	    	
	    	<p class="p_paragraph_title"><b>实际消费返款：</b><c:if test="${view ne 1 }">
	    			<button type="button" id="priceBtn" value="" class="btn_guide_add button button-primary button-small">添加</button></c:if></p>	    	
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="guide_new pl-20 pr-20">
	    			<!-- <form id="repayForm" method="post" action="saveShopDetail.do"> -->
		    							<input type="hidden" name="bookingId" value="${id }" id="bookingId">
		    							<%-- <input type="hidden" name="shopDate" value="${shop.shopDate }" id="shopDate"> --%>
		    							<%-- <input type="hidden" name="supplierId" value="${shop.supplierId }" id="supplierId"> --%>
	    				<table cellspacing="0" cellpadding="0" class="w_table w-1100 tab_guide" id="repayTable">
	    					<col width="10%"/><col width="7%"/><col width="10%"/><col width="10%"/>
	    					<col width="5%"/>
	    					<thead>
	    						<th>商品<i class="w_table_split"></i></th>
	    						
								<th>金额<i class="w_table_split"></th>
								<th>返款比例<i class="w_table_split"></th>
								<th>返款<i class="w_table_split"></th>
								
								<th>操作<i class="w_table_split"></th>
	    					</thead>
	    					<tbody id="priceTblTr">
	    					 <c:forEach items="${shopDetails}" var="d" varStatus="status">
		    					<tr id="${d.id }">
		    						<%-- <td>${status.count }</td> --%>
		    						<td style="text-align: center;">
				    					<%-- <input type="hidden" name="id" value="${d.id }">--%>
				    					<input type="hidden" name="goodsName"  value="${d.goodsName }"> 
				    					<select name="goodsId"
				    						<option value="">请选择</option>
											<c:forEach items="${dic}" var="dd">
												
												<option value="${dd.id}" <c:if test="${d.goodsId eq dd.id }">selected</c:if> >${dd.value}</option>
											</c:forEach>
										</select>
		    						</td>
		    						<%-- <td>${d.buyNum }</td>
		    						<td><fmt:formatNumber value="${d.buyPrice }" pattern="#.##" type="number"/></td> --%>
		    						<td style="text-align: center;"><input  type="text"  name="buyTotal"  value="<fmt:formatNumber value='${d.buyTotal }' pattern='#.##' type='number'/>" class="IptText300"></td>
		    						<td style="text-align: center;"><%-- <c:if test="${d.repayType eq 1 }">按销售金额返款</c:if><c:if test="${d.repayType eq 2 }">按销售数量返款</c:if> --%>
		    							<input  name="repayVal" type="text" value="<fmt:formatNumber value='${d.repayVal }' pattern='#.##' type='number'/>"  />%
		    						</td >
		    						
		    						<td style="text-align: center;"><input name="repayTotal"  type="text" value="<fmt:formatNumber value="${d.repayTotal }" pattern="#.##" type="number"/>" /></td>
</td>
		    						<td style="text-align: center;">
			    						<c:if test="${view ne 1 }">
<%-- 			    							<a class="def" href="toEditShopDetail.htm?id=${d.id }&shopDate=${shop.shopDate}&supplierId=${shop.supplierId}&groupId = ${shop.groupId }">修改</a>
 --%>			    							<a href="#"  name="priceDel" class="def">删除</a>
			    						</c:if>
		    						</td>
		    					</tr>
		    				</c:forEach>
		    				</tbody>
	    				</table>
	    				<div>
			    		</div>
			    		<c:if test="${view ne 1 }">
	    				<button  type="submit" class="button button-primary button-small" id="saveForm">保存</button>
	    				</c:if>
	    				</form>
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
	</tbody>
		
	 
</table>
</form>
</div>
</div>	  			
</div>

</body>
<script type="text/html" id="addShopBack">
	<tr >
		 
		 <td style="text-align: center;">
			<input type="hidden" name="goodsName"  value=""> 
	    		<select name="goodsId" id="goodsId">
	    			<option value="">请选择</option>
						<c:forEach items="${dic}" var="dd">
								
						<option value="${dd.id}" <c:if test="${d.goodsId eq dd.id }">selected</c:if> >${dd.value}</option>
				</c:forEach>
			</select>
		</td>
		 <td style="text-align: center;"><input type="text"  name="buyTotal"  value="0"></td>
		 <td style="text-align: center;">
			<input  name="repayVal" type="text" value="0"  />%
	    	
	    			
		</td>
		 <td style="text-align: center;"><input type="text"  name="repayTotal"  value="0"></td>	    						
		 <td style="text-align: center;">
		<c:if test="${view ne 1 }">
		<a href="#"  name="priceDel" class="def">删除</a>
			</c:if>
		   </td>
	</tr>
</script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript">
var priceData = new Array();
var actualRepays=new Array();
	function addRow(){
		var divHtml = $("#addShopBack").html();
		$("#repayTable tbody").append(divHtml);
	}
	function getRepayDetail(){
		$("#repayTable tbody").find("tr").each(function(){
			var actualRepay={
					bookingId:$("#bookingId").val(),
					goodsId:$(this).find("select option:selected").val(),
					goodsName:$(this).find("input[name='goodsName']").val(),
					buyTotal:$(this).find("input[name='buyTotal']").val(),
					repayTotal:$(this).find("input[name='repayTotal']").val(),
					repayVal:$(this).find("input[name='repayVal']").val()
			};
			actualRepays.push(actualRepay);
		})
	}
	/* $("#saveForm").click(function(){
		getRepayDetail();
		var options={
			type:'post',
			dataType:"json",
			data:{
				shopDetail:JSON.stringify(actualRepays)
			},
			success : function(data) {
				
				if (data.success) {
					$.success('操作成功',function(){
						//window.location.href="toFactShop.htm?id=${shopDetail.bookingId }&groupId=${groupId}";
					});
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
		$("#repayForm").ajaxSubmit(options);
	}) */


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
	<c:if test='${! empty shopDetails }'>
	<c:forEach items="${shopDetails}" var="detail">				
	actualRepays.push({id:${detail.id},goodsId:${detail.goodsId},bookingId:${detail.bookingId},goodsName:'${detail.goodsName}',buyTotal:${detail.buyTotal},repayVal:${detail.repayVal},repayTotal:${detail.repayTotal}});				
	</c:forEach>
</c:if>
	$.ajax({
		type: 'GET',
        url: "<%=ctx%>/booking/contractPriceExt.htm?supplierId="+$('#supplierId').val()+"&date="+$('#shopDate').val(),
        dataType: 'json',
        success: function(data) {
        	priceData = data;		        	
        },
        error: function(data,msg) {	            
        }
	});

	
	
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
	
	/* $("#shop").validate(
			{
				rules:{
					'personRepayPrice' : {
						required : true,
						isDouble:true
					},
					'personNumFact' : {
						required : true,
						isDouble:true
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
	$("#priceBtn").click(function(){
		addRow();
		bindEvent();
	});		
	bindEvent();
	$("#saveShopForm").validate(
			{
				rules:{
					'supplierName' : {
						required : true
					},
					'shopDate':{
						required : true
					},
					'guideId':{
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
					getRepayDetail();
					
					var options = {
						url : "saveShopDetail.do",
						type : "post",
						dataType : "json",
						data:{
							shopDetail:JSON.stringify(actualRepays)
						},
						success : function(data) {
							
							if (data.success) {
								$.success('操作成功',function(){
									//window.location.href="toBookingShopView.htm?groupId=${groupId }&type=1";
								});
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

//  新增
function date_compare(dateStart, dateEnd, dateCompare) {
    var arr = dateStart.split("-"), arr2 = dateEnd.split("-"), arr3 = dateCompare.split("-");
    var timeStart = (new Date(arr[0], arr[1], arr[2])).getTime();
    var timeEnd = (new Date(arr2[0], arr2[1], arr2[2])).getTime();
    var timeCompare = (new Date(arr3[0], arr3[1], arr3[2])).getTime();
    return (timeCompare >= timeStart && timeCompare <= timeEnd); 
}

var type;
var price;
function changeData(obj){
	var d = priceData;
	var vType1 = obj.find("select option:selected").val();//商品

	var exist=false;
	if(d.length>0){
		for (var i = 0; i < d.length&&!exist; i++) {
			if(d[i].itemType == vType1){
				if (date_compare(d[i].startDateStr, d[i].endDateStr, $('#shopDate').val())){
					price = d[i].rebateAmount;
					obj.find("input[name='repayVal']").val(price); 
					exist=true;
				}
				
			}
		}
	}

	
};
function bindEvent(){
	$("#repayTable tbody tr").each(function(){
		var obj=$(this);
		//绑定删除事件
		$(this).find("a[name='priceDel']").unbind("click").bind("click",function(){
			if(!id){
				var rowindex = $(this).closest("#priceTblTr").find("tr").index($(this).closest("tr")[0]);			
				$(this).closest("tr").remove();
				actualRepays.splice(rowindex, 1);
			}
			else{
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
			var rowindex = $(this).closest("#priceTblTr").find("tr").index($(this).closest("tr")[0]);			
			$(this).closest("tr").remove();
			actualRepays.splice(rowindex, 1);
			//$("#sumPrice").html(calcSum());
		}
		})
		//绑定行计算
		var buyTotalObj=$(this).find("input[name='buyTotal']");
		var goodsIdObj=$(this).find("select[name='goodsId']");
		var repayValObj=$(this).find("input[name='repayVal']");
		
		goodsIdObj.removeAttr("onchange").change(function(){	
			changeData(obj);
			obj.find("input[name='goodsName']").val(obj.find("select option:selected").text());
			
		})
		buyTotalObj.removeAttr("onblur").blur(function(){
			var buyTotal = buyTotalObj.val();
			if(buyTotal==''||isNaN(buyTotal)){
				buyTotalObj.val(0);
			}
			
			var repayVal=obj.find("input[name='repayVal']").val();
			var total =new Number(buyTotal*100 * repayVal / 10000);
			//totalPriceObj.val(isNaN(total)? 0:total);
			obj.find("input[name='repayTotal']").val(total);
		})
		repayValObj.removeAttr("onblur").blur(function(){
			var repayVal = repayValObj.val();
			if(repayVal==''||isNaN(repayVal)){
				repayVal.val(0);
			}
			
			var buyTotal=obj.find("input[name='buyTotal']").val();
			var total =new Number(buyTotal*100 * repayVal / 10000);
			//totalPriceObj.val(isNaN(total)? 0:total);
			obj.find("input[name='repayTotal']").val(total);
		})
		
		
		function calcSum(){
			var sum=0;
			//计算总价				
			$("#priceTable tbody tr").find("input[name='totalPrice']").each(function(){
				var total= $(this).val()=='' ? 0:$(this).val();
				sum = (new Number(sum)).add(new Number(isNaN(total) ? 0:total));
			})			
			return sum;
		}
	})
}
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择购物店',
		content : '<%=path%>/component/supplierList.htm?type=single&supplierType=6',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择购物店");
				return false;
			}
			for(var i=0;i<arr.length;i++){
//				console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
				$("#supplierId").val(arr[i].id);
				$("#supplierName").val(arr[i].name);
			}
	    }
	});
}

</script>
</html>

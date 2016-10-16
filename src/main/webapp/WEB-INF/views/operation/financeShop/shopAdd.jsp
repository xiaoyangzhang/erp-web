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

<script type="text/javascript" src="<%=ctx %>/assets/js/utils/float-calculate.js"></script>
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
	    				<input type="hidden" name="id" value="${shop.id }"/>
	    				<input type="hidden" name="groupId" value="${groupId }"/>
	    				<input  type="hidden" id="supplierId" name="supplierId"  value="${shop.supplierId }" class="IptText300">
	    				<input  type="text" id="supplierName" name="supplierName"  value="${shop.supplierName }" class="IptText300">
	    				<c:if test="${view ne 1 }">
	    				<a href="javascript:void(0);" onclick="selectSupplier()" class="button button-primary button-small">请选择</a></c:if>
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
	    				 <input type="hidden" id="guideName" name="guideName" value="" class="IptText300"> 
	    					<select name="guideId" id="guideId">
	    						<option value="">请选择</option>
							<c:forEach items="${guides}" var="g">
									<option value="${g.guideId}"  <c:if test="${g.guideId eq shop.guideId }">selected="selected"</c:if>>${g.guideName}</option>
							</c:forEach>
						</select>
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">司机：</div> 
	    			<div class="dd_right">
	    				 <input type="text" id="driverName" name="driverName" value="${driverName }" class="IptText300" readonly> 
	    				 <input type="hidden" id="driverId" name="driverId" value="${driverId }" class="IptText300"> 
	    					
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">预计人均消费：</div> 
	    			<div class="dd_right">
	    			<c:choose>
	    			<c:when test="${shop.personBuyAvg eq  null }"><input type="text"  name="personBuyAvg" value="0.00" ></c:when>
	    					
	    					<c:otherwise>
	    				<input type="text"  name="personBuyAvg" value="<fmt:formatNumber value='${shop.personBuyAvg }' pattern='#.##' type='number'/>" class="IptText300">
	    					
	    					</c:otherwise>
	    					</c:choose></div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">预计进店人数：</div> 
	    			<div class="dd_right">
	    			<c:choose>
	    			<c:when test="${shop.personNum eq  null }"><input type="text"  name="personNum"  value="${group.totalAdult }" /></c:when>
	    					
	    					<c:otherwise>
	    				<input type="text"  name="personNum"  value="${shop.personNum }">
	    					
	    					</c:otherwise>
	    					</c:choose><i class="gray"><em> 默认为团成人数 </em></i></div>
					<div class="clear"></div>
	    		</dd>
	    		  <dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    				<p>	<textarea rows="5" cols="50" id="remark" name="remark">${shop.remark }</textarea></p>
	    					
	    				</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>
	   
	    	
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
				    					<select name="goodsId">
				    						<option value="">请选择</option>
											<c:forEach items="${dic}" var="dd">
												
												<option value="${dd.id}" <c:if test="${d.goodsId eq dd.id }">selected</c:if> >${dd.itemName}</option>
											</c:forEach>
										</select>
		    						</td>
		    						<%-- <td>${d.buyNum }</td>
		    						<td><fmt:formatNumber value="${d.buyPrice }" pattern="#.##" type="number"/></td> --%>
		    						<td style="text-align: center;"><input oninput="cal(this);"  type="text"  name="buyTotal"  value="<fmt:formatNumber value='${d.buyTotal }' pattern='#.##' type='number'/>" class="IptText300"></td>
		    						<td style="text-align: center;"><%-- <c:if test="${d.repayType eq 1 }">按销售金额返款</c:if><c:if test="${d.repayType eq 2 }">按销售数量返款</c:if> --%>
		    							<input  name="repayVal" type="text" value="<fmt:formatNumber value='${d.repayVal }' pattern='#.##' type='number'/>" readonly  />%
		    						</td >
		    						
		    						<td style="text-align: center;"><input name="repayTotal"  type="text" value="<fmt:formatNumber value="${d.repayTotal }" pattern="#.##" type="number"/>" readonly /></td>
</td>
		    						<td style="text-align: center;">
			    						<c:if test="${view ne 1 }">
			    							<a href="#"  name="priceDel" class="def">删除</a>
			    						</c:if>
		    						</td>
		    					</tr>
		    					<c:set var="sum_price" value="${sum_price+d.buyTotal}" />
		    					<c:set var="sum_repay" value="${sum_repay+d.repayTotal}" />
		    				</c:forEach>
		    				</tbody>
		    				<tbody>
		    				<tr id="sumTotal">
		    					<td >合计</td>
		    					<td id="sumPrice"><fmt:formatNumber value='${ sum_price}' pattern='#.##' type='number'/></td>
		    					<td ></td>
		    					<td id="sumRepay"><fmt:formatNumber value='${ sum_repay}' pattern='#.##' type='number'/></td>
		    					<td ></td>
		    				</tr>
		    				</tbody>
	    				</table>
	    				<div>
			    		</div>
			    		<c:if test="${view ne 1 }">
	    				<button  type="submit" class="button button-primary button-small" id="saveForm">保存</button>
	    				</c:if>
	    				<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
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
<div id="groupDetail"></div>
</body>
<script type="text/html" id="addShopBack">
	<tr >
		 
		 <td style="text-align: center;">
			<input type="hidden" name="goodsName"  value=""> 
	    		<select name="goodsId" >
	    		<option value="">请选择</option>
				
			</select>
		</td>
		 <td style="text-align: center;"><input type="text" oninput="cal(this);"  name="buyTotal"  value="0"></td>
		 <td style="text-align: center;">
			<input  name="repayVal" type="text" value="0" readonly />%
	    	
	    			
		</td>
		 <td style="text-align: center;"><input type="text"  name="repayTotal"  readonly value="0"></td>	    						
		 <td style="text-align: center;">
		<c:if test="${view ne 1 }">
		<a href="#"  name="priceDel" class="def">删除</a>
			</c:if>
		   </td>
	</tr>
</script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript">
//if($("#supplierId").val()){
//	selectItems();
//}

function cal(obj){
	var fin = $(obj).parent().parent();
	var a = fin.find("input[name='buyTotal']").val()
	var b = fin.find("input[name='repayVal']").val()*0.01;
	fin.find("input[name='repayTotal']").val(a*b);
}



var priceData = new Array();
var actualRepays=new Array();
	function addRow(){
		if(!$("input[name='supplierId']").val()){
			$.warn("请先选择购物店");
		}else{
		var divHtml = $("#addShopBack").html();
		$("#sumTotal").before(divHtml);
		$.ajax({
	         type: "post",
	         cache: false,
	         url: "<%=ctx%>/booking/selectItems.htm",
	         data: {
	        	 supplierId:$("#supplierId").val()
	         },
	         dataType: 'json',
	         async: false,
	         success: function (data) {
	        	 for (var i = 0; i < data.length; i++) {
	        		 var item = data[i];
	        	$("#repayTable tbody tr").eq(-2).find("select[name='goodsId']").append('<option value="'+item.id+'" >'+item.itemName+'</option>');
 	 }
 		 
  }
}); 
		}
		
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
			if(actualRepay.goodsId){
			actualRepays.push(actualRepay);}
		})
	}
	


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
	
$("#groupDetail").load("<%=staticPath%>/booking/groupDetail.htm?gid=${groupId}&flag=1");
	<%-- $.ajax({
		type: 'GET',
        url: "<%=ctx%>/booking/contractPriceExt.htm?supplierId="+$('#supplierId').val()+"&date="+$('#shopDate').val(),
        dataType: 'json',
        success: function(data) {
        	priceData = data;		        	
        },
        error: function(data,msg) {	            
        }
	});
 --%>
	
	
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
	
	
	$("#priceBtn").click(function(){
		addRow();
		bindEvent();
	});		
	bindEvent();
	$("#guideId").removeAttr("onchange").change(function(){
		$("#guideName").val($("#guideId option:selected").text());
		$.ajax({
			
			url:"getMatchedDriver.htm",
			type : "post",
			async : false,
			data : {
				guideId:$("#guideId").val(),
				groupId:$("#groupId").val()
			},
			dataType : "json",
			success : function(data) {
				if (data.sucess) {
					$("#driverId").val(data['driverId']);
					$("#driverName").val(data['driverName']);
				}else{
					$.warn(data.msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				//window.location = window.location;
			}
		});
		
		
	})
	
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
							
							if (data.sucess) {
								$.success('操作成功',function(){
									//$("#saveForm").attr("disabled","disabled");
									//window.location.href="toBookingShopView.htm?groupId=${groupId }&type=1";
									refreshWindow("修改购物",
											'<%=path %>/bookingFinanceShop/toFactShop.htm?id='+data['id']+'&groupId=${groupId}');
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
					jQuery.ajax({
						url : "../tourGroup/validatorSupplier.htm",
						type : "post",
						async : false,
						data : {
							"supplierId" : $("#supplierId").val(),
							"supplierName":$("#supplierName").val()
						},
						dataType : "json",
						success : function(data) {
							if (data.success) {
								//$.success("操作成功");
								$(form).ajaxSubmit(options);
							}else{
								$.warn(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus, errorThrown) {
							$.error(textStatus);
							window.location = window.location;
						}
					});
					
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
				var rowindex = $(this).closest("#priceTblTr").find("tr").index($(this).closest("tr")[0]);			
				$(this).closest("tr").remove();
				actualRepays.splice(rowindex, 1);
				if($("#repayTable tbody tr").length<2){
					$("#sumPrice").html(0);
					$("#sumRepay").html(0);
					
				}
			
		})
		//绑定行计算
		var buyTotalObj=$(this).find("input[name='buyTotal']");
		var goodsIdObj=$(this).find("select[name='goodsId']");
		var repayValObj=$(this).find("input[name='repayVal']");
		goodsIdObj.removeAttr("onchange").change(function(){	
			
			obj.find("input[name='goodsName']").val(obj.find("select option:selected").text());
			$.ajax({
				type: 'GET',
		        url: "<%=ctx%>/booking/contractPriceExt.htm?supplierId="+$('#supplierId').val()+"&goodsId="+goodsIdObj.val()+"&date="+$('#shopDate').val(),
		        dataType: 'json',
		        success: function(data) {
		        	priceData = data;	
		        	changeData(obj);
		        	//重新计算返款
		        	cal(goodsIdObj);
		        	//重新计算合计
		        	$("#sumPrice").html(calcSumPrice());
					$("#sumRepay").html(calcSumRepay());
		        },
		        error: function(data,msg) {	            
		        }
			});

			
		})
		buyTotalObj.removeAttr("onblur").blur(function(){
			var buyTotal = buyTotalObj.val();
			if(buyTotal==''||isNaN(buyTotal)){
				buyTotalObj.val(0);
			}
			var repayVal=obj.find("input[name='repayVal']").val();
			var total =new Number(buyTotal*100 * repayVal / 10000);
			obj.find("input[name='repayTotal']").val(isNaN(total)? 0:total);
			$("#sumPrice").html(calcSumPrice());
			$("#sumRepay").html(calcSumRepay());
		})
		repayValObj.removeAttr("onblur").blur(function(){
			var repayVal = repayValObj.val();
			if(repayVal==''||isNaN(repayVal)){
				repayValObj.val(0);
			}
			
			var buyTotal=obj.find("input[name='buyTotal']").val();
			var total =new Number(buyTotal*100 * repayVal / 10000);
			obj.find("input[name='repayTotal']").val(isNaN(total)? 0:total);
			$("#sumRepay").html(calcSumRepay());
		})
		
		
		function calcSumPrice(){
			var sum1=0;
			//计算总价				
			$("#repayTable tbody tr").find("input[name='buyTotal']").each(function(){
				var totalPrice= $(this).val()=='' ? 0:$(this).val();
				sum1 = (new Number(sum1)).add(new Number(isNaN(totalPrice) ? 0:totalPrice));
			})			
			return sum1;
		}
		function calcSumRepay(){
			var sum2=0;
			//计算总价				
			$("#repayTable tbody tr").find("input[name='repayTotal']").each(function(){
				var totalRepay= $(this).val()=='' ? 0:$(this).val();
				sum2 = (new Number(sum2)).add(new Number(isNaN(totalRepay) ? 0:totalRepay));
			})			
			return sum2;
		}
	})
}
function selectSupplier(){
	layer.openSupplierLayer({
		title : '选择购物店',
		content : '<%=ctx%>/component/supplierList.htm?type=single&supplierType=6',
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选择购物店");
				return false;
			}
				$("#supplierId").val(arr[0].id);
				$("#supplierName").val(arr[0].name);
				selectItems();
		
	    }
	});
}
function selectItems(){
	var goodsObj=$("select[name='goodsId']");
	if(goodsObj!=null&&goodsObj.length>0){
	goodsObj.empty();
	goodsObj.each(function(){
		$(this).append("<option value='' selected>请选择</option>")
	})
	
	
	}
	$.ajax({
        type: "post",
        cache: false,
        url: "<%=ctx%>/booking/selectItems.htm",
        data: {
       	 supplierId:$("#supplierId").val()
        },
        dataType: 'json',
        async: false,
        success: function (data) {
       	 for (var i = 0; i < data.length; i++) {
       		 var item = data[i];
       		 
       		 goodsObj.append('<option value="'+item.id+'" >'+item.itemName+'</option>');
}
	 
}
}); 
}
</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
     $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=6", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
    	selectItems();
    }  
</script>
</html>

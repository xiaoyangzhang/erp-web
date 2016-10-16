<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>

</head>
<body>
	<div class="p_container">
		<div class="p_container_sub">
			<form id="initGroupForm" method="post">
				
				<dl class="p_paragraph_content">
					<input type="hidden" name="tourGroup.id" value="${tourGroup.id }" />
					<input type="hidden" name="tourGroup.groupMode" value="-2" />
					<input type="hidden" name="groupOrder.orderType" value="-2" />
					<dd>
						<div class="dd_left">团号：</div>
						<div class="dd_right">
							<input name="tourGroup.groupCode" value="${tourGroup.groupCode}" class="IptText300" type="text">
						</div>
						<div class="dd_left">开始日期:</div>
						<div class="dd_right">
							<input type="text" name="tourGroup.dateStart"
								value='<fmt:formatDate value="${tourGroup.dateStart}" pattern="yyyy-MM-dd"/>'
								class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</div>
						
		    			<div class="dd_left">团计调:</div>
		    			<div class="dd_right">
		    				<input type="text" name="tourGroup.operatorName" id="operator_name" value="${tourGroup.operatorName}" readonly="readonly"/>
							<input name="tourGroup.operatorId" id="operator_id" value="" type="hidden" value="${tourGroup.operatorId}"/> 
		    				<a href="javascript:void(0);" onclick="selectUserMuti()" > 请选择</a>
							<a href="javascript:void(0);" onclick="multiReset()" >重置</a>
		    			</div>
						<div class="clear"></div>
					</dd>
					<!-- 组团社 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">组团社<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupPrice();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupData">
									<c:forEach items="${orderList}" var="groupOrder" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="groupOrderList[${index.index}].id" value="${groupOrder.id }"/>
											<input type="hidden" name="groupOrderList[${index.index}].groupId" value="${groupOrder.groupId}" /> 
											<input type="hidden" name="groupOrderList[${index.index}].orderType" value="-2" />
										</td>
										<td>
											<input type="hidden" name="groupOrderList[${index.index}].supplierId" value="${groupOrder.supplierId }"/>
											<input type="text" style="width: 500px" name="groupOrderList[${index.index}].supplierName" value="${groupOrder.supplierName }" onfocus="getComplete(${index.index})"/>
										</td>
										<td>
											<input type="text" name="groupOrderList[${index.index}].total" value="<fmt:formatNumber value='${groupOrder.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupTable(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					<!-- 地接社 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">地接社<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupDeliveryPrice();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupDeliveryData">
									<c:forEach items="${bookingDeliveryList}" var="delivery" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="deliveryList[${index.index}].id" value="${delivery.id }"/>
											<input type="hidden" name="deliveryList[${index.index}].groupId" value="${delivery.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="deliveryList[${index.index}].supplierId" value="${delivery.supplierId }"/>
											<input type="text" style="width: 500px" name="deliveryList[${index.index}].supplierName" value="${delivery.supplierName }" onfocus="getDeliveryComplete(${index.index})"/>
										</td>
										<td>
											<input type="text" name="deliveryList[${index.index}].total" value="<fmt:formatNumber value='${delivery.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupDeliveryTable(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 酒店 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">酒店<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData">
									<c:forEach items="${hotelList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="hotelList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="hotelList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="hotelList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="hotelList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete(${index.index})"/>
										</td>
										<td>
											<input type="text" name="hotelList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 餐 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">餐厅<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice2();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData2">
									<c:forEach items="${restaurantList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="restaurantList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="restaurantList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="restaurantList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="restaurantList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete2(${index.index})"/>
										</td>
										<td>
											<input type="text" name="restaurantList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable2(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 车队 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">车队<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice3();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData3">
									<c:forEach items="${fleetList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="fleetList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="fleetList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="fleetList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="fleetList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete3(${index.index})"/>
										</td>
										<td>
											<input type="text" name="fleetList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable3(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 景点 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">景点<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice4();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData4">
									<c:forEach items="${scenicsportList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="scenicsportList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="scenicsportList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="scenicsportList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="scenicsportList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete4(${index.index})"/>
										</td>
										<td>
											<input type="text" name="scenicsportList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable4(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 保险 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">保险<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice5();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData5">
									<c:forEach items="${insuranceList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="insuranceList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="insuranceList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="insuranceList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="insuranceList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete5(${index.index})"/>
										</td>
										<td>
											<input type="text" name="insuranceList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable5(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 机票 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">机票<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice6();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData6">
									<c:forEach items="${airticketList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="airticketList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="airticketList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="airticketList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="airticketList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete6(${index.index})"/>
										</td>
										<td>
											<input type="text" name="airticketList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable6(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<!-- 火车 -->
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width:70%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="60%">火车<i class="w_table_split"></i></th>
										<th width="10%">期初金额<i class="w_table_split"></i></th>
										<th width="10%"><a href="javascript:;" onclick="addInitGroupHotelPrice7();" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newInitGroupHotelData7">
									<c:forEach items="${trainList}" var="hotel" varStatus="index">
									<tr>
										<td>
											${index.count}
											<input type="hidden" name="trainList[${index.index}].id" value="${hotel.id }"/>
											<input type="hidden" name="trainList[${index.index}].groupId" value="${hotel.groupId}" /> 
										</td>
										<td>
											<input type="hidden" name="trainList[${index.index}].supplierId" value="${hotel.supplierId }"/>
											<input type="text" style="width: 500px" name="trainList[${index.index}].supplierName" value="${hotel.supplierName }" onfocus="getHotelComplete7(${index.index})"/>
										</td>
										<td>
											<input type="text" name="trainList[${index.index}].total" value="<fmt:formatNumber value='${hotel.total}' type='currency' pattern='#.##' />" />
										</td>
										<td>
											<a href="javascript:void(0);" onclick="delInitGroupHotelTable7(this)">删除</a>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="clear"></div>
					</dd>
					
					<div class="Footer" style="text-align: center;margin-right:300px">
							<button type="submit" class="button button-primary button-small">保存</button>
							<button onclick="closeWindow();" class="button button-primary button-small">关闭</button>
					</div>
				</dl>
			</form>
		</div>
	</div>
</body>
</html>
<script type="text/javascript">
var eKeyDown = $.Event('keydown');
eKeyDown.keyCode = 40; // DOWN
//组团社
var supplierNameComplete={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 1,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getComplete =function(index){
	supplierNameComplete.select = function(event, v){
		$("input[name='groupOrderList["+index+"].supplierName']").val(v.item.label);
		$("input[name='groupOrderList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='groupOrderList["+index+"].supplierName']").autocomplete(supplierNameComplete);
	$("input[name='groupOrderList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupPrice= function(){
	var html = $("#initGroup_template").html();
	var count = $("#newInitGroupData").children('tr').length;
	html = template('initGroup_template', {index : count});
	$("#newInitGroupData").append(html);
	
	
	supplierNameComplete.select = function(event, v){
		$("input[name='groupOrderList["+count+"].supplierName']").val(v.item.label);
		$("input[name='groupOrderList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='groupOrderList["+count+"].supplierName']").autocomplete(supplierNameComplete);
	$("input[name='groupOrderList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='groupOrderList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择组团社'}});
	}
	
	var init_supplierName =  $("input[name='groupOrderList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='groupOrderList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}
var delInitGroupTable = function(el){
  	var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='groupOrderList']");
        founds.each(function(){
            $(this).attr('name', $(this).attr('name').replace(/groupOrderList\[\d+]/g, 'groupOrderList[' + index + ']'));
        	supplierNameComplete.select = function(event, v){
        		$("input[name='groupOrderList["+index+"].supplierName']").val(v.item.label);
        		$("input[name='groupOrderList["+index+"].supplierId']").val(v.item.id);
        	};
        	$("input[name='groupOrderList["+index+"].supplierName']").autocomplete(supplierNameComplete);
        	$("input[name='groupOrderList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
            
        });
    });
}

//地接社
var deliveryNameComplete={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 16,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getDeliveryComplete =function(index){
	deliveryNameComplete.select = function(event, v){
		$("input[name='deliveryList["+index+"].supplierName']").val(v.item.label);
		$("input[name='deliveryList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='deliveryList["+index+"].supplierName']").autocomplete(deliveryNameComplete);
	$("input[name='deliveryList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupDeliveryPrice= function(){
	var html = $("#initGroupDelivery_template").html();
	var count = $("#newInitGroupDeliveryData").children('tr').length;
	html = template('initGroupDelivery_template', {index : count});
	$("#newInitGroupDeliveryData").append(html);
	
	
	deliveryNameComplete.select = function(event, v){
		$("input[name='deliveryList["+count+"].supplierName']").val(v.item.label);
		$("input[name='deliveryList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='deliveryList["+count+"].supplierName']").autocomplete(deliveryNameComplete);
	$("input[name='deliveryList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='deliveryList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择地接社'}});
	}
	
	var init_supplierName =  $("input[name='deliveryList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='deliveryList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupDeliveryTable = function(el){
	var p = $(el).parent('td').parent('tr');
  var siblings = p.siblings();
  p.remove();
  siblings.each(function(index, element){
      var founds = $(element).find("[name^='deliveryList']");
      founds.each(function(){
          $(this).attr('name', $(this).attr('name').replace(/deliveryList\[\d+]/g, 'deliveryList[' + index + ']'));
      	deliveryNameComplete.select = function(event, v){
      		$("input[name='deliveryList["+index+"].supplierName']").val(v.item.label);
      		$("input[name='deliveryList["+index+"].supplierId']").val(v.item.id);
      	};
      	$("input[name='deliveryList["+index+"].supplierName']").autocomplete(deliveryNameComplete);
      	$("input[name='deliveryList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
          
      });
  });
}


//酒店
var hotelNameComplete={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 3,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete =function(index){
	hotelNameComplete.select = function(event, v){
		$("input[name='hotelList["+index+"].supplierName']").val(v.item.label);
		$("input[name='hotelList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='hotelList["+index+"].supplierName']").autocomplete(hotelNameComplete);
	$("input[name='hotelList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice= function(){
	var html = $("#initGroupHotel_template").html();
	var count = $("#newInitGroupHotelData").children('tr').length;
	html = template('initGroupHotel_template', {index : count});
	$("#newInitGroupHotelData").append(html);
	
	
	hotelNameComplete.select = function(event, v){
		$("input[name='hotelList["+count+"].supplierName']").val(v.item.label);
		$("input[name='hotelList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='hotelList["+count+"].supplierName']").autocomplete(hotelNameComplete);
	$("input[name='hotelList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='hotelList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择酒店'}});
	}
	
	var init_supplierName =  $("input[name='hotelList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='hotelList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable = function(el){
	var p = $(el).parent('td').parent('tr');
  var siblings = p.siblings();
  p.remove();
  siblings.each(function(index, element){
      var founds = $(element).find("[name^='hotelList']");
      founds.each(function(){
          $(this).attr('name', $(this).attr('name').replace(/hotelList\[\d+]/g, 'hotelList[' + index + ']'));
      	hotelNameComplete.select = function(event, v){
      		$("input[name='hotelList["+index+"].supplierName']").val(v.item.label);
      		$("input[name='hotelList["+index+"].supplierId']").val(v.item.id);
      	};
      	$("input[name='hotelList["+index+"].supplierName']").autocomplete(hotelNameComplete);
      	$("input[name='hotelList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
          
      });
  });
}

//餐
var hotelNameComplete2={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 2,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete2 =function(index){
	hotelNameComplete2.select = function(event, v){
		$("input[name='restaurantList["+index+"].supplierName']").val(v.item.label);
		$("input[name='restaurantList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='restaurantList["+index+"].supplierName']").autocomplete(hotelNameComplete2);
	$("input[name='restaurantList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice2= function(){
	var html = $("#initGroupHotel_template2").html();
	var count = $("#newInitGroupHotelData2").children('tr').length;
	html = template('initGroupHotel_template2', {index : count});
	$("#newInitGroupHotelData2").append(html);
	
	
	hotelNameComplete2.select = function(event, v){
		$("input[name='restaurantList["+count+"].supplierName']").val(v.item.label);
		$("input[name='restaurantList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='restaurantList["+count+"].supplierName']").autocomplete(hotelNameComplete2);
	$("input[name='restaurantList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='restaurantList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择餐厅'}});
	}
	
	var init_supplierName =  $("input[name='restaurantList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='restaurantList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable2 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='restaurantList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/restaurantList\[\d+]/g, 'restaurantList[' + index + ']'));
    	hotelNameComplete2.select = function(event, v){
    		$("input[name='restaurantList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='restaurantList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='restaurantList["+index+"].supplierName']").autocomplete(hotelNameComplete2);
    	$("input[name='restaurantList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}

//车队
var hotelNameComplete3={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 4,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete3 =function(index){
	hotelNameComplete3.select = function(event, v){
		$("input[name='fleetList["+index+"].supplierName']").val(v.item.label);
		$("input[name='fleetList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='fleetList["+index+"].supplierName']").autocomplete(hotelNameComplete3);
	$("input[name='fleetList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice3= function(){
	var html = $("#initGroupHotel_template3").html();
	var count = $("#newInitGroupHotelData3").children('tr').length;
	html = template('initGroupHotel_template3', {index : count});
	$("#newInitGroupHotelData3").append(html);
	
	
	hotelNameComplete3.select = function(event, v){
		$("input[name='fleetList["+count+"].supplierName']").val(v.item.label);
		$("input[name='fleetList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='fleetList["+count+"].supplierName']").autocomplete(hotelNameComplete3);
	$("input[name='fleetList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='fleetList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择车队'}});
	}
	
	var init_supplierName =  $("input[name='fleetList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='fleetList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable3 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='fleetList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/fleetList\[\d+]/g, 'fleetList[' + index + ']'));
    	hotelNameComplete3.select = function(event, v){
    		$("input[name='fleetList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='fleetList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='fleetList["+index+"].supplierName']").autocomplete(hotelNameComplete3);
    	$("input[name='fleetList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}

//景点
var hotelNameComplete4={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 5,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete4 =function(index){
	hotelNameComplete4.select = function(event, v){
		$("input[name='scenicsportList["+index+"].supplierName']").val(v.item.label);
		$("input[name='scenicsportList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='scenicsportList["+index+"].supplierName']").autocomplete(hotelNameComplete4);
	$("input[name='scenicsportList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice4= function(){
	var html = $("#initGroupHotel_template4").html();
	var count = $("#newInitGroupHotelData4").children('tr').length;
	html = template('initGroupHotel_template4', {index : count});
	$("#newInitGroupHotelData4").append(html);
	
	
	hotelNameComplete4.select = function(event, v){
		$("input[name='scenicsportList["+count+"].supplierName']").val(v.item.label);
		$("input[name='scenicsportList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='scenicsportList["+count+"].supplierName']").autocomplete(hotelNameComplete4);
	$("input[name='scenicsportList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='scenicsportList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择景区'}});
	}
	
	var init_supplierName =  $("input[name='scenicsportList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='scenicsportList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable4 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='scenicsportList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/scenicsportList\[\d+]/g, 'scenicsportList[' + index + ']'));
    	hotelNameComplete4.select = function(event, v){
    		$("input[name='scenicsportList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='scenicsportList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='scenicsportList["+index+"].supplierName']").autocomplete(hotelNameComplete4);
    	$("input[name='scenicsportList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}

//保险
var hotelNameComplete5={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 15,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete5 =function(index){
	hotelNameComplete5.select = function(event, v){
		$("input[name='insuranceList["+index+"].supplierName']").val(v.item.label);
		$("input[name='insuranceList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='insuranceList["+index+"].supplierName']").autocomplete(hotelNameComplete5);
	$("input[name='insuranceList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice5= function(){
	var html = $("#initGroupHotel_template5").html();
	var count = $("#newInitGroupHotelData5").children('tr').length;
	html = template('initGroupHotel_template5', {index : count});
	$("#newInitGroupHotelData5").append(html);
	
	
	hotelNameComplete5.select = function(event, v){
		$("input[name='insuranceList["+count+"].supplierName']").val(v.item.label);
		$("input[name='insuranceList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='insuranceList["+count+"].supplierName']").autocomplete(hotelNameComplete5);
	$("input[name='insuranceList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='insuranceList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择保险'}});
	}
	
	var init_supplierName =  $("input[name='insuranceList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='insuranceList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable5 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='insuranceList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/insuranceList\[\d+]/g, 'insuranceList[' + index + ']'));
    	hotelNameComplete5.select = function(event, v){
    		$("input[name='insuranceList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='insuranceList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='insuranceList["+index+"].supplierName']").autocomplete(hotelNameComplete5);
    	$("input[name='insuranceList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}

//机票
var hotelNameComplete6={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 9,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete6 =function(index){
	hotelNameComplete6.select = function(event, v){
		$("input[name='airticketList["+index+"].supplierName']").val(v.item.label);
		$("input[name='airticketList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='airticketList["+index+"].supplierName']").autocomplete(hotelNameComplete6);
	$("input[name='airticketList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice6= function(){
	var html = $("#initGroupHotel_template6").html();
	var count = $("#newInitGroupHotelData6").children('tr').length;
	html = template('initGroupHotel_template6', {index : count});
	$("#newInitGroupHotelData6").append(html);
	
	
	hotelNameComplete6.select = function(event, v){
		$("input[name='airticketList["+count+"].supplierName']").val(v.item.label);
		$("input[name='airticketList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='airticketList["+count+"].supplierName']").autocomplete(hotelNameComplete6);
	$("input[name='airticketList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='airticketList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择机票'}});
	}
	
	var init_supplierName =  $("input[name='airticketList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='airticketList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable6 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='airticketList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/airticketList\[\d+]/g, 'airticketList[' + index + ']'));
    	hotelNameComplete6.select = function(event, v){
    		$("input[name='airticketList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='airticketList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='airticketList["+index+"].supplierName']").autocomplete(hotelNameComplete6);
    	$("input[name='airticketList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}

//火车票
var hotelNameComplete7={
		  source: function( request, response ) {
			  var keyword = request.term;
			  $.ajax({
				  type : "post",
				  url : "../tourGroup/getSupplierName",
				  data : {
					  supplierType : 10,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.nameFull,id:v.id};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
var getHotelComplete7 =function(index){
	hotelNameComplete7.select = function(event, v){
		$("input[name='trainList["+index+"].supplierName']").val(v.item.label);
		$("input[name='trainList["+index+"].supplierId']").val(v.item.id);
	};
	$("input[name='trainList["+index+"].supplierName']").autocomplete(hotelNameComplete7);
	$("input[name='trainList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
}
	
var addInitGroupHotelPrice7= function(){
	var html = $("#initGroupHotel_template7").html();
	var count = $("#newInitGroupHotelData7").children('tr').length;
	html = template('initGroupHotel_template7', {index : count});
	$("#newInitGroupHotelData7").append(html);
	
	
	hotelNameComplete7.select = function(event, v){
		$("input[name='trainList["+count+"].supplierName']").val(v.item.label);
		$("input[name='trainList["+count+"].supplierId']").val(v.item.id);
	};
	$("input[name='trainList["+count+"].supplierName']").autocomplete(hotelNameComplete7);
	$("input[name='trainList["+count+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
	
	
	var init_supplierId =  $("input[name='trainList["+count+"].supplierId']");
	if(init_supplierId.length > 0){
		init_supplierId.rules("add",{required : true, messages: {required:'请在下拉框中选择火车票'}});
	}
	
	var init_supplierName =  $("input[name='trainList["+count+"].supplierName']");
	if(init_supplierName.length > 0){
		init_supplierName.rules("add",{required : true});
	}
	
	var init_total =  $("input[name='trainList["+count+"].total']");
	if(init_total.length  > 0){
		init_total.rules("add",{required : true,number : true});
	}
	
}

var delInitGroupHotelTable7 = function(el){
	var p = $(el).parent('td').parent('tr');
var siblings = p.siblings();
p.remove();
siblings.each(function(index, element){
    var founds = $(element).find("[name^='trainList']");
    founds.each(function(){
        $(this).attr('name', $(this).attr('name').replace(/trainList\[\d+]/g, 'trainList[' + index + ']'));
    	hotelNameComplete7.select = function(event, v){
    		$("input[name='trainList["+index+"].supplierName']").val(v.item.label);
    		$("input[name='trainList["+index+"].supplierId']").val(v.item.id);
    	};
    	$("input[name='trainList["+index+"].supplierName']").autocomplete(hotelNameComplete7);
    	$("input[name='trainList["+index+"].supplierName']").click(function(){$(this).trigger(eKeyDown);});
        
    });
});
}





//提交
$(function(){
	$("#initGroupForm").validate(
			{
				rules:{
					'tourGroup.groupCode':{
						required : true
					},
					'tourGroup.dateStart':{
						required : true
					},
					'tourGroup.operatorName':{
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
						url : '../initGroup/saveInitGroupInfo.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									closeWindow();
								});
								
							} else {
								$.warn(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
})

	/**
	 * 页面选择部分调用函数(多选)
	 */
	function selectUserMuti(num){
		var width = window.screen.width ;
		var height = window.screen.height ;
		var wh = (width/1920*650).toFixed(0) ;
		var hh = (height/1080*500).toFixed(0) ;
		wh = wh+"px" ;
		hh = hh+"px" ;
		var lh = (width/1920*400).toFixed(0) ;
		var th = (height/1080*100).toFixed(0) ;
		lh = lh+"px" ;
		th = th+"px" ;
		var win=0;
		layer.open({ 
			type : 2,
			title : '选择人员',
			shadeClose : true,
			shade : 0.5,
			offset : [th,lh],
			area : [wh,hh],
			content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var userArr = win.getUserList();   
				
				$("#operator_id").val("");
				$("#operator_name").val("");
				for(var i=0;i<userArr.length;i++){
					console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
					if(i==userArr.length-1){
						$("#operator_name").val($("#operator_name").val()+userArr[i].name);
						$("#operator_id").val($("#operator_id").val()+userArr[i].id);
					}else{
						$("#operator_name").val($("#operator_name").val()+userArr[i].name+",");
						$("#operator_id").val($("#operator_id").val()+userArr[i].id+",");
					}
				}
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}

	/**
	 * 重置查询条件
	 */
	function multiReset(){
		$("#operator_name").val("");
		$("#operator_id").val("");
		
	}	
</script>
<script type="text/html" id="initGroup_template">
	<tr>
		<td>
			<input type="hidden" name="groupOrderList[{{index}}].id"/>
			<input type="hidden" name="groupOrderList[{{index}}].groupId" value="${tourGroup.id}" /> 
			<input type="hidden" name="groupOrderList[{{index}}].orderType" value="-2" />
		</td>
		<td>
			<input type="hidden" name="groupOrderList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="groupOrderList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="groupOrderList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupTable(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupDelivery_template">
	<tr>
		<td>
			<input type="hidden" name="deliveryList[{{index}}].id"/>
			<input type="hidden" name="deliveryList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="deliveryList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="deliveryList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="deliveryList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupDeliveryTable(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template">
	<tr>
		<td>
			<input type="hidden" name="hotelList[{{index}}].id"/>
			<input type="hidden" name="hotelList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="hotelList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="hotelList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="hotelList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template2">
	<tr>
		<td>
			<input type="hidden" name="restaurantList[{{index}}].id"/>
			<input type="hidden" name="restaurantList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="restaurantList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="restaurantList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="restaurantList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable2(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template3">
	<tr>
		<td>
			<input type="hidden" name="fleetList[{{index}}].id"/>
			<input type="hidden" name="fleetList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="fleetList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="fleetList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="fleetList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable3(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template4">
	<tr>
		<td>
			<input type="hidden" name="scenicsportList[{{index}}].id"/>
			<input type="hidden" name="scenicsportList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="scenicsportList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="scenicsportList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="scenicsportList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable4(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template5">
	<tr>
		<td>
			<input type="hidden" name="insuranceList[{{index}}].id"/>
			<input type="hidden" name="insuranceList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="insuranceList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="insuranceList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="insuranceList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable5(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template6">
	<tr>
		<td>
			<input type="hidden" name="airticketList[{{index}}].id"/>
			<input type="hidden" name="airticketList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="airticketList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="airticketList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="airticketList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable6(this)">删除</a>
		</td>
	</tr>
</script>

<script type="text/html" id="initGroupHotel_template7">
	<tr>
		<td>
			<input type="hidden" name="trainList[{{index}}].id"/>
			<input type="hidden" name="trainList[{{index}}].groupId" value="${tourGroup.id}" /> 
		</td>
		<td>
			<input type="hidden" name="trainList[{{index}}].supplierId"/>
			<input type="text" style="width: 500px" name="trainList[{{index}}].supplierName"/>
		<td>
			<input type="text" name="trainList[{{index}}].total" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="delInitGroupHotelTable7(this)">删除</a>
		</td>
	</tr>
</script>
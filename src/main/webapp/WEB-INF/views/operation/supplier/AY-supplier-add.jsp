<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增安排</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../include/top.jsp"%>
</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<form id="bookingForm" action="">
	    	<input type="hidden" name="groupId" id="groupId" value="${groupId }" />
	    	<input type="hidden" name="orderId" id="orderId" value="${orderId }" />
				<input type="hidden" name="bookingId" id="bookingId" value="${supplier.id }" />
				<input type="hidden" name="stateFinance" id="stateFinance" value="${supplier.stateFinance }" />
				<input type="hidden" name="stateBooking" id="stateBooking" value="${supplier.stateBooking }" />
				<input type="hidden" name="flag" id="flag" value="${flag}" />
				<input type="hidden" name="subType" id="subType" value="${supplier.subType }" />
	    	<p class="p_paragraph_title"><b>预定安排信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    		<div class="dd_left"><i class="red">* </i>商家类别：</div> 
	    			<div class="dd_right">
	    			<select name="supplierType" id="supplierType">
	    			<option value="3" <c:if test="${supplier.supplierType==3}">selected="selected"</c:if>>酒店</option>
	    			<option value="2" <c:if test="${supplier.supplierType==2}">selected="selected"</c:if>>餐厅</option>
	    			<option value="5" <c:if test="${supplier.supplierType==5}">selected="selected"</c:if>>景区</option>
	    			<option value="9" <c:if test="${supplier.supplierType==9}">selected="selected"</c:if>>机票</option>
	    			<option value="15" <c:if test="${supplier.supplierType==15}">selected="selected"</c:if>>保险</option>
	    			<option value="120" <c:if test="${supplier.supplierType==120}">selected="selected"</c:if>>其他收入</option>
	    			<option value="121" <c:if test="${supplier.supplierType==121}">selected="selected"</c:if>>其他支出</option>
	    			</select></div>
					<div class="clear"></div>
	    		</dd>	    		
	    			
	    			
	    			<div class="dd_left"><i class="red">* </i>商家名称：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="supplierName" value="${supplier.supplierName }" onkeyup="aaa();" class="IptText300"/>
	    				<input type="hidden" name="supplierId" id="supplierId" value="${supplier.supplierId }" />
	    				<input type="button" class="button button-primary button-small" value="选择" onclick="selectAllSupplier()"/>
	    			</div>
					<div class="clear"></div>
	    		</dd>	    		
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="itemDate" id="itemDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value="${bookingDetailList[0].itemDate}" pattern='yyyy-MM-dd'/>"/>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
					<div class="dd_left"><i class="red">* </i>数量:</div>
					<div class="dd_right">
						<input type="text" name="itemNum" id="itemNum" value="${bookingDetailList[0].itemNum eq null?defaultPerson:bookingDetailList[0].itemNum}"
							class="IptText300" value="1"/>
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left"><i class="red">* </i>价格:</div>
					<div class="dd_right">
						
						
						
						<input type="text" name="itemPrice" id="itemPrice" value="<fmt:formatNumber value="${bookingDetailList[0].itemPrice eq null?0:bookingDetailList[0].itemPrice}" type="number" pattern="#.##"></fmt:formatNumber>"
						
							class="IptText300" />
						
					</div>
					<div class="clear"></div>
				</dd>
				<dd>
					<div class="dd_left">金额:</div>
					<div class="dd_right">
						<input id="itemTotal" type="text" name="itemTotal" value="<fmt:formatNumber value="${bookingDetailList[0].itemTotal eq null?0:bookingDetailList[0].itemTotal}" pattern="#.##" type="number"></fmt:formatNumber>"
							class="IptText300" readonly="readonly"></input>
						
					</div>
					<div class="clear"></div>
				</dd>
	    		<dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    				<textarea rows="5" cols="30" id="remark" name="remark">${supplier.remark }</textarea>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    			 <dd>
	    			<div class="dd_left">结算方式：</div> 
	    			<div class="dd_right">
	    				<select name="cashType" id="cashType">
								<c:choose>
									<c:when test="${empty supplier.cashType }">
									<c:forEach items="${cashTypes }" var="type">
										<option value="${type.value }" id="${type.id }" >${type.value }</option>
									</c:forEach>
									</c:when>
									<c:otherwise >
										<c:forEach items="${cashTypes }" var="type">
											<option <c:if test="${supplier.cashType eq type.value }">selected</c:if>  id="${type.id }">${type.value }</option>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</select>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">导游：</div> 
	    			<div class="dd_right">
	    				<c:set var="disabled" value="" />
						<c:if test="${supplier.payStatus eq 1 }">
							<c:set var="disabled" value="disabled='disabled'" />
						</c:if>
						<select id="bookingGuideId" style="width:93px;" ${disabled } >
							<option value=""></option>
							<c:forEach items="${bookingGuides}" var="booking">
								<option value="${booking.id}"
									<c:if test="${booking.id eq supplier.bookingId }">selected="selected"</c:if> 
								>${booking.guideName}</option>
							</c:forEach>
						</select>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">报账金额：</div> 
	    			<div class="dd_right">
	    				<input id="financeTotal" value="<fmt:formatNumber value="${supplier.financeTotal}" pattern="#.##"/>" 
						${disabled } type="text" style="width:85px;"/>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    	</dl>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
							<%-- <c:if test="${optMap['EDIT'] }"> --%>
							<c:if test="${see==null }">
								<button type="submit"
									class="button button-primary button-small" id="btnSave">保存</button>
								&nbsp;&nbsp;
									<button type="submit"
										class="button button-primary button-small" id="btnSaveAdd" >保存并新增</button>
									&nbsp;&nbsp;</c:if>
								<%-- </c:if> --%>
								<a href="javascript:void(0)" onclick="closeWindow()"
									class="button button-primary button-small">关闭</a>
							</div>
						</dd>
					</dl>
				</div>
			</form>
			
		</div>
	</div>	
<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript" src="<%=staticPath %>/assets/js/utils/float-calculate.js"></script>
<script type="text/javascript">
$(function () {
	var itemDate=$("#itemDate").val();
	
	function setData() {
		var curDate = new Date();
		var curMonth = curDate.getMonth()+1,
			  curDay = curDate.getDate(); 
		if(curMonth<10){curMonth='0'+curMonth;}
		if(curDay<10){curDay='0'+curDay;}
		
		var today=curDate.getFullYear() + "-" + curMonth + "-"+curDay;
		$("#itemDate").val(today);
	}
	if(itemDate ==null || itemDate==""){
	setData();
	}
});

var 	orderId=$("#orderId").val();
var detailArr=new Array();
var layindex=0;
$(function(){	
	 if($("#flag").val()==1){
		 $("#btnSave").attr("style","display:none");
		 $("#btnSaveAdd").attr("style","display:none");
		 $("#supplier").attr("style","display:none");
		 
		 $("#remark").attr("disabled","disabled");
		 $("#itemDate").attr("disabled","disabled");
		 $("#otherItem").attr("disabled","disabled");
		 $("#itemNum").attr("disabled","disabled");
		 $("#itemPrice").attr("disabled","disabled");
		 $("#itemTotal").attr("disabled","disabled");
		 $("#cashType").attr("disabled","disabled");
	 }
	 var saveFrom="save";
	 $("#btnSave").click(function(){
		 saveFrom="save";
	 })
	 
	 $("#btnSaveAdd").click(function(){
		 saveFrom="saveadd";
	 })
	$("#bookingForm").validate({
		rules : {
			'supplierName' : {
				required : true,
				maxlength:20
			},			
			'remark' : {
				//required : true
				maxlength:100
			},
			'itemDate':{
				required: true,
				
			},
			'itemNum':{
				required: true,
				isDouble:true
			},
			'itemPrice':{
				required:true,
				number:true
			}
		},
		messages : {
			'supplierName' : {
				required : "请选择商家"
			},
			'remark' : {
				maxlength : "备注信息长度小于100 "
			},
			'itemDate':{
				required: "请选择日期",
				
			},
			'itemNum':{
				required: "请输入数量",
				isDouble:"请输入数字"
			},
			'itemPrice':{
				required:"请输入价格",
				number:"请输入数字"
			}
		},
		errorPlacement : function(error, element) { // 指定错误信息位置
			if ( element.is(':checkbox')
					|| element.is(':input')) { // 如果是radio或checkbox
				var eid = element.attr('name'); // 获取元素的name属性
				error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var detail ={};				
			if(detailArr.length>0){
				detail=detailArr[0];
			}
			detail.type1Name = $("#otherItem option:selected").text(); 
			detail.type1Id = $("#otherItem option:selected").val(); 
			detail.itemDate = $("#itemDate").val();
			detail.itemPrice = $("#itemPrice").val();
			detail.itemNum = $("#itemNum").val();
			detail.itemTotal=$("#itemTotal").val();
			if(detailArr.length>0){
				detailArr[0]=detail;				
			}else{
				detailArr.push(detail);
			}
			
			var booking={
				id:$("#bookingId").val(),
				groupId:$("#groupId").val(),
				orderId:$("#orderId").val(),
				supplierId:$("#supplierId").val(),
				supplierType:$("#supplierType").val(),
				subType:$("#subType").val(),
				supplierName:$("#supplierName").val(),
				cashType:$("#cashType option:selected").text(),
				remark:$("#remark").val(),
				stateFinance:$("#stateFinance").val(),
				detailList:[]
			};
			booking.detailList=detailArr;
			
			var financeGuide = "";
			var bookingGuideId = $("#bookingGuideId");
			if(bookingGuideId && !$(bookingGuideId).attr("disabled")){
				financeGuide = '{"bookingId":"'+ bookingGuideId.val() +'", "total":"'+ $("#financeTotal").val() +'"}';
			}
			
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
						var options={
								type: 'POST',
								cache:false,
						        url: "saveSupplier.do",
						        dataType: 'json',		        
						        data: {bookingJson:JSON.stringify(booking), financeGuideJson:financeGuide},
						        //async:false,
						        success: function(data) {
						            if (data.sucess ) {
						            	$.success("保存成功",function(){
						            		if(saveFrom=='saveadd'){
						            			refreshWindow('新增其他支出','AYToAddSight.htm?groupId='+data['groupId']+"&orderId="+orderId);
						            		}else{
						            			refreshWindow('修改其他支出','AYToAddSight.htm?groupId='+data['groupId']+"&bookingId="+data['bookingId']+"&stateBooking="+data['stateBooking']+"&orderId="+orderId);
						            		}
						            	})
						            	}else{
										$.error("操作失败");
									}
						        },
						        error: function(data,msg) {
						            $.error("操作失败"+msg);
						        }
						};
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
	})
	addCompute();
});

	function addCompute(){
		$("input[id='itemPrice']").on('input',function(e){   
			 var itemPrice =$("input[id='itemPrice']").val();
			 var itemNum = $("input[id='itemNum']").val();
			 var total =(new Number(itemPrice==''?'1':itemPrice)).mul(new Number(itemNum==''?'1':itemNum));
			 $("input[id='itemTotal']").val(isNaN(total)?0:total);
			 });  
		 $("input[id='itemNum']").on('input',function(e){  
			 var itemPrice =$("input[id='itemPrice']").val();
			 var itemNum = $("input[id='itemNum']").val();
			 var total =(new Number(itemPrice==''?'1':itemPrice)).mul(new Number(itemNum==''?'1':itemNum));
			 $("input[id='itemTotal']").val(isNaN(total)?0:total);
		});
	}
	
	function selectSupplier(){   //其他支出 120 121 
		layer.openSupplierLayer({
			title : '选择商家',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=12',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择商家");
					return false;
				}
				
			//	for(var i=0;i<arr.length;i++){
					$("#supplierId").val(arr[0].id);
					$("#supplierName").val(arr[0].name);
					// selectCashType();
				//}
					/* $.ajax({
				         type: "post",
				         cache: false,
				         url: "selectItems.htm",
				         data: {
				        	 supplierId:$("#supplierId").val()
				         },
				         dataType: 'json',
				         async: false,
				         success: function (data) {
				        	 for (var i = 0; i < data.length; i++) {
				        		 var item = data[i];
				        		 $("#otherItem").append('<option value="'+item.id+'">'+item.itemName+'</option>');
			   		//  $("#").append("<tr><td>"+item.orderNo+"</td><td>"+item.supplierName+"</td><td>"+item.guestNames+"</td><td>"+item.guestSize+"</td><td><input type='hidden' name='detail["+i+"].orderId' value="+(item.orderId)+" /><input type='hidden' name='detail["+i+"].bookingDetailId' value="+(item.bookingDetailId)+" /><input name='detail["+i+"].buyTotal' value='"+(item.buyTotal ?item.buyTotal : "") +"' style='width:50px' /></td><td><textarea  name='detail["+i+"].remark' class='IptText150'>"+(item.remark?item.remark : "")+"</textarea></td></tr>"); 
			   	 }
			   		 
			    }
			}); */
		    }
		});
	}
	//根据选择的供应商和该团的出团日期自动选中协议中的结算方式
	function selectCashType(){
		//var cashTypes=$("#cashTypes").val();
		$.ajax({
			type: 'POST',
	        url: 'selectCashType.htm',
	        dataType: 'json',
	        
	        data:{
	        	supplierId:$("#supplierId").val(),
	        	groupId:${groupId}
	        },
	        success: function(data) {
	        	if (data.sucess ) {	
	        		if (data['cashTypeId'] != undefined && data['cashTypeId']!='undefined'){
						$("#cashType").find("option[id='"+data['cashTypeId']+"']").attr("selected",true);
					}
	        	}
	        }
	        
	        });
	}
	
	function selectHotel() {    // 酒店3
		layer.openSupplierLayer({
			title: '选择酒店',
			content: '<%=ctx%>/component/supplierList.htm?supplierType=3',
			callback: function (arr) {
				if (arr.length == 0) {
					$.warn("请选择酒店 ");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
			}
		});
	}
	
	function selectRestraunt(){      //餐厅2
		layer.openSupplierLayer({
			title : '选择餐厅',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=2',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择餐厅 ");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	
	function selectTicket(){		// 景区5
		layer.openSupplierLayer({
			title : '选择供应商',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=5',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择供应商 ");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	function selectInsurance(){   //保险15
		layer.openSupplierLayer({
			title : '选择保险',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=15',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择商家");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	function selectAir(){
		layer.openSupplierLayer({
			title : '选择机票',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=9',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择商家 ");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	function selectAllSupplier(){
		var supplierType = $("#supplierType").val() ;
		if(supplierType==3)
			selectHotel();
		if(supplierType==2)
		selectRestraunt();
		if(supplierType==5)
			selectTicket();
		if(supplierType==9)
			selectAir();
		if(supplierType==15)
			selectInsurance();
		if(supplierType==120 || supplierType==121)
			selectSupplier();
	}
	
</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
   function aaa(){
        var param = "";
        var supplierType = $("#supplierType").val() ;
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType="+supplierType, param, "supplierId");
    }
</script>
</html>

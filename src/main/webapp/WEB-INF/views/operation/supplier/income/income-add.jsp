<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增其他收入</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../../include/top.jsp"%>

</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    <div id="groupDetail">
            </div>
	    	<form id="bookingForm" action="">
	    	<input type="hidden" name="groupId" id="groupId" value="${groupId }" />
				<input type="hidden" name="bookingId" id="bookingId" value="${supplier.id }" />
				<input type="hidden" name="supplierType" id="supplierType" value="${supplier.supplierType }" />
				<input type="hidden" name="stateFinance" id="stateFinance" value="${supplier.stateFinance }" />
				<input type="hidden" name="stateBooking" id="stateBooking" value="${supplier.stateBooking }" />
				<input type="hidden" name="flag" id="flag" value="${flag}" />
				
				<input type="hidden" name="subType" id="subType" value="${supplier.subType }" />
	    	<p class="p_paragraph_title"><b>其他收入信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>商家名称：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="supplierName" value="${supplier.supplierName }" class="IptText300"/>
	    				<input type="hidden" name="supplierId" id="supplierId" value="${supplier.supplierId }" />
	    				<input type="button" class="button button-primary button-small" value="选择" onclick="selectSupplier()" id="incomesupplier"/>
	    				
	    				
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
										<option value="${type.value }">${type.value }</option>
									</c:forEach>
									</c:when>
									<c:otherwise >
										<c:forEach items="${cashTypes }" var="type">
											<option <c:if test="${supplier.cashType eq type.value }">selected</c:if>  >${type.value }</option>
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
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="itemDate" id="itemDate" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="<fmt:formatDate value='${bookingDetailList[0].itemDate}' pattern='yyyy-MM-dd'/>"/>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>项目：</div> 
	    			<div class="dd_right">
	    				<select id="otherItem">	    					
							<c:forEach items="${otherItems }" var="item">
								<option value="${item.id }" <c:if test="${bookingDetailList[0].type1Id!=null and item.id==bookingDetailList[0].type1Id }">selected</c:if>>${item.value }</option>
							</c:forEach>								
	    				</select>
	    			</div>
					<div class="clear"></div>
	    		</dd>
	    		<dd>
					<div class="dd_left"><i class="red">* </i>数量:</div>
					<div class="dd_right">
					
						
						<input type="text" name="itemNum" id="itemNum" value="${bookingDetailList[0].itemNum eq null?0:bookingDetailList[0].itemNum}"
							class="IptText300" />
						
						
					
						
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
	    	</dl>
				<div class="Footer">
					<dl class="p_paragraph_content">
						<dd>
							<div class="dd_left"></div>
							<div class="dd_right">
								<%-- <c:if test="${optMap['EDIT'] }"> --%>
									<button type="submit"
										class="button button-primary button-small" id="btnSave" >保存</button>
									&nbsp;&nbsp;
									<button type="submit"
										class="button button-primary button-small" id="btnSaveAdd" >保存并新增</button>
									&nbsp;&nbsp;
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
var detailArr=new Array();
var layindex=0;
$(function(){	
	<c:if test='${! empty bookingDetailList }'>
		<c:forEach items="${bookingDetailList}" var="detail">				
			detailArr.push({id:${detail.id},type1Name:'${detail.type1Name}',type1Id:'${detail.type1Id}',bookingId:${detail.bookingId},itemDate:'<fmt:formatDate value="${detail.itemDate}" pattern="yyyy-MM-dd"/>',itemNum:${detail.itemNum},itemPrice:${detail.itemPrice},itemTotal:${detail.itemTotal}});				
		</c:forEach>
	</c:if>
	 $("#groupDetail").load("<%=staticPath%>/booking/groupDetail.htm?gid="+$("#groupId").val()+"&stype=12");
	 if($("#flag").val()==1){
		 $("#btnSave").attr("style","display:none");
		 $("#btnSaveAdd").attr("style","display:none");
		 $("#incomesupplier").attr("style","display:none");
		 $("#itemDate").attr("disabled","disabled");
		 $("#otherItem").attr("disabled","disabled");
		 $("#itemNum").attr("disabled","disabled");
		 $("#itemPrice").attr("disabled","disabled");
		 $("#itemTotal").attr("disabled","disabled");
		 $("#remark").attr("disabled","disabled");
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
				isDouble:"请输入非负数字"
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
				supplierId:$("#supplierId").val(),
				supplierType:$("#supplierType").val(),
				subType:$("#subType").val(),
				supplierName:$("#supplierName").val(),
				cashType:$("#cashType option:selected").text(),
				remark:$("#remark").val(),
				stateFinance:$("#stateFinance").val(),
				stateBooking:$("#stateBooking").val(),
				
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
						            			refreshWindow('新增其他收入','editIncome.htm?groupId='+data['groupId']);
						            		}else{
						            			refreshWindow('修改其他收入','editIncome.htm?groupId='+data['groupId']+'&bookingId='+data['bookingId']+"&stateBooking="+data['stateBooking']);
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
	
	/* var showGroupInfo=function(){
		$("#groupDetail").load("groupDetail.htm?gid=${supplier.groupId }");
	}
	showGroupInfo(); */
})

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
	
	function selectSupplier(){
		layer.openSupplierLayer({
			title : '选择商家',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=12',
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选择商家");
					return false;
				}
				
				//for(var i=0;i<arr.length;i++){
					$("#supplierId").val(arr[0].id);
					$("#supplierName").val(arr[0].name);
					selectCashType();
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
	            	$("#cashType").find("option").each(function(){
	            		var sid=$(this).attr("id");
	            		if(sid==data['cashTypeId']){
	            			$(this).attr("selected","selected");
	            		}
	            	})
	        	}
	        	
	        }
	        
	        });
	        
	}
</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
	var supplierType = $("#supplierType").val() ;
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=12", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
    	selectCashType();
    } 
</script>

</html>

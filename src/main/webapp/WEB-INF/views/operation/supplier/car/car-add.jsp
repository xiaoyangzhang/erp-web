
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>新增订单</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<%@ include file="../../../../include/top.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>

</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<div id="groupDetail" >            	
            </div> 
	    	<form id="bookingForm" action="">
	    	<input type="hidden" name="groupId" id="groupId" value="${groupId }" />
				<input type="hidden" name="bookingId" id="bookingId" value="${bookingId }" />
				<input type="hidden" name="stateBooking" id="stateBooking" value="${supplier.stateBooking }" />
				<input type="hidden" name="flag" id="flag" value="${flag }" />
				<input type="hidden" name="isShow" id="isShow_id" value="${isShow }" />
				<input type="hidden" name="supplierType" id="supplierType"
					value="${supplierType }" />
				<input type="hidden" name="stateFinance" id="stateFinance" value="${supplier.stateFinance }" />
				
	    	<p class="p_paragraph_title"><b>车队信息</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>车队名称：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="supplierName" value="${supplier.supplierName }" class="IptText300"/>
	    				<input type="hidden" name="supplierId" id="supplierId" value="${supplier.supplierId }" />
	    				<a href="javascript:void(0)" onclick="selectCars()" id="cars" class="button button-primary button-small" >选择</a>
	    				
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left">联系方式：</div> 
	    			<div class="dd_right">
	    			<p class="pb-5">	    				
						<p class="pb-5">
						<input type="text" id="contact" placeholder="联系人" name="contact" 
									class="IptText60" value="${supplier.contact }" />
								<input type="text" id="contactTel" placeholder="电话"
									name="contactTel" class="IptText120" 
									value="${supplier.contactTel }" /> <input
									type="text" id="contactMobile" name="contactMoblie"
									placeholder="手机" class="IptText120" 
									value="${supplier.contactMobile }" /> <input
									type="text" id="contactFax" name="contactFax" placeholder="传真"
									class="IptText120" value="${supplier.contactFax }" />
						
                        <a href="javascript:void(0)" onclick="selectContact()" class="button button-primary button-small" id="contact1"/>选择</a>
	    				</p>                        
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
									<option value="${type.value }" id="${type.id }">${type.value }</option>
								</c:forEach>
								</c:when>
								<c:otherwise >
									<c:forEach items="${cashTypes }" var="type">
										<option <c:if test="${supplier.cashType eq type.value }" >selected</c:if>  id="${type.id }">${type.value }</option>
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
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    				<textarea rows="5" cols="48" id="remark" name="remark" 
								value="${supplier.remark }">${supplier.remark }</textarea>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
                    		
	    	</dl>

	    	<p class="p_paragraph_title">
					<b>预订车辆</b>
				</p>
				<dl class="p_paragraph_content">
					
						<dd>
						<div class="dd_right" style="width: 80%">
							<input type="hidden" name="detailId" id="detailId" value="${bookingDetailList[0].id }" />
						</div>
 						
						</dd>
						
						<dd>
							<div class="dd_left"><i class="red">* </i>用车日期:</div>
							<input type="text"  tag="price" name="itemDate" id="itemDate" class="Wdate" value="<fmt:formatDate value='${bookingDetailList[0].itemDate }'
														pattern='yyyy-MM-dd'/>"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){changeData();}})" />
							~<input type="text"  tag="price" name="itemDateTo" id="itemDateTo" class="Wdate" value="<fmt:formatDate value='${bookingDetailList[0].itemDateTo }'
														pattern='yyyy-MM-dd'/>"
								onClick="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){changeData();}})" />
						</dd>
						<dd>

							<div class="dd_left">车型:</div>
							<select id="type1Id" name="type1Id" class="select160" tag="price"
								style="width: 310px; text-align: right">
								    					
							 <c:forEach items="${carTypes }" var="t1">
								<option value="${t1.id }" <c:if test="${bookingDetailList[0].type1Id!=null and t1.id==bookingDetailList[0].type1Id }">selected</c:if>>${t1.value} </option>
							</c:forEach> 								
	    				
								
								
							</select>
						</dd>


						<dd>
							<div class="dd_left">车牌号:</div>
							
								<input type="text" name="carLisence" id="carLisence" value="${bookingDetailList[0].carLisence }"
								class="IptText300" readonly="readonly"/>
								<a href="javascript:void(0)" onclick="selectCarLisence()" id="lisenceSeat" class="button button-primary button-small"/>选择</a>
						</dd>


						<dd>
							<div class="dd_left"><i class="red">* </i>座位数:</div>
							
							
								
							<input type="text" name="type2Name" tag="price" id="type2Name" class="IptText300"  value="${bookingDetailList[0].type2Name eq null?1:bookingDetailList[0].type2Name }" />
								
						</dd>
						


						<dd>
							<div class="dd_left">数量:</div>
							
							
							<input type="text" tag="price" name="itemNum" id="itemNum" value="<fmt:formatNumber value="${bookingDetailList[0].itemNum eq null?1:bookingDetailList[0].itemNum}" pattern="#.##" type="number"/>"
								class="IptText300" />
								
						</dd>


						<dd>
							<div class="dd_left">价格:</div>
							<div class="dd_right">
								<input type="text" tag="price" name="itemPrice" id="itemPrice"
									value="<fmt:formatNumber value="${bookingDetailList[0].itemPrice eq null ? 0:bookingDetailList[0].itemPrice}"  pattern="#.##" type="number"/>"
									class="IptText300" />
								<a href="javascript:void(0)" id="selPrice" onclick="selectPrice()" class="button button-primary button-small"/>选择</a>
							</div>
							<div class="clear"></div>
						</dd>
					<c:if test="${sysBizConfig.itemValue eq 1 and isShow == 1}">
						<dd id="sbf_id" style="background-color:#B0C4DE;width: 405px;">
							<div class="dd_left"><i class="red">* </i>计调费:</div>
							<div class="dd_right" style="width: 100px;">
								<input type="text" tag="price" name="carProfitTotal" id="carProfitTotal" style="width: 60px;"
									   value="<fmt:formatNumber value="${bookingDetailList[0].carProfitTotal eq null ? 0:bookingDetailList[0].carProfitTotal}"  pattern="#.##" type="number"/>"
									   class="IptText300" />
							</div>
							<div class="dd_left"><i class="red">* </i>备注:</div>
							<select id="carPayType" name="carPayType" class="select160" tag="price" text-align: right" style="width: 100px;">
							<option value="">--请选择--</option>
							<option value="短线" <c:if test="${bookingDetailList[0].carPayType eq '短线'}">selected="selected"</c:if>>短线</option>
							<option value="接送机" <c:if test="${bookingDetailList[0].carPayType eq '接送机'}">selected="selected"</c:if>>接送机</option>
							</select>
							<div class="clear">
							</div>
						</dd>
						<dd id="sbf_id2" style="background-color:#B0C4DE;width: 405px;">
							<div class="dd_left"><i class="red">* </i>其他利润:</div>
							<div class="dd_right" style="width: 100px;">
								<input type="text" tag="price" name="carProfitTotal2" id="carProfitTotal2" style="width: 60px;"
									   value="<fmt:formatNumber value="${bookingDetailList[0].carProfitTotal2 eq null ? 0:bookingDetailList[0].carProfitTotal2}"  pattern="#.##" type="number"/>"
									   class="IptText300" />
							</div>
							<div class="dd_left"><i class="red">* </i>备注:</div>
							<select id="carPayType2" name="carPayType2" class="select160" tag="price" text-align: right" style="width: 100px;">
							<option value="">--请选择--</option>
							<option value="套团" <c:if test="${bookingDetailList[0].carPayType2 eq '套团'}">selected="selected"</c:if> >套团</option>
							<option value="临时团" <c:if test="${bookingDetailList[0].carPayType2 eq '临时团'}">selected="selected"</c:if> >临时团</option>
							<option value="特殊线" <c:if test="${bookingDetailList[0].carPayType2 eq '特殊线'}">selected="selected"</c:if> >特殊线</option>
							<option value="其他" <c:if test="${bookingDetailList[0].carPayType2 eq '其他'}">selected="selected"</c:if> >其他</option>
							</select>
							<div class="clear"></div>
						</dd>
					</c:if>



						<dd>
							<div class="dd_left">司机:</div>
							<input type="text" id="driverName" name="driverName" readonly="readonly" value="${bookingDetailList[0].driverName}"
								class="IptText300"/>
								<input type="hidden" id="driverId" name="driverId" value="" />
							<a href="javascript:void(0)" onclick="selectDriver()" id="drivename" class="button button-primary button-small"/>选择</a>
							
							
						</dd>
						<dd>
							<div class="dd_left">司机联系方式:</div>
							<input type="text" id="driverTel" name="driverTel" value="${bookingDetailList[0].driverTel}"
								class="IptText300"/>
						</dd>
						<dd>
							<div class="dd_left">金额:</div>
							<div class="dd_right">
								<input id="itemTotal" type="text" name="itemTotal" value="<fmt:formatNumber value='${bookingDetailList[0].itemTotal eq null ? 0:bookingDetailList[0].itemTotal}' pattern="#.##" type='number' />"
									class="IptText300" readonly="readonly"/>								
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
								<%-- </c:if> --%>	<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
							</div>

						</dd>
					</dl>
				</div>
			</form>
		</div>
	</div>
	
</body>

<script type="text/javascript" src="<%=staticPath %>/assets/js/json2.js"></script>
<script type="text/javascript">
var detailArr=new Array();
$(function(){
	 /* <c:if test='${! empty bookingDetailList }'>
		<c:forEach items="${bookingDetailList}" var="detail">				
			detailArr.push({id:${detail.id},type1Name:'${detail.type1Name}',carLisence:'${detail.carLisence}',type1Id:'${detail.type1Id}',type2Id:'${detail.type2Id}',bookingId:${detail.bookingId},itemDate:'<fmt:formatDate value="${detail.itemDate}" pattern="yyyy-MM-dd"/>',itemNum:${detail.itemNum},itemPrice:${detail.itemPrice},driverName:'${detail.driverName}',driverTel:'${detail.driverTel}',itemTotal:${detail.itemTotal}});				
		</c:forEach>
	</c:if>  */
	 
	 $("#groupDetail").load("<%=staticPath%>/booking/groupDetail.htm?gid="+$("#groupId").val()+"&stype=4");
	 if($("#flag").val()==1){
		 $("#btnSave").attr("style","display:none");
		 $("#btnSaveAdd").attr("style","display:none");
		 $("#cars").attr("style","display:none");
		 $("#contact1").attr("style","display:none");
		 $("#itemDate").attr("disabled","disabled");
		 $("#itemDateTo").attr("disabled","disabled");
		 $("#type1Id").attr("disabled","disabled");
		 $("#carLisence").attr("disabled","disabled");
		 $("#type2Name").attr("disabled","disabled");
         $("#carProfitTotal").attr("disabled","disabled");
         $("#carPayType").attr("disabled","disabled");
         $("#carProfitTotal2").attr("disabled","disabled");
         $("#carPayType2").attr("disabled","disabled");
		 $("#itemNum").attr("disabled","disabled");
		 $("#selPrice").attr("style","display:none");
		 $("#itemPrice").attr("disabled","disabled");
		 $("#drivename").attr("style","display:none");
		 $("#driverName").attr("disabled","disabled");
		 $("#remark").attr("disabled","disabled");
		 $("#cashType").attr("disabled","disabled");
		 $("#contact").attr("disabled","disabled");
		 $("#contactTel").attr("disabled","disabled");
		 $("#contactMobile").attr("disabled","disabled");
		 $("#contactFax").attr("disabled","disabled");
		 $("#lisenceSeat").attr("style","display:none");
		 
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
				required : true
				//maxlength:20
			},
			'remark' : {
				//required : true
				maxlength:200
			},
			'itemDate':{
				required: true
				
			},
			'itemDateTo':{
				required: true
				
			},
			'itemNum':{
				required: true,
				isDouble:true
			},
			'itemPrice':{
				required:true,
				number:true
			},
            'carProfitTotal':{
                required:true,
                number:true
            },
            'carPayType':{
                required:false,
                maxlength:45
            },
            'carProfitTotal2':{
                required:true,
                number:true
            },
            'carPayType2':{
                required:false,
                maxlength:45
            },
			'type2Name':{
				required:true
				//maxlength:11
				//digits:true
				
			}
		},
		messages : {
			'supplierName' : {
				required : "请选择车队"

			},
			'remark' : {
				maxlength : "备注信息长度小于200 "

			},
			'itemDate':{
				required: "请选择开始日期"
				
			},
			'itemDateTo':{
				required: "请选择结束日期"
				
			},
			'itemNum':{
				required: "请输入用车数量",
				isDouble:"请输入非负数字"
			},
			'itemPrice':{
				required:"请输入价格",
				number:"请输入数字"
            },
            'carProfitTotal':{
                required: "请输入计调费",
                isDouble:"请输入数字"
            },
            'carPayType':{
                required:"请填写备注"
            },
            'carProfitTotal2':{
                required: "请输入其他利润",
                isDouble:"请输入数字"
            },
            'carPayType2':{
                required:"请填写备注",
			},
			'type2Name':{
				required:"请输入座位数"
				//maxlength:11
				//digits:"请输入数字"
				
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
			var book ={};
			if(detailArr.length>0){
				book=detailArr[0];
			}
			book.id=$(form).find("#detailId").val();
			book.type1Name = $(form).find("#type1Id option:selected").text(); 
			book.carLisence= $(form).find("#carLisence ").val();
			book.type1Id = $(form).find("#type1Id option:selected").val(); 
			book.type2Name = $(form).find("#type2Name").val(); 
			//book.type2Name=book.type2Id;
			book.itemDate = $(form).find("#itemDate").val();
			book.itemDateTo = $(form).find("#itemDateTo").val();
			book.itemPrice = $(form).find("#itemPrice").val();
            book.carProfitTotal = $(form).find("#carProfitTotal").val();
            book.carPayType = $(form).find("#carPayType").val();
            book.carProfitTotal2 = $(form).find("#carProfitTotal2").val();
            book.carPayType2 = $(form).find("#carPayType2").val();
			book.itemNum = $(form).find("#itemNum").val();
			book.driverName = $(form).find("#driverName").val();
			book.driverTel = $(form).find("#driverTel").val();
			book.itemTotal=$(form).find("#itemTotal").val();
			book.driverId=$("#driverId").val();
			if(detailArr.length>0){
				detailArr[0]=book;				
			}else{
				detailArr.push(book);
			}
			var booking={
				id:$("#bookingId").val(),
				groupId:$("#groupId").val(),
				supplierId:$("#supplierId").val(),
				supplierType:$("#supplierType").val(),
				
				supplierName:$("#supplierName").val(),
				contactTel:$("#contactTel").val(),
				contact:$("#contact").val(),
				contactFax:$("#contactFax").val(),
				contactMobile:$("#contactMobile").val(),
				cashType:$("#cashType  option:selected").text(),
				remark:$("#remark").val(),
				stateBooking:$("#stateBooking").val(),
				stateFinance:$("#stateFinance").val(),
				detailList:[]
			};
			booking.detailList = detailArr;
			
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
						            			refreshWindow("新增车辆订单","toAddCar?groupId="+data['groupId']+"&isShow="+$("#isShow_id").val());
						            		}else{
						            			refreshWindow("修改车辆订单","toAddCar?groupId="+data['groupId']+"&bookingId="+data['bookingId']+"&stateBooking="+data['stateBooking']);
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
})
	
 

	function addValidate(){
		return $("#detailForm").validate({
			rules:{
				
				'itemDate':{
					required: true
					
				},
				'itemDateTo':{
					required: true
					
				},
				'itemNum':{
					required: true,
					isDouble:true
				},
				'itemPrice':{
					required:true,
					isDouble:true
				},
				
				'driverTel':{
					required:true
					//maxlength:11
					
				},
                'carProfitTotal':{
                    required:true,
                    isDouble:true

                },
                'carPayType':{
                    required: true

                },
			},
			messages: {
				'itemDate':{
					required: "请选择开始日期",
					
				},
				'itemDateTo':{
					required: "请选择结束日期",
					
				},
				'itemNum':{
					required: "请输入用车数量",
					isNum:"请输入数字"
				},
				'itemPrice':{
					required:"请输入价格",
					isNum:"请输入数字"
					
				},
				
				'driverTel':{
					required:"请输入司机联系方式"
					//maxlength:"长度不大于11"
					
				},
				'carProfitTotal':{
                    required: "请输入计调费",
                    isDouble:"请输入数字"
                },
                'carPayType':{
                    required:"请选择方式",

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
				addCar(form);
				return false;
			}
		});
	}
			    
			function selectDriver(){
		    	/* var supplierId=$("#supplierId").val();
		    	if(supplierId==""){
		    		$.info("请先选择车队");
		    		return;
		    	} */
	    		var win;
	    		layer.open({ 
	    			type : 2,
	    			title : '选择司机',
	    			closeBtn : false,
	    			area : [ '600px', '450px' ],
	    			shadeClose : false,
	    			content : '<%=ctx%>/component/driverList.htm',
	    			btn: ['确定', '取消'],
	    			success:function(layero, index){
	    				win = window[layero.find('iframe')[0]['name']];
	    			},
	    			yes: function(index){
	    				//manArr返回的是联系人对象的数组
	    				var driver = win.getSelectedDriver();    				
	    				if(driver==null){
	    					$.warn("请选择司机");
	    					return false;
	    				}
	    				$("#driverId").val(driver.id);
	    				$("#driverName").val(driver.name);
	    				$("#driverTel").val(driver.mobile);
	    				//一般设定yes回调，必须进行手工关闭
	    		        layer.close(index); 
	    		    },cancel: function(index){
	    		    	layer.close(index);
	    		    }
	    		});
	    	}

	
	function selectCars(){
		var win;
		layer.openSupplierLayer({
			title : '选择车队',
			content : '<%=ctx%>/component/supplierList.htm?supplierType=4',
			btn: ['确定', '取消'],
			success:function(layero, index){
			    //win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index,lo){
				//manArr返回的是联系人对象的数组
//				alert(frames[0].parent.location);
                var win = lo.find('iframe')[0].contentWindow;
				var arr = win.getChkedSupplier(); 				
				if(arr.length==0){
					$.warn("请选择车队 ");
					return false;
				} 
				$("#supplierName").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		        layer.close(index); 
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
			        		 $("#type1Id").append('<option value="'+item.id+'">'+item.itemName+'</option>');
		   		//  $("#").append("<tr><td>"+item.orderNo+"</td><td>"+item.supplierName+"</td><td>"+item.guestNames+"</td><td>"+item.guestSize+"</td><td><input type='hidden' name='detail["+i+"].orderId' value="+(item.orderId)+" /><input type='hidden' name='detail["+i+"].bookingDetailId' value="+(item.bookingDetailId)+" /><input name='detail["+i+"].buyTotal' value='"+(item.buyTotal ?item.buyTotal : "") +"' style='width:50px' /></td><td><textarea  name='detail["+i+"].remark' class='IptText150'>"+(item.remark?item.remark : "")+"</textarea></td></tr>"); 
		   	 }
		   		 
		    }
		}); */
				//一般设定yes回调，必须进行手工关闭
		    },cancel: function(index){
		    	layer.close(index);
		    }
		    
			
		});
		
	}
	function selectCarLisence(){
		var win;
		
		layer.openSupplierLayer({
			title : '选择车辆',
			closeBtn : false,
			area : [ '700px', '500px' ],
			shadeClose : false,
			content : '<%=ctx%>/booking/toSupplierCarList.htm',
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				//manArr返回的是联系人对象的数组
				var car = win.getSelectedCarLisence();    				
				if(car==null){
					$.warn("请选择车辆");
					return false;
				}

				$("#carLisence").val(car.carLisenseNo);
				$("#type2Name").val(car.seatNum);
				selectCashType();
				//一般设定yes回调，必须进行手工关闭
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
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
	//查询联系人
	function selectContact(){
		/**
		 * 先选择供应商，再根据供应商id选择联系人 
		 */
		var win=0;
		var supplierId = $("#supplierId").val().trim() ;
		if(supplierId==""){
			layer.msg("请先选择车队 ");
		}else{
			layer.open({ 
				type : 2,
				title : '选择联系人',
				closeBtn : false,
				area : [ '550px', '450px' ],
				shadeClose : false,
				content : '<%=ctx%>/component/contactMan.htm?supplierId='
						+ supplierId,//参数为供应商id
				btn : [ '确定', '取消' ],
				success : function(layero, index) {
					win = window[layero.find('iframe')[0]['name']];
				},
				yes : function(index) {
					//manArr返回的是联系人对象的数组
					var arr = win.getChkedContact();
					if (arr.length == 0) {
						$.warn("请选择联系人");
						return false;
					}
					$("#contact").val(arr[0].name);
					$("#contactMobile").val(arr[0].mobile);
					$("#contactTel").val(arr[0].tel);
					$("#contactFax").val(arr[0].fax);
					//一般设定yes回调，必须进行手工关闭
					layer.close(index);
				},
				cancel : function(index) {
					layer.close(index);
				}
			});
		}
	}
	function del(obj, id) {
		delRowEvent(obj);
	}
	function delRowEvent(obj) {
		var rowindex = $(obj).closest("#carTblTr").find("tr").index(
				$(obj).closest("tr")[0]);
		$(obj).closest("tr").remove();
		detailArr.splice(rowindex, 1);
	}

	 var inputChange = function () {
		$("#bookingForm input[tag='price']").unbind("change").bind("change", function(){
			changeData();
		});
	}

	function selectPrice(){
		/* var supplierId=$("#supplierId").val();
    	if(supplierId==""){
    		$.info("请先选择车队");
    		return;
    	} */
    	var type1 = $("#type1Id").val(),
    	type2Name = $("#type2Name").val(),
    	date = $("#itemDate").val();
    	dateTo = $("#itemDateTo").val();
    	
    	var url = "carPrice.htm?s=1";
    	if(type1){
    		url+="&type1="+type1;
    	}
    	if(type2Name&&type2Name!=0){
    		url+="&seatCnt="+type2Name;
    	}
    	if(date){
    		url+="&date="+date;
    	}
    	if(dateTo){
    		url+="&dateTo="+dateTo;
    	}
    	
    	layer.open({ 
			type : 2,
			title : '选择协议价',
			closeBtn : false,
			area : [ '750px', '450px' ],
			shadeClose : false,
			content : url,//参数为供应商id
			btn : [ '确定', '取消' ],
			success : function(layero, index) {
				win = window[layero.find('iframe')[0]['name']];
			},
			yes : function(index) {				
				var price = win.getPrice();
				if (!price) {
					$.warn("请选择协议价");
					return false;
				}
				$("#itemPrice").val(price);
				changeData();
				//一般设定yes回调，必须进行手工关闭
				layer.close(index);
			},
			cancel : function(index) {
				layer.close(index);
			}
		});
	}
	 
	inputChange();
	
	function changeData(){
		var $Num = $("#itemNum"),
		$Price = $("#itemPrice");	

		var vNum=$Num.val(),vPrice=$Price.val();		
		var total =(vPrice==''?'1':vPrice)*(vNum==''?'1':vNum);
		$("#itemTotal").val(isNaN(total)?0:total);
	}
	
	/* function getSelectedCar(){
		var $check = $("input[name='subBox']:checked");
		if($check.length==0){	
			return null;
		}
		return {carLisense:$check.attr("carLisenseNo"),seatNum:$check.attr("seatNum")};
	} */
</script>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath%>/tourGroup/getSupplier?supplierType=4", param, "supplierId", customerTicketCallback, 1);
    });
    function customerTicketCallback(event, value) {
    	selectCashType();
    }
    (function(){
        var  formUtils = yihg_utils_fun;
        var params = formUtils.getParams("bookingForm");
        (params["bookingId"]=="") && formUtils.setDefault("bookingForm",{"carProfitTotal":"200","carProfitTotal2":"0"});
    })();
</script>
</html>

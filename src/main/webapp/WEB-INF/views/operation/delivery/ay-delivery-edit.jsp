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
<link rel="stylesheet" type="text/css" href="<%=staticPath %>/assets/css/operate/operate.css"/>
<style type="text/css">
	.dn{display:none;}
	.textarea-w200-h50{height:50px;width:80%;margin-top:4px;}
	.input-w80{width:70%;}
	.fontBold{font-weight:bold;}
</style>
<link href="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="<%=ctx%>/assets/js/web-js/sales/autocomplete/jquery.autocomplete.js" type="text/javascript"></script>
</head>
<body>
	 <div class="p_container" >
	    <div class="p_container_sub" id="tab1">
	    	<form id="bookingForm" method="post">
	    	<input type="hidden" name="groupId" id="groupId" value="${group.id}" />
	    	<input type="hidden" id="bookingId" value="${booking.id}" />
	    	<input type="hidden" name="stateFinance" id="stateFinance" value="${booking.stateFinance }" />
	    	<input type="hidden" id="orderId" id="orderId" value="${orderId}" />
	    	<input type="hidden" id="groupMode" value="${group.groupMode}" />
	    	<input type="hidden" id="stateBooking" value="${booking.stateBooking}" />
	    	<p class="p_paragraph_title"><b>地接社</b></p>
	    	<dl class="p_paragraph_content">
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>地接社：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="supplierName" id="supplierName" value="${booking.supplierName}" class="IptText300"/>
	    				<input type="hidden" name="supplierId" id="supplierId" value="${booking.supplierId}" />
	    				<c:if test="${empty view }">
	    					<input type="button" class="button button-primary button-small" value="选择" onclick="show.agency('<%=ctx%>')"/>
	    				</c:if>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		<dd>
	    			<div class="dd_left"><i class="red">* </i>到达日期：</div> 
	    			<div class="dd_right">
	    				<input type="text" name="dateArrival" id="dateArrival" class="Wdate"
							onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" 
							<c:if test="${not empty booking}">
								value="<fmt:formatDate value="${booking.dateArrival}" pattern="yyyy-MM-dd"/>"
							</c:if>
							<c:if test="${empty booking}">
								value="<fmt:formatDate value="${group.dateStart}" pattern="yyyy-MM-dd"/>"
							</c:if> 
							/>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left">产品说明：</div> 
	    			<div class="dd_right">
	    			<input type="hidden" name="productDes"class="IptText300" id="productDes"value="${booking.productDes }" /> 
						<select name="productDesId" id="productDesId">
								<option value="-1"> </option>
								<c:forEach items="${cashTypes}" var="v">
									<option value="${v.id }"
										<c:if test="${v.id==booking.productDesId }"> selected="selected" </c:if>>${v.value}</option>
								</c:forEach>
						</select>
					</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    			<dd>
	    			<div class="dd_left">数量：</div> 
	    			<div class="dd_right">
	    			<input class="input-w80" type="text" name="numTimes" id="numTimes" value="<fmt:formatNumber value="${booking.priceList[0].numTimes eq null?(group.totalAdult+group.totalChild):booking.priceList[0].numTimes}" type="number" pattern="#.##"></fmt:formatNumber>" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    				<dd>
	    			<div class="dd_left">价格：</div> 
	    			<div class="dd_right">
	    			<input class="input-w80" type="text" name="unitPrice" id="unitPrice"  value="<fmt:formatNumber value="${booking.priceList[0].unitPrice eq null?0:booking.priceList[0].unitPrice}" type="number" pattern="#.##"></fmt:formatNumber>" />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    				<dd>
	    			<div class="dd_left">金额：</div> 
	    			<div class="dd_right">
	    			<input class="input-w80" type="text" name="totalPrice" id="totalPrice" value="<fmt:formatNumber value="${booking.priceList[0].totalPrice eq null?0:booking.priceList[0].totalPrice}" type="number" pattern="#.##"></fmt:formatNumber>" readOnly />
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		
	    		<dd>
	    			<div class="dd_left">备注：</div> 
	    			<div class="dd_right">
	    					<c:choose>
		    				<c:when test="${booking!=null && !empty booking.priceList[0].remark }"><textarea rows="5" cols="30" name="remark" id="remark">${booking.priceList[0].remark }</textarea></c:when>
	    					<c:otherwise><textarea rows="5" cols="30" name="remark" id="remark"></textarea></c:otherwise>
	    				</c:choose>
	    			</div>
					<div class="clear"></div>
	    		</dd> 
	    		
            <div class="Footer">
	            <dl class="p_paragraph_content">
		    		<dd>
		    			<div class="dd_left"></div> 
		    			<div class="dd_right">
		    				<c:if test="${see ==null }">
	            			<button  type="submit" class="button button-primary button-small" id="btnSave">保存</button>
	            			</c:if>
	            			<a href="javascript:void(0)" onclick="closeWindow()" class="button button-primary button-small">关闭</a>
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
var person = {adult:0,child:0,guide:0};
var dataInit=function(){
	<c:if test='${booking!=null }'>
		person.adult = ${booking.personAdult==null?0:booking.personAdult};
		person.child = ${booking.personChild==null?0:booking.personChild};
		person.guide = ${booking.personGuide==null?0:booking.personGuide};
	</c:if>	
	<c:if test='${booking==null }'>
		<c:if test="${group.groupMode>0}">
			person.adult = ${group.totalAdult};
			person.child = ${group.totalChild};
			person.guide = ${group.totalGuide};
		</c:if>
	</c:if>
}
var showGroupInfo=function(){
	$("#groupDetail").load("groupDetail.htm?gid=${group.id}&stype=1");
}
dataInit();
showGroupInfo();
</script>
<script type="text/javascript" src="<%=ctx %>/assets/js/utils/float-calculate.js"></script>
<script type="text/javascript">
	var supplierType = $("#supplierType").val() ;
    $(function(){
        var param = "";
        JAutocompleteEx("#supplierName", "<%=staticPath %>/tourGroup/getSupplier?supplierType=16", param, "supplierId", customerTicketCallback, 1);
        <c:if test='${booking==null }'>
        	$(".itemChk").attr("checked", "checked");
        </c:if>
    });
    function customerTicketCallback(event, value) {
    } 
    
    /**
     * 
     */
    $(function(){		
    		$(".AreaDef").autoTextarea({ minHeight: 80 });
    		
    		$("input.chkAll").each(function(){			
    			$(this).unbind("click").bind("click",function(){
    				var chked = $(this).is(':checked');
    				$(this).closest("table").find("input.itemChk").each(function(){
    					$(this).attr("checked",chked);
    					changeNum(this,chked);
    				})
    			})
    		})
    		if($("#stateFinance").val()==1){
    			 $("#btnSave").attr("disabled","disabled");
    		 }
    		var chkIsAll=function(){
    			$("table.chk_table").each(function(){
    				$(this).find("input.chkAll").attr("checked",$(this).find("input.itemChk").length == $(this).find("input.itemChk:checked").length ? true:false);
    			})			
    		}
    		
    		chkIsAll();
    		
    		$("input.itemChk").click(function(){
    		 	var area = $(this).closest("table");
    			$(area).find("input.chkAll").attr("checked",$(area).find("input.itemChk").length == $(area).find("input.itemChk:checked").length ? true:false);
    			changeNum(this,$(this).is(':checked'));
    		})
    		//var person = {adult:${group.totalAdult==null ? 0:group.totalAdult},child:${group.totalChild==null ? 0:group.totalChild}};	
    		
    		function changeNum(obj,chked){
    			if($(obj).attr("tag")=='num'){
    				var adultnum = parseInt($(obj).attr("adultnum"));
    				var childnum = parseInt($(obj).attr("childnum"));
    				if(chked){
    					person.adult+=adultnum;
    					person.child+=childnum;
    					$("#numAdult").html(person.adult);
    					$("#numChild").html(person.child);					
    				}else{
    					person.adult-=adultnum;
    					person.child-=childnum;
    					$("#numAdult").html(person.adult);
    					$("#numChild").html(person.child);	
    				}
    			}
    		}
    		
    		$("#bookingForm").validate({
    				rules : {
    					'supplierName' : {
    						required : true
    					},
    					'dateArrival' : {
    						required : true
    					}
    				},
    				messages : {
    					'supplierName' : {
    						required : "请选择地接社"
    					},
    					'dateArrival' : {
    						required : "请输入到达日期"

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
    					var priceListArr=new Array();
    					var priceList ={};				
    					if(priceListArr.length>0){
    						priceList=priceListArr[0];
    					}
    					priceList.numTimes = $("#numTimes").val();
    					priceList.unitPrice = $("#unitPrice").val();
    					priceList.totalPrice=$("#totalPrice").val();
    					priceList.remark=$("#remark").val();
    					priceList.numPerson=(person.adult+person.child);
    					if(priceListArr.length>0){
    						priceListArr[0]=priceList;				
    					}else{
    						priceListArr.push(priceList);
    					}
    					var booking={
    						id:$("#bookingId").val(),
    						groupId:$("#groupId").val(),
    						supplierId:$("#supplierId").val(),
    						orderId:$("#orderId").val(),
    						supplierName:$("#supplierName").val(),
    						supplierOrderNo:$("#supplierOrderNo").val(),
    						contact:$("#contact").val(),
    						contactTel:$("#contactTel").val(),
    						contactFax:$("#contactFax").val(),
    						contactMobile:$("#contactMobile").val(),
    						productDesId:$("#productDesId").val(),
    						productDes:$("#productDesId").find("option:selected").text(),
    						personAdult:person.adult,
    						personChild:person.child,
    						personGuide:person.guide,
    						dateArrival:$("#dateArrival").val(),
    						remark:$("#remark").val(),
    						stateBooking:$("#stateBooking").val(),
    						routeList:[],
    						orderList:[],
    						priceList:[]
    					}
    					booking.priceList=priceListArr;
    					
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
    								$.ajax({
    				   					type: 'POST',
    				   					cache:false,
    				   			        url: 'saveBooking.do',
    				   			        dataType: 'json',		        
    				   			        data: {booking:JSON.stringify(booking)},
    				   			        success: function(data) {
    				   			            if (data.sucess == true) {
    							            	//refreshWindow("修改下接社订单","../booking/viewDelivery.htm?gid="+data['groupId']+"&bid="+data['bookingId']);
    				   			            	$.success("保存成功",function(){
    							            	refreshWindow("修改下接社订单","../booking/AYDelivery.htm?gid="+data['groupId']+"&bid="+data['bookingId']);
    				   			            	});

    				   			            }else{
    				   							$.error("操作失败");
    				   						}
    				   			        },
    				   			        error: function(data,msg) {
    				   			            $.error("操作失败"+msg);
    				   			        }
    								})
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
    		$("#impBtn").click(function(){
    			var win=0;
    			var supplierId = $("#supplierId").val().trim() ;
    			if(supplierId==""){
    				layer.msg("请先选择下接社");
    			}else{
    				layer.open({ 
    					type : 2,
    					title : '选择协议项目',
    					closeBtn : false,
    					area : [ '550px', '450px' ],
    					shadeClose : false,
    					content : 'deliveryContract.htm?supplierId='+supplierId,//参数为供应商id
    					btn: ['确定', '取消'],
    					success:function(layero, index){
    						win = window[layero.find('iframe')[0]['name']];
    					},
    					yes: function(index){
    						//manArr返回的是联系人对象的数组
    						var arr = win.getItems();    				
    						if(arr.length==0){
    							alert("请选择项目");
    							return false;
    						}
    				        layer.close(index); 
    				    },cancel: function(index){
    				    	layer.close(index);
    				    }
    				});
    			}
    		});
    	})
    	
    	

    		
    	var show = {
    			agency:function(ctx){
    				var win=0;
    				layer.openSupplierLayer({
    					title : '选择下接社',
                        content : ctx+'/component/supplierList.htm?supplierType=16',
    					callback: function(arr){
                            if(arr.length==0){
                                $.warn("请选择下接社");
                                return false;
                            }

                            /*for(var i=0;i<arr.length;i++){
                             console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
                             }*/
                            $("#supplierName").val(arr[0].name);
                            $("#supplierId").val(arr[0].id);
    					}
    				});
    			},
    			contact:function(ctx){
    				/**
    				 * 先选择供应商，再根据供应商id选择联系人 
    				 */
    				var win=0;
    				var supplierId = $("#supplierId").val().trim() ;
    				if(supplierId==""){
    					layer.msg("请先选择下接社");
    				}else{
    					layer.open({ 
    						type : 2,
    						title : '选择联系人',
    						closeBtn : false,
    						area : [ '550px', '450px' ],
    						shadeClose : false,
    						content : ctx+'/component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
    						btn: ['确定', '取消'],
    						success:function(layero, index){
    							win = window[layero.find('iframe')[0]['name']];
    						},
    						yes: function(index){
    							//manArr返回的是联系人对象的数组
    							var arr = win.getChkedContact();    				
    							if(arr.length==0){
    								alert("请选择联系人");
    								return false;
    							}
    							$("#contact").val(arr[0].name);
    							$("#contactMobile").val(arr[0].mobile);
    							$("#contactTel").val(arr[0].tel);
    							$("#contactFax").val(arr[0].fax);
    							//一般设定yes回调，必须进行手工关闭
    					        layer.close(index); 
    					    },cancel: function(index){
    					    	layer.close(index);
    					    }
    					});
    				}
    			},
    			guest:function(orderId){
    				layer.open({ 
    					type : 2,
    					title : '客人列表',
    					closeBtn : false,
    					area : [ '750px', '450px' ],
    					shadeClose : false,
    					content : 'guestList.htm?orderId='+orderId,
    					btn: ['确定', '取消'],
    					success:function(layero, index){
    						win = window[layero.find('iframe')[0]['name']];
    					},
    					yes: function(index){				
    						//一般设定yes回调，必须进行手工关闭
    				        layer.close(index); 
    				    },cancel: function(index){
    				    	layer.close(index);
    				    }
    				});
    			},
    			traffic:function(orderId){
    				layer.open({ 
    					type : 2,
    					title : '接送列表',
    					closeBtn : false,
    					area : [ '850px', '450px' ],
    					shadeClose : false,
    					content : 'transportList.htm?orderId='+orderId,
    					btn: ['确定', '取消'],
    					success:function(layero, index){
    						win = window[layero.find('iframe')[0]['name']];
    					},
    					yes: function(index){				
    						//一般设定yes回调，必须进行手工关闭
    				        layer.close(index); 
    				    },cancel: function(index){
    				    	layer.close(index);
    				    }
    				});
    			}		
    		}
    	
    // 人数 numperson 还要不要？
	$("input[id='unitPrice']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice']").val();
		 var numTimes = $("input[id='numTimes']").val();
		 var numPerson =$("input[id='numPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes);
		 $("input[id='totalPrice']").val(isNaN(total)? 0:total);
	});  
	$("input[id='numTimes']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice']").val();
		 var numTimes = $("input[id='numTimes']").val();
		 var numPerson =$("input[id='numPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes);
		 $("input[id='totalPrice']").val(isNaN(total)? 0:total);
	});  
</script>
</html>

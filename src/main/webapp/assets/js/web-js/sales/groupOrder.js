function toToutGroupList(){
	window.location = "../tourGroup/findTourGroupByCondition.htm" ;
}

function toGroupOrder(){
	window.location = "../tourGroup/toAddTourGroupOrder.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
}
function toOtherInfo(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../tourGroup/toOtherInfo.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}
function togroupRequirement(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../tourGroup/togroupRequirement.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}

function toGetRouteList(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../groupRoute/toGetRouteList.htm?orderId="+$("#orderId").val()+"&groupId="+$("#groupId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}
$(function() {
	/**
	 * 旅行团订单保存
	 */
	$("#groupOrderForm").validate({
		rules : {
			'dateStart' : {
				required : true
			},
			'receiveMode':{
				required : true
			},
			'totalAdult' : {
				required : true,
				digits : true 
			},
			'totalChild' : {
				required : true,
				digits : true
			},
			'totalGuide' : {
				required : true,
				digits : true
			},
			'supplierName' : {
				required : true
			},
			'contactName' : {
				required : true
			}
		},
		errorPlacement : function(error, element) {
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) {
				error.appendTo(element.parent()); 
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var options = {
				url : "saveTourGroupOrder.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.id!=null) {
						$.success('保存成功') ;
						/*$("#orderId").val(data.id);
						$("#groupId").val(data.groupId);*/
						refreshWindow('修改订单','toAddTourGroupOrder.htm?orderId='+data.id) ;
					} else {
						$.warn('服务忙，请稍后再试', {
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
	/**
	 * 分页查询
	 */
	var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
	 $("#tourGroupStartTime").val(vars.dateFrom);
	 $("#tourGroupEndTime").val(vars.dateTo );	
	
	queryList();
	$("selA").hide();
});
/**
 * 页面选择部分调用函数(单选)
 */
function selectUser(num){
	var win=0;
	layer.open({
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.warn("请选择人员");
				return false;
			}
			//销售计调
			if(num==1){
				$("#saleOperatorId").val(userArr[0].id);
				$("#saleOperatorName").val(userArr[0].name);
			}
			//操作计调
			if(num==2){
				$("#operatorId").val(userArr[0].id);
				$("#operatorName").val(userArr[0].name);
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
/**
 * 页面选择部分调用函数(多选)
 */
function selectUserMuti(num){
	
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList();   
			
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				//console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
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
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
	/*$("#tourGroupStartTime").val("");
	$("#tourGroupEndTime").val("");
	$("#tourGroupGroupCode").val("");
	$("#tourGroupProductName").val("");*/
}
/**
 * 先选择供应商，再根据供应商id选择联系人 
 */
function selectContact(){
	var win=0;
	var supplierId = $("#supplierId").val().trim() ;
	if(supplierId==""){
		$.warn("未选择组团社");
	}else{
		layer.open({ 
			type : 2,
			title : '选择联系人',
			shadeClose : true,
			shade : 0.5,
			//offset : [th,lh],
			area : ['550px', '400px'],
			content : '../component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var arr = win.getChkedContact();    				
				if(arr.length==0){
					$.warn("请选择联系人");
					return false;
				}
				$("#contactName").val(arr[0].name);
				$("#contactMobile").val(arr[0].mobile);
				$("#contactTel").val(arr[0].tel);
				$("#contactFax").val(arr[0].fax);
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}
}
/**
 * 选择组团社
 */
function selectSupplier(){
	
	layer.openSupplierLayer({
		title : '选择组团社',
		content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选组团社");
				return false;
			}
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
			/**
			 * 每次选择完组团社后将联系人相关部分数据清空
			 */
			$("#contactName").val("");
			$("#contactMobile").val("");
			$("#contactTel").val("");
			$("#contactFax").val("");
	    }
	});
}

/**
 * 分页查询
 * @param page 
 * @param pageSize
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#orderPage").val(page);
	$("#orderPageSize").val(pageSize);

	var options = {
		url:"../teamGroup/findTourGroupLoadModel.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#tourGroupForm").ajaxSubmit(options);	
}

function searchBtn() {
	var pageSize=$("#orderPageSize").val();
	queryList(1,pageSize);
}
function refreshCurrentPage() {
	var page=$("#orderPage").val();
	var pageSize=$("#orderPageSize").val();
	queryList(page,pageSize);
}
/**
 * 删除订单
 * @param orderId 订单id
 * @param groupId 团id
 * @param stateFinance 财务审核状态
 */
function deleteGroupOrderById(orderId,groupId){
	$.confirm("确认删除吗？", function() {
		$.getJSON("deleteGroupOrderById.do?orderId=" + orderId+"&groupId="+groupId, function(data) {
			if (data.success) {
				/*$.success('操作成功');
				window.location = window.location;*/
				 $.success('操作成功', function(){
					 refreshCurrentPage();
	             });
			}else{
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});
	/*if(stateFinance==1){
		//
	}else {
		$.info("财务未审核") ;
	}*/
	
};

/**
 * 更改团状态
 * state==0时代表未确认状态，需要查询该订单下是否维护了成本价格
 * @param state 
 */
var stateIndex;
function changeGroupState(groupId,state){
	if(state==0){
		$.getJSON("../budgetItem/getTotalBudgetByOrderId.do?id=" + groupId ,function(data) {
			if (data.success) {
				$("#modalgroupId").val(groupId);
				$("#modalGroupState").val(state);
				optionState(state);
				layer.open({
					type : 1,
					title : '修改状态',
					shadeClose : true,
					shade : 0.5,
			        area : ['350px','210px'],
					content : $('#stateModal')
				});
			}else{
				$.warn(data.msg);
			}
		});
	}else{
		$("#modalgroupId").val(groupId);
		$("#modalGroupState").val(state);
		optionState(state);
		stateIndex=layer.open({
			type : 1,
			title : '修改状态',
			shadeClose : true,
			shade : 0.5,
	        area : ['350px','210px'],
			content : $('#stateModal')
		});
	}
};
function optionState(state){
	var sltState = document.getElementById("modalGroupState");
	
	while (sltState.firstChild) {
		sltState.removeChild(sltState.firstChild); 
	}
	if(state==0){
		var option1 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);	
	}else if(state==1){
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);
	}else if(state==2){
		var option1 = new Option("未确认", "0");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option2);
	}
}

/**
 * 跳到信息编辑页面
 */
function editOrderGroupInfo(){
	var groupId = $("#modalgroupId").val();
	var groupState = $("#modalGroupState").val();
	$.getJSON("../groupOrder/editOrderGroupInfo.do?id=" + groupId +"&groupState="+groupState, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				layer.close(stateIndex);
				refreshCurrentPage();
				
			});
			
		}
	});
}

/**
 * 订单打印
 * @param orderId 订单id
 */
function printOrder(orderId,state,groupId){
	if(state==0 || state == 2){
		$("#saleOrder").hide() ;
		$("#saleCharge").hide() ;
		$("#saleChargeNoRoute").hide() ;
		$("#saleOrderNoRoute").hide() ;
		$("#tddyd").hide() ;
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}else{
		$("#saleOrder").show() ;
		$("#saleCharge").show() ;
		$("#saleChargeNoRoute").show() ;
		$("#saleOrderNoRoute").show() ;
		$("#tddyd").show() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
		$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
		$("#tddyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //导游行程单
		//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num=7") ; //游客反馈意见单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
        area : ['400px','350px'],
		content : $('#exportWord')
	});
};

/**
 * 订单打印-组团社
 * @param orderId 订单id
 */
function printOrderAgency(orderId,state,groupId){
	if(state==0 || state == 2){
		$("#saleOrder").show() ;
		$("#saleCharge").hide() ;
		$("#saleChargeNoRoute").hide() ;
		$("#saleOrderNoRoute").hide() ;
		$("#tddyd").hide() ;
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}else{
		$("#saleOrder").show() ;
		$("#saleCharge").show() ;
		$("#saleChargeNoRoute").show() ;
		$("#saleOrderNoRoute").show() ;
		$("#tddyd").show() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
		$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
		$("#tddyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //导游行程单
		//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num=7") ; //游客反馈意见单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
        area : ['400px','350px'],
		content : $('#exportWord')
	});
};

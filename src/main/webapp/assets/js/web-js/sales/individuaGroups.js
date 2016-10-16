//散客团业务js
/**
 * 散客订单编辑时增加客人信息
 */
function toAddGuest(){
	
	if($("#allowNum").val()<1){
		$.warn("库存不足");
		return ;
	}

	
	$("#modalGuestId").val('');
	$("#guestName").val('');
	$("#guestCertificateNum").val('');
	$("#guestAge").val('');
	$("#guestMobile").val('');
	$("#guestNativePlace").val('');
	$("#guestCareer").val('');
	$("#guestRemark").val('');
	
	layer.open({
		type : 1,
		title : '新增客人信息',
		shadeClose : true,
		shade : 0.5,
		// area : [ '40%', '60%' ],
		area : [{minLength : '1100px', areas : ['620px', '460px']}, { maxLength : '1100px', areas : ['480px', '460px']}],
		content : $('#guestModal')
	});
	
}





/**
 * 选择联系人
 */
function selectContact(){
	
			var supplierId=$("input[name='groupOrder.supplierId']").val();
			if(supplierId==''){
				$.error('请先选择组团社');
				return
			}
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择联系人',
    			closeBtn : false,
    			area : [ '550px', '450px' ],
    			shadeClose : false,
    			content : '../component/contactMan.htm?supplierId='+supplierId,// 参数为供应商id
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				// manArr返回的是联系人对象的数组
    				var arr = win.getChkedContact();    				
    				if(arr.length==0){
    					$.error('请选择联系人')
    					return false;
    				}
    				
    				for(var i=0;i<arr.length;i++){
    					$("input[name='groupOrder.contactName']").val(arr[i].name);
    					$("input[name='groupOrder.contactTel']").val(arr[i].tel);
    					$("input[name='groupOrder.contactMobile']").val(arr[i].mobile);
    					$("input[name='groupOrder.contactFax']").val(arr[i].fax);
    				}
    				// 一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
/**
 * 选择供应商
 */
function selectSupplier(){
    		layer.openSupplierLayer({
    			title : '选择组团社',
    			content : getContextPath() +  '/component/supplierList.htm?type=single&supplierType=1',// 参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
    			callback: function(arr){
    				if(arr.length==0){
    					$.warn('请选择供应商');
    					return false;
    				}
    				
    				for(var i=0;i<arr.length;i++){
    					// console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
						$("input[name='groupOrder.supplierId']").val(arr[i].id);
						$("#supplierName").val(arr[i].name);
    				}
    		    }
    		});
    	}
/**
 * 选择计调
 */
function selectUser(){
    		var win;
    		layer.open({ 
    			type : 2,
    			title : '选择人员',
    			area : [ '400px', '470px' ],
    			shadeClose : false,
    			content : '../component/orgUserTree.htm',// 单选地址为orgUserTree.htm，多选地址为
    			btn: ['确定', '取消'],
    			success:function(layero, index){
    				win = window[layero.find('iframe')[0]['name']];
    			},
    			yes: function(index){
    				// userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
    				var userArr = win.getUserList();    				
    				if(userArr.length==0){
    					$.error('请选择人员')
    					return false;
    				}
    				
    				for(var i=0;i<userArr.length;i++){
    					// console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
    					$("input[name='groupOrder.saleOperatorName']").val(userArr[i].name);
    					$("input[name='groupOrder.saleOperatorId']").val(userArr[i].id);
    				}
    				// 一般设定yes回调，必须进行手工关闭
    		        layer.close(index); 
    		    },cancel: function(index){
    		    	layer.close(index);
    		    }
    		});
    	}
/**
 * 客人信息弹出
 */
function  toEditGuest(id){
	$.getJSON("toEditGroupGuest.htm?id=" + id, function(data) {
		$("#modalGuestId").val(data.id);
		$("#guestName").val(data.name);
		$("#guestCertificateTypeId").val(data.certificateTypeId);
		$("#guestGender").val(data.gender);
		$("#guestCertificateNum").val(data.certificateNum);
		$("#guestAge").val(data.age);
		$("#guestMobile").val(data.mobile);
		$("#guestNativePlace").val(data.nativePlace);
		$("#guestIsSingleRoom").val(data.isSingleRoom);
		$("#guestCareer").val(data.career);
		$("#guestIsLeader").val(data.isLeader);
		$("#guestType").val(data.type);
		$("#guestRemark").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		// area : [ '40%', '60%' ],
		area : [{minLength : '1100px', areas : ['620px', '460px']}, { maxLength : '1100px', areas : ['480px', '460px']}],
		content : $('#guestModal')
	});
}

/**
 * 删除客人信息
 */
function delGuest(id){
	$.confirm("确认删除吗？", function() {
		$.getJSON("delGroupGuest.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功');
				window.location = window.location;
			}

		});
	}, function() {
		$.info('取消删除');
	})
	
	
}
/**
 * 弹出层计调-机票
 */
function toAddAirticket() {
	$("#modalAirticketId").val('');
	$("#airticketRequireDate").val('');
	$("#airticketClassNo").val('');
	$("#airticketCityDeparture").val('');
	$("#airticketCityArrival").val('');
	$("#airticketCountRequire").val('');
	$("#airticketRemark").val('');

	layer.open({
		type : 1,
		title : '新增信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '450px' ],
		content : $('#airticketModal')
	});

}

/**
 * 弹出层计调-获取机票信息
 */
function toEditAirticket(id) {
	$.getJSON("toEditGroupRequirement.htm?id=" + id, function(data) {
		$("#modalAirticketId").val(data.id);
		$("#airticketRequireDate").val(data.requireDate);
		$("#airticketClassNo").val(data.classNo);
		$("#airticketCityDeparture").val(data.cityDeparture);
		$("#airticketCityArrival").val(data.cityArrival);
		$("#airticketCountRequire").val(data.countRequire);
		$("#airticketRemark").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '450px' ],
		content : $('#airticketModal')
	});

}

/**
 * 弹出层计调-获取火车票信息
 */
function toEditTrainticket(id) {
	$.getJSON("toEditGroupRequirement.htm?id=" + id, function(data) {
		$("#modalTrainticketId").val(data.id);
		$("#trainticketRequireDate").val(data.requireDate);
		$("#trainticketClassNo").val(data.classNo);
		$("#trainticketCityDeparture").val(data.cityDeparture);
		$("#trainticketCityArrival").val(data.cityArrival);
		$("#trainticketCountRequire").val(data.countRequire);
		$("#trainticketRemark").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '450px' ],
		content : $('#trainticketModal')
	});

}

/**
 * 弹出层计调-火车票
 */
function toAddTrainticket() {
	$("#modalTrainticketId").val('');
	$("#trainticketRequireDate").val('');
	$("#trainticketClassNo").val('');
	$("#trainticketCityDeparture").val('');
	$("#trainticketCityArrival").val('');
	$("#trainticketCountRequire").val('');
	$("#trainticketRemark").val('');

	layer.open({
		type : 1,
		title : '新增信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '450px' ],
		content : $('#trainticketModal')
	});

}
/**
 * 弹出层计调-酒店
 */
function toAddRest() {
	$("#modalRestaurantId").val('');
	$("#restRequireDate").val('');
	$("#restArea").val('');
	$("#restCountSingleRoom").val('0');
	$("#restCountDoubleRoom").val('0');
	$("#restCountTripleRoom").val('0');
	$("#restRemark").val('');

	layer.open({
		type : 1,
		title : '新增信息',
		shadeClose : true,
		shade : 0.5,
		area : ['400px', '500px'],
		content : $('#restaurantModal')
	});

}
/**
 * 弹出层计调-获取酒店信息
 */
function toEditRest(id) {
	$.getJSON("toEditGroupRequirement.htm?id=" + id, function(data) {
		$("#modalRestaurantId").val(data.id);
		$("#restRequireDate").val(data.requireDate);
		$("#restArea").val(data.area);
		$("#restHotelLevel").val(data.hotelLevel);
		$("#restCountSingleRoom").val(data.countSingleRoom);
		$("#restCountDoubleRoom").val(data.countDoubleRoom);
		$("#restCountTripleRoom").val(data.countTripleRoom);
		$("#restExtraBed").val(data.extraBed);
		$("#restPeiFang").val(data.peiFang);
		$("#restRemark").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		area : ['400px', '500px'],
		content : $('#restaurantModal')
	});

}

/**
 * 删除计调信息
 */

function delTransfer(id) {
	$.confirm("确认删除吗？", function() {
		$.getJSON("delGroupRequirement.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功');
				window.location = window.location;
			}

		});
	}, function() {
		$.info('取消删除');
	})

}

/**
 * 弹出接送信息层
 */
function toAddTransport() {
	$("#modalTransportId").val('');
	$("#sourceType").val('');
	$("input[name='classNo']").val('');
	$("input[name='departureCity']").val('');
	$("input[name='departureStation']").val('');
	$("input[name='departureDate']").val('');
	$("input[name='departureTime']").val('');
	$("input[name='arrivalCity']").val('');
	$("input[name='arrivalStation']").val('');
	//$("input[name='arrivalTime']").val('');
	$("input[name='destination']").val('');

	layer.open({
		type : 1,
		title : '新增信息',
		shadeClose : true,
		shade : 0.5,
		 area : ['450px','480px'],
		content : $('#transportModal')
	});
}

/**
 * 获取被修改接送信息数据
 * 
 * @param id
 */
function toEditTransport(id) {
	$.getJSON("toEditGroupOrderTransport.htm?id=" + id, function(data) {
		$("#modalTransportId").val(data.id);
		$("#sourceType").val(data.sourceType);
		$("#transportMethod").val(data.method);
		$("input[name='type'][value=" + data.type + "]").attr("checked", true);
		$("input[name='classNo']").val(data.classNo);
		$("input[name='departureCity']").val(data.departureCity);
		$("input[name='departureDate']").val(data.departureDate);
		$("input[name='departureTime']").val(data.departureTime);
		$("input[name='arrivalCity']").val(data.arrivalCity);
		//$("input[name='arrivalTime']").val(data.arrivalTime);
		$("input[name='destination']").val(data.destination);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		area : ['450px', '480px'],
		content : $('#transportModal')
	});

}

function delTransport(id) {
	$.confirm("确认删除吗？", function() {
		$.getJSON("delGroupOrderTransport.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功');
				window.location = window.location;
			}

		});
	}, function() {
		$.info('取消删除');
	})

}

/**
 * 删除价格信息
 */
function delOrderPrice(id) {

	$.confirm("确认删除吗？", function() {
		$.getJSON("delOrderPrice.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功');
				window.location = window.location;
			}

		});
	}, function() {
		$.info('取消删除');
	})

}

/**
 * 弹出价格添加页面
 */
function toAddCost(mode) {
	$("#modalPriceId").val('');
	$("#priceRemark").val('');
	$("input[name='unitPrice']").val('0');
	$("input[name='numTimes']").val('1');
	$("input[name='numPerson']").val('1');
	$("input[name='totalPrice']").val('0');
	$("input[name='mode']").val(mode);
	layer.open({
		type : 1,
		title : '新增信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '500px', '440px' ],
		content : $('#costModal')
	});

}
/**
 * 获取被修改价格数据
 * 
 * @param id
 */
function toEditCost(id) {
	$.getJSON("toEditGroupOrderPrice.htm?id=" + id, function(data) {
		$("#costItemName").val(data.itemId);
		$("#modalPriceId").val(data.id);
		$("input[name='mode']").val(data.mode);
		$("input[name='rowState']").val(data.rowState);
		$("#priceRemark").val(data.remark);
		$("input[name='unitPrice']").val(data.unitPrice);
		$("input[name='numTimes']").val(data.numTimes);
		$("input[name='numPerson']").val(data.numPerson);
		$("input[name='totalPrice']").val(data.totalPrice);
	});
	layer.open({
		type : 1,
		title : '修改信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '500px', '440px' ],
		content : $('#costModal')
	});

}

/**
 * 生成大人小孩table
 */
function makeTable() {
	
	if($("#supplierId").val()==''){
		$.warn("请先选择组团社");
		$("input[name='groupOrder.numAdult']").val('0');
		$("input[name='groupOrder.numChild']").val('0');
		return ;
	}
	
	
	var allowNum =$("#allowNum").val();
	
	var adultNum = $("input[name='groupOrder.numAdult']").val();
	var childNum = $("input[name='groupOrder.numChild']").val();
	
	
	
	if((Number(adultNum)+Number(childNum))>Number(allowNum)){
		$.warn('余位不足');
		return ;
	}
	
	
	var adulthtml = "";
	var html1 = $('#tbodyAdult').html();
	for (int = 0; int < adultNum; int++) {
		adulthtml = adulthtml + html1.replace(/\$index/g, int);
	}
	$('#numAdult').html(adulthtml);

	var html2 = $('#tbodyChild').html();
	var childhtml = "";
	var childNum = Number(childNum) + Number(adultNum);
	for (int; int < childNum; int++) {
		childhtml = childhtml + html2.replace(/\$index/g, int);
	}
	$('#numChild').html(childhtml);

}


function automatic(value,count){
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	$("input[name='groupOrderGuestList["+count+"].nativePlace']").val('');
	$("input[name='groupOrderGuestList["+count+"].age']").val('');
	value=value.toUpperCase();
	if (reg.test(value) === true) { // 如果是身份证
			var card=$.parseIDCard(value);
			$("input[name='groupOrderGuestList["+count+"].nativePlace']").val(card.birthPlace);
			$("input[name='groupOrderGuestList["+count+"].age']").val(card.age);	
			$("select[name='groupOrderGuestList["+count+"].gender']").val(card.gender=='男'?1:0);
	}
	}
	
	
	
	


$(function() {

	/**
	 * 计算价格总额
	 */

	$("input[name='unitPrice']").on(
			'input',
			function(e) {
				var unitPrice = $("input[name='unitPrice']").val();
				var numTimes = $("input[name='numTimes']").val();
				var numPerson = $("input[name='numPerson']").val();
				var total = (unitPrice == '' ? '1' : unitPrice)
						* (numTimes == '' ? '1' : numTimes)
						* (numPerson == '' ? '1' : numPerson);
				$("input[name='totalPrice']").val(isNaN(total)?"0":total);
			});
	$("input[name='numTimes']").on(
			'input',
			function(e) {
				var unitPrice = $("input[name='unitPrice']").val();
				var numTimes = $("input[name='numTimes']").val();
				var numPerson = $("input[name='numPerson']").val();
				var total = (unitPrice == '' ? '1' : unitPrice)
						* (numTimes == '' ? '1' : numTimes)
						* (numPerson == '' ? '1' : numPerson);
				$("input[name='totalPrice']").val(isNaN(total)?"0":total);
			});
	
	$("input[name='numPerson']").on(
			'input',
			function(e) {
				var unitPrice = $("input[name='unitPrice']").val();
				var numTimes = $("input[name='numTimes']").val();
				var numPerson = $("input[name='numPerson']").val();
				var total = (unitPrice == '' ? '1' : unitPrice)
						* (numTimes == '' ? '1' : numTimes)
						* (numPerson == '' ? '1' : numPerson);
				$("input[name='totalPrice']").val(isNaN(total)?"0":total);
			});
	
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
	$("input[name='certificateNum']").on('input',
			function(e) {
				var guestCertificateNum = $("input[name='certificateNum']").val();
				if (reg.test(guestCertificateNum) === true) {
					guestCertificateNum=guestCertificateNum.toUpperCase();
					var card = new Card(guestCertificateNum);
					card.init(function(data){
						$("#guestAge").val(data.age);
						$("#guestNativePlace").val(data.addr);
						if(data.sex=='男'){
							$("input[id='guestGender'][value=1]").attr("checked", "checked");
						}else{
							$("input[id='guestGender'][value=0]").attr("checked", "checked");
						}
					});
					
				}
			});
	
	
	
	/**
	 * 编辑客人信息
	 */
	$("#guestInfoForm").validate(
			{
				rules : {
					'name' : {
						required : true
					},
					'certificateNum' : {
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
						url : 'editGroupGuest.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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
	
	
	
	/**
	 * 新增计调信息[火车票]
	 */
	$("#trainticketInfoForm").validate(
			{
				rules : {
					'requireDate' : {
						required : true
					},
					'classNo' : {
						required : true
					},
					'cityDeparture' : {
						required : true
					},
					'cityArrival' : {
						required : true
					},
					'countRequire' : {
						digits : true
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
					var guestId = $("#modalTrainticketId").val();
					var url = "addGroupRequirement.do";
					if (guestId != '') {
						url = "editGroupRequirement.do";
					}
					var options = {
						url : url,
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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

	/**
	 * 新增计调信息[机票]
	 */
	$("#airticketInfoForm").validate(
			{
				rules : {
					'requireDate' : {
						required : true
					},
					'classNo' : {
						required : true
					},
					'cityDeparture' : {
						required : true
					},
					'cityArrival' : {
						required : true
					},
					'countRequire' : {
						digits : true
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
					var guestId = $("#modalAirticketId").val();
					var url = "addGroupRequirement.do";
					if (guestId != '') {
						url = "editGroupRequirement.do";
					}
					var options = {
						url : url,
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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

	/**
	 * 新增计调信息[酒店]
	 */
	$("#restaurantInfoForm").validate(
			{
				rules : {
					'requireDate' : {
						required : true
					},
					'area' : {
						required : true
					},
					'countSingleRoom' : {
						digits : true
					},
					'countDoubleRoom' : {
						digits : true
					},
					'countTripleRoom' : {
						digits : true
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
					var guestId = $("#modalRestaurantId").val();
					var url = "addGroupRequirement.do";
					if (guestId != '') {
						url = "editGroupRequirement.do";
					}
					var options = {
						url : url,
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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

	/**
	 * 新增接送信息
	 */

	$("#transportInfoForm").validate(
			{
				rules : {
					/*'departureCity' : {
						required : true
					},
					'arrivalCity' : {
						required : true
					}*/
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
					var guestId = $("#modalTransportId").val();
					var url = "addGroupOrderTransport.do";
					if (guestId != '') {
						url = "editGroupOrderTransport.do";
					}
					var options = {
						url : url,
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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
	/**
	 * 新增价格信息
	 */

	$("#costInfoForm").validate(
			{
				rules : {
					'unitPrice' : {
						required : true,
						number : true
					},
					'numTimes' : {
						required : true,
						digits : true

					},
					'numPerson' : {
						required : true,
						digits : true
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
					var guestId = $("#modalPriceId").val();
					var url = "addGroupOrderPrice.do";
					if (guestId != '') {
						url = "editGroupOrderPrice.do";
					}
					var options = {
						url : url,
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
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

	/**
	 * 新增散客团订单
	 */
	$("#saveOrderForm").validate(
			{
				rules : {
					'groupOrder.productName' : {
						required : true
					},
					'groupOrder.supplierName' : {
						required : true
					},
					'groupOrder.saleOperatorId' : {
						required : true
					},
					'groupOrder.contactName' : {
						required : true

					},'groupOrder.receiveMode' : {
						required : true

					},
					'groupOrder.numAdult' : {
						required : true,
						digits : true
					},
					'groupOrder.numChild' : {
						required : true,
						digits : true
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
					
					var allowNum =$("#allowNum").val();
					
					var adultNum = $("input[name='groupOrder.numAdult']").val();
					var childNum = $("input[name='groupOrder.numChild']").val();
					
					if(adultNum==0 && childNum==0){
						$.warn('客人数不能都为0');
						return ;
					}
					if (!checkGuestList()){
						return ;
					}
					
					if((Number(adultNum)+Number(childNum))>Number(allowNum)){
						$.warn('余位不足');
						return ;
					}
					
					
					
					
					var options = {
						url : "addGroupOrder.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success('操作成功,请到散客订单管理页面查看！',function(){
									//refreshWindow('散客订单','toNotGroupList.htm?pageSize=10&page=1')
									closeWindow();
								});
							} else {
								$.error(data.msg);

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
	
});


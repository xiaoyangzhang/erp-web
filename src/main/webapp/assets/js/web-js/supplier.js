$(function(){
	$("#ulSel li span[class='pop_check_del']").bind("click", function(){
		var id = $(this).parent().attr("sid") ;
		if(id!='0'){
			jQuery.ajax({
				url : "../supplier/deleteSupplierItem.htm",
				type : "post",
				async : false,
				data : {
					"id" : id
				},
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('删除成功',function(){searchBtn();});
					} else {
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
					window.location = window.location;
				}
			});
		}
		supplierItem_remove(this);
	});
})
function supplierItem_remove(obj){
	$(obj).parent().remove();
}


function supplierItem_new(){
	var item = $("#txt_newItem").val();
	if (item == ""){
		$.info('请输入项目名称');
		return;
	}
	//检查是否重复
	var isExists = false;
	$("#ulSel li").each(function(){
		if ($(this).attr("sname") == item){
			$.info('项目重复，请勿重复添加！');
			isExists = true;
		}
	});
	if (isExists) return;
	
	$("#ulSel").append("<li sid='0' sname='"+item+"'>"+item+"<span class='pop_check_del' onclick='supplierItem_remove(this)'></span></li>");
	$("#txt_newItem").val('');
}

function supplierItem_get(){
	var str = "";
	$("#ulSel li").each(function(){
		if($(this).attr("sid")=='0'){
			str += (str==''?'':',')+$(this).attr("sname");
		}
	});
	return str;
}

$(function() {

	$("#provinceCode").change(
			function() {
				var text = $("#provinceCode").find("option:selected").text();
				if(text!='请选择省'){
					$("#pValue").html(text);
				}
				
				$("#cValue").html("");
				$("#aValue").html("");
				$("#tValue").html("");
				$("#cityCode").html("<option value=''>请选择市</option>");
				$("#areaCode").html("<option value=''>请选择区县</option>");
				$("#townCode").html("<option value=''>请选择街道</option>");
				if($("#provinceCode").val()!=''){
				$.getJSON("../basic/getRegion.do?id="
						+ $("#provinceCode").val(), function(data) {
					data = eval(data);
					var s = "<option value=''>请选择市</option>";
					$.each(data, function(i, item) {
						s += "<option value='" + item.id + "'>" + item.name
								+ "</option>";
					});
					$("#cityCode").html(s);

				});
				}

			});

	$("#cityCode").change(
			function() {
				var text = $("#cityCode").find("option:selected").text();
				if(text!='请选择市'){
					$("#cValue").html(text);
				}
				$("#aValue").html("");
				$("#tValue").html("");
				$("#areaCode").html("<option value=''>请选择区县</option>");
				$("#townCode").html("<option value=''>请选择街道</option>");
				if($("#cityCode").val()!=''){
				$.getJSON("../basic/getRegion.do?id=" + $("#cityCode").val(),
						function(data) {
							data = eval(data);
							var s = "<option value=''>请选择区县</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>"
										+ item.name + "</option>";
							});
							$("#areaCode").html(s);

						});
			}

			});
	$("#areaCode").change(
			function() {
				var text = $("#areaCode").find("option:selected").text();
				if(text!='请选择区县'){
					$("#aValue").html(text);
				}
				$("#tValue").html("");
				$("#townCode").html("<option value=''>请选择街道</option>");
				if($("#areaCode").val()!=''){
				$.getJSON("../basic/getRegion.do?id=" + $("#areaCode").val(),
						function(data) {
							data = eval(data);
							var s = "<option value=''>请选择街道</option>";
							$.each(data, function(i, item) {
								s += "<option value='" + item.id + "'>"
										+ item.name + "</option>";
							});
							$("#townCode").html(s);

						});}
			});
	
	$("#townCode").change(
			function() {
				var text = $("#townCode").find("option:selected").text();
				if(text!='请选择街道'){
					$("#tValue").html(text);
				}
				
				
			})

	$("#saveSupplierForm").validate(
			{
				rules : {
					'nameFull' : {
						required : true,
						remote : { // 验证手机号码是否存在
							type : "POST",
							url : "verifyNameFull.do",
							data : {
								supplierId : '',
								supplierType : function() {
									return $("input[name='supplierType']").val();
								},
								nameFull : function() {
									return $("input[name='nameFull']").val();
								}
							}
						}
					},
					'nameShort' : {
						required : true
					},
					'lawPerson' : {
						required : true
					}
				},
				messages : {
					'nameFull' : {
						required : "请输入全称",
						remote:"已存在此供应商名称,请导入"

					},
					'nameShort' : {
						required : "请输入简称"
					},
					'lawPerson' : {
						required : "请输入法人"

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
						url : "saveSupplier.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success('操作成功',function(){
                                    refreshWindow('修改供应商', path + '/supplier/toEditSupplier.htm?id=' + data["id"] + '&operType=1');
									//var map = ['toTravelagencyList.htm', 'toRestaurantList.htm', 'toHotelList.htm', 'toFleetList.htm',
									//   		'toScenicspotList.htm', 'toShoppingList.htm', 'toEntertainmentList.htm', '', 'toAirticketagentList.htm', 'toTrainticketagentList.htm', 'toGolfList.htm', 'toOtherList.htm'];
									//window.location="../supplier/"+map[$("input[name='supplierType']").val() - 1];
								});
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					};
					$("#items").val(supplierItem_get()) ;
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 修改餐厅
	 */
	$("#editSupplierForm").validate(
			{
				rules : {
					'nameFull' : {
						required : true,
						remote : { 
							type : "POST",
							url : "verifyNameFull.do",
							data : {
								supplierId :  function() {
									return $("input[name='id']").val();
								},
								supplierType : function() {
									return $("input[name='supplierType']").val();
								},
								nameFull : function() {
									return $("input[name='nameFull']").val();
								}
							}
						}
					},
					'nameShort' : {
						required : true
					},
					'lawPerson' : {
						required : true
					}
				},
				messages : {
					'nameFull' : {
						required : "请输入全称",
						remote:"已存在此供应商名称,请导入"

					},
					'nameShort' : {
						required : "请输入简称"
					},
					'lawPerson' : {
						required : "请输入法人"
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
						url : "editSupplier.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								
								$.success('操作成功',function(){
									window.location = window.location;
								});
						
							} else {
								
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$("#items").val(supplierItem_get()) ;
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 增加银行信息
	 */
	$("#saveBankInfo").validate(
			{
				rules : {
					'bankAccount' : {
						required : true
					},
					'accountName' : {
						required : true
					},
					'accountNo' : {
						required : true
					}
				},
				messages : {
					'bankAccount' : {
						required : "请输入开户行",

					},
					'accountName' : {
						required : "请输入开户名"
					},
					'accountNo' : {
						required : "请输入帐号"
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
						url : "addBankInfo.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
							
								$.success('操作成功',function(){
								window.location = window.location;
								})
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 修改银行信息
	 */
	$("#editBankInfo").validate(
			{
				rules : {
					'bankAccount' : {
						required : true
					},
					'accountName' : {
						required : true
					},
					'accountNo' : {
						required : true
					}
				},
				messages : {
					'bankAccount' : {
						required : "请输入开户行",

					},
					'accountName' : {
						required : "请输入开户名"
					},
					'accountNo' : {
						required : "请输入帐号"
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
						url : "editBankInfo.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success("操作成功",function(){
								window.location = window.location;
								});
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 增加发票信息
	 */
	$("#saveBillInfo").validate(
			{
				rules : {
					'billName' : {
						required : true
					}
				},
				messages : {
					'billName' : {
						required : "请输入名称"

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
						url : "addBillInfo.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success("操作成功",function(){
									window.location = window.location;	
								});
								
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 修改发票信息
	 */
	$("#editBillInfo").validate(
			{
				rules : {
					'billName' : {
						required : true
					}
				},
				messages : {
					'billName' : {
						required : "请输入名称",

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
						url : "editBillInfo.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success("操作成功",function(){
									window.location = window.location;
								});
								
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 增加联系人
	 */
	$("#saveManInfoForm").validate(
			{
				rules : {
					'name' : {
						required : true
					},
					'mobile' : {
						required : true,
						isMobile : true
//						remote : { // 验证手机号码是否存在
//							type : "POST",
//							url : "verifyMobile.do",
//							data : {
//								manId :'',
//								mobile : function() {
//									return $("input[name='mobile']").val();
//								}
//							}
//						}
					},
					'qq':{
						isQQ:true
					},
					'email':{
						email:true 
					},
					'note':{
						maxlength:300
					}
				},
				messages : {
					'name' : {
						required : "请输入姓名",

					},
					'mobile' : {
						required : "请输入手机号码",
						isMobile : "请输入正确的手机号码",
						remote : "该手机号码已存在"
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
						url : "addContactMan.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success("操作成功",function(){
									window.location = window.location;
								});
								
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

	/**
	 * 编辑联系人
	 */
	$("#editManInfoForm").validate(
			{
				rules : {
					'name' : {
						required : true
					},
					'mobile' : {
						required : true,
						isMobile : true
//						remote : { // 验证手机号码是否存在
//							type : "POST",
//							url : "verifyMobile.do",
//							data : {
//								manId : function() {
//									return $("#manId").val();
//								},
//								mobile : function() {
//									return $("#manMobile").val();
//								}
//							}
//						}
					},
					'qq':{
						isQQ:true
					},
					'email':{
						email:true 
					},
					'note':{
						maxlength:300
					}
				},
				messages : {
					'name' : {
						required : "请输入姓名",

					},
					'mobile' : {
						required : "请输入手机号码",
						isMobile : "请输入正确的手机号码",
						remote : "该手机号码已存在"
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
						url : "editContactMan.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success("操作成功",function(){
									window.location = window.location;
								});
								
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error("服务忙，请稍后再试");
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});

});

/**
 * 删除银行帐号信息
 * 
 * @param id
 */
function delBank(id) {
	
	$.confirm("确定删除该帐号信息吗?", function() {
		$.getJSON("delBankInfo.do?id=" + id, function(data) {
			if (data.success) {
				$.success("操作成功",function(){
					window.location = window.location;
				});
			}

		});
	}, function() {
		$.info('取消删除');
	})

}

/**
 * 删除私有联系人
 * 
 * @param id
 */
function delPrivateMan(supplierId, manId) {
	
	$.confirm("确定删除该联系人信息吗?如果确认删除,后续您可以从联系人列表重新导入它.", function() {
		$.getJSON("delContactMan.do?supplierId=" + supplierId + "&manId="
				+ manId, function(data) {
			if (data.success) {
				$.success("操作成功",function(){
					window.location = window.location;
				});
			}

		});
	}, function() {
		$.info('取消删除');
	})

}

/**
 * 设置为默认发票
 */

function setDefaultBill(billId, supplierId) {

	var action = $.confirm('确定设置该发票信息为默认发票吗?', function(){
		$.getJSON("setDefault.do?billId=" + billId + "&supplierId="
			+ supplierId, function(data) {
			if (data.success) {
				$.success("操作成功",function(){
					window.location = window.location;

				});
			} else {
				$.error("操作失败");
			}

		});
	});
}

/**
 * 删除发票信息
 * 
 * @param id
 */
function delBill(id) {
	$.confirm("确定删除该发票信息吗?",function(){
		$.getJSON("delBillInfo.do?id=" + id, function(data) {
			if (data.success) {
				$.success("操作成功",function(){
					window.location = window.location;
				});
			} else {
				$.error("操作失败");
			}

		});
		
	},function(){
		$.info('取消操作');
	})
}
/**
 * to修改银行信息
 * 
 * @param id
 */
function toEditBank(id) {
	$.getJSON("getBankInfo.do?id=" + id, function(data) {
		$("#bankAccountId").val(data.id);
		$("#accountType").val(data.accountType);
		$("#bankId").val(data.bankId);
		$("#bankAccount").val(data.bankAccount);
		$("#accountName").val(data.accountName);
		$("#accountNo").val(data.accountNo);
	});
	
	layer.open({ 
		type : 1,
		title : '修改银行信息',
		area : [ '300px', '350px' ],
		shadeClose : true,
		shade : 0.5,
		content :$('#bankEditModal')
	});
	
	
	

}

/**
 * to修改发票信息
 * 
 * @param id
 */
function toEditBill(id) {
	$.getJSON("getBillInfo.do?id=" + id, function(data) {
		$("#billId").val(data.id);
		$("#isDefault").val(data.isDefault);
		$("#billName").val(data.billName);
	});
	
	layer.open({ 
		type : 1,
		title : '需改发票信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '300px', '200px' ],
		content :$('#billEditModal')
	});
	

}

/**
 * to修改联系人信息
 * 
 * @param id
 */
function toEditMan(id) {
	$.getJSON("getManInfo.do?manId=" + id, function(data) {
		$("#manId").val(data.id);
		$("#manName").val(data.name);
		$("#manMobile").val(data.mobile);
		$("input[type=radio][value='" + data.gender + "']").attr("checked", true);
		$("#manBirthDate").val(data.birthDate);
		$("#manQQ").val(data.qq);
		$("#manWechat").val(data.wechat);
		$("#manPosition").val(data.position);
		$("#manDepartment").val(data.department);
		$("#manEmail").val(data.email);
		$("#manNameShort").val(data.nameShort);
		$("#manFax").val(data.fax);
		$("#manTel").val(data.tel);
		$("#manNote").val(data.note);
	});

	layer.open({ 
		type : 1,
		title : '修改联系人信息',
		area : [ '550px', '500px' ],
		shadeClose : true,
		shade : 0.5,
		content :$('#editModal')
	});
	
}

/**
 * 分页查询
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPage").val(page);
	$("#searchPageSize").val(pageSize);
	var $form = $("#searchSupplierForm");
	var supplierType = $form.find("[name='supplierType']").val();
	$form.attr('action', supplierMap[supplierType]);
	$form.submit();
}
function searchBtn() {
	//$("#searchPage").val(1);
	var $form = $("#searchSupplierForm");
	var supplierType = $form.find("[name='supplierType']").val();
	$form.attr('action', supplierMap[supplierType]);
	$form.submit();

}

function impSearchBtn(){
	$("#searchPage").val(1);
	var $form = $("#searchSupplierForm");
	$form.submit();
}

function delSupplier(id) {
	
	$.confirm("确定删除该供应商吗?",function(){
		$.getJSON("delSupplier.do?supplierId=" + id, function(data) {
			if (data.success) {
				$.success("操作成功",function(){
                    queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
				});
				
			} else {
				$.error(data.msg);
			}

		});
	},function(){
		$.info('取消操作');
	})

}

function upSupplier(supplierId,supplierType,supplierName) {
	$.confirm("确定更新该供应商吗?",function(){
		$.getJSON("fixSupplier.do?supplierId=" + supplierId + "&supplierType=" + supplierType + "&supplierName=" + encodeURI(supplierName,"utf-8"), function(data) {
			if (data.success) {
				$.success("操作成功");
				
			} else {
				$.error(data.msg);
			}

		});
	},function(){
		$.info('取消操作');
	})

}

function changeState(id, state) {
	
	$.confirm("确定变更该供应商状态吗?",function(){
		$.getJSON("changeState.do?supplierId=" + id + "&state=" + state,
				function(data) {
					if (data.success) {
						$.success("操作成功",function(){
							 queryList($('input[name="page"]').val(), $('input[name="pageSize"]').val());
						});
						
					} else {
						$.error("操作失败");
					}

				});
	},function(){
		$.info('取消操作');
	})

}

function impBtn(id) {
	var chk_value = [];
	$("input[name='manChecked']:checked").each(function() {// 遍历每一个名字为interest的复选框，其中选中的执行函数
		chk_value.push($(this).val());// 将选中的值添加到数组chk_value中
	});
	if (chk_value.length == 0) {
		$.warn("请先勾选想要导入的联系人");
		return;
	}

	$.getJSON("addPrivateMan.do?supplierId=" + id + "&ids=" + chk_value,
			function(data) {
				if (data.success) {
					$.success("操作成功",function(){
						window.location = window.location;
					});
				} else {
					$.error("操作失败");
				}

			});

}

function getJsonData(id) {
	$("#tbody").html("");

	$.getJSON("getContactManList.do?id=" + id, function(data) {
		$.each(data, function(index, element) {
			$("#tbody").append(
					"<tr><td>"
							+ element.name
							+ "</td><td>"
							+ (element.nameShort == undefined ? ""
									: element.nameShort)
							+ "</td><td>"
							+ (element.gender == 1 ? "男" : "女")
							+ "</td><td>"
							+ (element.department == undefined ? ""
									: element.department)
							+ "</td><td>"
							+ (element.position == undefined ? ""
									: element.position)
							+ "</td><td>"
							+ (element.mobile == undefined ? ""
									: element.mobile) + "</td><td>"
							+ (element.tel == undefined ? "" : element.tel)
							+ "</td><td>"
							+ (element.fax == undefined ? "" : element.fax)
							+ "</td></tr>");
		});

	});


	layer.open({ 
		type : 1,
		title : '查看联系人信息',
		area : [{minLength : '1400px', areas : ['700px', '380px']}, {maxLength : '1400px', areas : ['550px', '400px']}],
		shadeClose : true,
		shade : 0.5,
		content :$('#lookModal')
	});

}

function toImpSupplier(supplierType) {

	layer.open({
		type : 2,
		title : '导入供应商',
		shadeClose : true,
		shade : 0.5,
		area : [ '1000px', '550px' ],
		content : 'toImpSupplierList.htm?supplierType=' + supplierType
				+ '&page=1' // iframe的url
	});

}


function baiduMap() {

	var address = "";

	if ($("#provinceCode").val() != '') {
		address = $("#provinceCode option:selected").text()
	}
	window.open('baiduMap.htm?address=' + address + '&lon='
			+ $("input[name='positionLon']").val() + '&lat='
			+ $("input[name='positionLat']").val(), 'newwindow',
			'height=600px, width=650px, scrollbars=yes, resizable=no');
}
// 选择图片
function selectAttachment(el){
	layer.openImgSelectLayer({
		callback: function(arr){
			var addhtml="";
			var html1 = $('#imgTemp').html();
			var imgsLength = $(el).prev('.addImg').children().length;
			for(var i=0;i<arr.length;i++){
				addhtml= addhtml +  html1.replace(/\$src/g, arr[i].thumb).replace(/\$path/g, arr[i].path);
			}
			$(".addImg").append(addhtml);
			submitLogoForm(arr);
		}
	});
}
// 提交logo图片
function submitLogoForm(arr){

$.ajax({
	url:"saveLogo.do",
	dataType:"json",
	type:"post",
	data:{
		arr:JSON.stringify(arr),
		bizId:$("#bizId").val()
	},
	success:function(data){
		if(data.success){
			
			location.href="configBizInfo"
		}
		else{
			$.error("操作失败"+data.msg);
		}
	},
	error:function(data,msg) {
		$.error("操作失败"+msg);
	}
});
}

	



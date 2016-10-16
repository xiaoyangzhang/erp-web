$(function() {
	
	$(document).delegate('.ulImg', 'mouseenter', function(){
		$(this).find(".icon_del").show();
	});
	$(document).delegate('.ulImg', 'mouseleave', function(){
		$(this).find(".icon_del").hide();
	});


	$(".delImg").live("click",function(){
		var siblings = $(this).parent().siblings();
		$(this).parent().remove();
		siblings.each(function(index){
			var founds = $(this).find("[name^='imgList']");
			founds.each(function(){
				$(this).attr('name', $(this).attr('name').replace(/imgList\[\d+]/g, 'imgList[' + index + ']'));
			});

		});

	});
	
	$("#saveSupplierCarForm").validate(
			{
				rules : {
					'supplierCar.carLisenseNo' : {
						required : true
					},
					'supplierCar.seatNum' : {
						required : true,
						digits:true 
					},
					'supplierCar.buyDate' : {
						required : true
					},
					'supplierCar.examDate' : {
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
					var imgsLength = $('.addImg').children().length;
					if (imgsLength < 1) {
						$.warn("请至少选择一张图片");
						return;
					}
					var options = {
						url : "addSupplierCar.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success('操作成功', function() {
									refreshWindow("编辑产品",
											'../supplierCar/toEditSupplierCar.htm?id='
													+ data.id);
								});
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error('服务器忙，稍后再试');
						}
					};

					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});
	
	
	$("#editSupplierCarForm").validate(
			{
				rules : {
					'supplierCar.carLisenseNo' : {
						required : true
					},
					'supplierCar.seatNum' : {
						required : true,
						digits:true 
					},
					'supplierCar.buyDate' : {
						required : true
					},
					'supplierCar.examDate' : {
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
					var imgsLength = $('.addImg').children().length;
					if (imgsLength < 1) {
						$.warn("请至少选择一张图片");
						return;
					}
					var options = {
						url : "editSupplierCar.do",
						type : "post",
						dataType : "json",
						success : function(data) {

							if (data.success) {
								$.success('操作成功', function() {
									window.location=window.location;
								});
							} else {
								$.error(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.error('服务器忙，稍后再试');
						}
					};

					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			});

})
/**
 * 分页查询
 */
function queryList(page, pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#searchPage").val(page);
	$("#searchPageSize").val(pageSize);
	var $form = $("#searchSupplierCarForm");
	$form.submit();
}
function searchBtn() {
	$("#searchPage").val(1);
	var $form = $("#searchSupplierCarForm");
	$form.submit();

}
/**
 * 删除私有车辆
 * 
 * @param id
 */
function delPrivateCar(carId) {

	$.confirm("确定删除该关联关系吗?如果确认删除,后续您可以重新导入它.", function() {
		$.getJSON("delCarRelation.do?id=" + carId, function(data) {
			if (data.success) {
				$.success("操作成功", function() {
					queryList($("#searchPage").val(), $("#searchPageSize")
							.val());
				});
			}
		});
	}, function() {
		$.info('取消删除');
	})

}

function selectImg(el, selector) {

	layer.openImgSelectLayer({
		callback : function(arr) {
			var addhtml = "";
			var html1 = $(selector).html();
			var imgsLength = $('.addImg').children().length;
			for (var i = 0; i < arr.length; i++) {
				addhtml = addhtml
						+ html1.replace(/\$src/g, arr[i].thumb).replace(
								/\$index/g, imgsLength + i).replace(/\$name/g,
								arr[i].name).replace(/\$path/g, arr[i].path);
			}
			$(el).prev().append(addhtml);
		}
	});

}

function toImpSupplierCar() {
	
	
	var win;
	layer.open({ 
		type : 2,
		title : '导入车辆',
		shadeClose : true,
		shade : 0.5,
		area : [ '800px', '550px' ],
		content : 'toAllSupplierCarList.htm', // iframe的url
		btn: ['导入', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			// userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var chk_value = win.getCars();
			if (chk_value.length == 0) {
				$.warn("请先勾选想要导入的车辆");
				return;
			}
			$.getJSON("addRelation.do?ids=" + chk_value, function(data) {
				if (data.success) {
					layer.close(index); 
					$.success("操作成功",function(){
						window.location=window.location;
					});
					
				} else {
					$.error("操作失败");
				}

			});
			// 一般设定yes回调，必须进行手工关闭
	        
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
	

}





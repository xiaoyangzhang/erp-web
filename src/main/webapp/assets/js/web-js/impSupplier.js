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

});


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
	$form.submit();
}

function impSearchBtn(){
	$("#searchPage").val(1);
	var $form = $("#searchSupplierForm");
	$form.submit();
}


function impSupplier() {

	var chk_value = [];
	$("input[name='supplierChecked']:checked").each(function() {// 遍历每一个名字为interest的复选框，其中选中的执行函数
		chk_value.push($(this).val());// 将选中的值添加到数组chk_value中
	});
	if (chk_value.length == 0) {
		$.warn("请先勾选想要导入的供应商");
		return;
	}
	$.getJSON("impSupplier.do?ids=" + chk_value, function(data) {
		if (data.success) {
			$.success("操作成功",function(){
			    //window.parent.location=window.parent.location;
				parent.searchBtn();
				var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
				parent.layer.close(index);
				
			});
		
		} else {
			$.error("操作失败");
		}

	});
}

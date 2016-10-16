function newRestaurant(){
	$("#restaurantRequireDate").val("");
	$("#restaurantArea").val("");
	$("#restaurantCountRequire").val("");
	$("#restaurantRemark").val("");
	
	layer.open({
		type : 1,
		title : '添加餐厅信息',
		shadeClose : true,
		shade : 0.5,
        area : ['500px','330px'],
		content :$('#addOrEditRestaurant')
	});
}
function toEditRestaurant(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#restaurantId").val(data.id);
		$("#restaurantRequireDate").val(data.requireDate);
		$("#restaurantArea").val(data.area);
		$("#restaurantRemark").val(data.remark);
		$("#restaurantCountRequire").val(data.countRequire);
	});
	
	
	layer.open({
		type : 1,
		title : '修改餐厅信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','330px'],
		content :$('#addOrEditRestaurant')
	});
	
}
function deleteRestaurantById(obj,id){
	$.confirm("确认删除吗？",function(){
		$.getJSON("../groupRequirement/deleteGroupRequirementById.do?id=" + id, function(data) {
			if(data.success){
				$(obj).closest("tr").remove();
				$.info('删除成功！');
			}
		});
	},function(){
		$.info('取消删除');
	});	
}
$(function() {
	/**
	 * 新增接送信息弹出层form
	 */
	$("#addOrEditRestaurantForm").validate({
		rules : {
			'requireDate' : {
				required : true
			},
			'countRequire' : {
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
			var url = "" ;
			if($("#restaurantId").val().trim()==""){
				url = "../groupRequirement/saveGroupRequirement.do" ;
			}else{
				url = "../groupRequirement/updateGroupRequirement.do" ;
			}
			var options = {
				url : url,
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功');
						window.location = window.location;
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
			};
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
});


function newMotorcade(){
	$("#motorcadeId").val("");
	$("#requireDate").val("");
	$("#modelNum").val("");
	$("#countSeat").val("");
	$("#ageLimit").val("");
	$("#motorcadeRemark").val("");
	layer.open({
		type : 1,
		title : '添加车队信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','350px'],
		content :$('#addOrEditMotorcade')
	});
}
function toEditMotorcade(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#motorcadeId").val(data.id);
		$("#motorcadeRequireDate").val(data.requireDate);
		$("#motorcadeRequireDateTo").val(data.requireDateTo);
		$("#modelNum").val(data.modelNum);
		$("#countSeat").val(data.countSeat);
		$("#ageLimit").val(data.ageLimit);
		$("#motorcadeRemark").val(data.remark);
	});
	
	layer.open({
		type : 1,
		title : '修改车队信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','350px'],
		content :$('#addOrEditMotorcade')
	});
}
function deleteMotorcadeById(obj,id){
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
	$("#addOrEditMotorcadeForm").validate({
		rules : {
			'requireDate' : {
				required : true
			},
			'requireDateTo' : {
				required : true
			},
			'modelNum' : {
				required : true
			},
			'countSeat' : {
				required : true,
				digits : true
			},
			'ageLimit' : {
				required : true,
				digits : true
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
			if($("#motorcadeId").val().trim()==""){
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
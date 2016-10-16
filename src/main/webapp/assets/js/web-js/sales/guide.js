function newGuide(){
	$("#language").val("");
	$("#gender").val("");
	$("#guideAgeLimit").val("");
	$("#guideRemark").val("");
	layer.open({
		type : 1,
		title : '添加导游信息',
		shadeClose : true,
		shade : 0.5,
        area : ['500px','330px'],
		content :$('#addOrEditGuide')
	});
}
function toEditGuide(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#guideId").val(data.id);
		$("#language").val(data.language);
		$("input[name='gender'][value=" + data.gender + "]").attr(
				"checked", true);
		$("#guideAgeLimit").val(data.ageLimit);
		$("#guideRemark").val(data.remark);
	});
	
	
	layer.open({
		type : 1,
		title : '修改导游信息',
		shadeClose : true,
		shade : 0.5,
		 area : ['500px','330px'],
		content :$('#addOrEditGuide')
	});
	
}
function deleteGuideById(obj,id){
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
	 * 新增导游弹出层form
	 */
	$("#addOrEditGuideForm").validate({
		rules : {
			'language' : {
				required : true
			},
			'gender' : {
				required : true
			},
			'ageLimit' : {
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
			if($("#guideId").val().trim()==""){
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
						$.warn(data.msg) ;
						window.location = window.location;
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
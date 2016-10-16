function newAirTicket(){
	$("#airTicketRequireDate").val("");
	$("#classNo").val("");
	$("#cityDeparture").val("");
	$("#cityArrival").val("");
	$("#countRequire").val("");
	$("#airTicketRemark").val("");
	layer.open({
		type : 1,
		title : '添加机票信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','400px'],
		content :$('#addOrEditAirTicket')
	});
}
function toEditAirTicket(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#airTicketId").val(data.id);
		$("#airTicketRequireDate").val(data.requireDate);
		$("#classNo").val(data.classNo);
		$("#cityDeparture").val(data.cityDeparture);
		$("#cityArrival").val(data.cityArrival);
		$("#countRequire").val(data.countRequire);
		$("#airTicketRemark").val(data.remark);
	});
	layer.open({
		type : 1,
		title : '修改机票信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','400px'],
		content :$('#addOrEditAirTicket')
	});
	
}
function deleteAirTicketById(obj,id){
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
	$("#addOrEditAirTicketForm").validate({
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
			if($("#airTicketId").val().trim()==""){
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
						$.success('操作成功',function(){
							window.location = window.location;
						});
						
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试');
				}
			};
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
});
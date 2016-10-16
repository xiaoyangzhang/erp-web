function newRailwayTicket(){
	$("#railwayTicketRequireDate").val("");
	$("#railwayTicketClassNo").val("");
	$("#railwayTicketCityDeparture").val("");
	$("#railwayTicketCityArrival").val("");
	$("#railwayTicketCountRequire").val("");
	$("#railwayTicketRemark").val("");
	
	layer.open({
		type : 1,
		title : '添加火车票信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','400px'],
		content :$('#addOrEditRailwayTicket')
	});
}
function toEditRailwayTicket(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#railwayTicketId").val(data.id);
		$("#railwayTicketRequireDate").val(data.requireDate);
		$("#railwayTicketClassNo").val(data.classNo);
		$("#railwayTicketCityDeparture").val(data.cityDeparture);
		$("#railwayTicketCityArrival").val(data.cityArrival);
		$("#railwayTicketCountRequire").val(data.countRequire);
		$("#railwayTicketRemark").val(data.remark);
	});
	
	layer.open({
		type : 1,
		title : '修改火车票信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','400px'],
		content :$('#addOrEditRailwayTicket')
	});
	
}
function deleteRailwayTicketById(obj,id){
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
	$("#addOrEditRailwayTicketForm").validate({
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
			if($("#railwayTicketId").val().trim()==""){
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
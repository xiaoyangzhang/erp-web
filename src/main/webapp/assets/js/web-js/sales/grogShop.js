function newGrogShop(){
	$("#id").val("");
	$("#requireDate").val("");
	$("#area").val("");
	$("#hotelLevel").val("");
	$("#countSingleRoom").val(0);
	$("#countTripleRoom").val(0);
	$("#countDoubleRoom").val(0);
	$("#remark").val("");
	
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		for (var i = 0; i < data.length; i++) {
			
		}
	});
	
	layer.open({
		type : 1,
		title : '添加酒店信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','500px'],
		content :$('#addOrEditGrogShop')
	});
}
function toEditGrogShop(id){
	$.getJSON("../groupRequirement/editGroupRequirement.do?id=" + id, function(data) {
		$("#id").val(data.id);
		$("#requireDate").val(data.requireDate);
		$("#area").val(data.area);
		$("#hotelLevel").val(data.hotelLevel);
		$("#countSingleRoom").val(data.countSingleRoom);
		$("#countTripleRoom").val(data.countTripleRoom);
		$("#countDoubleRoom").val(data.countDoubleRoom);
		$("#hotelPeiFang").val(data.peiFang);
		$("#hotelExtraBed").val(data.extraBed);
		$("#remark").val(data.remark);
	});
	
	layer.open({
		type : 1,
		title : '修改酒店信息',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','500px'],
		content :$('#addOrEditGrogShop')
	});
}
function deleteGrogShopById(obj,id){
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
	$("#addOrEditGrogShopForm").validate({
		rules : {
			'requireDate' : {
				required : true
			},
			'hotelLevel' : {
				required : true
			},
			'countSingleRoom' : {
				required : true,
				digits : true
			},
			'countTripleRoom' : {
				required : true,
				digits : true
			},
			'countDoubleRoom' : {
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
			if($("#id").val().trim()==""){
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
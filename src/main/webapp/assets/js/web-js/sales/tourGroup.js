$(function() {
	/**
	 * 未确认团查询form提交
	 */
	$("#tourGroup").validate({
		errorPlacement : function(error, element) {
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) {
				error.appendTo(element.parent()); 
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var options = {
				url : "../tourGroup/findByCondition.htm",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功');
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
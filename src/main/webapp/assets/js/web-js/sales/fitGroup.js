function selectUser(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ '400px', '500px' ],
		shadeClose : true,
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.error('请选择人员') ;
				return false;
			}
			$("#operatorId").val(userArr[0].id) ;
			$("#operatorName").val(userArr[0].name) ;
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
/**
 * 散客团
 */

$(function(){
	$("#saveOrderGroupInfoForm").validate(
			{
				rules : {
					'productName' : {
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
				
					var options = {
						url : 'editOrderGroupInfo.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
							} else {
								$.success(data.msg);

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试', {
								icon : 5
							});
						}
					} 
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
});
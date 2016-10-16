/**
 * layer提示封装
 * $.success(msg);
 */
$.extend({
	/**
	 * 成功
	 */
	success:function(msg){
		layer.msg(msg, {icon: 1,time: 1000});
	},
	success:function(msg,callBack){
		layer.msg(msg, {icon: 1,time: 1000},callBack);
	},
	successR:function(msg,callBack){
		layer.msg(msg, {icon: 1,time: 1000,offset:['0px','0px']},callBack);
	},
	/**
	 * 提示信息
	 */
	info:function(msg){
		layer.msg(msg);
	},
	infoR:function(msg){
		layer.msg(msg, {offset:['0px','0px']});
	},
	/**
	 * 报错
	 */
	error:function(msg){
		layer.msg(msg, {icon: 5});
	},
	error:function(msg,callBack){
		layer.msg(msg, {icon: 5},callBack);
	},
	errorR:function(msg,callBack){
		layer.msg(msg, {icon: 5,offset:['0px','0px']},callBack);
	},
	/**
	 * 警告
	 */
	warn:function(msg){
		layer.msg(msg, {icon: 3});
	},
	warnR:function(msg){
		layer.msg(msg, {icon: 3,offset:['0px','0px']});
	},
	/**
	 * 确认框
	 */
	confirm:function(msg,yesCallBack,cancelCallBack){
		layer.confirm(msg, { btn: ['确定','取消'], shade: false	},yesCallBack,cancelCallBack);
	}
})
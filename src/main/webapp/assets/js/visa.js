var opChk = function(obj) {
	var curState = $(obj).attr("class");
	if (curState == "ico_checkUn") {
		curState = "ico_checkOk";
	} else {
		curState = "ico_checkUn";
	}
	$(obj).attr("class", curState);
}

var getInfo_fromCookie = function() {
	var user = $.cookie('lvdao_user');
	if (user)
		$("#loginName").val(user);
}

var checkSubmitFlg = false;

function is_CheckSubmit() {
	if (checkSubmitFlg == true) {
		return false;
	}
	checkSubmitFlg = true;
	return true;
}

function loadCode(){
	$("#verifycode").attr("src","verify.htm?"+Math.random());
}

$(function(){
	var login = function() {
		$("#loginForm").validate({
			rules : {
				'loginName':{
					required:true
				}
			},
			messages : {
				'loginName' : {
					required : "请输入手机号"
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
				//记住cookie状态
				var curState = $("#isRemember").attr("class");
				if (curState == "ico_checkUn") {
					$.cookie('lvdao_user', '');
				} else {
					$.cookie('lvdao_user', $("#loginName").val());
				}
				
				if (is_CheckSubmit()) {
					form.submit();
				} else {
					alert('在上一个动作未执行完成之前，请不要重复提交。');
					checkSubmitFlg = false;
				}
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		})
	}
	login();
	
	$("#refreshcode").click(function(){
		loadCode();
	})
})
var supersized=function(path){
jQuery(function($) {
	$.supersized({
		slide_interval: 5000,
		transition: 1,
		transition_speed: 3000,
		performance: 1,
		min_width: 0,
		min_height: 0,
		vertical_center: 1,
		horizontal_center: 1,
		fit_always: 0,
		fit_portrait: 1,
		fit_landscape: 0,
		slide_links: 'blank',
		slides: [{
			image: path+'/assets/img/login/visa.jpg'
		}, {
			image: path+'/assets/img/login/bj01.jpg'
		}]
	});
	
	loadCode();
	
	$("#isRemember").bind("click", function() {
		opChk(this);
	});
	getInfo_fromCookie();
});
}

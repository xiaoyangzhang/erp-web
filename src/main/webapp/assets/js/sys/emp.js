$(function(){
	 
$("#saveEmployee").validate({
	
	focusCleanup:true,
	errorElement : 'span',
	focusInvalid : false,
	errorClass : 'help-block',
	rules:{
		'loginName':{
			required:true,
			maxlength:20,
			remote:{
				url:"commons/valideteEmpName?bizId="+$("#bizId").val()+"&employeeId="+$("#employeeId").val(),
				cache:false,
				async:false,
				type:"get",
				//dataType:"json",
				data:{
					//bizId:$("#bizId").val(),
					//employeeId:$("#employeeId").val(),
					loginName:function(){return $("#loginName").val();}
				}
				 
				}
			
		},
		'password':{
			required:true,
			rangelength:[6,12]
		},
		'name':{
			required:true,
			maxlength:50
		},
		
		'mobile':{
			required:true,
			maxlength:20
		},
		'orgName':{
			required:true
			},
		'email':{
			email:true
		},
		'roles':{
			required:true
		}
		
	},
	messages:{
		'loginName':{
			required:"请输入用户名",
			maxlength:"用户名长度不能超过20",
			remote:"用户名已存在"
		},
		'password':{
			required:"请输入密码",
			rangelength:"长度介于6~12位之间"
		},
		'name':{
			required:"请输入姓名",
			
			maxlength:"长度不能超过50"
		},
		'mobile':{
			required:"请填写联系方式",
			
		},
		'orgName':{
			required:"请选择组织机构"
				},
		'email':{
			email:"请输入正确格式的邮箱 "
			
		},
		'roles':{
			required:"请选择角色"
		}
	},
	highlight : function(element) {
		$(element).closest('.form-group').addClass('has-error');
	},
	success : function(label) {
		label.closest('.form-group').removeClass('has-error');
		label.remove();
	},
	errorPlacement:function(error,element){
		element.parent('div').append(error);
		
	},
	submitHandler:function(form){

		
		getChildNodes();
		var options={
				type:"post",
				dataType:"json",
				success:function(data){
					if(data.success){
						//alert(123);
						$.success("保存成功");
					}
					else{
						if (data.msg){
							$.warn(data.msg);
						}else {
							$.warn("保存失败");
						}
					}
				},
				error:function(){
					$.error("服务器忙，请稍后再试");
				}
		};
		//form.submit();
		$(form).ajaxSubmit(options);
		
	},
	invalidHandler : function(form, validator) { // 不通过回调
		return false;
	}
});
imgHover();

});
function getChildNodes() {
	/*var orgId=$("#orgId").val();
	if(!orgId){
		
	
	var treeObj = $.fn.zTree.getZTreeObj("orgTree");
	var nodes = treeObj.getCheckedNodes(true);
	var nodeSiteId = new Array();      
	var nodeSiteName = new Array();      
	for(var i = 0; i < nodes.length; i++) {           
		nodeSiteId[i] = nodes[i].id;      
		nodeSiteName[i] = nodes[i].name;      
	} 
	
	document.getElementById('orgId').value=nodeSiteId[0];
	document.getElementById('orgName').value=nodeSiteName[0];
	}*/
	var checked=[];
	$("input:checkbox:checked").each(function(index,ele){
		checked.push($(this).val());
	});
	$("#roleIds").val(checked.join(","));
}

//选择图片
function selectAttachment(el){
	layer.openImgSelectLayer({
		callback: function(arr){
			
			//var addhtml="";
			//var html1 = $('#imgCopy').html();
			//var imgsLength = $(el).prev('.addImg').children().length;
			//for(var i=0;i<arr.length;i++){
				//addhtml= addhtml +  html1.replace(/\$src/g, arr[0].thumb).replace(/\$path/g, arr[0].path);
			//}
			//$(".addImg").append(addhtml);
			
			
			$("#logoSpan").css("display","");
			$("#imgs").attr("src",arr[0].thumb);
			$("#logo").val(arr[0].path);
		}
	});
	//layer.close();
}
var imgHover=function  () {
	$(".ulImg .icon_del").hide();
	$(".ulImg").unbind("hover").hover(function(){
		$(this).find(".icon_del").show();
	},function(){
		$(this).find(".icon_del").hide();
	});			
}
	
	
 

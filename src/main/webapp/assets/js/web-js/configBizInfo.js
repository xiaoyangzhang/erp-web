/**
 * 
 */
// 选择图片
function selectAttachment(el){
	layer.openImgSelectLayer({
		callback: function(arr){
			var addhtml="";
			var html1 = $('#imgTemp').html()+"";
			var imgsLength = $(el).prev('.addImg').children().length;
			for(var i=0;i<arr.length;i++){
				addhtml= addhtml +  html1.replace(/\$src/g, arr[i].thumb).replace(/\$path/g, arr[i].path);
			}
			$(".addImg").append(addhtml);
			submitLogoForm(arr);
		}
	});
}
// 提交logo图片
function submitLogoForm(arr){

$.ajax({
	url:"saveLogo.do",
	dataType:"json",
	type:"post",
	data:{
		arr:JSON.stringify(arr),
		bizId:$("#bizId").val()
	},
	success:function(data){
		if(data.success){
			
			location.href="configBizInfo"
		}
		else{
			$.error("操作失败"+data.msg);
		}
	},
	error:function(data,msg) {
		$.error("操作失败"+msg);
	}
});
}

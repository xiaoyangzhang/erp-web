/*删除选中行*/  
$("#delcon").live("click",function(){ 
	var siblings = $(this).closest('tr').siblings();
	$(this).parents("tr").remove();
	siblings.each(function(index, element){
		var founds = $(element).find("[name^='productContacts']");
		founds.each(function(){
			$(this).attr('name', $(this).attr('name').replace(/productContacts\[\d+]/g, 'productContacts[' + index + ']'));
		});
	});
		
	});

$(".delImg").live("click",function(){
	var siblings = $(this).parent().siblings();
	$(this).parent().remove();
	siblings.each(function(index){
		var founds = $(this).find("[name^='productAttachments']");
		founds.each(function(){
			$(this).attr('name', $(this).attr('name').replace(/productAttachments\[\d+]/g, 'productAttachments[' + index + ']'));
		});

	});

});

$(".delAtt").live("click",function(){
	var siblings = $(this).parent().siblings();
	$(this).parent().remove();
	siblings.each(function(index){
		var founds = $(this).find("[name^='attachments']");
		founds.each(function(){
			$(this).attr('name', $(this).attr('name').replace(/attachments\[\d+]/g, 'attachments[' + index + ']'));
		});

	});

});

$(function() {

	$(document).delegate('.ulImg', 'mouseenter', function(){
		$(this).find(".icon_del").show();
	});
	$(document).delegate('.ulImg', 'mouseleave', function(){
		$(this).find(".icon_del").hide();
	});

	$('#returnBtn').on('click', function(){
		$.confirm('确定关闭吗？所有未保存修改将丢失。', function(){
            closeWindow();
		});
	});
	
	
	$("#provinceCode").change(
			function() {
				var s = "<option value=''>请选择市</option>";
				var val = this.options[this.selectedIndex].value;
				if(val !== ''){
					$.getJSON("../basic/getRegion.do?id="
						+ val, function(data) {
						data = eval(data);
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
								+ "</option>";
						});
						$("#cityCode").html(s);
					});
				}else{
					$("#cityCode").html(s);
				}

			});
	
	
	$("#cityCode").change(function(){
		$("#provinceVal").val(($("#provinceCode  option:selected").text()));
		$("#cityVal").val(($("#cityCode  option:selected").text()));
	});
	
	$("#brandId").change(function(){
			$("#brandName").val(($("#brandId  option:selected").text()));

	});
	
	/*提交**/
	$("#saveProdectInfoForm").validate(
		{
			rules:{
				'productInfo.orderNum' : {
					required : true
				},
				'productInfo.brandId' : {
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
					url : "save.do",
					type : "post",
					dataType : "json",
					success : function(data) {

						if (data.success) {
							$.success('操作成功', function(){
                                refreshWindow("编辑产品", path + '/productInfo/edit.htm?productId=' + data["id"]);
							});
							//$.success("操作成功", function(){
							//	window.location = path + '/productInfo/list.htm?state=1';
							//});
						} else {
							$.error(data.msg);

						}
					},
					error : function(XMLHttpRequest, textStatus,
									 errorThrown) {
						$.error('服务器忙，稍后再试');
					}
				};

				$(form).ajaxSubmit(options);
			},
			invalidHandler : function(form, validator) { // 不通过回调
				return false;
			}
		});
	
});

		
/*人员弹窗**/
function selectUser(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ {minHeight : '768px', areas : [ '400px', '590px' ]}, {maxHeight : '768px', areas : [ '400px', '450px' ]} ],
		shadeClose : false,
		content : path+'/component/orgUserTree.htm?type=multi',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.warn("请选择人员");
				return false;
			}
			var addhtml = "";
			var conTr = $('#contacts tr').length + $('#addContacts tr').length;
			var html1 = $('#contactsTemp').html();
			for(var i=0;i<userArr.length;i++){
				addhtml = addhtml + html1.replace(/\$index/g, conTr++).replace(/\$typeName/g, userArr[i].pos ? userArr[i].pos : "")
						.replace(/\$name/g, userArr[i].name ? userArr[i].name : "").replace(/\$mobile/g, userArr[i].mobile ? userArr[i].mobile : "")
						.replace(/\$tel/g, userArr[i].phone ? userArr[i].phone : "").replace(/\$fax/g, userArr[i].fax ? userArr[i].fax : "");
			}
			$('#addContacts').append(addhtml);
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index);
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

function selectImg(el, selector){

	layer.openImgSelectLayer({
		callback: function(arr){
			var addhtml="";
			var html1 = $(selector).html();
			var imgsLength = $('.addImg').children().length;
			for(var i=0;i<arr.length;i++){
				/* console.log("name:"+arr[i].name+",path:"+arr[i].path); */
				//alert(arr[i].thumb) $src
				addhtml= addhtml +  html1.replace(/\$src/g, arr[i].thumb).replace(/\$index/g, imgsLength + i).replace(/\$name/g, arr[i].name).replace(/\$path/g, arr[i].path);
			}
			//$("#addImg").html(addhtml);
			$(el).prev().append(addhtml);
		}
	});

}

function selectAttachment(el, selector){

    layer.openImgSelectLayer({
        callback: function(arr){
            var addhtml="";
            var html1 = $(selector).html();
			var imgsLength = $('.addAttachment').children().length;
			for(var i=0;i<arr.length;i++){
				addhtml= addhtml +  html1.replace(/\$src/g, arr[i].thumb).replace(/\$index/g, imgsLength + i).replace(/\$name/g, arr[i].name).replace(/\$path/g, arr[i].path);
			}
            $(el).prev().append(addhtml);
        }
    });

}

function changeTab(){
	$.info("请先保存产品基本信息");
}
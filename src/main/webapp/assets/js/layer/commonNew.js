/**
 * Created by anps0907 on 2/6/2015.
 */
$.extend({

    /**
     * alert弹出信息框，与layer一致
     * @param alertMsg 信息内容（文本）
     * @param alertType 提示图标（整数，0-10的选择）
     * @param alertTit 标题（文本）
     * @param alertYes 按钮的回调函数
     * @returns
     */
    alertPlus: function (content, options, yesFunction) {
        return layer.alert(content, options, yesFunction);
    },

    /***
     * layer 关闭特定层
     * index 索引值
     */
    closeDialog: function (index) {
        return layer.close(index);
    },

    /**
     * 打开弹出层的方法
     * 0：信息框（默认），1：页面层，2：iframe层，3：加载层，4：tips层。
     * */
    alertDialog: function (setting) {
        return layer.open(setting);
       },
        
    /***
     *content：信息内容（文本）
     * options：参数
     * yesFunction ： yes 回调
     * cancelFunction : 关闭回调
     */
    layerConfirm: function (content, options, yesFunction, cancelFunction) {
        return layer.confirm(content, options, yesFunction, cancelFunction);
    },
    /**
     * 加载tip层
     * content ：文本内容
     * follow : 要吸引的dom对象, 对象
     * parme : parme允许传这些属性{time: 自动关闭所需秒,
         * maxWidth: 最大宽度, guide: 指引方向, style: tips样式（参加api表格一中的style属性）
         */
    loadTip: function (content, follow, parme) {
        return layer.tips(content,follow,parme);
    },
   
    /***
     * 加载层
     *icon 图标 icon支持传入0-2如果是0，
     *loadgif：加载图标（整数，0-3的选择），
     * options 参数
     */
    loadDialog: function (icon, options) {
        layer.load(icon, options);
    },
    /**
     * 修改层的标题
     * @param content 内容
     * @param index 层索引
     */
    updateTitle: function (title, index) {
        layer.title(title,index);
    },
    /***
     * 
     */
    layerMsg : function(content, options, end){
    	layer.msg(content, options, end);
    }
});

/***
 * 清空表单中的数据
 * @param formId
 */
function resetFormInfo(formId){
	$("#"+formId).find(':input').not(':button, :submit, :reset').val('')
	.removeAttr('checked').removeAttr('selected');
}

/**全选、取消全选*/ 
function checkItem(checkallId){
	
	$("#"+checkallId).click(function(){  
	    $("input[name='items']").attr("checked",$(this).get(0).checked);  
	}); 
}


/***
 * 
 * @param target
 */

function toLength(target,max) {
    var text = target.value.slice(0,max), len = 0, maxLength = max, currLength = max;
    target.value=text;
    if ("" !== text) {
        len = text.length;
        currLength = maxLength - len;
    }

    if (currLength < 0){
    	 currLength = 0;
    }
    $(target).wrap();
    $(target).next("span").remove();
    $('<span >您还可以输入 <span style="color:green">'+currLength+'</span> 个字</span>').insertAfter(target);
}



function checkItems(typeCode,checkedValue){
	 var flag = false;
	 $("input[type='checkbox'][name='"+typeCode+"']").each(function (){
		 if($(this).val() == checkedValue){
			 //$.layerMsg("该类型已存在",{icon:3,time:1500});
			 $.layerMsg("该类型已存在",{icon:0,time:1500});
			 return flag = true;
		 }	
	 });
	 return flag;
}


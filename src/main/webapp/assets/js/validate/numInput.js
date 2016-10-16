/**
 * 控制文本框只能输入数字
 * 使用方法：
 * 1.在要使用的input文本框里加上class：numInput
 * 2.在该input文本框中加上格式化属性:_format="999,999.00",表示每3位添加分隔符，保留两位小数
 * 3.添加最大值属性：_max="9999",当输入数据大于最大值时，会把文本框内容变为最大值。
 * 4.添加最小值属性：_min="0",当输入数据小于最小值或者文本框为空时,会把文本框内容变为最小值
 * 5.使用NumInput.getValue(obj);获取文本框里的值,obj为jquery对象
 */

var NumInput = {
	format: function(str, decNum, step) {  
	   str = parseFloat((str + "").replace(/[^\d\.-]/g, "")).toFixed(decNum) + "";  
	   var l = str.split(".")[0].split("").reverse();
	   var lt = ""; 
	   var rt = "";
	   
	   for(i = 0; i < l.length; i ++ ) {  
		   lt += l[i] + ((i + 1) % step == 0 && (i + 1) != l.length ? "," : "");  
	   } 
	   
	   var result = lt.split("").reverse().join("");  
	   
	   if(decNum > 0){
		   r = str.split(".")[1].split("");  
		   for(i = 0; i < r.length; i++) {
			   rt += r[i] + ((i + 1) % step == 0 && (i + 1) != r.length ? "," : "");  
		   }
		   result += "." + rt.split("").join("");
	   }
	   return result;
	},
	
	blur: function (obj){
		var value = $.trim($(obj).val());
		
//		if(!value && parseFloat($(obj).attr("_min")) > 0){
//			return false;
//		}
		
		var format = $(obj).attr("_format");
		
		format = format ? format : "999,999.00";
		
		var step = 0;
		if(format && format.indexOf(",") > -1){
			step = format.split(".")[0].split(",").reverse()[0].length;
		}
		var dec = 0;
		if(format && format.indexOf(".") > -1){
			dec = format.split(".")[1].length;
		}
		
		var min = $(obj).attr("_min");
		var max = $(obj).attr("_max");
		
		
		if(value && parseFloat(value)){
			value = parseFloat(value.replace(/[^\d\.-]/g, "")) > parseFloat(max) ? max : value;
			value = parseFloat(value.replace(/[^\d\.-]/g, "")) < parseFloat(min) ? min : value;
			$(obj).val(NumInput.format(value, dec, step));
		} else if(min && parseFloat(min)) {
			$(obj).val(NumInput.format(min, dec, step));
		} else{
			$(obj).val(NumInput.format(0, dec, step));
		}
	},
	
	focus: function (obj) {
		obj.style.imeMode='disabled'; 
		if($(obj).attr("readonly")){
			$(obj).blur();
			return false;
		}
		if(!parseFloat($(obj).val())){
			$(obj).val("");
		}
	},
	
	keydown: function(obj, event){
		var value = obj.val();
		var code = [8, 9, 37, 38, 39, 40, 46, 48, 49, 50, 51, 52, 
		            53, 54, 55, 56, 57, 96, 97, 
		            98, 99, 100, 101, 102, 103, 
		            104, 105, 110, 190];
		
		if($.inArray(event.keyCode, code) == -1){
			return false;
		}
		if(value.indexOf(".") > -1 && (event.keyCode == 110 || event.keyCode == 190)){
			return false;
		}
	},
	
	getValue: function(obj){
		return $.trim(obj.val()).replace(/[^\d\.-]/g, "");
	},
	
	textFormat: function(obj){
		var value = $.trim($(obj).text());
		
		var format = $(obj).attr("_format");
		
		format = format ? format : "999,999.00";
		
		var step = 0;
		if(format && format.indexOf(",") > -1){
			step = format.split(".")[0].split(",").reverse()[0].length;
		}
		var dec = 0;
		if(format && format.indexOf(".") > -1){
			dec = format.split(".")[1].length;
		}
		
		var min = $(obj).attr("_min");
		var max = $(obj).attr("_max");
		
		
		if(value && parseFloat(value)){
			value = parseFloat(value.replace(/[^\d\.-]/g, "")) > parseFloat(max) ? max : value;
			$(obj).text(NumInput.format(value, dec, step));
		} else if(min && parseFloat(min)) {
			$(obj).text(NumInput.format(min, dec, step));
		} else{
			$(obj).text(NumInput.format(0, dec, step));
		}
	},
	
	parseValue: function(value){
		return $.trim(value).replace(/[^\d\.-]/g, "");
	}
}

/**
 * 键盘按下事件
 * 文本框获取键盘事件
 * 失去焦点事件
 */
$("input.numInput").on("keydown", function(event){
//	return NumInput.keydown($(this), event);
}).on("focus", function(event){
	NumInput.focus(this);
}).on("blur", function(event){
	NumInput.blur(this);
});

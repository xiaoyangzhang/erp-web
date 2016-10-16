/**
 * 通用函数库
 * 
 * @author Jing.Zhuo
 * @create 2015年7月25日
 */
$(function() {

	/**
	 * 支持后台异常前端展示， 配合后台@PostHandler和ClientException使用
	 */
	window.YM = {
		post : function(url, data, success, failure, dataType, async) {
			$.ajax({
				url : url,
				dataType : dataType ? dataType : "json",
				type : "POST",
				data : data,
				async : async !== false,
				success : function(response) {
					if (!response) {
						success();
						return;
					}
					if (response.success) {
						success(response.data);
						return;
					}
					$.error(response.msg);
					if (failure)
						failure(response.data);
					return;
				},
				error : function() {
					if (failure)
						failure();
					$.error("服务器异常");
				}
			});
		},

		/**
		 * 表单序列化数组转换成Json对象
		 */
		getFormData : function(formId) {
			var arr = $("#" + formId).serializeArray();
			var obj = {};
			for (var i = 0; i < arr.length; i++) {
				obj[arr[i].name] = arr[i].value;
			}
			return obj;
		}
	};

});

$.extend({
  getUrlVars: function(){
    var vars = [], hash;
    posQ = window.location.href.indexOf('?');
    if (posQ<=0){return vars;}
    var hashes = window.location.href.slice(posQ + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
      hash = hashes[i].split('=');
      //vars.push(hash[0]);
      vars[hash[0]] = decodeURIComponent(hash[1]);
    }
    return vars;
  },
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  },
  makeUrlFromVars: function(vars){
	  var arr=[];
	  for(key in vars){
		  if (key && vars[key]!=""){arr.push(key + "=" + encodeURIComponent(vars[key]));}
	  }
	  return "?" + arr.join("&");
  },
  currentMonthFirstDay: function(){
	  var curDate=new Date();
	  var curMonth = curDate.getMonth()+1; if(curMonth<10){curMonth='0'+curMonth;}
	  return curDate.getFullYear()+"-"+curMonth+"-01";
  },
  currentMonthLastDay: function(){
	  var curDate=new Date();
	  var curMonth = curDate.getMonth()+1;
	  if(curMonth<10){curMonth='0'+curMonth;}
	  var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1); //get Next month
	  var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate(); // next month -1 day
	  return curDate.getFullYear()+"-"+curMonth+"-"+endDate;
  },
  currentDay: function(){
	  var curDate=new Date();
	  var curMonth = curDate.getMonth()+1; if(curMonth<10){curMonth='0'+curMonth;}
	  var curDay = curDate.getDate(); if(curDay<10){curDay='0'+curDay;}
	  return curDate.getFullYear()+"-"+curMonth+"-"+curDay;
  }
});

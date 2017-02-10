/**
 * daixiaoman  获取表单参数
 */
yihg_utils_fun = {
	getParams : function(paramDivId) {
		var params = {};
		var _$ = jQuery || $;
		_$("#" + paramDivId).find(" input , select ,textarea").each(
				function(i) {
					var jqObj = _$(this);
					var type = jqObj.attr("type");
					var val = _$.trim(jqObj.val());
					var name = jqObj.attr("name");
					if(!name){
						return true;
					}
					if (type == "text" || type == "hidden"
							|| jqObj.is("select") || type=="password") {
						params[name] = val;
					}

					if (type == "radio") {
						jqObj.attr("checked") && (params[name] = val);
					}

					if ((type == "checkbox")) {
						var checkAttr = jqObj.attr("checked");

						if (checkAttr && !params[name]) {
							params[name] = [];
						}
						checkAttr && (params[name]).push(val);
					}

					if (jqObj.is("textarea")) {
						params[name] = jqObj.val();
					}
				});
		return params;
	},
	resetParams : function(paramDivId, excludesMap) {
		var excludes = excludesMap || {};
		var _$ = jQuery || $;
		_$("#" + paramDivId).find(" input , select,textarea ").each(
				function(i) {
					var jqObj = _$(this);
					var type = jqObj.attr("type");
					var name = jqObj.attr("name");
					!excludes[name] && jqObj.val("");
				});
	},
	showParams : function(paramDivId, params) {
		var _$ = jQuery || $;
		_$("#" + paramDivId).find(" input , select,textarea ").each(
				function(i) {
					var jqObj = _$(this);
					var name = jqObj.attr("name");
					jqObj.val(params[name] || "");
				});
	},
	setDefault:function(paramDivId,params){
        var _$ = jQuery || $;
        _$("#"+paramDivId).find("input,select,textarea").each(function(i){
        	var jqObj = _$(this);
        	var name = jqObj.attr("name");
        	if(!name || !params[name]){
        		return true;
			}
			var paramsVal = params[_$.trim(name)];
			var type = jqObj.attr("type");
        	if(type == "text"  || type == "hidden" || jqObj.is("textarea") || jqObj.is("select") ){
                jqObj.val(paramsVal);
			}
			if(type == "radio"){
        		var radioval = jqObj.val();
        		jqObj.attr("checked",(radioval+"") == (paramsVal));
			}
			if(type == "checkbox"){

				var checkval = jqObj.val();
				if(_$.isArray(paramsVal) &&  _$.inArray(checkval,paramsVal) ){
                    jqObj.attr("checked",true);
				}else if(_$.type(paramsVal) == "string"){
					jqObj.attr("checked",(checkval == paramsVal));
				}

			}
		});
	}
}

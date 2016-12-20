/**
 * author:daixiaoman time:2016-11-30
 * 改js 要放在 top.jsp 后面引用
 * js 全局变量 yihg_erp_web_config 在path.jsp 里初始化
 * useage: 
 * jsp 页面:
 *                              <select id="provinceNameSelect" class="input-small" name="provinceId">
 *		                		</select>
 *	                		<select id="cityNameSelect" class="input-small" name="cityId">
 *		                		</select>
 *		                		<select id="areaNameSelect" class="input-small" name="areaId">
 *		                		</select> 
 *
 * js 调用：
 * 
 * 页面加载完成之后 调用方法 eleId id对应 jsp 页面dom 元素的id levelLinks 数组里的顺序 就是联动的顺序
 * 		linkProvinceSelect({
			levelLinks:[
		                {"eleId":"provinceNameSelect","defaultLabel":"请选择省"},
		                {"eleId":"cityNameSelect","defaultLabel":"请选择市"},
		                {"eleId":"areaNameSelect","defaultLabel":"请选择县"}
		                ]
		});
 * 
 */


 
// author:daixiaoman time: 2016-11-30 联动处理 YihgErpWebLinkSelectProvince 为模板
var parseLinkProvinceSelectTemplte = function(eleId, dataList, defaultLabel) {
	var templateData = {};
	templateData["regions"] = dataList || [];
	templateData["defaultLabel"] = defaultLabel || "请选择";
	var templateHtml = template("YihgErpWebLinkSelectProvince", templateData);
	eleId && $("#" + eleId).empty();
	eleId && $("#" + eleId).html(templateHtml);
}
// author:daixiaoman time: 2016-11-30 省 市 县 联动 levelLinks 的顺序为联动的顺序
var linkProvinceSelect = function(config) {
	var myConfig = $.extend({
		proviceUrl : yihg_erp_web_config["ctxPath"]+"/basic/getAllProvince.do",
		regionUrl : yihg_erp_web_config["ctxPath"]+"/basic/getRegion.do",
		levelLinks : [ {
			"eleId" : "provinceName",
			"defaultLabel" : "请选择省"
		}, {
			"eleId" : "cityName",
			"defaultLabel" : "请选择市"
		}, {
			"eleId" : "areaName",
			"defaultLabel" : "请选择县"
		} ],
		linkDataMap:{},
		firstDataList:[]
	}, config || {});

	var linkArray = myConfig.levelLinks || [];
	var linkMap = {};
	var defaultLabelMap = {};
	var index = 0;
	if (linkArray.length) {
		for (; index < linkArray.length; index++) {
			if ((index + 1) < linkArray.length) {
				linkMap[linkArray[index]["eleId"]] = linkArray[index + 1]["eleId"];
			}
			defaultLabelMap[linkArray[index]["eleId"]] = linkArray[index]["defaultLabel"];
		}
	}
	index = 0;
	for (; index < linkArray.length; index++) {
		var domEleId = linkArray[index]["eleId"];
		$("#" + domEleId).on(
				"change",
				{
					"eleId" : domEleId || ""
				},
				function(e) {
					// 联动下一级
					var nextEleId = linkMap[e.data.eleId];
					var currenSelectObj = $(this);
					var currenLinkVal = currenSelectObj.val();

					// 查询下一级数据
					myConfig.regionUrl && (currenLinkVal != "") && (!myConfig.linkDataMap[currenLinkVal+""]) && $.ajax(myConfig.regionUrl, {
						type : "post",
						dataType : "json",
						data : {
							"id" : currenLinkVal
						},
						success : function(data) {
							myConfig.linkDataMap[currenLinkVal+""] = data;
							parseLinkProvinceSelectTemplte(nextEleId,data,
									defaultLabelMap[nextEleId]);
						},
						error : function(data) {
							$.warn("查询信息失败");
						}
					});
					
					//数据已经被缓存 
					 parseLinkProvinceSelectTemplte(nextEleId,myConfig.linkDataMap[currenLinkVal+""] || [],
							defaultLabelMap[nextEleId]);
					 
					// 清空 nextEleId 以后的所有 select
					var nextEleIdToEnd = linkMap[nextEleId];
					while (nextEleIdToEnd) {
						parseLinkProvinceSelectTemplte(nextEleIdToEnd, [],
								defaultLabelMap[nextEleIdToEnd]);
						nextEleIdToEnd = linkMap[nextEleIdToEnd];
					}
				});
	}

	// 渲染省 第一级
	myConfig.proviceUrl && $.ajax(myConfig.proviceUrl, {
		type : "post",
		dataType : "json",
		success : function(data) {
			var myEleId = linkArray.length ? linkArray[0]["eleId"] : "";
			parseLinkProvinceSelectTemplte(myEleId, data,
					defaultLabelMap[myEleId]);
			// 触发默认显示
			$("#" + myEleId).trigger("change");
		},
		error : function() {
			$.warn("查询省信息失败");
		}
	});
	// 用firstDataList 渲染
	if(!myConfig.proviceUrl && myConfig.firstDataList && myConfig.firstDataList.length){
		var myEleId = linkArray.length ? linkArray[0]["eleId"] : "";
		parseLinkProvinceSelectTemplte(myEleId, myConfig.firstDataList,
				defaultLabelMap[myEleId]);
		// 触发默认显示
		$("#" + myEleId).trigger("change");
	}
}
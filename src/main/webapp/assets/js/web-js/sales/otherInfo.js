$(function() {
	$('#departureCity').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#arrivalCity').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#departureCity1').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#arrivalCity1').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	
	/**
	 * 飞机票
	 */
	$('#cityDeparture').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#cityArrival').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	/**
	 * 火车票
	 */
	$('#railwayTicketCityDeparture').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
	$('#railwayTicketCityArrival').autocomplete(cities, {
		max: 12, //列表里的条目数
		minChars: 0, //自动完成激活之前填入的最小字符
		width: 385, //提示的宽度，溢出隐藏
		scrollHeight: 300, //提示的高度，溢出显示滚动条
		matchContains: true, //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
		autoFill: false, //自动填充
		minChars:1,
		formatItem: function(row, i, max) {
		return row.name + '（'+row.pinyin+'）';
		},
		formatMatch: function(row, i, max) {
		return row.match;
		},
		formatResult: function(row) {
		return row.name;
		},resultsClass:'search-text'
		}).result(function(event, row, formatted) {
	});
});

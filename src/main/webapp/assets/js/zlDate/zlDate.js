(function($) {

	$.fn.priceCalandar = function(options) {
		var defaults = {
			date: new Date(),
			year: -1,
			month: -1,
			callbackFunc: null
		};
		var opts = $.extend({}, defaults, options);
		var container = $(this).attr("id");

		//通用方法
		var dateUtil = {
			getWeek: function() {
				var d = new Date(opts.year, opts.month - 1, 1);
				return d.getDay();
			},
			getDay: function() {
				var new_year = opts.year;
				var new_month = opts.month;
				var new_date = new Date(new_year, new_month, 1);
				return (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
			},
			setCurrentMonth: function() {
				var dt = opts.date;
				opts.year = dt.getFullYear();
				opts.month = dt.getMonth() + 1;
			},
			setPrevMonth: function() {
				if (opts.year == -1) {
					var dt = new Date(opts.date);
					opts.year = dt.getFullYear();
					opts.month = dt.getMonth() + 1;
				} else {
					var newMonth = opts.month - 1;
					if (newMonth <= 0) {
						opts.year -= 1;
						opts.month = 12;
					} else {
						opts.month -= 1;
					}
				}
			},
			setNextMonth: function() {
				if (opts.year == -1) {
					var dt = new Date(opts.date);
					opts.year = dt.getFullYear();
					opts.month = dt.getMonth() + 1;
				} else {
					var newMonth = opts.month + 1;
					if (newMonth > 12) {
						opts.year += 1;
						opts.month = 1;
					} else {
						opts.month += 1;
					}
				}
			}
		};

		var getHtml = {
			getHead: function() {
				var head = '<ul class="calendar_num basefix"><li class="bold">六</li><li>五</li><li>四</li><li>三</li><li>二</li><li>一</li><li class="bold">日</li><li class="picker_today bold" id="picker_today">今天</li></ul>';
				return head;
			},
			getLeft: function() {
				var left = '<div class="calendar_left pkg_double_month"><p class="date_text">' + opts.year + '年<br>' + opts.month + '月</p><a href="javascript:void(0);" title="上一月" id="picker_last" class="pkg_circle_top">上一月</a><a href="javascript:void(0);" title="下一月" id="picker_next" class="pkg_circle_bottom">下一月</a></div>';
				return left;
			},
			getRight: function() {
				var days = dateUtil.getDay();
				var week = dateUtil.getWeek();
				//alert('days=' + days + ',week=' + week);
				
				var html = '<table id="calendar_tab" class="calendar_right"><tbody>';
				var index = 0;
				for (var i = 1; i <= 42; i++) {
					if (index == 0) {
						html += "<tr>";
					}
					var c = week > 0 ? week : 0;
					var curDay = (i - c);
					if (curDay >= (week - c + 1) && (i - c) <= days) {

						var classStyle = "";
						var isToday = (opts.year == new Date().getFullYear() && opts.month == new Date().getMonth() + 1 && curDay == new Date().getDate());
						if (isToday) classStyle = "class='today'";
						var monthstr = (opts.month<10?'0'+opts.month:opts.month);
						var daystr = curDay<10?'0'+curDay:curDay;
						html += '<td  ' + classStyle + ' date="' + opts.year + "-" + monthstr + "-" + ((i - c) < 10 ? ('0' + (i - c)) : (i - c)) + '" price1="" price2="" stock=""><a><span class=" basefix">' + (isToday ? '今天' : (i - c)) + '</span><span class="stockState"></span><span class="calendar_price01"></span></a></td>';

						if (index == 6) {
							html += '</tr>';
							index = -1;
						}
					} else {
						html += "<td></td>";
						if (index == 6) {
							html += "</tr>";
							index = -1;
						}
					}
					index++;
				}
				html += "</tbody></table>";
				return html;
			}
		};

		//开始
		if (opts.year == -1)
			dateUtil.setCurrentMonth();

		var calandarInit = function() {
			var calandarStr = '<div id="calendar_choose" class="calendar" style="display: block; position: relative;">';
			calandarStr += getHtml.getHead();
			calandarStr += '<div class="basefix" id="bigCalendar" style="display: block;">';
			calandarStr += getHtml.getLeft();
			calandarStr += getHtml.getRight();
			calandarStr += '<div style="clear: both;"></div>';
			calandarStr += "</div></div>";
			$("#" + container).html(calandarStr);
			$("#" + container).find("#picker_last, #picker_next, #picker_today").bind("click", function() {
				var curId = $(this).attr("id");
				if (curId == "picker_last") dateUtil.setPrevMonth();
				if (curId == "picker_next") dateUtil.setNextMonth();
				if (curId == "picker_today") dateUtil.setCurrentMonth();
				
				calandarInit();
				if (opts.callbackFunc != null)
					eval(opts.callbackFunc+"('"+container+"',"+opts.year+","+opts.month+")");
			});
		};


		return this.each(function() {
			calandarInit();
			if (opts.callbackFunc != null)
				eval(opts.callbackFunc+"('"+container+"',"+opts.year+","+opts.month+")");
		});


	}

})(jQuery);
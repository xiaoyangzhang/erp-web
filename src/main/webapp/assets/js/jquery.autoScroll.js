(function ($) {
    //欧宗莹 2015-7-6
    /* css如下
    .fixBarNav_Container{position: relative;}
    .fixBarNav{position: absolute; top: 0px;}
    .fixBarNav li a{ height: 30px; text-align: right; background: url(product/img/product_Nav.png) no-repeat right 2px; padding-right: 20px;display: block; color: #666666;}
    .fixBarNav li.on a{ background: url(product/img/product_NavOn.png) no-repeat right 4px; color: #68c1e7; }
    .fixBarNav li:nth-last-of-type(1) a{ height: 30px; text-align: right; background: url(product/img/product_Nav_last.png) no-repeat right 2px; padding-right: 20px;}
    .fixBarNav li:nth-last-of-type(1).on a{ background: url(product/img/product_NavOn_last.png) no-repeat right 4px; color: #68c1e7; }
    */

    $.fn.autoScroll = function (options) {
        var defaults = {
            nav: ".fixBarNav", //导航悬浮框box
            controll_box: ".fixNav_Content", //对应内容显示的box  
            controll_row: "dt", //内容显示box  下面每一行 
            controll_row_input: "" //内容显示box  下面每一行 里面的输入框（当点击输入框时， nav内容也自动选中 ）可以为空
        };
        var opts = $.extend({}, defaults, options);

        //点击悬浮框 某一项时，滚动到对应的内容
        $(opts.nav + " a").click(function () {
            var target = $(this).attr("href");
            $(this).parent().addClass("on").siblings().removeClass("on");
            $("html,body").animate({ scrollTop: $(target).offset().top }, 500);
        });

        //屏幕滚动时，--固定悬浮框不要动
		
        $(window).scroll(function () {
            var winTop = $(window).scrollTop();
            var pTop = $(opts.controll_box).offset().top;
            if (winTop > pTop && winTop < (pTop + $(opts.controll_box).height())) {
                $(opts.nav).css("position", "fixed");
            } else {
                $(opts.nav).css("position", "absolute");
            }
			
			/*
            $(opts.controll_box + " " + opts.controll_row).each(function () {
                var next = $(this).attr("next");
                var nextTop = $("#" + next).offset().top, curTop = $(this).offset().top;
                //console.log('id=' + $(this).attr("id") + 'wintop:' + winTop + ',curTop:' + curTop + ',next=' + next + ',nextTop:' + nextTop);
                if (winTop > curTop && winTop < nextTop) {
                    $(opts.nav + " a[href*='#" + $(this).attr("id") + "']").parent().addClass("on").siblings().removeClass("on");
                }
            });
			*/
        });
		
        //点击编辑框后，左侧浮动设置为选中
        if (opts.controll_row_input != "") {
            $(opts.controll_box + " " + opts.controll_row_input).click(function () {
                var id = $(this).prev().attr("id");                $(opts.nav + " a[href='#" + id + "']").parent().addClass("on").siblings().removeClass("on");
            });
        }
    }
})(jQuery);

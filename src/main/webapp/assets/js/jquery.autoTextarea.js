(function ($) {
    $.fn.autoTextarea = function (options) {
        var defaults = {
            maxHeight: null,//�ı����Ƿ��Զ��Ÿߣ�Ĭ�ϣ�null�����Զ��Ÿߣ�����Զ��Ÿ߱���������ֵ����ֵ��Ϊ�ı����Զ��Ÿߵ����߶�  
            minHeight: $(this).height() //Ĭ����С�߶ȣ�Ҳ�����ı�������ĸ߶ȣ������ݸ߶�С������߶ȵ�ʱ���ı�������߶���ʾ  
        };
        var opts = $.extend({}, defaults, options);
        return $(this).each(function () {
            //paste cut keydown keyup focus blur
            $(this).bind("paste cut focus", function () {
                var height, style = this.style;
                this.style.height = opts.minHeight + 'px';
                if (this.scrollHeight > opts.minHeight) {
                    if (opts.maxHeight && this.scrollHeight > opts.maxHeight) {
                        height = opts.maxHeight;
                        style.overflowY = 'scroll';
                    } else {
                        height = this.scrollHeight - 10;
                        style.overflowY = 'hidden';
                    }
                    style.height = height + 'px';
                }
            });
        });
    };
})(jQuery);
//ʾ����$("input[type='area-area']").autoTextarea({minHeight:100}); 
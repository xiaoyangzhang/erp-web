
$(function(){
    var productRoute = new ProductRoute();
    productRoute.dayAdd();

    $('#routeForm').validate({
        errorElement: 'div',
        errorClass: 'help-block',
        focusInvalid: true,
        rules : {
        },
        messages: {
        },
        submitHandler: function (form) {
            $(form).ajaxSubmit({
                type : "post",
                cache : false,
                url : path + "/productInfo/route/save.do",
                dataType : 'json',
                async : false,
                success : function(data) {
                    if (data.success) {

                        $.success('操作成功', function(){
                            window.location.reload();
                        });

                    } else {
                        $.error('操作失败');
                    }
                },
                error : function(data) {
                    $.error('请求失败');
                }
            });
        },
        success: function (e) {

        }
    });
});
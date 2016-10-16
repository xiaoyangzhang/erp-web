$(function(){
    var salesRoute = new SalesRoute();
    salesRoute.dayAdd();

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
                url : "../groupRoute/saveGroupRoute.do",
                dataType : 'json',
                async : false,
                success : function(data) {
                    if (data.success) {
                        $.success('操作成功');
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

$(function(){
        $.ajax({
            type: "post",
            cache: false,
            url: path + "/productInfo/route/data.do",
            data: {
                productId: productId
            },
            dataType: 'json',
            async: false,
            success: function (data) {
                new ProductRoute(function(){
                    var days = data.productRoteDayVoList;
                    for(var i = 1; i <= days.length; i++){
                        var dayVo = days[i - 1];
                        this.dayAdd(dayVo.productRoute);
                        var trafficList = dayVo.productRouteTrafficList;
                        for(var j = 0; j < trafficList.length; j++){
                            this.trafficAdd(i, j, trafficList[j]);
                        }
                        var optionsSupplierList = dayVo.productOptionsSupplierList;
                        for(var k = 0; k < optionsSupplierList.length; k++){
                            this.supplierAdd(i, k, optionsSupplierList[k])
                        }
                        var imgList = dayVo.productAttachments;
                        for(var l = 0; l < imgList.length; l++){
                            imgList[l].thumb = img200Url + imgList[l].path;
                            this.imgAdd(i, l, imgList[l])
                        }
                    }
                });
            }
        });


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
                url : path + "/productInfo/route/edit.do",
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

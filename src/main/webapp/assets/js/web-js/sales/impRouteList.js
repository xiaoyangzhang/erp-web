$(function(){
    $.ajax({
        type: "post",
        cache: false,
        url : path + "/groupRoute/getImpData.do",
        data : {
            productId : productId
        },
        dataType: 'json',
        async: false,
        success: function (data) {
            new SalesRoute(function(){
                var days = data.groupRouteDayVOList;
                for(var i = 1; i <= days.length; i++){
                    var dayVo = days[i - 1];
                    this.dayAdd(dayVo.groupRoute);
                    var trafficList = dayVo.groupRouteTrafficList;
                    for(var j = 0; j < trafficList.length; j++){
                        this.trafficAdd(i, j, trafficList[j]);
                    }
                    var optionsSupplierList = dayVo.groupRouteOptionsSupplierList;
                    for(var k = 0; k < optionsSupplierList.length; k++){
                        this.supplierAdd(i, k, optionsSupplierList[k])
                    }
                    var imgList = dayVo.groupRouteAttachmentList;
                    for(var l = 0; l < imgList.length; l++){
                        imgList[l].thumb = img200Url + imgList[l].path;
                        this.imgAdd(i, l, imgList[l])
                    }
                }
            });
        }
    });

    $('#routeForm').validate({
        rules : {
        	'tourGroup.productBrandName' : {
				required : true
			},
			'tourGroup.productName' : {
				required : true
			}
        },
        submitHandler: function (form) {
            $(form).ajaxSubmit({
                type : "post",
                cache : false,
                url : path + "/groupRoute/editGroupRoute.do",
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

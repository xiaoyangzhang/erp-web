/**
 * 
 */


/**
 * 选择产品
 * @param groupId
 */
function importRoute(){
	
	if($("input[name='groupOrder.departureDate']").val()==''){
		$.warn("请先选择出发日期!");
		return ;
	}
	
	var win ;
	layer.open({ 
		type : 2,
		title : '导入行程',
		shadeClose : true,
		shade : 0.5,
        area : ['680px','480px'],
		content : '../route/list.htm?state=2',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
	        layer.close(index);
	        /**
	         * 给基本信息赋值
	         */
	        $.getJSON('../productInfo/getProductInfo.do?productId='+$("#productId").val(), function(data){
	        	$("input[name='groupOrder.productBrandId']").val(data.brandId);
	        	$("input[name='groupOrder.productBrandName']").val(data.brandName);
	        	$("input[name='groupOrder.productName']").val(data.nameCity);
	        	
	        	 $.getJSON('../productInfo/getProductMarks.do?productId='+$("#productId").val(), function(data){
	        		 $("#serviceStandard").val(data.serveLevel);
	        		 $("#warmTip").val(data.warmTip);
	        		 $("#remark").val(data.remarkInfo);
	        	 });
	        	
	        	
	        	
	        });
	        /**
	         * 查找行程
	         */
	        $.ajax({
	            type: "post",
	            cache: false,
	            url : path + "/groupRoute/getImpData.do",
	            data : {
	                productId :$("#productId").val()
	            },
	            dataType: 'json',
	            async: false,
	            success: function (data) {
	            	$(".day_content").html('');
	                
	                    var days = data.groupRouteDayVOList;
	                    for(var i = 1; i <= days.length; i++){
	                        var dayVo = days[i - 1];
	                        salesRoute.dayAdd(dayVo.groupRoute);
	                        var trafficList = dayVo.groupRouteTrafficList;
	                        for(var j = 0; j < trafficList.length; j++){
	                        	salesRoute.trafficAdd(i, j, trafficList[j]);
	                        }
	                        var optionsSupplierList = dayVo.groupRouteOptionsSupplierList;
	                        for(var k = 0; k < optionsSupplierList.length; k++){
	                        	salesRoute.supplierAdd(i, k, optionsSupplierList[k])
	                        }
	                        var imgList = dayVo.groupRouteAttachmentList;
	                        for(var l = 0; l < imgList.length; l++){
	                            imgList[l].thumb = img200Url + imgList[l].path;
	                            salesRoute.imgAdd(i, l, imgList[l])
	                        }
	                    }
	               
	            }
	        });
	        
	        
	        
	        
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
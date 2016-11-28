
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
        area : ['850px','520px'],
		content : '../route/list.htm?state=2',
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			$("#orderBusiness").val("aa");
	        layer.close(index);
	        /**
	         * 给基本信息赋值
	         */
	        $.getJSON('../productInfo/getProductInfo.do?productId='+$("#productId").val(), function(data){
	        	$("input[name='groupOrder.productBrandId']").val(data.brandId);
	        	$("input[name='groupOrder.productBrandName']").val(data.brandName);
	        	$("input[name='groupOrder.productName']").val(data.nameCity);
	        	$("#addBtn").css("display","");
	        });
	        $.getJSON('../productInfo/getProductMarks.do?productId='+$("#productId").val(), function(data){
       		 $("#serviceStandard").val(data.serveLevel);
       		 $("#remark").val(data.remarkInfo);
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
	        
	        
	        
	        
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 选择库存
 * @param groupId
 */
function stockOpt(){
	if($("input[name='groupOrder.departureDate']").val()==''){
		$.warn("请先选择出发日期!");
		return ;
	}
	 var itemDate =$("input[name='groupOrder.departureDate']").val();
	var win ;
	layer.open({ 
		type : 2,
		title : '导入行程',
		shadeClose : true,
		shade : 0.5,
        area : ['680px','480px'],
		content : '../route/StockProduct_list.htm?state=2&itemDate='+itemDate,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			$("#orderBusiness").val("stock");
	        layer.close(index);
	        /**
	         * 给基本信息赋值
	         */
	        $.getJSON('../productInfo/getProductInfo.do?productId='+$("#productId").val(), function(data){
	        	$("input[name='groupOrder.productBrandId']").val(data.brandId);
	        	$("input[name='groupOrder.productBrandName']").val(data.brandName);
	        	$("input[name='groupOrder.productName']").val(data.nameCity);
	        	$("#addBtn").css("display","");
	        });
	        $.getJSON('../productInfo/getProductMarks.do?productId='+$("#productId").val(), function(data){
       		 $("#serviceStandard").val(data.serveLevel);
       		 $("#remark").val(data.remarkInfo);
       	 	});
	        $.getJSON('../productInfo/getStockCount.do?productId='+$("#productId").val()+"&itemDate="+itemDate, function(data){
	        	$("#stockCount").val(data.stockCount);
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
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 选择库存
 */
function stockOpt_TaobaoProduct(){
	var itemDate =$("input[name='groupOrder.departureDate']").val();
	if(itemDate==''){
		$.warn("请先选择出发日期!");
		return ;
	}
	var win ;
	layer.open({ 
		type : 2,
		title : '导入行程',
		shadeClose : true,
		shade : 0.5,
        area : ['850px','520px'],
		content : '../taobaoProect/TaoBaoProductStockDlg.htm?stockDate='+itemDate,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var body = layer.getChildFrame('body', index);
			body.find("input[name='stockDateId']").each(function(){
				if ($(this).attr("checked") || $(this).prop("checked")){
					//${res['stock_id']}^${res['stockDateId']}^${res['stockBalance']}^${res['outer_id']}
					var ary = $(this).val().split('^');
					$("#orderBusiness").val("stock");
					$("input[name='groupOrder.productBrandId']").val(ary[0]);
					$("input[name='groupOrder.productId']").val(ary[1]);
					$("#stockCount").text(ary[2]);
					$("input[name='groupOrder.productName']").val(ary[3]);
					limitInput();
			    }
			});
			
	        layer.close(index);
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

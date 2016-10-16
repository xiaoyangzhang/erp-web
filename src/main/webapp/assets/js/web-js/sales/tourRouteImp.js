function importRoute(groupId){
	
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
	         * 当用户没有选择行程时，当前页面不刷新
	         */
	        if($("#productId").val()!=null&&$("#productId").val()!=""){
	        	 window.location=path+"/groupRoute/toImpRouteList.htm?orderId="+$("#orderId").val()+"&groupId="+groupId+"&productId="+$("#productId").val();
	        }
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
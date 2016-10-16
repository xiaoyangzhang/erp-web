function toPreview(){
	
	$("#toPreview").attr("href","../query/toOrdersPreview.do?startTime="
			+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&supplierName="+$("#supplierName").val()
			+"&provinceId="+$("#provinceCode option:selected").val()
			+"&cityId="+$("#cityCode option:selected").val()
			+"&groupCode="+$("#groupCode").val()
			+"&paymentState="+$("#paymentState").val()
			+"&productName="+$("#productName").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&groupMode="+$("#groupMode").val()
			+"&type="+$("#type option:selected").val()
			+"&orgIds="+$("#orgIds").val()
			) ; 
}
function toPaymentStaticPreview(){
	
	$("#toPaymentStaticPreview").attr("href","../query/paymentStaticPreview.htm?startTime="
		+$("#startTime").val()
		+"&endTime="+$("#endTime").val()
		+"&supplierName="+$("#supplierName").val()
		+"&paymentState="+$("#paymentState").val()
		+"&productName="+$("#productName").val()
		+"&saleOperatorIds="+$("#saleOperatorIds").val()
		+"&groupMode="+$("#groupMode").val()
		+"&orgIds="+$("#orgIds").val()
		+"&type="+$("#type option:selected").val()
		) ; 
}
function toPaymentPreview(supplierId,obj){
	$(obj).attr("href","../query/toPaymentPreview.do?startTime="
			+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&supplierName="+$("#supplierName").val()
			+"&supplierId="+supplierId
			+"&paymentState="+$("#paymentState").val()
			+"&productName="+$("#productName").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&groupMode="+$("#groupMode").val()
			+"&type="+$("#type option:selected").val()
			+"&orgIds="+$("#orgIds").val()
			) ;  
}

function toPaymentList(num){
	if(num==1){
		window.location = "../query/paymentList.htm" ;
	}else{
		window.location = window.location ;
	}
}

function toPaymentDetailList(num){
	if(num==1){
		window.location = window.location ;
	}else{
		window.location = "../query/paymentDetailList.htm" ;
	}
}
function toPaymentDetail(supplierId){
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/paymentDetailList.htm") ;
	$("form").submit();
}


function queryList(page,pagesize) {
	
	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"../common/queryListPage.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
   // $("#type").val($("#slt option:selected").val());
    $("#form").ajaxSubmit(options);	
}

$(function() {
	var vars={
	   dateFrom : $.currentMonthFirstDay(),
 	   dateTo : $.currentMonthLastDay()
 	};
	if(!$("#startTime").val()){$("#startTime").val(vars.dateFrom);}
	if(!$("#endTime").val()){$("#endTime").val(vars.dateTo );}
	//设置默认日期，调用查询
	queryList(1,$("#searchPageSize").val());
});


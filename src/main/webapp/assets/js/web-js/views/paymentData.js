function toPreview(){
	var orgIds = '' ;
	var operatorIds = $("#operatorIds").val();
	if(operatorIds==''){
		orgIds = $("#orgIds").val();
		if(orgIds!=''){
			$.ajax({
				url : "../query/getEmployeeIds.htm",
				type : "post",
				async : false,
				data : {
					"orgIds" : orgIds
				},
				dataType : "json",
				success : function(data) {
					if (data.success) {
						 $("#operatorIds").val(data.employeeIds);
					}else {
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
				}
			});
		}
	}
	$("#toPreview").attr("href","../query/toOrdersPreview.do?startTime="
			+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&supplierName="+$("#supplierName").val()
			+"&provinceId="+$("#provinceCode option:selected").val()
			+"&cityId="+$("#cityCode option:selected").val()
			+"&groupCode="+$("#groupCode").val()
			+"&paymentState="+$("#paymentState").val()
			+"&productName="+$("#productName").val()
			+"&operatorIds="+$("#operatorIds").val()
			+"&groupMode="+$("#groupMode").val()
			+"&type="+$("#type").val()
			) ; 
}

function toPaymentPreview(supplierId){
	$("#toPaymentPreview").attr("href","../query/toPaymentPreview.do?startTime="
			+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&supplierName="+$("#supplierName").val()
			+"&supplierId="+supplierId
			+"&paymentState="+$("#paymentState").val()
			+"&productName="+$("#productName").val()
			+"&operatorIds="+$("#operatorIds").val()
			+"&groupMode="+$("#groupMode").val()
			+"&type="+$("#type").val()
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
	var orgIds = '' ;
	var operatorIds = $("#operatorIds").val();
	if(operatorIds==''){
		orgIds = $("#orgIds").val();
		if(orgIds!=''){
			$.ajax({
				url : "../query/getEmployeeIds.htm",
				type : "post",
				async : false,
				data : {
					"orgIds" : orgIds
				},
				dataType : "json",
				success : function(data) {
					if (data.success) {
						 $("#operatorIds").val(data.employeeIds);
					}else {
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
				}
			});
		}
	}
	
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
    $("#type").val($("#slt option:selected").val());
    $("#form").ajaxSubmit(options);	
    
}
function setData(){
	var curDate=new Date();
	 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
	 $("#startTime").val(startTime);
	var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
     $("#endTime").val(endTime);			
}


$(function() {
	setData();
	queryList();
});


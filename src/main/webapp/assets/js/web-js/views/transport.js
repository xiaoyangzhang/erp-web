var array = [] ;
function toClear(){
	$("#startTime").val("");
	$("#endTime").val("");
	$("#coachMethod").val("");
	$("#transportType").val("");
	$("#sortMethod").val("");
	$("#departureCity").val("");
	$("#arrivalCity").val("");
	$("#destination").val("");
	$("#groupCode").val("");
}

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"../query/getSupplierStatistics",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#tableDiv").html(data);
    		    /*$("#payTable tr").each(function(index){
    				var tdValue = $(this).find('td').eq(6);
    				alert(tdValue.text());
    				if(tdValue.text()!=""){
    					$("#transportType option").each(function(){ //遍历全部option 
    	    		    	var key = $(this).val();
    	    		        var value = $(this).text(); //获取option的内容 
	    		        	if(key==tdValue.text().trim()){
	    		        		tdValue.text(value);
	    		        	}
    	    		    });
    				}
    			});*/
    		    $(".sm").each(function(index){
    		    	var vv = $(this) ;
    		    	$("#transportType option").each(function(){ //遍历全部option 
	    		    	var key = $(this).val();
	    		        var value = $(this).text(); //获取option的内容 
    		        	if(key==vv.text() && key!=''){
    		        		vv.text(value);
    		        	}
	    		    });
    		    });
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#form").ajaxSubmit(options);	
}

$(function() {
	 var vars={
	   			 dateFrom : $.currentMonthFirstDay(),
	   		 	dateTo : $.currentMonthLastDay()
	   		 	};
		$("#startTime").val(vars.dateFrom);
		$("#endTime").val(vars.dateTo );	
		
	queryList();
});


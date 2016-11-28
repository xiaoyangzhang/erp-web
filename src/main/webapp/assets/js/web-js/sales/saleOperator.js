function toPreview(){
	$("#toPreview").attr("href","../query/toSaleOperatorPreview.htm?startTime="
			+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&supplierName="+$("#supplierName").val()
			+"&groupCode="+$("#groupCode").val()
			+"&productName="+$("#productName").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&guestName="+$("#guestName").val()
			+"&mobile="+$("#mobile").val()
			+"&select="+$("#select").val()
			+"&mergeGroupState="+$("#mergeGroupState").val()  
			) ; 
}
function toClear(){
	$("#operatorIds").val("");
	$("#operatorName").val("");
}
function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}

function queryList(page,pagesize) {	
    if (!page || page < 1) {
    	page = 1;
    }
    $("#page").val(page);
    $("#pageSize").val(pagesize);
    
    var options = {
		url:"../query/toSaleOperatorTable.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    		$('.rich_text').each(function(){
    	        $(this).html($(this).html().replace(/,/g,'<br/>'));
    	    });
    		$('.rich_text1').each(function(){
    	        $(this).html($(this).html().replace(/@/g,'<br/>'));
    	    });
    		$(".hl").each(function(index){
		    	var vv = $(this) ;
		    	$("#hotelLevel option").each(function(){ //遍历全部option 
    		    	var key = $(this).val();
    		        var value = $(this).text(); //获取option的内容 
		        	if(key==vv.text().trim()){
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
/*function setData(){
	var curDate=new Date();
	 var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
	 $("#startTime").val(startTime);
	var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
     $("#endTime").val(endTime);			
}*/
$(function() {
	//setData();
	var vars={
  			 dateFrom : $.currentDay(),
  		 	dateTo : $.currentDay()
  		 	};
  	$("#startTime").val(vars.dateFrom);
  	$("#endTime").val(vars.dateTo );
	queryList();
});
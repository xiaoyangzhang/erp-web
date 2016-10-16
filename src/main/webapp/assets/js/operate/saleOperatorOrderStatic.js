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
		url:"../query/toSaleOperatorOrderStaticTable.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
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
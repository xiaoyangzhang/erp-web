
function lockOrUnLock(orderId,obj){
	$.confirm("确认变更吗？", function() {
		var orderLockState = 0 ;
		if($(obj).text().trim()==="锁单"){
			orderLockState = 0 ;
		}else if($(obj).text().trim()==="解锁"){
			orderLockState = 1 ;
		}
		$.ajax({
			url : "../groupOrder/updateOrderLockState.do",
			type : "post",
			async : false,
			data : {
				"orderId" : orderId,
				"orderLockState":orderLockState
			},
			dataType : "json",
			success : function(data) {
				if (data.sucess) {
					if(data.orderLockState==1){
						$(obj).text("锁单");
					}else{
						$(obj).text("解锁");
					}
					$.success('变更成功');
				}else{
					$.warn(data.msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				window.location = window.location;
			}
		});
	}, function() {
		$.info('取消变更');
	});
	
}

function batchUpdate(){
	$("input[name=selectOne]:checked").each(function(){
		var obj = $(this) ;
		var orderId = $(this).val();
		var orderLockState = $(obj).attr("id");
		$.ajax({
			url : "../groupOrder/updateOrderLockState.do",
			type : "post",
			async : false,
			data : {
				"orderId" : orderId,
				"orderLockState":orderLockState
			},
			dataType : "json",
			success : function(data) {
				if (!data.sucess) {
					$.warn(data.msg);
				}
			},
			error : function(XMLHttpRequest, textStatus, errorThrown) {
				$.error(textStatus);
				window.location = window.location;
			}
		});
	}) ;
	
	searchBtn();
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
		url:"../groupOrder/toOrderLockTable.htm",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    		$("#selectAll").change(function(){
    			if($(this).attr('checked')=='checked'){
    				$("[name='selectOne']").attr('checked','checked') ;
    			}else{
    				$("[name='selectOne']").each(function(){
    					$(this).removeAttr('checked') ;
    				}) ;
    			}
    		}) ;
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
			 $("#tourGroupStartTime").val(startTime);
			var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
		     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
		    var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
		     $("#tourGroupEndTime").val(endTime);			
		}
		
	//queryList();
	
	 


$(function() {
	setData();
	queryList();
});
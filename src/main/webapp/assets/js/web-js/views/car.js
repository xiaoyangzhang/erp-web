function changePrice(obj,id){
        $(obj).hide() ;
       	$(obj).after('<input type="text" style="width:30%" id="newPrice" value='+$(obj).text()+' />');
       	$("#newPrice").mouseout(
       			function(e) {
       				jQuery.ajax({
       					url : "../booking/savePrice.htm",
       					type : "post",
       					async : false,
       					data : {
       						"id" : id,
       						"price":$("#newPrice").val()
       					},
       					dataType : "json",
       					success : function(data) {
   							$("#newPrice").remove();
       						$(obj).text(data.operatePrice) ;
       						$(obj).show();
       					},
       					error : function(XMLHttpRequest, textStatus, errorThrown) {
       						$.error(textStatus);
       					}
       				});
       			});
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
function toClear(){
	$("#operatorIds").val("");
	$("#operatorName").val("");
}
function selectUserMuti(){
	var width = window.screen.width ;
	var height = window.screen.height ;
	var wh = (width/1920*650).toFixed(0) ;
	var hh = (height/1080*500).toFixed(0) ;
	wh = wh+"px" ;
	hh = hh+"px" ;
	var lh = (width/1920*400).toFixed(0) ;
	var th = (height/1080*100).toFixed(0) ;
	lh = lh+"px" ;
	th = th+"px" ;
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [wh,hh],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList();   
			
			$("#operatorIds").val("");
			$("#operatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#operatorName").val($("#operatorName").val()+userArr[i].name);
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id);
				}else{
					$("#operatorName").val($("#operatorName").val()+userArr[i].name+",");
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id+",");
				}
			}
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
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
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#form").ajaxSubmit(options);	
    
}













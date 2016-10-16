$(document).ready(function () { 
	$("input[id='unitPrice']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice']").val();
		 var numTimes = $("input[id='numTimes']").val();
		 var numPerson =$("input[id='numPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice']").val(formatNumber(total,2));
	});  
	$("input[id='numTimes']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice']").val();
		 var numTimes = $("input[id='numTimes']").val();
		 var numPerson =$("input[id='numPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice']").val(formatNumber(total,2));
	});  
	$("input[id='numPerson']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice']").val();
		 var numTimes = $("input[id='numTimes']").val();
		 var numPerson =$("input[id='numPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice']").val(formatNumber(total,2));
	});  
   //修改部分
	$("input[id='unitPrice1']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice1']").val();
		 var numTimes = $("input[id='numTimes1']").val();
		 var numPerson =$("input[id='numPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice1']").val(formatNumber(total,2));
	});  
	$("input[id='numTimes1']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice1']").val();
		 var numTimes = $("input[id='numTimes1']").val();
		 var numPerson =$("input[id='numPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice1']").val(formatNumber(total,2));
	});  
	$("input[id='numPerson1']").on('input',function(e){  
		 var unitPrice =$("input[id='unitPrice1']").val();
		 var numTimes = $("input[id='numTimes1']").val();
		 var numPerson =$("input[id='numPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='totalPrice1']").val(formatNumber(total,2));
	}); 
});
function formatNumber(s, n) {
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
    return s.replace(".00", "");
}
$(function() {
	/**
	 * 新增项目弹出层form
	 */
	$("#addBudgetItemForm").validate({
		rules : {
			'itemName' : {
				required : true
			},
			'unitPrice' : {
				required : true,
				number :true
			},
			'numTimes' : {
				required : true,
				number :true
			},
			'numPerson' : {
				required : true,
				number :true
			}
		},
		errorPlacement : function(error, element) {
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) {
				error.appendTo(element.parent()); 
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var options = {
				url : "../budgetItem/saveBudgetItem.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功');
						window.location = window.location;
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试');
				}
			};
			$("#item").val($("#sl option:selected").text());
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	
	//修改项目弹出层form
	$("#editBudgetItemForm").validate({
		rules : {
			'itemName' : {
				required : true
			},
			'unitPrice' : {
				required : true,
				number :true
			},
			'numTimes' : {
				required : true,
				number :true
			},
			'numPerson' : {
				required : true,
				number :true
			}
		},
		errorPlacement : function(error, element) {
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) {
				error.appendTo(element.parent()); 
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var options = {
				url : "../budgetItem/updateBudgetItem.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功');
						window.location = window.location;
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试', {
						icon : 5
					});
				}
			};
			$("#item1").val($("#sl1 option:selected").text());
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
});

function newItem(){
	$("#sl").val("");
	$("#id").val("");
	$("#unitPrice").val("");
	$("#numTimes").val("1");
	$("#numPerson").val("1");
	$("#totalPrice").val("");
	$("#remark").val("");
	/*var width = window.screen.width ;
	var height = window.screen.height ;
	var wh = (width/1920*650).toFixed(0) ;
	var hh = (height/1080*420).toFixed(0) ;
	wh = wh+"px" ;
	hh = hh+"px" ;
	var lh = (width/1920*400).toFixed(0) ;
	var th = (height/1080*100).toFixed(0) ;
	lh = lh+"px" ;
	th = th+"px" ;*/
	layer.open({
		type : 1,
		title : '新增价格',
		shadeClose : true,
		shade : 0.5,
        area : ['500px','400px'],
		content :$('#addBudgetItem')
	});
}

function toEdit(id){
	$.getJSON("../budgetItem/editBudgetItem.do?id=" + id, function(data) {
		$("#sl1").val(data.itemId);
		$("#id").val(data.id);
		$("#unitPrice1").val(data.unitPrice);
		$("#numTimes1").val(data.numTimes);
		$("#numPerson1").val(data.numPerson);
		$("#totalPrice1").val(data.totalPrice);
		$("#remark1").val(data.remark);
		$("#orderId1").val(data.orderId);
	});
	layer.open({ 
		type : 1,
		title : '修改价格',
		shadeClose : true,
		shade : 0.5,
		 area : ['500px','400px'],
		content :$('#editBudgetItem')
	});
}

function deleteBudgetItemById(obj,id){
	$.confirm("确认删除吗？",function(){
		$.getJSON("../budgetItem/deleteBudgetItemById.do?id=" + id, function(data) {
			if (data.success) {
				//$(obj).closest("tr").remove();
				$.info('删除成功！');
				window.location = window.location ;
			}
		});
	},function(){
		$.info('取消删除');
	});	
}

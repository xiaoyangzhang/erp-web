$(document).ready(function () {
	/**
	 * 新增计算价格总额
	 */
	$("input[id='costUnitPrice']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice']").val();
		 var numTimes = $("input[id='costNumTimes']").val();
		 var numPerson =$("input[id='costNumPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice']").val(total.toFixed(2));
	});  
	$("input[id='costNumTimes']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice']").val();
		 var numTimes = $("input[id='costNumTimes']").val();
		 var numPerson =$("input[id='costNumPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice']").val(total.toFixed(2));
	});  
	$("input[id='costNumPerson']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice']").val();
		 var numTimes = $("input[id='costNumTimes']").val();
		 var numPerson =$("input[id='costNumPerson']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice']").val(total.toFixed(2));
	}); 
	
	/**
	 * 修改计算价格总额
	 */
	$("input[id='costUnitPrice1']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice1']").val();
		 var numTimes = $("input[id='costNumTimes1']").val();
		 var numPerson =$("input[id='costNumPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice1']").val(total.toFixed(2));
	});  
	$("input[id='costNumTimes1']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice1']").val();
		 var numTimes = $("input[id='costNumTimes1']").val();
		 var numPerson =$("input[id='costNumPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice1']").val(total.toFixed(2));
	});  
	$("input[id='costNumPerson1']").on('input',function(e){  
		 var unitPrice =$("input[id='costUnitPrice1']").val();
		 var numTimes = $("input[id='costNumTimes1']").val();
		 var numPerson =$("input[id='costNumPerson1']").val();
		 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
		 $("input[id='costTotalPrice1']").val(total.toFixed(2));
	}); 
});

$(function() {
	/**
	 * 新增项目弹出层form
	 */
	$("#addCostItemForm").validate({
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
				url : "../costItem/saveCostItem.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							window.location = window.location ;
						});
						
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
			$("#costItem").val($("#costSl option:selected").text());
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	
	//修改项目弹出层form
	$("#editCostItemForm").validate({
		rules : {
			'itemName' : {
				required : true
			},
			'costUnitPrice' : {
				required : true,
				number :true
			},
			'costNumTimes' : {
				required : true,
				number :true
			},
			'costNumPerson' : {
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
				url : "../costItem/updateCostItem.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							window.location = window.location;
						});
					} else {
						$.error(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试');
				}
			};
			$("#costItem1").val($("#costSl1 option:selected").text());
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	var totals = 0 ;
	$("#ibib tr").each(function(index){
		var v = $(this).find('td').eq(5).text();
		totals += Number(v);
	});
	$("#totals").text(formatNumber(totals,2));
});
function formatNumber(s, n) {
    n = n > 0 && n <= 20 ? n : 2;
    s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";
    return s.replace(".00", "");
}
function newCostItem(){
	$("#costId").val("");
	$("#costUnitPrice").val("");
	$("#costNumTimes").val("1");
	$("#costNumPerson").val("1");
	$("#costTotalPrice").val("");
	$("#costRemark").val("");
	$("#costSl").val("");
	layer.open({
		type : 1,
		title : '新增成本',
		shadeClose : true,
		shade : 0.5,
		area : ['500px','390px'],
		content :$('#addCostItem')
	});
}

function toEditCostItem(id){
	$.getJSON("../costItem/editCostItem.do?id=" + id, function(data) {
		$("#costId").val(data.id);
		$("#costUnitPrice1").val(data.unitPrice);
		$("#costNumTimes1").val(data.numTimes);
		$("#costNumPerson1").val(data.numPerson);
		$("#costTotalPrice1").val(data.totalPrice);
		$("#costRemark1").val(data.remark);
		$("#orderId1").val(data.orderId);
		$("#costSl1").val(data.itemId);
	});
	layer.open({ 
		type : 1, 
		title : '修改成本', 
		shadeClose : true, 
		shade : 0.5,
		area : ['500px','390px'],
		content :$('#editCostItem')
	});
}

function deleteCostItemById(obj,id){
	$.confirm("确认删除吗？",function(){
		$.getJSON("../costItem/deleteCostItemById.do?id=" + id, function(data) {
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


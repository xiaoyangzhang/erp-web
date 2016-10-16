$(function() {
	/**
	 * 新增接送信息弹出层form
	 */
	$("#addSeatInCoachItemForm").validate({
		rules : {
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
				url : "../seatInCoach/saveSeatInCoach.do",
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
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	
	/**
	 * 修改接送信息弹出层form
	 */
	$("#editSeatInCoachItemForm").validate({
		rules : {
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
				url : "../seatInCoach/updateSeatInCoach.do",
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
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	
	/**
	 * 批量录入的隐藏和显示
	 */
	$(".pp").toggle(function() {
		$("#bbb").show();
	}, function() {
		$("#bbb").hide();
	});
});
function newSeatInCoach(){
	$("#s").val("");
	$("#classNo").val("");
	$("#departureCity").val("");
	$("#departureStation").val("");
	$("#departureDate").val("");
	$("#departureTime").val("");
	$("#arrivalCity").val("");
	$("#arrivalStation").val("");
	//$("#arrivalTime").val("");
	$("#destination").val("");
	$("#seatInCoachId").val("");
	layer.open({
		type : 1,
		title : '添加接送信息',
		shadeClose : true,
		shade : 0.5,
        area : ['450px','440px'],
		content :$('#addSeatInCoachItem')
	});
}
function toEditSeatInCoach(id){
	$.getJSON("../seatInCoach/editSeatInCoach.do?id=" + id, function(data) {
		$("input[id='type1'][value=" + data.type + "]").attr("checked", true);
		$("#s1").val(data.method);
		$("#classNo1").val(data.classNo);
		$("#departureCity1").val(data.departureCity);
		$("#departureDate1").val(data.departureDate);
		$("#departureTime1").val(data.departureTime);
		$("#arrivalCity1").val(data.arrivalCity);
		//$("#arrivalTime1").val(data.arrivalTime);
		$("#destination1").val(data.destination);
		$("#seatInCoachId").val(data.id);
	});
	layer.open({ 
		type : 1,
		title : '修改接送信息',
		shadeClose : true,
		shade : 0.5,
		area : ['450px','440px'],
		content :$('#editSeatInCoachItem')
	});
}
function deleteSeatInCoachById(obj,id){
	$.confirm("确认删除吗？",function(){
		$.getJSON("../seatInCoach/deleteSeatInCoachById.do?id=" + id, function(data) {
			if (data.success) {
				$(obj).closest("tr").remove();
				$.info('删除成功！');
			}
		});
	},function(){
		$.info('取消删除');
	});	
}

function toSaveSeatInCoach(strr) {
	var html = $("#trans_template").html();
	// 订单id
	var orderId = $("#orderId").val();
	var str = $("#bit").val();
	if (str == "" || str == null) {
		$.warn("输入信息为空");
		return false;
	}
	var strs = new Array();
	strs = str.split("\n");
	// 比对当前输入人数是否定制团人数范围之内
	for (var i = 0; i < strs.length; i++) {
		if (strs[i] != "") {
			var infos = new Array();
			var va = strs[i].toString().replace("\n", "").replace(/，/g,
					",").replace(/。/g, ",");
			infos = va.split(",");
			if (infos.length != 5&&infos.length!=3) {
				$.warn("第" + eval(i + 1) + "行输入格式有误！");
				return false ;
			}
			if(infos.length==5){
				var count = $("#"+strr+"Data").children('tr').length;
				html = template('trans_template', {index : count});
				$("#"+strr+"Data").append(html);
				$("input[name='groupOrderTransportList["+count+"].departureDate']").val(infos[0]);
				$("input[name='groupOrderTransportList["+count+"].departureTime']").val(infos[1]);
				//$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
				$("input[name='groupOrderTransportList["+count+"].departureCity']").val(infos[3]);
				$("input[name='groupOrderTransportList["+count+"].arrivalCity']").val(infos[4]);
			}
			if(infos.length==3){
				var count = $("#"+strr+"Data").children('tr').length;
				html = template('trans_template', {index : count});
				$("#"+strr+"Data").append(html);
				$("input[name='groupOrderTransportList["+count+"].departureDate']").val(infos[0]);
				$("input[name='groupOrderTransportList["+count+"].departureTime']").val(infos[1]);
				//$("input[name='groupOrderTransportList["+count+"].arrivalTime']").val(infos[1]);
				$("input[name='groupOrderTransportList["+count+"].classNo']").val(infos[2]);
			}
			
		}
	}
	$("#bbb").hide();
}
/**
 * 
 */

$(function(){
	setData();
	queryList();
	$("#provinceCode").change(
			function() {
				if ($("#provinceCode").val() != -1) {
					
					$.getJSON("../basic/getRegion.do?id="
							+ $("#provinceCode").val(), function(data) {
						data = eval(data);
						var s = "<option value='-1'>请选择市</option>";
						$.each(data, function(i, item) {
							s += "<option value='" + item.id + "'>" + item.name
									+ "</option>";
						});
						$("#cityCode").html(s);
						$("#provinceName").val($("#provinceCode option:selected").text());
						
					});
				}else {
					$("#cityCode").html("<option value='-1'>请选择市</option>");
					$("#provinceName").val('');
				}

	});
	

	
	
	
	 $("#ckAll").live("click",function(){
		 $("input[name='chkFitOrder']:enabled").prop("checked", this.checked);
	 });
	 $("input[name='chkFitOrder']").live("click",function() {
	    var $subs = $("input[name='chkFitOrder']");
	    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
	 });
	
});
function setData(){
	var curDate=new Date();
	var startTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-01";
	 $("input[name='startTime']").val(startTime);
	var new_date = new Date(curDate.getFullYear(),curDate.getMonth()+1,1);                  
     var endDate=(new Date(new_date.getTime()-1000*60*60*24)).getDate();
     var endTime=curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+endDate;
     $("input[name='endTime']").val(endTime);			
}

function delGroupOrder(id) {
	$.confirm("确认删除吗？", function() {
		$.getJSON("../agencyFit/delGroupOrder.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					searchBtn();
				});
			}else {
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});

}

function insertGroupByList(){
	
	var chk_value = [];
	$("input[name='chkFitOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行加入团操作');
		return;
	}
	
	$.get("../agencyFit/beforeInsertGroup.htm?ids="+chk_value, function(data){
		  if(data.success){
					var win=0;
					layer.open({ 
						type : 2,
						title : '选择散客团',
						closeBtn : false,
						area : [ '900px', '500px' ],
						shadeClose : true,
						content : '../agencyFit/getInsertFitGroupList.htm?tid='+chk_value[0],
						btn: ['确定', '取消'],
						success:function(layero, index){
							win = window[layero.find('iframe')[0]['name']];
						},
						yes: function(index){
							var code = win.getCode();
							$.post("../agencyFit/insertGroupMany.do", { ids: chk_value.toString(), code: code }, function(data){
								  if(data.success){
									  $.success('操作成功',function(){
										searchBtn();
										layer.close(index); 
										})
								  }else{
									  $.error(data.msg);
								  }
							},"json");
							
							
					       
					    },cancel: function(index){
					    	layer.close(index);
					    }
					});

		  }else{
			  $.error(data.msg);
		  }
	},"json");
	
}


function insertGroup(tid){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择散客团',
		closeBtn : false,
		area : [ '900px', '500px' ],
		shadeClose : true,
		content : '../agencyFit/getInsertFitGroupList.htm?tid='+tid,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			
			var code = win.getCode();
			$.post("../fitOrder/insertGroup.do", { id: tid, code: code }, function(data){
				  if(data.success){
					  $.success('操作成功',function(){
						  	searchBtn();
						  	layer.close(index); 
						});
				  }else{
					  $.error(data.msg);
				  }
			},"json");
			
			
	       
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

function toMergeGroup(){
	
	var chk_value = [];
	$("input[name='chkFitOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行并团操作');
		return;
	}

	$.getJSON("../agencyFit/judgeMergeGroup.htm?ids=" + chk_value, function(data) {
		if (data.success) {
			newWindow('散客并团','fitOrder/toMergeGroup.htm?ids=' + chk_value);
		} else {
			$.error(data.msg);
		}
	});
	
	
}

/**
 * 分页查询
 * @param page 
 * @param pageSize
 */
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#orderPage").val(page);
	$("#orderPageSize").val(pageSize);
	
	var isSale=$("#isSales").val();
	var url;
	if(isSale=='true'){
		url="../agencyFit/getFitOrderListForMsglData.do";
	}else{
		url="../agencyFit/getFitOrderListForSalesData.do";
	}
	
	var options = {
		url:url,
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.layerMsg("服务忙，请稍后再试",{icon:1,time:1000});
    	}
    };
    $("#FitOrderListForm").ajaxSubmit(options);	
}

function searchBtn() {
	var pageSize=$("#orderPageSize").val();
	queryList(1,pageSize);
}
/**
 * 查看团信息
 * @param id
 */
function lookGroup(id){
	newWindow('查看团信息','groupOrder/toFitEdit.htm?groupId='+id+'&operType=0')
}
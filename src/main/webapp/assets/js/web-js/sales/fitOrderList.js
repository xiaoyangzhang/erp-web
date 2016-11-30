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
	
	$("#priceGroup").change(function() {
		var numAdult = $("input[name='groupOrder.numAdult']").val() ;
		var numChild = $("input[name='groupOrder.numChild']").val() ;
			if(numAdult!='' && numChild !='' &&  !isNaN(numAdult) &&  !isNaN(numChild)){
				var info= $("#priceGroup").val().split(",");
				var p = $(".price_select").parent('tr');
			    var siblings = p.siblings();
			    p.remove();
			    siblings.each(function(index, element){
			        var founds = $(element).find("[name^='groupOrderPriceList']");
			        
			        founds.each(function(){
			            $(this).attr('name', $(this).attr('name').replace(/groupOrderPriceList\[\d+]/g, 'groupOrderPriceList[' + index + ']'));
			        });
			        
			    });
			    
			    if(numAdult>0){
			    	
			    
			  	//价格-成人
				var html = $("#price_template_select").html();
				var count = $("#newPriceData").children('tr').length;
				html = template('price_template_select', {index : count});
				$("#newPriceData").append(html);
				 $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
				        var temp_value = $(this).text();  
				             if(temp_value == '成人'){  
				                 $(this).attr("selected","selected");  
				             }  
				        });  
				$("input[name='groupOrderPriceList["+count+"].itemName']").val("成人");
				$("input[name='groupOrderPriceList["+count+"].unitPrice']").val(info[0]);
				$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
				$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numAdult);
				$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(info[0]*numAdult);
				
			    }
			    if(numChild>0){
				//价格-小孩
				var html = $("#price_template_select").html();
				var count = $("#newPriceData").children('tr').length;
				html = template('price_template_select', {index : count});
				$("#newPriceData").append(html);
				
			 //	$("select[name='groupOrderPriceList["+count+"].itemId']").find("option[text='儿童']").attr("selected",true);
			    $("select[name='groupOrderPriceList["+count+"].itemId']").children("option").each(function(){  
			        var temp_value = $(this).text();  
			             if(temp_value == '儿童'){  
			                 $(this).attr("selected","selected");  
			             }  
			        });  
				$("input[name='groupOrderPriceList["+count+"].itemName']").val("儿童");
				$("input[name='groupOrderPriceList["+count+"].unitPrice']").val(info[1]);
				$("input[name='groupOrderPriceList["+count+"].numTimes']").val(1);
				$("input[name='groupOrderPriceList["+count+"].numPerson']").val(numChild);
				$("input[name='groupOrderPriceList["+count+"].totalPrice']").val(info[1]*numChild);
				
				
				
				var p = $(".cost_select").parent('tr');
			    var siblings = p.siblings();
			    p.remove();
			    siblings.each(function(index, element){
			        var founds = $(element).find("[name^='groupOrderCostList']");
			        founds.each(function(){
			            $(this).attr('name', $(this).attr('name').replace(/groupOrderCostList\[\d+]/g, 'groupOrderCostList[' + index + ']'));
			        });
			    });
			    }
			    
			    
			    if(numAdult>0){ 
			    //成本-成人
				var html = $("#cost_template_select").html();
				var count = $("#newCostData").children('tr').length;
				html = template('cost_template_select', {index : count});
				$("#newCostData").append(html);
				
			//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='成人']").attr("selected", true);
				 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
				        var temp_value = $(this).text();  
				             if(temp_value == '成人'){  
				                 $(this).attr("selected","selected");  
				             }  
				        });  
				$("input[name='groupOrderCostList["+count+"].itemName']").val("成人");
				$("input[name='groupOrderCostList["+count+"].unitPrice']").val(info[2]);
				$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
				$("input[name='groupOrderCostList["+count+"].numPerson']").val(numAdult);
				$("input[name='groupOrderCostList["+count+"].totalPrice']").val(info[2]*numAdult);
			    }
			    if(numChild>0){
				//成本-儿童
				var html = $("#cost_template_select").html();
				var count = $("#newCostData").children('tr').length;
				html = template('cost_template_select', {index : count});
				$("#newCostData").append(html);
				
			//	$("select[name='groupOrderCostList["+count+"].itemId'] option[text='儿童']").attr("selected", true);
				 $("select[name='groupOrderCostList["+count+"].itemId']").children("option").each(function(){  
				        var temp_value = $(this).text();  
				             if(temp_value == '儿童'){  
				                 $(this).attr("selected","selected");  
				             }  
				        }); 
				$("input[name='groupOrderCostList["+count+"].itemName']").val("儿童");
				$("input[name='groupOrderCostList["+count+"].unitPrice']").val(info[3]);
				$("input[name='groupOrderCostList["+count+"].numTimes']").val(1);
				$("input[name='groupOrderCostList["+count+"].numPerson']").val(numChild);
				$("input[name='groupOrderCostList["+count+"].totalPrice']").val(info[3]*numChild);
			    }
			}else{
				$.warn("请先正确填写订单人数！");
				$("#priceGroup").val("");
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
		$.getJSON("../fitOrder/delGroupOrder.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					refreshCurrentPage();
				});
			}else {
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});

}

function insertGroupByList(state){
	var chk_value = [];
	var order_locak =[];
	$("input[name='chkFitOrder']:checked").each(function() {
		chk_value.push($(this).val());
		order_locak.push($(this).attr("vars"));
	});
	
	if(state == 1 && (order_locak.indexOf('0')>-1)){
		$.error('含有未锁单的订单，请锁单后重试');
		return;
	}

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行加入团操作');
		return;
	}
	
	$.get("../fitOrder/beforeInsertGroup.htm?ids="+chk_value, function(data){
		  if(data.success){
					var win=0;
					layer.open({ 
						type : 2,
						title : '选择散客团',
						closeBtn : false,
						area : [ '900px', '500px' ],
						shadeClose : true,
						content : '../fitOrder/getInsertFitGroupList.htm?tid='+chk_value[0],
						btn: ['确定', '取消'],
						success:function(layero, index){
							win = window[layero.find('iframe')[0]['name']];
						},
						yes: function(index){
							var code = win.getCode();
							$.post("../fitOrder/insertGroupMany.do", { ids: chk_value.toString(), code: code }, function(data){
								  if(data.success){
									  $.success('操作成功',function(){
										 refreshCurrentPage();
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
		content : '../fitOrder/getInsertFitGroupList.htm?tid='+tid,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			
			var code = win.getCode();
			$.post("../fitOrder/insertGroup.do", { id: tid, code: code }, function(data){
				  if(data.success){
					  $.success('操作成功',function(){
						  refreshCurrentPage();
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

function toMergeGroup(state){
	var chk_value = [];
	var order_locak =[];
	$("input[name='chkFitOrder']:checked").each(function() {
		chk_value.push($(this).val());
		order_locak.push($(this).attr("vars"));
	});
	
	if(state == 1 && (order_locak.indexOf('0')>-1)){
		$.error('含有未锁单的订单，请锁单后重试');
		return;
	}

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行并团操作');
		return;
	}

	$.getJSON("../fitOrder/judgeMergeGroup.htm?ids=" + chk_value, function(data) {
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
	var options = {
		url:"../fitOrder/getFitOrderListData.do",
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
function refreshCurrentPage() {
	var page=$("#orderPage").val();
	var pageSize=$("#orderPageSize").val();
	queryList(page,pageSize);
}
/**
 * 查看团信息
 * @param id
 */
function lookGroup(id){
	newWindow('查看团信息','groupOrder/toFitEdit.htm?groupId='+id+'&operType=0')
}
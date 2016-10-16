/**
 * 未并团
 */
function onSubmit(){
		var options = {
				url : "mergeGroup.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$.success('操作成功',function(){
							 var tabs = $(top.document).find('#sysMenuTab li').children('span');
						     tabs.each(function(){
						         if($(this).text() === '散客订单管理'){
						             var index = $(this).parent().attr('frmindex');
						           top.document.getElementById('mainFrame' + index).contentWindow[0].searchBtn();
						         }
						     });
							closeWindow();
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
		$("#mergeGroupForm").ajaxSubmit(options);
	
	
		
	}
function insertGroup(id){
	
	layer.prompt({
	    title: '请输入散客团号',
	    formType: 0 //prompt风格，支持0-2
	}, function(pass){
		if(pass==''){
			$.warn("请输入散客团号");
			return ;
		}
		$.post("insertGroup.do", { id: id, code: pass }, function(data){
			  if(data.success){
				  $.success('操作成功',function(){
						queryList($("#groupPage").val(),$("#pageSize").val());
					});
			  }else{
				  $.error(data.msg);
			  }
			},"json");
	});
}


function beforeInsertGroup(){
	
	var chk_value = [];
	$("input[name='chkGroupOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行加入团操作');
		return;
	}
	
	$.get("beforeInsertGroup.htm?ids="+chk_value, function(data){
		  if(data.success){

					var win=0;
					layer.open({ 
						type : 2,
						title : '选择散客团',
						closeBtn : false,
						area : [ '900px', '500px' ],
						shadeClose : true,
						content : '../groupOrder/toInsertFitGroupList.htm?tid='+chk_value[0],
						btn: ['确定', '取消'],
						success:function(layero, index){
							win = window[layero.find('iframe')[0]['name']];
						},
						yes: function(index){
							var code = win.getCode();
							$.post("insertGroupMany.do", { ids: chk_value.toString(), code: code }, function(data){
								  if(data.success){
									  $.success('操作成功',function(){
										  var tabs = $(top.document).find('#sysMenuTab li').children('span');
										     tabs.each(function(){
										         if($(this).text() === '散客订单管理'){
										             var index = $(this).parent().attr('frmindex');
										           top.document.getElementById('mainFrame' + index).contentWindow[0].searchBtn();
										         }
										     });
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

		  }else{
			  $.error(data.msg);
		  }
	},"json");
	
}


function insertGroupByList(tid){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择散客团',
		closeBtn : false,
		area : [ '900px', '500px' ],
		shadeClose : true,
		content : '../groupOrder/toInsertFitGroupList.htm?tid='+tid,
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			
			var code = win.getCode();
			$.post("insertGroup.do", { id: tid, code: code }, function(data){
				  if(data.success){
					  $.success('操作成功',function(){
						  var tabs = $(top.document).find('#sysMenuTab li').children('span');
						     tabs.each(function(){
						         if($(this).text() === '散客订单管理'){
						             var index = $(this).parent().attr('frmindex');
						           top.document.getElementById('mainFrame' + index).contentWindow[0].searchBtn();
						         }
						     });
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



function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}
function queryList(page, pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#groupPage").val(page);
	$("#pageSize").val(pageSize);
	$("#toNotGroupListForm").submit();
}

function delGroupOrder(id) {
	
		$.confirm("确认删除吗？", function() {
			$.getJSON("delGroupOrder.do?id=" + id, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						queryList($("#groupPage").val(),$("#pageSize").val());
					});
				}
			});
		}, function() {
			$.info('取消删除');
		});
	
}
function mergeGroup() {

	var chk_value = [];
	$("input[name='chkGroupOrder']:checked").each(function() {
		chk_value.push($(this).val());
	});

	if (chk_value.length == 0) {
		$.error('请先选择散客订单再进行并团操作');
		return;
	}
//	if (chk_value.length < 2) {
//		$.error('请先选择至少2个散客订单再进行并团操作');
//		return;
//	}
	$.getJSON("judgeMergeGroup.htm?ids=" + chk_value, function(data) {
		if (data.success) {
			newWindow('并团','groupOrder/toMergeGroup.htm?ids=' + chk_value);
		} else {
			$.error(data.msg);
		}
	});

}
function openMergeAddGroup(ids) {
	layer.open({
		type : 2,
		title : '选择订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '70%', '80%' ],
		content : '../groupOrder/toImpNotGroupList.htm?pageSize=10&page=1&idLists=' + ids
	});
}
function selectUserMuti(num){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ '400px', '500px' ],
		shadeClose : true,
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();   
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				//console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
					//$("#saleOperatorIds").val($("#saleOperatorIds").val()+")");
					//alert($("#saleOperatorIds").val());
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
				}
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
function multiReset(){
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
}

/**
 * 打印订单信息
 * @param orderId
 */
function printOrder(orderId){
	/*$("#saleOrder").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+1) ; //销售订单
	$("#saleCharge").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+2) ; //销售价格
	$("#saleOrderNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleChargeNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+5) ; //结算单-无行程
*/	
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '210px' ],
		content : $('#exportWord')
	});
};
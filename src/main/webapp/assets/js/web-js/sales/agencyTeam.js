function toToutGroupList(){
	window.location = "../tourGroup/findTourGroupByCondition.htm" ;
}

function toGroupOrder(){
	window.location = "../tourGroup/toAddTourGroupOrder.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
}
function toOtherInfo(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../tourGroup/toOtherInfo.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}
function togroupRequirement(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../tourGroup/togroupRequirement.htm?orderId="+$("#orderId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}

function toGetRouteList(){
	if($("#orderId").val().trim()==""){
		$.warn("订单详情未保存") ;
	}else{
		window.location = "../groupRoute/toGetRouteList.htm?orderId="+$("#orderId").val()+"&groupId="+$("#groupId").val()+"&stateFinance="+$("#stateFinance").val()+"&state="+$("#state").val();
	}
}
$(function() {
	/**
	 * 旅行团订单保存
	 */
	$("#groupOrderForm").validate({
		rules : {
			'dateStart' : {
				required : true
			},
			'receiveMode':{
				required : true
			},
			'totalAdult' : {
				required : true,
				digits : true 
			},
			'totalChild' : {
				required : true,
				digits : true
			},
			'totalGuide' : {
				required : true,
				digits : true
			},
			'supplierName' : {
				required : true
			},
			'contactName' : {
				required : true
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
				url : "saveTourGroupOrder.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.id!=null) {
						$.success('保存成功') ;
						/*$("#orderId").val(data.id);
						$("#groupId").val(data.groupId);*/
						refreshWindow('修改订单','toAddTourGroupOrder.htm?orderId='+data.id) ;
					} else {
						$.warn('服务忙，请稍后再试', {
							icon : 5
						});
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					$.warn('服务忙，请稍后再试', {
						icon : 5
					});
				}
			};
			jQuery.ajax({
				url : "../tourGroup/validatorSupplier.htm",
				type : "post",
				async : false,
				data : {
					"supplierId" : $("#supplierId").val(),
					"supplierName":$("#supplierName").val()
				},
				dataType : "json",
				success : function(data) {
					if (data.success) {
						$(form).ajaxSubmit(options);
					}else{
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus, errorThrown) {
					$.error(textStatus);
					window.location = window.location;
				}
			});
			
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	/**
	 * 分页查询
	 */
	var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
	 $("#tourGroupStartTime").val(vars.dateFrom);
	 $("#tourGroupEndTime").val(vars.dateTo );	

	// var
	/*queryList();*/
	groupGrid.loadGrid();
    groupGrid.reSize();
    $(window).bind('resize', function () {
        groupGrid.reSize();
    });

	$("selA").hide();
});
/**
 * 页面选择部分调用函数(单选)
 */
function selectUser(num){
	var win=0;
	layer.open({
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.warn("请选择人员");
				return false;
			}
			//销售计调
			if(num==1){
				$("#saleOperatorId").val(userArr[0].id);
				$("#saleOperatorName").val(userArr[0].name);
			}
			//操作计调
			if(num==2){
				$("#operatorId").val(userArr[0].id);
				$("#operatorName").val(userArr[0].name);
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
/**
 * 页面选择部分调用函数(多选)
 */
function selectUserMuti(num){
	
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		area : [ '400px', '470px' ],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList();   
			
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				//console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
				}
			}
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}

/**
 * 重置查询条件
 */
function multiReset(){
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
	/*$("#tourGroupStartTime").val("");
	$("#tourGroupEndTime").val("");
	$("#tourGroupGroupCode").val("");
	$("#tourGroupProductName").val("");*/
}
/**
 * 先选择供应商，再根据供应商id选择联系人 
 */
function selectContact(){
	var win=0;
	var supplierId = $("#supplierId").val().trim() ;
	if(supplierId==""){
		$.warn("未选择组团社");
	}else{
		layer.open({ 
			type : 2,
			title : '选择联系人',
			shadeClose : true,
			shade : 0.5,
			//offset : [th,lh],
			area : ['550px', '400px'],
			content : '../component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				var arr = win.getChkedContact();    				
				if(arr.length==0){
					$.warn("请选择联系人");
					return false;
				}
				$("#contactName").val(arr[0].name);
				$("#contactMobile").val(arr[0].mobile);
				$("#contactTel").val(arr[0].tel);
				$("#contactFax").val(arr[0].fax);
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}
}
/**
 * 选择组团社
 */
function selectSupplier(){
	
	layer.openSupplierLayer({
		title : '选择组团社',
		content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
		callback: function(arr){
			if(arr.length==0){
				$.warn("请选组团社");
				return false;
			}
			$("#supplierName").val(arr[0].name);
			$("#supplierId").val(arr[0].id);
			/**
			 * 每次选择完组团社后将联系人相关部分数据清空
			 */
			$("#contactName").val("");
			$("#contactMobile").val("");
			$("#contactTel").val("");
			$("#contactFax").val("");
	    }
	});
}

function addCellAttr(rowId, val, rawObject, cm, rdata) {
	return "style='overflow: visible;'";
}


/**
 * 分页查询
 * @param page
 * @param pageSize
 */
var groupGrid = {
    reSize: function(){
        var width = $('.jqGrid_wrapper').width();

        var height = $(window).height();//parent.get_MainContainerHeight();
        var searchBox=80, jqGrid_head = 55, jqGrid_pager = 30, jqGrid_footer = 45;
        height = height - searchBox - jqGrid_head - jqGrid_pager - jqGrid_footer;
        $('#tableDiv').setGridWidth(width);
        $('#tableDiv').setGridHeight(height -10);
    },
	getParam: function(){
		var rowListNum = $("#tableDiv").jqGrid('getGridParam', 'rowNum');
		if(rowListNum == undefined){
			$('#pageSize').val(15);
		}else{
			$('#pageSize').val(rowListNum);
		}
		var params = {'startTime':$("#tourGroupStartTime").val()
			,'endTime':$("#tourGroupEndTime").val()
			,'dateType':$("#dateType").val()
			,'supplierName':$("#supplierName").val()
			,'tourGroup.groupCode':$("#tourGroupGroupCode").val()

			,'provinceId':$("#provinceCode").val()
			,'cityId':$("#cityCode").val()
			,'sourceTypeId':$("#sourceTypeId").val()
			,'orgNames':$("#orgNames").val()
			,'operType':$("#operType").val()

			,'orgIds':$("#orgIds").val()
			,'saleOperatorName':$("#saleOperatorName").val()
			,'saleOperatorIds':$("#saleOperatorIds").val()
			,'tourGroup.productName':$("#tourGroupProductName").val()
			,'orderLockState':$("#orderLockState").val()

			,'tourState':$("#tourState").val()
			,'pageSize':$("#pageSize").val()
			,'page':$("#page").val()
			,'cashState':$("#cashState").val()
		};
		return params;
	},

    formatter:'select', formatoptions:{
        value:{ '0':'未确认','1':'已确认',2:'已废弃', '3':'已审核', '4':'已封存'}
    },
    formatPerson: function(cellValue, options, rowObject) {
        return cellValue+"+"+rowObject.tourGroup.totalChild+"+"+rowObject.tourGroup.totalGuide;
    },
    formatState: function(cellValue,options,rowObject){
        var unconfirmed = "未确认";
        var confirmed_audit = "已确认(审)";
        var confirmed = "已确认";
        var abandoned = "已废弃";
        var audit = "已审核";
        var sealed = "已封存";
        if(cellValue==0){
            return '<span class="log_action update">'+unconfirmed+'</span>';
        }else if(cellValue==1){
            if(rowObject.tourGroup.stateFinance==1){
                return '<span class="log_action normal">'+confirmed_audit+'</span>';
            }else {
                return '<span class="log_action normal">'+confirmed+'</span>';
            }
        }else if(cellValue==2){
            return '<span class="log_action delete">'+abandoned+'</span>';
        }else if(cellValue==3){
            return '<span class="log_action insert">'+audit+'</span>';
        }else {
            return '<span class="log_action fuchsia">'+sealed+'</span>';
        }
    },

	formatOptions:function (cellValue, options, rowObject){
		var ops =  '<div class="tab-operate">' +
			'<a href="####" class="btn-show">操作<span class="caret"></span></a>' +
			'<div class="btn-hide" id="asd">' +
			'<a href="javascript:void(0);" onclick="newWindow(\'查看团队信息\',\'teamGroup/toEditTeamGroupInfo.htm?groupId='+rowObject.tourGroup.id+'+&operType=0\')"  class="def" >查看</a>' +
			'<a href="javascript:void(0);" onclick="printOrder('+rowObject.id+','+rowObject.tourGroup.groupState+','+rowObject.tourGroup.id+')" class="def">打印</a>';
			if(rowObject.tourGroup.groupState != 3 && rowObject.tourGroup.groupState !=4){
				if(rowObject.orderLockState != 1 && rowObject.stateFinance != 1){
					ops+='<a href="javascript:void(0);" onclick="newWindow(\'编辑团订单\',\'teamGroup/toEditTeamGroupInfo.htm?groupId='+rowObject.tourGroup.id+'&operType=1\')" class="def">编辑</a>' +
					'<a href="javascript:void(0);" onclick="changeGroupState('+rowObject.groupId+','+rowObject.tourGroup.groupState+')" class="def">状态</a>';
				}
			}
			if(rowObject.tourGroup.groupState==2){
				if(rowObject.orderLockState != 1){
					ops+='<a href="javascript:void(0);" onclick="deleteGroupOrderById('+rowObject.id+','+rowObject.groupId+')" class="def">删除</a>';
				}
			}
			if(rowObject.tourGroup.groupState !=2){
				ops+='<a href="javascript:void(0);" onclick="newWindow(\'复制为新团\',\'tourGroup/toCopyTourGroup.htm?orderId='+rowObject.id+'&groupId='+rowObject.groupId+'\')" class="def">复制</a>';
			}
			if(rowObject.tourGroup.groupState ==4){
				ops+='<a href="javascript:void(0);" onclick="newWindow(\'变更团\',\'tourGroup/toChangeGroup.htm?groupId='+rowObject.groupId+'\')" class="def">变更</a>';
			}
			ops+='</div></div>';
			/*'<c:if test="${'+rowObject.tourGroup.groupState+'!=3 and '+rowObject.tourGroup.groupState+'!=4 and optMap[\'EDIT\']}">' +
			'<c:if test="${'+rowObject.orderLockState+'!= 1 and '+rowObject.stateFinance+'!= 1}">' +
			'<a href="javascript:void(0);" onclick="newWindow(\'编辑团订单\',\'teamGroup/toEditTeamGroupInfo.htm?groupId='+rowObject.tourGroup.id+'&operType=1\')" class="def">编辑</a>' +
			'<a href="javascript:void(0);" onclick="changeGroupState('+rowObject.groupId+','+rowObject.tourGroup.groupState+')" class="def">状态</a>' +
			'</c:if>' +
			'</c:if>' +
			'<c:if test="${'+rowObject.tourGroup.groupState+'==2}">' +
			'<c:if test="${'+rowObject.orderLockState+' != 1}">' +
			'<a href="javascript:void(0);" onclick="deleteGroupOrderById('+rowObject.id+','+rowObject.groupId+')" class="def">删除</a>' +
			'</c:if>' +
			'</c:if>' +
			'<c:if test="${'+rowObject.tourGroup.groupState+'!=2 and optMap[\'EDIT\']}">' +
			'<a href="javascript:void(0);" onclick="newWindow(\'复制为新团\',\'tourGroup/toCopyTourGroup.htm?orderId='+rowObject.id+'&groupId='+rowObject.groupId+'\')" class="def">复制</a>' +
			'</c:if>' +
			'<c:if test="${'+rowObject.tourGroup.groupState+'==4 and optMap[\'EDIT\']}">' +
			'<a href="javascript:void(0);" onclick="newWindow(\'变更团\',\'tourGroup/toChangeGroup.htm?groupId='+rowObject.groupId+'\')" class="def">变更</a>' +
			'</c:if>' +
			'</div>' +
			'</div>';*/
		return ops;
	},
	loadGrid: function(){
		$("#tableDiv").jqGrid({
			url: '../agencyTeam/findTourGroupLoadModel.do',
			datatype: "json",
			mtype : "post",
			height: 250,
			autowidth: false,
			shrinkToFit: false,
            rownumbers:true,
			async:false,
			rowNum: 15,
			rowList: [15, 30, 50, 100, 500, 1000],
			colModel: [
				{label:'团号',name: 'tourGroup.groupCode',index: 'tourGroup.groupCode',width: 120, sortable: false, align:'left'},
				{label:'发团日期',name: 'tourGroup.dateStart',index: 'date_start',align: "center",formatter:function(cellValue,options,rowObject){
					return (moment(rowObject.tourGroup.dateStart).format("YYYY-MM-DD"));},width: 90, align:'center'},
				{label:'产品名称',name: 'productName',index: 'productName',width: 250, sortable: false, align:'left',
                    formatter:function(cellValue,options,rowObject){
                        return ("【"+rowObject.productBrandName+"】"+cellValue);
                    }
                },
				{label:'天数',name: 'tourGroup.daynum',index: 'daynum',width: 50, sortable: true, align:'center'},
				{label:'组团社',name: 'supplierName',index: 'supplierName',width: 250, sortable: false,align:'left'},
				{label:'客源地',name: 'provinceName',index: 'provinceName',width: 90, sortable: false,  align:'center',
                    formatter:function(cellValue,options,rowObject){
                        return (cellValue+rowObject.cityName);
                    }
                },
                {label:'联系人',name: 'contactName',index: 'contactName',width: 50, sortable: false, align:'center'},

                {label:'人数',name: 'tourGroup.totalAdult',index: 'totalAdult',width: 80, sortable: false, align:'center',formatter:groupGrid.formatPerson},
				{label:'销售',name: 'saleOperatorName',index: 'saleOperatorName',width: 50, sortable: false, align:'center'},
				{label:'操作',name: 'operatorName',index: 'operatorName',width: 50, sortable: false, align:'center'},
				{label:'状态',name: 'tourGroup.groupState',index: 'tourGroup.groupState',width: 50, sortable: false, align:'center',
                    formatter:groupGrid.formatState
                },
				{label:'操作',name: 'operations',index: 'operations',width: 80, sortable: false,align:'center',cellattr: addCellAttr,
					editable:true,edittype:'select',formatter:groupGrid.formatOptions
				}
			],
			pager: "#pagerDiv",
			viewrecords: true,
            caption: "",
			jsonReader:{
				root: "result",total: "totalPage",page: "pageBean",records: "totalCount",repeatitems: false
			},
			postData:groupGrid.getParam(),
			footerrow: true,//分页上添加一行，用于显示统计信息
			loadComplete:function(xhr){
				//查询为空的处理方式
				var rowNum = $("#tableDiv").jqGrid('getGridParam','records');
				if (rowNum == '0'){
					if($("#norecords").html() == null)
						$("#tableDiv").parent().append("</pre><div id='norecords' style='text:center;padding: 8px 8px;'>没有查询记录！</div><pre>");
					$("#norecords").show();
				}else{
					$("#norecords").hide();
				}

                //处理合计
                var GroupList = xhr.result;
                groupGrid.getPageFooterTotal(GroupList);
			}
		});
	},
   getPageFooterTotal: function(totalRow){
       var pageObj = {tAdult:0, tChild:0, tGuide:0};
       $.each(totalRow, function(i,item){
           pageObj.tAdult += parseInt(item.tourGroup.totalAdult);
           pageObj.tChild += parseInt(item.tourGroup.totalChild);
           pageObj.tGuide += parseInt(item.tourGroup.totalGuide);
       });

       var options = {
           url:"findTourGroupLoadFooter.do",
           type:"post",
           dataType:"json",
           success:function(data){

               $("tr.footRow2").remove();
               var $footerRow = $("tr.footrow");
               $footerRow.after("<tr role='row' class='footrow footRow2 footrow-ltr ui-widget-content'>"+$footerRow.html()+"</tr>");
               var $newFooterRow = $("tr.footRow2");
               $("#tableDiv").footerData("set",{sourceTypeName:"页合计：", "tourGroup.totalAdult":pageObj.tAdult, tourGroup:{totalChild:pageObj.tChild, totalGuide:pageObj.tGuide}});


               if (data == null || data == 'null'){
                   data = {numAdult:0, numChild:0, numGuide:0};
               }
               $newFooterRow.find("td[aria-describedby*='_sourceTypeName']").text("总合计：");
			   $newFooterRow.find("td[aria-describedby*='_tourGroup.totalAdult']").text(data.numAdult+"+"+data.numChild+"+"+data.numGuide);
           },
           error:function(XMLHttpRequest, textStatus, errorThrown){
               $.error(textStatus+':'+errorThrown);
           }
       };
       $("#tourGroupForm").ajaxSubmit(options);
    }
}

function searchBtn() {
	$("#tableDiv").jqGrid('setGridParam', {page:1, postData: groupGrid.getParam()}).trigger("reloadGrid");
}

/*function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#orderPage").val(page);
	$("#pageSize").val(pageSize);

	var options = {
		url:"../teamGroup/findTourGroupLoadModel.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error("服务忙，请稍后再试");
    	}
    };
    $("#tourGroupForm").ajaxSubmit(options);	
}*/
/*
function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}*/
/*function refreshCurrentPage() {
	var page=$("#page").val();
	var pageSize=$("#pageSize").val();
	queryList(page,pageSize);
}*/






/**
 * 删除订单
 * @param orderId 订单id
 * @param groupId 团id
 * @param stateFinance 财务审核状态
 */
function deleteGroupOrderById(orderId,groupId){
	$.confirm("确认删除吗？", function() {
		$.getJSON("deleteGroupOrderById.do?orderId=" + orderId+"&groupId="+groupId, function(data) {
			if (data.success) {
				/*$.success('操作成功');
				window.location = window.location;*/
				 $.success('操作成功', function(){
					 refreshCurrentPage();
	             });
			}else{
				$.warn(data.msg);
			}
		});
	}, function() {
		$.info('取消删除');
	});
	/*if(stateFinance==1){
		//
	}else {
		$.info("财务未审核") ;
	}*/
	
};

/**
 * 更改团状态
 * state==0时代表未确认状态，需要查询该订单下是否维护了成本价格
 * @param state 
 */
var stateIndex;
function changeGroupState(groupId,state){
	if(state==0){
		$.getJSON("../budgetItem/getTotalBudgetByOrderId.do?id=" + groupId ,function(data) {
			if (data.success) {
				$("#modalgroupId").val(groupId);
				$("#modalGroupState").val(state);
				optionState(state);
				layer.open({
					type : 1,
					title : '修改状态',
					shadeClose : true,
					shade : 0.5,
			        area : ['350px','210px'],
					content : $('#stateModal')
				});
			}else{
				$.warn(data.msg);
			}
		});
	}else{
		$("#modalgroupId").val(groupId);
		$("#modalGroupState").val(state);
		optionState(state);
		stateIndex=layer.open({
			type : 1,
			title : '修改状态',
			shadeClose : true,
			shade : 0.5,
	        area : ['350px','210px'],
			content : $('#stateModal')
		});
	}
};
function optionState(state){
	var sltState = document.getElementById("modalGroupState");
	
	while (sltState.firstChild) {
		sltState.removeChild(sltState.firstChild); 
	}
	if(state==0){
		var option1 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);	
	}else if(state==1){
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);
	}else if(state==2){
		var option1 = new Option("未确认", "0");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option2);
	}
}

/**
 * 跳到信息编辑页面
 */
function editOrderGroupInfo(){
	var groupId = $("#modalgroupId").val();
	var groupState = $("#modalGroupState").val();
	$.getJSON("../groupOrder/editOrderGroupInfo.do?id=" + groupId +"&groupState="+groupState, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				layer.close(stateIndex);
				refreshCurrentPage();
				
			});
			
		}
	});
}

/**
 * 订单打印
 * @param orderId 订单id
 */
function printOrder(orderId,state,groupId){
	if(state==0 || state == 2){
		$("#saleOrder").hide() ;
		$("#saleCharge").hide() ;
		$("#saleChargeNoRoute").hide() ;
		$("#saleOrderNoRoute").hide() ;
		$("#tddyd").hide() ;
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}else{
		$("#saleOrder").show() ;
		$("#saleCharge").show() ;
		$("#saleChargeNoRoute").show() ;
		$("#saleOrderNoRoute").show() ;
		$("#tddyd").show() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
		$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
		$("#tddyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //导游行程单
		//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num=7") ; //游客反馈意见单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
        area : ['400px','350px'],
		content : $('#exportWord')
	});
};

/**
 * 订单打印-组团社
 * @param orderId 订单id
 */
function printOrderAgency(orderId,state,groupId){
	if(state==0 || state == 2){
		$("#saleOrder").show() ;
		$("#saleCharge").hide() ;
		$("#saleChargeNoRoute").hide() ;
		$("#saleOrderNoRoute").hide() ;
		$("#tddyd").hide() ;
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}else{
		$("#saleOrder").show() ;
		$("#saleCharge").show() ;
		$("#saleChargeNoRoute").show() ;
		$("#saleOrderNoRoute").show() ;
		$("#tddyd").show() ;
		$("#guestNames").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
		$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
		$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
		$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
		$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
		$("#tddyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //导游行程单
		//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num=7") ; //游客反馈意见单
		$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
		$("#cttz").attr("href","../agencyFitGroup/toGroupNoticePreview.htm?groupId="+groupId) ; //出团通知单
	}
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
        area : ['400px','350px'],
		content : $('#exportWord')
	});
};

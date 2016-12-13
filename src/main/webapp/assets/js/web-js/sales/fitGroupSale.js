function pushInfo(groupId){
	layer.open({
		type : 2,
		title : '同步到APP',
		shadeClose : true,
		shade : 0.5,
		area : [ '1000px', '550px' ],
		content : '../tourGroup/getPushInfo.htm?groupId='+groupId 
	});

}
function openMergeAddGroup(id,mode) {
	layer.open({
		type : 2,
		title : '选择订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '70%', '80%' ],
		content:'../fitGroup/toSecImpNotGroupList.htm?orderType='+mode+'&reqType=0&gid='+id
	});
}

function toChangeState(groupId,state){
	
		$("#modalgroupId").val(groupId);
		$("#modalGroupState").val(state);
		optionState(state);
	layer.open({
		type : 1,
		title : '修改状态',
		shadeClose : true,
		shade : 0.5,
		area : [ '300px', '200px' ],
		content : $('#stateModal')
	});
}
function optionState(state){
	var sltCity = document.getElementById("modalGroupState");
	while (sltCity.firstChild) {
	  sltCity.removeChild(sltCity.firstChild); //移除已有的节点
	}
	if(state==0){//未确认
		var option1 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option2);	
		
	}else if(state==1){//已确认
		var option1 = new Option("废弃", "2");
		document.getElementById("modalGroupState").options.add(option1);
	
	}else if(state==2){//废弃
		var option1 = new Option("未确认", "0");
		document.getElementById("modalGroupState").options.add(option1);
		var option2 = new Option("已确认", "1");
		document.getElementById("modalGroupState").options.add(option2);
	}
}
function delGroup(groupId,state){
	$.confirm("确认删除吗？", function() {
	$.getJSON("../fitGroup/delFitTour.do?groupId=" + groupId, function(data) {
		if (data.success) {
			$.success('操作成功',function(){
				searchBtn();
			});
		}else{
			$.warn(data.msg);
		}
		
	});
	
	})

	
}
		
$(function(){
	$("#stateInfoForm").validate(
			{
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
					
					var options = {
						url : '../fitGroup/changeState.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									searchBtn();
								});
							} else {
								layer.alert(data.msg, {
									icon : 5
								});

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							layer.alert('服务忙，请稍后再试', {
								icon : 5
							});
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	var vars={
			 dateFrom : $.currentMonthFirstDay(),
		 	dateTo : $.currentMonthLastDay()
		 	};
	 $("#startTime").val(vars.dateFrom);
	 $("#endTime").val(vars.dateTo );	
	
	groupGrid.loadGrid();
    groupGrid.reSize();
    $(window).bind('resize', function () {
        groupGrid.reSize();
    });
})

/**
* 订单打印
*/
function print(groupId){
//	$("#skjd").attr("href","download.htm?groupId="+groupId+"&num="+1) ; //散客计调单
//$("#skdydwxc").attr("href","download.htm?groupId="+groupId+"&num="+5) ; //散客导游单-无行程
//$("#krmd").attr("href","download.htm?groupId="+groupId+"&num="+2) ; //客人名单
//$("#krmdjs").attr("href","download.htm?groupId="+groupId+"&num="+6) ; //客人名单-接送
$("#skqrd").attr("href","../tourGroup/toSKConfirmPreview.htm?groupId="+groupId) ; //散客确认单
$("#skjsd").attr("href","../tourGroup/toSKChargePreview.htm?groupId="+groupId) ; //散客结算单
$("#skjd").attr("href","../groupOrder/previewFitTransfer.htm?groupId="+groupId) ; //散客计调单
$("#skdydwxc").attr("href","../groupOrder/previewFitGuide.htm?groupId="+groupId) ; //散客导游单
$("#krmd").attr("href","../groupOrder/previewGuestWithoutTrans.htm?groupId="+groupId) ; //客人名单
$("#krmdjs").attr("href","../groupOrder/previewGuestWithTrans.htm?groupId="+groupId) ; //客人名单-接送

//$("#ykyjfkd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num="+3) ; //游客反馈意见单
$("#ykyjfkd").attr("href","../groupOrder/toIndividualGuestTickling.htm?groupId="+groupId ) ; //游客反馈意见单
//$("#skgwmxd").attr("href","../groupOrder/download.htm?groupId="+groupId+"&num="+4) ; 
$("#skgwmxd").attr("href","../groupOrder/toShoppingDetailPreview.htm?groupId="+groupId) ; //散客购物明细单
$("#skgwmxd2").attr("href","../groupOrder/toShoppingDetailPreview2.htm?groupId="+groupId) ; //散客购物明细单2
$("#skdyd").attr("href","../bookingGuide/previewGuideRoute.htm?id="+groupId+"&num="+3) ; //散客导游单

layer.open({
	type : 1,
	title : '打印',
	shadeClose : true,
	shade : 0.5,
    area : ['350px','400px'],
	content : $('#exportWord')
});
};

$(".serialnum div").bind("click", function(){
	divExpand(this, $(this).attr("id"),$(this).attr("groupId"));
});
var divExpand = function (btnObj,id,groupId) {
    //切换 (展开/收缩)小图标
    var cssName = $(btnObj).attr("class") == "serialnum_btn" ? "serialnum_btn2" : "serialnum_btn";
    $(btnObj).attr("class", cssName);
    //收起来
    if (cssName == "serialnum_btn") {
        $("#td_" + id).parent().slideUp().remove();
        return;
    }else{
    	//如果已经加载过数据则不再重复请求，直接展开
    	if($("#td_" + id).length>0){
    		$("#td_" + id).parent().slideDown().show();
    		return;
    	}
    }

    //展开 
     var trContainer = '<tr ><td style="padding: 8px 8px" colspan="12" id="td_'+id+'">'+
   
    +'</td></tr>';
    $(btnObj).closest("tr").after(trContainer);
    vTrObj = $("#td_" + id).slideDown();
    //开始读数据
    //loadGroupElementAjax(vTrObj, groupID);
    loadData("td_"+id,groupId);
}
function loadData(containerId,groupId){
	$("#"+containerId).load("../fitOrder/getSubOrderListData.do?groupId="+groupId);
}

function searchBtn() {
	$("#fitGroupTable").jqGrid('setGridParam', {page:1, postData: groupGrid.getParam()}).trigger("reloadGrid");
}
/*function searchBtn() {
	var pageSize=$("#groupPageSize").val();
	queryList(1,pageSize);
}

function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#groupPage").val(page);
	$("#groupPageSize").val(pageSize);
	$("#toFitGroupListForm").submit();
}*/

var groupGrid = {
	    reSize: function(){
	        var width = $('.jqGrid_fitGroup').width();
	        var height = $(window).height();//parent.get_MainContainerHeight();
	        var searchBox=80, jqGrid_head = 55, jqGrid_pager = 30, jqGrid_footer = 45;
	        height = height - searchBox - jqGrid_head - jqGrid_pager - jqGrid_footer;
	        $('#fitGroupTable').setGridWidth(width);
	        $('#fitGroupTable').setGridHeight(height -10);
	    },
	    //查询条件组装
	    getParam: function(){
	    	var rowListNum = $("#fitGroupTable").jqGrid('getGridParam', 'rowNum');
	    	if(rowListNum == undefined){
				$('#groupPageSize').val(15);
			}else{
				$('#groupPageSize').val(rowListNum);
			}
			var params = {'startTime':$("#startTime").val()
				,'endTime':$("#endTime").val()
				,'groupCode':$("#groupCode").val()
				,'productName':$("#productName").val()
				,'orgIds':$("#orgIds").val()
				,'orgNames':$("#orgNames").val()
				,'saleOperatorName':$("#saleOperatorName").val()
				,'saleOperatorIds':$("#saleOperatorIds").val()
				,'groupState':$("#groupState").val()
				,'groupMode':$("#groupMode").val()
				,'pageSize':$("#groupPageSize").val()
				,'page':$("#groupPage").val()
			};
			return params;
	    },
	    //状态
	    formatGroupState: function(cellValue,options,rowObject){
	        var unconfirmed = "未确认";
	        var confirmed = "已确认";
	        var abandoned = "已废弃";
	        var audit = "已审核";
	        var sealed = "已封存";
	        if(cellValue==0){
	            return '<span class="log_action update">'+unconfirmed+'</span>';
	        }else if(cellValue==1){
	             return '<span class="log_action normal">'+confirmed+'</span>';
	        }else if(cellValue==2){
	            return '<span class="log_action delete">'+abandoned+'</span>';
	        }else if(cellValue==3){
	            return '<span class="log_action insert">'+audit+'</span>';
	        }else {
	            return '<span class="log_action fuchsia">'+sealed+'</span>';
	        }
	    },
	    //类型
	    formatGroupMode: function(cellValue,options,rowObject){
	        var individual = "散客";
	        var one_individual = "一地散";
	        if(cellValue==0){
	            return individual;
	        }
	        if(cellValue==-1){
	             return one_individual;
	        }
	    },
	    //按钮操作
	    formatFitOptions:function (cellValue, options, rowObject){
			var ops = '<div class="tab-operate">'+
				'<a href="####" class="btn-show">操作<span class="caret"></span></a>'+
				'<div class="btn-hide" id="asd">'+
				 '<a href="javascript:void(0)" class="def" onclick="newWindow(\'查看散客团\',\'fitGroup/toFitGroupInfo.htm?groupId='+rowObject.id+'&operType=0\')">查看</a>'+
				 '<a href="javascript:void(0);" onclick="print('+rowObject.id+')" class="def">打印</a>';
				  if(rowObject.groupState!=3 && rowObject.groupState!=4){
					  ops+='<a href="javascript:void(0)"  class="def"  onclick="newWindow(\'编辑散客团\',\'fitGroup/toFitGroupInfo.htm?groupId='+rowObject.id+'&operType=1\')">编辑</a>'+
					  '<a href="javascript:void(0);" onclick="openMergeAddGroup('+rowObject.id+','+rowObject.groupMode+')"  class="def">并团</a>'+
					  '<a href="javascript:void(0);" onclick="toChangeState('+rowObject.id+','+rowObject.groupState+')" class="def">状态</a>';
				  }
				  if(rowObject.groupState==2){
					  ops+='<a href="javascript:void(0);" onclick="delGroup('+rowObject.id+',-1)"  class="def">删除</a>';
				  }
				  if(rowObject.groupState==4){
					  ops+='<a href="javascript:void(0);" onclick="newWindow(\'变更团\',\'tourGroup/toChangeGroup.htm?groupId='+rowObject.id+'\')" class="def">变更</a> ';
				  }
			ops+='</div></div>';
			return ops;
		},
	    loadGrid: function(){
			$("#fitGroupTable").jqGrid({
				url: '../fitGroup/toFitGroupTable.do',
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
					{label:'团号',name: 'groupCode',index: 'groupCode',width: 180, sortable: false, align:'left'},
					{label:'类型',name: 'groupMode',index: 'groupMode',width: 100, sortable: false, align:'center',
						 formatter:groupGrid.formatGroupMode},
					{label:'日期',name: 'dateStart',index: 'date_start',align: "center", sortable: true,formatter:function(cellValue,options,rowObject){
						return (moment(rowObject.dateStart).format("YYYY-MM-DD")+"/"+moment(rowObject.dateEnd).format("YYYY-MM-DD"));},width: 160, align:'center'},
					{label:'产品名称',name: 'productName',index: 'productName',width: 470, sortable: false, align:'left',
	                    formatter:function(cellValue,options,rowObject){
	                        return ("【"+rowObject.productBrandName+"】"+cellValue);
	                    }
	                },
					{label:'导游',name: 'guideName',index: 'guideName',width: 120, sortable: false, align:'center'},
					{label:'订单数',name: 'orderNum',index: 'order_num',width: 100, sortable: true,align:'center'},
					{label:'成人',name: 'totalAdult',index: 'total_adult',width: 100, sortable: true, align:'center'},
					{label:'儿童',name: 'totalChild',index: 'total_child',width: 100, sortable: true, align:'center'},
					{label:'计调',name: 'operatorName',index: 'operatorName',width: 100, sortable: false, align:'center'},
					{label:'团状态',name: 'groupState',index: 'groupState',width: 100, sortable: false, align:'center',
						 formatter:groupGrid.formatGroupState},
					{label:'操作',name: 'operations',index: 'operations',width: 90, sortable: false,align:'center',cellattr: addCellAttr,
						editable:true,edittype:'select',formatter:groupGrid.formatFitOptions}
				],
				pager: "#fitGroupPage",
				viewrecords: true,
	            caption: "",
				jsonReader:{
					root: "result",total: "totalPage",page: "pageBean",records: "totalCount",repeatitems: false
				},
				postData:groupGrid.getParam(),
				footerrow: true,//分页上添加一行，用于显示统计信息
				loadComplete:function(xhr){
					//查询为空的处理方式
					var rowNum = $("#fitGroupTable").jqGrid('getGridParam','records');
					if (rowNum == '0'){
						if($("#norecords").html() == null)
							$("#fitGroupTable").parent().append("</pre><div id='norecords' style='text:center;padding: 8px 8px;'>没有查询记录！</div><pre>");
						$("#norecords").show();
					}else{
						$("#norecords").hide();
					}

	                //处理合计
	                var fitGroupList = xhr.result;
	                groupGrid.getPageFooterTotalPerson(fitGroupList);
				}
			});
		},
		getPageFooterTotalPerson: function(totalRow){
		       var pageObj = {totalAdult:0, totalChild:0};
		       $.each(totalRow, function(i,item){
		           pageObj.totalAdult += parseInt(item.totalAdult);
		           pageObj.totalChild += parseInt(item.totalChild);
		       });

		       var options = {
		           url:"toSelectTotalPerson.do",
		           type:"post",
		           dataType:"json",
		           success:function(data){

		               $("tr.footRow2").remove();
		               var $footerRow = $("tr.footrow");
		               $footerRow.after("<tr role='row' class='footrow footRow2 footrow-ltr ui-widget-content'>"+$footerRow.html()+"</tr>");
		               var $newFooterRow = $("tr.footRow2");
		               $("#fitGroupTable").footerData("set",{orderNum:"页合计：", "totalAdult":pageObj.totalAdult, "totalChild":pageObj.totalChild});


		               if (data == null || data == 'null'){
		                   data = {totalAdult:0, totalChild:0};
		               }
		               $newFooterRow.find("td[aria-describedby*='_orderNum']").text("总合计：");
					   $newFooterRow.find("td[aria-describedby*='_totalAdult']").text(data.totalAdult);
					   $newFooterRow.find("td[aria-describedby*='_totalChild']").text(data.totalChild);
		           },
		           error:function(XMLHttpRequest, textStatus, errorThrown){
		               $.error(textStatus+':'+errorThrown);
		           }
		       };
		       $("#toFitGroupListForm").ajaxSubmit(options);
		    }
}

function addCellAttr(rowId, val, rawObject, cm, rdata) {
	return "style='overflow: visible;'";
}








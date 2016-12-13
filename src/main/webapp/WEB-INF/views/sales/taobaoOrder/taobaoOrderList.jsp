<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../include/top.jsp"%>
	<link rel="stylesheet" href="<%=staticPath %>/assets/js/jqgrid/css/ui.jqgrid.css" rel="stylesheet">
	<script src="<%=staticPath %>/assets/js/jqgrid/js/i18n/grid.locale-cn.js"></script>
	<script src="<%=staticPath %>/assets/js/jqgrid/js/jquery.jqGrid.min.js"></script>
<script type="text/javascript">
	$(function() {
		var vars={
   			 dateFrom : $.currentMonthFirstDay2(-3),
   		 	dateTo : $.currentMonthLastDay()
   		 	};
		 $("input[name='startTime']").val(vars.dateFrom);
		 //$("input[name='endTime']").val(vars.dateTo ); 
});
</script>
<script type="text/javascript" src="<%=ctx%>/assets/js/web-js/sales/taobaoOrderList.js"></script>
<script type="text/javascript">
$(function(){
		  $("#ckAll").live("click",function(){
				 $("input[name='chkGroupOrder']:enabled").prop("checked", this.checked);
		  });
		  $("input[name='chkGroupOrder']").live("click",function() {
		    var $subs = $("input[name='chkGroupOrder']");
		    $("#ckAll").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
		  });
	});
</script>
<script type="text/javascript">
<!-- 回车事件 -->
document.onkeydown = function (e) { 
	var theEvent = window.event || e; 
	var code = theEvent.keyCode || theEvent.which; 
	if (code == 13) { 
	$("#order_btn_key").click(); 
	} 
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp"%>
	<div class="p_container">
	<div class="p_container_sub">
			<div class="searchRow">
				<form method="post" id="specialGroupListForm">
					<input type="hidden" name="page" id="orderPage" value="${page.page }">
					<input type="hidden" name="pageSize" id="orderPageSize" value="${page.pageSize}">
					<input type="hidden" name="byType" id="byType" value="1">
					<ul>
						<li class="text">
							<select name="dateType" id="dateType">
								<option value="1">出团日期</option>
								<option value="2">输单日期</option>
							</select>
						</li>
						<li>
							<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">团号:</li><li><input name="groupCode" id="groupCode" type="text" /> </li>
						<li class="text">客人:</li><li><input name="receiveMode" id="receiveMode" type="text" style="width: 184px;"/> </li>
						<li class="text">旺旺号:</li><li><input name="buyerNick" id="buyerNick" type="text" /> </li>
					</ul>
					<ul>
						<li class="text">平台来源:</li><li><input name="supplierName" id="supplierName" type="text" style="width: 186px;"/> </li>
						<li class="text">游客姓名:</li><li><input name="guestName" id="guestName" type="text" /> </li>
						<li class="text">电话:</li><li><input name="mobile" id="mobile" type="text" style="width: 184px;"/> </li>
						<li class="text"> 业务类型:</li>
						<li >
							<input type="text" id="dicNames" readonly="readonly"  onclick="commonDicDlg()"/> 
							<input type="hidden" name="orderNo" id="dicIds"  />
						</li>
					</ul>
					<ul>
					<li class="text">部门:</li>
						<li>
							<input type="text" name="orgNames" id="orgNames" stag="orgNames"readonly="readonly" onclick="showOrg()"  style="width: 185px;"/>
							<input name="orgIds" id="orgIds" stag="orgIds" type="hidden" />
						</li>
						<li class="text">
							<select name="operType" id="operType">
								<option value="1">销售</option>
								<option value="2">计调</option>
								<option value="3">输单</option>
							</select>:
						</li>
						<li>
							<input type="text" name="saleOperatorName" stag="userNames" readonly="readonly" value="${curUser }" onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="${curUserId }" />
						</li>
						<li class="text">产品:</li>
						<li>
							<select name="productBrandId" id="productBrandId" style="width: 64px;"><option value=""
									selected="selected">全部</option>
								<c:forEach items="${pp}" var="pp">
									<option value="${pp.id}">${pp.value }</option>
								</c:forEach>
							</select><input name="productName" id="productName" type="text" 　placeholder="请输入产品名称" style="width: 121px;"/>
						</li>
						
						<li class="text">状态:</li><li> <select name="stateFinance" id="stateFinance">
								<option value="">审核状态</option>
								<option value="0">未审核</option>
								<option value="1">已审核</option>
							</select><select name="orderLockState" id="orderLockState">
								<option value="">流程状态</option>
								<option value="0">未提交</option>
								<option value="1">接收中</option>
								<option value="2">已接收</option>
							</select>
						</li>
						<li style="padding-left:10px">
							<button id="order_btn_key" type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<button type="button" onclick="addNewSpecialGroup()" class="button button-primary button-small">新增订单</button>
							<a href="javascript:void(0);" id="toOperatorExcelId" target="_blank" onclick="toOperatorExcel()" class="button button-primary button-small">导出到Excel</a>
						</li>
						<li class="clear"></li>
					</ul>
				</form>
			</div>
		</div>
	<!-- 	<dl class="p_paragraph_content">
			<div id="content"></div>
		</dl> -->
	</div>
	<div class="p_container" >	
	<div class="jqGrid_wrapper">
		<table id="tableDiv"></table>
		<div id="pagerDiv"></div>
	</div>
</div>	
</body>
<div id="stateModal" style="display: none">
		<input type="hidden" name="id" id="modalgroupId" />
		<dl class="p_paragraph_content">
			<dd>
				<div class="dd_left">状态:</div>
				<div class="dd_right">
					<select name="groupState" id="modalGroupState">
						<option value="0">未确认</option>
						<option value="1">已确认</option>
						<option value="2">废弃</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<div class="w_btnSaveBox" style="text-align: center;">
			<button type="button" class="button button-primary button-small" onclick="editOrderGroupInfo()">确定</button>
		</div>
	</div>
	
	<div id="exportWord"
	style="display: none; text-align: center; margin-top: 10px">
	<div style="margin-top: 10px">
		<a href="" id="saleOrder" target="_blank"
			class="button button-primary button-small">确认单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" id="saleCharge" target="_blank"
			class="button button-primary button-small">结算单</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" id="saleOrderNoRoute" target="_blank"
			class="button button-primary button-small">确认单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleChargeNoRoute"
			class="button button-primary button-small">结算单-无行程</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContract"
			class="button button-primary button-small">境内旅游合同</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractAY"
			class="button button-primary button-small">境内旅游合同(爱游)</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractJY"
			class="button button-primary button-small">境内旅游合同(景怡)</a>
	</div>
	<div style="margin-top: 10px">
		<a href="" target="_blank" id="saleTravelContractYM"
			class="button button-primary button-small">境内旅游合同(怡美)</a>
	</div>
</div>
<script type="text/javascript">
function  addNewSpecialGroup(){
	newWindow('新增订单','taobao/addNewTaobaoOrder.htm');
}

function commonDicDlg() {
	$.dicItemDlg('SALES_TEAM_TYPE','dicNames','dicIds');
}

/* 导出到Excel */
function toOperatorExcel(){
	$("#toOperatorExcelId").attr("href","toOrderPreview.htm?startTime="+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&dateType="+$("#dateType").val()
			+"&groupCode="+$("#groupCode").val()
			+"&supplierName="+$("#supplierName").val()
			+"&receiveMode="+$("#receiveMode").val()
			+"&orderNo="+$("#dicIds").val()
			+"&stateFinance="+$("#stateFinance").val()
			+"&buyerNick="+$("#buyerNick").val()
			+"&guestName="+$("#guestName").val()
			+"&orderLockState="+$("#orderLockState").val()
			+"&orgIds="+$("#orgIds").val()
			+"&operType="+$("#operType").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&productBrandId="+$("#productBrandId").val()
			+"&productName="+$("#productName").val() 
			+"&page="+$("#orderPage").val()
			+"&pageSize="+$("#orderPageSize").val());
}


function goLogStock(orderId){
    showInfo("订单日志","950px","550px","<%=staticPath%>/basic/singleList.htm?tableName=group_order&tableId=" + orderId);
}

function showInfo(title,width,height,url){
    layer.open({ 
        type : 2,
        title : title,
        shadeClose : true,
        shade : 0.5,        
        area : [width,height],
        content : url
    });
 }
 
$(function(){
	opGrid.loadGrid();
	opGrid.reSize();
	$(window).bind('resize', function () {
		opGrid.reSize();
    });
});

function addCellAttr(rowId, val, rawObject, cm, rdata) {  
    return "style='overflow: visible;'";  
}  

var opGrid = {
		reSize: function(){
			var width = $('.jqGrid_wrapper').width();

	   		var height = $(window).height();//parent.get_MainContainerHeight();
	   		var searchBox=120, jqGrid_head = 55, jqGrid_pager = 30, jqGrid_footer = 45;
	   		height = height - searchBox - jqGrid_head - jqGrid_pager - jqGrid_footer;
	        $('#tableDiv').setGridWidth(width);
	        $('#tableDiv').setGridHeight(height - 10); 
		},
	/* 	setHeaders: function(){
			var options = 
	            {
	                useColSpanStyle: true,
	                groupHeaders: [
	                    { "numberOfColumns": 8, "titleText": "团信息", "startColumnName": "dateStart" },
	                    { "numberOfColumns": 3, "titleText": "团收入", "startColumnName": "incomeOrder" },
	                    { "numberOfColumns": 9, "titleText": "团成本", "startColumnName": "expenseTravelagency" },
	                    { "numberOfColumns": 4, "titleText": "团合计", "startColumnName": "totalIncome" }
	                    ]
	            };
			return options;
	    }, */
		formatMoneyCell: function(cellValue, options, rowObject) {
			/* var val = accounting.formatMoney(cellValue, "", 2);
			val = val.replace(".00", "");
	        var cellHtml = (parseFloat(cellValue) < 0) ? "<span style='color:red'>" + val + "</span>" : val;
	        return cellHtml; */
	    },
	    formatMoney: function(val){
			var valStr = accounting.formatMoney(val,"",2);
			valStr = valStr.replace(".00", "");
			return (parseFloat(val) < 0) ? "<span style='color:red'>" + valStr + "</span>" : valStr;
		},
		getParam: function(){
			var rowListNum = $("#contentGroupOrderTable").jqGrid('getGridParam', 'rowNum');
			if(rowListNum == undefined){
				$('#pageSize').val(15);
			}else{
				$('#pageSize').val(rowListNum);
			}
			var params = {'byType':$("#byType").val(), 'dateType':$("#dateType").val(), 'startTime':$("#startTime").val()
					,'endTime':$("#endTime").val(), 'groupCode':$("#groupCode").val()
					,'receiveMode':$("#receiveMode").val(),'buyerNick':$("#buyerNick").val(),'supplierName':$("#supplierName").val()
					,'guestName':$("#guestName").val(),'mobile':$("#mobile").val()
					,'orderNo':$("#dicIds").val(),'orgIds':$("#orgIds").val()
					,'operType':$("#operType").val(),'saleOperatorIds':$("#saleOperatorIds").val()
					,'productBrandId':$("#productBrandId").val(),'productName':$("#productName").val()
					,'stateFinance':$("#stateFinance").val(),'orderLockState':$("#orderLockState").val()
					};
	    	return params;
		},
		formatOptions:function (cellValue, options, rowObject){
			var ops =  '<div class="tab-operate">' +
				'<a href="####" class="btn-show">操作<span class="caret"></span></a>' +
				'<div class="btn-hide" id="asd">' +
				'<a href="javascript:void(0);" class="def" onclick="printOrder('+rowObject.id+')" >打印</a>' +
				'<a href="javascript:void(0)" class="def" onclick="goLogStock('+rowObject.id+')" >操作日志</a>';
				if((rowObject.orderLockState == 0 || rowObject.orderLockState == 1) && rowObject.stateFinance !=1) {
					ops+='<a href="javascript:void(0);" onclick="newWindow(\'编辑订单\',\'taobao/toEditTaobaoOrder.htm?id='+rowObject.id+'&see=1\')" class="def">编辑</a>';	
				}else{
					ops+='<a href="javascript:void(0);" onclick="newWindow(\'查看订单\',\'taobao/toEditTaobaoOrder.htm?id='+rowObject.id+'+&see=0\')"  class="def" >查看</a>';
				}
				if(rowObject.orderLockState == 0) {
					ops+='<a href="javascript:void(0);" onclick="changeorderLockState('+rowObject.id+')" class="def">提交给计调</a>';
				}
				if(rowObject.orderLockState != 2 && rowObject.stateFinance !=1 && rowObject.totalCash=='0.0000' && rowObject.groupState!=3 && rowObject.groupState!=4) {
					ops+='<a href="javascript:void(0);" onclick="delGroup('+rowObject.id+')" class="def">删除</a>';	
				}
				/* '<a href="javascript:void(0);" onclick="changeGroupState('+rowObject.groupId+','+rowObject.groupState+')" class="def">状态</a>' +
				'</div>' +
				'</div>'; */
			return ops;
		},
		loadGrid: function(){
			//$.jgrid.defaults.styleUI = 'Bootstrap';
			$("#tableDiv").jqGrid({
	            url: 'taobaoOrderList_tableData.do',
	            datatype: "json",
	            mtype : "post",
	            height: 250,
	            autowidth: false,
	            shrinkToFit: true,
	            rownumbers:true,
	            rowNum: 16,
	            rowList: [15, 30, 50, 100, 500, 1000],
	            colNames: ['团号', '出发日期', '产品名称', '平台来源', '客人', '旺旺号', '成人','儿童','全陪','金额','业务','流程','团状态','销售员','计调员','操作'],
	            colModel: [
	              {name: 'groupCode', index: 'group_code', width: 130, frozen:true, formatter:function(cellValue,options,rowObject){
	            	  if( cellValue != null) {return "<a href=\"javascript:lookGroup("+rowObject.groupId+",\'"+rowObject.groupCode+"\');\">"+rowObject.groupCode+"</a>";}
	            	  else {return "";}
	              }},
	              {name: 'departureDate', index: 'departure_date', width: 90,align:'center',
	            	  formatter:function(value,options,rowObject){
		                    if( value < rowObject.fitDate ){return "<span style='color:red'>"+value+"</span>";}
		                    else {return value;}
	            	  		}      
	            	  },
	              {name: 'productName', index: 'product_name', width: 300, align: "left",
	                  formatter:function(cellValue,options,rowObject){
	                  	return ("【"+rowObject.productBrandName+"】"+cellValue);
	                  }
	              },
	              {name: 'supplierName',index: 'supplier_name',width: 80, align:'center'},
	              {name: 'receiveMode',index: 'receive_mode',width: 150,align:'center'},
	              {name: 'buyerNick',index: 'buyer_nick',width: 150, align:'center'},
					{name: 'numAdult',index: 'num_adult',width: 47, align: "center"},
					{name: 'numChild',index: 'num_child',width: 47, align: "center"},
					{name: 'numGuide',index: 'num_Guide',width: 47, align: "center"},
					{name: 'total',index: 'total',width: 80, align: "right"},
					{name: 'orderModeType',index: 'orderModeType',width: 80, align: "center", sortable: false},
					{name: 'orderLockState',index: 'orderLockState',width: 80, align: "center", sortable: false,
						formatter:function(value,options,rowData){
		                    if( value==0 ){return '未提交';}
		                    if( value==1 ){return "<span style='color:red'>"+'接收中'+"</span>";}
		                    if( value==2 ){return "<span style='color:blue'>"+'已接收'+"</span>";}
						}
					},
					{name: 'groupId',index: 'groupId',width: 80, align: "center", sortable: false,
						formatter:function(value,options,rowObject){
							if( value > 0 ){
		                    	if(rowObject.groupState==0){return '未确认';}
		                    	if(rowObject.groupState==1){return "<span class='log_action insert'>"+'已确认'+"</span>";}
		                    	if(rowObject.groupState==2){return "<span class='log_action delete'>"+'已废弃'+"</span>";}
		                    	if(rowObject.groupState==3){return "<span class='log_action update'>"+'已审核'+"</span>";}
		                    	if(rowObject.groupState==4){return "<span class='log_action fuchsia'>"+'已封存'+"</span>";}
		                    	}
		                    else {return "<span style='color:red'>"+'待并团'+"</span>";}
						}	
					},
					{name: 'saleOperatorName',index: 'saleOperatorName',width: 80, align: "center", sortable: false},
					{name: 'operatorName',index: 'operatorName',width: 80, align: "center", sortable: false, },
				    {name: 'operations',index: 'operations',width: 100, sortable: false,align:'center',cellattr: addCellAttr,  
				        editable:true,edittype:'select',formatter:opGrid.formatOptions  
				    }  
	              ],
	            pager: "#pagerDiv",
	            viewrecords: true,
	            caption: "",
	             jsonReader:{
	            	id: "groupId",  
	            	root: "result",
	            　　			total: "totalPage",
	            　　			page: "page",
	            　　			records: "totalCount", 
	            　　	repeatitems: false
	            }, 
	            postData:opGrid.getParam(),
	            footerrow: true,
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
	                var list = xhr.result;
	                opGrid.getPageFooter(list);

					//冻结
	                //jQuery("#tableDiv").jqGrid('destroyFrozenColumns');
	                //if(list.length > 0){
	                //	jQuery("#tableDiv").jqGrid('setFrozenColumns');
	                //}
	                	
	            }
	        });

				/* $("#tableDiv").jqGrid("setGroupHeaders", opGrid.setHeaders()); */
			},
			getPageFooter: function(totalRow){
				var pageObj = {sumTotal:0,pAdult:0, pChild:0, pGuide:0};
					$.each(totalRow, function(i,item){
						pageObj.sumTotal += parseFloat(item.total);
						pageObj.pAdult += parseInt(item.numAdult);
						pageObj.pChild += parseInt(item.numChild);
						pageObj.pGuide += parseInt(item.numGuide);
					});
					
				  var options = {
						url:"taobaoOrderList_PostFooter.do",
				    	type:"post",
				    	dataType:"json",
				    	success:function(data){
				    		$("tr.footRow2").remove();
				    		var $footerRow = $("tr.footrow");
					        $footerRow.after("<tr role='row' class='footrow footRow2 footrow-ltr ui-widget-content'>"+$footerRow.html()+"</tr>");
					        var $newFooterRow = $("tr.footRow2");
					        
				    		$("#tableDiv").footerData("set",{buyerNick:"页合计："
				    			,numAdult:pageObj.pAdult,numChild:pageObj.pChild,numGuide:pageObj.pGuide, total:pageObj.sumTotal});
				    		
				    		if (data == null || data == 'null'){
				    			data = {incomeOrder:0,incomeOther:0,incomeShop:0,expenseTravelagency:0,expenseHotel:0,expenseRestaurant:0,expenseFleet:0,expenseScenicspot:0,expenseAirticket:0
				    					,expenseTrainticket:0,expenseInsurance:0,expenseOther:0,totalIncome:0,totalExpense:0,totalProfit:0,profitPerGuest:0, totalAdult:0, totalChild:0, totalGuide:0};
				    		}
					        $newFooterRow.find("td[aria-describedby*='_buyerNick']").text("总合计：");
					        $newFooterRow.find("td[aria-describedby*='_numAdult']").text(data.numAdult);
					        $newFooterRow.find("td[aria-describedby*='_numChild']").text(data.numChild);
					        $newFooterRow.find("td[aria-describedby*='_numGuide']").text(data.numGuide);
					        $newFooterRow.find("td[aria-describedby*='_total']").text(data.total);
				    		//$("tr.footrow").find("td").attr("class", "jqGridFooterBg");
				    	},
				    	error:function(XMLHttpRequest, textStatus, errorThrown){
				    		$.error(textStatus+':'+errorThrown);
				    	}
				    };
				 $("#specialGroupListForm").ajaxSubmit(options);
			}
	}
	
function printOrder(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	$("#saleTravelContract").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+6) ;
	$("#saleTravelContractAY").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+9) ;
	$("#saleTravelContractJY").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+10) ;
	$("#saleTravelContractYM").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+11) ;
	//$("#saleInsurance").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+7) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '310px' ],
		content : $('#exportWord')
	});
};

function changeorderLockState(orderId){
	$.confirm("是否确认提交给计调？",  function(){
		$.getJSON("../taobao/changeOrderLockState.do?orderId=" + orderId, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					layer.close(stateIndex);
					searchBtn(); 
				});
			}
		});
	}, function(){
	$.info('操作取消！');
	})
}
</script>
</html>
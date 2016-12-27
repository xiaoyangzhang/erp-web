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
$(function () {
    function setData() {
        var curDate = new Date();
        var startTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-01";
        $("#startTime").val(startTime);
        var new_date = new Date(curDate.getFullYear(), curDate.getMonth() + 1, 1);
        var endDate = (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate();
        var endTime = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + "-" + endDate;
        $("#endTime").val(endTime);
    }
    
    setData();
});
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
						<li class="text">出团日期</li>
						<li>
								<input name="startTime" id="startTime" type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"/> 
							~ 
							<input name="endTime" id="endTime"  type="text"  class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
						</li>
						<li class="text">平台来源:</li><li><input name="businessName" id="businessName" type="text" style="width: 186px;"/> </li>
						<li class="text">供应商:</li><li><input name="supplierName" id="supplierName" type="text" style="width: 186px;"/> </li>
						<li class="text">类别:</li>
						<li> <select name='groupMode'>
								<option value="1">团队</option>
							</select>
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
							</select>:
						</li>
						<li>
							<input type="text" name="saleOperatorName" stag="userNames" readonly="readonly" value="" onclick="showUser()"/> 
							<input name="saleOperatorIds" id="saleOperatorIds" stag="userIds" type="hidden" value="" />
						</li>
						<li style="padding-left:10px">
							<button id="order_btn_key" type="button" onclick="searchBtn()" class="button button-primary button-small">查询</button>
							<a href="javascript:void(0);" id="toOperatorExcelId" target="_blank" onclick="toExcel()" class="button button-primary button-small">导出到Excel</a>
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

<script type="text/javascript">

/* 导出到Excel */
function toExcel(){
	$("#toOperatorExcelId").attr("href","toPaymentExcel.do?startTime="+$("#startTime").val()
			+"&endTime="+$("#endTime").val()
			+"&businessName="+$("#businessName").val()
			+"&groupMode="+$("#groupMode").val()
			+"&supplierName="+$("#supplierName").val()
			+"&operType="+$("#operType").val()
			+"&orgIds="+$("#orgIds").val()
			+"&saleOperatorIds="+$("#saleOperatorIds").val()
			+"&page="+$("#orderPage").val()
			+"&pageSize="+$("#orderPageSize").val());
}

function searchBtn() {
		$("#tableDiv").jqGrid('setGridParam', {page:1, postData: opGrid.getParam()}).trigger("reloadGrid"); //重新载入 
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
			var params = {'startTime':$("#startTime").val()
					,'endTime':$("#endTime").val(), 'businessName':$("#businessName").val()
					,'groupMode':$("#groupMode").val(),'supplierName':$("#supplierName").val()
					,'operType':$("#operType").val(),'orgIds':$("#orgIds").val()
					,'saleOperatorIds':$("#saleOperatorIds").val()
					};
	    	return params;
		},
		
		loadGrid: function(){
			//$.jgrid.defaults.styleUI = 'Bootstrap';
			$("#tableDiv").jqGrid({
	            url: 'PaymentStatisticsListData.do',
	            datatype: "json",
	            mtype : "post",
	            height: 250,
	            autowidth: false,
	            shrinkToFit: true,
	            rownumbers:true,
	            rowNum: 15,
	            rowList: [15, 30, 50, 100, 500, 1000],
	            colNames: ['平台来源', '供应商', '应付', '已付', '未付', '其他收入','应收', '已收','未收'],
	            colModel: [
				{name: 'businessName',index: 'businessName',width: 80, align: "center", sortable: false, },
				{name: 'supplierName',index: 'supplierName',width: 80, align: "center", sortable: false, },
				{name: 'cost',index: 'cost',width: 80, align: "center", sortable: false, },
				{name: 'costCash',index: 'costCash',width: 80, align: "center", sortable: false, },
				{name: 'costBalance',index: 'costBalance',width: 80, align: "center", sortable: false, },
				{name: 'otherTotal',index: 'otherTotal',width: 80, align: "center", sortable: false, },
				{name: 'total',index: 'total',width: 80, align: "center", sortable: false, },
				{name: 'totalCash',index: 'totalCash',width: 80, align: "center", sortable: false, },
				{name: 'totalBalance',index: 'totalBalance',width: 80, align: "center", sortable: false, },
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

			},
			  getPageFooter: function(totalRow){
				var pageObj = {sumTotal:0,sumTotalCash:0, sumTotalBalance:0, sumCost:0,sumCostCash:0,sumCostBalance:0,sumOtherTotal:0};
					$.each(totalRow, function(i,item){
						pageObj.sumTotal += parseFloat(item.total);
						pageObj.sumTotalCash += parseFloat(item.totalCash);
						pageObj.sumTotalBalance += parseFloat(item.totalBalance);
						pageObj.sumCost += parseFloat(item.cost);
						pageObj.sumCostCash += parseFloat(item.costCash);
						pageObj.sumCostBalance += parseFloat(item.costBalance);
						pageObj.sumOtherTotal += parseFloat(item.otherTotal);
					});
					
					$("#tableDiv").footerData("set",{supplierName:"页合计："
		    			,cost:pageObj.sumCost,costCash:pageObj.sumCostCash,costBalance:pageObj.sumCostBalance, otherTotal:pageObj.sumOtherTotal, total:pageObj.sumTotal
		    			, totalCash:pageObj.sumTotalCash, totalBalance:pageObj.sumTotalBalance});
				 
	}
}
</script>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>单团利润统计表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <%@ include file="../../include/top.jsp" %>
    
	<link rel="stylesheet" href="<%=staticPath %>/assets/js/jqgrid/css/ui.jqgrid.css" rel="stylesheet">
	<script src="<%=staticPath %>/assets/js/jqgrid/js/i18n/grid.locale-cn.js"></script>
	<script src="<%=staticPath %>/assets/js/jqgrid/js/jquery.jqGrid.min.js"></script>
</head>
<body>
<div class="p_container" ><div style="border: 1px solid #e7eff1">
		<form id="searchRequestForm" name="searchRequestForm" method="post">
		<input type="hidden" name="page" id="page" value="${page.page}"> 
		<input type="hidden" name="pageSize" id="pageSize" value="${page.pageSize}">
		<dl>
			<dd class="inl-bl">
				<div class="dd_left" >出团日期：</div>
				<div class="dd_right">
					<input name="dateStart_Search" id="startTime" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
					—<input name="dateEnd_Search" id="endTime" type="text" class="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl">
				<div class="dd_left">团号：</div>
				<div class="dd_right grey"><input name="groupCode" id="groupCode" type="text" value=""/></div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl">
				<div class="dd_left">组团社：</div>
				<div class="dd_right"><input name="receiveMode" id="receiveMode" type="text" value=""/></div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl">
				<div class="dd_left">产品：</div>
				<div class="dd_right">
				<input name="productName" id="productName" type="text" value=""/>
				</div>
				<div class="clear"></div>
			</dd>
		</dl>
		<dl>
			<dd class="inl-bl">
				<div class="dd_left">部门：</div>
    			<div class="dd_right">
					<input type="text" name="orgNames" id="orgNames" stag="orgNames" value="" readonly="readonly" onclick="showOrg()" style="width: 182px;">
					<input type="hidden" name="orgIds" id="orgIds" stag="orgIds" value="" />    				
    			</div>
    			<div class="clear"></div>
    			</dd>
    		<dd class="inl-bl">
				<div class="dd_left"><select id="state" name="state">
	    					<option value="1" >计调</option>
	    					<option value="0" >销售</option>
	    				</select></div>
    			<div class="dd_right">
	    			<input type="text" name="saleOperatorName" id="saleOperatorName" value="" stag="userNames" readonly="readonly"  onclick="showUser()"/> 
	    			<input type="hidden" name="saleOperatorIds" id="saleOperatorIds" stag="userIds" value="" />
    			</div>
    		</dd>
			<dd class="inl-bl">
				<div class="dd_left">团类型：</div>
				<div class="dd_right">
					<select name="groupMode" id="groupMode" style="width:151px">
						<option value="">全部</option>
						<option value='0' >散客</option>
						<option value="1" >团队</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl">
				<div class="dd_left">状态：</div>
				<div class="dd_right">
					<select name="groupStatus" id="groupStatus">
						<option value="">全部</option>
						<option value='0' >未审核</option>
						<option value="1" >已审核</option>
					</select>
				</div>
				<div class="clear"></div>
			</dd>
			<dd class="inl-bl">
			<div class="dd_right" style="margin-left:10px;">
				<button type="button" onclick="searchBtn();" class="button button-primary button-small">查询</button>
				<button type="button" onclick="print();" class="button button-primary button-small">打印</button>

			</div>
			</dd>
		</dl>
		</form>
</div></div>
<div class="p_container" >	
	<div class="jqGrid_wrapper">
		<table id="tableDiv"></table>
		<div id="pagerDiv"></div>
	</div>
</div>	



<div id="content">
</div>

<script src="<%=staticPath %>/assets/js/moment.js"></script>
<script src="<%=staticPath %>/assets/js/accounting.min.js"></script>
<script type="text/javascript">
$(function(){
	$("#startTime").val($.currentMonthFirstDay());
	$("#endTime").val($.currentMonthLastDay() );	
});

function queryList(page, pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#page").val(page);

	
	var options = {
		url:"GroupProfitList_Post.do",
    	type:"post",
    	dataType:"html",
    	success:function(data){
    		$("#content").html(data);
    	},
    	error:function(XMLHttpRequest, textStatus, errorThrown){
    		$.error(textStatus+':'+errorThrown);
    	}
    };
    alert('马上开始');
    $("#searchRequestForm").ajaxSubmit(options);	
}

function searchBtn() {
	//var pageSize=$("#PageSize").val();
	//queryList(1,pageSize);
	
	$("#tableDiv").jqGrid('setGridParam', {page:1, postData: opGrid.getParam()}).trigger("reloadGrid"); //重新载入 
}


function goToGroupStatistics(groupId, groupCode){
	newWindow('团信息'+groupCode, '<%=staticPath%>/finance/auditGroupListPrint.htm?groupId='+groupId+'&isShow=true');
}

function print(){
	window.open ("<%=staticPath%>/tjGroup/toGroupProfitPrint1.htm?"+ $("#searchRequestForm").serialize());
}

</script>
<script type="text/javascript">
$(function(){
	opGrid.loadGrid();
	opGrid.reSize();
	
	
	$(window).bind('resize', function () {
		opGrid.reSize();
    });
});


var opGrid = {
	reSize: function(){
		var width = $('.jqGrid_wrapper').width();

   		var height = $(window).height();//parent.get_MainContainerHeight();
   		var searchBox=80, jqGrid_head = 55, jqGrid_pager = 30, jqGrid_footer = 45;
   		height = height - searchBox - jqGrid_head - jqGrid_pager - jqGrid_footer;
        $('#tableDiv').setGridWidth(width);
        $('#tableDiv').setGridHeight(height - 10); 
	},
	setHeaders: function(){
		var options = 
            {
                useColSpanStyle: true,
                groupHeaders: [
                    { "numberOfColumns": 8, "titleText": "团信息", "startColumnName": "dateStart" },
                    { "numberOfColumns": 2, "titleText": "团收入", "startColumnName": "incomeOrder" },
                    { "numberOfColumns": 9, "titleText": "团成本", "startColumnName": "expenseTravelagency" },
                    { "numberOfColumns": 4, "titleText": "团合计", "startColumnName": "totalIncome" }
                    ]
            };
		return options;
    },
	formatMoneyCell: function(cellValue, options, rowObject) {
		var val = accounting.formatMoney(cellValue, "", 2);
		val = val.replace(".00", "");
        var cellHtml = (parseFloat(cellValue) < 0) ? "<span style='color:red'>" + val + "</span>" : val;
        return cellHtml;
    },
    formatMoney: function(val){
		var valStr = accounting.formatMoney(val,"",2);
		valStr = valStr.replace(".00", "");
		return (parseFloat(val) < 0) ? "<span style='color:red'>" + valStr + "</span>" : valStr;
	},
	getParam: function(){
		var params = {'dateStart_Search':$("#startTime").val(), 'dateEnd_Search':$("#endTime").val(), 'groupCode':$("#groupCode").val()
				,'receiveMode':$("#receiveMode").val(), 'productName':$("#productName").val()
				,'orgNames':$("#orgNames").val(),'orgIds':$("#orgIds").val(),'state':$("#state").val()
				,'saleOperatorName':$("#saleOperatorName").val(),'saleOperatorIds':$("#saleOperatorIds").val()
				,'groupMode':$("#groupMode").val(),'groupStatus':$("#groupStatus").val()
				};
    	return params;
	},
	loadGrid: function(){
		//$.jgrid.defaults.styleUI = 'Bootstrap';
		$("#tableDiv").jqGrid({
            url: 'GroupProfitList_GetData.do',
            datatype: "json",
            mtype : "post",
            height: 250,
            autowidth: false,
            shrinkToFit: false,
            rownumbers:true,
            rowNum: 15,
            rowList: [15, 30, 50, 100, 500, 1000],
            colNames: ['团号', '日期', '成人', '儿童', '全陪', '产品线路', '组团社','地接社','计调','团费','其他收入','地接','房费','餐费','车费','门票','机票','火车票','保险','其他支出','总收入','总成本','毛利','人均毛利'],
            colModel: [
              {name: 'groupCode', index: 'groupCode', width: 130, frozen:true, formatter:function(cellValue,options,rowObject){
            	  return "<a href=\"javascript:goToGroupStatistics("+rowObject.groupId+",\'"+rowObject.groupCode+"\');\">"+rowObject.groupCode+"</a>";
              }},
              {name: 'dateStart', index: 'dateStart', width: 90, align: "center",formatter:function(cellValue,options,rowObject){
                	return (moment(rowObject.dateStart).format("MM-DD")+"/"+moment(rowObject.dateEnd).format("MM-DD"));}
              },
              {name: 'totalAdult',index: 'totalAdult',width: 40, sortable: false, align:'center'},
              {name: 'totalChild',index: 'totalChild',width: 30, sortable: false, align:'center'},
              {name: 'totalGuide',index: 'totalGuide',width: 30, sortable: false, align:'center'},
              {name: 'productName', index: 'productName', width: 300, align: "left", sortable: false,
                  formatter:function(cellValue,options,rowObject){
                  	return ("【"+rowObject.productBrandName+"】"+cellValue);
                  }
              },
				{name: 'orderSupplierNames',index: 'orderSupplierNames',width: 370, sortable: false, formatter:function(cellValue,options,rowObject){
					var ret="";
					if (cellValue != undefined && cellValue != 'undefined'){
						$.each(cellValue.split(','), function(i,item){
							var iary = item.split('@');
							if (iary.length == 7)
								ret += "<ul class='p'><li class='s' style='width:210px;'>"+iary[0]+"</li><li class='s' style='width:40px;'>"+iary[1]+"+"+iary[2]+"</li><li class='s' style='width:50px'>"+opGrid.formatMoney(iary[4])+"</li><li class='s' style='width:50px'>"+iary[5]+"</li><li class='s' style='width:20px'>"+iary[6]+"</li></ul>";
						});
					}
					return ret;
				}},
				{name: 'deliveryNames',index: 'deliveryNames',width: 240, sortable: false, formatter:function(cellValue,options,rowObject){
					var ret="";
					if (cellValue != undefined && cellValue != 'undefined'){
						$.each(cellValue.split(','), function(i,item){
							ret += "<p>"+item+"</p>";
						});
					}
					return ret;
				}},
				{name: 'operatorName',index: 'operatorName',width: 60, sortable: false, align:'center'},
				{name: 'incomeOrder',index: 'incomeOrder',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'incomeOther',index: 'incomeOther',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseTravelagency',index: 'expenseTravelagency',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseHotel',index: 'expenseHotel',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseRestaurant',index: 'expenseRestaurant',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseFleet',index: 'expenseFleet',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseScenicspot',index: 'expenseScenicspot',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseAirticket',index: 'expenseAirticket',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseTrainticket',index: 'expenseTrainticket',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseInsurance',index: 'expenseInsurance',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'expenseOther',index: 'expenseOther',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'totalIncome1',index: 'totalIncome1',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'totalExpense',index: 'totalExpense',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell},
				{name: 'totalProfit1',index: 'totalProfit1',width: 80, align: "right", sortable: false,  formatter:opGrid.formatMoneyCell},
				{name: 'profitPerGuest',index: 'profitPerGuest',width: 80, align: "right", sortable: false, formatter:opGrid.formatMoneyCell}
              ],
            pager: "#pagerDiv",
            viewrecords: true,
            caption: "",
            jsonReader:{
            	id: "groupId", //相当于设置主键
            	root: "result",　　　 //Json数据
            　　			total: "totalPage",　　 //总页数
            　　			page: "page",　　//当前页
            　　			records: "totalCount",//总记录数
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

			$("#tableDiv").jqGrid("setGroupHeaders", opGrid.setHeaders());
		},
		getPageFooter: function(totalRow){
			var pageObj = {incomeOrder:0,incomeOther:0,incomeShop:0,expenseTravelagency:0,expenseHotel:0,expenseRestaurant:0,expenseFleet:0,expenseScenicspot:0,expenseAirticket:0
      			   ,expenseTrainticket:0,expenseInsurance:0,expenseOther:0,totalIncome:0,totalExpense:0,totalProfit:0,profitPerGuest:0, pAdult:0, pChild:0, pGuide:0};
				$.each(totalRow, function(i,item){
					pageObj.incomeOrder += parseFloat(item.incomeOrder);
					pageObj.incomeOther += parseFloat(item.incomeOther);
					pageObj.incomeShop += parseFloat(item.incomeShop);
					pageObj.expenseTravelagency += parseFloat(item.expenseTravelagency);
					pageObj.expenseHotel += parseFloat(item.expenseHotel);
					pageObj.expenseRestaurant += parseFloat(item.expenseRestaurant);
					pageObj.expenseFleet += parseFloat(item.expenseFleet);
					pageObj.expenseScenicspot += parseFloat(item.expenseScenicspot);
					pageObj.expenseAirticket += parseFloat(item.expenseAirticket);
					pageObj.expenseTrainticket += parseFloat(item.expenseTrainticket);
					pageObj.expenseInsurance += parseFloat(item.expenseInsurance);
					pageObj.expenseOther += parseFloat(item.expenseOther);
					pageObj.totalIncome += parseFloat(item.totalIncome);
					pageObj.totalExpense += parseFloat(item.totalExpense);
					pageObj.totalProfit += parseFloat(item.totalProfit);
					pageObj.profitPerGuest += parseFloat(item.profitPerGuest);
					pageObj.pAdult += parseInt(item.totalAdult);
					pageObj.pChild += parseInt(item.totalChild);
					pageObj.pGuide += parseInt(item.totalGuide);
					
					//pageObj.totalIncome =pageObj.totalIncome -pageObj.incomeShop;
					//pageObj.totalProfit =pageObj.totalProfit -pageObj.incomeShop;
				});
				
				pageObj.profitPerGuest = 0;
				if (pageObj.pAdult + pageObj.pChild + pageObj.pGuide > 0) 
					pageObj.profitPerGuest = parseFloat(pageObj.totalProfit)/(pageObj.pAdult + pageObj.pChild + pageObj.pGuide);
				
			var options = {
					url:"GroupProfitList_PostFooter.do",
			    	type:"post",
			    	dataType:"json",
			    	success:function(data){
			    		$("tr.footRow2").remove();
			    		var $footerRow = $("tr.footrow");
				        $footerRow.after("<tr role='row' class='footrow footRow2 footrow-ltr ui-widget-content'>"+$footerRow.html()+"</tr>");
				        var $newFooterRow = $("tr.footRow2");
				        
			    		$("#tableDiv").footerData("set",{groupCode:"页合计："
			    			,totalAdult:pageObj.pAdult, totalChild:pageObj.pChild ,totalGuide:pageObj.pGuide
			    			,incomeOrder:pageObj.incomeOrder
			    			,incomeOther:pageObj.incomeOther
			    			,expenseTravelagency:pageObj.expenseTravelagency
							,expenseHotel:pageObj.expenseHotel
							,expenseRestaurant:pageObj.expenseRestaurant
			    			,expenseFleet:pageObj.expenseFleet
							,expenseScenicspot:pageObj.expenseScenicspot
							,expenseAirticket:pageObj.expenseAirticket
			    			,expenseTrainticket:pageObj.expenseTrainticket
							,expenseInsurance:pageObj.expenseInsurance
							,expenseOther:pageObj.expenseOther
			    			,totalIncome:parseFloat(pageObj.totalIncome)-parseFloat(pageObj.incomeShop)
							,totalExpense:pageObj.totalExpense
							,totalProfit:parseFloat(pageObj.totalProfit)-parseFloat(pageObj.incomeShop)
							,profitPerGuest:pageObj.profitPerGuest});
			    		
			    		if (data == null || data == 'null'){
			    			data = {incomeOrder:0,incomeOther:0,incomeShop:0,expenseTravelagency:0,expenseHotel:0,expenseRestaurant:0,expenseFleet:0,expenseScenicspot:0,expenseAirticket:0
			    					,expenseTrainticket:0,expenseInsurance:0,expenseOther:0,totalIncome:0,totalExpense:0,totalProfit:0,profitPerGuest:0, totalAdult:0, totalChild:0, totalGuide:0};
			    		}
				        $newFooterRow.find("td[aria-describedby*='_groupCode']").text("总合计：");
				        $newFooterRow.find("td[aria-describedby*='_totalAdult']").text(data.totalAdult);
				        $newFooterRow.find("td[aria-describedby*='_totalChild']").text(data.totalChild);
				        $newFooterRow.find("td[aria-describedby*='_totalGuide']").text(data.totalGuide);
						$newFooterRow.find("td[aria-describedby*='_incomeOrder']").html(opGrid.formatMoney(data.incomeOrder));
						$newFooterRow.find("td[aria-describedby*='_incomeOther']").html(opGrid.formatMoney(data.incomeOther));
						$newFooterRow.find("td[aria-describedby*='_expenseTravelagency']").html(opGrid.formatMoney(data.expenseTravelagency));
						$newFooterRow.find("td[aria-describedby*='_expenseHotel']").html(opGrid.formatMoney(data.expenseHotel));
						$newFooterRow.find("td[aria-describedby*='_expenseRestaurant']").html(opGrid.formatMoney(data.expenseRestaurant));
						$newFooterRow.find("td[aria-describedby*='_expenseFleet']").html(opGrid.formatMoney(data.expenseFleet));
						$newFooterRow.find("td[aria-describedby*='_expenseScenicspot']").html(opGrid.formatMoney(data.expenseScenicspot));
						$newFooterRow.find("td[aria-describedby*='_expenseAirticket']").html(opGrid.formatMoney(data.expenseAirticket));
						$newFooterRow.find("td[aria-describedby*='_expenseTrainticket']").html(opGrid.formatMoney(data.expenseTrainticket));
						$newFooterRow.find("td[aria-describedby*='_expenseInsurance']").html(opGrid.formatMoney(data.expenseInsurance));
						$newFooterRow.find("td[aria-describedby*='_expenseOther']").html(opGrid.formatMoney(data.expenseOther));
						$newFooterRow.find("td[aria-describedby*='_totalIncome']").html(opGrid.formatMoney(data.totalIncome));
						$newFooterRow.find("td[aria-describedby*='_totalExpense']").html(opGrid.formatMoney(data.totalExpense));
						$newFooterRow.find("td[aria-describedby*='_totalProfit']").html(opGrid.formatMoney(data.totalProfit));
						$newFooterRow.find("td[aria-describedby*='_profitPerGuest']").html(opGrid.formatMoney(data.profitPerGuest));
					    
						

			    		//$("tr.footrow").find("td").attr("class", "jqGridFooterBg");
			    	},
			    	error:function(XMLHttpRequest, textStatus, errorThrown){
			    		$.error(textStatus+':'+errorThrown);
			    	}
			    };
			 $("#searchRequestForm").ajaxSubmit(options);
		}
		
	
}

</script>
<%@ include file="/WEB-INF/views/component/org-user/org_user_multi.jsp" %>
</body>

</html>
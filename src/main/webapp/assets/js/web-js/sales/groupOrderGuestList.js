$(function(){
	opGrid.loadGrid();
	opGrid.reSize();


	$(window).bind('resize', function () {
		opGrid.reSize();
	});
});
var opGrid = {
	reSize: function(){
		var width = $('.jqGrid_guest').width();

		var height = $(window).height();//parent.get_MainContainerHeight();
		var searchBox=80, jqGrid_head = 55, jqGrid_pager = 30, jqGrid_footer = 45;
		height = height - searchBox - jqGrid_head - jqGrid_pager - jqGrid_footer;
		$('#contentGroupOrderTable').setGridWidth(width);
		$('#contentGroupOrderTable').setGridHeight(height - 10);
	},
	getParam: function(){
		var rowListNum = $("#contentGroupOrderTable").jqGrid('getGridParam', 'rowNum');
		if(rowListNum == undefined){
			$('#pageSize').val(15);
		}else{
			$('#pageSize').val(rowListNum);
		}
		var params = {'startTime':$("#startTime").val()
			, 'endTime':$("#endTime").val()
			, 'supplierName':$("#supplierName").val()
			, 'groupCode':$("#groupCode").val()
			,'receiveMode':$("#receiveMode").val()
			,'orgNames':$("#orgNames").val()
			,'orgIds':$("#orgIds").val()
			,'saleOperatorName':$("#saleOperatorName").val()
			,'saleOperatorIds':$("#saleOperatorIds").val()

			,'productName':$("#productName").val()
			,'remark':$("#remark").val()
			,'operType':$("#operType").val()
			,'guestName':$("#guestName").val()
			,'gender':$("#gender").val()
			,'ageFirst':$("#ageFirst").val()
			,'ageSecond':$("#ageSecond").val()
			,'nativePlace':$("#nativePlace").val()
			,'pageSize':$("#pageSize").val()
			,'userRightType':$("#userRightType").val()
		};
		return params;
	},
	formatPerson:function(cellValue, options, rowObject){
		var total_p = cellValue/(rowObject.num_adult+rowObject.num_child);//金额除以人数
		var resTotal = accounting.formatMoney(total_p, "", 2);//保留2位小数
		resTotal= resTotal.replace(".00", "");//格式化数字
		return resTotal;
	},

	formatGender:function(v,o,r){
		if(v == 0 ){
			return '女';
		}else{
			return '男';
		}
	},
	loadGrid: function(){
		$("#contentGroupOrderTable").jqGrid({
			url: 'groupOrderGuestDataList.do',
			datatype: "json",
			mtype : "post",
			height: 250,
			//height: "100%",
			autowidth: false,
			shrinkToFit: true,
			rownumbers:true,
			rowNum: 15,
			rowList: [15, 30, 50, 100, 500, 1000],
			//colNames: ['团号', '发团日期', '平台来源', '客人信息', '姓名', '性别',
			//       '年龄','证件号','电话','籍贯','产品套餐','业务','销售','计调','金额'],
			colModel: [
				{label:'团号',name: 'group_code',index: 'groupCode',width: 150, sortable: false, align:'left'},
				{label:'发团日期',name: 'departure_date',index: 'departure_date',align: "center",formatter:function(cellValue,options,rowObject){
					return (moment(rowObject.departure_date).format("YYYY-MM-DD"));},width: 150, align:'center'},
				{label:'平台来源',name: 'supplier_name',index: 'supplier_name',width: 100, sortable: false, align:'left'},
				{label:'客人信息',name: 'receive_mode',index: 'receive_mode',width: 300, sortable: false, align:'left'},
				{label:'姓名',name: 'name',index: 'name',width: 100, sortable: false,align:'center'},

				{label:'性别',name: 'gender',index: 'gender',width: 80, sortable: false, align:'center',formatter:opGrid.formatGender},
				{label:'年龄',name: 'age',index: 'age',width: 80,  align:'center'},
				{label:'证件号',name: 'certificate_num',index: 'certificate_num',width: 180, sortable: false, align:'center'},
				{label:'电话',name: 'mobile',index: 'mobile',width: 120, sortable: false, align:'center'},
				{label:'籍贯',name: 'native_place',index: 'native_place',width: 150, sortable: false, align:'left'},

				{label:'产品套餐',name: 'remark',index: 'remark',width: 350, sortable: false, align:'left'},
				{label:'业务',name: 'order_mode',index: 'order_mode',width: 80, sortable: false, align:'center',  formatter:'select', formatoptions:{
					value:{ '1374':'长线',1475:'短线', '1476':'签证', '1486':'门票', '1487':'酒店', '1488':'专线', '1489':'包车', '1490':'组团', '1493':'推广', '1555':'石林九乡'}
				}
				},
				{label:'销售',name: 'sale_operator_name',index: 'sale_operator_name',width: 80, sortable: false, align:'center'},
				{label:'计调',name: 'operator_name',index: 'operator_name',width: 80, sortable: false, align:'center'},
				{label:'金额',name: 'total',index: 'total',width: 80, align:'center', formatter:opGrid.formatPerson}
			],
			pager: "#pagerGroupOrder",
			viewrecords: true,
			caption: "",
			jsonReader:{
				id: "group_id",
				root: "result",total: "totalPage",page: "pageBean",records: "totalCount",repeatitems: false
			},
			postData:opGrid.getParam(),
			footerrow: true,
			loadComplete:function(xhr){
				//查询为空的处理方式
				var rowNum = $("#contentGroupOrderTable").jqGrid('getGridParam','records');
				if (rowNum == '0'){
					if($("#norecords").html() == null)
						$("#contentGroupOrderTable").parent().append("</pre><div id='norecords' style='text:center;padding: 8px 8px;'>没有查询记录！</div><pre>");
					$("#norecords").show();
				}else{
					$("#norecords").hide();
				}

			}
		});
	}
}

function searchBtn() {
	$("#contentGroupOrderTable").jqGrid('setGridParam', {page:1, postData: opGrid.getParam()}).trigger("reloadGrid");
}

/* 导出地接单 */
function toPickUpExcel(){
	var curpagenum = $('#contentGroupOrderTable').getGridParam('page');
	$("#page").val(curpagenum);
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var receiveMode=$('#receiveMode').val();
	var groupCode=$('#groupCode').val();
	var supplierName=$('#supplierName').val();

	var orgIds=$('#orgIds').val();
	var orgNames=$('#orgNames').val();
	var operType=$('#operType').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var saleOperatorName=$('#saleOperatorName').val();

	var orderMode=$('#dicIds').val();
	var remark=$('#remark').val();
	var page=$('#page').val();
	var pageSize=$('#pageSize').val();
	var userRightType=$('#userRightType').val();

	var guestName=$('#guestName').val();
	var gender=$('#gender').val()
	var ageFirst=$('#ageFirst').val()
	var ageSecond=$('#ageSecond').val()
	var nativePlace=$('#nativePlace').val()

	window.location ='../taobao/toGroupOrderGuesExport.do?startTime='+startTime
		+"&endTime="+endTime
		+"&receiveMode="+receiveMode
		+"&groupCode="+groupCode
		+"&supplierName="+supplierName
		+"&orgIds="+orgIds
		+"&orgNames="+orgNames
		+"&operType="+operType
		+"&saleOperatorIds="+saleOperatorIds
		+"&saleOperatorName="+saleOperatorName
		+"&orderMode="+orderMode
		+"&remark="+remark
		+"&page="+page
		+"&pageSize="+pageSize
		+"&userRightType="+userRightType
		+"&guestName="+guestName
		+"&gender="+gender
		+"&ageFirst="+ageFirst
		+"&ageSecond="+ageSecond
		+"&nativePlace="+nativePlace;
}
/* 导出保险单 */
function toInsuranceExcel(){
	var curpagenum = $('#contentGroupOrderTable').getGridParam('page');
	$("#page").val(curpagenum);
	var startTime=$('#startTime').val();
	var endTime=$('#endTime').val();
	var receiveMode=$('#receiveMode').val();
	var groupCode=$('#groupCode').val();
	var supplierName=$('#supplierName').val();

	var orgIds=$('#orgIds').val();
	var orgNames=$('#orgNames').val();
	var operType=$('#operType').val();
	var saleOperatorIds=$('#saleOperatorIds').val();
	var saleOperatorName=$('#saleOperatorName').val();

	var orderMode=$('#dicIds').val();
	var remark=$('#remark').val();
	var page=$('#page').val();
	var pageSize=$('#pageSize').val();
	var userRightType=$('#userRightType').val();

	var guestName=$('#guestName').val();
	var gender=$('#gender').val()
	var ageFirst=$('#ageFirst').val()
	var ageSecond=$('#ageSecond').val()
	var nativePlace=$('#nativePlace').val()

	window.location ='../taobao/downloadInsure.htm?startTime='+startTime
		+"&endTime="+endTime
		+"&receiveMode="+receiveMode
		+"&groupCode="+groupCode
		+"&supplierName="+supplierName
		+"&orgIds="+orgIds
		+"&orgNames="+orgNames
		+"&operType="+operType
		+"&saleOperatorIds="+saleOperatorIds
		+"&saleOperatorName="+saleOperatorName
		+"&orderMode="+orderMode
		+"&remark="+remark
		+"&page="+page
		+"&pageSize="+pageSize
		+"&userRightType="+userRightType
		+"&guestName="+guestName
		+"&gender="+gender
		+"&ageFirst="+ageFirst
		+"&ageSecond="+ageSecond
		+"&nativePlace="+nativePlace;
}


/* 导出到Excel */
function toGuestListExcel(){
	var curpagenum = $('#contentGroupOrderTable').getGridParam('page');
	$("#page").val(curpagenum);
	$("#toGuestListExcelId").attr("href","toSaleGuestListExcel.do?startTime="+$("#startTime").val()
		+"&endTime="+$("#endTime").val()
		+"&receiveMode="+$("#receiveMode").val()
		+"&groupCode="+$("#groupCode").val()
		+"&orgIds="+$("#supplierName").val()
		+"&orgIds="+$("#orgIds").val()
		+"&orgNames="+$("#orgNames").val()
		+"&operType="+$("#operType").val()
		+"&saleOperatorIds="+$("#saleOperatorIds").val()
		+"&saleOperatorName="+$("#saleOperatorName").val()
		+"&orderMode="+$("#dicIds").val()
		+"&remark="+$("#remark").val()
		+"&page="+$("#page").val()
		+"&pageSize="+$("#pageSize").val()
		+"&userRightType="+$("#userRightType").val()
		+"&guestName="+$("#guestName").val()
		+"&gender="+$("#gender").val()
		+"&ageFirst="+$("#ageFirst").val()
		+"&ageSecond="+$("#ageSecond").val()
		+"&nativePlace="+$("#nativePlace").val());
}

function commonDicDlg() {
	$.dicItemDlg('SALES_TEAM_TYPE','dicNames','dicIds');
}
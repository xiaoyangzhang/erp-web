//begin 日历事件
function initCalandar() {	
	$("#divLeft").priceCalandar({
		callbackFunc: "processData"
	});
	var currDate = new Date();
	var year = currDate.getFullYear();
	var month = currDate.getMonth() + 1;
	if(month==12){
		month=1;
		year=year+1;
	}else{
		month = month+1;
	}
	$("#divRight").priceCalandar({
		year: year,
		month: month,
		callbackFunc: "processData"
	});

}

function processData(container, year, month) {
	//此处可通过ajax 返回json数据
	//var jsonData = [{
	//	"date": "2015-07-20",
	//	"price1": "1358",
	//	"price2": "1030",
	//	"stock": "10"
	//},{
	//	"date": "2015-08-15",
	//	"price1": "8888起",
	//	"price2": "3000",
	//	"stock": "0"
	//}];
    if(productId != '0'){
        $.ajax({
            type: "post",
            cache: false,
            url: "stock.do",
            data: {
            	productId: productId,
                year : year,
                month : month
            },
            dataType: 'json',
            async: true,
            success: function (data) {
            	if(!data||data.length==0){
            		return;
            	}
                var stockStr = "";
                var stateStr = "可选";
                var cssState = "";
                for (var i = 0; i < data.length; i++) {
                    var item = data[i];
                    var leave = item.stockCount - item.receiveCount;
                    var current = new Date();
                    var itemDate = new Date(item.itemDate);
                    var itemDateStr = formatDate(itemDate.getFullYear(),itemDate.getMonth()+1,itemDate.getDate());
                    
                    stockStr = leave  > 0 ? "余" + leave : "已满";
                    stateStr = leave > 0 ? "可选":"";
                    stockCss = leave > 0 ? "state1" : "state2";
                    var td = $("#" + container + " #calendar_tab").find("td[date='" + itemDateStr + "']");
                    $(td).attr("stockId", item.id).attr("productId", item.productId).attr("leave", leave)
                    	.attr("stock", item.stockCount).attr("receive", item.receiveCount).addClass("on");
                    $(td).find(".stockState").addClass(stockCss).html(stateStr);
                    if(leave > 0){
                        $(td).unbind("click").bind("click", function() {
                            calandarExec(this);
                        });
                    }else{
                        $(td).unbind("click").bind("click", function() {
                            $.warn('该日期已满');
                        });                           
                    }
                    $(td).find(".calendar_price01").html(stockStr);
                }
            }
        });
    }
}

function formatDate(year,month,day){
	return year+ (month<10 ? ("-0"+month):("-"+month)) + (day<10 ? ("-0"+day):("-"+day));
}

function openDownloadLayer(){
    layer.open({
        type: 1,
        title : '附件下载',
        skin: 'layui-layer-rim', //加上边框
        area: ['420px', '240px'], //宽高
        content: $("#download_layer")
    });
}

function calandarExec(td) {
    var _date = $(td).attr("date"),
        //_price1 = $(td).attr("price1"),
        //_price2 = $(td).attr("price2"),
        //priceId = $(td).attr("priceId"),
    	stockId = $(td).attr("stockId"),
        productId = $(td).attr("productId"),
        //groupId = $(td).attr("groupId"),
        _stock = $(td).attr("stock");
    //alert(_date);
    window.location = path + '/fitOrder/toAddGroupOrder.htm?productId=' + productId + '&date='+_date;
    //newWindow("新建散客订单"+_date, path + '/groupOrder/toAddGroupOrder.htm?productId=' + productId + '&groupId=' + groupId + '&priceId=' + priceId);
	}
//end 日历事件
function priceGroupEvent() {
	var maxh=$(".khlist ul").height();
		if ($(".brand p a").text() == "更多客户") {
			$(".brand p a").text("收起列表");
			$(".brand p a").addClass("shouqi");
			$(".khlist").animate({"height":maxh});
		} else {
			$(".brand p a").text("更多客户");
			$(".brand p a").removeClass("shouqi");
			$(".khlist").animate({"height": "65px"});
		}
}

var productId='0';

$(document).ready(function() {

    $(".khlist ul li").click(function(){
        $(this).addClass("bg-y").siblings("li").removeClass("bg-y");
    });
    $('.d_tab').on('click', function(){
        $('.d_content').hide();
        $('.d_tab').removeClass('selected');
        $(this).addClass('selected');
        var id = '#' + $(this).attr('jump-to');
        $(id).show();
    });
	//$("#divContent ul").idTabs();
	$("#divContent ul").autoScroll({
		nav: '.w_remarksNav',
		controll_box: '.rdaycontainer',
		controll_row: '.one'
	}); 
	productId=$("#productId").val();
	//行程天数左侧挂件
    initCalandar();   

	//日历：客户条件过虑
	//document.getElementById('priceGroupMore').onclick = priceGroupEvent;
});
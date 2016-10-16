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

function calandarExec(td) {
    var _date = $(td).attr("date"),
        //_price1 = $(td).attr("price1"),
        //_price2 = $(td).attr("price2"),
        //priceId = $(td).attr("priceId"),
    	stockId = $(td).attr("stockId"),
        productId = $(td).attr("productId"),
        //groupId = $(td).attr("groupId"),
        _stock = $(td).attr("stock");
    //window.location = path + '/fitOrder/toAddGroupOrder.htm?productId=' + productId + '&date=' + _date;
    newWindow("散客预定-新订单",path + '/fitOrder/toAddGroupOrder.htm?productId=' + productId + '&date=' + _date);
    //newWindow("新建散客订单"+_date, path + '/groupOrder/toAddGroupOrder.htm?productId=' + productId + '&groupId=' + groupId + '&priceId=' + priceId);
}

var productId='0';

$(document).ready(function() {
	productId=$("#productId").val();
	//行程天数左侧挂件
    initCalandar();   
	//日历：客户条件过虑
	//document.getElementById('priceGroupMore').onclick = priceGroupEvent;
});
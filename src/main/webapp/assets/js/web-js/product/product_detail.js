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
    if(groupId != '0'){
        $.ajax({
            type: "post",
            cache: false,
            url: path + "/productSales/priceData.do",
            data: {
            	productId: $("#productId").val(),
                groupId: groupId,
                year : year,
                month : month
            },
            dataType: 'json',
            async: true,
            success: function (data) {
            	if(!data||data.length==0){
            		return;
            	}
            	for (var i = 0; i < data.length; i++) {
                	var priceStr = "",
                    	stockStr = "";
                	var cssState = "";
                	var stockCss="";
                	
                    var item = data[i];
                    
                    var stock=true;//库存
                    var price=true;//价格
                    
                    if(!item.stockCount){//无库存
                    	stock = false;
                    }
                    if(!item.priceSuggestAdult){//无价格
                    	price = false;
                    }
                    
                    var leave=null;
                    var yuliu = '';
                    
                    if(stock){
                    	leave = item.stockCount - item.receiveCount - item.reserveCount;
                        var leave3 = item.reserveCount ;
                        yuliu = leave3 ==0? "" : "预" + leave3;
                    }
                    

                    var groupDate = new Date(item.groupDate);
                    if(price){
                    	//priceStr = "成" + item.priceSuggestAdult + "<br/>童" + item.priceSuggestChild;                    	
                    	priceStr = "成" + item.priceSettlementAdult + "<br/>童" + item.priceSettlementChild;
                    }
                    if(stock){
                    	stockStr = leave  > 0 ? "余" + leave + yuliu : "已满";
                    	stockCss = leave > 0 ? "state1" : "state2";                    	
                    }
                    var td = $("#" + container + " #calendar_tab").find("td[date='" + item.groupDate + "']");
                    $(td).attr("productId", item.productId).attr("groupId", item.groupId).attr("priceId", item.priceId)
                    	.attr("price1", item.priceSuggestAdult).attr("price2", item.priceSuggestChild)
                    	.attr("cost1",item.priceCostAdult).attr("cost2",item.priceCostChild)
                    	.attr("settle1",item.priceSettlementAdult).attr('settle2',item.priceSettlementChild)
                    	.attr("stock", leave).addClass("on");
                    $(td).find(".stockState").addClass(stockCss).html(stockStr);
                    if(stock && price){
                    	if(leave>0){
	                        $(td).unbind("click").bind("click", function() {
	                        	calandarExec(this);                        		
	                        });
                    	}else{
                    		$.warn('该日期已满');
                    	}
                    }else{
                        $(td).unbind("click").bind("click", function() {
                        	if(!$(this).attr("stock")){                        		
                        		$.warn('请先设置库存');
                        		return;
                        	}
                        	if(!$(this).attr("price1")){
                        		$.warn('请先设置价格');
                        	}
                        });
                    }

                    $(td).find(".calendar_price01").html(priceStr);
                }
            }
        });
    }

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

var info = {};

function calandarExec(td) {
    var _date = $(td).attr("date"),
        _price1 = $(td).attr("price1"),
        _price2 = $(td).attr("price2"),
        _cost1 = $(td).attr("cost1"),
        _cost2 = $(td).attr("cost2"),
        _settle1 = $(td).attr("settle1");
    	_settle2 = $(td).attr("settle2");
        priceId = $(td).attr("priceId"),
        productId = $(td).attr("productId"),
        groupId = $(td).attr("groupId"),
        _stock = $(td).attr("stock");
    
    //window.location = path + '/groupOrder/toAddGroupOrder.htm?productId=' + productId + '&groupId=' + groupId + '&priceId=' + priceId;    
	//newWindow("新建散客订单"+_date, path + '/groupOrder/toAddGroupOrder.htm?productId=' + productId + '&groupId=' + groupId + '&priceId=' + priceId);
    
   showMode(_date,_price1,_price2,_cost1,_cost2,_settle1,_settle2,priceId,productId,groupId,_stock);
}

function showMode(_date,_price1,_price2,_cost1,_cost2,_settle1,_settle2,priceId,productId,groupId,_stock){
	info = {};	
	info.date = _date;
    info.price1 = _price1;
    info.price2 = _price2;
    info.cost1 = _cost1;
    info.cost2 = _cost2;
    info.settle1 = _settle1;
    info.settle2 = _settle2;
    info.priceId = priceId;
    info.groupId = groupId;
    info.stock = _stock;
	
    if(isReserve==1){//允许预留
    	layer.open({
    		type : 1,
    		title : '下单',
    		shadeClose : true,
    		shade : 0.5,
    		area : [ '300px', '200px' ],
    		content : $('#modeSelect')
    	});
    }else{
    	goOrder(1);
    }
}

function goOrder(type){
	if(info.date){
		newWindow("散客订单", path + '/agencyFit/toAddGroupOrder.htm?type='+type+'&adultPrice='+info.settle1+'&childPrice='+info.settle2+'&adultCost='+info.cost1+'&childCost='+info.cost2+'&productId=' + productId + '&date='+ info.date + '&groupId=' + info.groupId + '&priceId=' + info.priceId);
	}
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

var groupId = '0';
var productId = '0';

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
	}); //行程天数左侧挂件   

    var $supplierName = $('.supplier_name');
    $supplierName.on('click', function(){
		groupId = $(this).attr('group-id');
        initCalandar();
	});
    var supplierName = $supplierName.first();
    if(supplierName.length > 0){
        supplierName.trigger('click');
    }
    
    productId = $("#productId").val();
    if(groupId=='0'){
    	initCalandar();
    }

	//日历：客户条件过虑
	document.getElementById('priceGroupMore').onclick = priceGroupEvent;
});
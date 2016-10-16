var getMonthList = function (year, month) {
    var d = new Date(year, month, 1);
    //var dayNum = (new Date(d.getTime() - 1000 * 60 * 60 * 24)).getDate();
    var dayNum = new Date(year,month,0).getDate();

    var rowStr = '<tr field="tr$Date"><td class="fixed"><input type="checkbox" class="rowChk" /></td>' +
        '<td class="fixed">$Day</td>' +
        '<td field="priceSuggestAdult"></td>' + //
        '<td field="priceSuggestChild"></td>' +
        '<td field="priceSuggestRoomSpread"></td>' +
        '<td field="priceSettlementAdult"></td>' +
        '<td field="priceSettlementChild"></td>' +
        '<td field="priceSettlementRoomeSpread"></td>' +
       /* '<td field="stockCount"></td>' +
        '<td field="receiveCount"></td>' +
        '<td field="isMemeberAllocate"></td>' +
        '<td field="daysRegisterBegin"></td>' +*/
        '<td field="daysRegisterFinish"></td>' +
        '<td field="operations">' +
        '</td>' +
        '</tr>';
    var html = "",
        weekStr = "",
        dayStr = "",
        curDay;
    for (var i = 1; i <= dayNum; i++) {
        curDay = new Date(year, month-1, i);
        dayStr = i < 10 ? '0' + i : i;
        weekStr = ' 周' + '日一二三四五六'.charAt(curDay.getDay());

        html += rowStr.replace('$Day', dayStr + " " + weekStr).replace("$Date", dayStr);
    }
    $(".w_table tr[field*='tr']").remove();
    $(".w_table .trHead").after(html);
}

var setMonthData = function (year, month) {
    $.ajax({
        type: "post",
        cache: false,
        url: path + "/productInfo/price/priceList.do",
        data: {
            groupId: groupId,
            year: year,
            month: month
        },
        dataType: 'json',
        async: false,
        success: function (data) {
            $('.w_table').find('.rowChk').each(function(){
                this.disabled = true;
            });
            for (var i = 0; i < data.length; i++) {
                var item = data[i];

                var $tr = $("tr[field='tr" + item.groupDate.split('-')[2] + "']");
                $tr.find('.rowChk').prop('disabled', false);
                $tr.find("td[field='priceSuggestAdult']").html(item.priceSuggestAdult);
                $tr.find("td[field='priceSuggestChild']").html(item.priceSuggestChild);
                $tr.find("td[field='priceSuggestRoomSpread']").html(item.priceSuggestRoomSpread);
                $tr.find("td[field='priceSettlementAdult']").html(item.priceSettlementAdult);
                $tr.find("td[field='priceSettlementChild']").html(item.priceSettlementChild);
                $tr.find("td[field='priceSettlementRoomeSpread']").html(item.priceSettlementRoomeSpread);
              /*  $tr.find("td[field='stockCount']").html(item.stockCount);
                $tr.find("td[field='receiveCount']").html(item.receiveCount);
                $tr.find("td[field='isMemeberAllocate']").html(item.isMemeberAllocate ? '已分配' : '未分配');
                $tr.find("td[field='daysRegisterBegin']").html(item.daysRegisterBegin ? '提前' + item.daysRegisterBegin + '天' : '-');*/
                $tr.find("td[field='daysRegisterFinish']").html(item.daysRegisterFinish ? '提前' + item.daysRegisterFinish + '天' : '-');
                $tr.find("td[field='operations']").html('<a class="def" href="editprice_list.htm?id=' + item.id + '&groupId=' + item.groupId + '&productId=' + productId + '">修改</a>&nbsp;' +
                    '<a field="id" field-value="' + item.id + '" class="def delete_price_row" href="javascript:void(0)">删除</a>');

                //其它行给值
            }
        },
        error: function (data) {
            $.error('请求失败');
        }
    });
    ////json 定义默认数据
    //var data = [{
    //	"group_date": "2015-07-20",
    //	"price_suggest_adult": "1358",
    //	"price_suggest_child": "1030",
    //	"price_suggest_room_spread": "10",
    //	"price_settlement_adult": 4433,
    //	"price_settlement_child": 2222,
    //	"price_settlement_roome_spread": 500,
    //	"days_register_begin": 2,
    //	"days_register_finish": 1,
    //	"stock_count": 10,
    //	"sale_count": 1,
    //	"is_memeber_allocate": 0
    //}, {
    //	"group_date": "2015-07-25",
    //	"price_suggest_adult": "2222",
    //	"price_suggest_child": "1030",
    //	"price_suggest_room_spread": "10",
    //	"price_settlement_adult": 8888,
    //	"price_settlement_child": 2222,
    //	"price_settlement_roome_spread": 500,
    //	"days_register_begin": 2,
    //	"days_register_finish": 1,
    //	"stock_count": 32,
    //	"sale_count": 10,
    //	"is_memeber_allocate": 1
    //}];

};

function processCalandar(year, month) {
    $(".li_year .year").text(year);
    $('#current_month').html(month + '月');
    $(".priceCalandar_List a").removeClass("on");
    $(".priceCalandar_List a[lang='" + month + "']").attr("class", "on");
    getMonthList(year, month);
    setMonthData(year, month);
    
    $('.delete_price_row').on('click', function(){
        var self = this;
        var id = $(this).attr("field-value");
        $.confirm("确认删除吗？", function () {
            $.ajax({
                type: "post",
                cache: false,
                url: path + "/productInfo/price/del.do",
                data: {
                    id : id
                },
                dataType: 'json',
                async: false,
                success: function (data) {
                    if(data.success){
                        $.success('删除成功');
                        var $tr = $(self).parent().parent();
                        $tr.find('td').filter(function(){
                            return !$(this).hasClass('fixed');
                        }).empty();
                        var $tdInput = $tr.children('td:first').children('input');
                        $tdInput.attr('checked', false);
                        $tdInput.attr('disabled', true);
                    }
                },
                error: function (data) {
                    $.error('请求失败');
                }
            });
        }, function () {

        });
    });
}


$(function () {
    var extraList = [];
    $.ajax({
        type: "post",
        cache: false,
        url: path + "/productInfo/price/extraDic.do",
        dataType: 'json',
        async: false,
        success: function (data) {
            extraList = data;
        },
        error: function (data) {
            $.error('请求失败');
        }
    });

    //全选事件
    $("#tbChk").click(function () {
        var chk = $(this).prop("checked");
        $(".rowChk").filter(function(){
            return !this.disabled;
        }).prop("checked", chk);
    });

    //切换年
    $(".li_year input").click(function () {
        var action = $(this).attr("class");
        var year = $(".li_year label").text();
        var month = $(".priceCalandar_List a[class='on']").text();
        if (action == "left")
            year = parseInt(year) - 1;
        else
            year = parseInt(year) + 1;

        processCalandar(year, month);
    });

    //切换月
    $(".priceCalandar_List a").click(function () {
        var year = $(".li_year label").text();
        var month = $(this).text();
        $('#current_month').html((month + 1) + '月');
        processCalandar(year, month);
    });

    //初始化
    var date = new Date;
    processCalandar(date.getFullYear(), date.getMonth() + 1);


    $('#batch_delete').on('click', function(){

        $.confirm("确认删除吗？", function () {
            var $checked = $('.w_table').find('input[type="checkbox"]:checked');
            var $ids = $checked.parent().siblings('[field="operations"]').children('a[field="id"]');
            var ids = [];
            $ids.each(function(i){
                ids.push($(this).attr('field-value'));
            });
            $.ajax({
                type: "post",
                cache: false,
                url: path + "/productInfo/price/batchDel.do",
                data: {
                    id : ids
                },
                dataType: 'json',
                async: false,
                success: function (data) {
                    if(data.success){
                        $.success('删除成功');
                        var $tr = $checked.parent().parent();
                        $tr.find('td').filter(function(){
                            return !$(this).hasClass('fixed') && $(this).parent().find('#tbChk').length == 0;
                        }).empty();
                        $tr.each(function(){
                            $(this).children('td:first').children('input').attr('checked', false);
                            $(this).children('td:first').children('input').attr('disabled', true);
                        });

                    }
                },
                error: function (data) {
                    $.error('请求失败');
                }
            });
        }, function () {

        });
    });

    $('#addExtra').on('click', function(){
        var win;
        var extraOptions = '';
        for(var i = 0; i < extraList.length; i++){
            extraOptions += ('<option value="' + extraList[i].id + '">' + extraList[i].value + '</option>');
        }
        layer.open({
            type : 1,
            title : '新增项目',
            closeBtn : true,
            area : [ '500px', '300px' ],
            content : '<div class="p_container_sub">' +
            '<form id="saveProdectInfoForm"><dl class="p_paragraph_content"><dd>' +
            '<div class="dd_left">项目</div><div class="dd_right">' +
            '<select name="itemId">' + extraOptions + '</select>' +
            '</div><div class="clear"></div></dd><dd>' +
            '<div class="dd_left">备注</div><div class="dd_right"><textarea name="remark" ></textarea></div>' +
            '<div class="clear"></div>' +
            '</dd><dd><div class="dd_left">售价</div><div class="dd_right"><input type="text" name="priceSale" placeholder="输入售价，单位：元" /></div>' +
            '<div class="clear"></div>' +
            '</dd><dd><div class="dd_left">成本价</div><div class="dd_right"><input type="text" name="priceCost" placeholder="输入价格，单位：元" /></div>' +
            '<div class="clear"></div>' +
            '</dl></form></div>',
            btn: ['确定', '取消'],
            success:function(layero, index){
                win = layero;
            },
            yes: function(index){
                var $content = $(win);
                var itemId = $content.find("select[name='itemId']").val();
                var itemName = $content.find("select[name='itemId']").find("option:selected").text();
                var remark = $content.find("textarea[name='remark']").val();
                var priceSale = $content.find("input[name='priceSale']").val();
                var priceCost = $content.find("input[name='priceCost']").val();
                var $table = $('#extra_table');
                var length = $table.children('tr').length;
                var data = {itemId : itemId, itemName : itemName, remark : remark, priceSale : priceSale, priceCost : priceCost};
                var success = true;
                var reg1 =  /^\d+$/;
                if(priceSale.match(reg1) == null || priceSale.length > 11){
                    $content.find("input[name='priceSale']").parent().append('请输入数字');
                    success = false;
                }
                if(priceCost.match(reg1) == null || priceCost.length > 11){
                    $content.find("input[name='priceCost']").parent().append('请输入数字');
                    success = false;
                }
                if(remark.length > 300){
                    $content.find("textarea[name='remark']").parent().append('不能大于300字');
                    success = false;
                }
                if(!success){
                    return false;
                }

                $.ajax({
                    type: "post",
                    cache: false,
                    url: path + "/productInfo/price/extra/save.do",
                    data: {
                        groupId : groupId,
                        data : JSON.stringify(data)
                    },
                    dataType: 'json',
                    async: false,
                    success: function (data) {
                        $table.append('<tr><td>' + (length + 1) + '</td>' +
                            '<td>' + data.itemName + '</td>' +
                            '<td>' + data.remark + '</td>' +
                            '<td>' + data.priceSale + '</td>' +
                            '<td>' + data.priceCost + '</td>' +
                            '<td><a id-value="' + data.id + '" class="mr-10 blue extra_edit" href="javascript:void(0)">修改</a><a id-value="' + data.id + '" class="mr-10 blue extra_delete" href="javascript:void(0)">删除</a></td></tr>');
                        $.success('新增成功');
                    },
                    error: function (data) {
                        $.error('请求失败');
                    }
                });


                layer.close(index);
            },
            no: function(index){
                layer.close(index);
            },
            cancel: function(index){
                layer.close(index);
            }
        });

    });

    $('#extra_table').delegate('.extra_edit', 'click', function(){
        var self = this;
        var id = $(self).attr('id-value');
        var $tr = $(self).parent().parent();
        $.ajax({
            type: "post",
            cache: false,
            url: path + "/productInfo/price/extra/view.do",
            data: {
                id : id
            },
            dataType: 'json',
            async: false,
            success: function (data) {

                var win;
                var extraOptions = '';
                for(var i = 0; i < extraList.length; i++){
                    if(data.itemId !== extraList[i].id){
                        extraOptions += ('<option value="' + extraList[i].id + '">' + extraList[i].value + '</option>');
                    }else{
                        extraOptions += ('<option value="' + extraList[i].id + '" selected>' + extraList[i].value + '</option>');
                    }

                }
                layer.open({
                    type : 1,
                    title : '修改项目',
                    closeBtn : true,
                    area : [ '500px', '300px' ],
                    content : '<div class="p_container_sub">' +
                    '<form id="saveProdectInfoForm"><dl class="p_paragraph_content"><dd>' +
                    '<div class="dd_left">项目</div><div class="dd_right">' +
                    '<select name="itemId">' + extraOptions + '</select>' +
                    '</div><div class="clear"></div></dd><dd>' +
                    '<div class="dd_left">备注</div><div class="dd_right"><textarea name="remark" >' + data.remark + '</textarea></div>' +
                    '<div class="clear"></div>' +
                    '</dd><dd><div class="dd_left">单价</div><div class="dd_right"><input type="text" name="priceSale" placeholder="输入价格，单位：元" value="' + data.priceSale + '" /></div>' +
                    '<div class="clear"></div>' +
                    '</dd><dd><div class="dd_left">成本价</div><div class="dd_right"><input type="text" name="priceCost" placeholder="输入价格，单位：元" value="' + data.priceCost + '" /></div>' +
                    '<div class="clear"></div>' +
                    '</dl></form></div>',
                    btn: ['确定', '取消'],
                    success:function(layero, index){
                        win = layero;
                    },
                    yes: function(index){
                        var $content = $(win);
                        var itemId = $content.find("select[name='itemId']").val();
                        var itemName = $content.find("select[name='itemId']").find("option:selected").text();
                        var remark = $content.find("textarea[name='remark']").val();
                        var priceSale = $content.find("input[name='priceSale']").val();
                        var priceCost = $content.find("input[name='priceCost']").val();
                        var data = {id : id, itemId : itemId, itemName : itemName, remark : remark, priceSale : priceSale, priceCost : priceCost};
                        var reg1 =  /^\d+$/;
                        var success = true;
                        if(priceSale.match(reg1) == null || priceSale.length > 11){
                            $content.find("input[name='priceSale']").parent().append('请输入数字');
                            success = false;
                        }
                        if(priceCost.match(reg1) == null || priceCost.length > 11){
                            $content.find("input[name='priceCost']").parent().append('请输入数字');
                            success = false;
                        }
                        if(remark.length > 300){
                            $content.find("textarea[name='remark']").parent().append('不能大于300字');
                            success = false;
                        }
                        if(!success){
                            return false;
                        }

                        $.ajax({
                            type: "post",
                            cache: false,
                            url: path + "/productInfo/price/extra/edit.do",
                            data: {
                                groupId : groupId,
                                data : JSON.stringify(data)
                            },
                            dataType: 'json',
                            async: false,
                            success: function (data) {
                                $tr.find('td').each(function(i){
                                    switch (i)
                                    {
                                        case 0:
                                            break;
                                        case 1:
                                            $(this).html(data.itemName);
                                            break;
                                        case 2:
                                            $(this).html(data.remark);
                                            break;
                                        case 3:
                                            $(this).html(data.priceSale);
                                            break;
                                        case 4:
                                            $(this).html(data.priceCost);
                                            break;
                                    }
                                });
                                $.success('修改成功');
                            },
                            error: function (data) {
                                $.error('请求失败');
                            }
                        });


                        layer.close(index);
                    },
                    no: function(index){
                        layer.close(index);
                    },
                    cancel: function(index){
                        layer.close(index);
                    }
                });
            },
            error: function (data) {
                $.error('请求失败');
            }
        });

    });

    $('#extra_table').delegate('.extra_delete', 'click', function(){
        var self = this;
        var id = $(self).attr('id-value');
        var $tr = $(self).parent().parent();
        $.confirm("确认删除吗？", function () {

            $.ajax({
                type: "post",
                cache: false,
                url: path + "/productInfo/price/extra/del.do",
                data: {
                    id : id
                },
                dataType: 'json',
                async: false,
                success: function (data) {
                    if(data.success){
                        $tr.remove();
                        $.success('删除成功');
                        var $tds = $('#extra_table').find('tr td:first-child');
                        $tds.each(function(i){
                            $(this).html(i + 1);
                        });
                    }else{
                        $.error('操作失败');
                    }
                },
                error: function (data) {
                    $.error('请求失败');
                }
            });
        }, function () {

        });
    });
});
        
        
 		

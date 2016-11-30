/**
 * Created by ZhengZiyu on 2015/6/15.
 */
$(function(){
    $('#contractForm').validate({
        errorElement: 'label',
        errorClass: 'error',
        focusInvalid: true,
        rules : {
            'supplierContract.contractName' : {
                rangelength:[1, 100],
                required : true
            },
            'supplierContract.startDate' : {
                required : true
            },
            'supplierContract.endDate' : {
                required : true
            },
            'supplierContract.signDate' : {
                required : true
            },
            'supplierContract.datePriority' : {
                rangelength:[0, 11],
                isNum : true
            },
            'supplierContract.settlementDays' : {
                rangelength:[0, 11],
                isNum : true
            },
            'supplierContract.settlementDesp' : {
                rangelength:[0, 20]
            },
            'supplierContract.exceedDays' : {
                rangelength:[0, 11],
                isNum : true
            },
            'supplierContract.maxDebt' : {
                rangelength:[0, 10],
                checkIntAndNum : true
            },
            'supplierContract.exceedAmount' : {
                rangelength:[0, 10],
                checkIntAndNum : true
            },
            'supplierContract.billDemand' : {
                rangelength:[0, 2000]
            },
            'supplierContract.rebatePolicy' : {
                rangelength:[0, 2000]
            },
            'supplierContract.note' : {
                rangelength:[0, 2000]
            }
        },
        messages: {
            'supplierContract.contractName' : {
                required : "请输入合同名称"
            },
            'supplierContract.startDate' : {
                required : "请输入开始日期"
            },
            'supplierContract.endDate' : {
                required : "请输入结束日期"
            }
        },
        //errorPlacement : function(error, element) { // 指定错误信息位置
        //
        //    if (element.is(':radio') || element.is(':checkbox')
        //        || element.is(':input')) { // 如果是radio或checkbox
        //        var eid = element.attr('name'); // 获取元素的name属性
        //        error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
        //    } else {
        //        error.insertAfter(element);
        //    }
        //},
        submitHandler: function (form) {
            $(form).ajaxSubmit({
                type : "post",
                cache : false,
                url : path + "/contract/add.do",
                dataType : 'json',
                async : false,
                success : function(data) {
                    if (data.success) {
                        $.success('操作成功', function(){
                            if(!supplierId){
                                refreshWindow("修改协议", path + '/contract/' + data["contractId"] + '/fleet-edit.htm');
                            }else{
                                refreshWindow("修改协议", path + '/contract/' + supplierId + '/' + data["contractId"] + '/edit.htm');
                            }

                        });

                        //top.topManager.closePage('add_contract');
                        //top.topManager.reloadPage('contract');
                    } else {
                        $.error('操作失败');
                        //BUI.Message.Alert('操作失败', 'error');
                    }
                },
                error : function(data) {
                    $.error('请求失败');
                    //BUI.Message.Alert('', 'error');
                }
            });
        },
        success: function (e) {

        }
    });
});
/**
 * 添加行
 * @param elementId
 * @param templateId
 */
var addPriceInfoRow = function(elementId, templateId){
    var html = $('#' + templateId).find('table').find('tbody').html();
    var count = $('#' + elementId).children('tr').length;


    html = html.replace(/\$index/g, count);
    $('#' + elementId).append(html);
    var itemType = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.itemType");
    if(itemType.length > 0){
        itemType.rules("add",{required : true});
    }
    var itemTypeName = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.itemTypeName");
    if(itemTypeName.length > 0){
        itemTypeName.rules("add",{required : true});
    }
    var itemType2 = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.itemType2");
    if(itemType2.length > 0){
        itemType2.rules("add",{required : true});
    }
    var itemType2Name = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.itemType2Name");
    if(itemType2Name.length > 0){
        itemType2Name.rules("add",{required : true});
    }
    //var contractPrice = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.contractPrice");
    //if(contractPrice.length > 0){
    //    contractPrice.rules("add",{required : true});
    //}
    var derateReach = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.derateReach");
    if(derateReach.length > 0){
        derateReach.rules("add",{rangelength : [0,10], checkIntAndNum : true});
    }
    var derateReduction = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.derateReduction");
    if(derateReduction.length > 0){
        derateReduction.rules("add",{rangelength : [0,10], checkIntAndNum : true});
    }
    var note = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.note");
    if(note.length > 0){
        note.rules("add",{rangelength : [0,2000]});
    }
    var rebateMethod = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.rebateMethod");
    if(rebateMethod.length > 0){
        rebateMethod.rules("add",{required : true});
    }
    var rebateAmount = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.rebateAmount");
    if(rebateAmount.length > 0){
        rebateAmount.rules("add",{rangelength : [0,10], checkIntAndNum : true});
    }
    var rebateAmountPercent = $("#priceVoList\\[" + count + "\\]\\.supplierContractPrice\\.rebateAmountPercent");
    if(rebateAmountPercent.length > 0){
        rebateAmountPercent.rules("add",{rangelength : [0,10], checkIntAndNum : true});
    }

};

/**
 * 添加二级行
 * @param findex
 * @param elementId
 * @param templateId
 */
var addSecLevelPriceInfoRow = function(findex, elementId, templateId){
    var html = $('#' + templateId).find('table').find('tbody').html();
    var count = $('#' + elementId).children('tr').length;
    html = html.replace(/\$index/g, findex);
    html = html.replace(/\$secLevel/g, count);
    $('#' + elementId).append(html);
    var brandId = $("#priceVoList\\[" + findex + "\\]\\.priceExtVoList\\[" + count + "\\]\\.supplierContractPriceExt\\.brandId");
    if(brandId.length > 0){
        brandId.rules("add",{required : true});
    }
    var brandName = $("#priceVoList\\[" + findex + "\\]\\.priceExtVoList\\[" + count + "\\]\\.supplierContractPriceExt\\.brandName");
    if(brandName.length > 0){
        brandName.rules("add",{required : true});
    }
    var price = $("#priceVoList\\[" + findex + "\\]\\.priceExtVoList\\[" + count + "\\]\\.supplierContractPriceExt\\.price");
    if(price.length > 0){
        price.rules("add",{rangelength : [0,10], checkIntAndNum : true});
    }
};

/**
 * 删除tr元素
 * @param el
 */
var deletePrice = function(el){
    var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='priceVoList']");
        //var current = founds.attr('id').replace(/priceVoList\[\d+]/g, 'priceVoList[' + index + ']');
        //$(founds).attr('id', current);
        //$(founds).attr('name', current);
        founds.each(function(){
            $(this).attr('id', $(this).attr('id').replace(/priceVoList\[\d+]/g, 'priceVoList[' + index + ']'));
            $(this).attr('name', $(this).attr('name').replace(/priceVoList\[\d+]/g, 'priceVoList[' + index + ']'));
        });
    });
};

/**
 * 删除二级元素
 * @param el
 * @param findex
 */
var deleteSecondLevelPrice = function(el, findex){
    var p = $(el).parent('td').parent('tr');
    var siblings = p.siblings();
    p.remove();
    siblings.each(function(index, element){
        var founds = $(element).find("[name^='priceVoList[" + findex + "].priceExtVoList']");
        //console.log(founds);
        //var current = founds.attr('id').replace(/priceVoList\[\d+].priceExtVoList\[\d+]/g, 'priceVoList[' + findex + '].priceExtVoList[' + index + ']');
        //console.log(current);
        //$(founds).attr('id', current);
        //$(founds).attr('name', current);
        founds.each(function(){
            $(this).attr('id', $(this).attr('id').replace(/priceVoList\[\d+].priceExtVoList\[\d+]/g, 'priceVoList[' + findex + '].priceExtVoList[' + index + ']'));
            $(this).attr('name', $(this).attr('name').replace(/priceVoList\[\d+].priceExtVoList\[\d+]/g, 'priceVoList[' + findex + '].priceExtVoList[' + index + ']'));
        });
    });
};

function selectAttachment(el){
    layer.openImgSelectLayer({
        callback: function(arr){
            var addhtml="";
            var html1 = $('#imgTemp').html();
            var imgsLength = $(el).prev('.addImg').children().length;
            for(var i=0;i<arr.length;i++){
                addhtml= addhtml +  html1.replace(/\$index/g, imgsLength + i).replace(/\$src/g, arr[i].thumb).replace(/\$name/g, arr[i].name).replace(/\$path/g, arr[i].path);
            }
            $(el).prev('.addImg').append(addhtml);
        }
    });
}
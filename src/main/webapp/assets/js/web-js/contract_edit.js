/**
 * Created by ZhengZiyu on 2015/6/19.
 */
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
//            
//            'settlementMethodList' : {
//                required : true
//            },
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
        submitHandler: function (form) {
            $(form).ajaxSubmit({
                type : "post",
                cache : false,
                url : path + "/contract/edit.do",
                dataType : 'json',
                async : false,
                success : function(data) {
                    if (data.success == true) {
                        $.success('操作成功11',function(){
                        	location.reload();
                        });
                        //BUI.Message.Alert('', 'success');
                        //top.topManager.reloadPage('edit_contract');
                        //top.topManager.reloadPage('view_contract_list');
                    } else {
                        $.error('操作失败');
                        //BUI.Message.Alert('', 'error');
                    }
                },
                error : function(data) {
                    $.error('请求失败');
                    //BUI.Message.Alert('请求失败', 'error');
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
    var salePrice = $("#priceVoList\\[" + findex + "\\]\\.priceExtVoList\\[" + count + "\\]\\.supplierContractPriceExt\\.salePrice");
    if(salePrice.length > 0){
    	salePrice.rules("add",{rangelength : [0,10], checkIntAndNum : true});
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
var deleteSecondLevelPrice = function(el, findex, extPriceId){
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
    if(extPriceId !='' && extPriceId != '0'){
    	delPriceExtRow(extPriceId);
    }
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

function delPriceExtRow(extId){
	$.ajax({
		type:"post",
		url:path+"/contract/delPriceExtRow.do",
		data:{priceExtId:extId},
		dataType:"json",
		success:function(data){
			if (data.success == true) {
            	$.success("删除成功",function(){
            		location.reload();
            	});
            }else{
				$.error("删除失败");
			}
		},
		error:function(data,msg){
			$.error("删除失败" + msg);
		}
	});
}
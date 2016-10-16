/**
 * Created by ZhengZiyu on 2015/8/19.
 */
function getContextPath() {
    /*var obj = window.location;
    var contextPath = obj.pathname.split("/")[1];
    return obj.protocol + "//" + obj.host + "/" + contextPath;*/
	return ctx;
}
if(layer){
    layer.openSupplierLayer = function(config){
        var win;
        var defaultConfig = {
            type : 2,
            title : '选择供应商',
            area : [{minHeight : '768px', areas : ['900px', '610px']}, {maxHeight : '768px', areas : ['600px', '450px']}],
            shadeClose : false,
            content : getContextPath() + '/component/supplierList.htm?type=multi',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
            btn: ['确定', '取消'],
            success:function(layero, index){
                win = window[layero.find('iframe')[0]['name']];
            },
            yes: function(index){
                var arr = win.getChkedSupplier();
                config.callback(arr);
                layer.close(index);
            },
            cancel : function(index){
                layer.close(index);
            }
        };
        if(config){
            for(var pro in config){
                defaultConfig[pro] = config[pro];
            }
            layer.open(defaultConfig);

        }
    };

    layer.openImgSelectLayer = function(config){
        var win;
        var defaultConfig = {
            type : 2,
            title : '选择图片/文件',
            area : [{minHeight : '768px', areas : ['980px', '620px']}, {maxHeight : '768px', areas : ['600px', '450px']}],
            shadeClose : false,
            content : getContextPath() + '/component/imgSelect.htm',
            btn: ['确定', '取消'],
            success:function(layero, index){
                win = window[layero.find('iframe')[0]['name']];
            },
            yes: function(index){
                var arr = win.getImgSelected();
                if(arr.length==0){
                    $.warn("请选择图片");
                    return false;
                }
                config.callback(arr);
                layer.close(index);
            },
            cancel : function(index){
                layer.close(index);
            }
        };
        if(config){
            for(var pro in config){
                defaultConfig[pro] = config[pro];
            }
            layer.open(defaultConfig);

        }
    };
}

/**
 * Product route module
 * @param dataConstruct
 * @constructor
 */
var ProductRoute = function ProductRoute(dataConstruct){

    var self = this;

    var $content = $(".day_content");
    self.$content = $content;

    if(typeof dataConstruct == 'function'){
        dataConstruct.call(this);
    }

    //行程天数添加事件
    $(".proAdd_btn").on('click', function(){
        self.dayAdd();
        /**
         * 早中晚餐自动补全“√”和“×”
         */
        $(".bldd").each(function(){
    		$(this).autocomplete({
    			  source: function( request, response ) {
    				  var name=encodeURIComponent(request.term);
    				  $.ajax({
    					  type : "post",
    					  url : getContextPath()+"/route/getNameList.do",
    					  data : {
    						  name : name
    					  },
    					  dataType : "json",
    					  success : function(data){
    						  if(data && data.success == 'true'){
    							  response($.map(data.result,function(v){
    								  return {
    									  label : v.name,
    									  value : v.name
    								  }
    							  }));
    						  }
    					  },
    					  error : function(data,msg){
    					  }
    				  });
    			  },
    			  focus: function(event, ui) {
    				    $(".adress_input_box li.result").removeClass("selected");
    				    $("#ui-active-menuitem")
    				        .closest("li")
    				        .addClass("selected");
    				},
    			  minLength : 0,
    			  autoFocus : true,
    			  delay : 300
    		});
    	});
    });

    //行程天数删除事件
    $content.delegate('.day_num', 'mouseenter', function(){
        $(this).find(".day_delete").show();
    });
    $content.delegate('.day_num', 'mouseleave', function(){
        $(this).find(".day_delete").hide();
    });
    $content.delegate('.day_delete', 'click', function(){
        var $template = $('#day_template');
        var nameRegex = $template.attr('name-regex');
        var nameResult = $template.attr('name-result');
        var regex = eval('/' + nameRegex + '/g');
        $(this).parents("tr").remove();
        $content.children('tr').each(function(i){
            $(this).find('.day_sequence').html('第' + (i + 1) + '天');
            $(this).find("input[name$='dayNum']").val(i + 1);
            var founds = $(this).find('input,textarea');
            founds.each(function(){
                if($(this).attr('name')){
                    $(this).attr('name', $(this).attr('name').replace(regex, nameResult.replace('\$param', i)));
                }
            });
        });
    });

    //交通添加事件
    $content.delegate('.traffic_select', 'click', function(){
        self.trafficAddEvent(this);
    });

    //交通删除事件
    $content.delegate('.traffic_span', 'mouseenter', function(){
        $(this).find(".traffic_delete").show();
    });
    $content.delegate('.traffic_span', 'mouseleave', function(){
        $(this).find(".traffic_delete").hide();
    });
    $content.delegate('.traffic_delete', 'click', function(){
        var $template = $('#traffic_template');
        var nameRegex = $template.attr('name-regex');
        var nameResult = $template.attr('name-result');
        var regex = eval('/' + nameRegex + '/g');
        var siblings = $(this).closest('.traffic_span').siblings();
        $(this).closest('.traffic_span').remove();
        siblings.each(function(index){
            var founds = $(this).find('input');
            founds.each(function(){
                if($(this).attr('name')){
                    $(this).attr('name', $(this).attr('name').replace(regex, nameResult.replace('\$param', index)));
                }
            });

        });
    });

    //商家添加事件
    $content.delegate('.supplier_select', 'click', function(){
        self.supplierAddEvent(this);
    });

    //商家删除事件
    $content.delegate('.supplier_span', 'mouseenter', function(){
        $(this).find(".supplier_delete").show();
    });
    $content.delegate('.supplier_span', 'mouseleave', function(){
        $(this).find(".supplier_delete").hide();
    });
    $content.delegate('.supplier_delete', 'click', function(){
        var $template = $('#supplier_template');
        var nameRegex = $template.attr('name-regex');
        var nameResult = $template.attr('name-result');
        var regex = eval('/' + nameRegex + '/g');
        var siblings = $(this).closest('.supplier_span').siblings();
        $(this).closest('.supplier_span').remove();
        siblings.each(function(index){
            var founds = $(this).find('input');
            founds.each(function(){
                if($(this).attr('name')){
                    $(this).attr('name', $(this).attr('name').replace(regex, nameResult.replace('\$param', index)));
                }
            });

        });
    });

    //上传图片添加事件
    $content.delegate('.img_select', 'click', function(){
        self.imgAddEvent(this);
    });

    //上传图片删除事件
    $content.delegate('.img_span', 'mouseenter', function(){
        $(this).find(".img_delete").show();
    });
    $content.delegate('.img_span', 'mouseleave', function(){
        $(this).find(".img_delete").hide();
    });

    $content.delegate('.img_delete', 'click', function(){
        var $template = $('#img_template');
        var nameRegex = $template.attr('name-regex');
        var nameResult = $template.attr('name-result');
        var regex = eval('/' + nameRegex + '/g');
        var siblings = $(this).closest('.img_span').siblings();
        $(this).closest('.img_span').remove();
        siblings.each(function(index){
            var founds = $(this).children('input');
            founds.each(function(){
                if($(this).attr('name')){
                    $(this).attr('name', $(this).attr('name').replace(regex, nameResult.replace('\$param', index)));
                }
            });

        });
    });

};


ProductRoute.prototype.dayAdd = function(data){
    var count = this.$content.children('tr').length + 1;
    var html;
    if(!data){
        html = template('day_template', {dayNum : count});
        this.$content.append(html);
    }else{
        html = template('day_template', {dayNum : count, routeShort : data.routeShort, routeDesp : data.routeDesp,
            routeTip : data.routeTip, breakfast : data.breakfast, lunch : data.lunch, supper : data.supper, hotelName : data.hotelName});
        this.$content.append(html);
    }
};

ProductRoute.prototype.trafficAdd = function(dayIndex, trafficIndex, data){
    //{dayNum : dayIndex, trafficImgPath : typePath, cityDeparture : cityDeparture, cityArrival : cityArrival, trafficContent : middle,
    //    typeId : typeId, typeName : typeName, miles : miles, duration : duration, trafficIndex : trafficIndex}
    var typeId = data.typeId;
    var typePath = '';
    if(typeId == 1){//飞机
        typePath = path + '/assets/img/plane.png';
    }
    else if(typeId == 2){//火车
        typePath = path + '/assets/img/train.png';
    }
    else if(typeId == 3){//汽车
        typePath = path + '/assets/img/bus.png';
    }
    else if(typeId == 4){//轮船
        typePath = path + '/assets/img/ship.png';
    }
    var middle = '';
    if(data.miles && data.duration){
        middle = '(' + data.miles + 'km,' + data.duration + 'h' + ')';
    }else if(!data.miles && data.duration){
        middle = '(' + data.duration + 'h' + ')';
    }else if(!data.duration && data.miles){
        middle = '(' + data.miles + 'km' + ')';
    }else{
        middle = '';
    }
    var text = template('traffic_template', {dayNum : dayIndex, trafficImgPath : typePath,
        cityDeparture : data.cityDeparture, cityArrival : data.cityArrival, trafficContent : middle,
        typeId : data.typeId, typeName : data.typeName, miles : data.miles, duration : data.duration, trafficIndex : trafficIndex});
    $('#tr_day_' + dayIndex + ' .traffic_details').append(text);
};

ProductRoute.prototype.supplierAdd = function(dayIndex, supplierIndex, data){
    //{dayNum : dayIndex, supplierIndex : supplierIndex + i,
    //    supplierId : arr[i].id, supplierType : arr[i].type, supplierName : arr[i].name, supplierTypeName : arr[i].typename}
    var text = template('supplier_template', {dayNum : dayIndex, supplierIndex : supplierIndex,
        supplierId : data.supplierId, supplierType : data.supplierType, supplierName : data.supplierName, supplierTypeName : data.supplierTypeName});
    $('#tr_day_' + dayIndex + ' .supplier_details').append(text);
};

ProductRoute.prototype.imgAdd = function(dayIndex, imgIndex, data){
    //{dayNum : dayIndex, imgIndex : imgIndex + i, imgSrc : arr[i].thumb, imgName : arr[i].name, imgPath : arr[i].path}
    var text = template('img_template', {dayNum : dayIndex, imgIndex : imgIndex, imgSrc : data.thumb, imgName : data.name, imgPath : data.path});
    $('#tr_day_' + dayIndex + ' .img_details').append(text);
};

ProductRoute.prototype.trafficAddEvent = function(el){
    var self = this;
    var win;
    var dayIndex = $(el).closest('tr').attr('id').substring(7);
    var trafficIndex = $(el).closest('td').find('.traffic_details').children('span').length;
    layer.open({
        type : 1,
        title : '编辑交通信息',
        //area : [ '500px', '300px' ],
        area : [{minLength : '1100px', areas : ['500px', '300px']}, {maxLength : '1100px', areas : ['280px', '300px']}],
        content : '<div class="p_container_sub">' +
        '<form id="saveProdectInfoForm"><dl class="p_paragraph_content"><dd>' +
        '<div class="dd_left">交通方式</div><div class="dd_right">' +
        '<select name="typeId"><option value="1">飞机</option><option value="2">火车</option><option value="3">汽车</option><option value="4">轮船</option></select>' +
        '</div><div class="clear"></div></dd><dd>' +
        '<div class="dd_left">出发城市</div><div class="dd_right"><input type="text" name="cityDeparture" /></div>' +
        '<div class="clear"></div></dd><dd><div class="dd_left">到达城市</div><div class="dd_right"><input type="text" name="cityArrival" /></div>' +
        '<div class="clear"></div></dd><dd><div class="dd_left">大概里程</div><div class="dd_right"><input type="text" name="miles" /> 千米</div>' +
        '<div class="clear"></div><div class="dd_left">大概时间</div><div class="dd_right"><input type="text" name="duration" /> 小时</div>' +
        '<div class="clear"></div></dd></dl></form></div>',
        btn: ['确定', '取消'],
        success:function(layero, index){
            win = layero;
        },
        yes: function(index){
            var $content = $(win);
            var typeId = $content.find("select[name='typeId']").val();
            var typeName = $content.find("select[name='typeId']").find("option:selected").text();
            var cityDeparture = $content.find("input[name='cityDeparture']").val();
            var cityArrival = $content.find("input[name='cityArrival']").val();
            var miles = $content.find("input[name='miles']").val();
            var duration = $content.find("input[name='duration']").val();
            self.trafficAdd(dayIndex, trafficIndex, {cityDeparture : cityDeparture, cityArrival : cityArrival,
                typeId : typeId, typeName : typeName, miles : miles, duration : duration});
            layer.close(index);
        },
        no: function(index){
            layer.close(index);
        },
        cancel: function(index){
            layer.close(index);
        }
    });
};

ProductRoute.prototype.supplierAddEvent = function(el){
    var self = this;
    var dayIndex = $(el).closest('tr').attr('id').substring(7);
    var supplierIndex = $(el).closest('td').find('.supplier_details').children('p').length;
    layer.openSupplierLayer({
        title : '选择商家',
        content : getContextPath() + '/component/supplierList.htm?type=multi&stypes=3,5',
        callback: function(arr){
            if(arr.length==0){
                $.warn("请选择供应商");
                return false;
            }

            for(var i=0;i<arr.length;i++){
                //重复验证
                var hs = false;
                var $ids = $(el).closest('td').find('.supplier_details').find('input[name*="supplierId"]');
                $ids.each(function(){
                    if($(this).val() == arr[i].id){
                        hs = true;
                    }
                });
                if(!hs){
                    self.supplierAdd(dayIndex, supplierIndex + i, {supplierId : arr[i].id, supplierType : arr[i].type, supplierName : arr[i].name, supplierTypeName : arr[i].typename});
                }
            }
        }
    });
};

ProductRoute.prototype.imgAddEvent = function(el){
    var self = this;
    var dayIndex = $(el).closest('tr').attr('id').substring(7);
    var imgIndex = $(el).closest('td').find('.img_details').children('span').length;

    layer.openImgSelectLayer({
        callback: function(arr){
            for(var i=0;i<arr.length;i++){
                self.imgAdd(dayIndex, imgIndex + i, {thumb : arr[i].thumb, name : arr[i].name, path : arr[i].path});
            }
        }
    });
};


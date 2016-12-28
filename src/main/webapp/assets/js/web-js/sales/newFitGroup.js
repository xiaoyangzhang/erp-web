$(function(){
	$("select[name='tourGroup.prudctBrandId']").change(function() {
		$("input[name='tourGroup.productBrandName']").val($("select[name='tourGroup.prudctBrandId'] option:selected").text());
	});
	//接
	loadRoute();
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	complete();
})
function delGroupOrder(id){
		$.confirm("确认删除吗？成功后将会刷新页面！", function() {
			$.getJSON("../fitGroup/delFitOrder.do?id=" + id, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						window.location = window.location;
					});
				}
			});
		}, function() {
			$.info('取消删除');
		})

		
	}
function loadRoute(){
	
	 $.ajax({
	        type: "post",
	        cache: false,
	        url : "../groupRoute/getData.do",
	        data : {
	            groupId : $("input[name='tourGroup.id']").val()
	        },
	        dataType: 'json',
	        async: false,
	        success: function (data) {
	            new SalesRoute(function(){
	                var days = data.groupRouteDayVOList;
	                for(var i = 1; i <= days.length; i++){
	                    var dayVo = days[i - 1];
	                    this.dayAdd(dayVo.groupRoute);
	                    var trafficList = dayVo.groupRouteTrafficList;
	                    for(var j = 0; j < trafficList.length; j++){
	                        this.trafficAdd(i, j, trafficList[j]);
	                    }
	                    var optionsSupplierList = dayVo.groupRouteOptionsSupplierList;
	                    for(var k = 0; k < optionsSupplierList.length; k++){
	                        this.supplierAdd(i, k, optionsSupplierList[k])
	                    }
	                    var imgList = dayVo.groupRouteAttachmentList;
	                    for(var l = 0; l < imgList.length; l++){
	                        imgList[l].thumb = img200Url + imgList[l].path;
	                        this.imgAdd(i, l, imgList[l])
	                    }
	                }
	            });
	        }
	    });
}

function printOrder(orderId){
	$("#saleOrder").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+1) ; //确认单
	$("#saleOrderNoRoute").attr("href","../tourGroup/toPreview.htm?orderId="+orderId+"&num="+4) ; //确认单-无行程
	$("#saleCharge").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+2) ;
	$("#saleChargeNoRoute").attr("href","../tourGroup/toSaleCharge.htm?orderId="+orderId+"&num="+5) ;
	layer.open({
		type : 1,
		title : '打印订单',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '210px' ],
		content : $('#exportWord')
	});
};
function printInfo(){
	layer.open({
		type : 1,
		title : '打印信息',
		shadeClose : true,
		shade : 0.5,
		area : [ '350px', '500px' ],
		content : $('#exportInfo')
	});
};
function showGuideList(obj){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $(obj).trigger(e);
	}
function complete(){
	$(".bldd").each(function(){
		$(this).autocomplete({
			  source: function( request, response ) {
				  var name=encodeURIComponent(request.term);
				  $.ajax({
					  type : "get",
					  url : "../route/getNameList.do",
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
}
function selectUser(){
	var win;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ '400px', '500px' ],
		shadeClose : true,
		content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();    				
			if(userArr.length==0){
				$.error('请选择人员') ;
				return false;
			}
			$("#operatorId").val(userArr[0].id) ;
			$("#operatorName").val(userArr[0].name) ;
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
/**
 * 散客团
 */

$(function(){
	$("#saveFitGroupInfoForm").validate(
			{
				rules : {
					'tourGroup.productName' : {
						required : true
					}
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
				
					var options = {
						url : '../fitGroup/updateFitGroupInfo.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
							} else {
								$.success(data.msg);

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试');
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	$("#saveAgencyFitGroupInfoForm").validate(
			{
				rules : {
					'tourGroup.productName' : {
						required : true
					}
				},
				errorPlacement : function(error, element) { // 指定错误信息位置

					if (element.is(':radio') || element.is(':checkbox')
							|| element.is(':input')) { // 如果是radio或checkbox
						var eid = element.attr('name'); // 获取元素的name属性
						error.appendTo(element.parent()); // 将错误信息添加当前元素的父结点后面
					} else {
						error.insertAfter(element);
					}
				},
				submitHandler : function(form) {
				
					var options = {
						url : '../agencyFitGroup/updateFitGroupInfo.do',
						type : "post",
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.success('操作成功',function(){
									window.location = window.location;
								});
							} else {
								$.success(data.msg);

							}
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							$.warn('服务忙，请稍后再试');
						}
					}
					$(form).ajaxSubmit(options);
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}

			});
	
});
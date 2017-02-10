/**
 * 
 */
$(function(){		
		$(".AreaDef").autoTextarea({ minHeight: 80 });
		
		$("input.chkAll").each(function(){			
			$(this).unbind("click").bind("click",function(){
				var chked = $(this).is(':checked');
				$(this).closest("table").find("input.itemChk").each(function(){
					$(this).attr("checked",chked);
					changeNum(this,chked);
				})
			})
		})
		if($("#stateFinance").val()==1){
			 $("#btnSave").attr("disabled","disabled");
		 }
		var chkIsAll=function(){
			$("table.chk_table").each(function(){
				$(this).find("input.chkAll").attr("checked",$(this).find("input.itemChk").length == $(this).find("input.itemChk:checked").length ? true:false);
			})			
		}
		
		chkIsAll();
		
		$("input.itemChk").click(function(){
		 	var area = $(this).closest("table");
			$(area).find("input.chkAll").attr("checked",$(area).find("input.itemChk").length == $(area).find("input.itemChk:checked").length ? true:false);
			changeNum(this,$(this).is(':checked'));
		})
		//var person = {adult:${group.totalAdult==null ? 0:group.totalAdult},child:${group.totalChild==null ? 0:group.totalChild}};	
		
		function changeNum(obj,chked){
			if($(obj).attr("tag")=='num'){
				var adultnum = parseInt($(obj).attr("adultnum"));
				var childnum = parseInt($(obj).attr("childnum"));
				if(chked){
					person.adult+=adultnum;
					person.child+=childnum;
					$("#numAdult").html(person.adult);
					$("#numChild").html(person.child);					
				}else{
					person.adult-=adultnum;
					person.child-=childnum;
					$("#numAdult").html(person.adult);
					$("#numChild").html(person.child);	
				}
			}
		}
		
		$("#bookingForm").validate({
				rules : {
					'supplierName' : {
						required : true
					},
					'dateArrival' : {
						required : true
					}
				},
				messages : {
					'supplierName' : {
						required : "请选择地接社"
					},
					'dateArrival' : {
						required : "请输入到达日期"

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
					var booking={
						id:$("#bookingId").val(),
						groupId:$("#groupId").val(),
						supplierId:$("#supplierId").val(),
						supplierName:$("#supplierName").val(),
						supplierOrderNo:$("#supplierOrderNo").val(),
						contact:$("#contact").val(),
						contactTel:$("#contactTel").val(),
						contactFax:$("#contactFax").val(),
						contactMobile:$("#contactMobile").val(),
						personAdult:person.adult,
						personChild:person.child,
						personGuide:person.guide,
						dateArrival:$("#dateArrival").val(),
						remark:$("#remark").val(),
						stateBooking:$("#stateBooking").val(),
						routeList:[],
						orderList:[],
						priceList:[]
					}
					$("#routeTable").find("input.itemChk:checked").each(function(){
						var routeId = $(this).attr("rid");
						var bookingId=$(this).attr("bkid");
						var id=$(this).attr("brid");
						booking.routeList.push({id:id,routeId:routeId,bookingId:bookingId});
					})
					if($('#groupMode').val()=='0' || $('#groupMode').val()=='-1'){
						$("#orderTable").find("input.itemChk:checked").each(function(){
							var orderId = $(this).attr("oid");
							var bookingId=$(this).attr("bkid");
							var id = $(this).attr("boid");
							booking.orderList.push({id:id,orderId:orderId,bookingId:bookingId});
						})
					}
					$("#priceTblTr tr").each(function(){
						booking.priceList.push({
							id:$(this).find("td[tag='priceId']").text().trim(),
							itemName:$(this).find("td[tag='itemName']").text().trim(),
							remark:$(this).find("td[tag='remark']").text().trim(),
							unitPrice:$(this).find("td[tag='unitPrice']").text().trim(),
							salePrice:$(this).find("td[tag='salePrice']").text().trim(),
							numTimes:$(this).find("td[tag='numTimes']").text().trim(),
							numPerson:$(this).find("td[tag='numPerson']").text().trim(),
							totalPrice:$(this).find("td[tag='totalPrice']").text().trim()});
					
					})
					jQuery.ajax({
						url : "../tourGroup/validatorSupplier.htm",
						type : "post",
						async : false,
						data : {
							"supplierId" : $("#supplierId").val(),
							"supplierName":$("#supplierName").val()
						},
						dataType : "json",
						success : function(data) {
							if (data.success) {
								$.ajax({
				   					type: 'POST',
				   					cache:false,
				   			        url: 'saveBooking.do',
				   			        dataType: 'json',		        
				   			        data: {booking:JSON.stringify(booking)},
				   			        success: function(data) {
				   			            if (data.sucess == true) {
							            	//refreshWindow("修改下接社订单","../booking/viewDelivery.htm?gid="+data['groupId']+"&bid="+data['bookingId']);
				   			            	$.success("保存成功",function(){
							            	refreshWindow("修改下接社订单","../booking/bookingDeliveryEdit.htm?gid="+data['groupId']+"&bid="+data['bookingId']);
				   			            	});

				   			            }else{
				   							$.error("操作失败");
				   						}
				   			        },
				   			        error: function(data,msg) {
				   			            $.error("操作失败"+msg);
				   			        }
								})
							}else{
								$.warn(data.msg);
							}
						},
						error : function(XMLHttpRequest, textStatus, errorThrown) {
							$.error(textStatus);
							window.location = window.location;
						}
					});
				},
				invalidHandler : function(form, validator) { // 不通过回调
					return false;
				}
			})
		$("#priceBtn").click(function(){
			price.showAdd();
			price.bindEvent();
		});		
		$("#impBtn").click(function(){
			var win=0;
			var supplierId = $("#supplierId").val().trim() ;
			if(supplierId==""){
				layer.msg("请先选择下接社");
			}else{
				layer.open({ 
					type : 2,
					title : '选择协议项目',
					closeBtn : false,
					area : [ '550px', '450px' ],
					shadeClose : false,
					content : 'deliveryContract.htm?supplierId='+supplierId,//参数为供应商id
					btn: ['确定', '取消'],
					success:function(layero, index){
						win = window[layero.find('iframe')[0]['name']];
					},
					yes: function(index){
						//manArr返回的是联系人对象的数组
						var arr = win.getItems();    				
						if(arr.length==0){
							alert("请选择项目");
							return false;
						}
						
						for(var i=0,len=arr.length;i<len;i++){
							//添加行
							$("#priceTblTr").append($("#priceRowHtml").html());	
							var tr = $('#priceTblTr tr:last');
							tr.find("select[name='itemName']").val(arr[i].itemName);
							tr.find("input[name='unitPrice']").val(arr[i].unitPrice);
						}
						price.bindEvent();
						//一般设定yes回调，必须进行手工关闭
				        layer.close(index); 
				    },cancel: function(index){
				    	layer.close(index);
				    }
				});
			}
		});
		price.bindEvent();
	})
	
	

var price = {
	addCompute:function(){
		$("input[id='unitPrice']").on('input',function(e){  
			 var unitPrice =$("input[id='unitPrice']").val();
			 var numTimes = $("input[id='numTimes']").val();
			 var numPerson =$("input[id='numPerson']").val();
			 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
			 $("input[id='totalPrice']").val(isNaN(total)? 0:total);
		});  
		$("input[id='numTimes']").on('input',function(e){  
			 var unitPrice =$("input[id='unitPrice']").val();
			 var numTimes = $("input[id='numTimes']").val();
			 var numPerson =$("input[id='numPerson']").val();
			 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
			 $("input[id='totalPrice']").val(isNaN(total)? 0:total);
		});  
		$("input[id='numPerson']").on('input',function(e){  
			 var unitPrice =$("input[id='unitPrice']").val();
			 var numTimes = $("input[id='numTimes']").val();
			 var numPerson =$("input[id='numPerson']").val();
			 var total =(unitPrice==''?'1':unitPrice)*(numTimes==''?'1':numTimes)*(numPerson==''?'1':numPerson);
			 $("input[id='totalPrice']").val(isNaN(total)? 0:total);
		});
	},	
	//点击添加
	showAdd:function(){		
		$("#priceTable tbody").append($("#priceRowHtml").html());
	},	
	bindEvent:function(){
		$("#priceTblTr tr").each(function(){
			
			//绑定删除事件
			$(this).find("a[name='priceDel']").bind("click",function(){
				var rowindex = $(this).closest("#priceTblTr").find("tr").index($(this).closest("tr")[0]);			
				$(this).closest("tr").remove();
				$("#sumPrice").html(calcSum());
			})
			//绑定行计算
			var unitPriceObj=$(this).find("td[tag='unitPrice']");
			var numTimesObj=$(this).find("td[tag='numTimes']");
			var numPersonObj=$(this).find("td[tag='numPerson']");
			var totalPriceObj=$(this).find("td[tag='totalPrice']");
			unitPriceObj.removeAttr("onblur").blur(function(){				
				var unitPrice = unitPriceObj.val();
				if(unitPrice=='' || isNaN(unitPrice)){
					unitPriceObj.val(1);
					unitPrice = 1;
				}
				var numTimes = numTimesObj.val();
				var numPerson =numPersonObj.val();
				var total =(new Number(unitPrice==''?'1':unitPrice)).mul(new Number(numTimes==''?'1':numTimes)).mul(new Number(numPerson==''?'1':numPerson));
				totalPriceObj.val(isNaN(total)? 0:total);	
				
				$("#sumPrice").html(calcSum());
			})
			numTimesObj.removeAttr("onblur").blur(function(){
				var unitPrice = unitPriceObj.val();
				var numTimes = numTimesObj.val();
				if(numTimes==''||isNaN(numTimes)){
					numTimesObj.val(1);
					numTimes = 1;
				}
				var numPerson =numPersonObj.val();
				var total =(new Number(unitPrice==''?'1':unitPrice)).mul(new Number(numTimes==''?'1':numTimes)).mul(new Number(numPerson==''?'1':numPerson));
				totalPriceObj.val(isNaN(total)? 0:total);
				$("#sumPrice").html(calcSum());
			})
			numPersonObj.removeAttr("onblur").blur(function(){
				var unitPrice = unitPriceObj.val();
				var numTimes = numTimesObj.val();
				var numPerson =numPersonObj.val();
				if(numPerson=='' || isNaN(numPerson)){
					numPersonObj.val(0);
					numPerson=0;
				}
				var total =(new Number(unitPrice==''?'1':unitPrice)).mul(new Number(numTimes==''?'1':numTimes)).mul(new Number(numPerson==''?'1':numPerson));
				totalPriceObj.val(isNaN(total)? 0:total);
				$("#sumPrice").html(calcSum());
			})	
			
			function calcSum(){
				var sum=0;
				//计算总价				
				$("#priceTable tbody tr").find("td[tag='totalPrice']").each(function(){
					var total= $(this).val()=='' ? 0:$(this).val();
					sum = (new Number(sum)).add(new Number(isNaN(total) ? 0:total));
				})			
				return sum;
			}
		})
	}
}
		
	var show = {
			agency:function(ctx){
				var win=0;
				layer.openSupplierLayer({
					title : '选择下接社',
                    content : ctx+'/component/supplierList.htm?supplierType=16',
					callback: function(arr){
                        if(arr.length==0){
                            $.warn("请选择下接社");
                            return false;
                        }

                        /*for(var i=0;i<arr.length;i++){
                         console.log("id:"+arr[i].id+",name:"+arr[i].name+",type:"+arr[i].type+",province:"+arr[i].province+",city:"+arr[i].city+",area:"+arr[i].area+",town:"+arr[i].town);
                         }*/
                        $("#supplierName").val(arr[0].name);
                        $("#supplierId").val(arr[0].id);
					}
				});
			},
			contact:function(ctx){
				/**
				 * 先选择供应商，再根据供应商id选择联系人 
				 */
				var win=0;
				var supplierId = $("#supplierId").val().trim() ;
				if(supplierId==""){
					layer.msg("请先选择下接社");
				}else{
					layer.open({ 
						type : 2,
						title : '选择联系人',
						closeBtn : false,
						area : [ '550px', '450px' ],
						shadeClose : false,
						content : ctx+'/component/contactMan.htm?supplierId='+supplierId,//参数为供应商id
						btn: ['确定', '取消'],
						success:function(layero, index){
							win = window[layero.find('iframe')[0]['name']];
						},
						yes: function(index){
							//manArr返回的是联系人对象的数组
							var arr = win.getChkedContact();    				
							if(arr.length==0){
								alert("请选择联系人");
								return false;
							}
							$("#contact").val(arr[0].name);
							$("#contactMobile").val(arr[0].mobile);
							$("#contactTel").val(arr[0].tel);
							$("#contactFax").val(arr[0].fax);
							//一般设定yes回调，必须进行手工关闭
					        layer.close(index); 
					    },cancel: function(index){
					    	layer.close(index);
					    }
					});
				}
			},
			guest:function(orderId){
				layer.open({ 
					type : 2,
					title : '客人列表',
					closeBtn : false,
					area : [ '750px', '450px' ],
					shadeClose : false,
					content : 'guestList.htm?orderId='+orderId,
					btn: ['确定', '取消'],
					success:function(layero, index){
						win = window[layero.find('iframe')[0]['name']];
					},
					yes: function(index){				
						//一般设定yes回调，必须进行手工关闭
				        layer.close(index); 
				    },cancel: function(index){
				    	layer.close(index);
				    }
				});
			},
			traffic:function(orderId){
				layer.open({ 
					type : 2,
					title : '接送列表',
					closeBtn : false,
					area : [ '850px', '450px' ],
					shadeClose : false,
					content : 'transportList.htm?orderId='+orderId,
					btn: ['确定', '取消'],
					success:function(layero, index){
						win = window[layero.find('iframe')[0]['name']];
					},
					yes: function(index){				
						//一般设定yes回调，必须进行手工关闭
				        layer.close(index); 
				    },cancel: function(index){
				    	layer.close(index);
				    }
				});
			}		
		}
	
	
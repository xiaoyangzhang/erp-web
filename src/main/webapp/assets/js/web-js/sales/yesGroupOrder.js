/**
 * 未并团
 */

function selectUserMuti(num){
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		closeBtn : false,
		area : [ '400px', '500px' ],
		shadeClose : true,
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
			var userArr = win.getUserList();   
			$("#saleOperatorIds").val("");
			$("#saleOperatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name);
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id);
					//$("#saleOperatorIds").val($("#saleOperatorIds").val()+")");
					//alert($("#saleOperatorIds").val());
				}else{
					$("#saleOperatorName").val($("#saleOperatorName").val()+userArr[i].name+",");
					$("#saleOperatorIds").val($("#saleOperatorIds").val()+userArr[i].id+",");
				}
			}
			//一般设定yes回调，必须进行手工关闭
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}
function multiReset(){
	$("#saleOperatorName").val("");
	$("#saleOperatorIds").val("");
}
function searchBtn() {
	var pageSize=$("#pageSize").val();
	queryList(1,pageSize);
}
function queryList(page,pageSize) {
	if (!page || page < 1) {
		page = 1;
	}
	$("#groupPage").val(page);
	$("#pageSize").val(pageSize);
	$("#toYesGroupListForm").submit();
}

function delGroupOrder(id){
	$.confirm("确认删除吗？", function() {
		$.getJSON("delGroupOrder.do?id=" + id, function(data) {
			if (data.success) {
				$.success('操作成功',function(){
					queryList($("#groupPage").val(),$("#pageSize").val());
				});
				
			}

		});
	}, function() {
		$.info('取消删除');
	});
	
}
/**
 * 打印订单信息
 * @param orderId
 */
function printOrder(orderId){
	/*$("#saleOrder").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+1) ; //销售订单
	$("#saleCharge").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+2) ; //销售价格
	$("#saleOrderNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+4) ; //销售订单-无行程
	$("#saleChargeNoRoute").attr("href","../tourGroup/download.htm?orderId="+orderId+"&num="+5) ; //结算单-无行程
*/	
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


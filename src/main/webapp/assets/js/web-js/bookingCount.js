/*
function toIncomeDetail(supplierId){
	$(window.parent.document).find("a.selected").removeClass("selected");
	$(window.parent.document).find("#bookingDetail").addClass("selected");
	
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/incomeDetailList.htm") ;
	$("form").submit();
}

function toOutcomeDetail(supplierId){
	$(window.parent.document).find("a.selected").removeClass("selected");
	$(window.parent.document).find("#bookingDetail").addClass("selected");
	
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/outcomeDetailList.htm") ;
	$("form").submit();
}
function toGolfList(num){
	if(num==1){
		window.location = "../query/golfList.htm" ;
	}else{
		window.location = window.location ;
	}
}

function toGolfDetailList(num){
	if(num==1){
		window.location = window.location ;
	}else{
		window.location = "../query/golfDetailList.htm" ;
	}
}
function toGolfDetail(supplierId){
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/golfDetailList.htm") ;
	$("form").submit();
}
function toEntertainmentList(num){
	if(num==1){
		window.location = "../query/entertainmentList.htm" ;
	}else{
		window.location = window.location ;
	}
}

function toEntertainmentDetailList(num){
	if(num==1){
		window.location = window.location ;
	}else{
		window.location = "../query/entertainmentDetailList.htm" ;
	}
}
function toEntertainmentDetail(supplierId){
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/entertainmentDetailList.htm") ;
	$("form").submit();
}

function toAirTicketDetail(supplierId){
	$(window.parent.document).find("a.selected").removeClass("selected");
	$(window.parent.document).find("#bookingDetail").addClass("selected");
	
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/airTicketDetailList.htm") ;
	$("form").submit();
}

function toTrainTicketDetail(supplierId){
	$(window.parent.document).find("a.selected").removeClass("selected");
	$(window.parent.document).find("#bookingDetail").addClass("selected");
	
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/trainTicketDetailList.htm") ;
	$("form").submit();
}



function toInsuranceDetail(supplierId){
	$(window.parent.document).find("a.selected").removeClass("selected");
	$(window.parent.document).find("#bookingDetail").addClass("selected");
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/insuranceDetailList.htm") ;
	$("form").submit();
}*/
/*function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5,
 		area : [width,height],
 		content : url
 	});
 }*/
//根据产品统计年龄
/*function toAgeListByProduct(num){
	if(num==1){
		window.location = "../query/ageListByProduct.htm" ;
	}else{
		window.location = window.location ;
	}
}

//根据产品+旅行社统计年龄
function toAgeListByProductAndAgency(num){
	if(num==1){
		window.location = window.location ;
	}else{
		window.location = "../query/toAgeListByProductAndAgency.htm" ;
	}
}
function toAgeTableByProduct(supplierId){
	$("#supplierId").val(supplierId);
	$("form").attr("action","../query/hotelDetailList.htm") ;
	$("form").submit();
}
*/

function toClear(){
	$("#startTime").val("");
	$("#endTime").val("");
	$("#supplierName").val("");
	$("#paymentState").val("");
	$("#operatorIds").val("");
	$("#operatorName").val("");
	$("#groupMode").val("");
	$("#userName").val("");
}
function selectUserMuti(num){
	var width = window.screen.width ;
	var height = window.screen.height ;
	var wh = (width/1920*650).toFixed(0) ;
	var hh = (height/1080*500).toFixed(0) ;
	wh = wh+"px" ;
	hh = hh+"px" ;
	var lh = (width/1920*400).toFixed(0) ;
	var th = (height/1080*100).toFixed(0) ;
	lh = lh+"px" ;
	th = th+"px" ;
	var win=0;
	layer.open({ 
		type : 2,
		title : '选择人员',
		shadeClose : true,
		shade : 0.5,
		offset : [th,lh],
		area : [wh,hh],
		content : '../component/orgUserTree.htm?type=multi',//单选地址为orgUserTree.htm，多选地址为
		btn: ['确定', '取消'],
		success:function(layero, index){
			win = window[layero.find('iframe')[0]['name']];
		},
		yes: function(index){
			var userArr = win.getUserList(); 
			if(num==1){
				
				$("#userIds").val("");
				$("#userName").val("");
			}
			
			$("#operatorIds").val("");
			$("#operatorName").val("");
			for(var i=0;i<userArr.length;i++){
				console.log("id:"+userArr[i].id+",name:"+userArr[i].name+",pos:"+userArr[i].pos+",mobile:"+userArr[i].mobile+",phone:"+userArr[i].phone+",fax:"+userArr[i].fax);
				if(i==userArr.length-1){
					if(num==1){
						
						$("#userName").val($("#userName").val()+userArr[i].name);
						$("#userIds").val($("#userIds").val()+userArr[i].id);
					}
					$("#operatorName").val($("#operatorName").val()+userArr[i].name);
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id);
				}else{
					if(num==1){
						
						$("#userName").val($("#userName").val()+userArr[i].name);
						$("#userIds").val($("#userIds").val()+userArr[i].id);
					}
					$("#operatorName").val($("#operatorName").val()+userArr[i].name+",");
					$("#operatorIds").val($("#operatorIds").val()+userArr[i].id+",");
				}
			}
	        layer.close(index); 
	    },cancel: function(index){
	    	layer.close(index);
	    }
	});
}


function toPreview(){
	var url = "../query/hotelDetailPreview.htm?"+
	"selectDate=" + $("#selectDate").val() +
	"&startTime=" + $("#startTime").val() + 
	"&endTime=" + $("#endTime").val() + 
	"&bizId="+$("#bizId").val() + 
	"&groupMode=" + $("#groupMode").val() + 
	"&groupCode=" + $("#groupCode").val() +
	"&productBrandName=" + $("#productBrandName").val() + 

	"&level=" + ($("#level").val()==undefined?"":$("#level").val()) + 
	"&provinceId=" + ($("#provinceCode").val()==undefined?"":$("#provinceCode").val()) + 
	"&cityId=" + ($("#cityCode").val()==undefined?"":$("#cityCode").val())  + 
	"&supplierType=" + $("#supplierType").val() +
	"&supplierId=" + $("#supplierId").val() + 
	"&supplierName=" + $("#supplierName").val() + 
	"&cashType=" + $("#cashType").val() + 
	"&paymentState=" + ($("#paymentState").val()==undefined?"":$("#paymentState").val()) + 
	"&type1Id=" + ($("#type1Id").val()==undefined?"":$("#type1Id").val()) + 
	"&type1Name=" + ($("#type1Name").val()==undefined?"":$("#type1Name").val()) + 

	"&orgIds=" + $("#orgIds").val() + 
	"&orgNames=" + $("#orgNames").val() + 
	"&operType=" + ($("#operType").val()==undefined?"":$("#operType").val())  + 
	"&saleOperatorIds=" + $("#saleOperatorIds").val() + 
	"&saleOperatorName=" + $("#saleOperatorName").val() + 
	"&sl="+$("input[name='sl']").val()+"&rp="+$("input[name='rp']").val()+"&ssl="+$("input[name='ssl']").val();

	$("#preview").attr("target","_blank").attr("href",encodeURI(url));
	
}
function exportExcel(){
	location.href="exportExcel.htm?"+(window.location.search.length>0?location.search.substring(1):"");
}



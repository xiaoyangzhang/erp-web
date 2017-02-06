<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>增加淘宝散客团</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/card/native-info.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/taobaoOrderList.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/changeAddShow.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/sales_route.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/specialRoute.js"></script>
<link href="<%=ctx%>/assets/css/product/product_rote.css"
	rel="stylesheet" />
<style type="text/css">
.p {
	font-family: "Arial Normal", "Arial";
	font-weight: 400;
	font-style: normal;
	font-size: 13px;
	cursor: pointer;
	text-align: left;
}

.searchTab {
	width: 100%;
}

.searchTab tr td {
	height: 25px;
	padding: 5px;
}

.searchTab tr td:nth-child(odd) {
	min-width: 90px;
	text-align: right;
}

.searchTab tr td:nth-child(even) {
	min-width: 200px;
}

.l_textarea_mark {
	border: 1px solid #dbe4e6;
	border-radius: 3px;
	width: 450px;
	height: 40px;
	min-height: 40px;
	padding: 5px 10px;
	line-height: 20px;
}

.hoverBlock { background-color: #fff;  border:2px solid  #1b9af7;  width: 10px;  height:380px;  position: fixed;  right: 0;  top: 10%;  z-index: 999; }
.hoverBlock .switch{float:left; width:10px;background-color: #ddd; height:100%; line-height:380px; cursor:pointer; }
.hoverBlock .container{float:left; width:0px; height:100%; overflow-y: scroll;}
</style>
<style type="text/css">
table.gridtable {
	font-family: verdana,arial,sans-serif;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
	width:100%;
}
table.gridtable th {
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #d4d4d4;
	background-color: #efefef;
	text-align:right;
	font-weight: normal;
}
table.gridtable th.line{
	padding: 3px;
	background-color: #f1f1f1;
	color: blue;
	text-align:left;
	font-weight:bold;
}
table.gridtable td {
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #d4d4d4;
	background-color: #ffffff;
}
</style>
<script type="text/javascript">
		var path = '<%=ctx%>';
		var startDate='${vo.groupOrder.departureDate}'==''?new Date().getTime():new Date('${vo.groupOrder.departureDate}').getTime();
		var img200Url = '${config.images200Url}';
        var ob;
        var pbId;
        var pId;
        var sc;
        var pn;
		$(function(){
		    $(".l_textarea").autoTextarea({minHeight:50});
		    $(".l_textarea_mark").autoTextarea({minHeight:40});
		    $(".switch").click(function () {
		    	if ($(this).attr("lang") == "open")
		    		{
		        		$(".hoverBlock").animate({ width: '10px' }, "slow").find(".container").css("width", "0px");
		        		$(this).attr("lang", "close").text("<");
		    		}else{
		    			$(".hoverBlock").animate({ width: '500px' }, "slow").find(".container").css("width", "489px");
		        		$(this).attr("lang", "open").text(">");
		    		}
		    });
		});
</script>

<script type="text/javascript">
function showInfo(title,width,height,url){
 	layer.open({ 
 		type : 2,
 		title : title,
 		shadeClose : true,
 		shade : 0.5,
 		area : [width,height],
 		content : url
 	});
 }

	/** * 选择组团社 */
	function selectSupplier(){
		layer.openSupplierLayer({
			title : '选择组团社',
			content : getContextPath() + '/component/supplierList.htm?supplierType=1',//参数：操作类型（type:单选(single)、多选(multi)）供应商类型supplierType=1
			callback: function(arr){
				if(arr.length==0){
					$.warn("请选组团社");
					return false;
				}
				$("#supplierName").val(arr[0].name);
				$("#supplierName_t").val(arr[0].name);
				$("#supplierId").val(arr[0].id);
		    }
		});
	}
	
	/**
	 * 页面选择部分调用函数(单选)
	 */
	function selectUser(num){
		var win=0;
		layer.open({
			type : 2,
			title : '选择人员',
			shadeClose : true,
			shade : 0.5,
			area : [ '400px', '470px' ],
			content : '../component/orgUserTree.htm',//单选地址为orgUserTree.htm，多选地址为
			btn: ['确定', '取消'],
			success:function(layero, index){
				win = window[layero.find('iframe')[0]['name']];
			},
			yes: function(index){
				//userArr返回的是user对象的数组，user包含属性：用户id(id),职位(pos)，名称（name），mobile（手机）,phone（电话）,fax（传真）
				var userArr = win.getUserList();    				
				if(userArr.length==0){
					$.warn("请选择人员");
					return false;
				}
				//销售计调
				if(num==1){
					$("#saleOperatorId").val(userArr[0].id);
					$("#saleOperatorName").val(userArr[0].name);
				}
				//操作计调
				if(num==2){
					$("#operatorId").val(userArr[0].id);
					$("#operatorName").val(userArr[0].name);
				}
				//一般设定yes回调，必须进行手工关闭
		        layer.close(index); 
		    },cancel: function(index){
		    	layer.close(index);
		    }
		});
	}
	
	var orderBusiness;
	/**
	 * 选择联系人
	 */
	function selectContact(){
		
				var supplierId=$("input[name='groupOrder.supplierId']").val();
				if(supplierId==''){
					$.error('请先选择组团社');
					return
				}
	    		var win;
	    		layer.open({ 
	    			type : 2,
	    			title : '选择联系人',
	    			closeBtn : false,
	    			area : [ '550px', '450px' ],
	    			shadeClose : false,
	    			content : '../component/contactMan.htm?supplierId='+supplierId,// 参数为供应商id
	    			btn: ['确定', '取消'],
	    			success:function(layero, index){
	    				win = window[layero.find('iframe')[0]['name']];
	    			},
	    			yes: function(index){
	    				// manArr返回的是联系人对象的数组
	    				var arr = win.getChkedContact();    				
	    				if(arr.length==0){
	    					$.error('请选择联系人')
	    					return false;
	    				}
	    				
	    				for(var i=0;i<arr.length;i++){
	    					$("input[name='groupOrder.contactName']").val(arr[i].name);
	    					$("input[name='groupOrder.contactTel']").val(arr[i].tel);
	    					$("input[name='groupOrder.contactMobile']").val(arr[i].mobile);
	    					$("input[name='groupOrder.contactFax']").val(arr[i].fax);
	    				}
	    				// 一般设定yes回调，必须进行手工关闭
	    		        layer.close(index); 
	    		    },cancel: function(index){
	    		    	layer.close(index);
	    		    }
	    		});
	    	}
	
	function limitInput(o){   
        var adult = $("input[name='groupOrder.numAdult']").val(),
        	child = $("input[name='groupOrder.numChild']").val(),
        	oAdult = $("#totalPerson_adult").val(),
        	oChild = $("#totalPerson_child").val(),
        	totalPerson=$("#totalPerson").val(),
        	allowNum = $("#allowNum").val();
        
        	oAdult = (oAdult==""?0:oAdult);
        	oChild = (oChild==""?0:oChild);
        	totalPerson = (totalPerson==""?0:totalPerson);
        	allowNum = (allowNum==""?0:allowNum);
        	
     	var isStock = $("#orderBusiness").val();
    	if (isStock == "stock"){
        	var maxEdit = parseInt(allowNum)+parseInt(totalPerson); //修改时的最大库存数
        	var maxNew = $("#stockCount").text(); //新增时的最大库存数（从选择框带进来）
        	var max = Math.max(maxEdit, maxNew);
	        var current = parseInt(adult)+parseInt(child);
        	if(parseInt(current)>max){
	       		alert('订单人数不允许大于库存人数！');
             	$("input[name='groupOrder.numAdult']").val(oAdult);
         		$("input[name='groupOrder.numChild']").val(oChild);
         	}
        	
    	}
    }
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
	<%@ include file="/WEB-INF/views/sales/template/groupRouteTemplate.jsp"%>
	<div class="p_container">
		<div class="p_container_sub" id="tab1">
		    <c:if test="${vo.groupOrder.id != null }">
		    <c:if test="${msgInfoList.size() > 0 }">
		    <p class="p_paragraph_title">
                    <b>消息记录</b>
                </p>
                <dl class="p_paragraph_content">
                    <dd>
                        <div class="dd_left">
                            <span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
                        </div>
                        <div class="dd_right" style="width: 90%">
                            <table cellspacing="0" cellpadding="0" class="w_table">
                                <thead>
                                    <tr>
                                        <!-- <th width="7%">状态<i class="w_table_split"></i></th> -->
                                        <th width="10%">标题<i class="w_table_split"></i></th>
                                        <th>内容<i class="w_table_split"></i></th>
                                        <th width="10%">发送人<i class="w_table_split"></i></th>
                                        <th width="15%">发送时间<i class="w_table_split"></i></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${msgInfoList}" var="msg">
                                    <tr onclick="showMsgView(${msg.id});">
                                        <%-- <td>
                                        <c:if test="${msg.status==0}">
                                          <a href="javascript:void(0);">未读</a>
                                        </c:if>
                                        <c:if test="${msg.status==1}">已读</c:if>
                                        </td> --%>
                                    <td style="text-align:left;">${msg.msgTitle}</td>
                                    <td style="text-align:left;">${msg.msgText}</td>
						            <td>${msg.operatorName}</td>
						            <td>${msg.createTime}</td>
						        </tr>
						    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="clear"></div>
                    </dd>
                </dl>
		      </c:if>
		      </c:if>
			<form id="SpecialGroupOrderForm">
				<p class="p_paragraph_title">
					<b>基本信息</b>
				</p>
			
				<table border="0" cellspacing="0" cellpadding="0" class="searchTab">
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tr style="display:none;">
						<td>订单号：</td>
						<td>
						<input type="hidden" id="orderId" name="groupOrder.id" value="${vo.groupOrder.id}" />
						<input type="text"name="groupOrder.orderNo" value="${vo.groupOrder.orderNo}"
							readonly="readonly" placeholder="订单号系统自动生成" /></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td><i class="red">* </i>销售计调 :</td>
						<td><input name="groupOrder.saleOperatorName"
							id="saleOperatorName" value="${vo.groupOrder.saleOperatorName}"
							readonly="readonly" type="text"> <a
							href="javascript:void(0);" onclick="selectUser(1)">修改</a> <input
							type="hidden" name="groupOrder.saleOperatorId"
							id="saleOperatorId" value="${vo.groupOrder.saleOperatorId}" /></td>
						<td><i class="red">* </i>操作计调:</td>
						<td><input name="groupOrder.operatorName" id="operatorName"
							readonly="readonly" value="${vo.groupOrder.operatorName}"
							type="text"> <a href="javascript:void(0);"
							onclick="selectUser(2)">修改</a> <input type="hidden"
							name="groupOrder.operatorId" id="operatorId"
							value="${vo.groupOrder.operatorId}"></td>
					</tr>
					<tr>
						<td><i class="red">* </i>出团日期：</td>
						<td><input type="text" name="groupOrder.departureDate" id="groupOrder_departureDate"
							class="Wdate"
								   onClick="WdatePicker({onpicking: function(dp){startDate=new Date(dp.cal.getNewDateStr()).getTime(); if($('#orderBusiness').val()==='stock'){$('#productBrandId').val('');$('#productBrandName').val('');$('#productId').val('');$('#stockCount').val('');$('#productName').val('');$('#groupOrder_numAdult').val(0);$('#groupOrder_numChild').val(0);} },dateFmt:'yyyy-MM-dd'})"
								   value="${vo.groupOrder.departureDate }" />
							离团日期：
							<input type="text" name="groupOrder.dateEnd" id="groupOrder_dateEnd"
								   class="Wdate"
								   onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'groupOrder_departureDate\')}',onpicked:pickedFunc})"
								   value="${vo.groupOrder.dateEnd }" /></td>
						<td><i class="red">* </i>业务类别：</td>
								<td><select name="groupOrder.orderMode" id="orderMode" onchange="orderModeChange()">
								<option value="-1">请选择</option>
								<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option lang="${v.note}" value="${v.id}"<c:if test='${vo.groupOrder.orderMode==v.id}'>selected='selected'</c:if> >${v.value}</option>
							</c:forEach>		
							</select>
							<input type="hidden" id="requireTraffic" value="0" />
							<span id="wuliu_id"></span>
							<input type="hidden" name="bookingDate" value="" />
							</td>
					</tr>		
			
					<tr>
						<td><i class="red">* </i>客户名称：</td>
						<td><input name="groupOrder.supplierId" id="supplierId"
							type="hidden" value="${vo.groupOrder.supplierId }" /> 
							<input  type="hidden" name="groupOrder.supplierName" id="supplierName" class="IptText300" value="${vo.groupOrder.supplierName }" />
							<input id="supplierName_t" type="text" class="IptText300" value="${vo.groupOrder.supplierName }" /> 
							<a href="javascript:void(0)" onclick="selectSupplier();">请选择</a></td>
						<td>客户单号：</td>
						<td><input type="text" name="groupOrder.supplierCode" class="IptText300" placeholder="客户单号" value="${vo.groupOrder.supplierCode }" /></td>
					</tr>

					<tr>
						<td>客户联系人：</td>
						<td><input type="text" name="groupOrder.contactName" id="contactName" style="width:80px" placeholder="姓名" value="${vo.groupOrder.contactName }" /> 
						<input type="text" name="groupOrder.contactTel" id="contactTel" style="width:90px" placeholder="座机" value="${vo.groupOrder.contactTel }" /> 
						<input type="text" name="groupOrder.contactMobile" id="contactMobile" style="width:90px" placeholder="手机" value="${vo.groupOrder.contactMobile }" /> 
						<input type="text" name="groupOrder.contactFax" id="contactFax" style="width:90px" placeholder="传真" value="${vo.groupOrder.contactFax} " /> <a href="javascript:void(0)" onclick="selectContact();">请选择</a>
						</td>
						<td><i class="red">* </i>客人内容：</td>
						<td><input type="text" name="groupOrder.receiveMode" id='groupOrder_receiveMode'
							class="IptText300" 
							value="${vo.groupOrder.receiveMode}" /></td>
					</tr>
					<tr>
						<td><i class="red">* </i>团人数：</td>
						<td><input style="width: 80px;" type="text" onblur="limitInput(this);"
							name="groupOrder.numAdult" id="groupOrder_numAdult" placeholder="成人数"
							value="${(empty vo.groupOrder.numAdult)?0:vo.groupOrder.numAdult}" />
							<input style="width: 90px;" type="text" id="groupOrder_numChild"
							name="groupOrder.numChild" placeholder="小孩数" onblur="limitInput(this);"
							value="${(empty vo.groupOrder.numChild)?0:vo.groupOrder.numChild}" />
							<input style="width: 90px;" type="text"
							name="groupOrder.numGuide" placeholder="全陪数" onblur="limitInput(this);"
							value="${(empty vo.groupOrder.numGuide)?0:vo.groupOrder.numGuide}" />
							(成人数~小孩数~全陪)</td>
							<td>旺旺号：</td>
						<td><input type="text" name="groupOrder.buyerNick" id='groupOrder_buyerNick'
							class="IptText300" 
							value="${vo.groupOrder.buyerNick}" /></td>
							</tr>
					<tr>
						<td><i class="red">* </i>产品名称：</td>
						<td><input type="hidden" id="productBrandId" name="groupOrder.productBrandId"value="${vo.groupOrder.productBrandId }" />
						<input type="text"name="groupOrder.productBrandName" id="productBrandName" value="${vo.groupOrder.productBrandName }" readonly="readonly" placeholder="产品品牌" />
						~ <input type="hidden" name="groupOrder.productId" id="productId" value="${vo.groupOrder.productId }" />
						<input type="text"name="groupOrder.productName" id="productName" value="${vo.groupOrder.productName }" style="width: 300px" placeholder="产品名称" />
						<span id="stockCount" style="color:red"></span>
						<div class="tab-operate">
							<a href="javascript:void(0)" class="btn-show">选择产品<span class="caret"></span></a>
							<div class="btn-hide" id="asd">
						  <a href="javascript:void(0)"onclick="importRoute();">模板选择</a>
						  <a href="javascript:void(0)"onclick="stockOpt_TaobaoProduct();">库存选择</a>
							</div></div>
					</td>		
								<td>客源地：</td>
						<td><input type="hidden" name="groupOrder.provinceName"class="IptText300" id="provinceName"value="${vo.groupOrder.provinceName }" /> 
						<select name="groupOrder.provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }"
										<c:if test="${province.id==vo.groupOrder.provinceId }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
						</select> <input type="hidden" name="groupOrder.cityName"
							class="IptText300" id="cityName"
							value="${vo.groupOrder.cityName }" /> <select
							name="groupOrder.cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
									<option value="${city.id }"
										<c:if test="${city.id==vo.groupOrder.cityId }"> selected="selected" </c:if>>${city.name}</option>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
					<td>出发地：</td>
						<td><input type="hidden" name="groupOrder.departProvinceName"class="IptText300" id="departProvinceName"value="${vo.groupOrder.departProvinceName }" /> 
						<select name="groupOrder.departProvinceId" id="departProvinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }"
										<c:if test="${province.id==vo.groupOrder.departProvinceId }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
						</select> <input type="hidden" name="groupOrder.departCityName" class="IptText300" id="departCityName" value="${vo.groupOrder.departCityName}" /> 
						<select name="groupOrder.departCityId" id="departCityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity1}" var="city">
									<option value="${city.id }"
										<c:if test="${city.id==vo.groupOrder.departCityId}"> selected="selected" </c:if>>${city.name}</option>
								</c:forEach>
						</select></td>
						<c:if test="${vo.groupOrder.id == null }">
							<td class="red">成团方式：</td>
							<td class="red">
								<div class="dd_right"  id="a">
		    					<label ><input type="radio" name="groupOrder.orderType" value="1" <c:if test="${vo.groupOrder.orderType != '0'}"> checked="checked" </c:if> /><span>不需并团</span></label>
								<label ><input type="radio" name="groupOrder.orderType" value="0" <c:if test="${vo.groupOrder.orderType == 0 }"> checked="checked" </c:if> /><span>需要并团</span></label>
		    					</div>
		    				<div class="clear"></td>
	    				</c:if>
	    			<c:if test="${vo.groupOrder.id != null }">
	    				<input type="hidden" name="groupOrder.orderType" value="${vo.groupOrder.orderType}"/>
	    			</c:if>
					</tr>
				</table>

				<p class="p_paragraph_title">
					<b>酒店需求</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="17%">星级<i class="w_table_split"></i></th>
										<th width="17%">单人间<i class="w_table_split"></i></th>
										<th width="17%">标间<i class="w_table_split"></i></th>
										<th width="17%">三人间<i class="w_table_split"></i></th>
										<th width="17%">陪房<i class="w_table_split"></i></th>
										<th width="17%">加床<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><input name="hotelInfo.id" type="hidden"
											value="${vo.hotelInfo.id}" /> <input
											name="hotelInfo.supplierType" type="hidden" value="3" /> <input
											name="hotelInfo.orderId" type="hidden"
											value="${vo.groupOrder.id}" /> <select
											name="hotelInfo.hotelLevel">
												<c:forEach items="${jdxjList}" var="jdxj">
													<option value="${jdxj.id }"
														<c:if test="${jdxj.id==vo.hotelInfo.hotelLevel }"> selected="selected" </c:if>>${jdxj.value }</option>
												</c:forEach>
										</select></td>
										<td><input name="hotelInfo.countSingleRoom" type="text"
											style="width: 100px;"
											value="${(empty vo.hotelInfo.countSingleRoom)?0:vo.hotelInfo.countSingleRoom }" />
										</td>
										<td><input name="hotelInfo.countDoubleRoom" type="text"
											style="width: 100px;"
											value="${(empty vo.hotelInfo.countDoubleRoom)?0:vo.hotelInfo.countDoubleRoom }" />
										</td>
										<td><input name="hotelInfo.countTripleRoom" type="text"
											style="width: 100px;"
											value="${(empty vo.hotelInfo.countTripleRoom)?0:vo.hotelInfo.countTripleRoom }" />
										</td>
										<td><input name="hotelInfo.peiFang" type="text"
											style="width: 100px;"
											value="${ (empty vo.hotelInfo.peiFang)?0:vo.hotelInfo.peiFang }" />
										</td>
										<td><input name="hotelInfo.extraBed" type="text"
											style="width: 100px;"
											value="${ (empty vo.hotelInfo.extraBed)?0:vo.hotelInfo.extraBed}" />
										</td>

									</tr>

								</tbody>
							</table>
						</div>
						<div class="clear"></div>

					</dd>
				</dl>
				<p class="p_paragraph_title">
					<b>接送信息</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="10%">线路类型<i class="w_table_split"></i></th>
										<th width="10%">接送方式<i class="w_table_split"></i></th>
										<th width="10%">交通方式<i class="w_table_split"></i></th>
										<th width="10%">出发城市<i class="w_table_split"></i></th>
										<th width="10%">到达城市<i class="w_table_split"></i></th>
										<th width="10%">班次/车次<i class="w_table_split"></i></th>
										<th width="10%">出发日期<i class="w_table_split"></i></th>
										<th width="10%">出发时间<i class="w_table_split"></i></th>
										<th width="10%">备注<i class="w_table_split"></i></th>
										<th width="5%"><a href="javascript:;"
											onclick="addTran('newTransport');" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newTransportData">
									<c:forEach items="${vo.groupOrderTransportList }" var="trans"
										varStatus="index">
										<tr>
											<td>${index.count} <input type="hidden"
												name="groupOrderTransportList[${index.index}].id"
												value="${trans.id}">
											</td>
											<td><select
												name="groupOrderTransportList[${index.index}].sourceType"
												style="width: 100px">
													<option value="1"
														<c:if test="${trans.sourceType==1 }">selected="selected"</c:if>>省外交通</option>
													<option value="0"
														<c:if test="${trans.sourceType==0 }">selected="selected"</c:if>>省内交通</option>
											</select></td>
											<td><input type="radio"
												name="groupOrderTransportList[${index.index}].type"
												value="0"
												<c:if test="${trans.type==0 }">checked="checked"</c:if>>接</input>
												<input type="radio"
												name="groupOrderTransportList[${index.index}].type"
												value="1"
												<c:if test="${trans.type==1 }">checked="checked"</c:if>>送</input>
											</td>
											<td><select
												name="groupOrderTransportList[${index.index}].method"
												id="transportMethod" style="width: 100px;">
													<c:forEach items="${jtfsList}" var="jtfs">
														<option value="${jtfs.id}"
															<c:if test="${trans.method==jtfs.id}">selected="selected"</c:if>>${jtfs.value }</option>
													</c:forEach>
											</select></td>
											<td><input style="width: 80px" type="text"
												name="groupOrderTransportList[${index.index}].departureCity"
												placeholder="出发城市" value="${trans.departureCity }" /></td>
											<td><input style="width: 80px" type="text"
												name="groupOrderTransportList[${index.index}].arrivalCity"
												placeholder="到达城市" value="${trans.arrivalCity }" /></td>
											<td><input style="width: 80px" type="text"
												name="groupOrderTransportList[${index.index}].classNo"
												placeholder="班次/车次" value="${trans.classNo }" /></td>
											<td><input type="text"
												name="groupOrderTransportList[${index.index}].departureDate"
												class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})"
												value="<fmt:formatDate value="${trans.departureDate }" pattern="yyyy-MM-dd"/>" style="width: 100px;" /></td>
											<td><input type="text"
												name="groupOrderTransportList[${index.index}].departureTime"
												class="Wdate" onClick="WdatePicker({dateFmt:'HH:mm'})"
												value="${trans.departureTime }" style="width: 100px;" /></td>
											<td><input style="width: 100px" type="text"
												name="groupOrderTransportList[${index.index}].destination"
												placeholder="备注" value="${trans.destination }" /></td>
											<td><a href="javascript:void(0);"
												onclick="delTranTable(this,'newTransport')" class="def">删除</a></td>
										</tr>

									</c:forEach>


								</tbody>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
					<div style="margin-left: 6%">
						</br>
						<button type="button" class="button button-primary button-small pp" id="trafficImport">文本导入</button>
						</br> </br>
						<div id="bbb" style="display: none;">
							<div>
								<textarea class=""w_textarea"" name="bit" value="" id="bit"
									placeholder="出发日期,出发时间,航班号,出发城市,到达城市"
									></textarea>
							</div>
							<span>
								<i style="color: gray;"> 格式：出发日期,出发时间,航班号,出发城市,到达城市</i>
							</span>
							<div style="margin-top: 20px;">
								<a href="javascript:void(0);"
									onclick="toSaveSeatInCoach('newTransport')"
									class="button button-primary button-small">导入 </a> <span>
									<i class="red"> 格式：出发日期,出发时间,航班号,出发城市,到达城市 </i>
								</span>
							</div>
						</div>
					</div>
				</dl>
				<p class="p_paragraph_title">
					<b>价格</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="5%">序号<i class="w_table_split"></i></th>
										<th width="10%">项目<i class="w_table_split"></i></th>
										<th>备注<i class="w_table_split"></i></th>
										<th width="8%">单价<i class="w_table_split"></i></th>
										<th width="8%">人数<i class="w_table_split"></i></th>
										<th width="8%">次数<i class="w_table_split"></i></th>
										<th width="8%">金额<i class="w_table_split"></i></th>
										<th width="5%"><a href="javascript:;"
											onclick="addPrice(0,'newPrice');" class="def">增加</a></th>
									</tr>
								</thead> 
								<tbody id="newPriceData">
									<c:forEach items="${vo.groupOrderPriceList }" var="price" varStatus="index">
										<tr>
											<td>${index.count} <input type="hidden" name="groupOrderPriceList[${index.index}].id"	value="${price.id}" />
											<input type="hidden" name="groupOrderPriceList[${index.index}].priceLockState"	value="${price.priceLockState}" />
											<input type="hidden" name="groupOrderPriceList[${index.index}].stateFinance"	value="${price.stateFinance}" />
											</td>
											<td><input type="hidden"
												name="groupOrderPriceList[${index.index}].itemName"
												value="${price.itemName}" /> <select <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }"> disabled="disabled" </c:if>
												name="groupOrderPriceList[${index.index}].itemId"
												onchange="addItemName(this)">
													<c:forEach items="${lysfxmList}" var="lysfxm">
														<option value="${lysfxm.id}"
															<c:if test="${price.itemId==lysfxm.id }">selected="selected"</c:if>>${lysfxm.value }</option>
													</c:forEach>
											</select></td>
											<td><textarea class="l_textarea_mark" <c:if test="${price.stateFinance==1 || price.priceLockState > 0 }"> style="width:80%;border-color: red" readonly="readonly" </c:if>
													name="groupOrderPriceList[${index.index}].remark"
													placeholder="备注" >${price.remark }</textarea></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" <c:if test="${price.stateFinance==1 || price.priceLockState > 0  }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].unitPrice"
												placeholder="单价" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.unitPrice }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1 || price.priceLockState > 0  }">border-color: red </c:if>" <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].numPerson"
												placeholder="人数" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.numPerson }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" <c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].numTimes"
												placeholder="次数" onblur="countTotalPrice(${index.index})" data-rule-required="true" data-rule-number="true"
												value="${price.numTimes }" /></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1  || price.priceLockState > 0 }">border-color: red </c:if>" type="text"
												name="groupOrderPriceList[${index.index}].totalPrice"
												placeholder="金额" readonly="readonly"
												value="<fmt:formatNumber value='${price.totalPrice }' type='currency' pattern='#.##' />" /></td>
											<td>
												<c:if test="${price.stateFinance==0  && price.priceLockState == 0 }">
													<a href="javascript:void(0);"	onclick="delPriceTable(this,'newPrice')">删除</a>
												</c:if>
												</td>
										</tr>
										<c:set var="totalPrice"
											value="${totalPrice+price.totalPrice  }" />
									</c:forEach>


								</tbody>
								<tr>
									<td colspan="6" style="text-align: right">合计：</td>
									<td colspan="2" style="text-align: left"><span id="totalPrice">${totalPrice }</span></td>
								</tr>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
				</dl>
				
				<p class="p_paragraph_title">
					<b>客人名单</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="2%">序号<i class="w_table_split"></i></th>
										<th width="5%">姓名<i class="w_table_split"></i></th>
										<th width="5%">性别<i class="w_table_split"></i></th>
										<th width="5%">年龄<i class="w_table_split"></i></th>
										<th width="10%">籍贯<i class="w_table_split"></i></th>
										<th width="5%">职业<i class="w_table_split"></i></th>
										<th width="8%">类别<i class="w_table_split"></i></th>
										<th width="8%">证件类型<i class="w_table_split"></i></th>
										<th width="12%">证件号码<i class="w_table_split"></i></th>
										<th width="10%">手机号码<i class="w_table_split"></i></th>
										<th width="8%">是否单房<i class="w_table_split"></i></th>
										<th width="8%">是否领队<i class="w_table_split"></i></th>
										<th width="8%">备注<i class="w_table_split"></i></th>
										<th width="3%"><a href="javascript:;"
											onclick="addGuest('newGuest');" class="def">增加</a></th>
									</tr>
								</thead>
								<tbody id="newGuestData">
									<c:forEach items="${vo.groupOrderGuestList}" var="guest"
										varStatus="index">
										<tr  <c:if test="${!guest.editType }"> title="该客人已订机票,姓名、身份证号码不可修改" </c:if>>
											<td>${index.count}<input type="hidden"
												name="groupOrderGuestList[${index.index}].id"
												value="${guest.id}" />
											</td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].name" data-rule-required="true"
												value="${guest.name }" style="width: 50px" <c:if test="${!guest.editType }"> readonly="readonly" </c:if>/></td>
											<td><input type="radio"
												name="groupOrderGuestList[${index.index}].gender" value="1"
												<c:if test="${guest.gender==1 }">checked="checked"</c:if> />男
												<input type="radio"
												name="groupOrderGuestList[${index.index}].gender" value="0"
												<c:if test="${guest.gender==0 }">checked="checked"</c:if> />女

											</td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].age"
												value="${guest.age }" onblur="changeType(${index.index})"  style="width: 50px" /></td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].nativePlace"
												value="${guest.nativePlace }" style="width: 120px" /></td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].career"
												value="${guest.career }" style="width: 50px" /></td>
											<td><select
												name="groupOrderGuestList[${index.index}].type"
												style="width: 80px">
													<option value="1"
														<c:if test="${guest.type==1 }">selected="selected"</c:if>>成人</option>
													<option value="2"
														<c:if test="${guest.type==2 }">selected="selected"</c:if>>儿童</option>
													<option value="3"
														<c:if test="${guest.type==3 }">selected="selected"</c:if>>全陪</option>
											</select></td>
											<td><select id="certificateTypeId"
												name="groupOrderGuestList[${index.index}].certificateTypeId"
												style="width: 80px" onchange="recCertifNum(${index.index})">
													<c:forEach items="${zjlxList}" var="v" varStatus="vs">
														<option id="it" value="${v.id}"
															<c:if test="${guest.certificateTypeId==v.id }">selected="selected"</c:if>>${v.value}</option>
													</c:forEach>
											</select></td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].certificateNum" 
												class="certificateNum" value="${guest.certificateNum }"
												onblur="recCertifNum(${index.index})" style="width: 140px" <c:if test="${!guest.editType }"> readonly="readonly" </c:if>/>
											</td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].mobile"
												value="${guest.mobile }" style="width: 100px" /></td>

											<td><input type="radio"
												name="groupOrderGuestList[${index.index}].isSingleRoom"
												value="1"
												<c:if test="${guest.isSingleRoom==1 }">checked="checked"</c:if>>是</input>
												<input type="radio"
												name="groupOrderGuestList[${index.index}].isSingleRoom"
												value="0"
												<c:if test="${guest.isSingleRoom==0 }">checked="checked"</c:if>>否</input>
											</td>
											<td><input type="radio"
												name="groupOrderGuestList[${index.index}].isLeader"
												value="1"
												<c:if test="${guest.isLeader==1 }">checked="checked"</c:if>>是</input>
												<input type="radio"
												name="groupOrderGuestList[${index.index}].isLeader"
												value="0"
												<c:if test="${guest.isLeader==0 }">checked="checked"</c:if>>否</input>
											</td>
											<td><input style="width: 100px" type="text"
												name="groupOrderGuestList[${index.index}].remark"
												placeholder="备注" value="${guest.remark }" /></td>
											<td>
												<c:if test="${guest.editType }">
											<a href="javascript:void(0);"
												onclick="delGuestTable(this,'newGuest')">删除</a>
												</c:if></td>
										</tr>
									</c:forEach>


								</tbody>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
					<div style="margin-left: 6%;margin-bottom:50px;margin-top: 5px;">
						<input type="hidden" id="certificateNum" />
							<button type="button" class="button button-primary button-small p">文本导入</button>
							<button type="button" class="button button-primary button-small" onclick="textImport()">excel导入</button>
						</br></br>
						<div id="bi" style="display: none;">
							<div>
								<textarea class="w_textarea" name="batchInputText" value=""
									id="batchInputText" placeholder="姓名, 证件号码, 手机号  或者   姓名, 证件号码"
									></textarea>
							</div>
							<div style="margin-top: 20px;">
								<a href="javascript:void(0);" onclick="toSubmit('newGuest')"
									class="button button-primary button-small">导入</a> <span>
									<i class="red"> 格式 ：姓名,证件号码,手机号 </i>
								</span>
							</div>
						</div>
					</div>
				</dl>
				
				
				<p class="p_paragraph_title">
					<b>行程列表</b>
				</p>
				<dl class="p_paragraph_content">
					<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="10%">天数<i class="w_table_split"></i></th>
										<th width="15%">交通<i class="w_table_split"></i></th>
										<th width="45%">行程描述<i class="w_table_split"></i></th>
										<th width="10%">用餐住宿<i class="w_table_split"></i></th>
										<th width="10%">商家列表<i class="w_table_split"></i></th>
										<th width="10%">图片集<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody class="day_content">

								</tbody>
							</table>
							<div  id="addBtn">
								<button type="button" class="proAdd_btn button button-action button-small">增加</button>
							</div>

						</div>
					</dd>
					<div class="clear"></div>
					<dd>
						<div class="dd_left">服务标准</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="groupOrder.serviceStandard" id="serviceStandard"
								placeholder="服务标准">${vo.groupOrder.serviceStandard}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">备注</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="groupOrder.remark" id="remark"
								placeholder="备注">${vo.groupOrder.remark }</textarea>
						</div>
						<p>
							<a href="javascript:void(0)" onclick="taobao_PorcessSellerMemo('remark','')">提取</a>
						</p>
						<div class="clear"></div>
					</dd>
					<dd style="display:none">
						<div class="dd_left">内部备注</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="groupOrder.remarkInternal"
								placeholder="备注">${vo.groupOrder.remarkInternal }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					
					<c:if test="${vo.groupOrder.groupId >0}">
					<p class="p_paragraph_title">
					<b>计调操作</b>
				</p>
				<div style="margin-left: 6%">
						</br>
				<a class="button button-primary button-small"href="javascript:void(0)"onclick="newWindow('新增安排','<%=ctx %>/booking/AYToAddSight?groupId=${vo.groupOrder.groupId }&orderId=${vo.groupOrder.id}')">新增安排</a>
				<a class="button button-primary button-small"  href="javascript:void(0)" onclick="newWindow('新增地接社','<%=ctx %>/booking/AYDelivery.htm?gid=${vo.groupOrder.groupId }&orderId=${vo.groupOrder.id}')">新增地接社</a>
				<a class="button button-primary button-small"  href="javascript:void(0)" onclick="F5()">刷新</a>
				<a class="button button-primary button-small"  href="javascript:void(0)" onclick="printInsure(${vo.groupOrder.groupId})">打印投保单</a>
				</div>
							<dd>
							<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
						<dl class="p_paragraph_content">
					<table cellspacing="0" cellpadding="0" class="w_table">
						<%-- <col width="10%" /> --%>
						<col width="10%" />
						<col width="" />
						<col width="15%" />
						<col width="10%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<col width="8%" />
						<thead>
							<tr>
								<th>商家类别</th>
								<th>商家</th>
								<th>价格明细(单价*人数)</th>
								<th>支出金额</th>
								<th>收入金额</th>
								<th>已结</th>
								<th>未结</th>
								<th>操作员</th>
								<th>备注</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${bookingInfo.bookingList  }" var="booking">
								<tr <c:if test="${booking.stateFinance==1}">style="color:red"</c:if>>
									<td><c:if test="${booking.supplierType==3}">酒店</c:if> <c:if test="${booking.supplierType==2}">餐厅</c:if> <c:if test="${booking.supplierType==5}">景区</c:if>
									<c:if test="${booking.supplierType==15}">保险</c:if><c:if test="${booking.supplierType==9}">机票</c:if><c:if test="${booking.supplierType==120}">其他收入</c:if>
									<c:if test="${booking.supplierType==121}">其他支出</c:if></td>
									<td style="text-align: left">${booking.supplierName }</td>
									<td>数量：${booking.detailList[0].itemNum }&nbsp;&nbsp;&nbsp;&nbsp;价格：${booking.detailList[0].itemPrice }</td>
											<td><c:choose>
											<c:when test="${booking.total eq null  }">0</c:when>
											<c:when test="${booking.supplierType==120}">0</c:when>
											<c:otherwise>
												<fmt:formatNumber value="${booking.total }" pattern="#.##"
													type="currency" />
											</c:otherwise>
										</c:choose></td>
										<td><c:choose>
											<c:when test="${booking.total eq null  }">0</c:when>
											<c:when test="${booking.supplierType==120}"><fmt:formatNumber value="${booking.total }" pattern="#.##"
													type="currency" /></c:when>
											<c:otherwise>0</c:otherwise>
										</c:choose></td>
											<td><c:choose>
											<c:when test="${booking.totalCash eq null  }">0</c:when>
											<c:otherwise>
												<fmt:formatNumber value="${booking.totalCash }" pattern="#.##"
													type="currency" />
											</c:otherwise>
										</c:choose></td>
										<td><fmt:formatNumber value="${booking.total - booking.totalCash}" pattern="#.##" type="currency" /></td>
									<td>${booking.userName }</td>
										<td>${booking.remark } </td>
									<td>
										<div class="tab-operate">
											<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
											<div class="btn-hide" id="asd">	
											<a class="def" href="javascript:void(0)"  onclick="toPreview1(${booking.id})">打印</a>
											<a class="def" href="javascript:void(0)"
											onclick="newWindow('查看预定安排','<%=staticPath %>/booking/AYToAddSight.do?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId }&orderId=${vo.groupOrder.id}&see=1')">查看</a>
												<c:if test="${booking.stateFinance==null || booking.stateFinance==0}">
												<a class="def" href="javascript:void(0)"
													onclick="newWindow('修改订单','<%=staticPath %>/booking/AYToAddSight?groupId=${booking.groupId }&bookingId=${booking.id}&supplierId=${booking.supplierId}&orderId=${vo.groupOrder.id}')">修改</a>
											<a class="def" href="javascript:void(0)"
													onclick="del(this,'${booking.id}','${booking.supplierType}')">删除</a> 
													</c:if>
											</div>
										</div>
									</td>
								</tr>
								<c:if test="${booking.supplierType!=120}">
								<c:set var="sum_price" value="${sum_price+booking.total}" />
								</c:if>
								<c:if test="${booking.supplierType==120}">
								<c:set var="sum_income" value="${sum_income+booking.total}" />
								</c:if>
								<c:set var="sum_totalCash" value="${sum_totalCash+booking.totalCash}" />
								<c:set var="sum_blan" value="${sum_price-sum_totalCash}" />
							</c:forEach>
							<c:forEach items="${bdList}" var="info">
								<tr <c:if test="${info.stateFinance==1}">style="color:red"</c:if>>
								<td>地接社</td>
								<td style="text-align: left">${info.supplierName}</td>
								<td>
          					<c:if test="${info.priceList!=null and fn:length(info.priceList)>0 }">
          						<table class="in_table">
          						<col width="30%" /><col width="40%" /><col width="30%" />
          							<c:forEach var="price" items="${info.priceList }">
          								<tr>
          									<td>
          										单价<fmt:formatNumber value="${price.unitPrice }" pattern="#.##" type="currency"/>*
          										人数<fmt:formatNumber value="${price.numPerson }" pattern="#.##" type="currency"/>
          									</td>
          								</tr>
	          						</c:forEach>
          						</table>
          					</c:if>
          				</td>
								<td> 
								<c:choose>
          						<c:when test="${ info.total eq null}">0</c:when>
          						<c:otherwise> 
          						<fmt:formatNumber value="${info.total}" pattern="#.##" type="currency"/>
          						 </c:otherwise>
          					</c:choose> </td>
          					<td>0</td>
								<td><c:choose>
          						<c:when test="${ info.totalCash eq null}">0</c:when>
          						<c:otherwise>
          						<fmt:formatNumber value="${info.totalCash}" pattern="#.##" type="currency"/>
          						 </c:otherwise>
          					</c:choose> </td>
								<td><fmt:formatNumber value="${info.total-info.totalCash}" pattern="#.##" type="currency"/></td>
								<td>${info.userName }</td>
								<td>${info.priceList[0].remark }</td>
								<td><div class="tab-operate">
						<a href="javascript:void(0);" class="btn-show">操作<span class="caret"></span></a>
						<div class="btn-hide" id="asd">						
							<a class="def" href="javascript:void(0)" onclick="newWindow('查看下接社订单','<%=staticPath %>/booking/AYDelivery.htm?gid=${info.groupId }&bid=${info.id}&see=1')">查看</a>
							<c:if test="${info.stateFinance==null || info.stateFinance==0}">
								<a class="def" href="javascript:void(0)" onclick="newWindow('修改下接社订单','<%=staticPath %>/booking/AYDelivery.htm?gid=${info.groupId }&bid=${info.id}&orderId=${vo.groupOrder.id}')">修改</a>
				         		<a class="def" href="javascript:void(0)" onclick="agencyDelete(this,${info.id })">删除</a></c:if>
				         		<a class="def" href="javascript:void(0)"  onclick="toPreview(${info.id})">打印</a>
	         			</div>
					</div></td>
								</tr>
								<c:set var="sum_price1" value="${sum_price1+info.total}" />
								<c:set var="sum_totalCash1" value="${sum_totalCash1+info.totalCash}" />
								<c:set var="sum_blan1" value="${sum_price1-sum_totalCash1}" />
								</c:forEach>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3" style="text-align: right">合计</td>
								<td><fmt:formatNumber value="${sum_price+sum_price1 }" pattern="#.##" type="currency" /></td>
								<td><fmt:formatNumber value="${sum_income }" pattern="#.##" type="currency" /></td>
										<td><fmt:formatNumber value="${sum_totalCash+sum_totalCash1 }" pattern="#.##" type="currency" /></td>
										<td><fmt:formatNumber value="${sum_blan + sum_blan1}" pattern="#.##" type="currency" /></td>
								<td colspan="3"></td>
							</tr>
						</tfoot>
					</table>
				</dl>
							</div>
					</dd>
					</br>
							<dd>
						<div class="dd_left">
							<span class="btnTianjia"><i></i>&nbsp;&nbsp;</span>
						</div>
						<div class="dd_right" style="width: 90%">
							<table cellspacing="0" cellpadding="0" class="w_table">
								<thead>
									<tr>
										<th width="20%">团号<i class="w_table_split"></i></th>
										<th width="20%">计调<i class="w_table_split"></i></th>
										<th width="20%">收入<i class="w_table_split"></i></th>
										<th width="20%">支出<i class="w_table_split"></i></th>
										<th width="20%">利润<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody >
								<tr>
								<td>${tg.groupCode}</td>
								<td>${tg.operatorName}</td>
								<td><fmt:formatNumber value="${tg.totalIncome}" pattern="#.##" type="currency" /></td>
								<td><fmt:formatNumber value="${tg.totalCost}" pattern="#.##" type="currency" /></td>
								<td><fmt:formatNumber value="${tg.totalIncome-tg.totalCost}" pattern="#.##" type="currency" /></td>
								</tr>
								</tbody>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
					</br>
					</br>
				</c:if>
				</dl>	
				<c:set var="totalPerson" value="${vo.groupOrder.numChild+vo.groupOrder.numAdult}" />
				<input type="hidden" name="totalPerson" id="totalPerson"value="${totalPerson}" />
				<input type="hidden" name="totalPerson_adult" id="totalPerson_adult"value="${vo.groupOrder.numAdult}" /> 
				<input type="hidden" name="totalPerson_child" id="totalPerson_child"value="${vo.groupOrder.numChild}" /> 
				
				<input type="hidden" name="allowNum"   id="allowNum" value="${allowNum}" />
				<input type="hidden" name="see"   id="see" value="${see}" />
				<input type="hidden" name="groupOrder.aiyouGroupId"   value="-1" />
				<input type="hidden" name="ids"  id="ids" value="${tbIds}" />
				<input type="hidden" name="id"  id="id" />
				<input type="hidden" name="groupOrder.orderBusiness"  id="orderBusiness"value="${vo.groupOrder.orderBusiness}"/>
				<az></az>
				<div class="Footer" style="position:fixed;bottom:0px; right:0px; background-color: rgba(58,128,128,0.7);width: 100%;padding-bottom: 4px;margin-bottom:0px; text-align: center;">
				    <c:if test="${see !=0 }">
						<button type="submit" class="button button-primary button-small">保存</button>
						<button type="button" onclick="importTaobaoOrder()" class="button button-primary button-small">淘宝订单导入</button>
			        </c:if>
			        <c:if test="${vo.groupOrder.id != null }">
                     <button class="button button-primary button-small" type="button" onclick="saveMsg();">发送消息</button>
                     <c:if test="${(see ==null || see ==1) && vo.groupOrder.orderLockState == 0 }">
                    <button class="button button-primary button-small" type="button" onclick="changeorderLockState(${vo.groupOrder.id})">提交给计调</button>
                    </c:if>
                     <c:if test="${see ==2 && vo.groupOrder.orderLockState ne 0}">
                    <c:if test="${vo.groupOrder.orderLockState == 1}">
                    <button class="button button-primary button-small" type="button" onclick="changeorderLockStateByOp(${vo.groupOrder.id})">确认接收</button>
                    </c:if>
                    <button class="button button-primary button-small" type="button" onclick="goBackOrderLockStateByOp(${vo.groupOrder.id})">退回</button>
                      <c:if test="${vo.groupOrder.groupId !=null && vo.groupOrder.orderLockState == 2}">
                    <c:if test="${SH}">
                    <button class="button button-primary button-small" type="button" onclick="newWindow('结算单详情', '<%=staticPath%>/finance/auditGroup.htm?groupId=${vo.groupOrder.groupId}')">审核</button>
                    </c:if>
                    </c:if>
                    </c:if>
                     </c:if>
				</div>
			</form>
			<div id="fileUpload" style="display: none">
				<form id="uploadForm" method="post" action="" enctype="multipart/form-data">
					 <table align="center">
					  <tr>
					  	<td>
					  		<br/><br/><br/>
					  		<button type="button" onclick="modelDownLoad()">模板下载</button>
					  		<br/><br/><br/>
						  	上传文件：<input name="file" type="file" size="20">
						  	<br/><br/><br/>
						  	<input type="submit" name="submit" value="提交" >
	    					<input type="reset" name="reset" value="重置" >
					  	</td>
					  </tr>    
					 </table>
				</form>
			</div>
		</div>
	</div>

<script type ="text/javascript">
    function pickedFunc(){
        var departureDate=$("#groupOrder_departureDate").val();
        var dateEnd=$dp.cal.getDateStr("yyyy-MM-dd");
        var days=DateDiff(departureDate,dateEnd);
        $(".day_content").html('');
        for(var i = 0; i <= days; i++){
            $('.proAdd_btn').click();
        }

    }

    //计算天数差的函数，通用
    function  DateDiff(sDate1,  sDate2){    //sDate1和sDate2是2006-12-18格式
        var  aDate,  oDate1,  oDate2,  iDays
        aDate  =  sDate1.split("-")
        oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])    //转换为12-18-2006格式
        aDate  =  sDate2.split("-")
        oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0])
        iDays  =  parseInt(Math.abs(oDate1  -  oDate2)  /  1000  /  60  /  60  /24)    //把相差的毫秒数转换为天数
        return  iDays
    }
    function F5(){
	location.reload();
}

function toPreview(bookingId,type){
	if(!type){type=1;}
	window.open("../booking/deliveryDetailPreview.htm?bookingId="+bookingId+"&type="+type+"&preview=1");
	
}
function toPreview1(bookingId){
	window.open("../booking/bookingDetailPreview.htm?bookingId="+bookingId);
}
/* 加载页面时获取业务类别的值 */
$(function(){
	//默认组团社为【淘宝】
	if ($("#supplierId").val()=='' || $("#supplierId").val()=='0'){
		$("#supplierName").val('淘宝');
		$("#supplierName_t").val('淘宝');
		$("#supplierId").val('2490');
	}
	
	var orderMode = $("#orderMode").val();
	
	if(orderMode==1476){
		$('#wuliu_id').append('<a href="javascript:void(0);" id="addVisaId">物流</a>');
		$("#wuliu_id").on("click","a", function() {
			 var orderId = $("#orderId").val();
			if(orderId != ""){
				var bookingDateId = $("#bookingDateId").val();
			    var orderMode = $("#orderMode").val();
			    //alert("orderMode="+orderMode);
			   
			    
			    layer.open({
			  		type : 2,
			  		title : '新增签证信息',
			  		shadeClose : true,
			  		shade : 0.5,
			  		area: ['600px', '230px'],
			  		content: '<%=path%>/taobao/visa.htm?orderMode='+orderMode+'&orderId='+orderId+'&bookingDate='+bookingDateId
			  	});
			}else{
				$.error("请先保存信息！");
			}
			
		  
		});
	  }else{
		  $('#wuliu_id a').remove();
	  };
})
function orderModeChange(){
	/* 点击业务类别时获取选中的值，并添加点击事件 */
	var orderMode = $("#orderMode").val();
	if(orderMode==1476){
		$('#wuliu_id').append('<a href="javascript:void(0);" id="addVisaId">物流</a>');
		$("#wuliu_id").on("click","a", function() {
	    var orderId = $("#orderId").val();
	    if(orderId != ""){
			var bookingDateId = $("#bookingDateId").val();
		    var orderMode = $("#orderMode").val();
		    //alert("orderMode="+orderMode);
		    layer.open({
		  		type : 2,
		  		title : '新增签证信息',
		  		shadeClose : true,
		  		shade : 0.5,
		  		area: ['600px', '230px'],
		  		content: '<%=path%>/taobao/visa.htm?orderMode='+orderMode+'&orderId='+orderId+'&bookingDate='+bookingDateId
		  	});
	    }else{
			$.error("请先保存信息！");
		}
	 });
	  }else{
		  $('#wuliu_id a').remove();
	  }
	//通过 【业务类别】下拉框（字典设置的规则 yihg_erp_basic.sys_dic.type_code='SALES_TEAM_TYPE' 的note字段）满足业务需求
	//note字段信息 绑定在#orderMode的lang里
	var lang = $("#orderMode").find("option:selected").attr("lang");
    var curOrgId = '${OrgId}';
	<c:if test="${vo.groupOrder.id == null }">
    if (lang != ''){
        if(lang.indexOf(curOrgId+'@SK,')!=-1){
            $("input[name='groupOrder.orderType']").get(1).checked=true;
        }else{
            $("input[name='groupOrder.orderType']").get(0).checked=true;
        }


        //默认操作计调
        if(lang.indexOf('$')!=-1){
            var ary = lang.split(',');
            for(var i=0; i<ary.length; i++){
                if (ary[i].indexOf('$') != -1){
                    var opAry = ary[i].split('$');
                    for (var j=0; j<opAry.length; j ++){
                        var idAry = opAry[j].split('@');
                        if (idAry[0] == curOrgId){
                            $("#operatorName").val(idAry[1]);
                            $("#operatorId").val(idAry[2]);
                        }
                    }

                }
            }
        }
    }
	</c:if>
	//若业务类别：长线，要求保存时，检查接送信息至少有一行！
	if(lang.indexOf('REQUIRE_TRAFFIC,')!=-1){
		$("#requireTraffic").val("1");
	}else{
		$("#requireTraffic").val("0");
	}
}
function importTaobaoOrder(){
	layer.open({
		type : 2,
		title : '淘宝订单导入',
		shadeClose : true,
		shade : 0.5,
		area: ['1100px', '650px'],
		content: "import_taobaoOrder.htm"
	});
}

$(document).ready(function(){
	var salesRoute = new SalesRoute();
	if ($("#orderId").val() == '' && $("#groupOrder_departureDate").val()==''){
		$("#groupOrder_departureDate").val($.currentDay());
		salesRoute.dayAdd();
	}
    if ($("#orderId").val() == '' && $("#groupOrder_dateEnd").val()==''){
        $("#groupOrder_dateEnd").val($.currentDay());
    }
	
	var taobaoIds = $("#ids").val();
	 loadTaobaoDataAjax(taobaoIds, "");
	 
		//从原始单直接点击新增
		var originalIds='${retVal}';
		if (originalIds != ''){
			$("#ids").val(originalIds);
			 loadTaobaoDataAjax(originalIds, "import");
		}
});

	
	
function remove_tbRow(obj){
	//从窗口移除
	var id = $(obj).closest("table[class*='tbDataRow']").find("#tbdata_id").val();
	$(obj).closest("table").remove();
	 
	//ids元素处理
	 var ids = $("#ids").val().split(',');
	 var pos = jQuery.inArray(id, ids);
	 if (pos != -1){
		 ids.splice(pos, 1); 
	 }
	 $("#ids").val(ids.join(','));
	 $("az").append(id).append(",");
	$("#id").val($("az").text());
	 //价格删除
	 //#newPriceData groupOrderPriceList[${index.index}].priceLockState

	 $priceRow_ele = $("#newPriceData").find("input[name*='.priceLockState'][value='"+id+"']");
	 var financeState =  $priceRow_ele.next().val();
	 if (financeState == 0){
		 	$priceRow_ele.closest("tr").remove();
		 	//重新计算合计
		 	var tag = 0, tmpTag='';
		 	$("input[name*='.unitPrice']").each(function(){
				tmpTag = $(this).attr("name").split('.')[0].split('[')[1];//取出下标 如groupOrderPriceList[1].itemId
				tag=tmpTag.substring(0, tmpTag.length-1);
		 	 });
		 	countTotalPrice(tag); //此方法在：taobaoOrderList.js
	 }
}
 
function loadTaobaoData(taobaoIdAry) {
	if (taobaoIdAry.length == 0) return;
	var Ids = taobaoIdAry.join(',');
	 loadTaobaoDataAjax(Ids, "import");

	 if ($("#ids").val() != ""){
		var origIdsAry = $("#ids").val().split(',');
		if (origIdsAry.length > 0){
			taobaoIdAry = taobaoIdAry.concat(origIdsAry);
			Ids = taobaoIdAry.join(',');
		}
	}
	$("#ids").val(Ids);
	
}

//扩展Date的format方法
Date.prototype.format = function (format) {
	var o = {
			"M+": this.getMonth() + 1,
			"d+": this.getDate(),
			"h+": this.getHours(),
			"m+": this.getMinutes(),
			"s+": this.getSeconds(),
			"q+": Math.floor((this.getMonth() + 3) / 3),
			"S": this.getMilliseconds()
			}
	if (/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}
	for (var k in o) {
		if (new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
		}
	}
	return format;
}
function getFormatDate(date, pattern) {
	if (date == undefined) {
		date = new Date();
	}
	
	if (pattern == undefined) {
		pattern = "yyyy-MM-dd hh:mm:ss";
	}
	
	return date.format(pattern);
}

function html_encode(str) {
    var s = "";
    if (str.length == 0) {
        return "";
    }
    
    s = str.replace(/</g, "&lt;");
    s = s.replace(/>/g, "&gt;");
  return s;   
}

function loadTaobaoDataAjax(ids, opType){
	//todo 通过ajax取淘宝订单数据
	//alert('loadTaobaoDataAjax');
	 $.ajax({
				  type : "post",
				  url : "<%=path%>/taobao/getTaobaoOrders.do",
				  data : {
					  ids:  "'"+ids+"'"
				  },
				  dataType : "json",
				  success : function(data){
					  if (data.length == 0) return;
					  var templateStr = "", templateRow = "";
					  for(var i=0;  i<data.length;  i++){
						  templateRow = $("#template_taobao").html(); 
						  	templateRow = templateRow.replace("$id", data[i].id);
						  	templateRow = templateRow.replace("$id", data[i].id);
						  	templateRow = templateRow.replace("$id", data[i].id);
						  	templateRow = templateRow.replace("$title", data[i].title);
						  	templateRow = templateRow.replace("$skuPropertiesName", data[i].skuPropertiesName);
                          templateRow = templateRow.replace("$skuPropertiesName", data[i].skuPropertiesName);
						  	templateRow = templateRow.replace("$tid", data[i].tid);
						  	templateRow = templateRow.replace("$tid", data[i].tid);
						  	
						  	templateRow = templateRow.replace("$oid", data[i].oid);
						  	templateRow = templateRow.replace("$outerIid", data[i].outerIid);
						  	templateRow = templateRow.replace("$outerIid", data[i].outerIid);

						  	templateRow = templateRow.replace("$tradeFrom", data[i].tradeFrom);
						  	templateRow = templateRow.replace("$created", getFormatDate(new Date(data[i].created)));
						  	templateRow = templateRow.replace("$created", getFormatDate(new Date(data[i].created)));
						  	templateRow = templateRow.replace("$payTime", getFormatDate(new Date(data[i].payTime)));
						  	templateRow = templateRow.replace("$buyerNick", data[i].buyerNick);
						  	templateRow = templateRow.replace("$buyerNick", data[i].buyerNick);
						  	templateRow = templateRow.replace("$buyerNick", data[i].buyerNick);
						  	templateRow = templateRow.replace("$buyerAlipayNo", data[i].buyerAlipayNo);
						  	
						  	/* templateRow = templateRow.replace("$buyerRegion", data[i].buyerRegion); */
						  	templateRow = templateRow.replace("$buyerEmail", data[i].buyerEmail);
						  	
						  	templateRow = templateRow.replace("$price", data[i].price);
						  	templateRow = templateRow.replace("$num", data[i].num);
						  	templateRow = templateRow.replace("$payment", data[i].payment);
						  	templateRow = templateRow.replace("$payment", data[i].payment);
						  	
						  	templateRow = templateRow.replace("$receiverName", data[i].receiverName);
						  	templateRow = templateRow.replace("$receiverMobile", data[i].receiverMobile);
						  	templateRow = templateRow.replace("$receiverZip", data[i].receiverZip);
						  	
						  	templateRow = templateRow.replace("$receiverDistrict", data[i].receiverDistrict);
						  	templateRow = templateRow.replace("$receiverAddress", data[i].receiverAddress);
						  	templateRow = templateRow.replace("$buyerMemo", data[i].buyerMemo);
						  	templateRow = templateRow.replace("$sellerMemo", html_encode(data[i].sellerMemo));
						  	templateStr +=  templateRow;
						  	
						  	//插入价格
						  	if (opType=="import")
						  		addPrice(0,'newPrice',{priceLockState:data[i].id, unitPrice:data[i].payment, remark: data[i].oid+' '+data[i].title});
					  }
					  if ($("#tbData_Container table").text() == "")
					  		$("#tbData_Container").html(templateStr);
					  else
						  $("#tbData_Container").find("table:last").after(templateStr);
					  
					  
					  if ($(".switch").attr("lang") == "close" && opType=="import"){
						  $(".switch").click();
					  }
					  //导入后提取
					  if (opType == 'import')
					  	receiverMode_setValue();
				  },
				  error : function(data,msg){
					  alert('获取淘宝订单出错！+msg');
				  }
	});

}



//$("#showTradeDetail").val(obj);

</script>
	<script type="text/javascript">
	var index ;
	function textImport(){
		index = layer.open({
			type : 1,
			title : '导入Excel',
			shadeClose : true,
			shade : 0.5,
	        area : ['350px','280px'],
			content : $('#fileUpload')
		});
	}
	function modelDownLoad(){
		window.location = "<%=ctx%>/teamGroup/download.do" ;
	}
	
	var eKeyDown = $.Event('keydown');
	eKeyDown.keyCode = 40; // DOWN
	var contactNameComplete={
		  source: function( request, response ) {
			  var keyword = request.term;
			  var supplierId = contactNameComplete.supplierId.val();
			  $.ajax({
				  type : "post",
				  url : "<%=path%>/tourGroup/getContactName",
				  data : {
					  supplierId: supplierId,
					  keyword:keyword
				  },
				  dataType : "json",
				  success : function(data){
					  if(data && data.success == 'true'){
						  response($.map(data.result,function(v){
							  return {label:v.name,fax:v.fax,tel:v.tel,mobile:v.mobile};
						  }));
					  }
				  },
				  error : function(data,msg){}
			  });
		  },
		  focus: function(event, ui) {},
		  minLength : 0,
		  delay : 300
		
	};
	
	
	
	var supplierNameComplete={
			  source: function( request, response ) {
				  var keyword = request.term;
				  $.ajax({
					  type : "post",
					  url : "<%=path%>/tourGroup/getSupplierName",
					  data : {
						  supplierType : 1,
						  keyword:keyword
					  },
					  dataType : "json",
					  success : function(data){
						  if(data && data.success == 'true'){
							  response($.map(data.result,function(v){
								  return {label:v.nameFull,id:v.id};
							  }));
						  }
					  },
					  error : function(data,msg){}
				  });
			  },
			  focus: function(event, ui) {},
			  minLength : 0,
			  delay : 300
			
		};
	
	$(function(){
		//联系人
		contactNameComplete.supplierId = $("#supplierId");
		contactNameComplete.select = function(event, v){
			$("#contactName").val(v.item.label);
			$("#contactTel").val(v.item.tel);
			$("#contactFax").val(v.item.fax);
			$("#contactMobile").val(v.item.mobile);
			
		};
		$("#contactName").autocomplete(contactNameComplete);
		$("#contactName").click(function(){$(this).trigger(eKeyDown);});
		
		//组团社
		supplierNameComplete.select = function(event, v){
			$("#supplierName").val(v.item.label);
			$("#supplierName_t").val(v.item.label);
			$("#supplierId").val(v.item.id);
		};
		$("#supplierName").autocomplete(supplierNameComplete);
		$("#supplierName").click(function(){$(this).trigger(eKeyDown);});
		$("#supplierName_t").autocomplete(supplierNameComplete);
		$("#supplierName_t").click(function(){$(this).trigger(eKeyDown);});
		
		$("#groupOrder_departureDate").blur( function(){
			receiverMode_setDate();
		});
	});

function receiverMode_setDate(){
	var $receiverMode = $("#groupOrder_receiveMode");
	var departureDate = $("#groupOrder_departureDate").val();
	
	departureDate = departureDate.replace("-","");
	departureDate = departureDate.replace("-","");
	departureDate = departureDate.replace("-","");
	var receiverValue = $receiverMode.val() ;
	if (receiverValue.length ==0) {
		$receiverMode.val(departureDate);
	}
	else{
		if (receiverValue.length>=8){
			if (checkDate(receiverValue.substr(0,4)+"-"+receiverValue.substr(4,2)+"-"+receiverValue.substr(6,2))){
				$("#groupOrder_receiveMode").val(departureDate.substr(0,8)+receiverValue.substr(8));
			}
		}
	}
}
	
function receiverMode_setValue(){
	//alert('receiverMode_setValue');
	var ingoreStr = "差价", personNum =0;
	var $receiverMode = $("#groupOrder_receiveMode");
	var departureDate = $("#groupOrder_departureDate").val();
	var firstGuestName =  $("input[name='groupOrderGuestList[0].name").val();
	if (firstGuestName==undefined || firstGuestName== 'undefined' || firstGuestName==null)
		firstGuestName = "";
	
	var taobao_outerIid = "", taobao_sku = "";
	var taobao_buyerNick=$("#groupOrder_buyerNick").val();
	
	//产品赋值，默认为SKU
	//if ($("input[name='groupOrder.productName']").val()==''){
		var importTaobaoNum = $("input[name='taobao_outerIid']").length;
		var isIngore = true;
		$("input[name='taobao_outerIid']").each(function(){
			isIngore = (importTaobaoNum == 1);
			if (importTaobaoNum > 1)
			{
					isIngore = ($(this).val().indexOf(ingoreStr)==-1) ;
			}
			if (isIngore)
				personNum += parseInt($(this).closest("table").find("#taobao_num").text());
				if (taobao_outerIid=="") taobao_outerIid = $(this).val();
            if (taobao_sku == "") {
                taobao_sku =  $(this).closest("table").find("#taobao_sku").val();
                if (taobao_sku != ""){
                    var skuAry = taobao_sku.split(";")[0];
                    if (skuAry.indexOf('套餐类型') != -1)
                        taobao_sku = skuAry.split(":")[1];
                    else
                        taobao_sku = "";
                }
            }
				if (taobao_buyerNick=="")
					taobao_buyerNick =  $(this).closest("table").find("#taobao_buyerNick").val();
				else{
					if(taobao_buyerNick.indexOf($(this).closest("table").find("#taobao_buyerNick").val())) taobao_buyerNick =taobao_buyerNick+","+$(this).closest("table").find("#taobao_buyerNick").val();
				}
				if (firstGuestName == ""){
					var ary = taobao_getReceiveText( $(this).closest("table").find("span[id*='PicketMemo']").text());
					if (ary.length > 0) {
						firstGuestName=ary[1];
						departureDate = ary[0];
						 $("#groupOrder_departureDate").val(departureDate);
                        startDate=new Date(departureDate).getTime();
                        $(".day_content").html('');
                        $("#groupOrder_dateEnd").val($("#groupOrder_departureDate").val());
                        $('.proAdd_btn').click();
					}
				}
		});

		if (taobao_buyerNick != '') $("#groupOrder_buyerNick").val(taobao_buyerNick);

    if (taobao_sku != "")
        $("input[name='groupOrder.productName']").val(taobao_sku);
    else if (taobao_outerIid != '')
        $("input[name='groupOrder.productName']").val(taobao_outerIid);
    if (taobao_outerIid != '')
        $("input[name='groupOrder.productBrandName']").val(taobao_outerIid);
		if (personNum > 0) $("#groupOrder_numAdult").val(personNum);

		departureDate = departureDate.replace("-","");
		departureDate = departureDate.replace("-","");
		departureDate = departureDate.replace("-","");
		if (firstGuestName != '')
			$receiverMode.val(departureDate+firstGuestName);
	//}
	
	//客户单号，默认为淘宝单号
	if ($("input[name='groupOrder.supplierCode']").val()==''){
		var taobao_tid = "";
		$("#taobao_tid").each(function(){
			if (taobao_tid=="")
				taobao_tid = $(this).val();
		});
		$("input[name='groupOrder.supplierCode']").val(taobao_tid);
	}
	
	if ($("input[name='bookingDate']").val()==''){
		var booking_date = "";
		$("#bookingDateId").each(function(){
			if (booking_date=="")
				booking_date = $(this).val();
		});
		$("input[name='bookingDate']").val(booking_date);
	}
}
	
function checkDate(obj){
    // var strDate=obj.value;//获取对象的值
    re=/^(\d{4})(-|\/)(\d{2})\2(\d{2})$/g;//正则表达式
    if(re.test(obj))//判断日期格式符合YYYY-MM-DD
        return true;
	else
		return false;
}	
function showGuideList(obj){
	 var e = $.Event('keydown');
	 e.keyCode = 40; // DOWN
	 $(obj).trigger(e);
	}
$(function() {
	$("#uploadForm").validate({
		rules : {
		},
		errorPlacement : function(error, element) {
			if (element.is(':radio') || element.is(':checkbox')
					|| element.is(':input')) {
				error.appendTo(element.parent()); 
			} else {
				error.insertAfter(element);
			}
		},
		submitHandler : function(form) {
			var options = {
				url : "<%=ctx%>/teamGroup/upload.do",
				type : "post",
				dataType : "json",
				success : function(data) {
					var html = $("#guest_template").html();
					// 订单id
					if(data.success){
						var guestString = data.guestString ;
						if(!guestString||guestString.length==0){
		            		return;
		            	}
						guestString  = $.parseJSON(guestString) ; //json字符传处理
						// 比对当前输入人数是否定制团人数范围之内
						var numAdult =$("input[name='groupOrder.numAdult']").val();
						var numChild =$("input[name='groupOrder.numChild']").val();
						var numGuide =$("input[name='groupOrder.numGuide']").val();
						if(numAdult=='' ||numChild=='' || numGuide==''){
							$.warn("请先填写订单接纳人数！");
							return ;
						}
						if(isNaN(numAdult) || isNaN(numChild) || isNaN(numGuide)){
							$.warn("请正确填写订单容纳人数！");
							return ;
						}
						var count = $("#newGuestData").children('tr').length;
						if((Number(count)+Number(guestString.length))>(Number(numAdult)+Number(numChild)+Number(numGuide))){
							$.warn("超过该订单最大容纳人数！");
							return ;
						}
						var cerNum = "" ; //统计录入数据是否重复
		                for (var i = 0; i < guestString.length; i++) {
		            		if($("input[name='groupOrder.receiveMode']").val()==''){
								$("input[name='groupOrder.receiveMode']").val(guestString[i].name);
							}
		            		count = $("#newGuestData").children('tr').length;
		            		html = template('guest_template', {index : count});
							$("#newGuestData").append(html);
							$("input[name='groupOrderGuestList["+count+"].age']").change(
									function(e) {
								if($(this).val().trim()<12){
									$("select[name='groupOrderGuestList["+count+"].type").val("2");
								}else{
									$("select[name='groupOrderGuestList["+count+"].type").val("1");
								}
							});
							$("input[name='groupOrderGuestList["+count+"].name").val(guestString[i].name);
							var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
							var cer = guestString[i].certificateNum.trim() ;
							var tt ="";
							if (reg.test(cer) === true) {
								cer = cer.toUpperCase();
								tt = $.parseIDCard(cer);
								if(tt.tip==''){
									$("input[name='groupOrderGuestList["+count+"].age").val(tt.age);
									if(data.age<18){
										$("select[name='groupOrderGuestList["+count+"].type").val("2");
									}else{
										$("select[name='groupOrderGuestList["+count+"].type").val("1");
									}
									$("input[name='groupOrderGuestList["+count+"].nativePlace").val(tt.birthPlace);
									if(tt.gender=='男'){
										$("input[name='groupOrderGuestList["+count+"].gender'][value=1]").attr("checked", "checked");
									}else{
										$("input[name='groupOrderGuestList["+count+"].gender'][value=0]").attr("checked", "checked");
									}
									$("input[name='groupOrderGuestList["+count+"].certificateNum").val(guestString[i].certificateNum);
								}else{
									$("input[name='groupOrderGuestList["+count+"].certificateNum").val(guestString[i].certificateNum);
									$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
								}
							}else{
								$("input[name='groupOrderGuestList["+count+"].certificateNum").val(guestString[i].certificateNum);
								$("input[name='groupOrderGuestList["+count+"].certificateNum").after("<span style='color:red'></br>该证件号不是有效的身份证号！</span>");
							}
							$("input[name='groupOrderGuestList["+count+"].mobile").val(guestString[i].mobile);
							$("input[name='groupOrderGuestList["+count+"].remark").val(guestString[i].remark);
		                }
		                layer.close(index) ;
					}else{
						$.warn(data.msg);
					}
				},
				error : function(XMLHttpRequest, textStatus,
						errorThrown) {
					if($("#file").val()=='undefined'){
						$.warn('请选择您要上传的excel文件！', {
							icon : 5
						});
					}else{
						$.warn('服务忙，请稍后再试', {
							icon : 5
						});
					} ;
					
				}
			};
			$(form).ajaxSubmit(options);
		},
		invalidHandler : function(form, validator) { // 不通过回调
			return false;
		}
	});
	$(".bldd").each(function(){
		$(this).autocomplete({
			  source: function( request, response ) {
				  var name=encodeURIComponent(request.term);
				  $.ajax({
					  type : "get",
					  url : "<%=staticPath%>/route/getNameList.do",
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
function changeType(count){
	if($("input[name='groupOrderGuestList["+count+"].age']").val().trim()<12){
		$("select[name='groupOrderGuestList["+count+"].type").val("2");
	}else{
		$("select[name='groupOrderGuestList["+count+"].type").val("1");
	}
}
</script>
<script type="text/html" id="template_taobao">
<table class="tbDataRow gridtable">
	<input type="hidden" id="tbdata_id" value="$id" />
	<tr>
			<th colspan="3" class="line">$title</th><th style="text-align:right"><a href="javascript:void(0)" onclick="remove_tbRow(this)">移除</a></th>
	</tr>
	<tr>
		<th style="width:60px">主订单号</th><td  style="width:190px">$tid<input type="hidden" id="taobao_tid" value="$tid" /></td>
		<th style="width:60px">子订单号</th><td>$oid</td>
	</tr>
	<tr>
		<th>自编号</th><td>$outerIid<input type="hidden" name="taobao_outerIid" value="$outerIid" /></td>
		<th>购买来源</th><td>$tradeFrom</td>
	</tr>
	<tr>
		<th>下单时间</th><td>$created <input type="hidden" id="bookingDateId" value="$created" /></td>
		<th>购买时间</th><td>$payTime</td>
	</tr>
	<tr>
		<th>买家旺旺号</th><td>$buyerNick <input type="hidden" id="taobao_buyerNick" value="$buyerNick" /> </td>
		<th>支付宝账号</th><td>$buyerAlipayNo</td>
	</tr>
	<tr>
		<th>买家地区</th><td> </td>
		<th>买家邮箱</th><td>$buyerEmail</td>
	</tr>
	<tr>
		<th >SKU数据</th><td colspan="3">$skuPropertiesName <input type="hidden" id="taobao_sku" value="$skuPropertiesName" /></td>
	</tr>
	<tr>
		<th>商品单价</th><td>$price</td>
		<th>购买数量</th><td id="taobao_num">$num</td>
	</tr>
	<tr>
		<th>应付金额</th><td>$payment</td>
		<th>实付金额</th><td>$payment</td>
	</tr>
	<tr>
		<th>收货人姓名</th><td>$receiverName</td>
		<th>收货人电话</th><td>$receiverMobile</td>
	</tr>
	<tr>
		<th>收货人邮编</th><td>$receiverZip</td>
		<th>收货人地区</th><td>$receiverDistrict</td>
	</tr>
	<tr>
		<th>收货人地址</th><td colspan="3">$receiverAddress</td>
	</tr>
	<tr>
		<th>买家备注</th><td colspan="3">$buyerMemo</td>
	</tr>
	<tr>
		<th>卖家备注</br><a href="javascript:void(0)" id="aPicketMemo" onclick="taobao_PorcessSellerMemo('PicketMemo$id', '$buyerNick')">提取</a></th><td colspan="3"><span id="PicketMemo$id">$sellerMemo</span></td>
	</tr>

</table>
</script>
<div class="hoverBlock clearfix">
<div class="switch" lang="close"><</div>
<div class="container" id="tbData_Container">



</div>
</div>
<script type="text/javascript">

	function saveMsg() {
		var msg_title;
		var msg_info;
		var operatorName;
		var operatorIds;
		var orderId;
		layer.open({ 
	        type : 2,
	        title : '发送消息',
	        closeBtn : false,
	        area : [ '450px', '470px' ],
	        shadeClose : true,
	        content : '../msgInfo/showMsg.htm',
	        btn: ['确定', '取消'],
	        success:function(layero, index){
	            win = window[layero.find('iframe')[0]['name']];
	        	
	        	msg_title = win.$("#msg_title");
	            msg_info = win.$("#msg_info");
	            operatorName = win.$("#operatorName");
	            operatorIds = win.$("#operatorIds");
	            
	            msg_title.val($("#groupOrder_receiveMode").val());
	            orderId = $("#orderId");
	        },
	        yes: function(index){
	        	if(msg_title.val() == "") {
	        		layer.msg("消息标题不能为空！");
	        		return;
	        	} else if (msg_info.val() == "") {
	        		layer.msg("消息内容不能为空！");
	        		return;
	        	} else if (operatorName.val() == "") {
	        		layer.msg("接收人员不能为空！");
	        		return;
	        	}
	        	
	        	$.post(
	        			"../msgInfo/sendMsg.do", 
	        			{
	        			    orderId: orderId.val(),
	        				title: msg_title.val(),
	        				info: msg_info.val() ,
	        				ids: operatorIds.val(),
	        				names: operatorName.val(),
	        				msgType: 1
	        			}, function(data){
	        				if(data.success){
	        					layer.msg("发送成功！");
	        				}else{
	        					layer.msg("发送失败！");
	        				}
	        			},
	        	"json");
                
                layer.close(index);
	        },cancel: function(index){
	            layer.close(index);
	        }
	    });
	}
	
	function showMsgView(mid) {
		layer.open({ 
            type : 2,
            title : '消息详细',
            closeBtn : false,
            area : [ '400px', '300px' ],
            shadeClose : true,
            content : '../msgInfo/showMsgDetail.htm?mid='+mid,
            btn: ['关闭'],
            success:function(layero, index){
            	/* $.ajax({
                    type : "post",
                    url : "<%=staticPath%>/msgInfo/modifyStatus.do",
                    data : {
                        midId : mid
                    },
                    dataType : "json",
                    success : function(data){
                        if(data.success){
                            searchBtn();
                        }
                    },
                    error : function(data,msg){
                        layer.msg(msg);
                    }
                }); */
            },
            cancel: function(index){
                layer.close(index);
            }
        });
	}
	
	function del(obj,id,type){
		$.ajax({
			url:"<%=staticPath%>/booking/delBookingSupplier.do",
			type:"post",
			dataType:"json",
			async:false,
			data:{
				bookingId:id
			},
			success:function(data){
				if(data.success){
					$.successR("删除成功",function(){
						//$(obj).parent().parent().remove();
						location.reload();
					});
				}
				else{
					$.errorR(data.msg);
				}
			},
			error:function(){
				$.errorR("服务器忙，请稍后再试");
			}
		})	
	}
	
	function agencyDelete(obj,id){
		$.post("<%=staticPath%>/booking/agencyDelele.do",{id:id},function(data){
			if(data.success){
				$.successR('删除成功！',function(){
					$(obj).closest("tr").remove();					
				});
			}else{
				$.errorR(data.msg);
			}
		},"json");
	}
	
	function changeorderLockState(orderId){
		$.confirm("是否确认提交给计调？",  function(){
			$.getJSON("../taobao/changeOrderLockState.do?orderId=" + orderId, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						layer.close(stateIndex);
						location.reload();
					});
				}
			});
		}, function(){
		$.info('操作取消！');
		})
	}
	
	function goBackOrderLockStateByOp(orderId){
		$.confirm("是否确认退回？",  function(){
			$.getJSON("../taobao/goBackOrderLockStateByOp.do?orderId=" + orderId, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						layer.close(stateIndex);
						location.reload();
					});
				}
			});
		}, function(){
		$.info('操作取消！');
		})
	}
	
	function changeorderLockStateByOp(orderId){
		$.confirm("是否确认接收？",  function(){
			$.getJSON("../taobao/changeorderLockStateByOp.do?orderId=" + orderId, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						layer.close(stateIndex);
						location.reload();
					});
				}
			});
		}, function(){
		$.info('操作取消！');
		})
	}
	
	function printInsure(groupId){
		location.href="<%=ctx%>/tourGroup/downloadInsure.htm?groupId="+groupId ; //供应商确认订单 
		
	}
/* 	function updateLockStateToFinance(orderId){
		$.confirm("是否确认提交？",  function(){
			$.getJSON("../taobao/updateLockStateToFinance.do?orderId=" + orderId, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						layer.close(stateIndex);
						location.reload();
					});
				}
			});
		}, function(){
		$.info('操作取消！');
		})
	} */
	
	/* function goBackToOP(orderId){
		$.confirm("是否确认退回给计调？",  function(){
			$.getJSON("../taobao/goBackToOP.do?orderId=" + orderId, function(data) {
				if (data.success) {
					$.success('操作成功',function(){
						layer.close(stateIndex);
						location.reload();
					});
				}
			});
		}, function(){
		$.info('操作取消！');
		})
	} */
</script>
</body>
</html>

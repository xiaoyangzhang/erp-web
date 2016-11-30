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
<title>增加散客团</title>
<%@ include file="../../../include/top.jsp"%>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/card/native-info.js"></script>
<script type="text/javascript" src="<%=ctx%>/assets/js/card/card.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/agencyTeamGroup.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/changeAddShow.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/sales_route.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/teamGroupRoute.js"></script>
<script type="text/javascript"
	src="<%=ctx%>/assets/js/web-js/sales/orderLock.js"></script>
<link href="<%=ctx%>/assets/css/product/product_rote.css"
	rel="stylesheet" />
<style type="text/css">
.pp {
	font-family: "Arial Normal", "Arial";
	font-weight: 400;
	font-style: normal;
	font-size: 13px;
	cursor: pointer;
	color: #09F;
	text-align: left;
}

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
</style>
<script type="text/javascript">
		var path = '<%=ctx%>';
		var startDate='${teamGroupVO.groupOrder.departureDate}'==''?new Date().getTime():new Date('${teamGroupVO.groupOrder.departureDate}').getTime();
		var img200Url = '${config.images200Url}';
		var salesRoute;
		$(function(){
		    $(".l_textarea").autoTextarea({minHeight:50});
		});
		
		
</script>

<script type="text/javascript">
	
	function setRouteDate(obj){
		startDate=new Date($(obj).val()).getTime();
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

	
	function toRequirement(){
		if($("input[name='groupOrder.id']").val().trim()==""){
			$.warn("请先保存订单详情") ;
		}else{
			window.location = "../agencyTeam/toRequirement.htm?orderId=${teamGroupVO.groupOrder.id}&operType=${operType}&isSales=${reqpm.isSales}";
		}
	}
	
	function toTeamGroupInfo(){
		if($("input[name='groupOrder.id']").val().trim()==""){
			$.warn("请先保存订单详情") ;
		}else{
			window.location = "../agencyTeam/toEditTeamGroupInfo.htm?groupId=${teamGroupVO.tourGroup.id}&operType=${operType}&isSales=${reqpm.isSales}";
		}
	}
	
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/sales/template/orderTemplate.jsp"%>
	<%@ include file="/WEB-INF/views/sales/template/groupRouteTemplate.jsp"%>
	<div class="p_container">
		<ul class="w_tab">
			<li><a href="javascript:void(0);" onclick="toTeamGroupInfo()" class="selected">团队信息</a></li>
			<li><a href="javascript:void(0);" onclick="toRequirement()">计调需求</a></li>
			<li class="clear"></li>
		</ul>
		
		<div class="p_container_sub" id="tab1">
			<form id="teamGroupForm">
				<input id="agencyIsSales" value="${reqpm.isSales}" type="hidden"/>
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
					<tr>
						
						<td>团号：</td>
						<td>
							<input name="tourGroup.groupCode" value="${teamGroupVO.tourGroup.groupCode}" class="IptText300" placeholder="系统自动产生" readonly="readonly" type="text"></td>
						<td>团号标识：</td>
						<td>
							<input name="tourGroup.groupCodeMark" value="${teamGroupVO.tourGroup.groupCodeMark}" class="IptText300" placeholder="团号标识"  type="text"></td>
					</tr>
					<tr>
						<td><i class="red">* </i>出团日期 :</td>
						<td>
						<c:if test="${!isEdit}">
							<input type="text" name="groupOrder.departureDate" value="${teamGroupVO.groupOrder.departureDate }" class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd'})" onblur="setRouteDate(this)" />
						</c:if>
						<c:if test="${isEdit}">
							${teamGroupVO.groupOrder.departureDate }
							<input type="hidden" name="groupOrder.departureDate" value="${teamGroupVO.groupOrder.departureDate }"  />
						</c:if>
						
						</td>
						<td>类别：</td>
						<td>
							<input type="hidden" name="tourGroup.id" value="${teamGroupVO.tourGroup.id}" />
							<input type="hidden" name="groupOrder.id" value="${teamGroupVO.groupOrder.id }" />
							<select name="tourGroup.groupMode">
							<c:forEach items="${typeList}" var="v" varStatus="vs">
								<option value="${v.id}" <c:if test='${teamGroupVO.tourGroup.groupMode==v.id}'>selected='selected'</c:if>>${v.value}</option>
							</c:forEach>
							</select>
						</td>
						
					</tr>
					<tr>
						<td><i class="red">* </i>销售计调 :</td>
						<td>
							<input name="groupOrder.saleOperatorName" id="saleOperatorName" value="${teamGroupVO.groupOrder.saleOperatorName}" readonly="readonly" type="text"> 
							<c:if test="${operType==1}"><a href="javascript:void(0);" onclick="selectUser(1)">修改</a></c:if>
							<input type="hidden" name="groupOrder.saleOperatorId" id="saleOperatorId" value="${teamGroupVO.groupOrder.saleOperatorId}" />
						</td>
						<td><i class="red">* </i>操作计调:</td>
						<td>
							<input name="groupOrder.operatorName" id="operatorName" readonly="readonly" value="${teamGroupVO.groupOrder.operatorName}" type="text">
							<c:if test="${operType==1}"><a href="javascript:void(0);" onclick="selectUser(2)">修改</a></c:if>
							<input type="hidden" name="groupOrder.operatorId" id="operatorId" value="${teamGroupVO.groupOrder.operatorId}">
						</td>
					</tr>
					
					<tr>
						<td>客源类别：</td>
						<td>
							<input type="hidden" name="groupOrder.sourceTypeName" class="IptText300" id="sourceTypeName" value="${teamGroupVO.groupOrder.sourceTypeName }" />
							<select name="groupOrder.sourceTypeId" id="sourceTypeCode">
								<option value="-1">请选择</option>
								<c:forEach items="${sourceTypeList }" var="source">
									<option value="${source.id }"
										<c:if test="${source.id==teamGroupVO.groupOrder.sourceTypeId }"> selected="selected" </c:if>>${source.value}</option>
								</c:forEach>
							</select>
						</td>
						<td>客源地：</td>
						<td>
							<input type="hidden" name="groupOrder.provinceName" class="IptText300" id="provinceName" value="${teamGroupVO.groupOrder.provinceName }" /> 
							<select name="groupOrder.provinceId" id="provinceCode">
								<option value="-1">请选择省</option>
								<c:forEach items="${allProvince }" var="province">
									<option value="${province.id }"
										<c:if test="${province.id==teamGroupVO.groupOrder.provinceId }"> selected="selected" </c:if>>${province.name}</option>
								</c:forEach>
							</select> 
							<input type="hidden" name="groupOrder.cityName" class="IptText300" id="cityName" value="${teamGroupVO.groupOrder.cityName }" /> 
							<select name="groupOrder.cityId" id="cityCode">
								<option value="-1">请选择市</option>
								<c:forEach items="${allCity }" var="city">
									<option value="${city.id }"
										<c:if test="${city.id==teamGroupVO.groupOrder.cityId }"> selected="selected" </c:if>>${city.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td><i class="red">* </i>客户名称：</td>
						<td>
							<input type="hidden" name="groupOrder.supplierId" id="supplierId"  value="${teamGroupVO.groupOrder.supplierId }" />
							<input name="groupOrder.supplierName" id="supplierName" type="text" class="IptText300" value="${teamGroupVO.groupOrder.supplierName }" />
							<c:if test="${operType==1}"><a href="javascript:void(0)" onclick="selectSupplier();">请选择</a></c:if>
						</td>
						<td>客户团号：</td>
						<td>
							<input type="text" name="groupOrder.supplierCode" class="IptText300" placeholder="客户团号" value="${teamGroupVO.groupOrder.supplierCode }" />
						</td>
					</tr>
					<tr>
						<td>联系人/介绍人：</td>
						<td>
							<input type="text" name="groupOrder.contactName" id="contactName" class="IptText100" placeholder="姓名" value="${teamGroupVO.groupOrder.contactName }" />
							<input type="text" name="groupOrder.contactTel" id="contactTel" class="IptText100" placeholder="座机" value="${teamGroupVO.groupOrder.contactTel }" />
							<input type="text" name="groupOrder.contactMobile" id="contactMobile" class="IptText100" placeholder="手机" value="${teamGroupVO.groupOrder.contactMobile }" />
							<input type="text" name="groupOrder.contactFax" id="contactFax" class="IptText100" placeholder="传真" value="${teamGroupVO.groupOrder.contactFax} " />
							<c:if test="${operType==1}"><a href="javascript:void(0)" onclick="selectContact();">请选择</a></c:if>
						</td>
						<td><i class="red">* </i>团人数：</td>
						<td>
							<input style="width:50px;" type="text" name="groupOrder.numAdult" placeholder="成人数" value="${(empty teamGroupVO.groupOrder.numAdult)?0:teamGroupVO.groupOrder.numAdult}" />
							~
							<input style="width:50px;" type="text" name="groupOrder.numChild" placeholder="小孩数" value="${(empty teamGroupVO.groupOrder.numChild)?0:teamGroupVO.groupOrder.numChild}" />
							~
							<input style="width:50px;" type="text" name="groupOrder.numGuide" placeholder="全陪数" value="${(empty teamGroupVO.groupOrder.numGuide)?0:teamGroupVO.groupOrder.numGuide}" />
							(成人数~小孩数~全陪)
						</td>
					</tr>
					<tr>
						<td><i class="red">* </i>产品名称：</td>
						<td>
							<input type="hidden" name="groupOrder.productBrandId" value="${teamGroupVO.groupOrder.productBrandId }" />
							<input type="text" name="groupOrder.productBrandName" value="${teamGroupVO.groupOrder.productBrandName }" />
							~ 
							<input type="hidden" name="groupOrder.productId" id="productId" value="${teamGroupVO.groupOrder.productId }" />
							<input type="text" name="groupOrder.productName" value="${teamGroupVO.groupOrder.productName }" style="width: 300px" />
							<c:if test="${operType==1}"><a href="javascript:void(0)" onclick="importRoute();">选择产品</a></c:if>
						</td>
						<td><i class="red">* </i>客人信息:</td>
						<td>
							<input type="text" name="groupOrder.receiveMode" value="${teamGroupVO.groupOrder.receiveMode}"  class="IptText300" />
						</td>
					</tr>
					<c:if test="${operType==1 }">
					<tr>
						<td>全陪：</td>
						<td>${guideStr}</td>
						<td>客人来源</td>
						<td>
							<input type="hidden" name="groupOrder.guestSourceName" id="guestSourceName" value="${teamGroupVO.groupOrder.guestSourceName }" />
							<select name="groupOrder.guestSourceId" id="guestSourceId">
								<option value="">请选择</option>
								<c:forEach items="${guestSource}" var="source">
									<option value="${source.id }"
										<c:if test="${source.id==teamGroupVO.groupOrder.guestSourceId }"> selected="selected" </c:if>>${source.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					</c:if>
				</table>

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
							<c:if test="${operType==1}">
							<div>
								<button type="button" class="proAdd_btn button button-action button-small">增加</button>
							</div>
							</c:if>
						</div>
					</dd>
					<div class="clear"></div>
					<dd>
						<div class="dd_left">备注</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.remark" id="remark"
								placeholder="备注">${teamGroupVO.tourGroup.remark }</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">服务标准</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.serviceStandard" id="serviceStandard"
								placeholder="服务标准">${teamGroupVO.tourGroup.serviceStandard}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					<dd>
						<div class="dd_left">温馨提示</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.warmNotice" id="warmTip"
								placeholder="温馨提示">${teamGroupVO.tourGroup.warmNotice}</textarea>
						</div>
						<div class="clear"></div>
					</dd>
					
					<dd>
						<div class="dd_left">内部备注</div>
						<div class="dd_right">
							<textarea class="w_textarea" name="tourGroup.remarkInternal"
								placeholder="备注">${teamGroupVO.tourGroup.remarkInternal }</textarea>
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
										<c:if test="${operType==1}">
										<th width="5%">
										<a href="javascript:;" onclick="addTran('newTransport');" class="def">增加</a>
										</th>
										</c:if>
										
									</tr>
								</thead>
								<tbody id="newTransportData">
									<c:forEach items="${teamGroupVO.groupOrderTransportList }" var="trans"
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
											<c:if test="${operType==1}"><td><a href="javascript:void(0);"
												onclick="delTranTable(this,'newTransport')" class="def">删除</a></td></c:if>
										</tr>

									</c:forEach>


								</tbody>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
					<c:if test="${operType==1}">
					<div style="margin-left: 6%">
						<p class="pp">批量录入</p>
						</br> </br>
						<div id="bbb" style="display: none;">
							<div>
								<textarea class="l_textarea" name="bit" value="" id="bit"
									placeholder="出发日期,出发时间,航班号,出发城市,到达城市"
									style="width: 600px; height: 250px"></textarea>
							</div>
							<span>
								<i style="color: gray;"> 格式：出发日期,出发时间,航班号,出发城市,到达城市</i>
							</span>
							<div style="margin-top: 20px;">
								<a href="javascript:void(0);"
									onclick="toSaveSeatInCoach('newTransport')"
									class="button button-primary button-small">保存</a> <span>
									<i class="red"> 按照上面格式填写后提交即可，回车换行添加多人信息 </i>
								</span>
							</div>
						</div>
					</div>
					</c:if>
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
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;"
											onclick="addPrice(0,'newPrice');" class="def">增加</a></th></c:if>
									</tr>
								</thead>
								<tbody id="newPriceData">
									<c:forEach items="${teamGroupVO.groupOrderPriceList }" var="price"
										varStatus="index">
										<tr>
											<td>${index.count} <input type="hidden"
												name="groupOrderPriceList[${index.index}].id"
												value="${price.id}" />
											</td>
											<td><input type="hidden"
												name="groupOrderPriceList[${index.index}].itemName"
												value="${price.itemName}" /> <select <c:if test="${price.stateFinance==1 }"> disabled="disabled" </c:if>
												name="groupOrderPriceList[${index.index}].itemId"
												onchange="addItemName(this)">
													<c:forEach items="${lysfxmList}" var="lysfxm">
														<option value="${lysfxm.id}"
															<c:if test="${price.itemId==lysfxm.id }">selected="selected"</c:if>>${lysfxm.value }</option>
													</c:forEach>
											</select></td>
											<td><textarea class="l_textarea_mark"
													name="groupOrderPriceList[${index.index}].remark"
													placeholder="备注" <c:if test="${price.stateFinance==1 }"> style="width:80%;border-color: red" readonly="readonly" </c:if>>${price.remark }</textarea></td>
											<td><input style="width: 80%;<c:if test="${price.stateFinance==1 }">border-color: red </c:if>" <c:if test="${price.stateFinance==1 }">readonly="readonly" </c:if> type="text"
												name="groupOrderPriceList[${index.index}].unitPrice"
												placeholder="单价" onblur="countTotalPrice(${index.index})"
												value="${price.unitPrice }" /></td>
											<td><input style="width: 80%; <c:if test="${price.stateFinance==1 }">border-color: red </c:if>" type="text"
												name="groupOrderPriceList[${index.index}].numPerson"
												placeholder="人数" onblur="countTotalPrice(${index.index})"
												value="${price.numPerson }" <c:if test="${price.stateFinance==1 }">readonly="readonly" </c:if>/></td>
											<td><input style="width: 80%; <c:if test="${price.stateFinance==1 }">border-color: red </c:if>" type="text"
												name="groupOrderPriceList[${index.index}].numTimes"
												placeholder="次数" onblur="countTotalPrice(${index.index})"
												value="${price.numTimes }" <c:if test="${price.stateFinance==1 }">readonly="readonly" </c:if>/></td>
											
											<td><input style="width: 80%; <c:if test="${price.stateFinance==1 }">border-color: red </c:if>" type="text"
												name="groupOrderPriceList[${index.index}].totalPrice"
												placeholder="金额" readonly="readonly"
												value="<fmt:formatNumber value='${price.totalPrice }' type='currency' pattern='#.##' />" /></td>
											<c:if test="${operType==1}"><td>
											<c:if test="${price.stateFinance==0 }">
											<a href="javascript:void(0);" onclick="delPriceTable(this,'newPrice')">删除</a></td></c:if>
											</c:if>
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
					<b>预算成本</b>
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
										<c:if test="${operType==1}"><th width="5%"><a href="javascript:;"
											onclick="addCost(1,'newCost');" class="def">增加</a></th></c:if>
									</tr>
								</thead>
								<tbody id="newCostData">
									<c:forEach items="${teamGroupVO.groupOrderCostList }" var="cost"
										varStatus="index">
										<tr>
											<td>${index.count}<input type="hidden"
												name="groupOrderCostList[${index.index}].id"
												value="${cost.id}" />
											</td>
											<td><input type="hidden"
												name="groupOrderCostList[${index.index}].itemName"
												value="${cost.itemName }" /> <select
												name="groupOrderCostList[${index.index}].itemId"
												onchange="addItemName(this)">
													<c:forEach items="${lysfxmList}" var="lysfxm">
														<option value="${lysfxm.id}"
															<c:if test="${cost.itemId==lysfxm.id }">selected="selected"</c:if>>${lysfxm.value }</option>
													</c:forEach>
											</select></td>
											<td><textarea class="l_textarea_mark" style="width: 90%"
													name="groupOrderCostList[${index.index}].remark"
													placeholder="备注">${cost.remark }</textarea></td>
											<td><input style="width: 80%" type="text"
												name="groupOrderCostList[${index.index}].unitPrice"
												placeholder="单价" onblur="countTotalCost(${index.index})"
												value="${cost.unitPrice }" /></td>
											<td><input style="width: 80%" type="text"
												name="groupOrderCostList[${index.index}].numPerson"
												placeholder="人数" onblur="countTotalCost(${index.index})"
												value="${cost.numPerson }" /></td>
											<td><input style="width: 80%" type="text"
												name="groupOrderCostList[${index.index}].numTimes"
												placeholder="次数" onblur="countTotalCost(${index.index})"
												value="${cost.numTimes }" /></td>
											
											<td><input style="width: 80%" type="text"
												name="groupOrderCostList[${index.index}].totalPrice"
												placeholder="金额" readonly="readonly"
												value="<fmt:formatNumber value='${cost.totalPrice}' type='currency' pattern='#.##' />" /></td>
											<c:if test="${operType==1}"><td><a href="javascript:void(0);"
												onclick="delCostTable(this,'newCost')">删除</a></td></c:if>
										</tr>
										<c:set var="totalCost" value="${totalCost+cost.totalPrice }" />
									</c:forEach>


								</tbody>
								<tr>
									<td colspan="6" style="text-align: right">合计：</td>
									<td colspan="2" style="text-align: left"><span id="totalCost">${totalCost }</span></td>
								</tr>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
				</dl>
				<p class="p_paragraph_title">
					<b>收款信息</b>
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
										<th width="3%">序号<i class="w_table_split"></i></th>
										<th width="5%">发票号<i class="w_table_split"></i></th>
										<th>备注<i class="w_table_split"></i></th>
										<th width="10%">付款方式<i class="w_table_split"></i></th>
										<th width="10%">付款时间<i class="w_table_split"></i></th>
										<th width="8%">付款人<i class="w_table_split"></i></th>
										<th width="8%">金额<i class="w_table_split"></i></th>
										<th width="8%">收款人<i class="w_table_split"></i></th>
										<th width="8%">收款部门<i class="w_table_split"></i></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${payDetails}" var="item" varStatus="index">
										<tr>
											<td>${index.count}</td>
											<td>${item.pay_code }</td>
											<td>${item.remark }</td>
											<td>${item.pay_type }</td>
											<td>${item.create_time }</td>
											<td>${item.right_bank_holder }</td>
											<td>${item.cash }</td>
											<td>${item.user_name }</td>
											<td>${item.department }</td>
										</tr>
									</c:forEach>
								</tbody>
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
										<c:if test="${operType==1}"><th width="3%"><a href="javascript:;"
											onclick="addGuest('newGuest');" class="def">增加</a></th></c:if>
									</tr>
								</thead>
								<tbody id="newGuestData">
									<c:forEach items="${teamGroupVO.groupOrderGuestList}" var="guest"
										varStatus="index">
										<tr <c:if test="${!guest.editType }"> title="该客人已订机票,姓名、身份证号码不可修改" </c:if>>
											<td>${index.count}<input type="hidden"
												name="groupOrderGuestList[${index.index}].id"
												value="${guest.id}" />
											</td>
											<td><input type="text"
												name="groupOrderGuestList[${index.index}].name"
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
												value="${guest.age }" onblur="changeType(${index.index})" style="width: 50px" /></td>
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
												onblur="recCertifNum(${index.index})" style="width: 130px" <c:if test="${!guest.editType }"> readonly="readonly" </c:if>/>
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
											<c:if test="${operType==1}"><td>
											<c:if test="${guest.editType }">
											<a href="javascript:void(0);"
												onclick="delGuestTable(this,'newGuest')">删除</a>
												</c:if></td></c:if>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</dd>
					<div class="clear"></div>
					<c:if test="${operType==1}">
					<div style="margin-left: 6%;margin-bottom:50px;margin-top: 5px;">
						<input type="hidden" id="certificateNum" />
							<button type="button" class="p">文本导入</button>
							<button type="button" onclick="textImport()">excel导入</button>
						</br></br>
						<div id="bi" style="display: none;">
							<div>
								<textarea name="batchInputText" value=""
									id="batchInputText" placeholder="[姓名,证件号码,手机号]或者[姓名,证件号码]"
									style="width: 600px; height: 250px"></textarea>
							</div>
							<div style="margin-top: 20px;">
								<a href="javascript:void(0);" onclick="toSubmit('newGuest')"
									class="button button-primary button-small">导入</a> <span>
									<i class="red"> 按照上面格式填写后提交即可，回车换行添加多人信息 </i>
								</span>
							</div>
						</div>
					</div>
					</c:if>
				</dl>
				
				<div class="Footer" style="position:fixed;bottom:0px; right:0px; background-color: rgba(58,128,128,0.7);width:100%;margin-bottom:0px; text-align: center;">
						<c:if test="${operType==1}">
						<button type="submit" class="button button-primary button-small">保存</button>
						</c:if>
						
						<c:if test="${reqpm.isSales eq true}">
							<a class="button button-primary button-small" href="javascript:void(0);" 
								onclick="lockOrUnLock(${teamGroupVO.groupOrder.id},this)">
								<c:if test="${teamGroupVO.groupOrder.orderLockState==0}">锁单</c:if>
								<c:if test="${teamGroupVO.groupOrder.orderLockState==1}">解锁</c:if>
							</a>
						</c:if>
						
						<button type="button" class="button button-primary button-small" onclick="printOrder(${teamGroupVO.groupOrder.id},${teamGroupVO.tourGroup.groupState},${teamGroupVO.tourGroup.id})" >打印</button>
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
			$("#supplierId").val(v.item.id);
		};
		$("#supplierName").autocomplete(supplierNameComplete);
		$("#supplierName").click(function(){$(this).trigger(eKeyDown);});
		
		$("#guestSourceId").change(function(){
			if($("#guestSourceId").val()!=-1){
				$("#guestSourceName").val($("#guestSourceId option:selected").text());
			}else{
				$("#guestSourceName").val('');
			}
		});
	})
	
	
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
})
function changeType(count){
	if($("input[name='groupOrderGuestList["+count+"].age']").val().trim()<12){
		$("select[name='groupOrderGuestList["+count+"].type").val("2");
	}else{
		$("select[name='groupOrderGuestList["+count+"].type").val("1");
	}
}
</script>
<div id="exportWord" style="display: none;text-align: center;margin-top: 10px">
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleOrder" class="button button-primary button-small">确认单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleCharge" class="button button-primary button-small">结算单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleOrderNoRoute" class="button button-primary button-small">确认单-无行程</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="saleChargeNoRoute" class="button button-primary button-small">结算单-无行程</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="tddyd" class="button button-primary button-small">导游行程单</a>
		</div>
		<div style="margin-top: 10px">
			<a href="" target="_blank" id="guestNames" class="button button-primary button-small">客人名单</a>
		</div>
	</div>
</body>
</html>
